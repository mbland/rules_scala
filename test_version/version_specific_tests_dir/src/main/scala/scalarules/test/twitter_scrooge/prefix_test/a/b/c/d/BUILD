load("@rules_scala//thrift:thrift.bzl", "thrift_library")
load("@rules_scala//twitter_scrooge:twitter_scrooge.bzl", "scrooge_scala_library")

thrift_library(
    name = "a_thrift",
    srcs = ["A.thrift"],
    absolute_prefix = "prefix_test/a",
    visibility = ["//visibility:public"],
)

scrooge_scala_library(
    name = "d",
    visibility = ["//visibility:public"],
    deps = [
        ":a_thrift",
    ],
)
