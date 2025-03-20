load(
    "@com_google_protobuf//bazel/toolchains:proto_lang_toolchain.bzl",
    "proto_lang_toolchain",
)
load(
    "@com_google_protobuf//bazel/toolchains:proto_toolchain.bzl",
    "proto_toolchain",
)
load("@rules_scala_toolchains//protoc:platforms.bzl", "PROTOC_PLATFORMS")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

proto_lang_toolchain(
    name = "protoc_scala_toolchain",
    command_line = "unused-because-we-pass-protoc-to-scalapb",
    toolchain_type = ":toolchain_type",
)

[
    proto_toolchain(
        name = platform,
        exec_compatible_with = specs,
        proto_compiler = "@rules_scala_toolchains//protoc:" + platform,
    )
    for platform, specs in PROTOC_PLATFORMS.items()
]
