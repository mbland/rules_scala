load(
    "//scala_proto:scala_proto_toolchain.bzl",
    "scala_proto_deps_toolchain",
    "scala_proto_toolchain",
)

def scala_proto_register_toolchains():
    native.register_toolchains("@io_bazel_rules_scala//scala_proto:default_toolchain")

def scala_proto_register_enable_all_options_toolchain():
    native.register_toolchains("@io_bazel_rules_scala//scala_proto:enable_all_options_toolchain")

def setup_scala_proto_toolchains(name, enable_all_options = False):
    scala_proto_deps_toolchain(
        name = "%s_default_deps_toolchain_impl" % name,
        dep_providers = [
            ":scalapb_%s_deps_provider" % p
            for p in ["compile", "grpc", "worker"]
        ],
        visibility = ["//visibility:public"],
    )

    native.toolchain(
        name = "%s_default_deps_toolchain" % name,
        toolchain = ":%s_default_deps_toolchain_impl" % name,
        toolchain_type = Label("//scala_proto:deps_toolchain_type"),
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
        **toolchain_options
    )

    native.toolchain(
        name = toolchain_name,
        toolchain = ":" + toolchain_impl_name,
        toolchain_type = Label("//scala_proto:toolchain_type"),
        visibility = ["//visibility:public"],
    )
