load(
    "//scala:scala_cross_version.bzl",
    _default_maven_server_urls = "default_maven_server_urls",
)
load("//third_party/repositories:repositories.bzl", "repositories")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

def junit_artifact_ids():
    return [
        "io_bazel_rules_scala_junit_junit",
        "io_bazel_rules_scala_org_hamcrest_hamcrest_core",
    ]

def junit_repositories(
        maven_servers = _default_maven_server_urls(),
        scala_version = SCALA_VERSION,
        overriden_artifacts = {},
        fetch_sources = True):
    repositories(
        scala_version = scala_version,
        for_artifact_ids = junit_artifact_ids(),
        fetch_sources = fetch_sources,
        maven_servers = maven_servers,
        overriden_artifacts = overriden_artifacts,
    )
