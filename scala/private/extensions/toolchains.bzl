"""Creates a repo containing Scala toolchain packages"""

def _scala_toolchains_repo_impl(repository_ctx):
    repo_attr = repository_ctx.attr
    toolchains = {}

    if repo_attr.scala:
        toolchains["scala"] = _SCALA_TOOLCHAIN_BUILD
    if repo_attr.scalatest:
        toolchains["scalatest"] = _SCALATEST_TOOLCHAIN_BUILD
    if repo_attr.junit:
        toolchains["junit"] = _JUNIT_TOOLCHAIN_BUILD
    if repo_attr.specs2:
        toolchains["specs2"] = _SPECS2_TOOLCHAIN_BUILD
    if repo_attr.twitter_scrooge:
        toolchains["twitter_scrooge"] = _TWITTER_SCROOGE_TOOLCHAIN_BUILD
    if repo_attr.jmh:
        toolchains["jmh"] = _JMH_TOOLCHAIN_BUILD
    if repo_attr.scala_proto or repo_attr.scala_proto_enable_all_options:
        toolchains["scala_proto"] = _SCALA_PROTO_TOOLCHAIN_BUILD % (
            repo_attr.scala_proto_enable_all_options
        )
    if repo_attr.testing:
        toolchains["testing"] = _TESTING_TOOLCHAIN_BUILD

    if len(toolchains) == 0:
        fail("no toolchains specified")

    for pkg, build in toolchains.items():
        repository_ctx.file(pkg + "/BUILD", content=build, executable=False)

scala_toolchains_repo = repository_rule(
    implementation = _scala_toolchains_repo_impl,
    attrs = {
        "scala": attr.bool(),
        "scalatest": attr.bool(),
        "junit": attr.bool(),
        "specs2": attr.bool(),
        "twitter_scrooge": attr.bool(),
        "jmh": attr.bool(),
        "scala_proto": attr.bool(),
        "scala_proto_enable_all_options": attr.bool(),
        "testing": attr.bool(),
    },
)

_SCALA_TOOLCHAIN_BUILD = """
load(
    "@io_bazel_rules_scala//scala/private:macros/setup_scala_toolchain.bzl",
    "setup_scala_toolchain",
)
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

[
    setup_scala_toolchain(
        name = "toolchain" + version_suffix(scala_version),
        scala_version = scala_version,
        use_argument_file_in_runner = True,
    )
    for scala_version in SCALA_VERSIONS
]
"""

_SCALATEST_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load("@io_bazel_rules_scala//testing:deps.bzl", "SCALATEST_DEPS")
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

[
    setup_scala_testing_toolchain(
        name = "scalatest_toolchain" + version_suffix(scala_version),
        scala_version = scala_version,
        scalatest_classpath = SCALATEST_DEPS,
    )
    for scala_version in SCALA_VERSIONS
]
"""

_JUNIT_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load("@io_bazel_rules_scala//testing:deps.bzl", "JUNIT_DEPS")

setup_scala_testing_toolchain(
    name = "junit_toolchain",
    junit_classpath = JUNIT_DEPS,
)
"""

_SPECS2_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load(
    "@io_bazel_rules_scala//testing:deps.bzl",
    "JUNIT_DEPS",
    "SPECS2_DEPS",
    "SPECS2_JUNIT_DEPS",
)

setup_scala_testing_toolchain(
    name = "specs2_junit_toolchain",
    junit_classpath = JUNIT_DEPS,
    specs2_classpath = SPECS2_DEPS,
    specs2_junit_classpath = SPECS2_JUNIT_DEPS,
)
"""

_TWITTER_SCROOGE_TOOLCHAIN_BUILD = """
load(
    "@io_bazel_rules_scala//twitter_scrooge/toolchain:toolchain.bzl",
    "setup_scrooge_toolchain",
)

setup_scrooge_toolchain(name = "scrooge_toolchain")
"""

_JMH_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//jmh/toolchain:toolchain.bzl", "setup_jmh_toolchain")

setup_jmh_toolchain(name = "jmh_toolchain")
"""

_SCALA_PROTO_TOOLCHAIN_BUILD = """
load(
    "@io_bazel_rules_scala//scala_proto:toolchains.bzl",
    "setup_scala_proto_toolchains",
)

setup_scala_proto_toolchains(
    name = "scala_proto", enable_all_options = %s
)
"""

_TESTING_TOOLCHAIN_BUILD = """
load("@io_bazel_rules_scala//scala:scala.bzl", "setup_scala_testing_toolchain")
load(
    "@io_bazel_rules_scala//testing:deps.bzl",
    "JUNIT_DEPS",
    "SCALATEST_DEPS",
    "SPECS2_DEPS",
    "SPECS2_JUNIT_DEPS",
)
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

[
    setup_scala_testing_toolchain(
        name = "testing_toolchain" + version_suffix(scala_version),
        junit_classpath = JUNIT_DEPS,
        scala_version = scala_version,
        scalatest_classpath = SCALATEST_DEPS,
        specs2_classpath = SPECS2_DEPS,
        specs2_junit_classpath = SPECS2_JUNIT_DEPS,
    )
    for scala_version in SCALA_VERSIONS
]
"""
