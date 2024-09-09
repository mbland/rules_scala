load(
    "//third_party/repositories:scala_2_11.bzl",
    _artifacts_2_11 = "artifacts",
    _scala_version_2_11 = "scala_version",
)
load(
    "//third_party/repositories:scala_2_12.bzl",
    _artifacts_2_12 = "artifacts",
    _scala_version_2_12 = "scala_version",
)
load(
    "//third_party/repositories:scala_2_13.bzl",
    _artifacts_2_13 = "artifacts",
    _scala_version_2_13 = "scala_version",
)
load(
    "//third_party/repositories:scala_3_1.bzl",
    _artifacts_3_1 = "artifacts",
    _scala_version_3_1 = "scala_version",
)
load(
    "//third_party/repositories:scala_3_2.bzl",
    _artifacts_3_2 = "artifacts",
    _scala_version_3_2 = "scala_version",
)
load(
    "//third_party/repositories:scala_3_3.bzl",
    _artifacts_3_3 = "artifacts",
    _scala_version_3_3 = "scala_version",
)
load(
    "//third_party/repositories:scala_3_4.bzl",
    _artifacts_3_4 = "artifacts",
    _scala_version_3_4 = "scala_version",
)
load(
    "@io_bazel_rules_scala//scala:scala_cross_version.bzl",
    "default_maven_server_urls",
    "extract_major_version",
    "version_suffix",
)
load(
    "@io_bazel_rules_scala//scala:scala_maven_import_external.bzl",
    _scala_maven_import_external = "scala_maven_import_external",
)
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

artifacts_by_major_scala_version = {
    "2.11": _artifacts_2_11,
    "2.12": _artifacts_2_12,
    "2.13": _artifacts_2_13,
    "3.1": _artifacts_3_1,
    "3.2": _artifacts_3_2,
    "3.3": _artifacts_3_3,
    "3.4": _artifacts_3_4,
}

scala_version_by_major_scala_version = {
    "2.11": _scala_version_2_11,
    "2.12": _scala_version_2_12,
    "2.13": _scala_version_2_13,
    "3.1": _scala_version_3_1,
    "3.2": _scala_version_3_2,
    "3.3": _scala_version_3_3,
    "3.4": _scala_version_3_4,
}

def repositories(
        scala_version = None,
        for_artifact_ids = [],
        maven_servers = default_maven_server_urls(),
        overriden_artifacts = {},
        fetch_sources = True,
        validate_scala_version = False):
    """
    Downloads given artifacts.

    If `scala_version` is provided, artifacts will be downloaded for that Scala version.
    Also version-aware naming of repositories will be used (appending a suffix).
    Otherwise, the default Scala version is used and repository names have no suffix.
    """

    suffix = version_suffix(scala_version) if scala_version else ""
    scala_version = scala_version or SCALA_VERSION
    major_scala_version = extract_major_version(scala_version)

    if validate_scala_version:
        repository_scala_version = scala_version_by_major_scala_version[major_scala_version]
        default_version_matches = scala_version == repository_scala_version

        if not default_version_matches and len(overriden_artifacts) == 0:
            version_message = "Scala config (%s) version does not match repository version (%s)"
            fail(version_message % (scala_version, repository_scala_version))

    default_artifacts = artifacts_by_major_scala_version[major_scala_version]
    artifacts = dict(default_artifacts.items() + overriden_artifacts.items())
    for id in for_artifact_ids:
        _scala_maven_import_external(
            name = id + suffix,
            # Split the last component off of mangled bzlmod repo names to
            # produce the expected target name. Or else we get output like:
            #
            # scala_import(
            #     name = "_main~scala_deps~io_bazel_rules_scala_scala_compiler",
            #     jars = ["scala-compiler-2.12.18.jar"],
            # )
            #
            # resulting in errors like:
            #
            # ERROR: .../_main~_repo_rules~io_bazel_rules_scala/scala/BUILD:
            # no such target
            #   '@@_main~scala_deps~io_bazel_rules_scala_scala_compiler
            #     //:io_bazel_rules_scala_scala_compiler':
            # target 'io_bazel_rules_scala_scala_compiler' not declared in
            # package '' defined by
            #   .../_main~scala_deps~io_bazel_rules_scala_scala_compiler/BUILD
            # and referenced by '@@_main~_repo_rules~io_bazel_rules_scala
            #   //scala:default_toolchain_scala_compile_classpath_provider'
            generated_rule_name = _unmangle_bzlmod_repo_name(id) + suffix,
            artifact = artifacts[id]["artifact"],
            artifact_sha256 = artifacts[id]["sha256"],
            licenses = ["notice"],
            server_urls = maven_servers,
            deps = [dep + suffix for dep in artifacts[id].get("deps", [])],
            runtime_deps = artifacts[id].get("runtime_deps", []),
            testonly_ = artifacts[id].get("testonly", False),
            fetch_sources = fetch_sources,
        )

        # For backward compatibility: non-suffixed repo pointing to the suffixed one,
        # See: https://github.com/bazelbuild/rules_scala/pull/1573
        # Hopefully we can deprecate and remove it one day.
        if suffix and scala_version == SCALA_VERSION:
            _alias_repository(name = id, target = id + suffix)

def _unmangle_bzlmod_repo_name(name):
    """Return the correct repository name under bzlmod.

    Splits the last component off of mangled bzlmod repo names to produce the
    expected repo name. Or else we get output like:

        scala_import(
            name = "_main~scala_deps~io_bazel_rules_scala_scala_compiler",
            jars = ["scala-compiler-2.12.18.jar"],
        )

    resulting in errors like:

      ERROR: .../_main~_repo_rules~io_bazel_rules_scala/scala/BUILD:
      no such target
        '@@_main~scala_deps~io_bazel_rules_scala_scala_compiler
          //:io_bazel_rules_scala_scala_compiler':
      target 'io_bazel_rules_scala_scala_compiler' not declared in
      package '' defined by
        .../_main~scala_deps~io_bazel_rules_scala_scala_compiler/BUILD
      and referenced by '@@_main~_repo_rules~io_bazel_rules_scala
        //scala:default_toolchain_scala_compile_classpath_provider'

    However, we can't rely on the specific canonical repository name format:

    > Repos generated by extensions have canonical names in the form of
    > `module_repo_canonical_name~extension_name~repo_name`. For extensions
    > hosted in the root module, the `module_repo_canonical_name` part is
    > replaced with the string `_main`. Note that the canonical name format is
    > not an API you should depend on — it's subject to change at any time.
    >
    > - https://bazel.build/external/extension#repository_names_and_visibility

    The change to no longer encode module versions in canonical repo names in
    Bazel 7.1.0 is a recent example of Bazel maintainers altering the format:

    - https://github.com/bazelbuild/bazel/pull/21316

    And the maintainers are about to replace `~` as the delimiter due to build
    performance issues on Windows:

    - https://github.com/bazelbuild/bazel/issues/22865

    This function assumes the only valid `repo_name` characters are letters,
    numbers, '_', '-', and '.'. It finds the last character not in this set, and
    returns the contents of `name` following this character.
    """
    for i in range(len(name)-1, -1, -1):
        c = name[i]
        if not (c.isalnum() or c in "_-."):
            return name[i+1:]
    return name

def _alias_repository_impl(rctx):
    """ Builds a repository containing just two aliases to the Scala Maven artifacts in the `target` repository. """

    format_kwargs = {
        "name": rctx.name,
        "target": rctx.attr.target,
    }
    rctx.file("BUILD", """alias(
    name = "{name}",
    actual = "@{target}",
    visibility = ["//visibility:public"],
)
""".format(**format_kwargs))
    rctx.file("jar/BUILD", """alias(
    name = "jar",
    actual = "@{target}//jar",
    visibility = ["//visibility:public"],
)
""".format(**format_kwargs))

_alias_repository = repository_rule(
    implementation = _alias_repository_impl,
    attrs = {
        "target": attr.string(mandatory = True),
    },
)
