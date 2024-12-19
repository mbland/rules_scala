"""Maven artifact repository metadata.

Mostly generated and updated by scripts/create_repository.py.
"""

scala_version = "2.13.15"

artifacts = {
    "com_geirsson_metaconfig_core": {
        "artifact": "com.geirsson:metaconfig-core_2.13:0.12.0",
        "sha256": "2c91199ae5b206afdd52538f8c4da67c1794bcce0b5b06cf25679db00cf32c19",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@com_geirsson_metaconfig_pprint",
            "@org_scala_lang_modules_scala_collection_compat",
            "@org_typelevel_paiges_core",
        ],
    },
    "com_geirsson_metaconfig_pprint": {
        "artifact": "com.geirsson:metaconfig-pprint_2.13:0.12.0",
        "sha256": "6d8b0b4279116c11d4f29443bd2a9411bedb3d86ccaf964599a9420f530ed062",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler",
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@com_lihaoyi_fansi",
        ],
    },
    "com_geirsson_metaconfig_typesafe_config": {
        "artifact": "com.geirsson:metaconfig-typesafe-config_2.13:0.12.0",
        "sha256": "b4c5dbf863dadde363d8bd24333ce1091fec94fc5b88efd04607a26f3eab61b8",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@com_geirsson_metaconfig_core",
            "@com_typesafe_config",
        ],
    },
    "com_github_jnr_jffi_native": {
        "testonly": True,
        "artifact": "com.github.jnr:jffi:jar:native:1.2.17",
        "sha256": "4eb582bc99d96c8df92fc6f0f608fd123d278223982555ba16219bf8be9f75a9",
    },
    "com_google_android_annotations": {
        "artifact": "com.google.android:annotations:4.1.1.4",
        "sha256": "ba734e1e84c09d615af6a09d33034b4f0442f8772dec120efb376d86a565ae15",
    },
    "com_google_code_findbugs_jsr305": {
        "artifact": "com.google.code.findbugs:jsr305:3.0.2",
        "sha256": "766ad2a0783f2687962c8ad74ceecc38a28b9f72a2d085ee438b7813e928d0c7",
    },
    "com_google_code_gson_gson": {
        "artifact": "com.google.code.gson:gson:2.11.0",
        "sha256": "57928d6e5a6edeb2abd3770a8f95ba44dce45f3b23b7a9dc2b309c581552a78b",
        "deps": [
            "@com_google_errorprone_error_prone_annotations",
        ],
    },
    "com_google_errorprone_error_prone_annotations": {
        "artifact": "com.google.errorprone:error_prone_annotations:2.28.0",
        "sha256": "f3fc8a3a0a4020706a373b00e7f57c2512dd26d1f83d28c7d38768f8682b231e",
    },
    "com_google_guava_guava_21_0": {
        "testonly": True,
        "artifact": "com.google.guava:guava:21.0",
        "sha256": "972139718abc8a4893fa78cba8cf7b2c903f35c97aaf44fa3031b0669948b480",
        "deps": [
            "@org_springframework_spring_core",
        ],
    },
    "com_google_guava_guava_21_0_with_file": {
        "testonly": True,
        "artifact": "com.google.guava:guava:21.0",
        "sha256": "972139718abc8a4893fa78cba8cf7b2c903f35c97aaf44fa3031b0669948b480",
    },
    "com_google_j2objc_j2objc_annotations": {
        "artifact": "com.google.j2objc:j2objc-annotations:3.0.0",
        "sha256": "88241573467ddca44ffd4d74aa04c2bbfd11bf7c17e0c342c94c9de7a70a7c64",
    },
    "com_google_protobuf_protobuf_java": {
        "artifact": "com.google.protobuf:protobuf-java:4.29.0",
        "sha256": "16901851ebe5e89fe88aaad3c26866373695bc2e30627bb8932847e2f5fc2e76",
    },
    "com_lihaoyi_fansi": {
        "artifact": "com.lihaoyi:fansi_2.13:0.4.0",
        "sha256": "0eb11a2a905d608033ec1642b0a9f0d8444daa4ad465f684b50bdc7e7a41bf53",
        "deps": [
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_fastparse": {
        "artifact": "com.lihaoyi:fastparse_2.13:2.1.3",
        "sha256": "5064d3984aab8c48d2dbd6285787ac5c6d84a6bebfc02c6d431ce153cf91dec1",
        "deps": [
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_geny": {
        "artifact": "com.lihaoyi:geny_2.13:0.6.5",
        "sha256": "ca3857a3f95266e0d87e1a1f26c8592c53c12ac7203f911759415f6c8a43df7d",
    },
    "com_lihaoyi_pprint": {
        "artifact": "com.lihaoyi:pprint_2.13:0.9.0",
        "sha256": "5dd36b65addcd47bccc68d36dd00bee93e2def439f1a36d02a450308e8d9a3d3",
        "deps": [
            "@com_lihaoyi_fansi",
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_sourcecode": {
        "artifact": "com.lihaoyi:sourcecode_2.13:0.4.2",
        "sha256": "fbace2b994a7184f6b38ee98630be61f21948008a4a56cd83c7f86c1c1de743d",
    },
    "com_twitter__scalding_date": {
        "testonly": True,
        "artifact": "com.twitter:scalding-date_2.13:0.17.0",
        "sha256": "973a7198121cc8dac9eeb3f325c93c497fe3b682f68ba56e34c1b210af7b15b4",
    },
    "com_typesafe_config": {
        "artifact": "com.typesafe:config:1.4.1",
        "sha256": "4c0aa7e223c75c8840c41fc183d4cd3118140a1ee503e3e08ce66ed2794c948f",
    },
    "dev_dirs_directories": {
        "artifact": "dev.dirs:directories:26",
        "sha256": "6d18fe25aa30b7e08b908cd21151d8f96e22965c640acd7751add9bbfe6137d4",
    },
    "io_bazel_rules_scala_failureaccess": {
        "artifact": "com.google.guava:failureaccess:1.0.2",
        "sha256": "8a8f81cf9b359e3f6dfa691a1e776985c061ef2f223c9b2c80753e1b458e8064",
    },
    "io_bazel_rules_scala_guava": {
        "artifact": "com.google.guava:guava:33.3.1-jre",
        "sha256": "4bf0e2c5af8e4525c96e8fde17a4f7307f97f8478f11c4c8e35a0e3298ae4e90",
        "deps": [
            "@com_google_code_findbugs_jsr305",
            "@com_google_errorprone_error_prone_annotations",
            "@com_google_j2objc_j2objc_annotations",
            "@io_bazel_rules_scala_failureaccess",
            "@org_checkerframework_checker_qual",
        ],
    },
    "io_bazel_rules_scala_javax_annotation_api": {
        "artifact": "javax.annotation:javax.annotation-api:1.3.2",
        "sha256": "e04ba5195bcd555dc95650f7cc614d151e4bcd52d29a10b8aa2197f3ab89ab9b",
    },
    "io_bazel_rules_scala_junit_junit": {
        "artifact": "junit:junit:4.12",
        "sha256": "59721f0805e223d84b90677887d9ff567dc534d7c502ca903c0c2b17f05c116a",
    },
    "io_bazel_rules_scala_mustache": {
        "artifact": "com.github.spullara.mustache.java:compiler:0.8.18",
        "sha256": "ddabc1ef897fd72319a761d29525fd61be57dc25d04d825f863f83cc89000e66",
    },
    "io_bazel_rules_scala_net_sf_jopt_simple_jopt_simple": {
        "artifact": "net.sf.jopt-simple:jopt-simple:5.0.4",
        "sha256": "df26cc58f235f477db07f753ba5a3ab243ebe5789d9f89ecf68dd62ea9a66c28",
    },
    "io_bazel_rules_scala_org_apache_commons_commons_math3": {
        "artifact": "org.apache.commons:commons-math3:3.6.1",
        "sha256": "1e56d7b058d28b65abd256b8458e3885b674c1d588fa43cd7d1cbb9c7ef2b308",
    },
    "io_bazel_rules_scala_org_hamcrest_hamcrest_core": {
        "artifact": "org.hamcrest:hamcrest-core:1.3",
        "sha256": "66fdef91e9739348df7a096aa384a5685f4e875584cce89386a7a47251c4d8e9",
    },
    "io_bazel_rules_scala_org_openjdk_jmh_jmh_core": {
        "artifact": "org.openjdk.jmh:jmh-core:1.36",
        "sha256": "f90974e37d0da8886b5c05e6e3e7e20556900d747c5a41c1023b47c3301ea73c",
    },
    "io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_asm": {
        "artifact": "org.openjdk.jmh:jmh-generator-asm:1.36",
        "sha256": "7460b11b823dee74b3e19617d35d5911b01245303d6e31c30f83417cfc2f54b5",
    },
    "io_bazel_rules_scala_org_openjdk_jmh_jmh_generator_reflection": {
        "artifact": "org.openjdk.jmh:jmh-generator-reflection:1.36",
        "sha256": "a9c72760e12c199e2a2c28f1a126ebf0cc5b51c0b58d46472596fc32f7f92534",
    },
    "io_bazel_rules_scala_org_ow2_asm_asm": {
        "artifact": "org.ow2.asm:asm:9.0",
        "sha256": "0df97574914aee92fd349d0cb4e00f3345d45b2c239e0bb50f0a90ead47888e0",
    },
    "io_bazel_rules_scala_org_specs2_specs2_common": {
        "artifact": "org.specs2:specs2-common_2.13:4.10.3",
        "sha256": "51636fb6a904b3c807de0673f283a971379c9886e03aedbecbf5d787b22346b0",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_fp",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_core": {
        "artifact": "org.specs2:specs2-core_2.13:4.10.3",
        "sha256": "9cc55eb11781c9b77689cf8175795fad34b060718b04a225fffb0613a181256b",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_common",
            "@io_bazel_rules_scala_org_specs2_specs2_matcher",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_fp": {
        "artifact": "org.specs2:specs2-fp_2.13:4.10.3",
        "sha256": "48a908b345c93a3387ddd157ab338686513f450c7dd8afe0f32b6edc7ff15239",
    },
    "io_bazel_rules_scala_org_specs2_specs2_junit": {
        "artifact": "org.specs2:specs2-junit_2.13:4.10.3",
        "sha256": "49c4e7cf5483aada90852314983fc046f72092da1a4e7900ace6574444f581ea",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_core",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_matcher": {
        "artifact": "org.specs2:specs2-matcher_2.13:4.10.3",
        "sha256": "754465f58dad8f59b3bb299d5dc127027bf0c0c9ad25250260fc95abd705363b",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_common",
        ],
    },
    "io_bazel_rules_scala_scala_compiler": {
        "artifact": "org.scala-lang:scala-compiler:2.13.15",
        "sha256": "4c200cd193c082bec14a2a2dffe6a1ba5f8130b1b27c79ee54c936dfcafc8ed9",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
        ],
    },
    "io_bazel_rules_scala_scala_library": {
        "artifact": "org.scala-lang:scala-library:2.13.15",
        "sha256": "8e4dbc3becf70d59c787118f6ad06fab6790136a0699cd6412bc9da3d336944e",
    },
    "io_bazel_rules_scala_scala_parallel_collections": {
        "artifact": "org.scala-lang.modules:scala-parallel-collections_2.13:1.0.4",
        "sha256": "68f266c4fa37cb20a76e905ad940e241190ce288b7e4a9877f1dd1261cd1a9a7",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scala_parser_combinators": {
        "artifact": "org.scala-lang.modules:scala-parser-combinators_2.13:1.1.2",
        "sha256": "5c285b72e6dc0a98e99ae0a1ceeb4027dab9adfa441844046bd3f19e0efdcb54",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scala_reflect": {
        "artifact": "org.scala-lang:scala-reflect:2.13.15",
        "sha256": "78d0cc350e1ee42d87c6e11cf5b0dc7bf0b70829c00aa38f27bfb019d439dc11",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scala_xml": {
        "artifact": "org.scala-lang.modules:scala-xml_2.13:2.1.0",
        "sha256": "d122cbf93115ee714570de6a9c18e53001fedb474911d4cb5091758ee51f053a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scalactic": {
        "artifact": "org.scalactic:scalactic_2.13:3.2.19",
        "sha256": "c27c33de17d450e29e66c16c5af4cfa33e8ffcf03c124f0a3d249d848cccd4af",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
        ],
    },
    "io_bazel_rules_scala_scalatest": {
        "artifact": "org.scalatest:scalatest_2.13:3.2.19",
        "sha256": "c37d97f16172d45b2aef0cebbe59dd2174b7d1ff2c2f272516707cf923015a52",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
            "@io_bazel_rules_scala_scalatest_diagrams",
            "@io_bazel_rules_scala_scalatest_featurespec",
            "@io_bazel_rules_scala_scalatest_flatspec",
            "@io_bazel_rules_scala_scalatest_freespec",
            "@io_bazel_rules_scala_scalatest_funspec",
            "@io_bazel_rules_scala_scalatest_funsuite",
            "@io_bazel_rules_scala_scalatest_matchers_core",
            "@io_bazel_rules_scala_scalatest_mustmatchers",
            "@io_bazel_rules_scala_scalatest_propspec",
            "@io_bazel_rules_scala_scalatest_refspec",
            "@io_bazel_rules_scala_scalatest_shouldmatchers",
            "@io_bazel_rules_scala_scalatest_wordspec",
        ],
    },
    "io_bazel_rules_scala_scalatest_compatible": {
        "artifact": "org.scalatest:scalatest-compatible:3.2.19",
        "sha256": "5dc6b8fa5396fe9e1a7c2b72df174a8eb3e92770cdc3e70636d3eba673cd0da3",
    },
    "io_bazel_rules_scala_scalatest_core": {
        "artifact": "org.scalatest:scalatest-core_2.13:3.2.19",
        "sha256": "30230081d029f6341b83fe7f157d336113e1c97497fe950169293d28a5bf2936",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scala_xml",
            "@io_bazel_rules_scala_scalactic",
            "@io_bazel_rules_scala_scalatest_compatible",
        ],
    },
    "io_bazel_rules_scala_scalatest_diagrams": {
        "artifact": "org.scalatest:scalatest-diagrams_2.13:3.2.19",
        "sha256": "a77294d3d5a564e1d8cd6550d4ac795ac042fa90efa91d139da123d7ec5f3bec",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_featurespec": {
        "artifact": "org.scalatest:scalatest-featurespec_2.13:3.2.19",
        "sha256": "58a44e6be12409596feab4d4123900ef2af55d3fcb72033412059ce055e91dee",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_flatspec": {
        "artifact": "org.scalatest:scalatest-flatspec_2.13:3.2.19",
        "sha256": "de4d28423dc69e91fdc8f3a03a4fb6b443c5626b819c896e5fbe4a73a375654a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_freespec": {
        "artifact": "org.scalatest:scalatest-freespec_2.13:3.2.19",
        "sha256": "f3e463422cca38117bb48665602543474fbc2c37427b1133a9c34332f895b08a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_funspec": {
        "artifact": "org.scalatest:scalatest-funspec_2.13:3.2.19",
        "sha256": "4c682781b67c5daeeebb9e132a78929b824f88747b963b9aa8bd24a0a7d6893b",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_funsuite": {
        "artifact": "org.scalatest:scalatest-funsuite_2.13:3.2.19",
        "sha256": "926aeb37193ad79d0b380160765c9ab61d4367b994c1ab715896fe4961241d5e",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_matchers_core": {
        "artifact": "org.scalatest:scalatest-matchers-core_2.13:3.2.19",
        "sha256": "033f16c1143fbe51675d080b13ac319d98581d0331ba3ccebb121e3904a774a3",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_mustmatchers": {
        "artifact": "org.scalatest:scalatest-mustmatchers_2.13:3.2.19",
        "sha256": "8ebbd5c12843d75f15283f31c35994b6e733ce737f666b05528fa8b6e67ad32e",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_matchers_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_propspec": {
        "artifact": "org.scalatest:scalatest-propspec_2.13:3.2.19",
        "sha256": "6c1c7d557485861d920b1c26748a871232b626e93d466a3d9bb8dbbc6e38485d",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_refspec": {
        "artifact": "org.scalatest:scalatest-refspec_2.13:3.2.19",
        "sha256": "7a4c836cf66c99c1e12ca96e6d94c4f68b7dbb49144f9e13af73ada4df752652",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_shouldmatchers": {
        "artifact": "org.scalatest:scalatest-shouldmatchers_2.13:3.2.19",
        "sha256": "64658d736039267baae0108af620617e8ce88b2f4683112e2e31e4ad2a603c0f",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_matchers_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_wordspec": {
        "artifact": "org.scalatest:scalatest-wordspec_2.13:3.2.19",
        "sha256": "08050f3d05c72575cac29a1483185b443d5f9f34c1fcf80c683083330385ef93",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scopt": {
        "artifact": "com.github.scopt:scopt_2.13:4.0.0-RC2",
        "sha256": "07c1937cba53f7509d2ac62a0fc375943a3e0fef346625414c15d41b5a6cfb34",
    },
    "io_bazel_rules_scala_scrooge_core": {
        "artifact": "com.twitter:scrooge-core_2.13:21.2.0",
        "sha256": "a93f179b96e13bd172e5164c587a3645122f45f6d6370304e06d52e2ab0e456f",
    },
    "io_bazel_rules_scala_scrooge_generator": {
        "artifact": "com.twitter:scrooge-generator_2.13:21.2.0",
        "sha256": "1293391da7df25497cad7c56cf8ecaeb672496a548d144d7a2a1cfcf748bed6c",
        "runtime_deps": [
            "@io_bazel_rules_scala_guava",
            "@io_bazel_rules_scala_mustache",
            "@io_bazel_rules_scala_scopt",
        ],
    },
    "io_bazel_rules_scala_util_core": {
        "artifact": "com.twitter:util-core_2.13:21.2.0",
        "sha256": "da8e149b8f0646316787b29f6e254250da10b4b31d9a96c32e42f613574678cd",
    },
    "io_bazel_rules_scala_util_logging": {
        "artifact": "com.twitter:util-logging_2.13:21.2.0",
        "sha256": "90bd8318329907dcf7e161287473e27272b38ee6857e9d56ee8a1958608cc49d",
    },
    "io_github_java_diff_utils_java_diff_utils": {
        "artifact": "io.github.java-diff-utils:java-diff-utils:4.12",
        "sha256": "9990a2039778f6b4cc94790141c2868864eacee0620c6c459451121a901cd5b5",
    },
    "libthrift": {
        "artifact": "org.apache.thrift:libthrift:0.8.0",
        "sha256": "adea029247c3f16e55e29c1708b897812fd1fe335ac55fe3903e5d2f428ef4b3",
    },
    "net_java_dev_jna_jna": {
        "artifact": "net.java.dev.jna:jna:5.14.0",
        "sha256": "34ed1e1f27fa896bca50dbc4e99cf3732967cec387a7a0d5e3486c09673fe8c6",
    },
    "org_apache_commons_commons_lang_3_5": {
        "testonly": True,
        "artifact": "org.apache.commons:commons-lang3:3.5",
        "sha256": "8ac96fc686512d777fca85e144f196cd7cfe0c0aec23127229497d1a38ff651c",
    },
    "org_checkerframework_checker_qual": {
        "artifact": "org.checkerframework:checker-qual:3.43.0",
        "sha256": "3fbc2e98f05854c3df16df9abaa955b91b15b3ecac33623208ed6424640ef0f6",
    },
    "org_codehaus_mojo_animal_sniffer_annotations": {
        "artifact": "org.codehaus.mojo:animal-sniffer-annotations:1.24",
        "sha256": "c720e6e5bcbe6b2f48ded75a47bccdb763eede79d14330102e0d352e3d89ed92",
    },
    "org_jline_jline": {
        "artifact": "org.jline:jline:3.27.1",
        "sha256": "72fcbc58da05092067739ded62ed6b1ba9075ecd0fee1caa634c2cbf1a16fe7a",
    },
    "org_scala_lang_modules_scala_collection_compat": {
        "artifact": "org.scala-lang.modules:scala-collection-compat_2.13:2.12.0",
        "sha256": "befff482233cd7f9a7ca1e1f5a36ede421c018e6ce82358978c475d45532755f",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scala_lang_scalap": {
        "artifact": "org.scala-lang:scalap:2.13.15",
        "sha256": "78991282d73e9d20cbf187bab8549ce2ef940269409d47df2a71faaf9afc4616",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler",
        ],
    },
    "org_scalameta_common": {
        "artifact": "org.scalameta:common_2.13:4.9.9",
        "sha256": "be66ba789863c65abfc9c1e448339ce915f2bc778daf348d884a967e8eb473ee",
        "deps": [
            "@com_lihaoyi_sourcecode",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_fastparse": {
        "artifact": "org.scalameta:fastparse-v2_2.13:2.3.1",
        "sha256": "8fca8597ad6d7c13c48009ee13bbe80c176b08ab12e68af54a50f7f69d8447c5",
        "deps": [
            "@com_lihaoyi_geny",
            "@com_lihaoyi_sourcecode",
        ],
    },
    "org_scalameta_fastparse_utils": {
        "artifact": "org.scalameta:fastparse-utils_2.13:1.0.1",
        "sha256": "9d650543903836684a808bb4c5ff775a4cae4b38c3a47ce946b572237fde340f",
        "deps": [
            "@com_lihaoyi_sourcecode",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_mdoc_parser": {
        "artifact": "org.scalameta:mdoc-parser_2.13:2.5.4",
        "sha256": "a36fc6125666047b653f8acb1aad16db4aefaaaffdc3f53d2b9eeec83dc580bf",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_parsers": {
        "artifact": "org.scalameta:parsers_2.13:4.9.9",
        "sha256": "ab4198d993b4214d9b98277f96c4ac76a72b87a1fea8df96e9be8e3e98176d7a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scalameta_trees",
        ],
    },
    "org_scalameta_scalafmt_config": {
        "artifact": "org.scalameta:scalafmt-config_2.13:3.8.3",
        "sha256": "175c7e345baccb75e0f79aa9d8c821834b4b232d3917039c44ca2f0265f2110a",
        "deps": [
            "@com_geirsson_metaconfig_core",
            "@com_geirsson_metaconfig_typesafe_config",
        ],
    },
    "org_scalameta_scalafmt_core": {
        "artifact": "org.scalameta:scalafmt-core_2.13:3.8.3",
        "sha256": "c214d16a746ceab8ac47b97c18d2817f726174dd58da75d43472d045ddc25009",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@org_scalameta_mdoc_parser",
            "@org_scalameta_scalafmt_config",
            "@org_scalameta_scalafmt_sysops",
            "@org_scalameta_scalameta",
        ],
    },
    "org_scalameta_scalafmt_sysops": {
        "artifact": "org.scalameta:scalafmt-sysops_2.13:3.8.3",
        "sha256": "981b5455b956ece0e7f2c0825241c6f99b2d70cc2352700a2fcffa5c01ed6633",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_parallel_collections",
        ],
    },
    "org_scalameta_scalameta": {
        "artifact": "org.scalameta:scalameta_2.13:4.9.9",
        "sha256": "01a3c1130202400dbcf4ea0f42374c8e392b9199716ddf605217f4bf1f61cb1d",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_scalap",
            "@org_scalameta_parsers",
        ],
    },
    "org_scalameta_semanticdb_scalac": {
        "artifact": "org.scalameta:semanticdb-scalac_2.13.15:4.9.9",
        "sha256": "409194fee7eeb3da25733f6fc0c2d62b9ef53ddecdc50b6c922fdc695b250fe7",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_trees": {
        "artifact": "org.scalameta:trees_2.13:4.9.9",
        "sha256": "d016cde916b19d6c814ac296544a1882b96664ac03e5ef27019a518482c3db49",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scalameta_common",
        ],
    },
    "org_springframework_spring_core": {
        "testonly": True,
        "artifact": "org.springframework:spring-core:5.1.5.RELEASE",
        "sha256": "f771b605019eb9d2cf8f60c25c050233e39487ff54d74c93d687ea8de8b7285a",
    },
    "org_springframework_spring_tx": {
        "testonly": True,
        "artifact": "org.springframework:spring-tx:5.1.5.RELEASE",
        "sha256": "666f72b73c7e6b34e5bb92a0d77a14cdeef491c00fcb07a1e89eb62b08500135",
        "deps": [
            "@org_springframework_spring_core",
        ],
    },
    "org_typelevel__cats_core": {
        "testonly": True,
        "artifact": "org.typelevel:cats-core_2.13:2.2.0",
        "sha256": "6058d02418e4eb5f1919a1156d63d2d1b93f2c6190b1a1806ee2b73f8726a92f",
    },
    "org_typelevel_kind_projector": {
        "artifact": "org.typelevel:kind-projector_2.13.15:0.13.3",
        "sha256": "569fec54deba82cd143f05a6a0456c9e3bf56bff310b0968f0adb5fb3b352d92",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_typelevel_paiges_core": {
        "artifact": "org.typelevel:paiges-core_2.13:0.4.3",
        "sha256": "4daa8b180b466634b66be040e1097c107981c0ba0b7c605e2f7c0b66ae1b99b5",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "scala_proto_rules_disruptor": {
        "artifact": "com.lmax:disruptor:3.4.2",
        "sha256": "f412ecbb235c2460b45e63584109723dea8d94b819c78c9bfc38f50cba8546c0",
    },
    "scala_proto_rules_grpc_api": {
        "artifact": "io.grpc:grpc-api:1.68.1",
        "sha256": "d88d815e07fe58a7572dda5d2823485b61706564f289a1e74281705d50ac2d5b",
        "deps": [
            "@com_google_code_findbugs_jsr305",
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
        ],
    },
    "scala_proto_rules_grpc_context": {
        "artifact": "io.grpc:grpc-context:1.68.1",
        "sha256": "1df4f0310a7e7836bc2948afa95105f5ee27b5d468488aded74e7ff620359076",
        "deps": [
            "@scala_proto_rules_grpc_api",
        ],
    },
    "scala_proto_rules_grpc_core": {
        "artifact": "io.grpc:grpc-core:1.68.1",
        "sha256": "e1eddfe433aa850783cb6af9ad6da1ad3dfe2fb9b4c385b9a98d7a596e4d382a",
        "deps": [
            "@com_google_android_annotations",
            "@com_google_code_gson_gson",
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
            "@org_codehaus_mojo_animal_sniffer_annotations",
            "@scala_proto_rules_grpc_api",
            "@scala_proto_rules_grpc_context",
            "@scala_proto_rules_perfmark_api",
        ],
    },
    "scala_proto_rules_grpc_netty": {
        "artifact": "io.grpc:grpc-netty:1.68.1",
        "sha256": "1bf33f36496c4fffa7b83cab9215ab2967f00e483270d87f1c17b23e5722a13f",
        "deps": [
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
            "@scala_proto_rules_grpc_api",
            "@scala_proto_rules_grpc_core",
            "@scala_proto_rules_grpc_util",
            "@scala_proto_rules_netty_codec_http2",
            "@scala_proto_rules_netty_handler_proxy",
            "@scala_proto_rules_netty_transport_native_unix_common",
            "@scala_proto_rules_perfmark_api",
        ],
    },
    "scala_proto_rules_grpc_protobuf": {
        "artifact": "io.grpc:grpc-protobuf:1.68.1",
        "sha256": "75329d9aa328a0b1feef6803d59b93b527bceed9c97ceaaa0f8bd2d78ce98d14",
        "deps": [
            "@com_google_code_findbugs_jsr305",
            "@com_google_protobuf_protobuf_java",
            "@io_bazel_rules_scala_guava",
            "@scala_proto_rules_grpc_api",
            "@scala_proto_rules_grpc_protobuf_lite",
            "@scala_proto_rules_proto_google_common_protos",
        ],
    },
    "scala_proto_rules_grpc_protobuf_lite": {
        "artifact": "io.grpc:grpc-protobuf-lite:1.68.1",
        "sha256": "f039759f64d365e7495a05bebee938713c85720236b91f628c21a7c3bc7f98de",
        "deps": [
            "@com_google_code_findbugs_jsr305",
            "@io_bazel_rules_scala_guava",
            "@scala_proto_rules_grpc_api",
        ],
    },
    "scala_proto_rules_grpc_stub": {
        "artifact": "io.grpc:grpc-stub:1.68.1",
        "sha256": "3d0260ba925cdeb63930b672daac815245f1c76d67ec111dd82e4dac6c9abd47",
        "deps": [
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
            "@scala_proto_rules_grpc_api",
        ],
    },
    "scala_proto_rules_grpc_util": {
        "artifact": "io.grpc:grpc-util:1.68.1",
        "sha256": "d489e40de9209981272fb9e7b0f61a5f0e5c1ce230195a5f23fb1078cd1baade",
        "deps": [
            "@io_bazel_rules_scala_guava",
            "@org_codehaus_mojo_animal_sniffer_annotations",
            "@scala_proto_rules_grpc_api",
            "@scala_proto_rules_grpc_core",
        ],
    },
    "scala_proto_rules_instrumentation_api": {
        "artifact": "com.google.instrumentation:instrumentation-api:0.3.0",
        "sha256": "671f7147487877f606af2c7e39399c8d178c492982827305d3b1c7f5b04f1145",
    },
    "scala_proto_rules_netty_buffer": {
        "artifact": "io.netty:netty-buffer:4.1.110.Final",
        "sha256": "46d74e79125aacc055c31f18152fdc5d4a569aa8d60091203d0baa833973ac3c",
        "deps": [
            "@scala_proto_rules_netty_common",
        ],
    },
    "scala_proto_rules_netty_codec": {
        "artifact": "io.netty:netty-codec:4.1.110.Final",
        "sha256": "9eccce9a8d827bb8ce84f9c3183fec58bd1c96a51010cf711297746034af3701",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_transport",
        ],
    },
    "scala_proto_rules_netty_codec_http": {
        "artifact": "io.netty:netty-codec-http:4.1.110.Final",
        "sha256": "dc0d6af5054630a70ff0ef354f20aa7a6e46738c9fc5636ed3d4fe77e38bd48d",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_codec",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_handler",
            "@scala_proto_rules_netty_transport",
        ],
    },
    "scala_proto_rules_netty_codec_http2": {
        "artifact": "io.netty:netty-codec-http2:4.1.110.Final",
        "sha256": "b546c75445a487bb7bcd5a94779caecce33582cf7be31b8b39fc0e65b1ee26fc",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_codec",
            "@scala_proto_rules_netty_codec_http",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_handler",
            "@scala_proto_rules_netty_transport",
        ],
    },
    "scala_proto_rules_netty_codec_socks": {
        "artifact": "io.netty:netty-codec-socks:4.1.110.Final",
        "sha256": "976052a3c9bb280bc6d99f3a29e6404677cf958c3de05b205093d38c006b880c",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_codec",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_transport",
        ],
    },
    "scala_proto_rules_netty_common": {
        "artifact": "io.netty:netty-common:4.1.110.Final",
        "sha256": "9851ec66548b9e0d41164ce98943cdd4bbe305f68ddbd24eae52e4501a0d7b1a",
    },
    "scala_proto_rules_netty_handler": {
        "artifact": "io.netty:netty-handler:4.1.110.Final",
        "sha256": "d5a08d7de364912e4285968de4d4cce3f01da4bb048d5c6937e5f2af1f8e148a",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_codec",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_resolver",
            "@scala_proto_rules_netty_transport",
            "@scala_proto_rules_netty_transport_native_unix_common",
        ],
    },
    "scala_proto_rules_netty_handler_proxy": {
        "artifact": "io.netty:netty-handler-proxy:4.1.110.Final",
        "sha256": "ad54ab4fe9c47ef3e723d71251126db53e8db543871adb9eafc94446539eff52",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_codec",
            "@scala_proto_rules_netty_codec_http",
            "@scala_proto_rules_netty_codec_socks",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_transport",
        ],
    },
    "scala_proto_rules_netty_resolver": {
        "artifact": "io.netty:netty-resolver:4.1.110.Final",
        "sha256": "a2e9b4ae7caa92fc5bd747e11d1dec20d81b18fc00959554302244ac5c56ce70",
        "deps": [
            "@scala_proto_rules_netty_common",
        ],
    },
    "scala_proto_rules_netty_transport": {
        "artifact": "io.netty:netty-transport:4.1.110.Final",
        "sha256": "a42dd68390ca14b4ff2d40628a096c76485b4adb7c19602d5289321a0669e704",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_resolver",
        ],
    },
    "scala_proto_rules_netty_transport_native_unix_common": {
        "artifact": "io.netty:netty-transport-native-unix-common:4.1.110.Final",
        "sha256": "51717bb7471141950390c6713a449fdb1054d07e60737ee7dda7083796cdee48",
        "deps": [
            "@scala_proto_rules_netty_buffer",
            "@scala_proto_rules_netty_common",
            "@scala_proto_rules_netty_transport",
        ],
    },
    "scala_proto_rules_opencensus_api": {
        "artifact": "io.opencensus:opencensus-api:0.22.1",
        "sha256": "62a0503ee81856ba66e3cde65dee3132facb723a4fa5191609c84ce4cad36127",
    },
    "scala_proto_rules_opencensus_contrib_grpc_metrics": {
        "artifact": "io.opencensus:opencensus-contrib-grpc-metrics:0.22.1",
        "sha256": "3f6f4d5bd332c516282583a01a7c940702608a49ed6e62eb87ef3b1d320d144b",
    },
    "scala_proto_rules_opencensus_impl": {
        "artifact": "io.opencensus:opencensus-impl:0.22.1",
        "sha256": "9e8b209da08d1f5db2b355e781b9b969b2e0dab934cc806e33f1ab3baed4f25a",
    },
    "scala_proto_rules_opencensus_impl_core": {
        "artifact": "io.opencensus:opencensus-impl-core:0.22.1",
        "sha256": "04607d100e34bacdb38f93c571c5b7c642a1a6d873191e25d49899668514db68",
    },
    "scala_proto_rules_perfmark_api": {
        "artifact": "io.perfmark:perfmark-api:0.27.0",
        "sha256": "c7b478503ec524e55df19b424d46d27c8a68aeb801664fadd4f069b71f52d0f6",
    },
    "scala_proto_rules_proto_google_common_protos": {
        "artifact": "com.google.api.grpc:proto-google-common-protos:2.48.0",
        "sha256": "43ec7807459aaa4012e838a1be4ef2d590cf233305da60af5b54f08ec8cf2302",
        "deps": [
            "@com_google_protobuf_protobuf_java",
        ],
    },
    "scala_proto_rules_scalapb_compilerplugin": {
        "artifact": "com.thesamet.scalapb:compilerplugin_2.13:0.11.17",
        "sha256": "d36b84059289c7aa2f2bf08eeab7e85084fcf72bf58b337edf167c73218880d7",
        "deps": [
            "@com_google_protobuf_protobuf_java",
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
            "@scala_proto_rules_scalapb_protoc_gen",
        ],
    },
    "scala_proto_rules_scalapb_lenses": {
        "artifact": "com.thesamet.scalapb:lenses_2.13:0.11.17",
        "sha256": "4abe3fe573b8505a633414b0fbbcae4240250690ba48a9d4a6eeb3dfc3302ddf",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
        ],
    },
    "scala_proto_rules_scalapb_protoc_bridge": {
        "artifact": "com.thesamet.scalapb:protoc-bridge_2.13:0.9.8",
        "sha256": "0b3827da2cd9bca867d6963c2a821e7eaff41f5ac3babf671c4c00408bd14a9b",
        "deps": [
            "@dev_dirs_directories",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "scala_proto_rules_scalapb_protoc_gen": {
        "artifact": "com.thesamet.scalapb:protoc-gen_2.13:0.9.8",
        "sha256": "cf2b50721952cb4f10ca05a0ed36d7b01b88eb6505a9478556ee5a7af1a21775",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@scala_proto_rules_scalapb_protoc_bridge",
        ],
    },
    "scala_proto_rules_scalapb_runtime": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime_2.13:0.11.17",
        "sha256": "fe91faf58bccef68be348e76cab339a5fe2c215e48f7bd8f836190449ed94077",
        "deps": [
            "@com_google_protobuf_protobuf_java",
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
            "@scala_proto_rules_scalapb_lenses",
        ],
    },
    "scala_proto_rules_scalapb_runtime_grpc": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime-grpc_2.13:0.11.17",
        "sha256": "c03687c038f2a45bb413551519542069a59faf322de29fd1f9e06f2dd65003d0",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
            "@scala_proto_rules_grpc_protobuf",
            "@scala_proto_rules_grpc_stub",
            "@scala_proto_rules_scalapb_runtime",
        ],
    },
}
