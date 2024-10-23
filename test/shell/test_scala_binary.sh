# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")

test_scala_binary_expect_failure_on_missing_direct_deps() {
  dependency_target='//test_expect_failure/missing_direct_deps/internal_deps:transitive_dependency'
  test_target='test_expect_failure/missing_direct_deps/internal_deps:user_binary'

  test_scala_library_expect_failure_on_missing_direct_deps ${dependency_target} ${test_target}
}

test_scala_binary_expect_failure_on_missing_direct_deps_located_in_dependency_which_is_scala_binary() {
  dependency_target='//test_expect_failure/missing_direct_deps/internal_deps:transitive_dependency'
  test_target='test_expect_failure/missing_direct_deps/internal_deps:binary_user_of_binary'

  test_scala_library_expect_failure_on_missing_direct_deps ${dependency_target} ${test_target}
}

test_scala_binary_allows_opt_in_to_use_of_argument_file_in_runner_for_improved_performance() {

  bazel run --extra_toolchains="//test/toolchains:use_argument_file_in_runner" //test/src/main/scala/scalarules/test/large_classpath:largeClasspath
  local classpath_file="bazel-bin/test/src/main/scala/scalarules/test/large_classpath/largeClasspath"
  local expected="\"argsfile\" == \"argsfile\""
  if [[ ! "$(< $classpath_file)" =~ $expected ]]; then
    echo -e "${RED} Binary script does not use the argument file. $NC"
    exit -1
  fi

  bazel run //test/src/main/scala/scalarules/test/large_classpath:largeClasspath
  expected="\"manifest\" == \"argsfile\""
  if [[ ! "$(< $classpath_file)" =~ $expected ]]; then
    echo -e "${RED} Binary script does not use the classpath jar. $NC"
    exit -1
  fi

}

$runner test_scala_binary_expect_failure_on_missing_direct_deps
$runner test_scala_binary_expect_failure_on_missing_direct_deps_located_in_dependency_which_is_scala_binary

if !  is_windows; then
  #rules_scala doesn't support argfiles on windows yet
  $runner test_scala_binary_allows_opt_in_to_use_of_argument_file_in_runner_for_improved_performance
fi
