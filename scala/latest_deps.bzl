"""Macro for instantiating repos required for core functionality."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//scala/private:macros/workspace_compat.bzl", "workspace_compat")

def rules_scala_dependencies():
    """Instantiates repos needed by rules provided by `rules_scala`."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "3b5b49006181f5f8ff626ef8ddceaa95e9bb8ad294f7b5d7b11ea9f7ddaf8c59",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.9.0/bazel-skylib-1.9.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.9.0/bazel-skylib-1.9.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "platforms",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/1.0.0/platforms-1.0.0.tar.gz",
            "https://github.com/bazelbuild/platforms/releases/download/1.0.0/platforms-1.0.0.tar.gz",
        ],
        sha256 = "3384eb1c30762704fbe38e440204e114154086c8fc8a8c2e3e28441028c019a8",
    )

    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/9.6.1/rules_java-9.6.1.tar.gz",
        ],
        sha256 = "9de4e178c2c4f98d32aafe5194c3f2b717ae10405caa11bdcb460ac2a6f61516",
    )

    # Required before `rules_java_dependencies` since `rules_java` 8.16.0.
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "c26b4e69cf02fea24511a108d158188b9d8174426311aac59ce803a78d107648",
        strip_prefix = "bazel_features-1.43.0",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.43.0/bazel_features-v1.43.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "61c47fabb1190e0acb2d47e67f31baac05d9b4ce69d7d1b43f6c83744f83898e",
        strip_prefix = "protobuf-34.0",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v34.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "14a225870ab4e91869652cfd69ef2028277fc1dc4910d65d353b62d6e0ae21f4",
        strip_prefix = "rules_proto-7.1.0",
        url = "https://github.com/bazelbuild/rules_proto/releases/download/7.1.0/rules_proto-7.1.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "098ba13578e796c00c853a2161f382647f32eb9a77099e1c88bc5299333d0d6e",
        strip_prefix = "rules_python-1.9.0",
        url = "https://github.com/bazel-contrib/rules_python/releases/download/1.9.0/rules_python-1.9.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_shell",
        sha256 = "e6b87c89bd0b27039e3af2c5da01147452f240f75d505f5b6880874f31036307",
        strip_prefix = "rules_shell-0.6.1",
        url = "https://github.com/bazelbuild/rules_shell/releases/download/v0.6.1/rules_shell-v0.6.1.tar.gz",
    )

    workspace_compat()
