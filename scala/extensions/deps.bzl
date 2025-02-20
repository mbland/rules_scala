"""Configures builtin toolchains.

Provides the `scala_deps` module extension with the following tag classes:

- `settings`
- `scalafmt`
- `compiler_srcjar`
- `toolchains`
- `twitter_scrooge`

For documentation, see the `_tag_classes` dict, and the `_<TAG>_attrs` dict
corresponding to each `<TAG>` listed above.
"""

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
    "fetch_sources": True,
    "validate_scala_version": True,
}

_settings_attrs = {
    "maven_servers": attr.string_list(
        default = _settings_defaults["maven_servers"],
        doc = "Maven servers used to fetch dependency jar files",
    ),
    # Correct spelling of "overridden"
    "overridden_artifacts": attr.string_dict(
        default = _settings_defaults["overridden_artifacts"],
        doc = """
Specific dependency jar files to use instead of those from `maven_servers`, in
the format:

```starlark
"repo_name": {
    "artifact": "<maven coordinates>",
    "sha256": "<checksum>",
    "deps": [
        "repository_names_of_dependencies",
    ],
}
```
""",
    ),
    "fetch_sources": attr.bool(
        default = _settings_defaults["fetch_sources"],
        doc = "Download dependency source jars",
    ),
    "validate_scala_version": attr.bool(
        default = _settings_defaults["validate_scala_version"],
        doc = (
            "Check if the configured Scala version matches " +
            "the default version supported by rules_scala"
        ),
    ),
}

_scalafmt_defaults = {
    "default_config_path": ".scalafmt.conf",
}

_scalafmt_attrs = {
    "default_config_path": attr.string(
        default = _scalafmt_defaults["default_config_path"],
        doc = (
            "The relative path to the default Scalafmt config file " +
            "within the repository"
        ),
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
    "scalatest": attr.bool(
        default = _toolchains_defaults["scalatest"],
        doc = "Register the Scalatest toolchain",
    ),
    "junit": attr.bool(
        default = _toolchains_defaults["junit"],
        doc = "Register the JUnit toolchain",
    ),
    "specs2": attr.bool(
        default = _toolchains_defaults["specs2"],
        doc = "Register the Specs2 JUnit toolchain",
    ),
    "testing": attr.bool(
        default = _toolchains_defaults["testing"],
        doc = (
            "Register the Scalatest, JUnit, and Specs2 JUnit toolchains " +
            "(in place of individual settings)"
        ),
    ),
    "scalafmt": attr.bool(
        default = _toolchains_defaults["scalafmt"],
        doc = (
            "Register the Scalafmt toolchain; configured by the " +
            "`scalafmt` tag"
        ),
    ),
    "scala_proto": attr.bool(
        default = _toolchains_defaults["scala_proto"],
        doc = "Register the scala_proto toolchain",
    ),
    "scala_proto_enable_all_options": attr.bool(
        default = _toolchains_defaults["scala_proto_enable_all_options"],
        doc = (
            "Register the scala_proto toolchain with all options enabled; " +
            "`scala_proto` must also be `True` for this to take effect"
        ),
    ),
    "twitter_scrooge": attr.bool(
        default = _toolchains_defaults["twitter_scrooge"],
        doc = (
            "Use the twitter_scrooge toolchain; configured by the " +
            "`twitter_scrooge` tag"
        ),
    ),
    "jmh": attr.bool(
        default = _toolchains_defaults["jmh"],
        doc = "Use the jmh toolchain",
    ),
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

_twitter_scrooge_attrs = {
    k: attr.label(default = v)
    for k, v in _twitter_scrooge_defaults.items()
}

def _twitter_scrooge(mctx, root_tags):
    tags = root_tags.twitter_scrooge
    values = single_tag_values(mctx, tags, _twitter_scrooge_defaults)
    return {k: v for k, v in values.items() if v != None}

_tag_classes = {
    "settings": tag_class(
        attrs = _settings_attrs,
        doc = "Settings affecting the configuration of all toolchains",
    ),
    "scalafmt": tag_class(
        attrs = _scalafmt_attrs,
        doc = "Options for the Scalafmt toolchain",
    ),
    "compiler_srcjar": tag_class(
        attrs = _compiler_srcjar_attrs,
        doc = """
Metadata for locating compiler source jars. Can be specified multiple times,
containing:

    - `version`
    - exactly one of `label`, `url`, or `urls`
    - optional `integrity` or `sha256`
""",
    ),
    "toolchains": tag_class(
        attrs = _toolchains_attrs,
        doc = (
            "Selects which builtin toolchains to use; the toolchain for the " +
            "configured Scala version is always enabled"
        ),
    ),
    "twitter_scrooge": tag_class(
        attrs = _twitter_scrooge_attrs,
        doc = (
            "Targets that override default `twitter_scrooge` toolchain " +
            "dependency providers"
        ),
    ),
}

def _scala_deps_impl(module_ctx):
    tags = root_module_tags(module_ctx, _tag_classes.keys())
    kwargs = (
        single_tag_values(module_ctx, tags.settings, _settings_defaults) |
        _scalafmt(module_ctx, tags) |
        _toolchains(module_ctx)
    )

    scala_toolchains(
        scala_compiler_srcjars = _compiler_srcjars(tags),
        twitter_scrooge_deps = _twitter_scrooge(module_ctx, tags),
        **kwargs
    )

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = _tag_classes,
    doc = "Configures builtin toolchains",
)
