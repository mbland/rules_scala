load("//scala:scala_cross_version_select.bzl", "select_for_scala_version")
load(
    "@io_bazel_rules_scala_config//:config.bzl",
    "ENABLE_COMPILER_DEPENDENCY_TRACKING",
)
load("@rules_java//java:defs.bzl", "java_binary")

SCALAC_DEPS = [
    "//scala/private/toolchain_deps:scala_compile_classpath",
    "//src/java/io/bazel/rulesscala/io_utils",
    "//src/java/io/bazel/rulesscala/jar",
    "//src/java/io/bazel/rulesscala/scalac/compileoptions",
    "//src/java/io/bazel/rulesscala/scalac/reporter",
    "//src/java/io/bazel/rulesscala/worker",
    "//src/protobuf/io/bazel/rules_scala:diagnostics_java_proto",
    "@bazel_tools//src/main/protobuf:worker_protocol_java_proto",
]

java_binary(
    name = "scalac",
    srcs = [
        ":scalac_files",
    ],
    javacopts = [
        "-source 1.8",
        "-target 1.8",
    ],
    main_class = "io.bazel.rulesscala.scalac.ScalacWorker",
    visibility = ["//visibility:public"],
    deps = ([
        "//third_party/dependency_analyzer/src/main/io/bazel/rulesscala/dependencyanalyzer/compiler:dep_reporting_compiler",
    ] if ENABLE_COMPILER_DEPENDENCY_TRACKING else []) + SCALAC_DEPS,
)

java_binary(
    name = "scalac_bootstrap",
    srcs = [
        ":scalac_files",
    ],
    javacopts = [
        "-source 1.8",
        "-target 1.8",
    ],
    main_class = "io.bazel.rulesscala.scalac.ScalacWorker",
    visibility = ["//visibility:public"],
    deps = SCALAC_DEPS,
)

filegroup(
    name = "scalac_files",
    srcs = [
        "ScalacWorker.java",
        "ScalacInvokerResults.java",
    ] + select_for_scala_version(
        any_2 = glob(["scala_2/*.java"]),
        any_3 = glob(["scala_3/*.java"]),
    ),
    visibility = ["//visibility:public"],
)
