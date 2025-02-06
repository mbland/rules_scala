"""Utilities for working with Bazel modules

These utilities facilitate the pattern of defining defaults, attrs, and tag
class dictionaries, as employed by:

- //scala/extensions:config.bzl
- //scala/extensions:deps.bzl
- //scala/private/extensions:dev_deps.bzl
- //scala/private:macros/test/bzlmod_test_ext.bzl

This pattern overcomes the restriction that tag class attrs are not iterable,
which would otherwise yield lots of initialization logic with duplicated default
values.

These functions facilitate writing module extensions that need to implement
three common cases:

- `root_module_tags`: for abiding the root module configuration only, returning
  an empty struct if the root module doesn't specify any tags

- `single_tag_values`: for enforcing that a tag appears at most once per module
  as a regular and/or dev dependency, returning default values if unspecified

- `repeated_tag_values`: for collecting unique tag instance values into a dict
  of dicts, keyed by a particular tag `attr`

For example:

```py
_string_tag_defaults = {
    "first": "foo",
    "second": "bar",
    "third": "baz",
}

# A dict comprehension works if all attrs are of the same type.
_string_tag_attrs = {
    k: attr.string(default = v)
    for k, v in _string_tag_defaults.items()
}

_mixed_tag_defaults = {
    "fourth": "quux",
    "fifth": ["xyzzy"],
    "sixth": {"plugh": "frobozz"},
}

_mixed_tag_attrs = {
    "fourth": attr.string(default = _mixed_tag_defaults["fourth"]),
    "fifth": attr.string_list(default = _mixed_tag_defaults["fifth"]),
    "sixth": attr.string_dict(default = _mixed_tag_defaults["sixth"]),
}

_repeated_tag_attrs = {
    "key": attr.string(mandatory = True),
    "required_value": attr.string(mandatory = True),
    "optional_value": attr.string(),
}

_tag_classes = {
    "string_tag": tag_class(attrs = _string_tag_attrs),
    "mixed_tag": tag_class(attrs = _mixed_tag_attrs),
    "repeated_tag": tag_class(attrs = _repeated_tag_attrs),
}

def _example_ext_impl(module_ctx):
    root_tags = root_module_tags(module_ctx, _tag_classes.keys())
    string_values_dict = single_tag_values(
        module_ctx,
        root_tags.string_tag,
        _string_tag_defaults,
    )
    mixed_values_dict = single_tag_values(
        module_ctx,
        root_tags.mixed_tag,
        _mixed_tag_defaults,
    )
    repeated_values_dict = repeated_tag_values(
        root_tags.repeated_tag,
        _repeated_tag_attrs,
    )

    some_macro_or_repo_rule_that_uses_these_tag_values(
        name = "example_repo",
        repeated = repeated_values_dict,
        **(string_values_dict | mixed_values_dict),
    )

example_ext = module_extension(
    implementation = _example_ext_impl,
    tag_classes = _tag_classes,
)
```py
"""

def root_module_tags(module_ctx, tag_class_names):
    """Returns the bazel_module_tags from the root bazel_module or a fake.

    Returns a fake struct constructed from `tag_class_names` if `module_ctx`
    doesn't contain the root module (i.e., the root module doesn't use the
    module extension). This is useful for configuring default values in that
    case, without having to add special case module extension logic.

    Args:
        module_ctx: the module extension context
        tag_class_names: tag classes used to create a struct if no root module
            detected

    Returns:
        The bazel_module_tags from the root bazel_module object if
            `module_ctx.modules` contains the root module,
        or a struct mapping the specified tag class fields to the empty list
            otherwise
    """
    for module in module_ctx.modules:
        if module.is_root:
            return module.tags
    return struct(**{name: [] for name in tag_class_names})

_single_tag_err = (
    "expected one regular tag instance and/or one dev_dependency instance, " +
    "got %s:"
)

def single_tag_values(module_ctx, tags, tag_defaults):
    """Returns a dictionary of tag attr names to explicit or default values.

    Use for tags that should appear at most once in a module as a regular tag
    and at most once as a `dev_dependency` tag.

    Nondefault values from a `dev_dependency` instance will override the regular
    instance's values.

    Args:
        module_ctx: the module extension context
        tags: a list of tag class values from a `bazel_module_tags` object
        tag_defaults: a dictionary of tag attr names to default values

    Returns:
        `tag_defaults` if `tags` is empty, or a new dict created from the
            elements of `tags`

    Raises:
        If `tags` contains more than one two tag instances, if both are
            `dev_dependency` or regular instances, or if the regular instance
            doesn't come first
    """
    if len(tags) == 0:
        return tag_defaults
    if len(tags) > 2:
        fail(_single_tag_err % len(tags), *tags)

    result = {k: getattr(tags[0], k) for k in tag_defaults}

    if len(tags) == 2:
        first_is_dev = module_ctx.is_dev_dependency(tags[0])
        second_is_dev = module_ctx.is_dev_dependency(tags[1])

        if first_is_dev == second_is_dev:
            tag_type = "dev_dependency" if first_is_dev else "regular"
            fail(_single_tag_err % ("two %s instances" % (tag_type)), *tags)

        elif first_is_dev:
            msg = "the dev_dependency instance before the regular instance"
            fail(_single_tag_err % msg, *tags)

        dev_dep_values = {k: getattr(tags[1], k) for k in tag_defaults}
        result.update({
            k: v
            for k, v in dev_dep_values.items()
            if v != tag_defaults[k]
        })

    return result

def repeated_tag_values(tags, attr_dict):
    """Compiles repeated tag instances into a dict of dicts.

    The first key from `attr_dict` identifies the tag field used as the dict
    key. Fails if more than one tag instance has the same key value, regardless
    of `dev_dependency` status.

    Args:
        tags: a list of tag class values from a `bazel_module_tags` object
        attr_dict: a dict from `attr` name to `attr` instance

    Returns:
        a dict of dicts representing unique `tag_name` instance values, using
            the first key from `attr_dict` as the key value

    Raises:
        if more than one tag instance contains the same key value (i.e., the
            same value for the first `attr` in `attr_dict`)
    """
    attr_names = attr_dict.keys()
    key_name = attr_names[0]
    instances = {}
    result = {}

    for instance in tags:
        values = {field: getattr(instance, field) for field in attr_names}
        key = values.pop(key_name)

        if key in instances:
            msg = "multiple tags with same %s:" % key_name
            fail(msg, instances[key], instance)

        instances[key] = instance
        result[key] = {k: v for k, v in values.items()}

    return result
