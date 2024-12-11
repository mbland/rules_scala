"""Exports repos used by @rules_scala rules"""

load("//scala/private:macros/bzlmod.bzl", "get_root_module", "get_tag_values")
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("//scala:toolchains.bzl", "scala_toolchains")

_settings_defaults = {
    "maven_servers": default_maven_server_urls(),
    "overridden_artifacts": {},
    "load_scala_toolchain_dependencies": True,
    "fetch_sources": True,
    "validate_scala_version": True,
}

_settings_attrs = {
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
}

_settings = tag_class(
    attrs = _settings_attrs,
)

_scalafmt_defaults = {
    "default_config_path": ".scalafmt.conf",
}

_scalafmt_attrs = {
    "default_config_path": attr.string(
        default = _scalafmt_defaults["default_config_path"],
    ),
}

_scalafmt = tag_class(
    attrs = _scalafmt_attrs,
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
        settings = get_tag_values(tags.settings, settings)
        scalafmt = get_tag_values(tags.scalafmt, scalafmt)

    return settings | {"scalafmt_%s" % k: v for k, v in scalafmt.items()}

_compiler_srcjar_attrs = {
    "version": attr.string(mandatory = True),
    "url": attr.string(),
    "urls": attr.string_list(),
    "label": attr.label(),
    "sha256": attr.string(),
    "integrity": attr.string(),
}

_compiler_srcjar = tag_class(
    attrs = _compiler_srcjar_attrs,
)

def _get_scala_compiler_srcjars(root_module):
    if root_module == None:
        return {}

    result = {}

    for srcjar in root_module.tags.compiler_srcjar:
        values = {k: getattr(srcjar, k) for k in _compiler_srcjar_attrs}

        # Later instances for the same version overwrite earlier ones.
        result[srcjar.version] = {k: v for k, v in values.items() if v}

    return result

_toolchains_defaults = {
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

_toolchains_attrs = {
    k: attr.bool(default = v)
    for k, v in _toolchains_defaults.items()
}

_toolchains = tag_class(
    attrs = _toolchains_attrs,
)

def _get_toolchains(module_ctx):
    result = dict(_toolchains_defaults)

    for mod in module_ctx.modules:
        values = get_tag_values(mod.tags.toolchains, _toolchains_defaults)

        # Don't overwrite `True` values from one tag with `False` from another.
        result.update({k: True for k in values if values[k]})

    if result["testing"]:
        result["scalatest"] = True
        result["specs2"] = True
    if result["specs2"]:
        result["junit"] = True
    return result

_twitter_scrooge_attrs = {
    "libthrift": attr.string(),
    "scrooge_core": attr.string(),
    "scrooge_generator": attr.string(),
    "util_core": attr.string(),
    "util_logging": attr.string(),
}

_twitter_scrooge = tag_class(
    attrs = _twitter_scrooge_attrs,
)

def _get_twitter_scrooge(root_module):
    if root_module == None or len(root_module.tags.twitter_scrooge) == 0:
        return {}

    tag = root_module.tags.twitter_scrooge[-1]
    tag_values = {k: getattr(tag, k) for k in _twitter_scrooge_attrs}
    return {k: v for k, v in tag_values.items() if len(v) != 0}

def _scala_deps_impl(module_ctx):
    root_module = get_root_module(module_ctx)
    scala_toolchains(
        load_rules_scala_dependencies = False,  # MODULE.bazel loads these now.
        scala_compiler_srcjars = _get_scala_compiler_srcjars(root_module),
        **(
            _get_settings(root_module) |
            _get_toolchains(module_ctx) |
            _get_twitter_scrooge(root_module)
        )
    )

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = {
        "settings": _settings,
        "scalafmt": _scalafmt,
        "compiler_srcjar": _compiler_srcjar,
        "toolchains": _toolchains,
        "twitter_scrooge": _twitter_scrooge,
    },
)
