load(
    "//scala/private/toolchain_deps:toolchain_deps.bzl",
    "expose_toolchain_deps",
)

_toolchain_type = "//scala:toolchain_type"

def _common_toolchain_deps(ctx):
    return expose_toolchain_deps(ctx, _toolchain_type)

common_toolchain_deps = rule(
    implementation = _common_toolchain_deps,
    attrs = {
        "deps_id": attr.string(mandatory = True),
    },
    toolchains = [_toolchain_type],
    incompatible_use_toolchain_transition = True,
)
