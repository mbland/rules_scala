"""Utilities for working with Bazel modules"""

def get_root_module(module_ctx):
    """Returns the root bazel_module object from the module extension context.

    Args:
        module_ctx: the module extension context

    Returns:
        The root bazel_module object if found, None otherwise
    """
    for module in module_ctx.modules:
        if module.is_root:
            return module
    return None

def get_tag_values(tags, tag_defaults):
    """Returns a dictionary of tag attr names to explicit or default values.

    Note that if tags is nonempty, the return value is created from only the
    last element (i.e., the last instance of the tag wins).

    Args:
        tags: a list of tag values from a bazel_module_tags object
        tag_defaults: a dictionary of tag attr names to default values

    Returns:
        `tag_defaults` if `tags` is empty, or a new dict created from the last
            element of `tags`
    """
    return tag_defaults if len(tags) == 0 else {
        attr_name: getattr(tags[-1], attr_name)
        for attr_name in tag_defaults
    }
