scala_version = "2.12.20"

artifacts = {
    "io_bazel_rules_scala_scala_library": {
        "artifact": "org.scala-lang:scala-library:2.12.20",
        "sha256": "4d8a8f984cce31a329a24f10b0bf336f042cb62aeb435290a1b20243154cfccb",
    },
    "io_bazel_rules_scala_scala_compiler": {
        "artifact": "org.scala-lang:scala-compiler:2.12.20",
        "sha256": "c88676d75c69721b717ea6c441ece04fff262abab9d210a2936abc2be3731fa2",
        "deps": [
            "@io_bazel_rules_scala_scala_xml",
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
        ],
    },
    "io_bazel_rules_scala_scala_reflect": {
        "artifact": "org.scala-lang:scala-reflect:2.12.20",
        "sha256": "5f1914cdc7a70580ea6038d929ebb25736ecf2234f677e2d47f8a4b2bc81e1fb",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scalatest": {
        "artifact": "org.scalatest:scalatest_2.12:3.2.9",
        "sha256": "ed4a7e0a2373505ae5b9c4811fa2d2d167f5388556cdcb49bce11f27e18b90fa",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
            "@io_bazel_rules_scala_scalatest_featurespec",
            "@io_bazel_rules_scala_scalatest_flatspec",
            "@io_bazel_rules_scala_scalatest_freespec",
            "@io_bazel_rules_scala_scalatest_funspec",
            "@io_bazel_rules_scala_scalatest_funsuite",
            "@io_bazel_rules_scala_scalatest_matchers_core",
            "@io_bazel_rules_scala_scalatest_mustmatchers",
            "@io_bazel_rules_scala_scalatest_shouldmatchers",
        ],
    },
    "io_bazel_rules_scala_scalatest_compatible": {
        "artifact": "org.scalatest:scalatest-compatible:3.2.9",
        "sha256": "7e5f1193af2fd88c432c4b80ce3641e4b1d062f421d8a0fcc43af9a19bb7c2eb",
    },
    "io_bazel_rules_scala_scalatest_core": {
        "artifact": "org.scalatest:scalatest-core_2.12:3.2.9",
        "sha256": "8d5bc6b847caaf221fa42cc214dcd1c70fd758aef384a2b6498463db0caf8e3c",
        "deps": [
            "@io_bazel_rules_scala_scala_xml",
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalactic",
            "@io_bazel_rules_scala_scalatest_compatible",
        ],
    },
    "io_bazel_rules_scala_scalatest_featurespec": {
        "artifact": "org.scalatest:scalatest-featurespec_2.12:3.2.9",
        "sha256": "f68bd68cd1f9fc5ccc3bbb004bb843bf01481886952e96e909933960a3365d00",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_flatspec": {
        "artifact": "org.scalatest:scalatest-flatspec_2.12:3.2.9",
        "sha256": "bcec89594fda4fc4ffe3c98adaf8e9b7982011433d782b280fe54b6dc8b9f21f",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_freespec": {
        "artifact": "org.scalatest:scalatest-freespec_2.12:3.2.9",
        "sha256": "097d551509cbb472d2367ea1b2060b0a27e36bad45ce5828ae2062867b5e8299",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_funsuite": {
        "artifact": "org.scalatest:scalatest-funsuite_2.12:3.2.9",
        "sha256": "07b6eb20584bc684646dff58ac02019b97a74c2825644f09d514b7dd7cacf067",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_funspec": {
        "artifact": "org.scalatest:scalatest-funspec_2.12:3.2.9",
        "sha256": "3d4d5b6e79c4398d0ff71f1ad4843f7eaf2acd0d197d782ee5f2437eb214ccf1",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_matchers_core": {
        "artifact": "org.scalatest:scalatest-matchers-core_2.12:3.2.9",
        "sha256": "44e6bf24fb6fd4fd9419fcaf8d7e64b20c2916659f5d062d33f2de9a48ffdf09",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_shouldmatchers": {
        "artifact": "org.scalatest:scalatest-shouldmatchers_2.12:3.2.9",
        "sha256": "2fce7f0f8cbfbc1a3bc65807cf389b01599ee78af459071e679ba5ed4884b4e2",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_matchers_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_mustmatchers": {
        "artifact": "org.scalatest:scalatest-mustmatchers_2.12:3.2.9",
        "sha256": "e443fa6b4b741d1fb21c76ec204df39fec565ea817a3adb2b0b9be7c2a143041",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@io_bazel_rules_scala_scalatest_matchers_core",
        ],
    },
    "io_bazel_rules_scala_scalactic": {
        "artifact": "org.scalactic:scalactic_2.12:3.2.9",
        "sha256": "a5f01a0ecb7479b4f43e03147094279609d66fdaa04a9cb3238510d7c4dbc22a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
        ],
    },
    "io_bazel_rules_scala_scala_xml": {
        "artifact": "org.scala-lang.modules:scala-xml_2.12:2.3.0",
        "sha256": "4932c56a2d5aae77ae8d7ac6bed1f21d48268fdbac8b4e5f3ca5196ad10fd93e",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scala_parser_combinators": {
        "artifact": "org.scala-lang.modules:scala-parser-combinators_2.12:1.1.2",
        "sha256": "24985eb43e295a9dd77905ada307a850ca25acf819cdb579c093fc6987b0dbc2",
    },
    "org_scalameta_common": {
        "artifact": "org.scalameta:common_2.12:4.4.27",
        "sha256": "71c9d13df52d0f2169befbb078af37175c18f50456ebdf0410b99ebae0df3a9f",
        "deps": [
            "@com_lihaoyi_sourcecode",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_semanticdb_scalac": {
        "artifact": "org.scalameta:semanticdb-scalac_2.12.20:4.9.9",
        "sha256": "7f0e44262b2b1003668f2f51eb0f978ed5a4b94f734e3a6138ce9d7d1a40fc83",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_fastparse": {
        "artifact": "org.scalameta:fastparse-v2_2.12:2.3.1",
        "sha256": "c8ddc110da4b2e3d204e44b2629f4663edeb61094fa7ab4749f2f82b1b0cb026",
        "deps": [
            "@com_lihaoyi_geny",
            "@com_lihaoyi_sourcecode",
        ],
    },
    "org_scalameta_fastparse_utils": {
        "artifact": "org.scalameta:fastparse-utils_2.12:1.0.1",
        "sha256": "9d8ad97778ef9aedef5d4190879ed0ec54969e2fc951576fe18746ae6ce6cfcf",
        "deps": [
            "@com_lihaoyi_sourcecode",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "com_lihaoyi_geny": {
        "artifact": "com.lihaoyi:geny_2.12:0.6.5",
        "sha256": "9e81e90ab3e380192e04926d546418d825853de8efea12a7f94e0bd04c250419",
    },
    "org_scala_lang_modules_scala_collection_compat": {
        "artifact": "org.scala-lang.modules:scala-collection-compat_2.12:2.4.3",
        "sha256": "8499054aa4e490ae94703b2be653af954db5193e277673f17886bd2e57d16c90",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "org_scalameta_parsers": {
        "artifact": "org.scalameta:parsers_2.12:4.4.27",
        "sha256": "5c25dbb82d9c3cb206373297373be4014d3e189fe674a8b1fdb43d5ea5d5a963",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scalameta_trees",
        ],
    },
    "org_scalameta_scalafmt_core": {
        "artifact": "org.scalameta:scalafmt-core_2.12:3.0.0",
        "sha256": "8888f2a37d9ca0f10ff97d2eb2027c530e15e4a38aa2447e5b13d1ab3605339b",
        "deps": [
            "@com_geirsson_metaconfig_core",
            "@com_geirsson_metaconfig_typesafe_config",
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_reflect",
            "@org_scalameta_scalameta",
        ],
    },
    "org_scalameta_scalameta": {
        "artifact": "org.scalameta:scalameta_2.12:4.4.27",
        "sha256": "bd62786fcae33f46e1c981b1ff7bbf3934b5dc1916ddeba259a787759ba1afd9",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_scalap",
            "@org_scalameta_parsers",
        ],
    },
    "org_scalameta_trees": {
        "artifact": "org.scalameta:trees_2.12:4.4.27",
        "sha256": "bab0a348edcdbd56832fdc0b8ca5576a4aa25aa67c5365a5d74b86c8b15ac21c",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scalameta_common",
            "@org_scalameta_fastparse",
        ],
    },
    "org_typelevel_paiges_core": {
        "artifact": "org.typelevel:paiges-core_2.12:0.4.1",
        "sha256": "2a27d525fbf3274f1887b4d7af4b8e337c5b00c054c1e31f49640460c73dc947",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "com_typesafe_config": {
        "artifact": "com.typesafe:config:1.4.1",
        "sha256": "4c0aa7e223c75c8840c41fc183d4cd3118140a1ee503e3e08ce66ed2794c948f",
    },
    "org_scala_lang_scalap": {
        "artifact": "org.scala-lang:scalap:2.12.14",
        "sha256": "52c37b4e5a37146a9ce5e48b8fb2c39aa0ec7eb867c65708a5cdac786ac79f2a",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler",
        ],
    },
    "com_thesamet_scalapb_lenses": {
        "artifact": "com.thesamet.scalapb:lenses_2.12:0.9.0",
        "sha256": "0a2fff4de17d270cea561618090c21d50bc891d82c6f9dfccdc20568f18d0260",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "com_thesamet_scalapb_scalapb_runtime": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime_2.12:0.9.0",
        "sha256": "b905fa66b3fd0fabf3114105cd73ae2bdddbb6e13188a6538a92ae695e7ad6ed",
        "deps": [
            "@com_google_protobuf_protobuf_java",
            "@com_lihaoyi_fastparse",
            "@com_thesamet_scalapb_lenses",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "com_lihaoyi_fansi": {
        "artifact": "com.lihaoyi:fansi_2.12:0.2.12",
        "sha256": "c142f910ddbbc0370763d969095b4d94c945b394b96ff7d0943cf086b3c24249",
        "deps": [
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_fastparse": {
        "artifact": "com.lihaoyi:fastparse_2.12:2.1.2",
        "sha256": "92a98f89c4f9559715124599ee5ce8f0d36ee326f5c7ef88b51487de39a3602e",
        "deps": [
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_pprint": {
        "artifact": "com.lihaoyi:pprint_2.12:0.6.4",
        "sha256": "e357e0217c776f4bf2ff4d00aa66398aeecdc81f44803ed677eb5c832de758b0",
        "deps": [
            "@com_lihaoyi_fansi",
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_sourcecode": {
        "artifact": "com.lihaoyi:sourcecode_2.12:0.2.7",
        "sha256": "52a8e02b1c90de686994a5f9818987cec44c5df97118e4b59fe2414227099c6a",
    },
    "com_google_protobuf_protobuf_java": {
        "artifact": "com.google.protobuf:protobuf-java:4.28.2",
        "sha256": "707bccf406f4fc61b841d4700daa8d3e84db8ab499ef3481a060fa6a0f06e627",
    },
    "com_geirsson_metaconfig_core": {
        "artifact": "com.geirsson:metaconfig-core_2.12:0.9.14",
        "sha256": "5efc7a4c5c47df5001c21415ae4e6f37621d731c1895e606029b888728da73c6",
        "deps": [
            "@com_lihaoyi_pprint",
            "@org_scala_lang_modules_scala_collection_compat",
            "@io_bazel_rules_scala_scala_library",
            "@org_typelevel_paiges_core",
        ],
    },
    "com_geirsson_metaconfig_typesafe_config": {
        "artifact": "com.geirsson:metaconfig-typesafe-config_2.12:0.9.14",
        "sha256": "5962872d18d70de9df2bf969b449295b0f483870e6bd3f229f44a0578d83ce71",
        "deps": [
            "@com_geirsson_metaconfig_core",
            "@com_typesafe_config",
            "@io_bazel_rules_scala_scala_library",
        ],
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
    "io_bazel_rules_scala_org_ows2_asm_asm": {
        "artifact": "org.ow2.asm:asm:9.0",
        "sha256": "0df97574914aee92fd349d0cb4e00f3345d45b2c239e0bb50f0a90ead47888e0",
    },
    "io_bazel_rules_scala_net_sf_jopt_simple_jopt_simple": {
        "artifact": "net.sf.jopt-simple:jopt-simple:5.0.4",
        "sha256": "df26cc58f235f477db07f753ba5a3ab243ebe5789d9f89ecf68dd62ea9a66c28",
    },
    "io_bazel_rules_scala_org_apache_commons_commons_math3": {
        "artifact": "org.apache.commons:commons-math3:3.6.1",
        "sha256": "1e56d7b058d28b65abd256b8458e3885b674c1d588fa43cd7d1cbb9c7ef2b308",
    },
    "io_bazel_rules_scala_junit_junit": {
        "artifact": "junit:junit:4.12",
        "sha256": "59721f0805e223d84b90677887d9ff567dc534d7c502ca903c0c2b17f05c116a",
    },
    "io_bazel_rules_scala_org_hamcrest_hamcrest_core": {
        "artifact": "org.hamcrest:hamcrest-core:1.3",
        "sha256": "66fdef91e9739348df7a096aa384a5685f4e875584cce89386a7a47251c4d8e9",
    },
    "io_bazel_rules_scala_org_specs2_specs2_common": {
        "artifact": "org.specs2:specs2-common_2.12:4.4.1",
        "sha256": "7b7d2497bfe10ad552f5ab3780537c7db9961d0ae841098d5ebd91c78d09438a",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_fp",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_core": {
        "artifact": "org.specs2:specs2-core_2.12:4.4.1",
        "sha256": "f92c3c83844aac13250acec4eb247a2a26a2b3f04e79ef1bf42c56de4e0bb2e7",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_common",
            "@io_bazel_rules_scala_org_specs2_specs2_matcher",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_fp": {
        "artifact": "org.specs2:specs2-fp_2.12:4.4.1",
        "sha256": "834a145b28dbf57ba6d96f02a3862522e693b5aeec44d4cb2f305ef5617dc73f",
    },
    "io_bazel_rules_scala_org_specs2_specs2_matcher": {
        "artifact": "org.specs2:specs2-matcher_2.12:4.4.1",
        "sha256": "78c699001c307dcc5dcbec8a80cd9f14e9bdaa047579c3d1010ee4bea66805fe",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_common",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_junit": {
        "artifact": "org.specs2:specs2-junit_2.12:4.4.1",
        "sha256": "c867824801da5cccf75354da6d12d406009c435865ecd08a881b799790e9ffec",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_core",
        ],
    },
    "scala_proto_rules_scalapb_plugin": {
        "artifact": "com.thesamet.scalapb:compilerplugin_2.12:0.9.7",
        "sha256": "516ed567e2c3ac28b91a2f350d3febc7a6a396978718145f536853ffe8de40c2",
    },
    "scala_proto_rules_protoc_bridge": {
        "artifact": "com.thesamet.scalapb:protoc-bridge_2.12:0.7.14",
        "sha256": "2b8db0b71be5052768a96ccc41c9bb03f3f19e1e267e810a64963566538b1a2b",
    },
    "scala_proto_rules_scalapb_runtime": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime_2.12:0.9.7",
        "sha256": "82624a7fadaa323bbb8d33e37f055ce42e761c203573ace3ccf95bd0511917fe",
    },
    "scala_proto_rules_scalapb_runtime_grpc": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime-grpc_2.12:0.9.7",
        "sha256": "4c00f2a57cc1d00a2d454f695c3f1e565173e1d1297294f1cf81339bdeba3f4a",
    },
    "scala_proto_rules_scalapb_lenses": {
        "artifact": "com.thesamet.scalapb:lenses_2.12:0.9.7",
        "sha256": "fff4fc9d47ad44c1371ff2d8dfa2b5907826c4b98ca576baf67f14d31d0d9be1",
    },
    "scala_proto_rules_scalapb_fastparse": {
        "artifact": "com.lihaoyi:fastparse_2.12:2.1.3",
        "sha256": "e8b831a843c0eb5105d42e4b6febfc772b3aed3a853a899e6c8196e9ecc057df",
    },
    "scala_proto_rules_grpc_core": {
        "artifact": "io.grpc:grpc-core:1.24.0",
        "sha256": "8fc900625a9330b1c155b5423844d21be0a5574fe218a63170a16796c6f7880e",
    },
    "scala_proto_rules_grpc_api": {
        "artifact": "io.grpc:grpc-api:1.24.0",
        "sha256": "553978366e04ee8ddba64afde3b3cf2ac021a2f3c2db2831b6491d742b558598",
    },
    "scala_proto_rules_grpc_stub": {
        "artifact": "io.grpc:grpc-stub:1.24.0",
        "sha256": "eaa9201896a77a0822e26621b538c7154f00441a51c9b14dc9e1ec1f2acfb815",
    },
    "scala_proto_rules_grpc_protobuf": {
        "artifact": "io.grpc:grpc-protobuf:1.24.0",
        "sha256": "88cd0838ea32893d92cb214ea58908351854ed8de7730be07d5f7d19025dd0bc",
    },
    "scala_proto_rules_grpc_netty": {
        "artifact": "io.grpc:grpc-netty:1.24.0",
        "sha256": "8478333706ba442a354c2ddb8832d80a5aef71016e8a9cf07e7bf6e8c298f042",
    },
    "scala_proto_rules_grpc_context": {
        "artifact": "io.grpc:grpc-context:1.24.0",
        "sha256": "1f0546e18789f7445d1c5a157010a11bc038bbb31544cdb60d9da3848efcfeea",
    },
    "scala_proto_rules_perfmark_api": {
        "artifact": "io.perfmark:perfmark-api:0.17.0",
        "sha256": "816c11409b8a0c6c9ce1cda14bed526e7b4da0e772da67c5b7b88eefd41520f9",
    },
    "scala_proto_rules_guava": {
        "artifact": "com.google.guava:guava:26.0-android",
        "sha256": "1d044ebb866ef08b7d04e998b4260c9b52fab6e6d6b68d207859486bb3686cd5",
    },
    "scala_proto_rules_google_instrumentation": {
        "artifact": "com.google.instrumentation:instrumentation-api:0.3.0",
        "sha256": "671f7147487877f606af2c7e39399c8d178c492982827305d3b1c7f5b04f1145",
    },
    "scala_proto_rules_netty_codec": {
        "artifact": "io.netty:netty-codec:4.1.32.Final",
        "sha256": "dbd6cea7d7bf5a2604e87337cb67c9468730d599be56511ed0979aacb309f879",
    },
    "scala_proto_rules_netty_codec_http": {
        "artifact": "io.netty:netty-codec-http:4.1.32.Final",
        "sha256": "db2c22744f6a4950d1817e4e1a26692e53052c5d54abe6cceecd7df33f4eaac3",
    },
    "scala_proto_rules_netty_codec_socks": {
        "artifact": "io.netty:netty-codec-socks:4.1.32.Final",
        "sha256": "fe2f2e97d6c65dc280623dcfd24337d8a5c7377049c120842f2c59fb83d7408a",
    },
    "scala_proto_rules_netty_codec_http2": {
        "artifact": "io.netty:netty-codec-http2:4.1.32.Final",
        "sha256": "4d4c6cfc1f19efb969b9b0ae6cc977462d202867f7dcfee6e9069977e623a2f5",
    },
    "scala_proto_rules_netty_handler": {
        "artifact": "io.netty:netty-handler:4.1.32.Final",
        "sha256": "07d9756e48b5f6edc756e33e8b848fb27ff0b1ae087dab5addca6c6bf17cac2d",
    },
    "scala_proto_rules_netty_buffer": {
        "artifact": "io.netty:netty-buffer:4.1.32.Final",
        "sha256": "8ac0e30048636bd79ae205c4f9f5d7544290abd3a7ed39d8b6d97dfe3795afc1",
    },
    "scala_proto_rules_netty_transport": {
        "artifact": "io.netty:netty-transport:4.1.32.Final",
        "sha256": "175bae0d227d7932c0c965c983efbb3cf01f39abe934f5c4071d0319784715fb",
    },
    "scala_proto_rules_netty_resolver": {
        "artifact": "io.netty:netty-resolver:4.1.32.Final",
        "sha256": "9b4a19982047a95ea4791a7ad7ad385c7a08c2ac75f0a3509cc213cb32a726ae",
    },
    "scala_proto_rules_netty_common": {
        "artifact": "io.netty:netty-common:4.1.32.Final",
        "sha256": "cc993e660f8f8e3b033f1d25a9e2f70151666bdf878d460a6508cb23daa696dc",
    },
    "scala_proto_rules_netty_handler_proxy": {
        "artifact": "io.netty:netty-handler-proxy:4.1.32.Final",
        "sha256": "10d1081ed114bb0e76ebbb5331b66a6c3189cbdefdba232733fc9ca308a6ea34",
    },
    "scala_proto_rules_opencensus_api": {
        "artifact": "io.opencensus:opencensus-api:0.22.1",
        "sha256": "62a0503ee81856ba66e3cde65dee3132facb723a4fa5191609c84ce4cad36127",
    },
    "scala_proto_rules_opencensus_impl": {
        "artifact": "io.opencensus:opencensus-impl:0.22.1",
        "sha256": "9e8b209da08d1f5db2b355e781b9b969b2e0dab934cc806e33f1ab3baed4f25a",
    },
    "scala_proto_rules_disruptor": {
        "artifact": "com.lmax:disruptor:3.4.2",
        "sha256": "f412ecbb235c2460b45e63584109723dea8d94b819c78c9bfc38f50cba8546c0",
    },
    "scala_proto_rules_opencensus_impl_core": {
        "artifact": "io.opencensus:opencensus-impl-core:0.22.1",
        "sha256": "04607d100e34bacdb38f93c571c5b7c642a1a6d873191e25d49899668514db68",
    },
    "scala_proto_rules_opencensus_contrib_grpc_metrics": {
        "artifact": "io.opencensus:opencensus-contrib-grpc-metrics:0.22.1",
        "sha256": "3f6f4d5bd332c516282583a01a7c940702608a49ed6e62eb87ef3b1d320d144b",
    },
    "io_bazel_rules_scala_mustache": {
        "artifact": "com.github.spullara.mustache.java:compiler:0.8.18",
        "sha256": "ddabc1ef897fd72319a761d29525fd61be57dc25d04d825f863f83cc89000e66",
    },
    "io_bazel_rules_scala_guava": {
        "artifact": "com.google.guava:guava:21.0",
        "sha256": "972139718abc8a4893fa78cba8cf7b2c903f35c97aaf44fa3031b0669948b480",
    },
    "libthrift": {
        "artifact": "org.apache.thrift:libthrift:0.10.0",
        "sha256": "8591718c1884ac8001b4c5ca80f349c0a6deec691de0af720c5e3bc3a581dada",
    },
    "io_bazel_rules_scala_scrooge_core": {
        "artifact": "com.twitter:scrooge-core_2.12:21.2.0",
        "sha256": "1178f6cef63c9ad9e787ee7dbb26008d2a8cec9afee7629d0037c534d5b5d575",
    },
    "io_bazel_rules_scala_scrooge_generator": {
        "artifact": "com.twitter:scrooge-generator_2.12:21.2.0",
        "sha256": "ac5afecfd742ce07cf127b253df20ebf265d75d02d5f38bd8c683da194780862",
        "runtime_deps": [
            "@io_bazel_rules_scala_guava",
            "@io_bazel_rules_scala_mustache",
            "@io_bazel_rules_scala_scopt",
        ],
    },
    "io_bazel_rules_scala_util_core": {
        "artifact": "com.twitter:util-core_2.12:21.2.0",
        "sha256": "5d4ed75a26a3a2cc7fdc1dbeb29878a70024a8b7864287ed1e182dbca9c775a5",
    },
    "io_bazel_rules_scala_util_logging": {
        "artifact": "com.twitter:util-logging_2.12:21.2.0",
        "sha256": "6110ea70a1ea65c477cec72b7a2ce2ec92427e081ff9366272cb7c3bcadf69a9",
    },
    "io_bazel_rules_scala_javax_annotation_api": {
        "artifact": "javax.annotation:javax.annotation-api:1.3.2",
        "sha256": "e04ba5195bcd555dc95650f7cc614d151e4bcd52d29a10b8aa2197f3ab89ab9b",
    },
    "io_bazel_rules_scala_scopt": {
        "artifact": "com.github.scopt:scopt_2.12:4.0.0-RC2",
        "sha256": "d19a4e8b8c013a56e03bc57bdf87abe6297c974cf907585d00284eae61c6ac91",
    },
    "com_twitter__scalding_date": {
        "testonly": True,
        "artifact": "com.twitter:scalding-date_2.12:0.17.0",
        "sha256": "973a7198121cc8dac9eeb3f325c93c497fe3b682f68ba56e34c1b210af7b15b3",
    },
    "org_typelevel__cats_core": {
        "testonly": True,
        "artifact": "org.typelevel:cats-core_2.12:0.9.0",
        "sha256": "3ca705cba9dc0632e60477d80779006f8c636c0e2e229dda3410a0c314c1ea1d",
    },
    "com_google_guava_guava_21_0_with_file": {
        "testonly": True,
        "artifact": "com.google.guava:guava:21.0",
        "sha256": "972139718abc8a4893fa78cba8cf7b2c903f35c97aaf44fa3031b0669948b480",
    },
    "com_github_jnr_jffi_native": {
        "testonly": True,
        "artifact": "com.github.jnr:jffi:jar:native:1.2.17",
        "sha256": "4eb582bc99d96c8df92fc6f0f608fd123d278223982555ba16219bf8be9f75a9",
    },
    "org_apache_commons_commons_lang_3_5": {
        "testonly": True,
        "artifact": "org.apache.commons:commons-lang3:3.5",
        "sha256": "8ac96fc686512d777fca85e144f196cd7cfe0c0aec23127229497d1a38ff651c",
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
    "com_google_guava_guava_21_0": {
        "testonly": True,
        "artifact": "com.google.guava:guava:21.0",
        "sha256": "972139718abc8a4893fa78cba8cf7b2c903f35c97aaf44fa3031b0669948b480",
        "deps": [
            "@org_springframework_spring_core",
        ],
    },
    "org_typelevel_kind_projector": {
        "testonly": True,
        "artifact": "org.typelevel:kind-projector_2.12.20:0.13.3",
        "sha256": "98a53122dedd51f79f23ae03eae3258a2e5dbd51c647eaea4942f98c55b052d1",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler",
            "@io_bazel_rules_scala_scala_library",
        ],
    },
}
