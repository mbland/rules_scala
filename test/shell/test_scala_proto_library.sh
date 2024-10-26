# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")

test_scala_proto_library_action_label() {
  cd third_party/test/proto
  local expected="action 'scala @{0,2}//:proto'"
  local action=$(bazel aquery --include_aspects 'mnemonic("Scalac", //...)' | grep ^action | head -n 1)
  if [ "$action" != $expected ]; then
    echo "Expected \"$expected\" but got \"$action\""
    exit 1
  fi
}

test_scala_proto_custom_generator() {
  bazel test //test/proto/custom_generator:DummyGeneratorTest \
  --extra_toolchains=//test/proto/custom_generator:scala_proto_deps_toolchain \
  --extra_toolchains=//test/proto/custom_generator:scala_proto_toolchain
}

test_scala_proto_show_generator_exception() {
  action_should_fail_with_message \
    "java.lang.RuntimeException: expected generator failure" \
    build //test/proto/custom_generator:any_proto_scala \
    --extra_toolchains=//test/proto/custom_generator:failing_scala_proto_deps_toolchain \
    --extra_toolchains=//test/proto/custom_generator:failing_scala_proto_toolchain
}

$runner test_scala_proto_library_action_label
$runner test_scala_proto_custom_generator
$runner test_scala_proto_show_generator_exception
