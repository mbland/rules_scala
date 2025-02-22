load("//scala:scala_toolchain.bzl", "scala_toolchain")
load("//scala:scala.bzl", "scala_test")

scala_toolchain(
    name = "failing_scala_toolchain",
    # This will fail because :failing_jacocorunner is not a valid JacocoRunner.
    jacocorunner = ":failing_jacocorunner",
    visibility = ["//visibility:public"],
)

scala_test(
    name = "empty_test",
    srcs = ["EmptyTest.scala"],
)

filegroup(
    name = "failing_jacocorunner",
    srcs = ["EmptyTest.scala"],
)
