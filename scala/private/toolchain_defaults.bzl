"""Gathers defaults for toolchain macros in one place.

Used by both //scala:toolchains.bzl and //scala/extensions:deps.bzl.
"""

load(
    "//scala/private:macros/setup_scala_toolchain.bzl",
    _scala_attrs = "TOOLCHAIN_ATTRS",
    _scala_defaults = "TOOLCHAIN_DEFAULTS",
)
load(
    "//scala/scalafmt/toolchain:setup_scalafmt_toolchain.bzl",
    _scalafmt_defaults = "TOOLCHAIN_DEFAULTS",
)
load(
    "//scala_proto:toolchains.bzl",
    _scala_proto_defaults = "TOOLCHAIN_DEFAULTS")
load(
    "//twitter_scrooge/toolchain:toolchain.bzl",
    _twitter_scrooge_defaults = "TOOLCHAIN_DEFAULTS",
)

TOOLCHAIN_DEFAULTS = {
    "scala": _scala_defaults,
    "scalafmt": _scalafmt_defaults,
    "scala_proto": _scala_proto_defaults,
    "twitter_scrooge": _twitter_scrooge_defaults,
}

TOOLCHAIN_ATTRS = {
    "scala": _scala_attrs,
}
