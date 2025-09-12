"""Implements a custom environment variable map"""

env_vars = rule(
    implementation = lambda ctx: [
        platform_common.TemplateVariableInfo(ctx.attr.vars),
    ],
    attrs = {"vars": attr.string_dict(mandatory = True)},
)
