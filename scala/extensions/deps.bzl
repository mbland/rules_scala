"""Exports repos used by @io_bazel_rules_scala rules"""

load("//jmh:jmh.bzl", "jmh_repositories")
load("//junit:junit.bzl", "junit_repositories")
load("//scala/private/extensions:toolchains.bzl", "scala_toolchains_repo")
load(
    "//scala/private:macros/scala_repositories.bzl",
    "dt_patched_compiler_setup",
    "dt_patched_compiler_source_aliases_repo",
    "rules_scala_toolchain_deps_repositories",
)
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

_settings = tag_class(
    attrs = {
        "maven_servers": attr.string_list(
            default = default_maven_server_urls(),
        ),
        # Correct spelling of "overridden"
        "overridden_artifacts": attr.string_dict(),
        "load_dep_rules": attr.bool(default = True),
        "load_jar_deps": attr.bool(default = True),
        "fetch_sources": attr.bool(),
        "validate_scala_version": attr.bool(default = True),
    },
)

_compiler_srcjar = tag_class(
    attrs = {
        "version": attr.string(mandatory = True),
        "url": attr.string(),
        "urls": attr.string_list(),
        "label": attr.string(),
        "sha256": attr.string(),
        "integrity": attr.string(),
    },
)

_toolchains = tag_class(
    attrs = {
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
    },
)

def _get_settings(module_ctx):
    root_settings = module_ctx.modules[0].tags.settings

    if len(root_settings) == 0:
        return True, True, default_maven_server_urls(), {}, False, True
    settings = root_settings[0]
    return (
        settings.load_dep_rules,
        settings.load_jar_deps,
        settings.maven_servers,
        settings.overridden_artifacts,
        settings.fetch_sources,
        settings.validate_scala_version,
    )

def _add_if_not_empty(result, name, value):
    if len(value) != 0:
        result[name] = value

def _get_scala_compiler_srcjars(module_ctx):
    result = {}

    for srcjar in module_ctx.modules[0].tags.compiler_srcjar:
        if srcjar in result:
            continue

        info = {}
        _add_if_not_empty(info, "url", srcjar.url)
        _add_if_not_empty(info, "urls", srcjar.urls)
        _add_if_not_empty(info, "label", srcjar.label)
        _add_if_not_empty(info, "sha256", srcjar.sha256)
        _add_if_not_empty(info, "integrity", srcjar.integrity)
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
        load_dep_rules,
        load_jar_deps,
        maven_servers,
        overridden_artifacts,
        fetch_sources,
        validate_scala_version,
    ) = _get_settings(module_ctx)
    toolchains = _get_toolchains(module_ctx)
    srcjars = _get_scala_compiler_srcjars(module_ctx)

    # Replace scala_repositories()
    for version in SCALA_VERSIONS:
        if load_dep_rules:
            # Replace rules_scala_setup()
            dt_patched_compiler_setup(version, srcjars.get(version))

    dt_patched_compiler_source_aliases_repo(
        name = "scala_compiler_sources",
        scala_versions = SCALA_VERSIONS,
    )

    if load_jar_deps:
        rules_scala_toolchain_deps_repositories(
            maven_servers = maven_servers,
            # Note the internal macro parameters misspell "overriden".
            overriden_artifacts = overridden_artifacts,
            fetch_sources = fetch_sources,
            validate_scala_version = validate_scala_version,
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
        twitter_scrooge(bzlmod_enabled = True)
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
        scalafmt_default_config()
        scalafmt_repositories(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
        )

    if len(toolchains) != 0:
        scala_toolchains_repo(
            name = "io_bazel_rules_scala_toolchains",
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
        "settings": _settings,
        "toolchains": _toolchains,
        "compiler_srcjar": _compiler_srcjar,
    },
)
