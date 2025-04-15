#!/usr/bin/env bash
#
# Test runner functions for rules_scala integration tests.
#
# Supports the following env vars:
#
# - `RULES_SCALA_TEST_ONLY`: Run a specific test by name. Emits full Bazel
#   output, without having to search for it and recreate its command line.
#
# - `RULES_SCALA_TEST_REGEX`: Run only tests matching the regular expression.
#   Does not show full Bazel output by default.
#
# - `RULES_SCALA_TEST_VERBOSE`: Set to a nonempty string to see verbose output
#   for all tests.
#
# Skips test cases whose name begins with `_` unless those tests match
# `RULES_SCALA_TEST_ONLY` or `RULES_SCALA_TEST_REGEX`.

NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

_skip_test() {
  local test_name="$1"

  # This allows us to run a single test case with full Bazel output without
  # having to search for it and recreate its command line.
  if [[ -n "$RULES_SCALA_TEST_ONLY" &&
        "$test_name" != "$RULES_SCALA_TEST_ONLY" ]]; then
    return

  # Same as above, but for multiple tests, and without full output by default.
  elif [[ -n "$RULES_SCALA_TEST_REGEX" &&
        ! "$test_name" =~ $RULES_SCALA_TEST_REGEX ]]; then
    return

  # Only skips a test if it wasn't specifically identified by name or regex.
  elif [[ -z "${RULES_SCALA_TEST_ONLY}${RULES_SCALA_TEST_REGEX}" &&
      "${test_name:0:1}" == '_' ]]; then
    echo -e "${YELLOW}skipping test ${test_name}${NC}"
    return
  fi

  return 1
}

run_test_ci() {
  # spawns the test to new process
  local TEST_ARG=$@

  if _skip_test "$TEST_ARG"; then
    return
  fi

  local log_file=output_$$.log
  echo "running test $TEST_ARG"
  eval $TEST_ARG &>$log_file &
  local test_pid=$!

  SECONDS=0
  test_pulse_printer "$test_pid" "${TEST_TIMEOUT:-60}" $TEST_ARG &

  local pulse_printer_pid=$!
  local result

  {
    wait $test_pid 2>/dev/null
    result=$?
    kill $pulse_printer_pid && wait $pulse_printer_pid 2>/dev/null || true
  } || return 1

  local DURATION=$SECONDS
  if [ $result -eq 0 ]; then
    echo -e "\n${GREEN}Test \"$TEST_ARG\" successful ($DURATION sec) $NC"
  else
    echo -e "\nLog:\n"
    cat $log_file
    echo -e "\n${RED}Test \"$TEST_ARG\" failed $NC ($DURATION sec) $NC"
  fi
  return $result
}

test_pulse_printer() {
  # makes sure something is printed to stdout while test is running
  local test_pid="$1"
  shift
  local timeout="$1" # in minutes
  shift
  local count=0

  # clear the line
  echo -e "\n"

  while [ $count -lt $timeout ]; do
    count=$(($count + 1))
    echo -ne "Still running: \"$@\"\r"
    sleep 60
  done

  echo -e "\n${RED}Timeout (${timeout} minutes) reached. Terminating \"$@\"${NC}\n"
  kill -9 $test_pid
}

run_test_local() {
  # runs the tests locally
  set +e
  local TEST_ARG=$@
  local RES=''

  if _skip_test "$TEST_ARG"; then
    return
  fi

  echo "running test $TEST_ARG"
  SECONDS=0

  if [[ -n "$RULES_SCALA_TEST_VERBOSE" || -n "$RULES_SCALA_TEST_ONLY" ]]; then
    $TEST_ARG
  else
    RES="$($TEST_ARG 2>&1)"
  fi

  local RESPONSE_CODE="$?"
  local DURATION="$SECONDS"

  if [ $RESPONSE_CODE -eq 0 ]; then
    echo -e "${GREEN} Test \"$TEST_ARG\" successful ($DURATION sec) $NC"
  else
    if [[ -n "$RES" ]]; then
      echo -e "\nLog:\n"
      echo "$RES"
    fi
    echo -e "${RED} Test \"$TEST_ARG\" failed $NC ($DURATION sec) $NC"
    exit $RESPONSE_CODE
  fi
}

get_test_runner() {
  local test_env="$1"
  if [[ "${test_env}" != "ci" && "${test_env}" != "local" ]]; then
    echo -e "${RED}test_env must be either 'local' or 'ci'"
    exit 1
  fi
  echo "run_test_${test_env}"
}

# Creates a temporary directory for the test file and changes into it.
#
# `$PWD` will be this new test directory upon returning. Sets an `EXIT` trap to
# run `teardown_test_tmpdir()`, which will restore the original `$PWD`.
#
# Args:
#   root_dir: the root directory of the repository
#   test_file_name: the name of the test file
setup_test_tmpdir_for_file() {
  local root_dir="$1"
  local test_file_name="${2##*/}"
  local test_tmpdir="${root_dir}/tmp/${test_file_name%.*}"
  local original_dir="$PWD"

  mkdir -p "$test_tmpdir"
  cd "$test_tmpdir"
  trap "teardown_test_tmpdir '$original_dir' '$PWD' " EXIT
}

# Cleans the Bazel workspace, removes the test dir, and restores `$PWD`.
#
# `setup_test_tmpdir_for_file()` sets this function as the `EXIT` trap handler.
#
# Args:
#   original_dir: `$PWD` at the start of `setup_test_tmpdir_for_file()`
#   test_tmpdir: `$PWD` at the end of `setup_test_tmpdir_for_file()`
teardown_test_tmpdir() {
    local original_dir="$1"
    local test_tmpdir="$2"

    bazel clean --expunge_async 2>/dev/null
    cd "$original_dir"
    rm -rf "$test_tmpdir"
}

# Runs test cases extracted from a file whose name matches `test_*() {`.
#
# To skip a test, add a `_` prefix to its function name.
#
# Args:
#   test_source: path to the source file containing test functions
#   runner: the result from `get_test_runner()`
run_tests() {
  local test_source="$1"
  local runner="$2"

  while IFS= read -r line; do
    if [[ "$line" =~ ^(_?test_[A-Za-z0-9_]+)\(\)\ ?{$ ]]; then
      "$runner" "${BASH_REMATCH[1]}"
    fi
  done <"$test_source"
}
