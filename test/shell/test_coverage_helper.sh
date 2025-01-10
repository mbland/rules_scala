COVERAGE_FLAGS=(
    "--experimental_fetch_all_coverage_outputs"
    "--experimental_split_coverage_postprocessing"
)
TESTLOGS="$(bazel info bazel-testlogs)"

# Default to 2.12.20 for `diff` tests because other versions change the output.
SCALA_VERSION="${SCALA_VERSION:-2.12.20}"

_coverage_path() {
    echo "$TESTLOGS/$TEST_PKG/$TARGET/coverage.dat"
}

do_test_coverage_on() {
    bazel coverage "${COVERAGE_FLAGS[@]}" "${EXTRA_COVERAGE_FLAGS[@]}" \
        --repo_env="SCALA_VERSION=${SCALA_VERSION}" "//$TEST_PKG:$TARGET"
    diff "${EXPECTED_COVERAGE_PATH:-$TEST_PKG/expected-coverage.dat}" \
        "$(_coverage_path)"
}

do_test_coverage_includes_test_targets() {
    local test_file="$1"

    bazel coverage "${COVERAGE_FLAGS[@]}" "${EXTRA_COVERAGE_FLAGS[@]}" \
        --instrument_test_targets=True "//$TEST_PKG:$TARGET"
    grep -q "SF:$TEST_PKG/$test_file" "$(_coverage_path)"
}
