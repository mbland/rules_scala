load("//scala:scala_toolchain.bzl", "scala_toolchain")
load("//scala:scala.bzl", "scala_test")

scala_toolchain(
    name = "passing_scala_toolchain",
    jacocorunner = "@bazel_tools//tools/jdk:JacocoCoverage",
    visibility = ["//visibility:public"],
)

scala_test(
    name = "empty_test",
    srcs = ["EmptyTest.scala"],
)
