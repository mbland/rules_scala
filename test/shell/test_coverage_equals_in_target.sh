# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
. "${dir}"/test_coverage_helper.sh
runner=$(get_test_runner "${1:-local}")

TEST_PKG="test/coverage_filename_encoding"
TARGET="name-with-equals"

test_coverage_target_name_contains_equals_sign() {
    do_test_coverage_on
}

$runner test_coverage_target_name_contains_equals_sign
