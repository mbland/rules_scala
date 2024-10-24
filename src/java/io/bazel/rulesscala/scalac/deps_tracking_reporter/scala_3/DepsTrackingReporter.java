package io.bazel.rulesscala.scalac.reporter;

import dotty.tools.dotc.core.*;
import dotty.tools.dotc.reporting.*;
import dotty.tools.dotc.util.NoSourcePosition$;
import io.bazel.rulesscala.deps.proto.ScalaDeps;
import io.bazel.rulesscala.deps.proto.ScalaDeps.Dependency;
import io.bazel.rulesscala.deps.proto.ScalaDeps.Dependency.Kind;
import io.bazel.rulesscala.scalac.compileoptions.CompileOptions;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.jar.JarFile;
import java.util.stream.Collectors;

public class DepsTrackingReporter extends BazelConsoleReporter {

  private static final String HJAR_JAR_SUFFIX = "-hjar.jar";
  private static final String IJAR_JAR_SUFFIX = "-ijar.jar";
  private final Set<String> usedJars = new HashSet<>();

  private final Map<String, String> jarToTarget = new HashMap<>();
  private final Map<String, String> indirectJarToTarget = new HashMap<>();

  private final Set<String> ignoredTargets;
  private final Set<String> directTargets;

  private final CompileOptions ops;
  public final Reporter delegateReporter;
  private Set<String> astUsedJars = new HashSet<>();

  public DepsTrackingReporter(CompileOptions ops, Reporter delegate) {
    super();
    this.ops = ops;
    this.delegateReporter = delegate;

    if (ops.directJars.length == ops.directTargets.length) {
      for (int i = 0; i < ops.directJars.length; i++) {
        jarToTarget.put(ops.directJars[i], ops.directTargets[i]);
      }
    } else {
      throw new IllegalArgumentException(
          "mismatched size: directJars " + ops.directJars.length + " vs directTargets"
              + ops.directTargets.length);
    }

    if (ops.indirectJars.length == ops.indirectTargets.length) {
      for (int i = 0; i < ops.indirectJars.length; i++) {
        indirectJarToTarget.put(ops.indirectJars[i], ops.indirectTargets[i]);
      }
    } else {
      throw new IllegalArgumentException(
          "mismatched size: indirectJars " + ops.directJars.length + " vs indirectTargets "
              + ops.directTargets.length);
    }

    ignoredTargets = Arrays.stream(ops.unusedDepsIgnoredTargets).collect(Collectors.toSet());
    directTargets = Arrays.stream(ops.directTargets).collect(Collectors.toSet());
  }

  private boolean isDependencyTrackingOn() {
    return "ast-plus".equals(ops.dependencyTrackingMethod)
        && (!"off".equals(ops.strictDepsMode) || !"off".equals(ops.unusedDependencyCheckerMode));
  }


  @Override
  public void doReport(Diagnostic dia, Contexts.Context ctx) {
    if (dia.message().startsWith("DT:")) {
      if (isDependencyTrackingOn()) {
        parseOpenedJar(dia.message());
      }
    } else {
      if (delegateReporter != null) {
        delegateReporter.doReport(dia, ctx);
      } else {
        super.doReport(dia, ctx);
      }
    }
  }

  private void parseOpenedJar(String msg) {
    String jar = msg.split(":")[1];

    //normalize path separators (scalac passes os-specific path separators.)
    jar = jar.replace("\\", "/");

    // track only jars from dependency targets
    // this should exclude things like rt.jar which come from JDK
    if (jarToTarget.containsKey(jar) || indirectJarToTarget.containsKey(jar)) {
      usedJars.add(jar);
    }
  }

  public void prepareReport(Contexts.Context ctx) throws IOException {
    Set<String> usedTargets = new HashSet<>();
    Set<Dependency> usedDeps = new HashSet<>();

    for (String jar : usedJars) {
      String target = jarToTarget.get(jar);

      if (target == null) {
        target = indirectJarToTarget.get(jar);
      }

      if (target.startsWith("Unknown")) {
        target = jarLabel(jar);
      }

      if (target == null) {
        // probably a bug if we get here
        continue;
      }

      Dependency dep = buildDependency(
          jar,
          target,
          astUsedJars.contains(jar) ? Kind.EXPLICIT : Kind.IMPLICIT,
          ignoredTargets.contains(target)
      );

      usedTargets.add(target);
      usedDeps.add(dep);
    }

    Set<Dependency> unusedDeps = new HashSet<>();
    if (!hasErrors()) {
      for (int i = 0; i < ops.directTargets.length; i++) {
        String directTarget = ops.directTargets[i];
        if (usedTargets.contains(directTarget)) {
          continue;
        }

        unusedDeps.add(
          buildDependency(
            ops.directJars[i],
            directTarget,
            Kind.UNUSED,
            ignoredTargets.contains(directTarget) || "off".equals(ops.unusedDependencyCheckerMode)
          )
        );
      }
    }

    writeSdepsFile(usedDeps, unusedDeps);

    Reporter reporter = this.delegateReporter != null ? this.delegateReporter : this;
    reportDeps(usedDeps, unusedDeps, reporter, ctx);
  }

  private Dependency buildDependency(String jar, String target, Kind kind, boolean ignored) {
    Dependency.Builder dependecyBuilder = Dependency.newBuilder();

    dependecyBuilder.setKind(kind);
    dependecyBuilder.setLabel(target);
    dependecyBuilder.setIjarPath(jar);
    dependecyBuilder.setPath(guessFullJarPath(jar));
    dependecyBuilder.setIgnored(ignored);

    return dependecyBuilder.build();
  }

  private void writeSdepsFile(Collection<Dependency> usedDeps, Collection<Dependency> unusedDeps)
      throws IOException {

    ScalaDeps.Dependencies.Builder builder = ScalaDeps.Dependencies.newBuilder();
    builder.setRuleLabel(ops.currentTarget);
    builder.setDependencyTrackingMethod(ops.dependencyTrackingMethod);
    builder.addAllDependency(usedDeps);
    builder.addAllDependency(unusedDeps);

    try (OutputStream outputStream = new BufferedOutputStream(
        Files.newOutputStream(Paths.get(ops.scalaDepsFile)))) {
      outputStream.write(builder.build().toByteArray());
    }
  }

  private void reportDeps(Collection<Dependency> usedDeps, Collection<Dependency> unusedDeps,
      Reporter reporter, Contexts.Context ctx) {
    if (ops.dependencyTrackingMethod.equals("ast-plus")) {

      if (!ops.strictDepsMode.equals("off")) {
        boolean isWarning = ops.strictDepsMode.equals("warn");
        StringBuilder strictDepsReport = new StringBuilder("Missing strict dependencies:\n");
        StringBuilder compilerDepsReport = new StringBuilder("Missing compiler dependencies:\n");
        int strictDepsCount = 0;
        int compilerDepsCount = 0;
        for (Dependency dep : usedDeps) {
          String depReport = addDepMessage(dep);
          if (dep.getIgnored()) {
            continue;
          }

          if (directTargets.contains(dep.getLabel())) {
            continue;
          }

          if (dep.getKind() == Kind.EXPLICIT) {
            strictDepsCount++;
            strictDepsReport
                .append(isWarning ? "warning: " : "error: ")
                .append(depReport);
          } else {
            compilerDepsCount++;
            compilerDepsReport
                .append(isWarning ? "warning: " : "error: ")
                .append(depReport);
          }
        }

        if (strictDepsCount > 0) {
          Message msg = CompilerCompat.toMessage(strictDepsReport.toString());
          if (ops.strictDepsMode.equals("warn")) {
            reporter.report(new Diagnostic.Warning(msg, NoSourcePosition$.MODULE$), ctx);
          } else {
            reporter.report(new Diagnostic.Error(msg ,NoSourcePosition$.MODULE$), ctx);
          }
        }

        if (!ops.compilerDepsMode.equals("off") && compilerDepsCount > 0) {
          Message msg = CompilerCompat.toMessage(compilerDepsReport.toString());
          if (ops.compilerDepsMode.equals("warn")) {
            reporter.report(new Diagnostic.Warning(msg, NoSourcePosition$.MODULE$), ctx);
          } else {
            reporter.report(new Diagnostic.Error(msg ,NoSourcePosition$.MODULE$), ctx);
          }
        }
      }

      if (!ops.unusedDependencyCheckerMode.equals("off")) {
        boolean isWarning = ops.unusedDependencyCheckerMode.equals("warn");
        StringBuilder unusedDepsReport = new StringBuilder("Unused dependencies:\n");
        int count = 0;
        for (Dependency dep : unusedDeps) {
          if (dep.getIgnored()) {
            continue;
          }
          count++;
          unusedDepsReport
              .append(isWarning ? "warning: " : "error: ")
              .append(removeDepMessage(dep));
        }
        if (count > 0) {
          Message msg = CompilerCompat.toMessage(unusedDepsReport.toString());
          if (isWarning) {
            reporter.report(new Diagnostic.Warning(msg, NoSourcePosition$.MODULE$), ctx);
          } else {
            reporter.report(new Diagnostic.Error(msg ,NoSourcePosition$.MODULE$), ctx);
          }
        }
      }
    }
  }

  private String addDepMessage(Dependency dep) {
    String target = dep.getLabel();
    String jar = dep.getPath();

    String message = "Target '" + target + "' (via jar: ' " + jar + " ') "
        + "is being used by " + ops.currentTarget
        + " but is is not specified as a dependency, please add it to the deps.\n"
        + "You can use the following buildozer command:\n";
    String command = "buildozer 'add deps " + target + "' " + ops.currentTarget + "\n";
    return message + command;
  }

  private String removeDepMessage(Dependency dep) {
    String target = dep.getLabel();
    String jar = dep.getPath();

    String message = "Target '" + target + "' (via jar: ' " + jar + " ')  "
        + "is specified as a dependency to " + ops.currentTarget
        + " but isn't used, please remove it from the deps.\n"
        + "You can use the following buildozer command:\n";
    String command = "buildozer 'remove deps " + target + "' " + ops.currentTarget + "\n";

    return message + command;
  }

  private String guessFullJarPath(String jar) {
    if (jar.endsWith(IJAR_JAR_SUFFIX)) {
      return stripIjarSuffix(jar, IJAR_JAR_SUFFIX);
    } else if (jar.endsWith(HJAR_JAR_SUFFIX)) {
      return stripIjarSuffix(jar, HJAR_JAR_SUFFIX);
    } else {
      return jar;
    }
  }

  private static String stripIjarSuffix(String jar, String suffix) {
    return jar.substring(0, jar.length() - suffix.length()) + ".jar";
  }

  private String jarLabel(String path) throws IOException {
    try (JarFile jar = new JarFile(path)) {
      return jar.getManifest().getMainAttributes().getValue("Target-Label");
    }
  }

  public void registerAstUsedJars(Set<String> jars) {
    astUsedJars = jars;
  }

  public void writeDiagnostics(String diagnosticsFile) throws IOException {
    if (! (delegateReporter instanceof ProtoReporter)) {
      return;
    }

    ProtoReporter protoReporter = (ProtoReporter) delegateReporter;
    protoReporter.writeTo(Paths.get(diagnosticsFile));
  }
}
