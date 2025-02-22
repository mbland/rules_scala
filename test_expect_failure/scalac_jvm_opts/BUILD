load("//scala:scala_toolchain.bzl", "scala_toolchain")
load("//scala:scala.bzl", "scala_library")

scala_toolchain(
    name = "failing_scala_toolchain",
    # This will fail because 1M isn't enough
    scalac_jvm_flags = ["-Xmx1M"],
    visibility = ["//visibility:public"],
)

scala_library(
    name = "empty_build",
    srcs = ["Empty.scala"],
)
