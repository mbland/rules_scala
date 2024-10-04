#!/usr/bin/env python3
"""Updates scala/private/protoc/protoc_integrity.bzl"""

from base64 import b64encode
from pathlib import Path

import ast
import hashlib
import json
import re
import urllib.request
import sys

PROTOC_VERSIONS = [
    "29.3",
    "29.2",
    "29.1",
    "29.0",
    "28.3",
    "28.2",
]

THIS_FILE = Path(__file__)
REPO_ROOT = THIS_FILE.parent.parent
OUTPUT_FILE = REPO_ROOT / 'scala/private/protoc/protoc_integrity.bzl'
THIS_FILE_RELATIVE_TO_REPO_ROOT = THIS_FILE.relative_to(REPO_ROOT)

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


class UpdateProtocIntegrityError(Exception):
    """Errors raised explicitly by this module."""


def get_protoc_integrity(platform, version):
    try:
        url = PROTOC_DOWNLOAD_URL.format(
          version = version,
          platform = platform
        )
        print(f'Updating protoc {version} for {platform}:')
        print(f'  {url}')

        with urllib.request.urlopen(url) as data:
            body = data.read()

        sha256 = hashlib.sha256(body).digest()
        return f'sha256-{b64encode(sha256).decode('utf-8')}'

    except Exception as err:
        msg = f'while processing {url}: {err}'
        raise UpdateProtocIntegrityError(msg) from err

def update_build_data(platform, exec_compat, orig_build):
    integrity = dict(orig_build.get("integrity", {}))

    for version in PROTOC_VERSIONS:
        if version not in integrity:
            integrity[version] = get_protoc_integrity(platform, version)

    return {
        "exec_compat": exec_compat,
        "integrity": dict(sorted(integrity.items(), reverse=True)),
    }

def stringify_object(data):
    result = (
        json.dumps(data, indent=4)
            .replace('true', 'True')
            .replace('false', 'False')
    )
    # Add trailing commas.
    return re.sub(r'([]}"])\n', r'\1,\n', result) + '\n'

def emit_protoc_integrity_file(output_file, integrity_data):
    # Lifted this from ArtifactUpdater.write_to_file() from
    # create_repository.py. Should probably extract it into a helper.

    with output_file.open('w', encoding = 'utf-8') as data:
        data.write('\n'.join([
            '"""Protocol compiler build and integrity metadata.\n',
            'Generated and updated by ' +
            f'{THIS_FILE_RELATIVE_TO_REPO_ROOT}.',
            '"""\n\n',
        ]))

        data.write(f'PROTOC_RELEASES_URL = "{PROTOC_RELEASES_URL}"\n')
        data.write("PROTOC_DOWNLOAD_URL = (\n    PROTOC_RELEASES_URL +\n")
        data.write(f'    "{PROTOC_DOWNLOAD_SUFFIX}"\n)\n\n')

        data.write("PROTOC_VERSIONS = ")
        data.write(stringify_object(PROTOC_VERSIONS))

        data.write("\nPROTOC_BUILDS = ")
        data.write(stringify_object(dict(sorted(integrity_data.items()))))

def load_orig_data(output_file):
    if not output_file.exists():
        return {}

    with output_file.open('r', encoding='utf-8') as f:
        data = f.read()

    marker = 'PROTOC_BUILDS = '
    start = data.find(marker)

    if start == -1:
        msg = f'"{marker}" not found in {output_file}'
        raise UpdateProtocIntegrityError(msg)
    return ast.literal_eval(data[start + len(marker):])

if __name__ == "__main__":
    try:
        orig_data = load_orig_data(OUTPUT_FILE)
        updated_data = {
            k: update_build_data(k, v, orig_data.get(k, {}))
            for k, v in PROTOC_BUILDS.items()
        }
        emit_protoc_integrity_file(OUTPUT_FILE, updated_data)
    except UpdateProtocIntegrityError as err:
        print(f'Failed to update {OUTPUT_FILE}: {err}', file=sys.stderr)
        sys.exit(1)
