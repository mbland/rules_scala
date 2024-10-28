load("//scala:providers.bzl", _DepsInfo = "DepsInfo")

def _scala_toolchain_impl(ctx):
    toolchain = platform_common.ToolchainInfo(
        dep_providers = ctx.attr.dep_providers,
    )
    return [toolchain]

scala_testing_toolchain = rule(
    _scala_toolchain_impl,
    attrs = {
        "dep_providers": attr.label_list(
            providers = [_DepsInfo],
        ),
    },
)

def register_testing_toolchains(name = None):
    """DO NOT USE: Registers all testing toolchains for WORKSPACE builds.

    This exists solely for backwards compatibility with existing
    `{scalatest,junit,specs2_junit}_toolchain` users. New users should prefer to
    use the following in their `WORKSPACE` files:

    ```starlark
    register_toolchains("@io_bazel_rules_scala_toolchains//...:all")
    ```

    Bzlmod users need not do this; the rules_scala `MODULE.bazel` does this
    automatically.
    """
    native.register_toolchains("@io_bazel_rules_scala_toolchains//testing:all")
