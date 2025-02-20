#!/usr/bin/env bash
#
# Tests for //scala/private:macros/bzlmod.bzl

set -e

dir="$( cd "${BASH_SOURCE[0]%/*}" && echo "${PWD%/test/shell}" )"
# shellcheck source=./test_runner.sh
. "${dir}"/test/shell/test_runner.sh
. "${dir}"/test/shell/test_helper.sh
runner=$(get_test_runner "${1:-local}")
export USE_BAZEL_VERSION=${USE_BAZEL_VERSION:-$(cat $dir/.bazelversion)}

test_tmpdir="${dir}/tmp/${BASH_SOURCE[0]##*/}"
test_tmpdir="${test_tmpdir%.*}"
mkdir -p "$test_tmpdir"
cd "$test_tmpdir"

teardown_suite() {
    # Make sure bazel isn't still running for this workspace.
    bazel shutdown
    cd - >/dev/null
    rm -rf "$test_tmpdir"
}
trap 'teardown_suite' EXIT

if [[ "$(bazel --version)" =~ ^bazel\ 6\. ]]; then
  exit
fi

test_srcs_dir="${dir}/scala/private/macros/test"
cp "${dir}"/.bazel{rc,version} "${test_srcs_dir}/bzlmod_test_ext.bzl" .
cp "${test_srcs_dir}/BUILD.bzlmod_test" 'BUILD'

setup_module_dot_bazel() {
  sed -e "s%\${rules_scala_dir}%${dir}%" \
    "${test_srcs_dir}/MODULE.bzlmod_test" > 'MODULE.bazel'

  printf '%s\n' "$@" >>'MODULE.bazel'
}

bazel_run_args=('run' '--enable_bzlmod' '//:print-test-tag-values')

print_test_tag_values() {
  bazel "${bazel_run_args[@]}" 2>&1
}

print_test_tag_values_should_fail_with_message() {
  local expected=(
    "expected one regular tag instance and/or one dev_dependency instance,"
    "${1}: 'test_tag' tag at ${test_tmpdir}/MODULE.bazel:"
  )

  action_should_fail_with_message "${expected[*]}" "${bazel_run_args[@]}"
}

test_bzlmod_single_tag_values_returns_defaults_when_no_root_tag() {
  setup_module_dot_bazel

  assert_matches 'foo bar baz$' "$(print_test_tag_values)"
}

test_bzlmod_single_tag_values_returns_regular_root_tag_values() {
  setup_module_dot_bazel \
    'test_ext.test_tag(first = "quux", third = "plugh")'

  assert_matches 'quux bar plugh$' "$(print_test_tag_values)"
}

test_bzlmod_single_tag_values_returns_dev_root_tag_values() {
  setup_module_dot_bazel \
    'dev_test_ext.test_tag(first = "quux", third = "plugh")'

  assert_matches 'quux bar plugh$' "$(print_test_tag_values)"
}

test_bzlmod_single_tag_values_combines_regular_and_dev_dep_tags() {
  setup_module_dot_bazel \
    'test_ext.test_tag(first = "quux", third = "plugh")' \
    'dev_test_ext.test_tag(second = "xyzzy", third = "frobozz")'

  # Dev values matching the default won't overwrite regular tag values.
  assert_matches 'quux xyzzy frobozz$' "$(print_test_tag_values)"
}

test_bzlmod_single_tag_values_errors_if_more_than_two_tags() {
  setup_module_dot_bazel \
    'test_ext.test_tag()' \
    'dev_test_ext.test_tag()' \
    'dev_test_ext.test_tag(second = "not", third = "happening")'

  print_test_tag_values_should_fail_with_message "got 3"
}

test_bzlmod_single_tag_values_errors_if_dev_tag_before_regular() {
  setup_module_dot_bazel \
    'dev_test_ext.test_tag()' \
    'test_ext.test_tag(first = "should be, but isn''t")'

  print_test_tag_values_should_fail_with_message \
    "got the dev_dependency instance before the regular instance"
}

test_bzlmod_single_tag_values_errors_if_two_regular_tags() {
  setup_module_dot_bazel \
    'test_ext.test_tag(first = "of two")' \
    'test_ext.test_tag(second = "of two")'

  print_test_tag_values_should_fail_with_message "got two regular instances"
}

test_bzlmod_single_tag_values_errors_if_two_dev_tags() {
  setup_module_dot_bazel \
    'dev_test_ext.test_tag(first = "of two")' \
    'dev_test_ext.test_tag(second = "of two")'

  print_test_tag_values_should_fail_with_message \
    "got two dev_dependency instances"
}

"$runner" test_bzlmod_single_tag_values_returns_defaults_when_no_root_tag
"$runner" test_bzlmod_single_tag_values_returns_regular_root_tag_values
"$runner" test_bzlmod_single_tag_values_returns_dev_root_tag_values
"$runner" test_bzlmod_single_tag_values_combines_regular_and_dev_dep_tags
"$runner" test_bzlmod_single_tag_values_errors_if_more_than_two_tags
"$runner" test_bzlmod_single_tag_values_errors_if_dev_tag_before_regular
"$runner" test_bzlmod_single_tag_values_errors_if_two_regular_tags
"$runner" test_bzlmod_single_tag_values_errors_if_two_dev_tags
