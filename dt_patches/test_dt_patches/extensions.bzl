load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    "default_maven_server_urls",
)
load(
    "@io_bazel_rules_scala//scala:scala_maven_import_external.bzl",
    "scala_maven_import_external",
)
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

SCALA_2_ARTIFACTS = {
    "scala_library": "org.scala-lang:scala-library:%s",
    "scala_compiler": "org.scala-lang:scala-compiler:%s",
    "scala_reflect": "org.scala-lang:scala-reflect:%s",
}

SCALA_3_ARTIFACTS = {
    "scala_library": "org.scala-lang:scala3-library_3:%s",
    "scala_compiler": "org.scala-lang:scala3-compiler_3:%s",
    "scala3_interfaces": "org.scala-lang:scala3-interfaces:%s",
    "tasty_core": "org.scala-lang:tasty-core_3:%s",
}

UNVERSIONED_ARTIFACTS = {
    "scala2_library": "org.scala-lang:scala-library:2.13.15",
    "scala_asm": "org.scala-lang.modules:scala-asm:9.7.0-scala-2",
    "sbt_compiler_interface": "org.scala-sbt:compiler-interface:1.9.6",
}

IS_SCALA_2 = SCALA_VERSION.startswith("2.")

def import_compiler_source_repos():
    versioned_artifact_templates = (
        SCALA_2_ARTIFACTS if IS_SCALA_2 else SCALA_3_ARTIFACTS
    )
    versioned_artifacts = {
        k: v % SCALA_VERSION
        for k, v in versioned_artifact_templates
    }

    for name, artifact in versioned_artifacts | UNVERSIONED_ARTIFACTS:
        scala_maven_import_external(
            name = name,
            artifact = artifact,
            licenses = ["notice"],
            server_urls = default_maven_server_urls(),
        )

def _compiler_source_repos_impl(_ctx):
    import_compiler_source_repos()

compiler_source_repos = module_extension(
    implementation = _compiler_source_repos_impl,
)
