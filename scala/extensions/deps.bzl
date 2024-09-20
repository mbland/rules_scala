"""Exports repos used by @io_bazel_rules_scala rules"""

load(
    "//scala/private:macros/scala_repositories.bzl",
    "dt_patched_compiler_setup",
    "rules_scala_toolchain_deps_repositories",
)
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("@io_bazel_rules_scala//junit:junit.bzl", "junit_repositories")
load("@io_bazel_rules_scala//scalatest:scalatest.bzl", "scalatest_repositories")
load(
    "@io_bazel_rules_scala//specs2:specs2_junit.bzl",
    "specs2_junit_repositories",
)
load(
    "@io_bazel_rules_scala_config//:config.bzl",
    "SCALA_VERSION",
    "SCALA_VERSIONS",
)

_settings = tag_class(
    attrs = {
        "maven_servers": attr.string_list(
            default = default_maven_server_urls(),
        ),
        # Correct spelling of "overridden"
        "overridden_artifacts": attr.string_dict(),
        "load_dep_rules": attr.bool(default = True),
        "load_jar_deps": attr.bool(default = True),
        "fetch_sources": attr.bool(),
        "validate_scala_version": attr.bool(default = True),
    },
)

_scala_compiler_srcjar_default_url = ("https://repo1.maven.org/maven2/org/" +
    "scala-lang/scala-compiler/%s/scala-compiler-%s-sources.jar" % (
        SCALA_VERSION, SCALA_VERSION
    )
)

_scala_compiler_srcjar = tag_class(
    attrs = {
        "url": attr.string(default = _scala_compiler_srcjar_default_url),
        "urls": attr.string_list(),
        "label": attr.string(),
        "sha256": attr.string(),
        "integrity": attr.string(),
    },
)

_toolchains = tag_class(
    attrs = {
        "scala": attr.bool(default = True),
        "scalatest": attr.bool(default = True),
        "junit": attr.bool(),
        "specs2": attr.bool(),
    }
)

def _get_settings(module_ctx):
    root_settings = module_ctx.modules[0].tags.settings

    if len(root_settings) == 0:
        return True, True, {"maven_servers": default_maven_server_urls()}
    settings = root_settings[0]
    return settings.load_dep_rules, settings.load_jar_deps, {
        "maven_servers": settings.maven_servers,
        # internal macros misspell "overridden"
        "overriden_artifacts": settings.overridden_artifacts,
        "fetch_sources": settings.fetch_sources,
        "validate_scala_version": settings.validate_scala_version,
    }

def _add_if_not_empty(name, value, result):
    if len(value) != 0:
        result[name] = value

def _get_scala_compiler_srcjar(module_ctx):
    root_srcjar = module_ctx.modules[0].tags.scala_compiler_srcjar

    if len(root_srcjar) == 0:
        return None
    srcjar = root_srcjar[0]

    result = {}
    _add_if_not_empty("url", srcjar.url, result)
    _add_if_not_empty("urls", srcjar.urls, result)
    _add_if_not_empty("label", srcjar.label, result)
    _add_if_not_empty("sha256", srcjar.sha256, result)
    _add_if_not_empty("integrity", srcjar.integrity, result)
    return result

def _get_toolchains(module_ctx):
    result = {}

    for mod in module_ctx.modules:
        for toolchains in mod.tags.toolchains:
            if toolchains.scala:
                result["scala"] = _SCALA_TOOLCHAIN_BUILD
            if toolchains.scalatest:
                result["scalatest"] = _SCALATEST_TOOLCHAIN_BUILD
            if toolchains.junit:
                result["junit"] = _JUNIT_TOOLCHAIN_BUILD
            if toolchains.specs2:
                result["specs2"] = _SPECS2_TOOLCHAIN_BUILD
    return result

_SCALA_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load(
    "@io_bazel_rules_scala//scala/private:macros/setup_scala_toolchain.bzl",
    "setup_scala_toolchain",
)
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

[
    setup_scala_toolchain(
        name = "toolchain" + version_suffix(scala_version),
        scala_version = scala_version,
        use_argument_file_in_runner = True,
    )
    for scala_version in SCALA_VERSIONS
]
"""

_SCALATEST_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    "repositories",
    "version_suffix",
)
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")
load("@io_bazel_rules_scala//testing:deps.bzl", "SCALATEST_DEPS")

[
    setup_scala_testing_toolchain(
        name = "scalatest_toolchain" + version_suffix(scala_version),
        scala_version = scala_version,
        scalatest_classpath = repositories(scala_version, SCALATEST_DEPS),
        visibility = ["//visibility:public"],
    )
    for scala_version in SCALA_VERSIONS
]
"""

_JUNIT_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    "repositories",
    "version_suffix",
)
load("@io_bazel_rules_scala//testing:deps.bzl", "JUNIT_DEPS")

setup_scala_testing_toolchain(
    name = "junit_toolchain",
    junit_classpath = JUNIT_DEPS,
    visibility = ["//visibility:public"],
)
"""

_SPECS2_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    "repositories",
    "version_suffix",
)
load(
    "@io_bazel_rules_scala//testing:deps.bzl",
    "JUNIT_DEPS",
    "SPECS2_DEPS",
    "SPECS2_JUNIT_DEPS",
)

setup_scala_testing_toolchain(
    name = "specs2_junit_toolchain",
    junit_classpath = JUNIT_DEPS,
    specs2_classpath = SPECS2_DEPS,
    specs2_junit_classpath = SPECS2_JUNIT_DEPS,
    visibility = ["//visibility:public"],
)
"""

def _scala_toolchain_repos_impl(repository_ctx):
    for pkg, build in repository_ctx.attr.package_to_build_file_content.items():
        repository_ctx.file(pkg + "/BUILD", content=build, executable=False)

scala_toolchain_repos = repository_rule(
    implementation = _scala_toolchain_repos_impl,
    attrs = {
        "package_to_build_file_content": attr.string_dict(mandatory = True),
    },
)

def strip_artifact_prefix(deps):
    return [dep.removeprefix("@") for dep in deps]

def _scala_deps_impl(module_ctx):
    load_dep_rules, load_jar_deps, settings = _get_settings(module_ctx)
    toolchains = _get_toolchains(module_ctx)
    srcjar = _get_scala_compiler_srcjar(module_ctx)

    # Replace scala_repositories()
    for scala_version in SCALA_VERSIONS:
        if load_dep_rules:
            # Replace rules_scala_setup()
            dt_patched_compiler_setup(scala_version, srcjar)

    if load_jar_deps:
        rules_scala_toolchain_deps_repositories(**settings)

    repositories_options = {
        k: settings.get(k) for k in ["maven_servers", "fetch_sources"]
    }

    if "scalatest" in toolchains:
        scalatest_repositories(**repositories_options)
    if "junit" in toolchains:
        junit_repositories(**repositories_options)
    if "specs2" in toolchains:
        specs2_junit_repositories(
            maven_servers = settings.get("maven_servers"),
            overriden_artifacts = settings.get("overriden_artifacts", {}),
            create_junit_repositories = "junit" not in toolchains,
        )

    if len(toolchains) != 0:
        scala_toolchain_repos(
            name = "io_bazel_rules_scala_toolchains",
            package_to_build_file_content = toolchains,
        )
    # jmh_repositories()
    # scala_proto_repositories()
    # scalafmt_default_config()
    # scalafmt_repositories()
    # proto_cross_repo_boundary_repository()
    # new_local_repository()...
    # local_repository()...
    # scala_register_unused_deps_toolchains()
    # java_import_external() - see WORKSPACE

    # We need to select based on platform when we use these
    # https://github.com/bazelbuild/bazel/issues/11655
    #remote_jdk8_repos()

    # repositories() - see WORKSPACE

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = {
        "settings": _settings,
        "toolchains": _toolchains,
        "scala_compiler_srcjar": _scala_compiler_srcjar,
    }
)

#new_local_repository(
#    name = "test_new_local_repo",
#    build_file_content =
#        """
#filegroup(
#    name = "data",
#    srcs = glob(["**/*.txt"]),
#    visibility = ["//visibility:public"],
#)
#""",
#    path = "third_party/test/new_local_repo",
#)

#local_repository(
#    name = "example_external_workspace",
#    path = "third_party/test/example_external_workspace",
#)

# load("@bazelci_rules//:rbe_repo.bzl", "rbe_preconfig")
# rbe_preconfig(
#     name = "rbe_default",
#     toolchain = "ubuntu2004-bazel-java11",
# )

# load("//test/toolchains:jdk.bzl", "remote_jdk21_repositories", "remote_jdk21_toolchains")
# remote_jdk21_repositories()
# remote_jdk21_toolchains()
