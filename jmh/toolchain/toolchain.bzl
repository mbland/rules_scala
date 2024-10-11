load("//scala/private/toolchain_deps:toolchain_deps.bzl", "expose_toolchain_deps")
load("//scala:artifacts.bzl", "versioned_artifact_repos")
load("//scala:providers.bzl", _DepsInfo = "DepsInfo", "declare_deps_provider")

DEP_PROVIDERS = [
    "jmh_classpath",
    "jmh_core",
    "benchmark_generator",
    "benchmark_generator_runtime",
]

def _jmh_toolchain_impl(ctx):
    toolchain = platform_common.ToolchainInfo(
        dep_providers = ctx.attr.dep_providers,
    )
    return [toolchain]

jmh_toolchain = rule(
    _jmh_toolchain_impl,
    attrs = {
        "dep_providers": attr.label_list(
            default = [":%s_provider" % p for p in DEP_PROVIDERS],
            providers = [_DepsInfo],
        ),
    },
)

_toolchain_type = "//jmh/toolchain:jmh_toolchain_type"

def _export_toolchain_deps_impl(ctx):
    return expose_toolchain_deps(ctx, _toolchain_type)

export_toolchain_deps = rule(
    _export_toolchain_deps_impl,
    attrs = {
        "deps_id": attr.string(
            mandatory = True,
        ),
    },
    toolchains = [_toolchain_type],
    incompatible_use_toolchain_transition = True,
)

def setup_jmh_toolchain(name):
    jmh_toolchain(
        name = "%s_impl" % name,
        dep_providers = [":%s_provider" % p for p in DEP_PROVIDERS],
        visibility = ["//visibility:public"],
    )

    native.toolchain(
        name = name,
        toolchain = ":%s_impl" % name,
        toolchain_type = Label(_toolchain_type),
        visibility = ["//visibility:public"],
    )

    declare_deps_provider(
        name = "jmh_core_provider",
        deps_id = "jmh_core",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@io_bazel_rules_scala_org_openjdk_jmh_jmh_core",
        ]),
    )

    declare_deps_provider(
        name = "jmh_classpath_provider",
        deps_id = "jmh_classpath",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@io_bazel_rules_scala_net_sf_jopt_simple_jopt_simple",
            "@io_bazel_rules_scala_org_apache_commons_commons_math3",
        ]),
    )

    declare_deps_provider(
        name = "benchmark_generator_provider",
        deps_id = "benchmark_generator",
        visibility = ["//visibility:public"],
        deps = [
            "@io_bazel_rules_scala//src/java/io/bazel/rulesscala/jar",
        ] + versioned_artifact_repos([
            "@io_bazel_rules_scala_org_openjdk_jmh_jmh_core",
            "@io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_asm",
            "@io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_reflection",
        ]),
    )

    declare_deps_provider(
        name = "benchmark_generator_runtime_provider",
        deps_id = "benchmark_generator_runtime",
        visibility = ["//visibility:public"],
        deps = versioned_artifact_repos([
            "@io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_asm",
        ]),
    )
