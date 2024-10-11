load(
    "@io_bazel_rules_scala//scala/private/toolchain_deps:toolchain_deps.bzl",
    "expose_toolchain_deps",
)

_toolchain_type = "//scala_proto:deps_toolchain_type"

def _export_scalapb_toolchain_deps(ctx):
    return expose_toolchain_deps(ctx, _toolchain_type)

export_scalapb_toolchain_deps = rule(
    _export_scalapb_toolchain_deps,
    attrs = {
        "deps_id": attr.string(
            mandatory = True,
        ),
    },
    incompatible_use_toolchain_transition = True,
    toolchains = [_toolchain_type],
)
