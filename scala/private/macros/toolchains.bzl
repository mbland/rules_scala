"""Macro to instantiate @io_bazel_rules_scala_toolchains"""

load(":macros/toolchains_repo.bzl", "scala_toolchains_repo")
load("//jmh:jmh.bzl", "jmh_repositories")
load("//junit:junit.bzl", "junit_repositories")
load("//scala/private:macros/scala_repositories.bzl", "scala_repositories")
load(
    "//scala/scalafmt:scalafmt_repositories.bzl",
    "scalafmt_default_config",
    "scalafmt_repositories",
)
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load(
    "//scala_proto/default:repositories.bzl",
    "scala_proto_default_repositories",
)
load("//scalatest:scalatest.bzl", "scalatest_repositories")
load("//specs2:specs2_junit.bzl", "specs2_junit_repositories")
load("//twitter_scrooge:twitter_scrooge.bzl", _scrooge = "twitter_scrooge")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSIONS")

def scala_toolchains(
        maven_servers = default_maven_server_urls(),
        overridden_artifacts = {},
        load_rules_scala_dependencies = True,
        load_scala_toolchain_dependencies = True,
        fetch_sources = False,
        validate_scala_version = True,
        scala_compiler_srcjars = {},
        scalafmt_default_config_path = ".scalafmt.conf",
        scalatest = False,
        junit = False,
        specs2 = False,
        scala_proto = False,
        scala_proto_enable_all_options = False,
        twitter_scrooge = False,
        jmh = False,
        testing = False,
        scalafmt = False):
    """Instantiates @io_bazel_rules_scala_toolchains and all its dependencies.

    Provides a unified interface to configuring rules_scala both directly in a
    `WORKSPACE` file and in a Bazel module extension.

    Instantiates the `@io_bazel_rules_scala_toolchains` repository. Under
    `WORKSPACE`, you will need to call `register_toolchains` at some point.
    Under Bzlmod, rules_scala does this automatically.

    ```starlark
    register_toolchains("@io_bazel_rules_scala_toolchains//...:all")
    ```

    All arguments are optional.

    Args:
        maven_servers: Maven servers used to fetch dependency jar files
        overridden_artifacts: specific dependency jar files to use instead of
            those from `maven_servers`, in the format:
            ```starlark
            "repo_name": {
                "artifact": "<maven coordinates>",
                "sha256": "<checksum>",
                "deps": [
                    "repository_names_of_dependencies",
                ],
            }
            ```
        load_rules_scala_dependencies: whether load rules_scala repository
            dependencies
        load_scala_toolchain_dependencies: whether to load repository
            dependencies of the core Scala language toolchain
        fetch_sources: whether to download dependency source jars
        validate_scala_version: whether to check if the configured Scala version
            matches the default version supported by rules_scala
        scala_compiler_srcjars: optional dictionary of Scala version string to
            compiler srcjar metadata dictionaries containing:
            - exactly one "label", "url", or "urls" key
            - optional "integrity" or "sha256" keys
        scalatest: whether to instantiate the Scalatest toolchain
        junit: whether to instantiate the JUnit toolchain
        specs2: whether to instantiate the Specs2 JUnit toolchain
        testing: whether to instantiate the Scalatest, JUnit, and Specs2 JUnit
            toolchains combined
        scalafmt: whether to instantiate the Scalafmt toolchain
        scalafmt_default_config_path: the relative path to the default Scalafmt
            config file within the repository
        scala_proto: whether to instantiate the scala_proto toolchain
        scala_proto_enable_all_options: whether to instantiate the scala_proto
            toolchain with all options enabled; `scala_proto` must also be
            `True` for this to take effect
        twitter_scrooge: whether to instantiate the twitter_scrooge toolchain
        jmh: whether to instantiate the jmh toolchain
    """
    scala_repositories(
        maven_servers = maven_servers,
        # Note the internal macro parameter misspells "overriden".
        overriden_artifacts = overridden_artifacts,
        load_dep_rules = load_rules_scala_dependencies,
        load_jar_deps = load_scala_toolchain_dependencies,
        fetch_sources = fetch_sources,
        validate_scala_version = validate_scala_version,
        scala_compiler_srcjars = scala_compiler_srcjars,
    )

    if testing:
        scalatest = True
        junit = True
        specs2 = True

    if scalatest:
        scalatest_repositories(
            maven_servers = maven_servers,
            fetch_sources = fetch_sources,
        )

    for scala_version in SCALA_VERSIONS:
        if junit:
            junit_repositories(
                maven_servers = maven_servers,
                scala_version = scala_version,
                overriden_artifacts = overridden_artifacts,
                fetch_sources = fetch_sources,
            )
        if specs2:
            specs2_junit_repositories(
                maven_servers = maven_servers,
                scala_version = scala_version,
                overriden_artifacts = overridden_artifacts,
                create_junit_repositories = not junit,
            )
        if scala_proto:
            scala_proto_default_repositories(
                maven_servers = maven_servers,
                scala_version = scala_version,
                overriden_artifacts = overridden_artifacts,
                register_toolchains = False,
            )

    if twitter_scrooge:
        _scrooge(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
            scala_proto_instantiated = scala_proto,
        )
    if jmh:
        jmh_repositories(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
        )
    if scalafmt:
        scalafmt_default_config(scalafmt_default_config_path)
        scalafmt_repositories(
            maven_servers = maven_servers,
            overriden_artifacts = overridden_artifacts,
            bzlmod_enabled = True,
            scala_proto_instantiated = scala_proto,
        )

    scala_toolchains_repo(
        scalatest = scalatest,
        junit = junit,
        specs2 = specs2,
        twitter_scrooge = twitter_scrooge,
        jmh = jmh,
        scala_proto = scala_proto,
        scala_proto_enable_all_options = scala_proto_enable_all_options,
        testing = testing,
        scalafmt = scalafmt,
    )
