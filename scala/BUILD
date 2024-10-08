load("@rules_java//java:defs.bzl", "java_import", "java_library")
load("//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

# Alias for backward compatibility
alias(
    name = "default_toolchain",
    actual = (
        "@io_bazel_rules_scala_toolchains//scala:toolchain" +
        version_suffix(SCALA_VERSION)
    ),
)

[
    alias(
        name = toolchain,
        actual = "@io_bazel_rules_scala_toolchains//scala:" + toolchain,
    )
    for toolchain in [
        "unused_dependency_checker_error_toolchain",
        "minimal_direct_source_deps",
    ]
]

java_import(
    name = "bazel_test_runner_deploy",
    jars = ["@bazel_tools//tools/jdk:TestRunner_deploy.jar"],
    visibility = ["//visibility:public"],
)

java_library(
    name = "PlaceHolderClassToCreateEmptyJarForScalaImport",
    srcs = ["PlaceHolderClassToCreateEmptyJarForScalaImport.java"],
    visibility = ["//visibility:public"],
)
