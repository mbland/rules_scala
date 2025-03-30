#!/usr/bin/env bash

set -e

if ! bazel_loc="$(type -p 'bazel')" || [[ -z "$bazel_loc" ]]; then
  export PATH="$(cd "$(dirname "$0")"; pwd)"/tools:$PATH
  echo 'Using ./tools/bazel directly for bazel calls'
fi

test_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/test/shell
# shellcheck source=./test_runner.sh
. "${test_dir}"/test_runner.sh
. "${test_dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")
test_output_flag="--test_output=errors"
test_target_filter=""

if is_windows; then
  test_target_filter="-- -//src/java/io/bazel/rulesscala/worker:worker_test"
fi

"${test_dir}"/test_bzlmod_macros.sh
$runner bazel build "src/... test/... ${test_target_filter}"
#$runner bazel build "src/... test/... --all_incompatible_changes ${test_target_filter}"
$runner bazel test "${test_output_flag} src/... test/... ${test_target_filter}"
$runner bazel test "${test_output_flag} third_party/..."
$runner bazel build "--extra_toolchains=//test/toolchains:high_level_transitive_deps_strict_deps_error -- test/..."
$runner bazel build "--extra_toolchains=//scala:minimal_direct_source_deps -- test/..."
#$runner bazel build "--extra_toolchains=//test/toolchains:high_level_transitive_deps_strict_deps_error --all_incompatible_changes -- test/..."
$runner bazel test "${test_output_flag} --extra_toolchains=//test/toolchains:high_level_transitive_deps_strict_deps_error -- test/..."
$runner bazel test "${test_output_flag} --extra_toolchains=//scala:minimal_direct_source_deps -- test/..."
$runner bazel build "test_expect_failure/missing_direct_deps/internal_deps/... --strict_java_deps=warn --extra_toolchains=//test/toolchains:high_level_transitive_deps_strict_deps_warn"
$runner bazel build //test_expect_failure/proto_source_root/... --strict_proto_deps=off
$runner bazel test "$test_output_flag" //test/... --extra_toolchains="//test_expect_failure/plus_one_deps:plus_one_deps"
$runner bazel build test:ScalaBinaryInGenrule --nolegacy_external_runfiles
$runner bazel build //test_statsfile:Simple_statsfile
$runner bazel build //test_statsfile:SimpleNoStatsFile_statsfile --extra_toolchains="//test/toolchains:enable_stats_file_disabled_toolchain"
. "${test_dir}"/test_build_event_protocol.sh
. "${test_dir}"/test_compilation.sh
. "${test_dir}"/test_deps.sh
. "${test_dir}"/test_diagnostics_reporter.sh
. "${test_dir}"/test_javac_jvm_flags.sh
. "${test_dir}"/test_custom_reporter_class.sh
. "${test_dir}"/test_junit.sh
. "${test_dir}"/test_misc.sh
. "${test_dir}"/test_phase.sh
. "${test_dir}"/test_scalafmt.sh
. "${test_dir}"/test_scala_binary.sh
. "${test_dir}"/test_scalac_jvm_flags.sh
. "${test_dir}"/test_scala_classpath.sh
. "${test_dir}"/test_scala_config.sh
. "${test_dir}"/test_scala_import_source_jar.sh
. "${test_dir}"/test_scala_jvm_flags.sh
. "${test_dir}"/test_scala_jacocorunner.sh
. "${test_dir}"/test_scala_library_jar.sh
. "${test_dir}"/test_scala_proto_library.sh
. "${test_dir}"/test_scala_library.sh
. "${test_dir}"/test_scala_specs2.sh
. "${test_dir}"/test_scala_test_testfilter.sh
. "${test_dir}"/test_toolchain.sh
. "${test_dir}"/test_strict_dependency.sh
. "${test_dir}"/test_unused_dependency.sh
. "${test_dir}"/test_compiler_dependency_tracking.sh
. "${test_dir}"/test_twitter_scrooge.sh
. "${test_dir}"/test_inherited_environment.sh
. "${test_dir}"/test_persistent_worker.sh
. "${test_dir}"/test_semanticdb.sh
. "${test_dir}"/test_scaladoc.sh
. "${test_dir}"/test_invalid_scalacopts.sh
