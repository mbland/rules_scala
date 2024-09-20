load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load("//scala:scala_cross_version.bzl", "repositories", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION", "SCALA_VERSIONS")
load(
    ":deps.bzl",
    _SPECS2_DEPS = "SPECS2_DEPS",
    _SPECS2_JUNIT_DEPS = "SPECS2_JUNIT_DEPS",
    _JUNIT_DEPS = "JUNIT_DEPS",
    _SCALATEST_DEPS = "SCALATEST_DEPS",
)

[
    setup_scala_testing_toolchain(
        name = "testing_toolchain" + version_suffix(scala_version),
        junit_classpath = _JUNIT_DEPS,
        scala_version = scala_version,
        scalatest_classpath = repositories(scala_version, _SCALATEST_DEPS),
        specs2_classpath = _SPECS2_DEPS,
        specs2_junit_classpath = _SPECS2_JUNIT_DEPS,
        visibility = ["//visibility:public"],
    )
    for scala_version in SCALA_VERSIONS
]

[
    setup_scala_testing_toolchain(
        name = "scalatest_toolchain" + version_suffix(scala_version),
        scala_version = scala_version,
        scalatest_classpath = repositories(scala_version, _SCALATEST_DEPS),
        visibility = ["//visibility:public"],
    )
    for scala_version in SCALA_VERSIONS
]

# Aliases for backward compatibility:
alias(
    name = "testing_toolchain",
    actual = "testing_toolchain" + version_suffix(SCALA_VERSION),
)

alias(
    name = "scalatest_toolchain",
    actual = "scalatest_toolchain" + version_suffix(SCALA_VERSION),
)

setup_scala_testing_toolchain(
    name = "specs2_junit_toolchain",
    junit_classpath = _JUNIT_DEPS,
    specs2_classpath = _SPECS2_DEPS,
    specs2_junit_classpath = _SPECS2_JUNIT_DEPS,
    visibility = ["//visibility:public"],
)

setup_scala_testing_toolchain(
    name = "junit_toolchain",
    junit_classpath = _JUNIT_DEPS,
    visibility = ["//visibility:public"],
)
