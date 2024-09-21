"""Exports repos used by @io_bazel_rules_scala rules"""

load("//scala/private/extensions:toolchains.bzl", "scala_toolchains_repo")
load(
    "//scala/private:macros/scala_repositories.bzl",
    "dt_patched_compiler_setup",
    "rules_scala_toolchain_deps_repositories",
)
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("@io_bazel_rules_scala//junit:junit.bzl", "junit_repositories")
load("@io_bazel_rules_scala//scalatest:scalatest.bzl", "scalatest_repositories")
load(
    "@io_bazel_rules_scala//specs2:specs2_junit.bzl",
    "specs2_junit_repositories",
)
load(
    "@io_bazel_rules_scala_config//:config.bzl",
    "SCALA_VERSION",
    "SCALA_VERSIONS",
)

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

_scala_compiler_srcjar_default_url = ("https://repo1.maven.org/maven2/org/" +
    "scala-lang/scala-compiler/%s/scala-compiler-%s-sources.jar" % (
        SCALA_VERSION, SCALA_VERSION
    )
)

_scala_compiler_srcjar = tag_class(
    attrs = {
        "url": attr.string(default = _scala_compiler_srcjar_default_url),
        "urls": attr.string_list(),
        "label": attr.string(),
        "sha256": attr.string(),
        "integrity": attr.string(),
    },
)

_toolchains = tag_class(
    attrs = {
        "scala": attr.bool(default = True),
        "scalatest": attr.bool(default = True),
        "junit": attr.bool(),
        "specs2": attr.bool(),
    }
)

def _get_settings(module_ctx):
    root_settings = module_ctx.modules[0].tags.settings

    if len(root_settings) == 0:
        return True, True, {"maven_servers": default_maven_server_urls()}
    settings = root_settings[0]
    return settings.load_dep_rules, settings.load_jar_deps, {
        "maven_servers": settings.maven_servers,
        # internal macros misspell "overridden"
        "overriden_artifacts": settings.overridden_artifacts,
        "fetch_sources": settings.fetch_sources,
        "validate_scala_version": settings.validate_scala_version,
    }

def _add_if_not_empty(result, name, value):
    if len(value) != 0:
        result[name] = value

def _get_scala_compiler_srcjar(module_ctx):
    root_srcjar = module_ctx.modules[0].tags.scala_compiler_srcjar

    if len(root_srcjar) == 0:
        return None
    srcjar = root_srcjar[0]

    result = {}
    _add_if_not_empty(result, "url", srcjar.url)
    _add_if_not_empty(result, "urls", srcjar.urls)
    _add_if_not_empty(result, "label", srcjar.label)
    _add_if_not_empty(result, "sha256", srcjar.sha256)
    _add_if_not_empty(result, "integrity", srcjar.integrity)
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
    return result

def _scala_deps_impl(module_ctx):
    load_dep_rules, load_jar_deps, settings = _get_settings(module_ctx)
    toolchains = _get_toolchains(module_ctx)
    srcjar = _get_scala_compiler_srcjar(module_ctx)

    # Replace scala_repositories()
    for scala_version in SCALA_VERSIONS:
        if load_dep_rules:
            # Replace rules_scala_setup()
            dt_patched_compiler_setup(scala_version, srcjar)

    if load_jar_deps:
        rules_scala_toolchain_deps_repositories(**settings)

    repositories_options = {
        k: settings.get(k) for k in ["maven_servers", "fetch_sources"]
    }

    if "scalatest" in toolchains:
        scalatest_repositories(**repositories_options)
    if "junit" in toolchains:
        junit_repositories(**repositories_options)
    if "specs2" in toolchains:
        specs2_junit_repositories(
            maven_servers = settings.get("maven_servers"),
            overriden_artifacts = settings.get("overriden_artifacts", {}),
            create_junit_repositories = "junit" not in toolchains,
        )

    if len(toolchains) != 0:
        scala_toolchains_repo(
            name = "io_bazel_rules_scala_toolchains",
            scala = "scala" in toolchains,
            scalatest = "scalatest" in toolchains,
            junit = "junit" in toolchains,
            specs2 = "specs2" in toolchains,
        )

scala_deps = module_extension(
    implementation = _scala_deps_impl,
    tag_classes = {
        "settings": _settings,
        "toolchains": _toolchains,
        "scala_compiler_srcjar": _scala_compiler_srcjar,
    }
)
