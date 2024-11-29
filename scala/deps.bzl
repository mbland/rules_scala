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
        urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.0.17/rules_cc-0.0.17.tar.gz"],
        sha256 = "abc605dd850f813bb37004b77db20106a19311a96b2da1c92b789da529d28fe1",
        strip_prefix = "rules_cc-0.0.17",
    )

    maybe(
        http_archive,
        name = "abseil-cpp",
        sha256 = "16242f394245627e508ec6bb296b433c90f8d914f73b9c026fddb905e27276e8",
        strip_prefix = "abseil-cpp-20250127.0",
        url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20250127.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/8.8.0/rules_java-8.8.0.tar.gz",
        ],
        sha256 = "f79a6e10cdd213ceded45884914bb8c68f0c8d41144e74ec89ebb74984c409ac",
    )

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "008a11cc56f9b96679b4c285fd05f46d317d685be3ab524b2a310be0fbad987e",
        strip_prefix = "protobuf-29.3",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v29.3.tar.gz",
        repo_mapping = {"@com_google_absl": "@abseil-cpp"},
    )

    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "14a225870ab4e91869652cfd69ef2028277fc1dc4910d65d353b62d6e0ae21f4",
        strip_prefix = "rules_proto-7.1.0",
        url = "https://github.com/bazelbuild/rules_proto/releases/download/7.1.0/rules_proto-7.1.0.tar.gz",
    )
