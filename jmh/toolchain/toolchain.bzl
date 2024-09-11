load("//scala/private/toolchain_deps:toolchain_deps.bzl", "expose_toolchain_deps")
load("//scala:providers.bzl", _DepsInfo = "DepsInfo")

def _jmh_toolchain_impl(ctx):
    toolchain = platform_common.ToolchainInfo(
        dep_providers = ctx.attr.dep_providers,
    )
    return [toolchain]

jmh_toolchain = rule(
    _jmh_toolchain_impl,
    attrs = {
        "dep_providers": attr.label_list(
            default = [
                "//jmh:jmh_classpath_provider",
                "//jmh:jmh_core_provider",
                "//jmh:benchmark_generator_provider",
                "//jmh:benchmark_generator_runtime_provider",
            ],
            providers = [_DepsInfo],
        ),
    },
)

def _export_toolchain_deps_impl(ctx):
    return expose_toolchain_deps(ctx, "//jmh/toolchain:jmh_toolchain_type")

export_toolchain_deps = rule(
    _export_toolchain_deps_impl,
    attrs = {
        "deps_id": attr.string(
            mandatory = True,
        ),
    },
    toolchains = ["//jmh/toolchain:jmh_toolchain_type"],
    incompatible_use_toolchain_transition = True,
)
