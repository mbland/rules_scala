"""Exports repos used by @io_bazel_rules_scala rules"""

load(
    "//scala/private:macros/scala_repositories.bzl",
    "dt_patched_compiler_setup",
)
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("//third_party/repositories:repositories.bzl", "repositories")
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

_artifacts = tag_class(
    attrs = {
        "toolchain_common": attr.string_list(),
        "toolchain_scala_2": attr.string_list(),
        "toolchain_scala_3": attr.string_list(),
        "scalatest": attr.string_list(),
        "testonly": attr.string_list(),
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

def _get_artifacts(module_ctx):
    toolchain_common = {}
    toolchain_scala_2 = {}
    toolchain_scala_3 = {}
    scalatest = {}
    testonly = {}

    for mod in module_ctx.modules:
        for artifacts in mod.tags.artifacts:
            for artifact in artifacts.toolchain_common:
                toolchain_common[artifact] = None
            for artifact in artifacts.toolchain_scala_2:
                toolchain_scala_2[artifact] = None
            for artifact in artifacts.toolchain_scala_3:
                toolchain_scala_3[artifact] = None
            for artifact in artifacts.scalatest:
                scalatest[artifact] = None
            for artifact in artifacts.testonly:
                testonly[artifact] = None

    return {
        "toolchain_common": toolchain_common.keys(),
        "toolchain_scala_2": toolchain_scala_2.keys(),
        "toolchain_scala_3": toolchain_scala_3.keys(),
        "scalatest": scalatest.keys(),
        "testonly": testonly.keys(),
    }

def _scala_dependencies_impl(module_ctx):
    load_dep_rules, load_jar_deps, settings = _get_settings(module_ctx)
    artifacts = _get_artifacts(module_ctx)
    srcjar = _get_scala_compiler_srcjar(module_ctx)

    for scala_version in SCALA_VERSIONS:
        # Replace scala_repositories()
        if load_dep_rules:
            # Replace rules_scala_setup()
            dt_patched_compiler_setup(scala_version, srcjar)

        if load_jar_deps:
            # Replace rules_scala_toolchain_deps_repositories()
            toolchain_ids = artifacts["toolchain_common"]
            toolchain_ids += artifacts["toolchain_scala_%s" % scala_version[0]]
            repositories(
                scala_version = scala_version,
                for_artifact_ids = toolchain_ids,
                **settings,
            )

        # Replace scalatest_repositories()
        repositories(
            scala_version = scala_version,
            for_artifact_ids = artifacts["scalatest"],
            **settings,
        )

    # twitter_scrooge()
    # jmh_repositories()
    # scala_proto_repositories()
    # specs2_junit_repositories()
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
    implementation = _scala_dependencies_impl,
    tag_classes = {
        "settings": _settings,
        "scala_compiler_srcjar": _scala_compiler_srcjar,
        "artifacts": _artifacts,
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
