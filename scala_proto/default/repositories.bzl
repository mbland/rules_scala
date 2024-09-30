load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("//third_party/repositories:repositories.bzl", "repositories")
load("@io_bazel_rules_scala_config//:config.bzl", "SCALA_VERSION")

def scala_proto_default_repositories(
        maven_servers = default_maven_server_urls(),
        scala_version = SCALA_VERSION,
        overriden_artifacts = {},
        register_toolchains = True):
    repositories(
        scala_version = scala_version,
        for_artifact_ids = [
            "scala_proto_rules_scalapb_plugin",
            "scala_proto_rules_protoc_bridge",
            "scala_proto_rules_scalapb_runtime",
            "scala_proto_rules_scalapb_runtime_grpc",
            "scala_proto_rules_scalapb_lenses",
            "scala_proto_rules_scalapb_fastparse",
            "scala_proto_rules_grpc_core",
            "scala_proto_rules_grpc_api",
            "scala_proto_rules_grpc_stub",
            "scala_proto_rules_grpc_protobuf",
            "scala_proto_rules_grpc_netty",
            "scala_proto_rules_grpc_context",
            "scala_proto_rules_perfmark_api",
            "scala_proto_rules_guava",
            "scala_proto_rules_google_instrumentation",
            "scala_proto_rules_netty_codec",
            "scala_proto_rules_netty_codec_http",
            "scala_proto_rules_netty_codec_socks",
            "scala_proto_rules_netty_codec_http2",
            "scala_proto_rules_netty_handler",
            "scala_proto_rules_netty_buffer",
            "scala_proto_rules_netty_transport",
            "scala_proto_rules_netty_resolver",
            "scala_proto_rules_netty_common",
            "scala_proto_rules_netty_handler_proxy",
            "scala_proto_rules_opencensus_api",
            "scala_proto_rules_opencensus_impl",
            "scala_proto_rules_disruptor",
            "scala_proto_rules_opencensus_impl_core",
            "scala_proto_rules_opencensus_contrib_grpc_metrics",
        ],
        maven_servers = maven_servers,
        fetch_sources = True,
        overriden_artifacts = overriden_artifacts,
    )

    if register_toolchains:
        native.register_toolchains(
            "@io_bazel_rules_scala//scala_proto:default_deps_toolchain"
        )
