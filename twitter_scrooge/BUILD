load("//twitter_scrooge/toolchain:toolchain.bzl", "DEP_PROVIDERS")

[
    alias(
        name = "%s" % target,
        actual = (
            "@io_bazel_rules_scala_toolchains//twitter_scrooge:%s" % target
        ),
    )
    for target in DEP_PROVIDERS
]
