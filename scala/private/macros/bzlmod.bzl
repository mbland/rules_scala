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

def apparent_repo_label_string(label):
    """Return a Label string starting with its apparent repo name.

    For top level target labels (starting with "//"), or main repository labels
    (starting with "@@//" or "@//"), the result will start with:

    - "@@//" for Bazel >= 7.1.0
    - "@//" for Bazel < 7.1.0

    Args:
        label: a Label instance

    Returns:
        str(label) with its canonical repository name replaced with its apparent
            repository name
    """
    if len(label.repo_name) == 0:
        return str(label)

    apparent_repo = apparent_repo_name(label)
    return "@" + str(label).lstrip("@").replace(label.repo_name, apparent_repo)
