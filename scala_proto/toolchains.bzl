load(
    "//scala_proto:scala_proto_toolchain.bzl",
    "scala_proto_deps_toolchain",
    "scala_proto_toolchain",
)
load(
    "//scala_proto/default:default_deps.bzl",
    "DEFAULT_SCALAPB_COMPILE_DEPS",
    "DEFAULT_SCALAPB_GRPC_DEPS",
)
load("//scala:providers.bzl", "declare_deps_provider")
load("//scala_proto/private:toolchain_deps.bzl", "export_scalapb_toolchain_deps")
load("//scala:artifacts.bzl", "versioned_artifact_repos")

# We only publicly export one provider.
DEP_PROVIDERS = [
    "scalapb_compile_deps",
    "scalapb_grpc_deps",
    "scalapb_worker_deps",
]

def scala_proto_register_toolchains():
    native.register_toolchains("@io_bazel_rules_scala//scala_proto:default_toolchain")

def scala_proto_register_enable_all_options_toolchain():
    native.register_toolchains("@io_bazel_rules_scala//scala_proto:enable_all_options_toolchain")

def setup_scala_proto_toolchains(name, enable_all_options = False):
    scala_proto_deps_toolchain(
        name = "%s_default_deps_toolchain_impl" % name,
        dep_providers = [":%s_provider" % p for p in DEP_PROVIDERS],
        visibility = ["//visibility:public"],
    )

    native.toolchain(
        name = "%s_default_deps_toolchain" % name,
        toolchain = ":%s_default_deps_toolchain_impl" % name,
        toolchain_type = (
            "@io_bazel_rules_scala//scala_proto:deps_toolchain_type"
        ),
    )

    toolchain_name = "%s_default_toolchain" % name
    toolchain_impl_name = "%s_default_toolchain_impl" % name
    toolchain_options = {
        "with_flat_package": False,
        "with_grpc": True,
        "with_single_line_to_string": False,
    }

    if enable_all_options:
        toolchain_name = "%s_enable_all_options_toolchain" % name
        toolchain_impl_name = "%s_enable_all_options_toolchain_impl" % name
        toolchain_options["with_flat_package"] = True
        toolchain_options["with_single_line_to_string"] = True

    scala_proto_toolchain(
        name = toolchain_impl_name,
        visibility = ["//visibility:public"],
        **toolchain_options,
    )

    native.toolchain(
        name = toolchain_name,
        toolchain = ":%s" % toolchain_impl_name,
        toolchain_type = "@io_bazel_rules_scala//scala_proto:toolchain_type",
        visibility = ["//visibility:public"],
    )

    declare_deps_provider(
        name = "scalapb_compile_deps_provider",
        deps_id = "scalapb_compile_deps",
        visibility = ["//visibility:public"],
        deps = DEFAULT_SCALAPB_COMPILE_DEPS,
    )

    declare_deps_provider(
        name = "scalapb_grpc_deps_provider",
        deps_id = "scalapb_grpc_deps",
        visibility = ["//visibility:public"],
        deps = DEFAULT_SCALAPB_GRPC_DEPS,
    )

    declare_deps_provider(
        name = "scalapb_worker_deps_provider",
        deps_id = "scalapb_worker_deps",
        visibility = ["//visibility:public"],
        deps = [
            "@com_google_protobuf//:protobuf_java",
        ] + versioned_artifact_repos([
            "@scala_proto_rules_protoc_bridge",
            "@scala_proto_rules_scalapb_plugin",
        ]),
    )
