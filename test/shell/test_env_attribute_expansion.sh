#!/usr/bin/env bash
#
# Tests that `scala_binary` properly expands `env` attribute values.
# See: scala/private/phases/phase_expand_environment.bzl

set -euo pipefail

dir="$( cd "${BASH_SOURCE[0]%/*}" && echo "${PWD%/test/shell}" )"
test_source="${dir}/test/shell/${BASH_SOURCE[0]#*test/shell/}"
# shellcheck source=./test_runner.sh
. "${dir}"/test/shell/test_runner.sh

test_scala_binary_env_attribute_expansion() {
  bazel run //test:EnvAttributeBinary
}

run_tests "$test_source" "$(get_test_runner "${1:-local}")"
