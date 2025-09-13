"""Phase implementing variable expansion for the env attribute

- https://bazel.build/reference/be/common-definitions#common-attributes-tests
- https://bazel.build/rules/lib/providers/RunEnvironmentInfo
- https://bazel.build/reference/be/common-definitions#common-attributes-binaries
- https://bazel.build/reference/be/make-variables#use

As for why we're using the "deprecated" `ctx.expand_make_variables`:

- https://github.com/bazelbuild/bazel/issues/5859
- https://github.com/bazelbuild/bazel-skylib/pull/486

The "deprecated" comment in the `ctx.expand_make_variables` docstring has
existed from the beginning of the file's existence (2018-05-11):

- https://github.com/bazelbuild/bazel/commit/abbb9002c41bbd53588e7249756aab236f6fcb4b
"""

def _expand_part(ctx, attr_name, part, targets, additional_subs):
    expanded = ctx.expand_location(part, targets)
    return ctx.expand_make_variables(attr_name, expanded, additional_subs)

def expand_vars(ctx, attr_name, value, targets, additional_subs):
    return "$".join([
        _expand_part(ctx, attr_name, p, targets, additional_subs)
        for p in value.split("$$")
    ])

def phase_test_environment(ctx, _):
    # Not sure if we'll ever include additional substitutions, but
    # `ctx.expand_make_variables` requires it.
    additional_subs = {}
    test_env = {
        k: expand_vars(ctx, "env", v, ctx.attr.data, additional_subs)
        for k, v in ctx.attr.env.items()
    }
    return struct(
        external_providers = {
            "RunEnvironmentInfo": RunEnvironmentInfo(
                environment = test_env,
                inherited_environment = ctx.attr.env_inherit,
            ),
        },
    )
