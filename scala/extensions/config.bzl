"""Exports the @io_bazel_rules_scala_config repo"""

load("//scala/private:macros/bzlmod.bzl", "get_root_module")
load(
    "//:scala_config.bzl",
    "DEFAULT_SCALA_VERSION",
    _scala_config = "scala_config",
)

_settings = tag_class(
    attrs = {
        "scala_version": attr.string(default = DEFAULT_SCALA_VERSION),
        "scala_versions": attr.string_list(),
        "enable_compiler_dependency_tracking": attr.bool(),
    },
)

def _get_root_settings(module_ctx):
    scala_version = DEFAULT_SCALA_VERSION
    compiler_dep_tracking = False
    root_module = get_root_module(module_ctx)
    root_settings = root_module.tags.settings if root_module != None else []

    if len(root_settings) != 0:
        # The first settings tag in the root module wins.
        root = root_settings[0]
        scala_version = root.scala_version
        compiler_dep_tracking = root.enable_compiler_dependency_tracking

    return (
        module_ctx.os.environ.get("SCALA_VERSION", scala_version),
        module_ctx.os.environ.get(
            "ENABLE_COMPILER_DEPENDENCY_TRACKING",
            compiler_dep_tracking,
        ),
    )

def _collect_versions(module_ctx, scala_version):
    versions = {scala_version: None}

    for mod in module_ctx.modules:
        for settings in mod.tags.settings:
            for version in settings.scala_versions:
                versions[version] = None
    return versions.keys()

def _scala_config_impl(module_ctx):
    version, compiler_dep_tracking = _get_root_settings(module_ctx)

    _scala_config(
        scala_version = version,
        scala_versions = _collect_versions(module_ctx, version),
        enable_compiler_dependency_tracking = compiler_dep_tracking,
    )

scala_config = module_extension(
    implementation = _scala_config_impl,
    tag_classes = {"settings": _settings},
    environ = ["SCALA_VERSION", "ENABLE_COMPILER_DEPENDENCY_TRACKING"],
)
