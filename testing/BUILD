load("//scala:scala_cross_version.bzl", "repositories", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION", "SCALA_VERSIONS")

# Aliases for backward compatibility:
alias(
    name = "testing_toolchain",
    actual = (
        "@io_bazel_rules_scala_toolchains//testing:testing_toolchain" +
        version_suffix(SCALA_VERSION)
    ),
)

alias(
    name = "scalatest_toolchain",
    actual = (
        "@io_bazel_rules_scala_toolchains//scalatest:scalatest_toolchain" +
        + version_suffix(SCALA_VERSION)
    ),
)

alias(
    name = "specs2_junit_toolchain",
    actual = (
        "@io_bazel_rules_scala_toolchains//specs2:specs2_junit_toolchain"
    ),
)

alias(
    name = "junit_toolchain",
    actual = "@io_bazel_rules_scala_toolchains//junit:junit_toolchain",
)
