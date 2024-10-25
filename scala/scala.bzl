load(
    "//specs2:specs2_junit.bzl",
    _specs2_junit_dependencies = "specs2_junit_dependencies",
)
load(
    "//scala/private:macros/toolchains.bzl",
    _scala_toolchains = "scala_toolchains",
)
load(
    "//scala/private:macros/toolchains_repo.bzl",
    _scala_toolchains_repo = "scala_toolchains_repo",
)
load(
    "//scala/private:macros/scala_repositories.bzl",
    _rules_scala_setup = "rules_scala_setup",
    _rules_scala_toolchain_deps_repositories = "rules_scala_toolchain_deps_repositories",
    _scala_repositories = "scala_repositories",
)
load(
    "//scala/private:macros/setup_scala_toolchain.bzl",
    _setup_scala_toolchain = "setup_scala_toolchain",
)
load(
    "//scala/private:rules/scala_binary.bzl",
    _scala_binary = "scala_binary",
)
load(
    "//scala/private:rules/scala_doc.bzl",
    _ScaladocAspectInfo = "ScaladocAspectInfo",
    _make_scala_doc_rule = "make_scala_doc_rule",
    _scaladoc_intransitive_aspect = "scaladoc_intransitive_aspect",
)
load(
    "//scala/private:rules/scala_junit_test.bzl",
    _scala_junit_test = "scala_junit_test",
)
load(
    "//scala/private:rules/scala_library.bzl",
    _scala_library = "scala_library",
    _scala_library_for_plugin_bootstrapping = "scala_library_for_plugin_bootstrapping",
    _scala_library_suite = "scala_library_suite",
    _scala_macro_library = "scala_macro_library",
)
load(
    "//scala/private:rules/scala_repl.bzl",
    _scala_repl = "scala_repl",
)
load(
    "//scala/private:rules/scala_test.bzl",
    _scala_test = "scala_test",
    _scala_test_suite = "scala_test_suite",
)
load(
    "//testing:testing.bzl",
    _setup_scala_testing_toolchain = "setup_scala_testing_toolchain",
)

def scala_specs2_junit_test(name, **kwargs):
    _scala_junit_test(
        name = name,
        deps = _specs2_junit_dependencies() + kwargs.pop("deps", []),
        unused_dependency_checker_ignored_targets =
            _specs2_junit_dependencies() + kwargs.pop("unused_dependency_checker_ignored_targets", []),
        suite_label = Label(
            "//src/java/io/bazel/rulesscala/specs2:specs2_test_discovery",
        ),
        suite_class = "io.bazel.rulesscala.specs2.Specs2DiscoveredTestSuite",
        **kwargs
    )

# Re-export private rules for public consumption
scala_binary = _scala_binary

# These are exported for enabling users to build scaladocs without transitive dependencies.
make_scala_doc_rule = _make_scala_doc_rule
scaladoc_intransitive_aspect = _scaladoc_intransitive_aspect
scala_doc = _make_scala_doc_rule()
ScaladocAspectInfo = _ScaladocAspectInfo
scala_junit_test = _scala_junit_test
scala_library = _scala_library
scala_library_for_plugin_bootstrapping = _scala_library_for_plugin_bootstrapping
scala_library_suite = _scala_library_suite
scala_macro_library = _scala_macro_library
scala_repl = _scala_repl
scala_repositories = _scala_repositories
rules_scala_setup = _rules_scala_setup
rules_scala_toolchain_deps_repositories = _rules_scala_toolchain_deps_repositories
scala_test = _scala_test
scala_test_suite = _scala_test_suite
setup_scala_testing_toolchain = _setup_scala_testing_toolchain
setup_scala_toolchain = _setup_scala_toolchain
scala_toolchains = _scala_toolchains
scala_toolchains_repo = _scala_toolchains_repo
