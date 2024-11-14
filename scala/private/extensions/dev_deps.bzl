"""Repositories for testing rules_scala itself"""

load("//scala/private:macros/bzlmod.bzl", "get_root_module", "get_tag_values")
load("//scala:scala_cross_version.bzl", "default_maven_server_urls")
load("//scala:scala_maven_import_external.bzl", "java_import_external")
load("//test/toolchains:jdk.bzl", "remote_jdk21_repositories")
load("//testing/private:repositories.bzl", "testing_repositories")
load("@rules_java//java:repositories.bzl", "remote_jdk8_repos")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(
    "@bazel_tools//tools/build_defs/repo:local.bzl",
    "local_repository",
    "new_local_repository",
)

_BUILD_TOOLS_RELEASE = "5.1.0"

_settings_defaults = {
    "maven_servers": default_maven_server_urls(),
    "fetch_sources": False,
}

_settings = tag_class(
    attrs = {
        "maven_servers": attr.string_list(
            default = _settings_defaults["maven_servers"],
        ),
        "fetch_sources": attr.bool(
            default = _settings_defaults["fetch_sources"],
        ),
    },
)

def _dev_deps_impl(module_ctx):
    """Instantiate internal only repos for development and testing

    Mostly just copied from `WORKSPACE`, and adapted slightly. Also currently
    incompatible with Bazel 6, given `new_local_repository` isn't Starlarkified
    in that version. Will eventually find a way to move this into a macro shared
    by both WORKSPACE and MODULE.bazel. Will probably create proper repos
    instead of using `new_local_repository` as well.
    """
    settings = _settings_defaults
    root_module = get_root_module(module_ctx)
    if root_module != None:
        settings = get_tag_values(root_module.tags.settings, settings)

    testing_repositories(**settings)

    # We need to select based on platform when we use these
    # https://github.com/bazelbuild/bazel/issues/11655
    remote_jdk8_repos()
    remote_jdk21_repositories(bzlmod_enabled = True)

    local_repository(
        name = "example_external_workspace",
        path = "third_party/test/example_external_workspace",
    )

    new_local_repository(
        name = "proto_cross_repo_boundary",
        path = "test/proto_cross_repo_boundary/repo",
        build_file = "//test/proto_cross_repo_boundary:repo/BUILD.repo",
    )

    new_local_repository(
        name = "test_new_local_repo",
        build_file_content = """
filegroup(
    name = "data",
    srcs = glob(["**/*.txt"]),
    visibility = ["//visibility:public"],
)
""",
        path = "third_party/test/new_local_repo",
    )

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

    http_archive(
        name = "com_github_bazelbuild_buildtools",
        sha256 = "e3bb0dc8b0274ea1aca75f1f8c0c835adbe589708ea89bf698069d0790701ea3",
        strip_prefix = "buildtools-%s" % _BUILD_TOOLS_RELEASE,
        url = "https://github.com/bazelbuild/buildtools/archive/%s.tar.gz" % _BUILD_TOOLS_RELEASE,
    )

dev_deps = module_extension(
    implementation = _dev_deps_impl,
    tag_classes = {
        "settings": _settings,
    },
)
