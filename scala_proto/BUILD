load("//scala_proto:toolchains.bzl", "DEP_PROVIDERS")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

toolchain_type(
    name = "deps_toolchain_type",
    visibility = ["//visibility:public"],
)

[
    alias(
        name = "%s" % target,
        actual = "@io_bazel_rules_scala_toolchains//scala_proto:%s" % target,
    )
    for target in DEP_PROVIDERS
]
