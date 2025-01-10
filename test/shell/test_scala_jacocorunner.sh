# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
. "${dir}"/test_coverage_helper.sh
runner=$(get_test_runner "${1:-local}")

test_scala_jacocorunner_from_scala_toolchain_passes() {
  bazel coverage "${COVERAGE_FLAGS[@]}" \
    --extra_toolchains="//manual_test/scala_test_jacocorunner:passing_scala_toolchain" \
    //manual_test/scala_test_jacocorunner:empty_test
}

test_scala_jacocorunner_from_scala_toolchain_fails() {
  action_should_fail coverage "${COVERAGE_FLAGS[@]}" \
    --extra_toolchains="//test_expect_failure/scala_test_jacocorunner:failing_scala_toolchain" \
    //test_expect_failure/scala_test_jacocorunner:empty_test
}

#Jacocoa support not implemented for windows just yet
if ! is_windows; then
  $runner test_scala_jacocorunner_from_scala_toolchain_passes
  $runner test_scala_jacocorunner_from_scala_toolchain_fails
fi
