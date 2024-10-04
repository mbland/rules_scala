"""com_google_protobuf dependencies for the protoc_toolchain"""

load (
    ":protoc_toolchain.bzl",
    "PROTOBUF_SHA256",
    "PROTOBUF_URL",
    "PROTOBUF_VERSION",
    "protoc_toolchains",
)
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def scala_protoc_toolchains(name, builds = None):
    http_archive(
        name = "com_google_protobuf",
        sha256 = PROTOBUF_SHA256,
        strip_prefix = "protobuf-%s" % PROTOBUF_VERSION,
        url = PROTOBUF_URL,
    )

    protoc_toolchains(
        name = name,
        builds = builds,
    )
