#!/usr/bin/env bash

set -e

root_dir="$PWD"
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
runner=$(get_test_runner "${1:-local}")

check_module_bazel() {
  local repo_path="${1%MODULE.bazel}"
  local mod_orig="${root_dir}/tmp/MODULE.lint"
  local mod_diff="${root_dir}/tmp/MODULE.diff"

  echo -e "${GREEN}INFO:${NC} linting $1"
  repo_path="${repo_path:-.}"
  cd "${root_dir}/${repo_path:-.}"
  cp MODULE.bazel "$mod_orig"
  trap "rm ${mod_orig} ${mod_diff}" EXIT
  bazel mod tidy
  bazel shutdown

  if ! diff -u "$mod_orig" MODULE.bazel >"$mod_diff"; then
    echo -e "${RED}ERROR:${NC}" \
      "\`bazel mod tidy\` produced changes in ${repo_path%.}MODULE.bazel:"
    echo "$(< "$mod_diff")"
    exit 1
  fi
}

for module_file in $(git ls-files '**MODULE.bazel'); do
  $runner check_module_bazel "$module_file"
done
