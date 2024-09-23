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
    export_scalapb_toolchain_deps(
        name = provider,
        deps_id = provider,
        visibility = ["//visibility:public"],
    )
    for provider in DEP_PROVIDERS
]
