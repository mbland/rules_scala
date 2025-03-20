"""Precompiled protocol compiler toolchain repository interface.

```py
# WORKSPACE

# Include this as early in the file as possible.
register_toolchains("@rules_scala//protoc:all")

# Include this after loading `platforms` and `com_google_protobuf`.
load("@rules_scala//protoc:toolchains.bzl", "scala_protoc_toolchains")

scala_protoc_toolchains()
```
"""

load(":private/protoc_toolchain.bzl", _toolchains = "scala_protoc_toolchains")

def scala_protoc_toolchains(platforms = []):
    """Creates a repo of precompiled protocol compiler toolchain binaries.

    Used by `//protoc` to implement precompiled protocol compiler toochains.

    Args:
        platforms: Operating system and architecture identifiers for
            precompiled protocol compiler releases, taken from
            protocolbuffers/protobuf releases file name suffixes. If
            unspecified, will use the identifier matching the `HOST_CONSTRAINTS`
            from `@platforms//host:constraints.bzl`. Only takes effect when
            `--incompatible_enable_proto_toolchain_resolution` is `True`.
    """
    _toolchains(
        name = "rules_scala_protoc_toolchains",
        platforms = platforms,
    )
