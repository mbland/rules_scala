# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
. "${dir}"/test_coverage_helper.sh
runner=$(get_test_runner "${1:-local}")

TEST_PKG="test/coverage_scalatest_resources/consumer"
TARGET="tests"

test_coverage_succeeds_resource_call() {
    local EXTRA_COVERAGE_FLAGS=(
        "--instrumentation_filter=^//test/coverage_scalatest_resources[:/]"
    )
    local EXPECTED_COVERAGE_PATH=(
        "test/coverage_scalatest_resources/expected-coverage.dat"
    )
    do_test_coverage_on
}

test_coverage_includes_resource_test_targets() {
    do_test_coverage_includes_test_targets \
        "src/test/scala/com/example/consumer/ConsumerSpec.scala"
}

$runner test_coverage_succeeds_resource_call
$runner test_coverage_includes_resource_test_targets
