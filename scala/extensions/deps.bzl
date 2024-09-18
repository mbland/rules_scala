"""Exports repos used by @io_bazel_rules_scala rules"""

load("//scala:scala.bzl", "scala_repositories")
load("//testing:scalatest.bzl", "scalatest_repositories")

def _scala_dependencies_impl(_ctx):
    scala_repositories(load_dep_rules=False)
    scalatest_repositories()
    # rules_scala_toolchain_deps_repositories(fetch_sources = True)
    # twitter_scrooge()
    # jmh_repositories()
    # scala_proto_repositories()
    # specs2_junit_repositories()
    # scalafmt_default_config()
    # scalafmt_repositories()
    # proto_cross_repo_boundary_repository()
    # new_local_repository()...
    # local_repository()...
    # scala_register_unused_deps_toolchains()
    # java_import_external() - see WORKSPACE

    # We need to select based on platform when we use these
    # https://github.com/bazelbuild/bazel/issues/11655
    #remote_jdk8_repos()

    # repositories() - see WORKSPACE

scala_deps = module_extension(
    implementation = _scala_dependencies_impl
)

#new_local_repository(
#    name = "test_new_local_repo",
#    build_file_content =
#        """
#filegroup(
#    name = "data",
#    srcs = glob(["**/*.txt"]),
#    visibility = ["//visibility:public"],
#)
#""",
#    path = "third_party/test/new_local_repo",
#)

#local_repository(
#    name = "example_external_workspace",
#    path = "third_party/test/example_external_workspace",
#)

# load("@bazelci_rules//:rbe_repo.bzl", "rbe_preconfig")
# rbe_preconfig(
#     name = "rbe_default",
#     toolchain = "ubuntu2004-bazel-java11",
# )

# load("//test/toolchains:jdk.bzl", "remote_jdk21_repositories", "remote_jdk21_toolchains")
# remote_jdk21_repositories()
# remote_jdk21_toolchains()
