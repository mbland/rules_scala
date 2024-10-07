"""Creates a repo containing Scala toolchain packages"""

def _generate_testing_toolchain_build_file(repo_attr):
    framework_deps = {}

    if repo_attr.testing:
        framework_deps = {
            "scalatest": "SCALATEST_DEPS",
            "junit": "JUNIT_DEPS",
            "specs2": "SPECS2_DEPS"
        }
    if repo_attr.scalatest:
        framework_deps["scalatest"] = "SCALATEST_DEPS"
    if repo_attr.specs2:
        framework_deps["specs2"] = "SPECS2_DEPS"
        framework_deps["specs2_junit"] = "SPECS2_JUNIT_DEPS"
        framework_deps["junit"] = "JUNIT_DEPS"
    if repo_attr.junit:
        framework_deps["junit"] = "JUNIT_DEPS"

    if len(framework_deps) == 0:
        return None
    return _TESTING_TOOLCHAIN_BUILD.format(
        deps_symbols="\",\n    \"".join([s for s in framework_deps.values()]),
        scalatest = framework_deps.get("scalatest"),
        junit = framework_deps.get("junit"),
        specs2 = framework_deps.get("specs2"),
        specs2_junit = framework_deps.get("specs2_junit"),
    )

def _scala_toolchains_repo_impl(repository_ctx):
    repo_attr = repository_ctx.attr
    toolchains = {}

    if repo_attr.scala:
        toolchains["scala"] = _SCALA_TOOLCHAIN_BUILD
    if repo_attr.twitter_scrooge:
        toolchains["twitter_scrooge"] = _TWITTER_SCROOGE_TOOLCHAIN_BUILD
    if repo_attr.jmh:
        toolchains["jmh"] = _JMH_TOOLCHAIN_BUILD
    if repo_attr.scala_proto or repo_attr.scala_proto_enable_all_options:
        toolchains["scala_proto"] = _SCALA_PROTO_TOOLCHAIN_BUILD % (
            repo_attr.scala_proto_enable_all_options
        )

    testing_build_file = _generate_testing_toolchain_build_file(repo_attr)
    if testing_build_file != None:
        toolchains["testing"] = testing_build_file

    if repo_attr.scalafmt:
        toolchains["scalafmt"] = _SCALAFMT_TOOLCHAIN_BUILD

    if repo_attr.rules_scala_test:
        toolchains["rules_scala_test"] = _RULES_SCALA_TEST_TOOLCHAIN_BUILD

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
        "scalafmt": attr.bool(),
        "rules_scala_test": attr.bool(),
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

setup_scala_toolchain(
    name = "unused_dependency_checker_error_toolchain",
    dependency_tracking_method = "ast-plus",
    unused_dependency_checker_mode = "error",
)

setup_scala_toolchain(
    name = "minimal_direct_source_deps",
    dependency_mode = "plus-one",
    dependency_tracking_method = "ast",
    strict_deps_mode = "error",
    unused_dependency_checker_mode = "error",
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
load("@io_bazel_rules_scala//scala:scala_cross_version.bzl", "version_suffix")
load(
    "@io_bazel_rules_scala//testing:deps.bzl",
    "{deps_symbols}",
)
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

[
    setup_scala_testing_toolchain(
        name = "testing_toolchain" + version_suffix(scala_version),
        junit_classpath = {junit},
        scala_version = scala_version,
        scalatest_classpath = {scalatest},
        specs2_classpath = {specs2},
        specs2_junit_classpath = {specs2_junit},
    )
    for scala_version in SCALA_VERSIONS
]
"""

_SCALAFMT_TOOLCHAIN_BUILD = """
load(
    "@io_bazel_rules_scala//scala/scalafmt/toolchain:setup_scalafmt_toolchain.bzl",
    "setup_scalafmt_toolchains",
)

setup_scalafmt_toolchains()
"""

_RULES_SCALA_TEST_TOOLCHAIN_BUILD = """
load(
    "@io_bazel_rules_scala//test/toolchains:setup.bzl",
    "setup_rules_scala_test_toolchains",
)

load(
    "@io_bazel_rules_scala//test_expect_failure/plus_one_deps:setup_toolchains.bzl",
    "setup_test_expect_failure_toolchains",
)

setup_rules_scala_test_toolchains()
setup_test_expect_failure_toolchains()
"""
