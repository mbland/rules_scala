load("//scala:scala_cross_version.bzl", "version_suffix")
load("//testing/toolchain:toolchain_deps.bzl", "testing_toolchain_deps")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

_VERSION_SUFFIX = version_suffix(SCALA_VERSION)

toolchain_type(
    name = "testing_toolchain_type",
    visibility = ["//visibility:public"],
)

testing_toolchain_deps(
    name = "junit_classpath",
    deps_id = "junit_classpath" + _VERSION_SUFFIX,
)

testing_toolchain_deps(
    name = "scalatest_classpath",
    deps_id = "scalatest_classpath" + _VERSION_SUFFIX,
)

testing_toolchain_deps(
    name = "specs2_classpath",
    deps_id = "specs2_classpath" + _VERSION_SUFFIX,
)

testing_toolchain_deps(
    name = "specs2_junit_classpath",
    deps_id = "specs2_junit_classpath" + _VERSION_SUFFIX,
)
