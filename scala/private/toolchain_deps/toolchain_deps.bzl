load("//scala:providers.bzl", "DepsInfo")

def java_info_for_deps(deps):
    return [java_common.merge([dep[JavaInfo] for dep in deps])]

def _lookup_provider_by_id(ctx, toolchain_type_label, dep_providers, deps_id):
    for dep_provider in dep_providers:
        if dep_provider[DepsInfo].deps_id == deps_id:
            return dep_provider

    fail("%s requires mapping of %s provider id on the toolchain %s" % (
        ctx.label,
        toolchain_type_label,
        deps_id,
    ))

def find_deps_info_on(ctx, toolchain_type_label, deps_id):
    dep_providers = getattr(ctx.toolchains[toolchain_type_label], "dep_providers")

    return _lookup_provider_by_id(ctx, toolchain_type_label, dep_providers, deps_id)[DepsInfo]

def expose_toolchain_deps(ctx, toolchain_type_label):
    deps_id = ctx.attr.deps_id
    deps_info = find_deps_info_on(ctx, toolchain_type_label, deps_id)
    return java_info_for_deps(deps_info.deps)
