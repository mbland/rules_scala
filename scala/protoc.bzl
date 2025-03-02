"""Precompiled protocol compiler toolchain helpers."""
load("@com_google_protobuf//bazel/common:proto_common.bzl", "proto_common")

def register_precompiled_protoc_toolchain():
    if proto_common.INCOMPATIBLE_ENABLE_PROTO_TOOLCHAIN_RESOLUTION:
        native.register_toolchains("@rules_scala_toolchains//protoc/...:all")
