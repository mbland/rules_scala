load("//junit:junit.bzl", _repositories = "junit_repositories")
load("//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

def junit_repositories(**kwargs):
    _repositories(**kwargs)

def junit_toolchain():
    for scala_version in SCALA_VERSIONS:
        native.register_toolchains(str(Label(
            "//testing:junit_toolchain" + version_suffix(scala_version),
        )))
