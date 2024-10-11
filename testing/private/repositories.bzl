"""Macro for repositories required to test rules_scala"""

load("//third_party/repositories:repositories.bzl", "repositories")
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")

def testing_repositories(
        maven_servers = default_maven_server_urls(),
        fetch_sources = False):
    repositories(
        fetch_sources = fetch_sources,
        for_artifact_ids = [
            # test adding a scala jar:
            "com_twitter__scalding_date",
            # test of strict deps (scalac plugin UT + E2E)
            "com_google_guava_guava_21_0_with_file",
            "com_github_jnr_jffi_native",
            "org_apache_commons_commons_lang_3_5",
            "com_google_guava_guava_21_0",
            # test of import external
            # scala maven import external decodes maven artifacts to its parts
            # (group id, artifact id, packaging, version and classifier). To make sure
            # the decoding and then the download url composition are working the artifact example
            # must contain all the different parts and sha256s so the downloaded content will be
            # validated against it
            "org_springframework_spring_core",
            "org_springframework_spring_tx",
            "org_typelevel_kind_projector",
            # For testing that we don't include sources jars to the classpath
            "org_typelevel__cats_core",
        ],
        maven_servers = maven_servers,
    )
