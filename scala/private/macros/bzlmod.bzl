"""Utilities for working with Bazel modules"""

def apparent_repo_name(label_or_name):
    """Return a repository's apparent repository name.

    Can be replaced with a future bazel-skylib implementation, if accepted into
    that repo.

    Args:
        label_or_name: a Label or repository name string

    Returns:
        The apparent repository name
    """
    repo_name = getattr(label_or_name, "repo_name", label_or_name)

    # Bazed on this pattern from the Bazel source:
    # com.google.devtools.build.lib.cmdline.RepositoryName.VALID_REPO_NAME
    for i in range(len(repo_name) - 1, -1, -1):
        c = repo_name[i]
        if not (c.isalnum() or c in "_-."):
            # For repos representing top level modules, the canonical name will
            # end with a delimiter, and `result` will be the empty string.
            result = repo_name[i + 1:]
            return result if len(result) != 0 else repo_name[:-1]
    return repo_name
