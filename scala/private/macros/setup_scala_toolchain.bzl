load(
    "//scala:scala_toolchain.bzl",
    "scala_toolchain",
    "toolchain_attrs",
    "toolchain_defaults",
)
load("//scala:providers.bzl", "declare_deps_provider")
load("//scala:scala_cross_version.bzl", "repositories", "version_suffix")
load("@rules_scala_config//:config.bzl", "SCALA_VERSION")

TOOLCHAIN_DEFAULTS = {
    "name": "scala_toolchain" + version_suffix(SCALA_VERSION),
    "scala_compile_classpath": [],
    "scala_library_classpath": [],
    "scala_macro_classpath": [],
    "scala_version": SCALA_VERSION,
    "scala_xml_deps": [],
    "parser_combinators_deps": [],
    "semanticdb_deps": [],
    "enable_semanticdb": False,
    "toolchain_type": Label("//scala:toolchain_type"),
    "visibility": [Label("//visibility:public")],
} | toolchain_defaults

_defaults = TOOLCHAIN_DEFAULTS

TOOLCHAIN_ATTRS = {
    "name": attr.string(default = _defaults["name"]),
    "scala_compile_classpath": attr.label_list(
        default = _defaults["scala_compile_classpath"],
        doc = "Scala compiler JAR targets",
    ),
    "scala_library_classpath": attr.label_list(
        default = _defaults["scala_library_classpath"],
        doc = "Scala library JAR targets",
    ),
    "scala_macro_classpath": attr.label_list(
        default = _defaults["scala_macro_classpath"],
        doc = "Scala macro JAR targets",
    ),
    "scala_version": attr.string(
        default = _defaults["scala_version"],
    ),
    "scala_xml_deps": attr.label_list(
        default = _defaults["scala_xml_deps"],
        doc = "Scala XML JAR targets",
    ),
    "parser_combinators_deps": attr.label_list(
        default = _defaults["parser_combinators_deps"],
        doc = "Parser combinators JAR targets",
    ),
    "semanticdb_deps": attr.label_list(
        default = _defaults["semanticdb_deps"],
        doc = "Semantic DB JAR targets",
    ),
    "enable_semanticdb": attr.bool(
        default = _defaults["enable_semanticdb"],
        doc = "Enable Semantic DB",
    ),
    "toolchain_type": attr.label(
        default = _defaults["toolchain_type"],
    ),
    "visibility": attr.label_list(
        default = _defaults["visibility"],
    ),
} | toolchain_attrs

def setup_scala_toolchain(
        name,
        scala_compile_classpath = None,
        scala_library_classpath = None,
        scala_macro_classpath = None,
        scala_version = SCALA_VERSION,
        scala_xml_deps = None,
        parser_combinators_deps = None,
        semanticdb_deps = None,
        enable_semanticdb = False,
        toolchain_type = _defaults["toolchain_type"],
        visibility = _defaults["visibility"],
        **kwargs):
    scala_xml_provider = "%s_scala_xml_provider" % name
    parser_combinators_provider = "%s_parser_combinators_provider" % name
    scala_compile_classpath_provider = "%s_scala_compile_classpath_provider" % name
    scala_library_classpath_provider = "%s_scala_library_classpath_provider" % name
    scala_macro_classpath_provider = "%s_scala_macro_classpath_provider" % name
    semanticdb_deps_provider = "%s_semanticdb_deps_provider" % name

    if not scala_compile_classpath:
        scala_compile_classpath = default_deps("scala_compile_classpath", scala_version)
    declare_deps_provider(
        name = scala_compile_classpath_provider,
        deps_id = "scala_compile_classpath",
        visibility = visibility,
        deps = scala_compile_classpath,
    )

    if not scala_library_classpath:
        scala_library_classpath = default_deps("scala_library_classpath", scala_version)
    declare_deps_provider(
        name = scala_library_classpath_provider,
        deps_id = "scala_library_classpath",
        visibility = visibility,
        deps = scala_library_classpath,
    )

    if not scala_macro_classpath:
        scala_macro_classpath = default_deps("scala_macro_classpath", scala_version)
    declare_deps_provider(
        name = scala_macro_classpath_provider,
        deps_id = "scala_macro_classpath",
        visibility = visibility,
        deps = scala_macro_classpath,
    )

    if not scala_xml_deps:
        scala_xml_deps = default_deps("scala_xml", scala_version)
    declare_deps_provider(
        name = scala_xml_provider,
        deps_id = "scala_xml",
        visibility = visibility,
        deps = scala_xml_deps,
    )

    if not parser_combinators_deps:
        parser_combinators_deps = default_deps("parser_combinators", scala_version)
    declare_deps_provider(
        name = parser_combinators_provider,
        deps_id = "parser_combinators",
        visibility = visibility,
        deps = parser_combinators_deps,
    )

    dep_providers = [
        scala_xml_provider,
        parser_combinators_provider,
        scala_compile_classpath_provider,
        scala_library_classpath_provider,
        scala_macro_classpath_provider,
    ]

    if enable_semanticdb == True or semanticdb_deps:
        if not semanticdb_deps:
            semanticdb_deps = default_deps("semanticdb", scala_version)
        declare_deps_provider(
            name = semanticdb_deps_provider,
            deps_id = "semanticdb",
            deps = semanticdb_deps,
            visibility = visibility,
        )
        dep_providers.append(semanticdb_deps_provider)

    scala_toolchain(
        name = "%s_impl" % name,
        dep_providers = dep_providers,
        enable_semanticdb = enable_semanticdb,
        visibility = visibility,
        **kwargs
    )

    native.toolchain(
        name = name,
        toolchain = ":%s_impl" % name,
        toolchain_type = toolchain_type,
        target_settings = [
            "@rules_scala_config//:scala_version" +
            version_suffix(scala_version),
        ],
        visibility = visibility,
    )

_DEFAULT_DEPS = {
    "scala_compile_classpath": {
        "any": [
            "@io_bazel_rules_scala_scala_compiler",
            "@io_bazel_rules_scala_scala_library",
        ],
        "2": [
            "@io_bazel_rules_scala_scala_reflect",
        ],
        "3": [
            "@io_bazel_rules_scala_scala_interfaces",
            "@io_bazel_rules_scala_scala_tasty_core",
            "@io_bazel_rules_scala_scala_asm",
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scala_sbt_compiler_interface",
        ],
    },
    "scala_library_classpath": {
        "any": [
            "@io_bazel_rules_scala_scala_library",
        ],
        "2": [
            "@io_bazel_rules_scala_scala_reflect",
        ],
        "3": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "scala_macro_classpath": {
        "any": [
            "@io_bazel_rules_scala_scala_library",
        ],
        "2": [
            "@io_bazel_rules_scala_scala_reflect",
        ],
        "3": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "scala_xml": {
        "any": ["@io_bazel_rules_scala_scala_xml"],
    },
    "parser_combinators": {
        "any": ["@io_bazel_rules_scala_scala_parser_combinators"],
    },
    "semanticdb": {
        "2": ["@org_scalameta_semanticdb_scalac"],
    },
}

def default_deps(deps_id, scala_version):
    versions = _DEFAULT_DEPS[deps_id]
    deps = versions.get("any", []) + versions.get(scala_version[0], [])
    return repositories(scala_version, deps)
