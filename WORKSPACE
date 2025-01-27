workspace(name = "io_bazel_rules_scala")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//scala:deps.bzl", "rules_scala_dependencies")

rules_scala_dependencies()

load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")

rules_java_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "rules_python",
    sha256 = "ca2671529884e3ecb5b79d6a5608c7373a82078c3553b1fa53206e6b9dddab34",
    strip_prefix = "rules_python-0.38.0",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.38.0/rules_python-0.38.0.tar.gz",
)

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

rules_java_toolchains()

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
    scala_proto = True,
    scalafmt = True,
    testing = True,
)

register_toolchains(
    "//scala:unused_dependency_checker_error_toolchain",
    "//test/proto:scalapb_toolchain",
    "@io_bazel_rules_scala_toolchains//...:all",
)

load("//twitter_scrooge:twitter_scrooge.bzl", "twitter_scrooge")

twitter_scrooge()

load("//jmh:jmh.bzl", "jmh_repositories")

jmh_repositories()

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
    sha256 = "90fe8fb402dee957a375f3eb8511455bd738c7ed562695f4dd117ac7d2d833b1",
    urls = [
        "https://mirror.bazel.build/github.com/bazel-contrib/rules_go/releases/download/v0.52.0/rules_go-v0.52.0.zip",
        "https://github.com/bazel-contrib/rules_go/releases/download/v0.52.0/rules_go-v0.52.0.zip",
    ],
)

load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_register_toolchains",
    "go_rules_dependencies",
)

go_rules_dependencies()

go_register_toolchains(version = "1.23.4")

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

register_toolchains("//test/toolchains:java21_toolchain_definition")
