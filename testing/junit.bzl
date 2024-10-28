load("//junit:junit.bzl", _repositories = "junit_repositories")
load("//testing/toolchain:toolchain.bzl", "register_testing_toolchains")

def junit_repositories(**kwargs):
    _repositories(**kwargs)

def junit_toolchain():
    register_testing_toolchains()
