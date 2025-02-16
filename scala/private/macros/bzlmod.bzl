"""Utilities for working with Bazel modules"""

def root_module_tags(module_ctx, tag_class_names):
    """Returns the bazel_module_tags from the root bazel_module.

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
    "expected a single tag instance and optional dev_dependency instance, " +
    "got %s:"
)

def single_tag_values(module_ctx, tags, tag_defaults):
    """Returns a dictionary of tag attr names to explicit or default values.

    Use for tags that should only appear at most once in a module, except for an
    optional `dev_dependency` instance.

    Raises if `tags` contains more than two tag instances, if both return the
    same value for `module_ctx.is_dev_dependency(tag)`, or if the second isn't a
    `dev_dependency`. Nondefault values from the `dev_dependency` instance will
    override the first instance's values.

    Args:
        module_ctx: the module extension context
        tags: a list of tag class values from a bazel_module_tags object
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
