"""Exports repos used by @io_bazel_rules_scala rules"""

load("//scala/private:macros/bzlmod.bzl", "get_root_module", "get_tag_values")
load("//scala/private:macros/toolchains.bzl", "scala_toolchains")
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")

_settings_defaults = {
    "maven_servers": default_maven_server_urls(),
    "overridden_artifacts": {},
    "load_scala_toolchain_dependencies": True,
    "fetch_sources": True,
    "validate_scala_version": True,
}

_settings = tag_class(
    attrs = {
        "maven_servers": attr.string_list(
            default = _settings_defaults["maven_servers"],
        ),
        # Correct spelling of "overridden"
        "overridden_artifacts": attr.string_dict(
            default = _settings_defaults["overridden_artifacts"],
        ),
        "load_scala_toolchain_dependencies": attr.bool(
            default = _settings_defaults["load_scala_toolchain_dependencies"],
        ),
        "fetch_sources": attr.bool(
            default = _settings_defaults["fetch_sources"],
        ),
        "validate_scala_version": attr.bool(
            default = _settings_defaults["validate_scala_version"],
        ),
    },
)

_scalafmt_defaults = {
    "default_config_path": ".scalafmt.conf",
}

_scalafmt = tag_class(
    attrs = {
        "default_config_path": attr.string(
            default = _scalafmt_defaults["default_config_path"],
        ),
    },
)

_compiler_srcjar = tag_class(
    attrs = {
        "version": attr.string(mandatory = True),
        "url": attr.string(),
        "urls": attr.string_list(),
        "label": attr.label(),
        "sha256": attr.string(),
        "integrity": attr.string(),
    },
)

_toolchains_defaults = {
    "scala": True,
    "scalatest": False,
    "junit": False,
    "specs2": False,
    "testing": False,
    "scalafmt": False,
    "scala_proto": False,
    "scala_proto_enable_all_options": False,
    "twitter_scrooge": False,
    "jmh": False,
}

_toolchains = tag_class(
    attrs = {
        k: attr.bool(default = v)
        for k, v in _toolchains_defaults.items()
    },
)

def _get_settings(root_module):
    """Compiles the `settings` and `scalafmt` tag values from the root module.

    Args:
        root_module: the root module from the main repository

    Returns:
        A tuple of values compiled from the root module's `settings` and
            `scalafmt` tags, or the default values for each
    """
    settings = _settings_defaults
    scalafmt = _scalafmt_defaults

    if root_module != None:
        tags = root_module.tags
        settings = get_tag_values(tags.settings, _settings_defaults)
        scalafmt = get_tag_values(tags.scalafmt, _scalafmt_defaults)

    return settings | {"scalafmt_%s" % k: v for k, v in scalafmt.items()}

def _add_if_not_empty(result, name, value):
    if len(value) != 0:
        result[name] = value

def _get_scala_compiler_srcjars(root_module):
    if root_module == None:
        return {}

    result = {}
    for srcjar in root_module.tags.compiler_srcjar:
        info = {}
        _add_if_not_empty(info, "url", srcjar.url)
        _add_if_not_empty(info, "urls", srcjar.urls)
        _add_if_not_empty(info, "sha256", srcjar.sha256)
        _add_if_not_empty(info, "integrity", srcjar.integrity)

        # Label values don't have a length.
        if srcjar.label != None:
            info["label"] = srcjar.label

        # Later instances for the same version overwrite earlier ones.
        result[srcjar.version] = info

    return result

def _get_toolchains(module_ctx):
    result = dict(_toolchains_defaults)
    root_scala_toolchain = True

    for mod in module_ctx.modules:
        values = get_tag_values(mod.tags.toolchains, _toolchains_defaults)
        result.update({k: True for k in values if values[k]})
        if mod.is_root:
            root_scala_toolchain = values["scala"]

    if result["testing"]:
        result["scalatest"] = True
        result["specs2"] = True
    if result["specs2"]:
        result["junit"] = True
    result["scala"] = root_scala_toolchain
    return result

def _scala_deps_impl(module_ctx):
    root_module = get_root_module(module_ctx)
    scala_toolchains(
        load_rules_scala_dependencies = False,  # MODULE.bazel loads these now.
        scala_compiler_srcjars = _get_scala_compiler_srcjars(root_module),
        **(_get_settings(root_module) | _get_toolchains(module_ctx))
    )

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = {
        "settings": _settings,
        "scalafmt": _scalafmt,
        "compiler_srcjar": _compiler_srcjar,
        "toolchains": _toolchains,
    },
)
