# shellcheck source=./test_runner.sh

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")

PERSISTENT_WORKER_FLAGS=(
  # Explicitly disable remote execution and enable C++ toolchain detection in
  # case .bazelrc configures remote execution.
  "--remote_executor="
  "--extra_execution_platforms=@bazel_tools//tools:host_platform"
  "--action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN="
  "--host_action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN="
  "--strategy=Scalac=worker" 
)

if ! is_windows; then
  PERSISTENT_WORKER_FLAGS+=("--worker_sandboxing")
fi

check_persistent_worker_failure() {
  command=$1
  output=$(bazel ${command} 2>&1)
  ! (echo "$output" | grep -q -- "---8<---8<---") && echo "$output"
}

test_persistent_worker_success() {
  # shellcheck disable=SC2086
  bazel build //test:ScalaBinary "${PERSISTENT_WORKER_FLAGS[@]}"
}

_scalac_worker_build_command() {
  echo "build ${TARGET} ${PERSISTENT_WORKER_FLAGS[@]}"
}

test_persistent_worker_failure() {
  local TARGET="//test_expect_failure/diagnostics_reporter:error_file"
  action_should_fail_with_message \
    "ErrorFile.scala:6: error: ')' expected but '}' found." \
    "$(_scalac_worker_build_command)"
}

test_persistent_worker_handles_exception_in_macro_invocation() {
  local TARGET="//test_expect_failure/scalac_exceptions:bad_macro_invocation"
  check_persistent_worker_failure "$(_scalac_worker_build_command)" |
    grep -q "Build failure during macro expansion"

  RESPONSE_CODE=$?
  if [ $RESPONSE_CODE -ne 0 ]; then
    echo -e "${RED} Scalac persistent worker does not handle uncaught error in macro expansion. $NC"
    exit 1
  fi
}

test_persistent_worker_handles_stack_overflow_exception() {
  local TARGET="//test_expect_failure/scalac_exceptions:stack_overflow_macro_invocation"
  check_persistent_worker_failure "$(_scalac_worker_build_command)" |
    grep -q "Build failure with StackOverflowError"

  RESPONSE_CODE=$?
  if [ $RESPONSE_CODE -ne 0 ]; then
    echo -e "${RED} Scalac persistent worker does not handle StackOverflowError in macro expansion. $NC"
    exit 1
  fi
}

$runner test_persistent_worker_success
$runner test_persistent_worker_failure
$runner test_persistent_worker_handles_exception_in_macro_invocation
$runner test_persistent_worker_handles_stack_overflow_exception
