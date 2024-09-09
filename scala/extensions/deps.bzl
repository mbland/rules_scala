"""Exports repos used by @io_bazel_rules_scala rules"""

load("//scala:scala.bzl", "scala_repositories")
load("//testing:scalatest.bzl", "scalatest_repositories")

def _scala_dependencies_impl(_ctx):
    scala_repositories(load_dep_rules=False)
    scalatest_repositories()

scala_deps = module_extension(
    implementation = _scala_dependencies_impl
)
