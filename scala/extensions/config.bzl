"""Exports the @io_bazel_rules_scala_config repo"""

load("//:scala_config.bzl", _scala_config = "scala_config")
load("//scala/private:default_scala_version.bzl", "DEFAULT_SCALA_VERSION")

_settings = tag_class(
    attrs = {
        "scala_version": attr.string(default = DEFAULT_SCALA_VERSION),
        "scala_versions": attr.string_list(),
        "enable_compiler_dependency_tracking": attr.bool(),
    },
)

def _get_root_settings(module_ctx):
    root_settings = module_ctx.modules[0].tags.settings

    if len(root_settings) == 0:
        return DEFAULT_SCALA_VERSION, False
    root = root_settings[0]
    return root.scala_version, root.enable_compiler_dependency_tracking

def _collect_versions(module_ctx):
    versions = {}

    for mod in module_ctx.modules:
        for settings in mod.tags.settings:
            for version in settings.scala_versions:
                versions[version] = None
    return versions.keys()

def _scala_config_impl(module_ctx):
    version, compiler_dep_tracking = _get_root_settings(module_ctx)

    _scala_config(
        scala_version = version,
        scala_versions = _collect_versions(module_ctx),
        enable_compiler_dependency_tracking = compiler_dep_tracking,
    )
    return module_ctx.extension_metadata(
        root_module_direct_deps="all",
        root_module_direct_dev_deps=[],
    )

scala_config = module_extension(
    implementation = _scala_config_impl,
    tag_classes = {"settings": _settings},
)