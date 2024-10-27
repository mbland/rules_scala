"""Utilities for working with Bazel modules"""

def apparent_repo_name(repository_ctx):
    """Generates a repository's apparent name from a repository_ctx object.

    Args:
        repository_ctx: a repository_ctx object

    Returns:
        An apparent repo name derived from repository_ctx.name
    """
    repo_name = repository_ctx.name

    # Based on this pattern from the Bazel source:
    # com.google.devtools.build.lib.cmdline.RepositoryName.VALID_REPO_NAME
    for i in range(len(repo_name) - 1, -1, -1):
        c = repo_name[i]
        if not (c.isalnum() or c in "_-."):
            return repo_name[i + 1:]

    return repo_name

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
