load("//scala:providers.bzl", "DepsInfo")
load(
    "//scala/private/toolchain_deps:toolchain_deps.bzl",
    "expose_toolchain_deps",
)
load("//scala:providers.bzl", "declare_deps_provider")
load("//scala:artifacts.bzl", "versioned_artifact_repos")

def _scrooge_toolchain_impl(ctx):
    toolchain = platform_common.ToolchainInfo(
        dep_providers = ctx.attr.dep_providers,
    )
    return [toolchain]

scrooge_toolchain = rule(
    _scrooge_toolchain_impl,
    attrs = {
        "dep_providers": attr.label_list(
            providers = [DepsInfo],
        ),
    },
)

def _export_scrooge_deps_impl(ctx):
    return expose_toolchain_deps(
        ctx,
        "@io_bazel_rules_scala//twitter_scrooge/toolchain:scrooge_toolchain_type",
    )

export_scrooge_deps = rule(
    _export_scrooge_deps_impl,
    attrs = {
        "deps_id": attr.string(
            mandatory = True,
        ),
    },
    toolchains = ["@io_bazel_rules_scala//twitter_scrooge/toolchain:scrooge_toolchain_type"],
    incompatible_use_toolchain_transition = True,
)

def setup_scrooge_toolchain(name):
    scrooge_toolchain(
        name = "%s_impl" % name,
        dep_providers = [
            ":compile_classpath_provider",
            ":aspect_compile_classpath_provider",
            ":compiler_classpath_provider",
            ":scrooge_generator_classpath_provider",
        ],
        visibility = ["//visibility:public"],
    )

    native.toolchain(
        name = name,
        toolchain = ":%s_impl" % name,
        toolchain_type = Label(
            "//twitter_scrooge/toolchain:scrooge_toolchain_type"
        ),
        visibility = ["//visibility:public"],
    )

    declare_deps_provider(
        name = "aspect_compile_classpath_provider",
        deps_id = "aspect_compile_classpath",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@io_bazel_rules_scala_javax_annotation_api",
            "@libthrift",
            "@io_bazel_rules_scala_scrooge_core",
            "@io_bazel_rules_scala_util_core",
        ]) + [
            Label("//scala/private/toolchain_deps:scala_library_classpath"),
        ],
    )

    declare_deps_provider(
        name = "compile_classpath_provider",
        deps_id = "compile_classpath",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@libthrift",
            "@io_bazel_rules_scala_scrooge_core",
        ]) + [
            Label("//scala/private/toolchain_deps:scala_library_classpath"),
        ],
    )

    declare_deps_provider(
        name = "scrooge_generator_classpath_provider",
        deps_id = "scrooge_generator_classpath",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@io_bazel_rules_scala_scrooge_generator",
        ]),
    )

    declare_deps_provider(
        name = "compiler_classpath_provider",
        deps_id = "compiler_classpath",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@io_bazel_rules_scala_mustache",
            "@io_bazel_rules_scala_scopt",
            "@io_bazel_rules_scala_scrooge_generator",
            "@io_bazel_rules_scala_util_core",
            "@io_bazel_rules_scala_util_logging",
        ]) + [
            Label("//scala/private/toolchain_deps:parser_combinators"),
        ],
    )

    export_scrooge_deps(
        name = "compile_classpath",
        deps_id = "compile_classpath",
        visibility = ["//visibility:public"],
    )

    export_scrooge_deps(
        name = "aspect_compile_classpath",
        deps_id = "aspect_compile_classpath",
        visibility = ["//visibility:public"],
    )

    export_scrooge_deps(
        name = "scrooge_generator_classpath",
        deps_id = "scrooge_generator_classpath",
        visibility = ["//visibility:public"],
    )

    export_scrooge_deps(
        name = "compiler_classpath",
        deps_id = "compiler_classpath",
        visibility = ["//visibility:public"],
    )
