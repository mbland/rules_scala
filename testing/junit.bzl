load("//junit:junit.bzl", _repositories = "junit_repositories")

def junit_repositories(**kwargs):
    _repositories(**kwargs)

def junit_toolchain():
    native.register_toolchains("@io_bazel_rules_scala//testing:junit_toolchain")
