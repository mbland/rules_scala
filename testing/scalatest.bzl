load("//scalatest:scalatest.bzl", _repositories = "scalatest_repositories")
load("//testing/toolchain:toolchain.bzl", "register_testing_toolchains")

def scalatest_repositories():
    _repositories()

def scalatest_toolchain():
    register_testing_toolchains()
