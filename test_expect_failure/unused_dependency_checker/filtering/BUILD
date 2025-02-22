load("//scala:scala.bzl", "scala_library")
load("//scala:scala_toolchain.bzl", "scala_toolchain")

scala_toolchain(
    name = "plus_one_unused_deps_filter",
    dependency_mode = "plus-one",
    dependency_tracking_method = "ast",
    dependency_tracking_unused_deps_patterns = [
        "@//test_expect_failure/unused_dependency_checker/filtering",
        "-@//test_expect_failure/unused_dependency_checker/filtering:a",
    ],
    unused_dependency_checker_mode = "error",
    visibility = ["//visibility:public"],
)

scala_library(
    name = "a",
    testonly = True,
    srcs = ["Empty.scala"],
    deps = ["@com_google_guava_guava_21_0"],
)

scala_library(
    name = "b",
    testonly = True,
    srcs = ["Empty.scala"],
    deps = ["@com_google_guava_guava_21_0"],
)
