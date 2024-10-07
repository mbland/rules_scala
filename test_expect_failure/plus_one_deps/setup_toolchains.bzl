"""rules_scala test toolchain setup"""

load(
    "//scala/private:macros/setup_scala_toolchain.bzl",
    "setup_scala_toolchain",
)

TEST_TOOLCHAINS = [
    "plus_one_deps",
    "plus_one_deps_with_unused_error",
]

def setup_test_expect_failure_toolchains(name = ""):
    """Sets up toolchains required by rules_scala/test_all.sh."""
    setup_scala_toolchain(
        name = "plus_one_deps",
        dependency_mode = "plus-one",
    )

    setup_scala_toolchain(
        name = "plus_one_deps_with_unused_error",
        dependency_mode = "plus-one",
        unused_dependency_checker_mode = "error",
    )
