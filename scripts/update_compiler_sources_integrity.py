#!/usr/bin/env python3
"""Updates `scala/private/macros/compiler_sources_integrity.bzl`.

`compiler_sources_integrity.bzl` contains the mapping from Scala versions to
their source URLs and integrity hashes.

Only computes the integrity information if it doesn't already exist in the
integrity file.
"""

from pathlib import Path

import argparse
import sys

from lib.update_integrity import (
    get_integrity_file_path_and_generated_by,
#    get_artifact_integrity,
    stringify_object,
    load_existing_data,
)


# These are matched with the versions from //dt_patches:dt_patch_test.sh.
# The `+ 1` expressions ensure inclusion of the most recent patch version.
SCALA_VERSIONS = [
    "2.11.12",
]
SCALA_VERSIONS.extend([f'2.12.{patch}' for patch in range(1, 20 + 1)])
SCALA_VERSIONS.extend([f'2.13.{patch}' for patch in range(0, 16 + 1)])
SCALA_VERSIONS.extend([f'3.1.{patch}' for patch in range(0, 3 + 1)])
SCALA_VERSIONS.extend([f'3.2.{patch}' for patch in range(0, 2 + 1)])
SCALA_VERSIONS.extend([f'3.3.{patch}' for patch in range(0, 6 + 1)])
SCALA_VERSIONS.extend([f'3.4.{patch}' for patch in range(0, 3 + 1)])
SCALA_VERSIONS.extend([f'3.5.{patch}' for patch in range(0, 2 + 1)])
SCALA_VERSIONS.extend([f'3.6.{patch}' for patch in range(0, 4 + 1)])
SCALA_VERSIONS.extend([f'3.7.{patch}' for patch in range(0, 1 + 1)])

INTEGRITY_FILE, GENERATED_BY = get_integrity_file_path_and_generated_by(
    'scala/private/macros/compiler_sources_integrity.bzl',
    __file__,
)
INTEGRITY_FILE_HEADER = f'''"""Scala compiler source JAR integrity metadata.

{GENERATED_BY}
"""

'''


class UpdateCompilerSourcesIntegrityError(Exception):
    """Errors raised explicitly by this module."""


def compiler_source_url(scala_version):
    prefix = "https://repo1.maven.org/maven2/org/scala-lang/scala-compiler/"
    jar_fmt = "/scala-compiler-%s-sources.jar"

    if scala_version.startswith("3."):
        jar_fmt = "/scala3-compiler_3-%s-sources.jar"

    return prefix + scala_version + jar_fmt % scala_version


def emit_compiler_sources_integrity_file(output_file, integrity_data):
    """Writes the updated compiler_sources integrity data to the `output_file`.

    Args:
        output_file: path to the updated compiler sources integrity file
        integrity_data: compiler sources integrity data to emit into
            `output_file`
    """
    with output_file.open('w', encoding = 'utf-8') as data:
        data.write(INTEGRITY_FILE_HEADER)
        data.write("COMPILER_SOURCES = ")
        data.write(stringify_object(integrity_data))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description = (
            "Updates Scala compiler source JAR integrity information."
        ),
    )

    parser.add_argument(
        '--integrity_file',
        type=str,
        default=str(INTEGRITY_FILE),
        help=(
            f'compiler sources integrity file path (default: {INTEGRITY_FILE})'
        )
    )

    args = parser.parse_args()
    integrity_file = Path(args.integrity_file)

    try:
        existing_data = load_existing_data(
            integrity_file,
            'COMPILER_SOURCES = '
        )
        updated_data = existing_data | {
            version: {
                "url": compiler_source_url(version),
                "integrity": "",
            }
            for version in SCALA_VERSIONS
        }
        emit_compiler_sources_integrity_file(integrity_file, updated_data)

    except UpdateCompilerSourcesIntegrityError as err:
        print(f'Failed to update {integrity_file}: {err}', file=sys.stderr)
        sys.exit(1)
