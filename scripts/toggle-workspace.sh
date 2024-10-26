#!/usr/bin/env bash
#
# Updates .bazelrc files to enable or disable WORKSPACE builds.
#
# This is for testing `WORKSPACE` and Bzlmod compatibility. The produced changes
# should never be checked in. Run `git restore` and `git clean` to revert them
# before committing.

ROOTDIR="${BASH_SOURCE[0]%/*}/.."
cd "$ROOTDIR"

if [[ "$?" -ne 0 ]]; then
  echo "Could not change to $ROOTDIR." >&2
  exit 1
elif [[ "$#" -gt 1  || "${1:-disable}" != 'disable' ]]; then
  printf '%s\n' >&2 \
    "Usage: $0 [ disable ]" \
    "" \
    "Updates .bazelrc files to enable or disable WORKSPACE builds."
  exit 1
fi

workspace_options="build --noenable_bzlmod"
bzlmod_options="build --enable_bzlmod"
bazel_version="$(bazel --version 2>&1)"

if [[ "$?" -ne 0 ]]; then
  echo "failed to run `bazel --version`: $bazel_version" >&2
  exit 1
elif [[ "${bazel_version#* }" =~ ^(7|8)\. ]]; then
  workspace_options="${workspace_options} --enable_workspace"
  bzlmod_options="${bzlmod_options} --noenable_workspace"
fi

enabled_options="$workspace_options"
disabled_options="$bzlmod_options"

if [[ "$1" == "disable" ]]; then
  enabled_options="$bzlmod_options"
  disabled_options="$workspace_options"
fi

already_enabled="($enabled_options|import [./]*/.bazelrc)"

# Searches for WORKSPACE instead of .bazelrc because not all repos may have a
# .bazelrc file.
while IFS="" read repo_marker_path; do
  repo_path="${repo_marker_path%/*}"
  bazelrc_path="$repo_path/.bazelrc"

  # The top level repo is a special case.
  if [[ "$repo_path" == "$repo_marker_path" ]]; then
    bazelrc_path="./.bazelrc"
  fi

  if [[ ! -f "$bazelrc_path" ]]; then
    echo "$enabled_options" > "$bazelrc_path"
    continue
  fi

  content="$(< "$bazelrc_path")"

  if [[ "$content" =~ $disabled_options ]]; then
    echo "${content//$disabled_options/$enabled_options}" >"$bazelrc_path"
  elif [[ ! "$content" =~ $already_enabled ]]; then
    echo "$enabled_options" >> "$bazelrc_path"
  fi

done < <(find [A-Za-z0-9]* -name "WORKSPACE")
