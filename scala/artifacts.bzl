load("//scala:scala_cross_version.bzl", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

SCALA_VERSION_SUFFIX = version_suffix(SCALA_VERSION)

def versioned_artifact_repos(artifacts):
    return [repo + SCALA_VERSION_SUFFIX for repo in artifacts]
