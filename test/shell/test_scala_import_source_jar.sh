#! /usr/bin/env bash

# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")

package_path="test/src/main/scala/scalarules/test/fetch_sources"
repo_name="com_google_guava_guava_21_0"
srcjar_name="guava-21.0-src.jar"

# Calculate the repo name by itself, since we need to wildcard it for Bzlmod
# compatibility. Otherwise calculating `bazel_out_external_guava_21` with the
# glob included will produce an invalid path if the srcjar doesn't exist.
repo_path=("$(bazel info output_base)"/external/*${repo_name})
bazel_out_external_guava_21="${repo_path}/${srcjar_name}"

test_scala_import_fetch_sources_with_env_bazel_jvm_fetch_sources_set_to() {
  # the existence of the env var should cause the import repository rule to re-fetch the dependency
  # and therefore the order of tests is not expected to matter
  export BAZEL_JVM_FETCH_SOURCES="$1"
  local expect_failure="${2:-}"

  test_scala_import_fetch_sources "$expect_failure"
  unset BAZEL_JVM_FETCH_SOURCES
}

# Tests using this helper depend upon setting `fetch_sources` for `$repo_name`
# to `True` in `scala/private/extensions/dev_deps.bzl`. Without that, the first
# test will always fail, and the `BAZEL_JVM_FETCH_SOURCES` environment variable
# has no effect.
test_scala_import_fetch_sources() {
  local expect_failure="${1:-}"

  set -e
  bazel build "//${package_path}/..."
  set +e

  assert_file_exists "$expect_failure" "$bazel_out_external_guava_21"
}

assert_file_exists() {
  if [[ -n "$1" ]]; then
    if [[ -f "$2" ]]; then
      echo "File $2 exists but we expect no source jars."
      exit 1
    else
      echo "File $2 does not exist."
    fi
  else
    if [[ -f "$2" ]]; then
      echo "File $2 exists."
    else
      echo "File $2 does not exist but we expect it to exist."
      exit 1
    fi
  fi
}

test_scala_import_source_jar_should_be_fetched_when_fetch_sources_is_set_to_true() {
  test_scala_import_fetch_sources
}

test_scala_import_source_jar_should_be_fetched_when_env_bazel_jvm_fetch_sources_is_set_to_true() {
  test_scala_import_fetch_sources_with_env_bazel_jvm_fetch_sources_set_to "TruE" # as implied, the value is case insensitive
}

test_scala_import_source_jar_should_not_be_fetched_when_env_bazel_jvm_fetch_sources_is_set_to_non_true() {
  test_scala_import_fetch_sources_with_env_bazel_jvm_fetch_sources_set_to "false" "true"
}

$runner test_scala_import_source_jar_should_be_fetched_when_fetch_sources_is_set_to_true
$runner test_scala_import_source_jar_should_be_fetched_when_env_bazel_jvm_fetch_sources_is_set_to_true
$runner test_scala_import_source_jar_should_not_be_fetched_when_env_bazel_jvm_fetch_sources_is_set_to_non_true
