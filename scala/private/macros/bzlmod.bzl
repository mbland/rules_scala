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

    Args:
        tags: a list of tag values from a bazel_module_tags object
        tag_defaults: a dictionary of tag attr names to default values

    Returns:
        a dictionary of tag attr names to values from tag instances or
            tag_defaults
    """
    values = {}
    for tag in tags:
        for name, default in tag_defaults.items():
            value = getattr(tag, name, default)
            if value != default:
                values[name] = value
    return values | {k: v for k, v in tag_defaults.items() if k not in values}
