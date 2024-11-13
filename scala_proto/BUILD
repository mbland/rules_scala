load("//scala:providers.bzl", "declare_deps_provider")
load(
    "//scala_proto/default:default_deps.bzl",
    "DEFAULT_SCALAPB_COMPILE_DEPS",
    "DEFAULT_SCALAPB_GRPC_DEPS",
    "DEFAULT_SCALAPB_WORKER_DEPS",
)
load("//scala_proto/private:toolchain_deps.bzl", "export_scalapb_toolchain_deps")
load(
    "//scala_proto/private:toolchain_deps.bzl",
    "export_scalapb_toolchain_deps",
)

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

toolchain_type(
    name = "deps_toolchain_type",
    visibility = ["//visibility:public"],
)

export_scalapb_toolchain_deps(
    name = "scalapb_worker_deps",
    deps_id = "scalapb_worker_deps",
    visibility = ["//visibility:public"],
)
