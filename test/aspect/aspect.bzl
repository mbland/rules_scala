"""
This test makes sure that the implicit rule dependencies are discoverable by
an IDE. We stuff all dependencies into _scala_toolchain so we just need to make
sure the targets we expect are there.
"""
attr_aspects = ["_scala_toolchain", "deps"]

VisitedInfo = provider("Collection of visited targets", fields = ["visited"])

def _stringify_label(label):
    s = str(label)
    if s.startswith("@@//"):
        return s[2:]
    if s.startswith("@//"):
        return s[1:]
    return s

def _aspect_impl(target, ctx):
    visited = [_stringify_label(target.label)]

    for attr_name in attr_aspects:
        for dep in getattr(ctx.rule.attr, attr_name, []):
            visited += dep[VisitedInfo].visited

    return VisitedInfo(visited = visited)

test_aspect = aspect(
    attr_aspects = attr_aspects,
    implementation = _aspect_impl,
)

def _aspect_testscript_impl(ctx):
    expected_deps = {
        "scala_library": [
            "//test/aspect:scala_library",
            "//scala/private/toolchain_deps:scala_library_classpath",
        ],
        "scala_test": [
            "//test/aspect:scala_test",
            "//scala/private/toolchain_deps:scala_library_classpath",
            "//testing/toolchain:scalatest_classpath",
        ],
        "scala_junit_test": [
            "//test/aspect:scala_junit_test",
            "//scala/private/toolchain_deps:scala_library_classpath",
            "//testing/toolchain:junit_classpath",
        ],
        "scala_specs2_junit_test": [
            "//scala/private/toolchain_deps:scala_library_classpath",
            "//test/aspect:scala_specs2_junit_test",
            "//testing/toolchain:junit_classpath",
            # From specs2/specs2.bzl:specs2_dependencies()
            "//specs2:specs2",
            "//scala/private/toolchain_deps:scala_xml",
            # From specs2/specs2_junit.bzl:specs2_junit_dependencies()
            "//testing/toolchain:specs2_junit_classpath",
        ],
    }
    content = ""
    for target in ctx.attr.targets:
        visited = depset(sorted(target[VisitedInfo].visited)).to_list()
        expected = depset(sorted(expected_deps[target.label.name])).to_list()
        if visited != expected:
            content += """
            echo Expected these deps from {name}: 1>&2
            echo {expected}, 1>&2
            echo but got these instead: 1>&2
            echo {visited} 1>&2
            false # test returns 1 (and fails) if this is the final line
            """.format(
                name = target.label.name,
                expected = ", ".join(expected),
                visited = ", ".join(visited),
            )

    script_file = ctx.actions.declare_file("aspect_test.sh")
    ctx.actions.write(
        output = script_file,
        content = content,
    )
    return [DefaultInfo(files = depset([script_file]))]

aspect_testscript = rule(
    implementation = _aspect_testscript_impl,
    attrs = {
        # The targets whose dependencies we want to verify.
        "targets": attr.label_list(aspects = [test_aspect]),
    },
)
