exports_files(
    ["toolchains.bzl"],
    visibility = ["//visibility:public"],
)

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

# Aliases the @protobuf >= v33.4 flag so test modules don't have to import
# @protobuf directly to handle the flag imported from .bazelrc.
alias(
    name = "prefer_prebuilt_protoc",
    actual = "@com_google_protobuf//bazel/toolchains:prefer_prebuilt_protoc",
    visibility = ["//visibility:public"],
)
