load(
    "//scala/scalafmt/toolchain:toolchain.bzl",
    "SCALAFMT_TOOLCHAIN_TYPE",
    "scalafmt_toolchain",
)
load("//scala/scalafmt:scalafmt_repositories.bzl", "scalafmt_artifact_ids")
load("//scala:providers.bzl", "declare_deps_provider")
load("//scala:scala_cross_version.bzl", "version_suffix")
load("@rules_scala_config//:config.bzl", "SCALA_VERSION", "SCALA_VERSIONS")

TOOLCHAIN_DEFAULTS = {
    "name": "scalafmt_toolchain" + version_suffix(SCALA_VERSION),
    # Used by `scala_toolchains{,_repo}` to generate
    # `@rules_scala_toolchains//scalafmt:config`, the default config for
    # `ext_scalafmt` from `phase_scalafmt_ext.bzl`.
    "default_config": Label("//:.scalafmt.conf"),
    "scalafmt_classpath": [],
    "scala_version": SCALA_VERSION,
    "toolchain_type": SCALAFMT_TOOLCHAIN_TYPE,
    "visibility": ["//visibility:public"],
}

_defaults = TOOLCHAIN_DEFAULTS

def setup_scalafmt_toolchain(
        name,
        scalafmt_classpath = _defaults["scalafmt_classpath"],
        scala_version = _defaults["scala_version"],
        toolchain_type = _defaults["toolchain_type"],
        visibility = _defaults["visibility"]):
    scalafmt_classpath_provider = "%s_scalafmt_classpath_provider" % name
    if not scalafmt_classpath:
        scalafmt_classpath = _deps(scala_version)

    declare_deps_provider(
        name = scalafmt_classpath_provider,
        deps_id = "scalafmt_classpath",
        visibility = visibility,
        deps = scalafmt_classpath,
    )
    scalafmt_toolchain(
        name = "%s_impl" % name,
        dep_providers = [scalafmt_classpath_provider],
        visibility = visibility,
    )
    native.toolchain(
        name = name,
        target_settings = [
            "@rules_scala_config//:scala_version" +
            version_suffix(scala_version),
        ],
        toolchain = ":%s_impl" % name,
        toolchain_type = toolchain_type,
        visibility = visibility,
    )

def setup_scalafmt_toolchains():
    for scala_version in SCALA_VERSIONS:
        setup_scalafmt_toolchain(
            name = "scalafmt_toolchain" + version_suffix(scala_version),
            scala_version = scala_version,
        )

def _deps(scala_version):
    return [
        "@" + artifact_id + version_suffix(scala_version)
        for artifact_id in scalafmt_artifact_ids(scala_version)
    ]
