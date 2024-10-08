"""Rule for launching a Scala REPL with dependencies"""

load("@bazel_skylib//lib:dicts.bzl", _dicts = "dicts")
load(
    "@io_bazel_rules_scala//scala/private:common_attributes.bzl",
    "common_attrs",
    "implicit_deps",
    "launcher_template",
    "resolve_deps",
)
load("@io_bazel_rules_scala//scala/private:common_outputs.bzl", "common_outputs")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "scala_version_transition", "toolchain_transition_attr")
load(
    "@io_bazel_rules_scala//scala/private:phases/phases.bzl",
    "extras_phases",
    "phase_collect_jars_repl",
    "phase_compile_repl",
    "phase_coverage_common",
    "phase_declare_executable",
    "phase_default_info",
    "phase_dependency_common",
    "phase_java_wrapper_repl",
    "phase_merge_jars",
    "phase_runfiles_common",
    "phase_scalac_provider",
    "phase_scalacopts",
    "phase_semanticdb",
    "phase_write_executable_repl",
    "phase_write_manifest",
    "run_phases",
)

def _scala_repl_impl(ctx):
    return run_phases(
        ctx,
        # customizable phases
        [
            ("scalac_provider", phase_scalac_provider),
            ("write_manifest", phase_write_manifest),
            ("dependency", phase_dependency_common),
            # need scala-compiler for MainGenericRunner below
            ("collect_jars", phase_collect_jars_repl),
            ("java_wrapper", phase_java_wrapper_repl),
            ("declare_executable", phase_declare_executable),
            ("scalacopts", phase_scalacopts),
            ("semanticdb", phase_semanticdb),
            # no need to build an ijar for an executable
            ("compile", phase_compile_repl),
            ("coverage", phase_coverage_common),
            ("merge_jars", phase_merge_jars),
            ("runfiles", phase_runfiles_common),
            ("write_executable", phase_write_executable_repl),
            ("default_info", phase_default_info),
        ],
    )

_scala_repl_attrs = {
    "jvm_flags": attr.string_list(),
}

_scala_repl_attrs.update(launcher_template)

_scala_repl_attrs.update(implicit_deps)

_scala_repl_attrs.update(common_attrs)

_scala_repl_attrs.update(resolve_deps)

_scala_repl_attrs.update(toolchain_transition_attr)

def make_scala_repl(*extras):
    return rule(
        attrs = _dicts.add(
            _scala_repl_attrs,
            extras_phases(extras),
            *[extra["attrs"] for extra in extras if "attrs" in extra]
        ),
        executable = True,
        fragments = ["java"],
        outputs = _dicts.add(
            common_outputs,
            *[extra["outputs"] for extra in extras if "outputs" in extra]
        ),
        toolchains = [
            Label("//scala:toolchain_type"),
            "@bazel_tools//tools/jdk:toolchain_type",
        ],
        cfg = scala_version_transition,
        incompatible_use_toolchain_transition = True,
        implementation = _scala_repl_impl,
    )

scala_repl = make_scala_repl()
