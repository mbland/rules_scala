load("@io_bazel_rules_scala//scala:providers.bzl", "declare_deps_provider")
load(
    "@io_bazel_rules_scala//testing/toolchain:toolchain.bzl",
    "scala_testing_toolchain",
)
load(
    "@io_bazel_rules_scala//testing/toolchain:toolchain_deps.bzl",
    "testing_toolchain_deps",
)
load("//scala:scala_cross_version.bzl", "repositories", "version_suffix")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

def _declare_deps_provider(macro_name, deps_id, deps, visibility):
    label = "%s_%s_provider" % (macro_name, deps_id)
    declare_deps_provider(
        name = label,
        deps_id = deps_id,
        visibility = visibility,
        deps = deps,
    )
    return ":%s" % label

def setup_scala_testing_toolchain(
        name,
        scala_version = SCALA_VERSION,
        junit_classpath = None,
        specs2_classpath = None,
        specs2_junit_classpath = None,
        scalatest_classpath = None,
        visibility = ["//visibility:public"]):
    dep_providers = []
    suffix = version_suffix(scala_version)

    if junit_classpath != None:
        dep_providers.append(
            _declare_deps_provider(
                name,
                "junit_classpath" + suffix,
                repositories(scala_version, junit_classpath),
                visibility,
            ),
        )

    if specs2_junit_classpath != None:
        dep_providers.append(
            _declare_deps_provider(
                name,
                "specs2_junit_classpath" + suffix,
                repositories(scala_version, specs2_junit_classpath),
                visibility,
            ),
        )

    if specs2_classpath != None:
        dep_providers.append(
            _declare_deps_provider(
                name,
                "specs2_classpath" + suffix,
                repositories(scala_version, specs2_classpath),
                visibility,
            ),
        )

    if scalatest_classpath != None:
        dep_providers.append(
            _declare_deps_provider(
                name,
                "scalatest_classpath" + suffix,
                repositories(scala_version, scalatest_classpath),
                visibility,
            ),
        )

    scala_testing_toolchain(
        name = name + "_impl",
        dep_providers = dep_providers,
        visibility = visibility,
    )

    native.toolchain(
        name = name,
        toolchain = ":" + name + "_impl",
        toolchain_type = (
            "@io_bazel_rules_scala//testing/toolchain:testing_toolchain_type"
        ),
        target_settings = [
            "@io_bazel_rules_scala_config//:scala_version" + suffix
        ],
        visibility = visibility,
    )
