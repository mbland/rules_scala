"""Prepares the precompiled protoc toolchain"""

load(":protoc/protoc_integrity.bzl", "PROTOC_BUILDS", "PROTOC_DOWNLOAD_URL")
load("@com_google_protobuf//:protobuf_version.bzl", "PROTOC_VERSION")
load("@platforms//host:constraints.bzl", "HOST_CONSTRAINTS")

def _default_protoc_platform():
    host_platform = sorted(HOST_CONSTRAINTS)
    for platform, info in PROTOC_BUILDS.items():
        if sorted(info["exec_compat"]) == host_platform:
            return platform
    fail(
        "no protoc build found for host platform with constraints: " +
        HOST_CONSTRAINTS,
    )

_PROTOC_TOOLCHAIN_INFO_TEMPLATE = """    "{platform}": [\n{specs}\n    ],"""

def _download_protoc_and_emit_toolchain_info(repository_ctx, platform):
    if platform not in PROTOC_BUILDS:
        fail("no protoc build found for platform: " + platform)

    protoc_build = PROTOC_BUILDS[platform]
    integrity = protoc_build["integrity"].get(PROTOC_VERSION)

    if not integrity:
        fail(
            "no protoc %s build found for platform: %s" %
            (PROTOC_VERSION, platform),
        )

    repository_ctx.download_and_extract(
        url = PROTOC_DOWNLOAD_URL.format(
            platform = platform,
            version = PROTOC_VERSION,
        ),
        output = "protoc/" + platform,
        integrity = integrity,
    )
    return _PROTOC_TOOLCHAIN_INFO_TEMPLATE.format(
        platform = platform,
        specs = "\n".join([
            '        "%s",' % s
            for s in protoc_build["exec_compat"]
        ]),
    )

def generate_protoc_toolchains(repository_ctx):
    platforms = repository_ctx.attr.protoc_platforms

    if len(platforms) == 0:
        platforms = [_default_protoc_platform()]

    return "\n".join([
        _download_protoc_and_emit_toolchain_info(repository_ctx, platform)
        for platform in platforms
    ])
