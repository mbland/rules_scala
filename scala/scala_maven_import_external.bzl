# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""
'jvm_import_external' offers additional functionality above what maven_jar has to offer.
In addition to downloading the jars, it allows to define this jar's dependencies.
thus it enables the explicit definition of the entire transitive dependency graph.

The rule achieves this by writing 'import' build rules in BUILD files next to the downloaded jars.
The name of the underlying 'import' rule needs to be specified.
An optional 'load' statement can also be provided, along with any other relevant custom attribute.
These import rules must have the following attributes:
- "jars"
- "deps"
- "runtime_deps"
- "exports"

the code here is solely based on `java_import_external` from bazelbuild/bazel repository and is proposed to be upstreamed back.

the following macros are defined below that utilize jvm_import_external:

- scala_import_external - uses `scala_import` as the underlying build rule
- jvm_maven_import_external - offers a 'maven' like api for identifying jars using 'artifact' format
- scala_maven_import_external - combination of scala_import_external and jvm_maven_import_external
- java_import_external - to demonstrate that the original functionality of `java_import_external` stayed intact.
"""

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "read_netrc", "read_user_netrc", "use_netrc")

_SCALA_IMPORT_RULE_LOAD = (
    "load(\"%s\", \"scala_import\")" % Label("//scala:scala_import.bzl")
)

# https://github.com/bazelbuild/bazel/issues/13709#issuecomment-1336699672
def _get_auth(ctx, urls):
    """Given the list of URLs obtain the correct auth dict."""
    if ctx.attr.netrc:
        netrc = read_netrc(ctx, ctx.attr.netrc)
    else:
        netrc = read_user_netrc(ctx)
    return use_netrc(netrc, urls, ctx.attr.auth_patterns)

_HEADER = "# DO NOT EDIT: generated by jvm_import_external()"
_PASS_PROPS = (
    "neverlink",
    "testonly_",
    "visibility",
    "exports",
    "runtime_deps",
    "deps",
    "tags",
)

_FETCH_SOURCES_ENV_VAR_NAME = "BAZEL_JVM_FETCH_SOURCES"

def _jvm_import_external_impl(repository_ctx):
    """Implementation of `java_import_external` rule."""
    if (repository_ctx.attr.generated_linkable_rule_name and
        not repository_ctx.attr.neverlink):
        fail("Only use generated_linkable_rule_name if neverlink is set")
    repo_name = repository_ctx.name
    name = repository_ctx.attr.generated_rule_name or repo_name
    urls = repository_ctx.attr.jar_urls
    if repository_ctx.attr.jar_sha256:
        print("'jar_sha256' is deprecated. Please use 'artifact_sha256'")
    sha = repository_ctx.attr.jar_sha256 or repository_ctx.attr.artifact_sha256
    path = repo_name + ".jar"
    for url in urls:
        if url.endswith(".jar"):
            path = url[url.rindex("/") + 1:]
            break
    srcurls = repository_ctx.attr.srcjar_urls
    srcsha = repository_ctx.attr.srcjar_sha256
    srcpath = repo_name + "-src.jar" if srcurls else ""
    coordinates = repository_ctx.attr.coordinates
    for url in srcurls:
        if url.endswith(".jar"):
            srcpath = url[url.rindex("/") + 1:].replace("-sources.jar", "-src.jar")
            break
    lines = [_HEADER, ""]
    if repository_ctx.attr.rule_load:
        lines.append(repository_ctx.attr.rule_load)
        lines.append("")
    if repository_ctx.attr.default_visibility:
        lines.append("package(default_visibility = %s)" %
                     (repository_ctx.attr.default_visibility))
        lines.append("")
    lines.append("licenses(%s)" % repr(repository_ctx.attr.licenses))
    lines.append("")
    lines.extend(
        _serialize_given_rule_import(
            repository_ctx.attr.rule_name,
            name,
            path,
            srcpath,
            coordinates,
            repository_ctx.attr,
            _PASS_PROPS,
            repository_ctx.attr.additional_rule_attrs,
        ),
    )
    if (repository_ctx.attr.neverlink and
        repository_ctx.attr.generated_linkable_rule_name):
        lines.extend(
            _serialize_given_rule_import(
                repository_ctx.attr.rule_name,
                repository_ctx.attr.generated_linkable_rule_name,
                path,
                srcpath,
                coordinates,
                repository_ctx.attr,
                [p for p in _PASS_PROPS if p != "neverlink"],
                repository_ctx.attr.additional_rule_attrs,
            ),
        )
    extra = repository_ctx.attr.extra_build_file_content
    if extra:
        lines.append(extra)
        if not extra.endswith("\n"):
            lines.append("")
    repository_ctx.download(urls, path, sha, auth = _get_auth(repository_ctx, urls))
    if srcurls and _should_fetch_sources_in_current_env(repository_ctx):
        repository_ctx.download(srcurls, srcpath, srcsha, auth = _get_auth(repository_ctx, srcurls))
    repository_ctx.file("BUILD", "\n".join(lines))
    repository_ctx.file("jar/BUILD", "\n".join([
        _HEADER,
        "",
        "package(default_visibility = %r)" %
        (repository_ctx.attr.visibility or
         repository_ctx.attr.default_visibility),
        "",
        "alias(",
        "    name = \"jar\",",
        "    actual = \"//:%s\"," % name,
        ")",
        "",
    ]))

def _should_fetch_sources_in_current_env(repository_ctx):
    env_bazel_jvm_fetch_sources = repository_ctx.os.environ.get(_FETCH_SOURCES_ENV_VAR_NAME, "true")
    return env_bazel_jvm_fetch_sources.lower() == "true"

def _decode_maven_coordinates(artifact):
    parts = artifact.split(":")
    group_id = parts[0]
    artifact_id = parts[1]
    version = parts[2]
    packaging = "jar"
    classifier = None
    if len(parts) == 4:
        packaging = parts[2]
        version = parts[3]
    elif len(parts) == 5:
        packaging = parts[2]
        classifier = parts[3]
        version = parts[4]

    return struct(
        group_id = group_id,
        artifact_id = artifact_id,
        version = version,
        classifier = classifier,
        packaging = packaging,
    )

def _convert_coordinates_to_urls(coordinates, server_urls):
    group_id = coordinates.group_id.replace(".", "/")
    classifier = coordinates.classifier

    if classifier:
        classifier = "-" + classifier
    else:
        classifier = ""

    final_name = coordinates.artifact_id + "-" + coordinates.version + classifier + "." + coordinates.packaging
    url_suffix = group_id + "/" + coordinates.artifact_id + "/" + coordinates.version + "/" + final_name

    urls = []
    for server_url in server_urls:
        urls.append(_concat_with_needed_slash(server_url, url_suffix))
    return urls

def _concat_with_needed_slash(server_url, url_suffix):
    if server_url.endswith("/"):
        return server_url + url_suffix
    else:
        return server_url + "/" + url_suffix

def _serialize_given_rule_import(
        rule_name,
        name,
        path,
        srcpath,
        coordinates,
        attrs,
        props,
        additional_rule_attrs):
    lines = [
        "%s(" % rule_name,
        "    name = %s," % repr(name),
        "    jars = [%s]," % repr(path),
    ]

    if coordinates:
        lines.append("    tags = [\"maven_coordinates=%s\"]," % coordinates)
    if srcpath:
        lines.append("    srcjar = %s," % repr(srcpath))
    for prop in props:
        value = getattr(attrs, prop, None)
        if value:
            if prop.endswith("_"):
                prop = prop[:-1]
            lines.append("    %s = %s," % (prop, repr(value)))
    for attr_key in additional_rule_attrs:
        lines.append("    %s = %s," % (attr_key, additional_rule_attrs[attr_key]))
    lines.append(")")
    lines.append("")
    return lines

_jvm_import_external = repository_rule(
    implementation = _jvm_import_external_impl,
    attrs = {
        "rule_name": attr.string(mandatory = True),
        "licenses": attr.string_list(mandatory = True, allow_empty = False),
        "jar_urls": attr.string_list(mandatory = True, allow_empty = False),
        "jar_sha256": attr.string(doc = "'jar_sha256' is deprecated. Please use 'artifact_sha256'"),
        "artifact_sha256": attr.string(),
        "rule_load": attr.string(),
        "additional_rule_attrs": attr.string_dict(),
        "srcjar_urls": attr.string_list(),
        "srcjar_sha256": attr.string(),
        "deps": attr.string_list(),
        "runtime_deps": attr.string_list(),
        "testonly_": attr.bool(),
        "exports": attr.string_list(),
        "neverlink": attr.bool(),
        "generated_rule_name": attr.string(),
        "generated_linkable_rule_name": attr.string(),
        "default_visibility": attr.string_list(
            default = ["//visibility:public"],
        ),
        "extra_build_file_content": attr.string(),
        "auth_patterns": attr.string_dict(),
        "netrc": attr.string(),
        "coordinates": attr.string(),
    },
    environ = [_FETCH_SOURCES_ENV_VAR_NAME],
)

def jvm_import_external(**kwargs):
    """Wraps `_jvm_import_external` to pass `name` as `generated_target_name`.

    If `generated_rule_name` is specified already, this is a noop.
    """
    generated_rule_name = kwargs.pop("generated_rule_name", kwargs.get("name"))
    _jvm_import_external(generated_rule_name = generated_rule_name, **kwargs)

def scala_maven_import_external(
        artifact,
        server_urls,
        rule_load = _SCALA_IMPORT_RULE_LOAD,
        fetch_sources = False,
        **kwargs):
    jvm_maven_import_external(
        rule_name = "scala_import",
        rule_load = rule_load,
        artifact = artifact,
        server_urls = server_urls,
        fetch_sources = fetch_sources,
        #additional string attributes' values have to be escaped in order to accomodate non-string types
        #    additional_rule_attrs = {"foo": "'bar'"},
        **kwargs
    )

def jvm_maven_import_external(
        artifact,
        server_urls,
        fetch_sources = False,
        **kwargs):
    if kwargs.get("srcjar_urls") and fetch_sources:
        fail("Either use srcjar_urls or fetch_sources but not both")

    coordinates = _decode_maven_coordinates(artifact)

    jar_urls = _convert_coordinates_to_urls(coordinates, server_urls)

    srcjar_urls = kwargs.pop("srcjar_urls", None)

    if fetch_sources:
        src_coordinates = struct(
            group_id = coordinates.group_id,
            artifact_id = coordinates.artifact_id,
            version = coordinates.version,
            classifier = "sources",
            packaging = "jar",
        )

        srcjar_urls = _convert_coordinates_to_urls(src_coordinates, server_urls)

    jvm_import_external(jar_urls = jar_urls, srcjar_urls = srcjar_urls, coordinates = artifact, **kwargs)

def scala_import_external(
        rule_load = _SCALA_IMPORT_RULE_LOAD,
        **kwargs):
    jvm_import_external(
        rule_name = "scala_import",
        rule_load = rule_load,
        **kwargs
    )

"""Rules for defining external Java dependencies.

java_import_external() replaces `maven_jar` and `http_jar`. It is the
recommended solution for defining third party Java dependencies that are
obtained from web servers.

This solution offers high availability, low latency, and repository
scalability at the cost of simplicity. Tooling can be used to generate

The default target in this BUILD file will always have the same name as
the repository itself. This means that other Bazel rules can depend on
it as `@repo//:repo` or `@repo` for short.

### Setup

Add the following to your `WORKSPACE` file:

```python
load("@bazel_tools//tools/build_defs/repo:java.bzl", "java_import_external")
```

### Best Practices

#### Downloading

The recommended best practices for downloading Maven jars are as follows:

1. Always follow release versions or pinned revisions.
2. Permanently mirror all dependencies to GCS or S3 as the first URL
3. Put the original URL in the GCS or S3 object name
4. Make the second URL the original repo1.maven.org URL
5. Make the third URL the maven.ibiblio.org mirror, if it isn't 404
6. Always specify the sha256 checksum

Bazel has one of the most sophisticated systems for downloading files of any
build system. Following these best practices will ensure that your codebase
takes full advantage of the level of reliability that Bazel able to offer. See
https://goo.gl/uQOE11 for more information.

#### Selection

Avoid using jars that bundle their dependencies. For example, a Maven jar for
the artifact com.initech:tps:1.0 should not contain a classes named
com.fakecorp.foo. Try to see if Initech distributes a tps jar that doesn't
bundle its dependencies. Then create a separate java_import_external() for each
one and have the first depend on the second.

Sometimes jars are distributed with their dependencies shaded. What this means
is that com.initech.tps will contain classes like
com.initech.tps.shade.com.fakecorp.foo. This is less problematic, since it
won't lead to mysterious classpath conflicts. But it can lead to inefficient
use of space and make the license of the the end product more difficult to
determine.

#### Licensing

The following values for the licenses field are typically used. If a jar
contains multiple works with difference licenses, then only the most
restrictive one is listed, and the rest are noted in accompanying comments.

The following are examples of how licenses could be categorized, ordered
by those with terms most permissive to least:

- **unencumbered**: CC0, Unlicense
- **permissive**: Beerware
- **notice**: Apache, MIT, X11, BSD, ISC, ZPL, Unicode, JSON, Artistic
- **reciprocal**: MPL, CPL, EPL, Eclipse, APSL, IBMPL, CDDL
- **restricted**: GPL, LGPL, OSL, Sleepycat, QTPL, Java, QMail, NPL
- **by_exception_only**: AGPL, WTFPL

### Naming

Bazel repository names must match the following pattern: `[_0-9A-Za-z]+`. To
choose an appropriate name based on a Maven group and artifact ID, we recommend
an algorithm https://gist.github.com/jart/41bfd977b913c2301627162f1c038e55 which
can be best explained by the following examples:

- com.google.guava:guava becomes com_google_guava
- commons-logging:commons-logging becomes commons_logging
- junit:junit becomes junit

Adopting this naming convention will help maximize the chances that your
codebase will be able to successfully interoperate with other Bazel codebases
using Java.

### Example

Here is an example of a best practice definition of Google's Guava library:

```python
java_import_external(
    name = "com_google_guava",
    licenses = ["notice"],  # Apache 2.0
    jar_urls = [
        "http://bazel-mirror.storage.googleapis.com/repo1.maven.org/maven2/com/google/guava/guava/20.0/guava-20.0.jar",
        "http://repo1.maven.org/maven2/com/google/guava/guava/20.0/guava-20.0.jar",
        "http://maven.ibiblio.org/maven2/com/google/guava/guava/20.0/guava-20.0.jar",
    ],
    artifact_sha256 = "36a666e3b71ae7f0f0dca23654b67e086e6c93d192f60ba5dfd5519db6c288c8",
    deps = [
        "@com_google_code_findbugs_jsr305",
        "@com_google_errorprone_error_prone_annotations",
    ],
)

java_import_external(
    name = "com_google_code_findbugs_jsr305",
    licenses = ["notice"],  # BSD 3-clause
    jar_urls = [
        "http://bazel-mirror.storage.googleapis.com/repo1.maven.org/maven2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar",
        "http://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar",
        "http://maven.ibiblio.org/maven2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar",
    ],
    artifact_sha256 = "905721a0eea90a81534abb7ee6ef4ea2e5e645fa1def0a5cd88402df1b46c9ed",
)

java_import_external(
    name = "com_google_errorprone_error_prone_annotations",
    licenses = ["notice"],  # Apache 2.0
    artifact_sha256 = "e7749ffdf03fb8ebe08a727ea205acb301c8791da837fee211b99b04f9d79c46",
    jar_urls = [
        "http://bazel-mirror.storage.googleapis.com/repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.0.15/error_prone_annotations-2.0.15.jar",
        "http://maven.ibiblio.org/maven2/com/google/errorprone/error_prone_annotations/2.0.15/error_prone_annotations-2.0.15.jar",
        "http://repo1.maven.org/maven2/com/google/errorprone/error_prone_annotations/2.0.15/error_prone_annotations-2.0.15.jar",
    ],
)
```

### Annotation Processors

Defining jars that contain annotation processors requires a certain level of
trickery, which is best done by copying and pasting from codebases that have
already done it before. Please see the Google Nomulus and Bazel Closure Rules
codebases for examples in which java_import_external has been used to define
Dagger 2.0, AutoValue, and AutoFactory.

Please note that certain care needs to be taken into consideration regarding
whether or not these annotation processors generate actual API, or simply
generate code that implements them. See the Bazel documentation for further
information.

### Test Dependencies

It is strongly recommended that the `testonly_` attribute be specified on
libraries that are intended for testing purposes. This is passed along to the
generated `java_library` rule in order to ensure that test code remains
disjoint from production code.

### Provided Dependencies

The feature in Bazel most analagous to Maven's provided scope is the neverlink
attribute. This should be used in rare circumstances when a distributed jar
will be loaded into a runtime environment where certain dependencies can be
reasonably expected to already be provided.
"""

def java_import_external(**kwargs):
    jvm_import_external(
        rule_name = "java_import",
        **kwargs
    )
