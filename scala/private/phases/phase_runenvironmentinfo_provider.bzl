"""Phase implementing variable expansion for the env attribute"""

def _expand_part(ctx, attr_name, part, targets, additional_vars):
    """Perform `$(location)` and "Make variable" substitution for `expand_vars`.

    As for why we're using the "deprecated" `ctx.expand_make_variables`:

    - https://github.com/bazelbuild/bazel/issues/5859
    - https://github.com/bazelbuild/bazel-skylib/pull/486

    The "deprecated" comment in the `ctx.expand_make_variables` docstring has
    existed from the beginning of the file's existence (2018-05-11):

    - https://github.com/bazelbuild/bazel/commit/abbb9002c41bbd53588e7249756aab236f6fcb4b
    """
    expanded = ctx.expand_location(part, targets)
    return ctx.expand_make_variables(attr_name, expanded, additional_vars)

def expand_vars(ctx, attr_name, value, targets, additional_vars):
    """Perform `$(location)` and "Make variable" substitution on an attribute.

    - https://bazel.build/reference/be/make-variables#use

    Args:
        ctx: Rule context object
        attr_name: name of the attribute (for error messages)
        value: the attribute value
        targets: a list of `Target` values to use with `$(location)` expansion
        additional_vars: additional values to use with "Make variable" expansion

    Returns:
        the result of performing `$(location)` and "Make variable" substitution
            on the specified attribute value
    """
    # Splitting on `$$` ensures that escaped `$` values prevent `$(location)`
    # and "Make variable" substitution for those portions of `value`.
    return "$".join([
        _expand_part(ctx, attr_name, s, targets, additional_vars)
        for s in value.split("$$")
    ])

def run_environment_info(ctx, additional_attr_names = []):
    """Create a RunEnvironmentInfo provider from `ctx.attr.env` values.

    Implements the "values are subject to `$(location)` and "Make variable"
    substitution" contract for the common `env` attribute for binary and test
    rules:

    - https://bazel.build/reference/be/common-definitions#common-attributes-binaries
    - https://bazel.build/reference/be/common-definitions#common-attributes-tests
    - https://bazel.build/reference/be/make-variables#use
    - https://bazel.build/rules/lib/providers/RunEnvironmentInfo

    Assigns `ctx.attr.env_inherit` to `RunEnvironmentInfo.inherited_environment`
    if present.

    Args:
        ctx: Rule context object
        additional_attr_names: list of attribute names containing targets to use
            when invoking `ctx.expand_location`; already includes "data",
            "deps", and "srcs"

    Returns:
        a RunEnvironmentInfo object containing `ctx.attr.env` values after
            expanding location and Make variables
    """
    targets = []
    for attr_name in ["data"] + additional_attr_names:
        targets.extend(getattr(ctx.attr, attr_name, []))

    return RunEnvironmentInfo(
        environment = {
            k: expand_vars(ctx, "env", v, targets, ctx.var)
            for k, v in ctx.attr.env.items()
        },
        inherited_environment = getattr(ctx.attr, "env_inherit", []),
    )

def phase_runenvironmentinfo_provider(ctx, _):
    return struct(
        external_providers = {"RunEnvironmentInfo": run_environment_info(ctx)},
    )
