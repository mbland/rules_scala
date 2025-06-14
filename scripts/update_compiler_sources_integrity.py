#!/usr/bin/env python3
"""Updates `scala/private/macros/compiler_sources_integrity.bzl`.

`compiler_sources_integrity.bzl` contains the mapping from Scala versions to
their source URLs and integrity hashes.

Only computes the integrity information if it doesn't already exist in the
integrity file.
"""

from lib.update_integrity import (
    get_artifact_integrity,
    get_integrity_file_path_and_generated_by,
    stringify_object,
    update_integrity_file,
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


def get_compiler_source_integrity(scala_version):
    """Generates the URL and integrity value for a specific Scala version.

    Args:
        scala_version: the scala version for which to generate a URL and
            integrity value

    Returns:
        a `{"url", "integrity"}` dict for the `scala_version` compiler sources
    """
    prefix = "https://repo1.maven.org/maven2/org/scala-lang/"
    suffix = "scala-compiler/{version}/scala-compiler-{version}-sources.jar"

    if scala_version.startswith("3."):
        suffix = (
            "scala3-compiler_3/{version}/" +
            "scala3-compiler_3-{version}-sources.jar"
        )

    url = prefix + suffix.format(version = scala_version)

    print(f'Generating integrity for:\n  {url}')
    return {"url": url, "integrity": get_artifact_integrity(url)}


def emit_compiler_sources_integrity_data(output_file, integrity_data):
    """Writes the updated compiler_sources integrity data to the `output_file`.

    Args:
        output_file: open file handle to the updated compiler sources integrity
            file
        integrity_data: compiler sources integrity data to emit into
            `output_file`
    """
    output_file.write(INTEGRITY_FILE_HEADER)
    output_file.write("COMPILER_SOURCES = ")
    output_file.write(stringify_object(integrity_data))


if __name__ == "__main__":
    update_integrity_file(
        "Updates Scala compiler source JAR integrity information.",
        INTEGRITY_FILE,
        "COMPILER_SOURCES = ",
        lambda existing_data: dict(sorted(
            (existing_data | {
                version: get_compiler_source_integrity(version)
                for version in SCALA_VERSIONS
                if version not in existing_data
            }).items(),
            key=lambda item: [int(n) for n in item[0].split(".")],
        )),
        emit_compiler_sources_integrity_data,
    )
