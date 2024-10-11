load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_jar")
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
    http_jar(
        name = "scala_compiler_srcjar",
        sha256 = "95c217cc87ee846b39990e0a9c273824a384dffbac57df84d466f866df4a91ea",
        url = "https://repo1.maven.org/maven2/org/scala-lang/scala-compiler/2.12.16/scala-compiler-2.12.16-sources.jar",
    )

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
