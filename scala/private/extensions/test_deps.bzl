"""Repositories for testing rules_scala itself"""

load("//test/toolchains:jdk.bzl", "remote_jdk21_repositories")
load("@rules_java//java:repositories.bzl", "remote_jdk8_repos")
load(
    "@bazel_tools//tools/build_defs/repo:local.bzl",
    "local_repository",
    "new_local_repository",
)

def _test_deps_impl(_ctx):
    # We need to select based on platform when we use these
    # https://github.com/bazelbuild/bazel/issues/11655
    remote_jdk8_repos()
    remote_jdk21_repositories(bzlmod_enabled = True)

    local_repository(
        name = "example_external_workspace",
        path = "third_party/test/example_external_workspace",
    )

    new_local_repository(
        name = "proto_cross_repo_boundary",
        path = "test/proto_cross_repo_boundary/repo",
        build_file = "//test/proto_cross_repo_boundary:repo/BUILD.repo",
    )

    new_local_repository(
        name = "test_new_local_repo",
        build_file_content ="""
filegroup(
    name = "data",
    srcs = glob(["**/*.txt"]),
    visibility = ["//visibility:public"],
)
""",
        path = "third_party/test/new_local_repo",
    )


test_deps = module_extension(implementation = _test_deps_impl)
