"""Macro for instantiating repos required for core functionality."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_scala_dependencies():
    """Instantiates repos needed by rules provided by `rules_scala`."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "rules_cc",
        urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.1.0/rules_cc-0.1.0.tar.gz"],
        sha256 = "4b12149a041ddfb8306a8fd0e904e39d673552ce82e4296e96fac9cbf0780e59",
        strip_prefix = "rules_cc-0.1.0",
    )

    maybe(
        http_archive,
        name = "com_google_absl",
        sha256 = "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3",
        strip_prefix = "abseil-cpp-20240722.0",
        url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240722.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/8.6.1/rules_java-8.6.1.tar.gz",
        ],
        sha256 = "c5bc17e17bb62290b1fd8fdd847a2396d3459f337a7e07da7769b869b488ec26",
    )

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "3d32940e975c4ad9b8ba69640e78f5527075bae33ca2890275bf26b853c0962c",
        strip_prefix = "protobuf-29.1",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v29.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "0e5c64a2599a6e26c6a03d6162242d231ecc0de219534c38cb4402171def21e8",
        strip_prefix = "rules_proto-7.0.2",
        url = "https://github.com/bazelbuild/rules_proto/releases/download/7.0.2/rules_proto-7.0.2.tar.gz",
    )