#!/usr/bin/env bash

# shellcheck source=./test_runner.sh

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")

_check_failing_action() {
  local assertion="$1"
  local scalaVersion="$2"
  local expected="$3"
  
  "$assertion" "$expected" \
    build \
    "--repo_env=SCALA_VERSION=${scalaVersion}" \
    //test_expect_failure/scalacopts_invalid:empty
}

test_logs_contains() {
  _check_failing_action 'action_should_fail_with_message' "$@"
}

test_logs_not_contains() {
  _check_failing_action 'action_should_fail_without_message' "$@"
}

for scalaVersion in 2.12.20 2.13.16 3.3.6; do
  if [[ "$scalaVersion" == 3.* ]]; then
    $runner test_logs_contains $scalaVersion "not-existing is not a valid choice for -source"
  else
    $runner test_logs_contains $scalaVersion "bad option: '-source:not-existing'"
  fi
  $runner test_logs_contains $scalaVersion 'Failed to invoke Scala compiler, ensure passed options are valid'
  $runner test_logs_not_contains $scalaVersion 'at io.bazel.rulesscala.scalac.ScalacWorker.main'
done
