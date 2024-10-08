# These are the compile/runtime dependencies needed for scalapb compilation
# and grpc compile/runtime.
#
# In a complex environment you may want to update the toolchain to not refer to these anymore
# If you are using a resolver (like bazel-deps) that can export compile + runtime jar paths
# for you, then you should only need much shorter dependency lists. This needs to be the unrolled
# transitive path to be used without such a facility.

load("//scala:artifacts.bzl", "versioned_artifact_repos")

_DEFAULT_DEP_PROVIDER_FORMAT = (
    "@io_bazel_rules_scala_toolchains//scala_proto:scalapb_%s_deps_provider"
)

def scala_proto_deps_providers(
    compile = _DEFAULT_DEP_PROVIDER_FORMAT % "compile",
    grpc = _DEFAULT_DEP_PROVIDER_FORMAT % "grpc",
    worker = _DEFAULT_DEP_PROVIDER_FORMAT % "worker",
):
    return [ compile, grpc, worker ]

DEFAULT_SCALAPB_COMPILE_DEPS = versioned_artifact_repos([
    "@scala_proto_rules_scalapb_runtime",
    "@scala_proto_rules_scalapb_lenses",
    "@scala_proto_rules_scalapb_fastparse",
]) + [
    "@com_google_protobuf//:protobuf_java",
    Label("//scala/private/toolchain_deps:scala_library_classpath"),
]

DEFAULT_SCALAPB_GRPC_DEPS = versioned_artifact_repos([
    "@scala_proto_rules_grpc_api",
    "@scala_proto_rules_perfmark_api",
    "@scala_proto_rules_scalapb_runtime_grpc",
    "@scala_proto_rules_grpc_core",
    "@scala_proto_rules_grpc_stub",
    "@scala_proto_rules_grpc_protobuf",
    "@scala_proto_rules_grpc_netty",
    "@scala_proto_rules_grpc_context",
    "@scala_proto_rules_guava",
    "@scala_proto_rules_opencensus_api",
    "@scala_proto_rules_opencensus_impl",
    "@scala_proto_rules_disruptor",
    "@scala_proto_rules_opencensus_impl_core",
    "@scala_proto_rules_opencensus_contrib_grpc_metrics",
    "@scala_proto_rules_google_instrumentation",
    "@scala_proto_rules_netty_codec",
    "@scala_proto_rules_netty_codec_http",
    "@scala_proto_rules_netty_codec_http2",
    "@scala_proto_rules_netty_codec_socks",
    "@scala_proto_rules_netty_handler",
    "@scala_proto_rules_netty_buffer",
    "@scala_proto_rules_netty_transport",
    "@scala_proto_rules_netty_resolver",
    "@scala_proto_rules_netty_common",
    "@scala_proto_rules_netty_handler_proxy",
])

DEFAULT_SCALAPB_WORKER_DEPS = versioned_artifact_repos([
    "@scala_proto_rules_protoc_bridge",
    "@scala_proto_rules_scalapb_plugin",
]) + [
    "@com_google_protobuf//:protobuf_java",
]
