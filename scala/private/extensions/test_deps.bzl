"""Repositories for testing rules_scala itself"""

load("//test/toolchains:jdk.bzl", "remote_jdk21_repositories")
load("@rules_java//java:repositories.bzl", "remote_jdk8_repos")
load(
    "@rules_java//toolchains:remote_java_repository.bzl",
    "remote_java_repository",
)

def _test_deps_impl(_ctx):
    # We need to select based on platform when we use these
    # https://github.com/bazelbuild/bazel/issues/11655
    remote_jdk8_repos()
    remote_jdk21_repositories(bzlmod_enabled = True)

test_deps = module_extension(implementation = _test_deps_impl)
