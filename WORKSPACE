workspace(name = "io_bazel_rules_scala")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

_build_tools_release = "5.1.0"

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "e3bb0dc8b0274ea1aca75f1f8c0c835adbe589708ea89bf698069d0790701ea3",
    strip_prefix = "buildtools-%s" % _build_tools_release,
    url = "https://github.com/bazelbuild/buildtools/archive/%s.tar.gz" % _build_tools_release,
)

load("@io_bazel_rules_scala//:scala_config.bzl", "scala_config")

scala_config(enable_compiler_dependency_tracking = True)

load("//scala:scala.bzl", "rules_scala_setup", "rules_scala_toolchain_deps_repositories")

rules_scala_setup()

rules_scala_toolchain_deps_repositories(fetch_sources = True)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies")

rules_proto_dependencies()

load("@rules_proto//proto:setup.bzl", "rules_proto_setup")

rules_proto_setup()

load("@rules_proto//proto:toolchains.bzl", "rules_proto_toolchains")

rules_proto_toolchains()

load("//scala:protoc_deps.bzl", "scala_protoc_setup")

scala_protoc_setup()

load("//scala:protoc_toolchain.bzl", "protoc_toolchains")

protoc_toolchains(name = "io_bazel_rules_scala_protoc")
register_toolchains("@io_bazel_rules_scala_protoc//:all")

load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("//twitter_scrooge:twitter_scrooge.bzl", "twitter_scrooge")

twitter_scrooge()

load("//jmh:jmh.bzl", "jmh_repositories")

jmh_repositories()

load("//scala_proto:scala_proto.bzl", "scala_proto_repositories")

scala_proto_repositories()

load("//scalatest:scalatest.bzl", "scalatest_repositories")

scalatest_repositories()

load("//specs2:specs2_junit.bzl", "specs2_junit_repositories")

specs2_junit_repositories()

register_toolchains("//testing:testing_toolchain")

load("//scala/scalafmt:scalafmt_repositories.bzl", "scalafmt_default_config", "scalafmt_repositories")

scalafmt_default_config()

scalafmt_repositories()

MAVEN_SERVER_URLS = default_maven_server_urls()

# needed for the cross repo proto test
load("//test/proto_cross_repo_boundary:repo.bzl", "proto_cross_repo_boundary_repository")

proto_cross_repo_boundary_repository()

new_local_repository(
    name = "test_new_local_repo",
    build_file_content =
        """
filegroup(
    name = "data",
    srcs = glob(["**/*.txt"]),
    visibility = ["//visibility:public"],
)
""",
    path = "third_party/test/new_local_repo",
)

local_repository(
    name = "example_external_workspace",
    path = "third_party/test/example_external_workspace",
)

load("@io_bazel_rules_scala//scala:toolchains.bzl", "scala_register_unused_deps_toolchains")

scala_register_unused_deps_toolchains()

register_toolchains("@io_bazel_rules_scala//test/proto:scalapb_toolchain")

load("//scala:scala_maven_import_external.bzl", "java_import_external")

# bazel's java_import_external has been altered in rules_scala to be a macro based on jvm_import_external
# in order to allow for other jvm-language imports (e.g. scala_import)
# the 3rd-party dependency below is using the java_import_external macro
# in order to make sure no regression with the original java_import_external
java_import_external(
    name = "org_apache_commons_commons_lang_3_5_without_file",
    generated_linkable_rule_name = "linkable_org_apache_commons_commons_lang_3_5_without_file",
    jar_sha256 = "8ac96fc686512d777fca85e144f196cd7cfe0c0aec23127229497d1a38ff651c",
    jar_urls = ["https://repo.maven.apache.org/maven2/org/apache/commons/commons-lang3/3.5/commons-lang3-3.5.jar"],
    licenses = ["notice"],  # Apache 2.0
    neverlink = True,
    testonly_ = True,
)

## Linting

load("//private:format.bzl", "format_repositories")

format_repositories()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "f4a9314518ca6acfa16cc4ab43b0b8ce1e4ea64b81c38d8a3772883f153346b8",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.50.1/rules_go-v0.50.1.zip",
    ],
)

load(
    "@io_bazel_rules_go//go:deps.bzl",
    "go_register_toolchains",
    "go_rules_dependencies",
)

go_rules_dependencies()

go_register_toolchains(version = "1.19.5")

load("@rules_java//java:repositories.bzl", "remote_jdk8_repos")

# We need to select based on platform when we use these
# https://github.com/bazelbuild/bazel/issues/11655
remote_jdk8_repos()

http_archive(
    name = "bazelci_rules",
    sha256 = "eca21884e6f66a88c358e580fd67a6b148d30ab57b1680f62a96c00f9bc6a07e",
    strip_prefix = "bazelci_rules-1.0.0",
    url = "https://github.com/bazelbuild/continuous-integration/releases/download/rules-1.0.0/bazelci_rules-1.0.0.tar.gz",
)

load("@bazelci_rules//:rbe_repo.bzl", "rbe_preconfig")

rbe_preconfig(
    name = "rbe_default",
    toolchain = "ubuntu2004-bazel-java11",
)

load("//third_party/repositories:repositories.bzl", "repositories")

repositories(
    fetch_sources = False,
    for_artifact_ids = [
        # test adding a scala jar:
        "com_twitter__scalding_date",
        # test of strict deps (scalac plugin UT + E2E)
        "com_google_guava_guava_21_0_with_file",
        "com_github_jnr_jffi_native",
        "org_apache_commons_commons_lang_3_5",
        "com_google_guava_guava_21_0",
        # test of import external
        # scala maven import external decodes maven artifacts to its parts
        # (group id, artifact id, packaging, version and classifier). To make sure
        # the decoding and then the download url composition are working the artifact example
        # must contain all the different parts and sha256s so the downloaded content will be
        # validated against it
        "org_springframework_spring_core",
        "org_springframework_spring_tx",
        "org_typelevel_kind_projector",
        # For testing that we don't include sources jars to the classpath
        "org_typelevel__cats_core",
    ],
    maven_servers = MAVEN_SERVER_URLS,
)

load("//test/toolchains:jdk.bzl", "remote_jdk21_repositories", "remote_jdk21_toolchains")

remote_jdk21_repositories()

remote_jdk21_toolchains()

# //test_version:WORKSPACE.template dependencies

http_archive(
    name = "com_google_protobuf",
    sha256 = "b2340aa47faf7ef10a0328190319d3f3bee1b24f426d4ce8f4253b6f27ce16db",
    strip_prefix = "protobuf-28.2",
    url = "https://github.com/protocolbuffers/protobuf/releases/download/v28.2/protobuf-28.2.tar.gz",
)

http_archive(
    name = "rules_pkg",
    sha256 = "d20c951960ed77cb7b341c2a59488534e494d5ad1d30c4818c736d57772a9fef",
    url = "https://github.com/bazelbuild/rules_pkg/releases/download/1.0.1/rules_pkg-1.0.1.tar.gz",
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

RULES_JVM_EXTERNAL_TAG = "6.4"

RULES_JVM_EXTERNAL_SHA = "85776be6d8fe64abf26f463a8e12cd4c15be927348397180a01693610da7ec90"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazel-contrib/rules_jvm_external/releases/download/%s/rules_jvm_external-%s.tar.gz" % (RULES_JVM_EXTERNAL_TAG, RULES_JVM_EXTERNAL_TAG),
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

http_archive(
    name = "com_google_absl",
    sha256 = "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3",
    strip_prefix = "abseil-cpp-20240722.0",
    url = "https://github.com/abseil/abseil-cpp/releases/download/20240722.0/abseil-cpp-20240722.0.tar.gz",
)

http_archive(
    name = "zlib",
    build_file = "@com_google_protobuf//third_party:zlib.BUILD",
    sha256 = "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23",
    strip_prefix = "zlib-1.3.1",
    url = "https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz",
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()
