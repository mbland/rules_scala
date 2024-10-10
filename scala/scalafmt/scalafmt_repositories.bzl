load(
    "//scala:scala_cross_version.bzl",
    "extract_major_version",
    "version_suffix",
    _default_maven_server_urls = "default_maven_server_urls",
)
load("//third_party/repositories:repositories.bzl", "repositories")
load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

def scalafmt_default_config(path = ".scalafmt.conf"):
    build = []
    build.append("filegroup(")
    build.append("    name = \"config\",")
    build.append("    srcs = [\"{}\"],".format(path))
    build.append("    visibility = [\"//visibility:public\"],")
    build.append(")")

    new_local_repository(
        name = "scalafmt_default",
        build_file_content = "\n".join(build),
        path = "",
    )

_SCALAFMT_BASE_DEPS = [
    "com_google_protobuf_protobuf_java",
    "com_lihaoyi_fastparse",
    "com_thesamet_scalapb_lenses",
    "com_thesamet_scalapb_scalapb_runtime",
    "org_scala_lang_modules_scala_collection_compat",
    "org_scala_lang_scalap",
    "org_scalameta_scalafmt_core",
]

_SCALAFMT_CORE_DEPS_2_11 = [
    "com_geirsson_metaconfig_core",
    "com_geirsson_metaconfig_typesafe_config",
    "org_scalameta_scalameta",
    "com_lihaoyi_pprint",
    "com_lihaoyi_fansi",
    "com_lihaoyi_sourcecode",
    "org_typelevel_paiges_core",
]

_SCALAFMT_CORE_DEPS = [
    "com_geirsson_metaconfig_core",
    "com_geirsson_metaconfig_pprint",
    "com_geirsson_metaconfig_typesafe_config",
    "com_lihaoyi_fansi",
    "com_lihaoyi_sourcecode",
    "com_typesafe_config",
    "org_scalameta_common",
    "org_scalameta_mdoc_parser",
    "org_scalameta_parsers",
    "org_scalameta_scalafmt_config",
    "org_scalameta_scalafmt_sysops",
    "org_scalameta_scalameta",
    "org_scalameta_trees",
    "org_typelevel_paiges_core",
]

def _artifact_ids(scala_version):
    major_version = extract_major_version(scala_version)

    if major_version == "2.11":
        return _SCALAFMT_BASE_DEPS + _SCALAFMT_CORE_DEPS_2_11

    extra_deps = ["com_lihaoyi_geny"]

    if major_version == "2.12":
        extra_deps.append("com_github_bigwheel_util_backports")
    else:
        extra_deps.append("io_bazel_rules_scala_scala_parallel_collections")

    return _SCALAFMT_BASE_DEPS + _SCALAFMT_CORE_DEPS + extra_deps

def scalafmt_repositories(
        maven_servers = _default_maven_server_urls(),
        overriden_artifacts = {},
        bzlmod_enabled = False):
    for scala_version in SCALA_VERSIONS:
        repositories(
            scala_version = scala_version,
            for_artifact_ids = _artifact_ids(scala_version),
            maven_servers = maven_servers,
            overriden_artifacts = overriden_artifacts,
        )

    if not bzlmod_enabled:
        _register_scalafmt_toolchains()

def _register_scalafmt_toolchains():
    for scala_version in SCALA_VERSIONS:
        native.register_toolchains(
            "@io_bazel_rules_scala//scala/scalafmt:scalafmt_toolchain" + version_suffix(scala_version),
        )
