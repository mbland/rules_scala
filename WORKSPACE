workspace(name = "io_bazel_rules_scala")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//scala:deps.bzl", "rules_scala_dependencies")

rules_scala_dependencies()

load("@rules_java//java:rules_java_deps.bzl", "rules_java_dependencies")

rules_java_dependencies()

# buildifier: disable=bzl-visibility
load(
    "@com_google_protobuf//bazel/private:proto_bazel_features.bzl",
    "proto_bazel_features",
)

proto_bazel_features(name = "proto_bazel_features")

load("@rules_java//java:repositories.bzl", "rules_java_toolchains")

rules_java_toolchains()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "rules_python",
    sha256 = "690e0141724abb568267e003c7b6d9a54925df40c275a870a4d934161dc9dd53",
    strip_prefix = "rules_python-0.40.0",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.40.0/rules_python-0.40.0.tar.gz",
)

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies")

rules_proto_dependencies()

load("@rules_proto//proto:setup.bzl", "rules_proto_setup")

rules_proto_setup()

load("@rules_proto//proto:toolchains.bzl", "rules_proto_toolchains")

rules_proto_toolchains()

load("@io_bazel_rules_scala//:scala_config.bzl", "scala_config")

scala_config(enable_compiler_dependency_tracking = True)

load("//scala:toolchains.bzl", "scala_toolchains")

scala_toolchains(
    fetch_sources = True,
    jmh = True,
    scala_proto = True,
    scalafmt = True,
    testing = True,
    twitter_scrooge = True,
)

register_toolchains(
    "//scala:unused_dependency_checker_error_toolchain",
    "//test/proto:scalapb_toolchain",
    "@io_bazel_rules_scala_toolchains//...:all",
)

# needed for the cross repo proto test
local_repository(
    name = "proto_cross_repo_boundary",
    path = "test/proto_cross_repo_boundary/repo",
)

local_repository(
    name = "test_new_local_repo",
    path = "third_party/test/new_local_repo",
)

local_repository(
    name = "example_external_workspace",
    path = "third_party/test/example_external_workspace",
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "f4a9314518ca6acfa16cc4ab43b0b8ce1e4ea64b81c38d8a3772883f153346b8",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip",
    ],
)

load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_register_toolchains",
    "go_rules_dependencies",
)

go_rules_dependencies()

go_register_toolchains(version = "1.23.0")

http_archive(
    name = "bazelci_rules",
    sha256 = "eca21884e6f66a88c358e580fd67a6b148d30ab57b1680f62a96c00f9bc6a07e",
    strip_prefix = "bazelci_rules-1.0.0",
    url = "https://github.com/bazelbuild/continuous-integration/releases/download/rules-1.0.0/bazelci_rules-1.0.0.tar.gz",
)

load("@bazelci_rules//:rbe_repo.bzl", "rbe_preconfig")

rbe_preconfig(
    name = "rbe_default",
    toolchain = "ubuntu2004-bazel-java11",
)

load("//scala/private/extensions:dev_deps.bzl", "dev_deps_repositories")

dev_deps_repositories()
