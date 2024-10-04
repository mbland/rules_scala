"""Prepares the precompiled protoc toolchain"""

load("@platforms//host:constraints.bzl", "HOST_CONSTRAINTS")

PROTOBUF_VERSION = "28.2"
PROTOBUF_SHA256 = (
    "b2340aa47faf7ef10a0328190319d3f3bee1b24f426d4ce8f4253b6f27ce16db"
)
PROTOBUF_URL = (
    "https://github.com/protocolbuffers/protobuf/releases/download/" +
    "v{version}/protobuf-{version}.tar.gz".format(version=PROTOBUF_VERSION)
)

_PROTOC_RELEASES_URL = "https://github.com/protocolbuffers/protobuf/releases"
_PROTOC_DOWNLOAD_URL = (
    _PROTOC_RELEASES_URL + "/download/" +
    "v{version}/protoc-{version}-".format(version=PROTOBUF_VERSION) +
    "{platform}.zip"
)

_PROTOC_BUILDS = {
    "linux-aarch_64": struct(
        integrity = "sha256-kdglPNwPDw/FHCtpyAZ3mWYy9SWthFBL+ltO44rT5Jw=",
        exec_compat = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
    ),
    "linux-ppcle_64": struct(
        integrity = "sha256-xcFrR2f/iGYJDuEOhwkDABBSAbXbHs7zgO3XPCM03Ng=",
        exec_compat = [
            "@platforms//os:linux",
            "@platforms//cpu:ppc64le",
        ],
    ),
    "linux-s390_64": struct(
        integrity = "sha256-ESIsQ4+G6Hsv2vaKKmzB2ytiKBP9btiRUJ4vOw4F7hs=",
        exec_compat = [
            "@platforms//os:linux",
            "@platforms//cpu:s390x",
        ],
    ),
    "linux-x86_32": struct(
        integrity = "sha256-ucjToo5Lq5WcwQ5smjjxfFlGc3Npv+AT9RqG19Ns//E=",
        exec_compat = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_32"
        ],
    ),
    "linux-x86_64": struct(
        integrity = "sha256-L+v9QrWc6Too63iQGaRwo90ESWGbwE+E2tEzPaJh3sE=",
        exec_compat = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64"
        ],
    ),
    "osx-aarch_64": struct(
        integrity = "sha256-e7BI9ShBeJ2exhmDvgzkyeT7O9mhQ0YoILqaO+CgN5c=",
        exec_compat = [
            "@platforms//os:osx",
            "@platforms//cpu:aarch64",
        ],
    ),
    "osx-x86_64": struct(
        integrity = "sha256-Iy8H0Sv0gGIHp57CxzeDAcUuby9+/dIcDdQW8L2hA+w=",
        exec_compat = [
            "@platforms//os:osx",
            "@platforms//cpu:x86_64"
        ],
    ),
    "win32": struct(
        integrity = "sha256-V6hpbqvtUgl19PpGkUGwuC+iEIYj0YtyOqi+yae0u1g=",
        exec_compat = [
            "@platforms//os:windows",
            "@platforms//cpu:x86_32"
        ],
    ),
    "win64": struct(
        integrity = "sha256-S94ZJx7XyrkANXDyjG5MTXGWPq8SEahr87sl2biVF3o=",
        exec_compat = [
            "@platforms//os:windows",
            "@platforms//cpu:x86_64"
        ],
    ),
}

_PROTOC_BUILD_TEMPLATE="""load(
    "@com_google_protobuf//bazel/toolchains:proto_toolchain.bzl",
    "proto_toolchain",
)

proto_toolchains = {{
{proto_toolchains}
}}

[
    proto_toolchain(
        name = build,
        proto_compiler = ":%s/bin/protoc%s" % (
            build, ".exe" if build.startswith("win") else ""
        ),
        exec_compatible_with = specs,
    )
    for build, specs in proto_toolchains.items()
]
"""

_PROTOC_TOOLCHAIN_INFO_TEMPLATE= """    {build}: [\n{specs}\n    ],"""

def _default_protoc_build():
    host_platform = sorted(HOST_CONSTRAINTS)
    for build, info in _PROTOC_BUILDS.items():
        if sorted(info.exec_compat) == host_platform:
            return build
    fail(
        "no protoc build from version %s found " % PROTOBUF_VERSION +
        "for host platform with constraints: %s" % HOST_CONSTRAINTS
    )

def _download_protoc_and_emit_toolchain_info(repository_ctx, build):
    if build not in _PROTOC_BUILDS:
        fail(
            "no protoc build from version %s found " % PROTOBUF_VERSION +
            "with build identifier: %s" % build
        )

    protoc_build = _PROTOC_BUILDS[build]
    repository_ctx.download_and_extract(
        url = _PROTOC_DOWNLOAD_URL.format(platform = build),
        output = build,
        integrity = protoc_build.integrity,
    )
    return _PROTOC_TOOLCHAIN_INFO_TEMPLATE.format(
        build = '"%s"' % build,
        specs = "\n".join([
            '        "%s",' % s for s in protoc_build.exec_compat
        ])
    )

def _protoc_toolchains_impl(repository_ctx):
    builds = repository_ctx.attr.builds

    if len(builds) == 0:
        builds = [_default_protoc_build()]

    proto_toolchains = [
        _download_protoc_and_emit_toolchain_info(repository_ctx, build)
        for build in builds
    ]
    build_content = _PROTOC_BUILD_TEMPLATE.format(
        name = repository_ctx.attr.name,
        proto_toolchains = "\n".join(proto_toolchains)
    )
    repository_ctx.file("BUILD", content=build_content, executable=False)

protoc_toolchains = repository_rule(
    implementation = _protoc_toolchains_impl,
    attrs = {
        "builds": attr.string_list(
            doc = (
                "os and arch identifiers for precompiled protoc release " +
                "download filenames from " + _PROTOC_RELEASES_URL +
                "; if unspecified, will use the identifier matching the " +
                "HOST_CONSTRAINTS from @platforms//host:constraints.bzl"
            ),
        ),
    }
)
