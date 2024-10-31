#!/usr/bin/env python3
"""Updates jar versions in third_party/repositories/scala_*.bzl files"""

from dataclasses import dataclass
from pathlib import Path
from typing import Dict
from typing import List

import ast
import hashlib
import json
import re
import shutil
import subprocess
import urllib.request

DOWNLOADED_ARTIFACTS_FILE = 'repository-artifacts.json'

ROOT_SCALA_VERSIONS = [
    "2.11.12",
    "2.12.20",
    "2.13.15",
    "3.1.3",
    "3.2.2",
    "3.3.4",
    "3.4.3",
    "3.5.2",
]
SCALATEST_VERSION = "3.2.9"
SCALAFMT_VERSION = "3.8.3"
PROTOBUF_JAVA_VERSION = "4.28.2"

EXCLUDED_ARTIFACTS = set([
    "org.scala-lang.modules:scala-parser-combinators_2.11:1.0.4",
])

@dataclass
class MavenCoordinates:
    group: str
    artifact: str
    version: str
    coordinate: str

@dataclass
class ResolvedArtifact:
    coordinates: MavenCoordinates
    checksum: str
    direct_dependencies: List[MavenCoordinates]

def select_root_artifacts(scala_version, scala_major, is_scala_3) -> List[str]:
    scalatest_major = "3" if is_scala_3 else scala_major
    scalafmt_major = "2.13" if is_scala_3 else scala_major
    kind_projector_version = "0.13.2" if scala_major < "2.12" else "0.13.3"
    scalafmt_version = "2.7.5" if scala_major == "2.11" else SCALAFMT_VERSION

    common_root_artifacts = [
        f"com.google.protobuf:protobuf-java:{PROTOBUF_JAVA_VERSION}",
        f"org.scalatest:scalatest_{scalatest_major}:{SCALATEST_VERSION}",
        f"org.scalameta:scalafmt-core_{scalafmt_major}:{scalafmt_version}"
    ]
    scala_artifacts = [
        f'org.scala-lang:scala3-library_3:{scala_version}',
        f'org.scala-lang:scala3-compiler_3:{scala_version}',
        f'org.scala-lang:scala3-interfaces:{scala_version}',
        f'org.scala-lang:tasty-core_3:{scala_version}'
    ] if scala_major[0] == "3" else [
        f'org.scala-lang:scala-library:{scala_version}',
        f'org.scala-lang:scala-compiler:{scala_version}',
        f'org.scala-lang:scala-reflect:{scala_version}',
        f'org.scalameta:semanticdb-scalac_{scala_version}:4.9.9',
        f'org.typelevel:kind-projector_{scala_version}:{kind_projector_version}'
    ]
    return common_root_artifacts + scala_artifacts

def get_maven_coordinates(artifact) -> MavenCoordinates:
    # There are Maven artifacts that contain extra components like `:jar` in
    # their coordinates. However, the groupId and artifactId are always the
    # first two components, and the version is the last.
    parts = artifact.split(':')
    return MavenCoordinates(parts[0], parts[1], parts[-1], artifact)

def get_mavens_coordinates_from_json(artifacts) -> List[MavenCoordinates]:
    return list(map(get_maven_coordinates, artifacts))

def get_artifact_checksum(artifact) -> str:
    output = subprocess.run(
      f'cs fetch {artifact}',
      capture_output=True,
      text=True,
      shell=True,
      check=False,
    ).stdout.splitlines()

    possible_url = [o for o in output if "https" in o][0]
    possible_url = possible_url[possible_url.find("https"):]
    possible_url = possible_url.replace('https/', 'https://')

    try:
        with urllib.request.urlopen(possible_url) as value:
            return hashlib.sha256(value.read()).hexdigest()

    except urllib.error.HTTPError as e:
        print(f'RESOURCES NOT FOUND: {possible_url}: {e}')

def get_json_dependencies(artifact) -> List[MavenCoordinates]:
    with open(DOWNLOADED_ARTIFACTS_FILE, 'r', encoding='utf-8') as file:
        data = json.load(file)

    return (
        get_mavens_coordinates_from_json(dep["directDependencies"])
        if any((dep := d)["coord"] == artifact for d in data["dependencies"])
        else []
    )

ARTIFACT_LABEL_ONLY_GROUPS = set([
  "com.twitter",
  "javax.annotation",
  "org.scalactic",
  "org.scalatest",
])

GROUP_AND_ARTIFACT_LABEL_GROUPS = set([
  "junit",
  "net.sf.jopt-simple",
  "org.apache.commons",
  "org.hamcrest",
  "org.openjdk.jmh",
  "org.ow2.asm",
  "org.specs2",
])

LAST_GROUP_COMPONENT_GROUPS = set([
    "com.google.guava"
    "com.github.scopt",
])

NEXT_TO_LAST_GROUP_COMPONENT_GROUPS = set([
    "com.github.spullara.mustache.java",
])

SCALA_PROTO_RULES_GROUPS = set([
    "com.google.instrumentation",
    "com.lmax",
    "com.thesamet.scalapb",
    "io.grpc",
    "io.netty",
    "io.opencensus",
    "io.perfmark",
])

SCALA_LANG_GROUPS = set(['org.scala-lang', 'org.scala-lang.modules'])
SCALA_2_ARTIFACTS = set(['scala-library', 'scala-compiler', 'scala-reflect'])

def adjust_scala_lang_label(label, is_scala_3, coordinates):
    artifact = coordinates.artifact

    if is_scala_3 and artifact in SCALA_2_ARTIFACTS:
        return label + '_2'
    if artifact.startswith("scala3-"):
        return label.replace('scala3_', 'scala_')
    return label.replace('scala_tasty_core', 'scala_scala_tasty_core')

def get_label(coordinates, is_scala_3) -> str:
    group = coordinates.group
    group_label = group.replace('.', '_').replace('-', '_')
    artifact_label = coordinates.artifact.split('_')[0].replace('-', '_')

    if group in SCALA_LANG_GROUPS:
        label = f'io_bazel_rules_scala_{artifact_label}'
        return adjust_scala_lang_label(label, is_scala_3, coordinates)
    if group in ARTIFACT_LABEL_ONLY_GROUPS:
        return f'io_bazel_rules_scala_{artifact_label}'
    if group in GROUP_AND_ARTIFACT_LABEL_GROUPS:
        return f'io_bazel_rules_scala_{group_label}_{artifact_label}'
    if group in LAST_GROUP_COMPONENT_GROUPS:
        return f'io_bazel_rules_scala_{group.split('.')[-1]}'
    if group in NEXT_TO_LAST_GROUP_COMPONENT_GROUPS:
        return f'io_bazel_rules_scala_{group.split('.')[-2]}'
    if group in SCALA_PROTO_RULES_GROUPS:
        return f'scala_proto_rules_{artifact_label}'
    return f'{group_label}_{artifact_label}'.replace('_v2', '')

def is_newer_than_current_version(version_to_check, current_version):
    """Determines if the version_to_check is newer than the current_version.

    The idea is to prevent downgrades of versions already in the artifacts file.
    If they are later versions, presumably they were updated to that version for
    a good reason.
    """
    if current_version is None:
        return True
    if version_to_check == current_version:
        return False

    check_parts = version_to_check.split(".")
    current_parts = current_version.split(".")

    for check_part, current_part in zip(check_parts, current_parts):
        if check_part == current_part:
            continue
        if check_part.isdecimal() and current_part.isdecimal():
            return int(current_part) < int(check_part)
        return current_part < check_part

    return len(current_parts) < len(check_parts)

def map_to_resolved_artifacts(
    output, current_artifact_to_version_map
) -> List[ResolvedArtifact]:

    artifacts_to_update = []
    fetch_specs = []

    for line in output:
        artifact = line.replace(':default', '')
        coordinates = get_maven_coordinates(artifact)
        name, version = coordinates.artifact, coordinates.version
        current_version = current_artifact_to_version_map.get(name, None)

        if is_newer_than_current_version(version, current_version):
            artifacts_to_update.append(artifact)
            fetch_specs.append(line)

    subprocess.call(
        f'cs fetch {' '.join(fetch_specs)} --json-output-file ' +
        DOWNLOADED_ARTIFACTS_FILE,
        shell=True,
    )
    return [
        ResolvedArtifact(
            get_maven_coordinates(artifact),
            get_artifact_checksum(artifact),
            get_json_dependencies(artifact),
        )
        for artifact in artifacts_to_update
    ]

def resolve_artifacts_with_checksums_and_direct_dependencies(
    root_artifacts, current_artifact_to_version_map
) -> List[ResolvedArtifact]:
    command = f'cs resolve {' '.join(root_artifacts)}'
    proc = subprocess.run(
      command, capture_output=True, text=True, shell=True, check=False
    )
    print(proc.stderr)
    return map_to_resolved_artifacts(
        proc.stdout.splitlines(), current_artifact_to_version_map,
    )

def to_rules_scala_compatible_dict(artifacts, is_scala_3) -> Dict[str, Dict]:
    result = {}

    for a in artifacts:
        coordinates = a.coordinates
        result[get_label(coordinates, is_scala_3)] = {
            "artifact": f"{coordinates.coordinate}",
            "sha256": f"{a.checksum}",
            "deps": sorted([
                f'@{get_label(d, is_scala_3)}' for d in a.direct_dependencies
            ]),
        }

    return result

def write_to_file(artifact_dict, version, file):
    artifacts = (
        json.dumps(artifact_dict, indent=4)
            .replace('true', 'True')
            .replace('false', 'False')
    )
    # Add trailing commas.
    artifacts = re.sub(r'([]}"])\n', r'\1,\n', artifacts) + '\n'

    with file.open('w', encoding='utf-8') as data:
        data.write(f'scala_version = "{version}"\n')
        data.write('\nartifacts = ')
        data.write(artifacts)

def create_artifact_version_map(original_artifacts):
    result = {}
    for metadata in original_artifacts.values():
        coordinates = get_maven_coordinates(metadata['artifact'])
        result[coordinates.artifact] = coordinates.version
    return result

def create_file(version):
    file = (
        Path(__file__).parent.parent /
        'third_party' /
        'repositories' /
        f'scala_{"_".join(version.split(".")[:2])}.bzl'
    )

    if not file.exists():
        file_to_copy = sorted(file.parent.glob('scala_*.bzl'))[-1]
        shutil.copyfile(file_to_copy, file)

    print("\nUPDATING:", file)
    with file.open('r', encoding='utf-8') as data:
        read_data = data.read()

    scala_major = ".".join(version.split(".")[:2])
    is_scala_3 = scala_major.startswith("3.")
    root_artifacts = select_root_artifacts(version, scala_major, is_scala_3)
    replaced_data = read_data[read_data.find('{'):]

    original_artifacts = ast.literal_eval(replaced_data)

    transitive_artifacts: List[ResolvedArtifact] = (
       resolve_artifacts_with_checksums_and_direct_dependencies(
            root_artifacts,
            create_artifact_version_map(original_artifacts),
       )
    )
    generated_artifacts = to_rules_scala_compatible_dict(
        transitive_artifacts, is_scala_3
    )

    for label, generated_metadata in generated_artifacts.items():
        artifact = generated_metadata["artifact"]
        if artifact in EXCLUDED_ARTIFACTS:
            continue

        metadata = original_artifacts.setdefault(label, {})
        metadata["artifact"] = artifact
        metadata["sha256"] = generated_metadata["sha256"]
        dependencies = generated_metadata["deps"]

        if dependencies:
            metadata["deps"] = dependencies

    write_to_file(original_artifacts, version, file)

for root_scala_version in ROOT_SCALA_VERSIONS:
    create_file(root_scala_version)
Path(DOWNLOADED_ARTIFACTS_FILE).unlink()
