load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    "default_maven_server_urls",
)
load(
    "@io_bazel_rules_scala//scala:scala_maven_import_external.bzl",
    "scala_maven_import_external",
)
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

def import_compiler_source_repos():
    for artifact in ["library", "compiler", "reflect"]:
        scala_maven_import_external(
            name = "scala_%s" % artifact,
            artifact = "org.scala-lang:scala-%s:%s" % (
                artifact, SCALA_VERSION,
            ),
            licenses = ["notice"],
            server_urls = default_maven_server_urls(),
        )

def _compiler_source_repos_impl(_ctx):
    import_compiler_source_repos()

compiler_source_repos = module_extension(
    implementation = _compiler_source_repos_impl,
)
