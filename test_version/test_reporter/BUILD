load("@rules_scala//scala:scala_toolchain.bzl", "scala_toolchain")
load("@rules_scala//scala:scala.bzl", "scala_library")

scala_toolchain(
    name = "diagnostics_reporter_toolchain",
    enable_diagnostics_report = True,
    visibility = ["//visibility:public"],
)

scala_toolchain(
    name = "diagnostics_reporter_and_semanticdb_toolchain",
    enable_diagnostics_report = True,
    enable_semanticdb = True,
    visibility = ["//visibility:public"],
)

scala_toolchain(
    name = "no_diagnostics_reporter_toolchain",
    visibility = ["//visibility:public"],
)

scala_library(
    name = "error_file",
    srcs = ["ErrorFile.scala"],
    visibility = ["//visibility:public"],
)
