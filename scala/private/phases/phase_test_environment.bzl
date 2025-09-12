"""Phase implementing variable expansion for the env attribute

- https://bazel.build/reference/be/common-definitions#common-attributes-tests
- https://bazel.build/rules/lib/providers/RunEnvironmentInfo
- https://bazel.build/reference/be/common-definitions#common-attributes-binaries
- https://bazel.build/reference/be/make-variables#use
"""

def _expand_part(ctx, part, targets):
    expanded = ctx.expand_location(part, targets)

    for name, value in ctx.var.items():
        if len(name) == 1 and not name.isalnum():
            var = "$" + name
        else:
            var = "$(%s)" % name
        expanded = expanded.replace(var, value)
    return expanded

def expand_vars(ctx, value, targets):
    return "$".join([
        _expand_part(ctx, p, targets)
        for p in value.split("$$")
    ])

def phase_test_environment(ctx, _):
    test_env = {
        k: expand_vars(ctx, v, ctx.attr.data)
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
