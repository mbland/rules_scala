"""Exports repos used by @io_bazel_rules_scala rules"""

load("//jmh:jmh.bzl", "jmh_repositories")
load("//junit:junit.bzl", "junit_repositories")
load("//scala/private/extensions:toolchains.bzl", "scala_toolchains_repo")
load("//scala/private:macros/scala_repositories.bzl", "scala_repositories")
load(
    "//scala/scalafmt:scalafmt_repositories.bzl",
    "scalafmt_default_config",
    "scalafmt_repositories",
)
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("//scala_proto:scala_proto.bzl", "scala_proto_repositories")
load("//scalatest:scalatest.bzl", "scalatest_repositories")
load("//specs2:specs2_junit.bzl", "specs2_junit_repositories")
load("//testing/private:repositories.bzl", "testing_repositories")
load("//twitter_scrooge:twitter_scrooge.bzl", "twitter_scrooge")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

# The _defaults() and _to_attrs() schema compensates for the fact that there's
# no way to pull the default value from an `attr` object. Without this, we'd
# have to have the `attr` dict, plus another dict containing default values for
# the same attributes. This schema eliminates the need for such duplication.
def _defaults(attr_dict):
    return {k: v.params["default"] for k, v in attr_dict.items()}

def _to_attrs(attr_dict):
    return {k: v.attr(**v.params) for k, v in attr_dict.items()}

_settings = {
    "maven_servers": struct(
        attr = attr.string_list,
        params = {
            "default": default_maven_server_urls(),
        },
    ),
    # Correct spelling of "overridden"
    "overridden_artifacts": struct(
        attr = attr.string_dict,
        params = {
            "default": {},
        },
    ),
    "load_toolchain_dependencies": struct(
        attr = attr.bool,
        params = {
            "default": True,
        },
    ),
    "fetch_sources": struct(
        attr = attr.bool,
        params = {
            "default": False,
        },
    ),
    "validate_scala_version": struct(
        attr = attr.bool,
        params = {
            "default": True,
        },
    ),
}

_scalafmt = {
    "default_config_path": struct(
        attr = attr.string,
        params = {
            "default": ".scalafmt.conf",
        },
    ),
}

_compiler_srcjar_attrs = {
    "version": attr.string(mandatory = True),
    "url": attr.string(),
    "urls": attr.string_list(),
    "label": attr.label(),
    "sha256": attr.string(),
    "integrity": attr.string(),
}

_toolchains_attrs = {
    "scala": attr.bool(default = True),
    "scalatest": attr.bool(),
    "junit": attr.bool(),
    "specs2": attr.bool(),
    "twitter_scrooge": attr.bool(),
    "jmh": attr.bool(),
    "scala_proto": attr.bool(),
    "scala_proto_enable_all_options": attr.bool(),
    "testing": attr.bool(),
    "scalafmt": attr.bool(),
}

def _get_root_module(module_ctx):
    """Returns the root bazel_module object from the module extension context.

    Args:
        module_ctx: the module extension context

    Returns:
        The root bazel_module object if found, None otherwise
    """
    for module in module_ctx.modules:
        # Only the root module can override the defaults.
        if module.is_root:
            return module
    return None

def _compile_tags(bazel_module_tags, defaults):
    """Compiles tag class values from a list of bazel_module_tags.

    Args:
        bazel_module_tags: a list of `bazel_module_tag` objects
        defaults: the default values for the tag class

    Returns:
        The values compiled from the bazel_module_tag instances, or `defaults`
            if the `bazel_module_tags` list is empty
    """
    if len(bazel_module_tags) == 0:
        return defaults

    base_tags = bazel_module_tags[0]
    attr_names = dir(base_tags)
    result = {k: getattr(base_tags, k) for k in attr_names}

    # Explicit, non-default values from later tags override earlier tags.
    for extra_tags in bazel_module_tags[1:]:
        for attr_name in attr_names:
            value = getattr(extra_tags, attr_name)
            if value != defaults.get(attr_name):
                result[attr_name] = value

    return result

def _compile_root_tags(module_ctx, tag_class_name, defaults):
    """Compiles tag class values from the root module.

    Args:
        module_ctx: the module extension context
        tag_class_name: the tag class from which to compile values
        defaults: the default values for the tag class

    Returns:
        The values compiled from the root module's tag class instances, or
            `defaults` if the root module didn't define any
    """
    root = _get_root_module(module_ctx)

    # Only the root module can override the defaults.
    if root != None:
        return _compile_tags(getattr(root.tags, tag_class_name), defaults)
    return defaults

def _get_settings(module_ctx):
    """Compiles the `settings` and `scalafmt` tag values from the root module.

    Args:
        module_ctx: the module extension context

    Returns:
        A tuple of values compiled from the root module's `settings` and
            `scalafmt` tags, or the default values for each
    """
    settings = _compile_root_tags(module_ctx, "settings", _defaults(_settings))
    scalafmt = _compile_root_tags(module_ctx, "scalafmt", _defaults(_scalafmt))

    return (
        settings["load_toolchain_dependencies"],
        settings["maven_servers"],
        settings["overridden_artifacts"],
        settings["fetch_sources"],
        settings["validate_scala_version"],
        scalafmt["default_config_path"],
    )

def _add_if_not_empty(result, name, value):
    if len(value) != 0:
        result[name] = value

def _get_scala_compiler_srcjars(module_ctx):
    root_module = _get_root_module(module_ctx)

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
    result = {}

    for mod in module_ctx.modules:
        for toolchains in mod.tags.toolchains:
            if toolchains.scala:
                result["scala"] = True
            if toolchains.scalatest:
                result["scalatest"] = True
            if toolchains.junit:
                result["junit"] = True
            if toolchains.specs2:
                result["specs2"] = True
                result["junit"] = True
            if toolchains.twitter_scrooge:
                result["twitter_scrooge"] = True
            if toolchains.jmh:
                result["jmh"] = True
            if toolchains.scala_proto:
                result["scala_proto"] = True
            if toolchains.scala_proto_enable_all_options:
                result["scala_proto_enable_all_options"] = True
            if toolchains.testing:
                result["testing"] = True
                result["scalatest"] = True
                result["junit"] = True
                result["specs2"] = True
            if toolchains.scalafmt:
                result["scalafmt"] = True
    return result

def _scala_deps_impl(module_ctx):
    (
        load_toolchain_dependencies,
        maven_servers,
        overridden_artifacts,
        fetch_sources,
        validate_scala_version,
        scalafmt_default_config_path,
    ) = _get_settings(module_ctx)
    compiler_srcjars = _get_scala_compiler_srcjars(module_ctx)
    toolchains = _get_toolchains(module_ctx)

    scala_repositories(
        maven_servers = maven_servers,
        # Note the internal macro parameter misspells "overriden".
        overriden_artifacts = overridden_artifacts,
        load_dep_rules = False,  # MODULE.bazel loads dependencies now.
        load_jar_deps = load_toolchain_dependencies,
        fetch_sources = fetch_sources,
        validate_scala_version = validate_scala_version,
        scala_compiler_srcjars = compiler_srcjars,
    )

    if "scalatest" in toolchains:
        scalatest_repositories(
            maven_servers = maven_servers,
            fetch_sources = fetch_sources,
        )

    for scala_version in SCALA_VERSIONS:
        if "junit" in toolchains:
            junit_repositories(
                maven_servers = maven_servers,
                scala_version = scala_version,
                overriden_artifacts = overridden_artifacts,
                fetch_sources = fetch_sources,
            )
        if "specs2" in toolchains:
            specs2_junit_repositories(
                maven_servers = maven_servers,
                scala_version = scala_version,
                overriden_artifacts = overridden_artifacts,
                create_junit_repositories = "junit" not in toolchains,
            )
        if (
            "scala_proto" in toolchains or
            "scala_proto_enable_all_options" in toolchains
        ):
            scala_proto_repositories(
                maven_servers = maven_servers,
                scala_version = scala_version,
                overriden_artifacts = overridden_artifacts,
                register_toolchains = False,
            )

    if "twitter_scrooge" in toolchains:
        twitter_scrooge(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
        )

    if "jmh" in toolchains:
        jmh_repositories(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
        )
    if "testing" in toolchains:
        testing_repositories(
            maven_servers = maven_servers,
            fetch_sources = False,
        )
    if "scalafmt" in toolchains:
        scalafmt_default_config(scalafmt_default_config_path)
        scalafmt_repositories(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
        )

    if len(toolchains) != 0:
        scala_toolchains_repo(
            scala = "scala" in toolchains,
            scalatest = "scalatest" in toolchains,
            junit = "junit" in toolchains,
            specs2 = "specs2" in toolchains,
            twitter_scrooge = "twitter_scrooge" in toolchains,
            jmh = "jmh" in toolchains,
            scala_proto = "scala_proto" in toolchains,
            scala_proto_enable_all_options = (
                "scala_proto_enable_all_options" in toolchains
            ),
            testing = "testing" in toolchains,
            scalafmt = "scalafmt" in toolchains,
        )

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = {
        "settings": tag_class(attrs = _to_attrs(_settings)),
        "scalafmt": tag_class(attrs = _to_attrs(_scalafmt)),
        "compiler_srcjar": tag_class(attrs = _compiler_srcjar_attrs),
        "toolchains": tag_class(attrs = _toolchains_attrs),
    },
)
