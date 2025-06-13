"""Scala compiler source JAR integrity metadata.

Generated and updated by scripts/update_compiler_sources_integrity.py.
"""

_compiler_source_url(scala_version):
    prefix = "https://repo1.maven.org/maven2/org/scala-lang/scala-compiler/"
    jar_fmt = "scala-compiler-%s-sources.jar"

    if scala_version.startswith("3."):
        jar_fmt = "scala3-compiler_3-%s-sources.jar"

    return prefix + scala_version + jar_fmt % scala_version


SCALA_VERSIONS = [
    "2.11.12",
    "2.12.1",
    "2.12.2",
    "2.12.3",
    "2.12.4",
    "2.12.5",
    "2.12.6",
    "2.12.7",
    "2.12.8",
    "2.12.9",
    "2.12.10",
    "2.12.11",
    "2.12.12",
    "2.12.13",
    "2.12.14",
    "2.12.15",
    "2.12.16",
    "2.12.17",
    "2.12.18",
    "2.12.19",
    "2.12.20",
    "2.13.0",
    "2.13.1",
    "2.13.2",
    "2.13.3",
    "2.13.4",
    "2.13.5",
    "2.13.6",
    "2.13.7",
    "2.13.8",
    "2.13.9",
    "2.13.10",
    "2.13.11",
    "2.13.12",
    "2.13.13",
    "2.13.14",
    "2.13.15",
    "2.13.16",
    "3.1.0",
    "3.1.1",
    "3.1.2",
    "3.1.3",
    "3.2.0",
    "3.2.1",
    "3.2.2",
    "3.3.0",
    "3.3.1",
    "3.3.2",
    "3.3.3",
    "3.3.4",
    "3.3.5",
    "3.3.6",
    "3.4.0",
    "3.4.1",
    "3.4.2",
    "3.4.3",
    "3.5.0",
    "3.5.1",
    "3.5.2",
    "3.6.0",
    "3.6.1",
    "3.6.2",
    "3.6.3",
    "3.6.4",
    "3.7.0",
    "3.7.1",
]
