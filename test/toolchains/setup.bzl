"""rules_scala test toolchain setup"""

load(
    "//scala/private:macros/setup_scala_toolchain.bzl",
    "setup_scala_toolchain",
)

TEST_TOOLCHAINS = [
    "ast_plus_one_deps_unused_deps_warn",
    "ast_plus_one_deps_unused_deps_error",
    "ast_plus_one_deps_strict_deps_warn",
    "ast_plus_one_deps_strict_deps_error",
    "high_level_transitive_deps_strict_deps_warn",
    "high_level_transitive_deps_strict_deps_error",
    "high_level_direct_deps",
    "enable_stats_file_disabled_toolchain",
    "use_argument_file_in_runner",
]

def setup_rules_scala_test_toolchains(name = ""):
    """Sets up toolchains required by rules_scala/test_all.sh."""
    setup_scala_toolchain(
        name = name + "ast_plus_one_deps_unused_deps_warn",
        dependency_mode = "plus-one",
        dependency_tracking_method = "ast",
        unused_dependency_checker_mode = "warn",
    )

    setup_scala_toolchain(
        name = name + "ast_plus_one_deps_unused_deps_error",
        dependency_mode = "plus-one",
        dependency_tracking_method = "ast",
        unused_dependency_checker_mode = "error",
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "ast_plus_one_deps_strict_deps_warn",
        dependency_mode = "plus-one",
        dependency_tracking_method = "ast",
        strict_deps_mode = "warn",
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "ast_plus_one_deps_strict_deps_error",
        dependency_mode = "plus-one",
        dependency_tracking_method = "ast",
        strict_deps_mode = "error",
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "high_level_transitive_deps_strict_deps_warn",
        dependency_mode = "transitive",
        dependency_tracking_method = "high-level",
        strict_deps_mode = "warn",
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "high_level_transitive_deps_strict_deps_error",
        dependency_mode = "transitive",
        dependency_tracking_method = "high-level",
        strict_deps_mode = "error",
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "high_level_direct_deps",
        dependency_mode = "direct",
        dependency_tracking_method = "high-level",
        strict_deps_mode = "off",
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "enable_stats_file_disabled_toolchain",
        enable_stats_file = False,
        visibility = ["//visibility:public"],
    )

    setup_scala_toolchain(
        name = name + "use_argument_file_in_runner",
        use_argument_file_in_runner = True,
        visibility = ["//visibility:public"],
    )
