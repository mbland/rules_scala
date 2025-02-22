load("//scala:scala_toolchain.bzl", "scala_toolchain")

scala_toolchain(
    name = "local_jacocorunner_toolchain",
    jacocorunner = ":local_jacocorunner",
    visibility = ["//visibility:public"],
)

filegroup(
    name = "local_jacocorunner",
    srcs = ["JacocoCoverage_jarjar_deploy.jar"],
)
