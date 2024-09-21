[
    alias(
        name = "%s_classpath" % target,
        actual = (
            "@io_bazel_rules_scala_toolchains//twitter_scrooge:%s_classpath" %
            target
        ),
    )
    for target in [
        "compile", "aspect_compile", "scrooge_generator", "compiler"
    ]
]
