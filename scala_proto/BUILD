load("//scala_proto:toolchains.bzl", "DEP_PROVIDERS")
load(
    "//scala_proto/private:toolchain_deps.bzl",
    "export_scalapb_toolchain_deps",
)

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

toolchain_type(
    name = "deps_toolchain_type",
    visibility = ["//visibility:public"],
)

[
    (
        export_scalapb_toolchain_deps(
            name = provider,
            deps_id = provider,
            visibility = ["//visibility:public"],
        ),
        alias(
            name = provider + "_provider",
            actual = "@io_bazel_rules_scala_toolchains//scala_proto:" + (
                provider + "_provider"
            )
        ),
    )
    for provider in DEP_PROVIDERS
]
