load("//specs2:specs2_junit.bzl", _repositories = "specs2_junit_repositories")
load("//testing/toolchain:toolchain.bzl", "register_testing_toolchains")

def specs2_junit_repositories():
    _repositories()

def specs2_junit_toolchain():
    register_testing_toolchains()
