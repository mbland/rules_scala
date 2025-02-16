"""Exports repos used by @rules_scala rules"""

load(
    "//scala/private:macros/bzlmod.bzl",
    "root_module_tags",
    "single_tag_values",
)
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

_scalafmt_defaults = {
    "default_config_path": ".scalafmt.conf",
}

_scalafmt_attrs = {
    "default_config_path": attr.string(
        default = _scalafmt_defaults["default_config_path"],
    ),
}

def _scalafmt(mctx, root_tags):
    """Compiles the `scalafmt` tag values from the root module.

    Args:
        mctx: the module extension context
        root_tags: tags from the root module

    Returns:
        A tuple of values compiled from the root module's `scalafmt` tags, or
        the default values for each
    """
    scalafmt = single_tag_values(mctx, root_tags.scalafmt, _scalafmt_defaults)
    return {"scalafmt_%s" % k: v for k, v in scalafmt.items()}

_compiler_srcjar_attrs = {
    "version": attr.string(mandatory = True),
    "url": attr.string(),
    "urls": attr.string_list(),
    "label": attr.label(),
    "sha256": attr.string(),
    "integrity": attr.string(),
}

def _compiler_srcjars(root_tags):
    result = {}

    for srcjar in root_tags.compiler_srcjar:
        values = {k: getattr(srcjar, k) for k in _compiler_srcjar_attrs}

        if srcjar.version in result:
            fail("multiple compiler srcjar entries for", srcjar.version)

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

def _toolchains(mctx):
    result = dict(_toolchains_defaults)

    for mod in mctx.modules:
        toolchains_tags = mod.tags.toolchains
        values = single_tag_values(mctx, toolchains_tags, _toolchains_defaults)

        # Don't overwrite `True` values from one tag with `False` from another.
        result.update({k: True for k in values if values[k]})

    return result

_twitter_scrooge_defaults = {
    "libthrift": None,
    "scrooge_core": None,
    "scrooge_generator": None,
    "util_core": None,
    "util_logging": None,
}

_twitter_scrooge_attrs = {k: attr.label() for k in _twitter_scrooge_defaults}

def _twitter_scrooge(mctx, root_tags):
    tags = root_tags.twitter_scrooge
    values = single_tag_values(mctx, tags, _twitter_scrooge_defaults)
    return {k: v for k, v in values.items() if v != None}

_tag_classes = {
    "settings": tag_class(attrs = _settings_attrs),
    "scalafmt": tag_class(attrs = _scalafmt_attrs),
    "compiler_srcjar": tag_class(attrs = _compiler_srcjar_attrs),
    "toolchains": tag_class(attrs = _toolchains_attrs),
    "twitter_scrooge": tag_class(attrs = _twitter_scrooge_attrs),
}

def _scala_deps_impl(module_ctx):
    tags = root_module_tags(module_ctx, _tag_classes.keys())

    scala_toolchains(
        load_rules_scala_dependencies = False,  # MODULE.bazel loads these now.
        scala_compiler_srcjars = _compiler_srcjars(tags),
        twitter_scrooge_deps = _twitter_scrooge(module_ctx, tags),
        **(
            single_tag_values(module_ctx, tags.settings, _settings_defaults) |
            _scalafmt(module_ctx, tags) |
            _toolchains(module_ctx)
        )
    )

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = _tag_classes,
)
