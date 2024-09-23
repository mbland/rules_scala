load("//scala:scala_cross_version.bzl", "version_suffix")
load("//testing/toolchain:toolchain_deps.bzl", "testing_toolchain_deps")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

_VERSION_SUFFIX = version_suffix(SCALA_VERSION)

toolchain_type(
    name = "testing_toolchain_type",
    visibility = ["//visibility:public"],
)

[
    testing_toolchain_deps(
        name = dep,
        deps_id = dep + _VERSION_SUFFIX,
        visibility = ["//visibility:public"],
    )
    for dep in [
        "junit_classpath",
        "scalatest_classpath",
        "specs2_classpath",
        "specs2_junit_classpath",
    ]
]
