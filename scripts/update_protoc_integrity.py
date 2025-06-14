#!/usr/bin/env python3
"""Updates `protoc/private/protoc_integrity.bzl`.

`protoc_integrity.bzl` contains the mapping from supported precompiled `protoc`
platforms to:

- `exec_compatible_with` properties based on `@platforms`
- `integrity` strings for each of the supported `PROTOC_VERSIONS`

Only computes integrity information for a `protoc` distribution if it doesn't
already exist in the integrity file.
"""

from pathlib import Path

import argparse
import sys

from lib.update_integrity import (
    get_integrity_file_path_and_generated_by,
    get_artifact_integrity,
    stringify_object,
    load_existing_data,
)


PROTOC_VERSIONS = [
    "31.1",
    "31.0",
    "30.2",
    "30.1",
    "30.0",
    "29.3",
    "29.2",
    "29.1",
    "29.0",
]

PROTOC_RELEASES_URL = "https://github.com/protocolbuffers/protobuf/releases"
PROTOC_DOWNLOAD_SUFFIX = "/download/v{version}/protoc-{version}-{platform}.zip"
PROTOC_DOWNLOAD_URL = PROTOC_RELEASES_URL + PROTOC_DOWNLOAD_SUFFIX

PROTOC_BUILDS = {
    "linux-aarch_64": [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
    "linux-ppcle_64": [
        "@platforms//os:linux",
        "@platforms//cpu:ppc64le",
    ],
    "linux-s390_64": [
        "@platforms//os:linux",
        "@platforms//cpu:s390x",
    ],
    "linux-x86_32": [
        "@platforms//os:linux",
        "@platforms//cpu:x86_32"
    ],
    "linux-x86_64": [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64"
    ],
    "osx-aarch_64": [
        "@platforms//os:osx",
        "@platforms//cpu:aarch64",
    ],
    "osx-x86_64": [
        "@platforms//os:osx",
        "@platforms//cpu:x86_64"
    ],
    "win32": [
        "@platforms//os:windows",
        "@platforms//cpu:x86_32"
    ],
    "win64": [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64"
    ],
}

INTEGRITY_FILE, GENERATED_BY = get_integrity_file_path_and_generated_by(
    'protoc/private/protoc_integrity.bzl',
    __file__,
)
INTEGRITY_FILE_HEADER = f'''"""Protocol compiler build and integrity metadata.

{GENERATED_BY}
"""

PROTOC_RELEASES_URL = "{PROTOC_RELEASES_URL}"
PROTOC_DOWNLOAD_URL = (
    PROTOC_RELEASES_URL +
    "{PROTOC_DOWNLOAD_SUFFIX}"
)

'''


class UpdateProtocIntegrityError(Exception):
    """Errors raised explicitly by this module."""


def get_protoc_integrity(platform, version):
    """Emits the integrity string for the specified `protoc` distribution.

    This will download the distribution specified by applying `platform` and
    `version` to `PROTOC_DOWNLOAD_URL`.

    Args:
        platform: a platform key from `PROTOC_BUILDS`
        version: a valid `protobuf` version specifier

    Returns:
        a string starting with `sha256-` and ending with the base 64 encoded
            sha256 checksum of the `protoc` distribution file

    Raises:
        `UpdateIntegrityError` if downloading or checksumming fails
    """
    url = PROTOC_DOWNLOAD_URL.format(version = version, platform = platform)
    print(f'Updating protoc {version} for {platform}:\n  {url}')
    return get_artifact_integrity(url)


def add_build_data(platform, exec_compat, existing_build):
    """Adds `protoc` integrity data to `existing_build` for new protoc versions.

    Args:
        platform: a platform key from `PROTOC_BUILDS`
        exec_compat: compatibility specifier values from `PROTOC_BUILDS`
        existing_build: an existing `PROTOC_BUILDS` output value for `platform`,
            or `{}` if it doesn't yet exist

    Returns:
        a new dictionary to emit as a `PROTOC_BUILDS` entry in the output file
    """
    integrity = dict(existing_build.get("integrity", {}))

    for version in PROTOC_VERSIONS:
        if version not in integrity:
            integrity[version] = get_protoc_integrity(platform, version)

    return {
        "exec_compat": exec_compat,
        "integrity": dict(sorted(integrity.items(), reverse=True)),
    }


def emit_protoc_integrity_file(output_file, integrity_data):
    """Writes the updated `protoc` integrity data to the `output_file`.

    Args:
        output_file: path to the updated `protoc` integrity file
        integrity_data: `protoc` integrity data to emit into `output_file`
    """
    with output_file.open('w', encoding = 'utf-8') as data:
        data.write(INTEGRITY_FILE_HEADER)
        data.write("PROTOC_VERSIONS = ")
        data.write(stringify_object(PROTOC_VERSIONS))
        data.write("\nPROTOC_BUILDS = ")
        data.write(stringify_object(dict(sorted(integrity_data.items()))))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description = "Updates precompiled `protoc` distribution information.",
    )

    parser.add_argument(
        '--integrity_file',
        type=str,
        default=str(INTEGRITY_FILE),
        help=f'`protoc` integrity file path (default: {INTEGRITY_FILE})',
    )

    args = parser.parse_args()
    integrity_file = Path(args.integrity_file)

    try:
        existing_data = load_existing_data(integrity_file, 'PROTOC_BUILDS = ')
        updated_data = {
            k: add_build_data(k, v, existing_data.get(k, {}))
            for k, v in PROTOC_BUILDS.items()
        }
        emit_protoc_integrity_file(integrity_file, updated_data)

    except UpdateProtocIntegrityError as err:
        print(f'Failed to update {integrity_file}: {err}', file=sys.stderr)
        sys.exit(1)
