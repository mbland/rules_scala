# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
. "${dir}"/test_coverage_helper.sh
runner=$(get_test_runner "${1:-local}")

TEST_PKG="test/coverage_scalatest"
TARGET="test-scalatest"

test_coverage_on() {
    do_test_coverage_on
}

test_coverage_includes_test_targets() {
    do_test_coverage_includes_test_targets "TestWithScalaTest.scala"
}

$runner test_coverage_on
$runner test_coverage_includes_test_targets
