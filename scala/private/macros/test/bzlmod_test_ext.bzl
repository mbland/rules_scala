"""Used by test/shell/test_bzlmod_helpers.sh to test bzlmod.bzl"""

load(
    "@rules_scala//scala/private:macros/bzlmod.bzl",
    "root_module_tags",
    "single_tag_values",
)

visibility("private")

_test_tag_defaults = {
    "first": "foo",
    "second": "bar",
    "third": "baz",
}

_test_tag_attrs = {
    k: attr.string(default = v)
    for k, v in _test_tag_defaults.items()
}

_tag_classes = {
    "test_tag": tag_class(attrs = _test_tag_attrs),
}

_test_tag_results_bzl_template = """
FIRST = "{first}"
SECOND = "{second}"
THIRD = "{third}"
"""

def _test_tag_results_repo_impl(rctx):
    rctx.file("BUILD")
    rctx.file(
        "results.bzl",
        _test_tag_results_bzl_template.format(**rctx.attr.test_tag_values),
    )

_test_tag_results_repo = repository_rule(
    implementation = _test_tag_results_repo_impl,
    attrs = {
        "test_tag_values": attr.string_dict(mandatory = True),
    },
)

def _test_ext_impl(mctx):
    root_tags = root_module_tags(mctx, _tag_classes.keys())
    values = single_tag_values(mctx, root_tags.test_tag, _test_tag_defaults)

    _test_tag_results_repo(
        name = "test_tag_values",
        test_tag_values = values,
    )

test_ext = module_extension(
    implementation = _test_ext_impl,
    tag_classes = _tag_classes,
)
