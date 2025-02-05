load("//scala:jars_to_labels.bzl", "JarsToLabelsInfo")
load("//scala:plusone.bzl", "PlusOneDeps")
load("//scala:providers.bzl", "ScalaInfo")
load("@bazel_skylib//lib:paths.bzl", "paths")

def write_manifest_file(actions, output_file, main_class):
    # TODO(bazel-team): I don't think this classpath is what you want
    manifest = "Class-Path: \n"
    if main_class:
        manifest += "Main-Class: %s\n" % main_class

    actions.write(output = output_file, content = manifest)

def collect_jars(
        dep_targets,
        dependency_mode,
        need_direct_info,
        need_indirect_info):
    """Compute the runtime and compile-time dependencies from the given targets"""  # noqa

    transitive_compile_jars = []
    jars2labels = {}
    compile_jars = []
    runtime_jars = []
    deps_providers = []
    macro_classpath = []

    for dep_target in dep_targets:
        # we require a JavaInfo for dependencies
        # must use java_import or scala_import if you have raw files
        java_provider = dep_target[JavaInfo]
        deps_providers.append(java_provider)
        compile_jars.append(java_provider.compile_jars)
        runtime_jars.append(java_provider.transitive_runtime_jars)

        additional_transitive_compile_jars = _additional_transitive_compile_jars(
            java_provider = java_provider,
            dep_target = dep_target,
            dependency_mode = dependency_mode,
        )
        transitive_compile_jars.append(additional_transitive_compile_jars)

        if need_direct_info or need_indirect_info:
            if need_indirect_info:
                all_jars = additional_transitive_compile_jars.to_list()
            else:
                all_jars = []
            add_labels_of_jars_to(
                jars2labels,
                dep_target,
                all_jars,
                java_provider.compile_jars.to_list(),
            )

        # Macros are different from ordinary targets in that they’re used at compile time instead of at runtime. That
        # means that both their compile-time classpath and runtime classpath are needed at compile time. We could have
        # `scala_macro_library` targets include their runtime dependencies in their compile-time dependencies, but then
        # we wouldn't have any guarantees classpath order.
        #
        # Consider the following scenario. Target A depends on targets B and C. Target C is a macro target, whereas
        # target B isn't. Targets C depends on target B. If target A doesn't include the runtime version of target C on
        # the compile classpath before the compile (`ijar`d) version of target B that target C depends on, then target A
        # won't use the correct version of target B at compile-time when evaluating the macros contained in target C.
        #
        # For that reason, we opt for a different approach: have `scala_macro_library` targets export `JavaInfo`
        # providers as normal, but put their transitive runtime dependencies first on the classpath. Note that we
        # shouldn't encounter any issues with external dependencies, so long as they aren't `ijar`d.
        if ScalaInfo in dep_target and dep_target[ScalaInfo].contains_macros:
            macro_classpath.append(java_provider.transitive_runtime_jars)

            add_labels_of_jars_to(
                jars2labels,
                dep_target,
                [],
                java_provider.transitive_runtime_jars.to_list(),
            )

    return struct(
        compile_jars = depset(order = "preorder", transitive = macro_classpath + compile_jars),
        transitive_runtime_jars = depset(transitive = runtime_jars),
        jars2labels = JarsToLabelsInfo(jars_to_labels = jars2labels),
        transitive_compile_jars = depset(order = "preorder", transitive = macro_classpath + transitive_compile_jars),
        deps_providers = deps_providers,
    )

def collect_plugin_paths(plugins):
    """Get the actual jar paths of plugins as a depset."""
    paths = []
    for p in plugins:
        if hasattr(p, "path"):
            paths.append(p)
        elif JavaInfo in p:
            paths.extend([j.class_jar for j in p[JavaInfo].outputs.jars])
            # support http_file pointed at a jar. http_jar uses ijar,
            # which breaks scala macros

        elif hasattr(p, "files"):
            paths.extend([f for f in p.files.to_list() if not_sources_jar(f.basename)])
    return depset(paths)

def _additional_transitive_compile_jars(
        java_provider,
        dep_target,
        dependency_mode):
    if dependency_mode == "transitive":
        return java_provider.transitive_compile_time_jars
    elif dependency_mode == "plus-one":
        # dep_target will not always have a PlusOneDeps provider, such as
        # with scala_maven_import_external, hence the need for the fallback.
        if PlusOneDeps in dep_target:
            plus_one_jars = [dep[JavaInfo].compile_jars for dep in dep_target[PlusOneDeps].direct_deps if JavaInfo in dep]

            # plus_one_jars only contains the deps of deps, not the deps themselves.
            # Hence the need to include the dep's compile jars anyways
            return depset(transitive = plus_one_jars + [java_provider.compile_jars])
        else:
            return java_provider.compile_jars
    else:  # direct
        return java_provider.compile_jars

# When import mavan_jar's for scala macros we have to use the jar:file requirement
# since bazel 0.6.0 this brings in the source jar too
# the scala compiler thinks a source jar can look like a package space
# causing a conflict between objects and packages warning
#  error: package cats contains object and package with same name: implicits
# one of them needs to be removed from classpath
# import cats.implicits._

def not_sources_jar(name):
    return "-sources.jar" not in name

def add_labels_of_jars_to(jars2labels, dependency, all_jars, direct_jars):
    for jar in direct_jars:
        jars2labels[jar.path] = dependency.label
    for jar in all_jars:
        path = jar.path
        if path not in jars2labels:
            # starlark exposes only labels of direct dependencies.
            # to get labels of indirect dependencies we collect them from the providers transitively
            label = _provider_of_dependency_label_of(dependency, path)
            if label == None:
                label = "Unknown label of file {jar_path} which came from {dependency_label}".format(
                    jar_path = path,
                    dependency_label = dependency.label,
                )
            jars2labels[path] = label

def _provider_of_dependency_label_of(dependency, path):
    if JarsToLabelsInfo in dependency:
        return dependency[JarsToLabelsInfo].jars_to_labels.get(path)
    else:
        return None

def sanitize_string_for_usage(s):
    res_array = []
    for idx in range(len(s)):
        c = s[idx]
        if c.isalnum() or c == ".":
            res_array.append(c)
        else:
            res_array.append("_")
    return "".join(res_array)

#generates an rlocationpath that can be used with the rlocation() at runtime. (rlocationpath starts with repo name)
def rlocationpath_from_file(ctx, file):
    return paths.normalize(ctx.workspace_name + "/" + file.short_path)

#generates an rlocationpath that can be used with the rlocation() at runtime. (rlocationpath start with repo name)
#rootpath arg expects "rootpath" format (i.e. relative to runfilesDir/workspacename). Rootpath can be obtained by $rootpath macro or File.short_path
def rlocationpath_from_rootpath(ctx, rootpath):
    return paths.normalize(ctx.workspace_name + "/" + rootpath)
