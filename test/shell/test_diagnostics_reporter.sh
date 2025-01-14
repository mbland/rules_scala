# Diagnostics Reporters Tests. Diagnostics definition based off the definition provided by the LSP

# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
runner=$(get_test_runner "${1:-local}")

do_test_diagnostics_reporter() {
  local test_pkg="test_expect_failure/diagnostics_reporter"
  local toolchain="//$test_pkg:$1"
  local diagnostics_output="$(bazel info bazel-bin)/$test_pkg"

  # Explicitly download the .diagnosticsproto files when building remotely,
  # because Bazel won't download them for successful targets by default.
  bazel build --build_event_publish_all_actions -k \
    "--extra_toolchains=$toolchain" \
    "--remote_download_regex=.*/$test_pkg/.*\.diagnosticsproto$" \
    //test_expect_failure/diagnostics_reporter:all || true

  # The path to the Java toolchain in the generated launcher script will match
  # the target platform. .bazelrc may configure a different execution platform,
  # such as when building and testing with remote execution. In that case,
  # `bazel run` will fail without setting `--platforms` to match the host.
  bazel run --platforms=@platforms//host \
    //test/diagnostics_reporter:diagnostics_reporter_test "$diagnostics_output"
}

test_diagnostics_reporter() {
  do_test_diagnostics_reporter diagnostics_reporter_toolchain
}

test_diagnostics_reporter_with_semanticdb() {
  do_test_diagnostics_reporter diagnostics_reporter_and_semanticdb_toolchain
}

$runner test_diagnostics_reporter
$runner test_diagnostics_reporter_with_semanticdb
