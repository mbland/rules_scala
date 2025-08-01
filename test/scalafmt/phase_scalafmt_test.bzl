"""Scalafmt rules: scalafmt_scala_{binary,library,test}"""

load(
    "//scala:advanced_usage/scala.bzl",
    "make_scala_binary",
    "make_scala_library",
    "make_scala_test",
)
load("//scala/scalafmt:phase_scalafmt_ext.bzl", "ext_scalafmt")
load("//scala/scalafmt:providers.bzl", "ScalafmtScriptInfo")

def _scalafmt_script_impl(ctx):
    if ctx.attr.dep.label.repo_name != "":
        fail(
            "This target only works when built within the main repo, not as:",
            ctx.label,
        )
    elif ScalafmtScriptInfo not in ctx.attr.dep:
        fail(
            "Set 'format = True' on",
            ctx.attr.dep.label,
            "before building or running",
            ctx.label,
        )

    output_runner = ctx.actions.declare_file(ctx.label.name)
    template = ctx.file.template
    info = ctx.attr.dep[ScalafmtScriptInfo]

    ctx.actions.run_shell(
        inputs = [template, info.manifest] + info.files,
        outputs = [output_runner],
        # replace %workspace% and %manifest% in template and rewrite it to
        # output_runner
        command = """
set -o errexit
set -o nounset
set -o pipefail
sed -e s#%workspace%#$2# -e s#%manifest%#$3# < $1 > $4
""",
        arguments = [
            template.path,
            ctx.workspace_name,
            info.manifest.short_path,
            output_runner.path,
        ],
        execution_requirements = {},
    )

    return DefaultInfo(
        executable = output_runner,
        runfiles = ctx.attr.dep[DefaultInfo].default_runfiles,
    )

_scalafmt_script = rule(
    implementation = _scalafmt_script_impl,
    attrs = {
        "dep": attr.label(mandatory = True),
        "template": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
    },
    executable = True,
)

_TARGET_SUFFIX_TO_SCRIPT_TEMPLATE = {
    ".format": Label("//scala/scalafmt:runner"),
    ".format-test": Label("//scala/scalafmt:testrunner"),
}

def _scalafmt_scripts(name):
    testonly = name.endswith("_test") or name.endswith("-test")

    for suffix, template in _TARGET_SUFFIX_TO_SCRIPT_TEMPLATE.items():
        _scalafmt_script(
            name = name + suffix,
            dep = name,
            tags = ["manual"],
            template = template,
            testonly = testonly,
        )

_scalafmt_scala_binary = make_scala_binary(ext_scalafmt)

_scalafmt_scala_library = make_scala_library(ext_scalafmt)

_scalafmt_scala_test = make_scala_test(ext_scalafmt)

def scalafmt_scala_binary(name, **kwargs):
    _scalafmt_scala_binary(
        name = name,
        **kwargs
    )

    _scalafmt_scripts(name)

def scalafmt_scala_library(name, **kwargs):
    _scalafmt_scala_library(
        name = name,
        **kwargs
    )

    _scalafmt_scripts(name)

def scalafmt_scala_test(name, **kwargs):
    _scalafmt_scala_test(
        name = name,
        **kwargs
    )

    _scalafmt_scripts(name)
