"""Exports the @io_bazel_rules_scala_config repo"""

load(
    "//scala/private:macros/bzlmod.bzl",
    "root_module_tags",
    "single_tag_values",
)
load(
    "//:scala_config.bzl",
    "DEFAULT_SCALA_VERSION",
    _scala_config = "scala_config",
)

_settings_defaults = {
    "scala_version": DEFAULT_SCALA_VERSION,
    "scala_versions": [],
    "enable_compiler_dependency_tracking": False,
}

_settings_attrs = {
    "scala_version": attr.string(
        default = _settings_defaults["scala_version"],
    ),
    "scala_versions": attr.string_list(
        default = _settings_defaults["scala_versions"],
    ),
    "enable_compiler_dependency_tracking": attr.bool(
        default = _settings_defaults["enable_compiler_dependency_tracking"],
    ),
}

_tag_classes = {
    "settings": tag_class(attrs = _settings_attrs),
}

def _scala_config_impl(module_ctx):
    tags = root_module_tags(module_ctx, _tag_classes.keys())
    settings = single_tag_values(module_ctx, tags.settings, _settings_defaults)
    menv = module_ctx.os.environ
    version = menv.get("SCALA_VERSION", settings["scala_version"])
    versions = {version: None} | {v: None for v in settings["scala_versions"]}

    _scala_config(
        scala_version = version,
        scala_versions = versions.keys(),
        enable_compiler_dependency_tracking = menv.get(
            "ENABLE_COMPILER_DEPENDENCY_TRACKING",
            settings["enable_compiler_dependency_tracking"],
        ),
    )

scala_config = module_extension(
    implementation = _scala_config_impl,
    tag_classes = _tag_classes,
    environ = ["SCALA_VERSION", "ENABLE_COMPILER_DEPENDENCY_TRACKING"],
)
