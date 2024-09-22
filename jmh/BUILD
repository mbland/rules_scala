load("//jmh/toolchain:toolchain.bzl", "DEP_PROVIDERS")

[
    alias(
        name = "%s" % target,
        actual = "@io_bazel_rules_scala_toolchains//jmh:%s" % target,
    )
    for target in DEP_PROVIDERS
]
