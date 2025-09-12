#!/usr/bin/env bash
#
# Tests that `scala_binary` properly expands `env` attribute values.
# See: scala/private/phases/phase_expand_environment.bzl

set -euo pipefail

dir="$( cd "${BASH_SOURCE[0]%/*}" && echo "${PWD%/test/shell}" )"
test_source="${dir}/test/shell/${BASH_SOURCE[0]#*test/shell/}"
# shellcheck source=./test_runner.sh
. "${dir}"/test/shell/test_runner.sh

setup_suite() {
  original_dir="$PWD"
  setup_test_tmpdir_for_file "$original_dir" "$test_source"
  test_tmpdir="$PWD"
  cd "$original_dir"
}

teardown_suite() {
  rm -rf "$test_tmpdir"
}

test_scala_binary_env_attribute_expansion() {
  local bindir="$(bazel info bazel-bin)"
  bindir="bazel-out/${bindir#*/bazel-out/}"

  bazel run //test:EnvAttributeBinary > "${test_tmpdir}/actual.txt"

  printf '%s\n' \
    'LOCATION: West of House' \
    'DATA_PATH: test/data/foo.txt' \
    'DEP_PATH: test/HelloLib.jar' \
    'SRC_PATH: test/EnvAttributeBinary.scala' \
    "BINDIR: ${bindir}" \
    'FROM_TOOLCHAIN_VAR: bazquux' \
    'ESCAPED: $(rootpath //test/data:foo.txt) $(BINDIR) $UNKNOWN' \
      > "${test_tmpdir}/expected.txt"

  diff -u --strip-trailing-cr "${test_tmpdir}"/{expected,actual}.txt
}

setup_suite
run_tests "$test_source" "$(get_test_runner "${1:-local}")"
teardown_suite
