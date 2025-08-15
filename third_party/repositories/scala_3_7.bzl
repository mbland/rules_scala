"""Maven artifact repository metadata.

Mostly generated and updated by scripts/create_repository.py.
"""

scala_version = "3.7.2"

artifacts = {
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
        "artifact": "com.google.errorprone:error_prone_annotations:2.36.0",
        "sha256": "77440e270b0bc9a249903c5a076c36a722c4886ca4f42675f2903a1c53ed61a5",
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
        "artifact": "com.google.protobuf:protobuf-java:4.32.0",
        "sha256": "e902c91b454812b7d056b8d303a572733bf0587576ff157c1049116c9626241d",
    },
    "com_lihaoyi_fansi": {
        "artifact": "com.lihaoyi:fansi_2.13:0.5.0",
        "sha256": "fcae26580f7d6e72adbd6e5c504bb1715fbe3f5fb814d70e84bc5427a835e42c",
        "deps": [
            "@com_lihaoyi_sourcecode",
            "@io_bazel_rules_scala_scala_library_2",
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
        "artifact": "com.lihaoyi:geny_3:1.1.1",
        "sha256": "39658649f90b631a4fd63187724f16ba8a045e1b10a513528f34517fb2edf98b",
    },
    "com_lihaoyi_pprint": {
        "artifact": "com.lihaoyi:pprint_3:0.9.0",
        "sha256": "61afea0579ee81727b44cdd490d13bedeb57cb50ad437797fd9c8c9865d0b795",
        "deps": [
            "@com_lihaoyi_fansi",
            "@com_lihaoyi_sourcecode",
        ],
    },
    "com_lihaoyi_sourcecode": {
        "artifact": "com.lihaoyi:sourcecode_2.13:0.4.2",
        "sha256": "fbace2b994a7184f6b38ee98630be61f21948008a4a56cd83c7f86c1c1de743d",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "com_twitter__scalding_date": {
        "testonly": True,
        "artifact": "com.twitter:scalding-date_2.13:0.17.0",
        "sha256": "973a7198121cc8dac9eeb3f325c93c497fe3b682f68ba56e34c1b210af7b15b4",
    },
    "com_typesafe_config": {
        "artifact": "com.typesafe:config:1.4.3",
        "sha256": "8ada4c185ce72416712d63e0b5afdc5f009c0cdf405e5f26efecdf156aa5dfb6",
    },
    "dev_dirs_directories": {
        "artifact": "dev.dirs:directories:26",
        "sha256": "6d18fe25aa30b7e08b908cd21151d8f96e22965c640acd7751add9bbfe6137d4",
    },
    "io_bazel_rules_scala_failureaccess": {
        "artifact": "com.google.guava:failureaccess:1.0.3",
        "sha256": "cbfc3906b19b8f55dd7cfd6dfe0aa4532e834250d7f080bd8d211a3e246b59cb",
    },
    "io_bazel_rules_scala_guava": {
        "artifact": "com.google.guava:guava:33.4.8-jre",
        "sha256": "f3d7f57f67fd622f4d468dfdd692b3a5e3909246c28017ac3263405f0fe617ed",
        "deps": [
            "@com_google_errorprone_error_prone_annotations",
            "@com_google_j2objc_j2objc_annotations",
            "@io_bazel_rules_scala_failureaccess",
            "@org_jspecify_jspecify",
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
        "artifact": "org.specs2:specs2-common_3:jar:5.0.0-RC-21",
        "sha256": "bfbc91a136493483ed5d2beba7f48520e72b66a9987ebec5b8f0ca38bda02801",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_fp",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_core": {
        "artifact": "org.specs2:specs2-core_3:jar:5.0.0-RC-21",
        "sha256": "ad4197e181c5921e685ce30b38f8a536745c8f3728172df49f7be2256e675608",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_common",
            "@io_bazel_rules_scala_org_specs2_specs2_matcher",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_fp": {
        "artifact": "org.specs2:specs2-fp_3:jar:5.0.0-RC-21",
        "sha256": "60f26aa132decb52682bba7ce0355b0b749b1b5fe283ec8929b050bb794cc1b8",
    },
    "io_bazel_rules_scala_org_specs2_specs2_junit": {
        "artifact": "org.specs2:specs2-junit_3:jar:5.0.0-RC-21",
        "sha256": "7e8b2c8ab10e6ea1ee471fb0313ad4c81963f326aa66efc4a2f476815ac4f8d9",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_core",
        ],
    },
    "io_bazel_rules_scala_org_specs2_specs2_matcher": {
        "artifact": "org.specs2:specs2-matcher_3:jar:5.0.0-RC-21",
        "sha256": "e747c4f40f3a96bfec5ac4a4af7d6b8b8f6f74b2412513752730888f75050e0b",
        "deps": [
            "@io_bazel_rules_scala_org_specs2_specs2_common",
        ],
    },
    "io_bazel_rules_scala_scala_asm": {
        "artifact": "org.scala-lang.modules:scala-asm:9.8.0-scala-1",
        "sha256": "86af037580bdf9ce9c05f8b2afd734daf1a8564c38cd10ca5d08bf81508ad2e4",
    },
    "io_bazel_rules_scala_scala_compiler": {
        "artifact": "org.scala-lang:scala3-compiler_3:3.7.2",
        "sha256": "3ecbe87d6b0f8d86cccc8eb6ad83b62126ad714a4cc8eb00afa3e7b481518303",
        "deps": [
            "@io_bazel_rules_scala_scala_asm",
            "@io_bazel_rules_scala_scala_interfaces",
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_tasty_core",
            "@org_jline_jline_reader",
            "@org_jline_jline_terminal",
            "@org_jline_jline_terminal_jni",
            "@org_scala_sbt_compiler_interface",
        ],
    },
    "io_bazel_rules_scala_scala_compiler_2": {
        "artifact": "org.scala-lang:scala-compiler:2.13.16",
        "sha256": "f59982714591e321ba9c087af2c8666e2f5fb92b11a0cef72c2c5e9b342152d3",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@io_bazel_rules_scala_scala_reflect_2",
            "@io_github_java_diff_utils_java_diff_utils",
            "@org_jline_jline",
        ],
    },
    "io_bazel_rules_scala_scala_interfaces": {
        "artifact": "org.scala-lang:scala3-interfaces:3.7.2",
        "sha256": "d151e52bfcc44c071e32baaca73f2d73dc7eca3f942ec5ce16f221d1a7b69ef2",
    },
    "io_bazel_rules_scala_scala_library": {
        "artifact": "org.scala-lang:scala3-library_3:3.7.2",
        "sha256": "241209cceff9876f491865e683109d02f32cf90bdff5cc6c2034661f56145e95",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "io_bazel_rules_scala_scala_library_2": {
        "artifact": "org.scala-lang:scala-library:2.13.16",
        "sha256": "1ebb2b6f9e4eb4022497c19b1e1e825019c08514f962aaac197145f88ed730f1",
    },
    "io_bazel_rules_scala_scala_parallel_collections": {
        "artifact": "org.scala-lang.modules:scala-parallel-collections_2.13:1.2.0",
        "sha256": "4eae6e68cf44e9f709970355590ae981883edf6484608d747376a56cbb285432",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "io_bazel_rules_scala_scala_parser_combinators": {
        "artifact": "org.scala-lang.modules:scala-parser-combinators_2.13:1.1.2",
        "sha256": "5c285b72e6dc0a98e99ae0a1ceeb4027dab9adfa441844046bd3f19e0efdcb54",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "io_bazel_rules_scala_scala_reflect_2": {
        "artifact": "org.scala-lang:scala-reflect:2.13.16",
        "sha256": "fb49ccd9cac7464486ab993cda20a3c1569d8ef26f052e897577ad2a4970fb1d",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "io_bazel_rules_scala_scala_tasty_core": {
        "artifact": "org.scala-lang:tasty-core_3:3.7.2",
        "sha256": "125b791d4ddcf5a187afae1de5158067dfbbfe96f7eaea73400d97cc60e74ad1",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scala_xml": {
        "artifact": "org.scala-lang.modules:scala-xml_3:2.1.0",
        "sha256": "48f22343575f4b1d6550eecc42d4b7f0a0d30223c72f015d8d893feab4cbeecd",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scalactic": {
        "artifact": "org.scalactic:scalactic_3:3.2.19",
        "sha256": "26ef71a6d0993301d28d9693bada18ff81b373336b70368fcff01ed4eb4b958e",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
        ],
    },
    "io_bazel_rules_scala_scalatest": {
        "artifact": "org.scalatest:scalatest_3:3.2.19",
        "sha256": "cd886ba42615fe0d730dd57197e6ee53eeb062cfd0b4d8c5d9757c977c0fdcf8",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
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
        "artifact": "org.scalatest:scalatest-core_3:3.2.19",
        "sha256": "f6e3d38c2034a9cab7313f644d8a933bf1b5241ff35002cc76916a427a826223",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scala_xml",
            "@io_bazel_rules_scala_scalactic",
            "@io_bazel_rules_scala_scalatest_compatible",
        ],
    },
    "io_bazel_rules_scala_scalatest_diagrams": {
        "artifact": "org.scalatest:scalatest-diagrams_3:3.2.19",
        "sha256": "835acf8ec2cb0d39beb1052ee2139029fdac28d172fc867db89ff49d640b255e",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_featurespec": {
        "artifact": "org.scalatest:scalatest-featurespec_3:3.2.19",
        "sha256": "3d49deeede2cd01578e037065862d7734afd3a6330c35dc3c4906f53f57302db",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_flatspec": {
        "artifact": "org.scalatest:scalatest-flatspec_3:3.2.19",
        "sha256": "85a6fb2285f20445615c6780a498c3bca99e4c2aad32fab6f74202bdc61e56a9",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_freespec": {
        "artifact": "org.scalatest:scalatest-freespec_3:3.2.19",
        "sha256": "ebc8573874766368316366495dcdfe0cca6d8082dc9cc08b5a2fd0834cdaecc0",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_funspec": {
        "artifact": "org.scalatest:scalatest-funspec_3:3.2.19",
        "sha256": "872b6889fac777aa813d21fb5f1e89710407785a61eb18a570142b6be10389a7",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_funsuite": {
        "artifact": "org.scalatest:scalatest-funsuite_3:3.2.19",
        "sha256": "42129cc156bd8978d9a438abd57001fc42ababf18f6178cbee91d0a9489334e0",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_matchers_core": {
        "artifact": "org.scalatest:scalatest-matchers-core_3:3.2.19",
        "sha256": "723fecdf0ea4542947ef5174068c4e05cd2145a3dcb6ffc797079368c94a187e",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_mustmatchers": {
        "artifact": "org.scalatest:scalatest-mustmatchers_3:3.2.19",
        "sha256": "837f76b73ff299fb6748ba0aff4eb7c9d9c00252741ad2bc15af3998d2e0558c",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_matchers_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_propspec": {
        "artifact": "org.scalatest:scalatest-propspec_3:3.2.19",
        "sha256": "6b033e73f3a53717a32a0d4d35ae2021a0afe8a028c42da62fb937932934bce3",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_refspec": {
        "artifact": "org.scalatest:scalatest-refspec_3:3.2.19",
        "sha256": "827b78a65c25a1dc4af747a7711e24c785fae92c39600fd357a7d486fcce2e7a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_shouldmatchers": {
        "artifact": "org.scalatest:scalatest-shouldmatchers_3:3.2.19",
        "sha256": "76ddce37f710ea96bdb3eebcb4bb0a0125fc70fb2ebaa7cc74c9bd28284b6a23",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@io_bazel_rules_scala_scalatest_matchers_core",
        ],
    },
    "io_bazel_rules_scala_scalatest_wordspec": {
        "artifact": "org.scalatest:scalatest-wordspec_3:3.2.19",
        "sha256": "c6acce0958b086cb857c4da6107f903b6166a46dfa251f54d3a0869212e229c7",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
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
        "artifact": "io.github.java-diff-utils:java-diff-utils:4.15",
        "sha256": "964c69e3a23a892db2778ae6806aa1d42f81230032bd8e4982dc8620582ee6b7",
    },
    "libthrift": {
        "artifact": "org.apache.thrift:libthrift:0.8.0",
        "sha256": "adea029247c3f16e55e29c1708b897812fd1fe335ac55fe3903e5d2f428ef4b3",
    },
    "net_java_dev_jna_jna": {
        "artifact": "net.java.dev.jna:jna:5.17.0",
        "sha256": "b3a9408e7c51e08ef0e3bfcc08f443f6ec0f6191ba8cd7c18d53d2b22e5bdbc0",
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
        "artifact": "org.jline:jline:jar:jdk8:3.30.5",
        "sha256": "dfcd5a6229332286407912ac8ec9380dabc160a9effa01f583eb565654f728ff",
    },
    "org_jline_jline_native": {
        "artifact": "org.jline:jline-native:3.30.5",
        "sha256": "cd1eba2f366b695cb39294538433a946bb9c662685ed4f134c78b5ba0cacca74",
    },
    "org_jline_jline_reader": {
        "artifact": "org.jline:jline-reader:3.30.5",
        "sha256": "e023c683023c7e5692530364fde63d20c4597cf5ef7dcd7c6f6541e5aeb81c16",
        "deps": [
            "@org_jline_jline_terminal",
        ],
    },
    "org_jline_jline_terminal": {
        "artifact": "org.jline:jline-terminal:3.30.5",
        "sha256": "4e871b40d2ce03bbb1f8713d6a3a268bf66c82164529756e8223f0e311a8ed96",
        "deps": [
            "@org_jline_jline_native",
        ],
    },
    "org_jline_jline_terminal_jna": {
        "artifact": "org.jline:jline-terminal-jna:3.30.5",
        "sha256": "60e8720d7fc866fa51f01256771a6daae79cd622e097f838caec1e2dbce3cf31",
        "deps": [
            "@net_java_dev_jna_jna",
            "@org_jline_jline_terminal",
        ],
    },
    "org_jline_jline_terminal_jni": {
        "artifact": "org.jline:jline-terminal-jni:3.30.5",
        "sha256": "73929d2331cb72fcb35b18b05ef740150cdc5cc18e414677685635c15b71e500",
        "deps": [
            "@org_jline_jline_native",
            "@org_jline_jline_terminal",
        ],
    },
    "org_jspecify_jspecify": {
        "artifact": "org.jspecify:jspecify:1.0.0",
        "sha256": "1fad6e6be7557781e4d33729d49ae1cdc8fdda6fe477bb0cc68ce351eafdfbab",
    },
    "org_scala_lang_modules_scala_collection_compat": {
        "artifact": "org.scala-lang.modules:scala-collection-compat_2.13:2.13.0",
        "sha256": "40f141575b57796bf0c1e4b5f0974d91e3a6dee6ecea47ceed62c0efa1298234",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "org_scala_lang_scalap": {
        "artifact": "org.scala-lang:scalap:2.13.16",
        "sha256": "7963c72c4c74d52278e42b0108ae8ae866d4d1c4579e20209a2f9617e6aacfca",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler_2",
        ],
    },
    "org_scala_sbt_compiler_interface": {
        "artifact": "org.scala-sbt:compiler-interface:1.10.8",
        "sha256": "b7569d4e2513391c11d14561013923841a6d7ece3b1d556bb054c3e3cc9d28e9",
        "deps": [
            "@org_scala_sbt_util_interface",
        ],
    },
    "org_scala_sbt_util_interface": {
        "artifact": "org.scala-sbt:util-interface:1.11.4",
        "sha256": "9b89874d8ebb00a7798ba8cbf8a1bcf4fc3f5934543ad4eae12b136d27c160ea",
    },
    "org_scalameta_common": {
        "artifact": "org.scalameta:common_2.13:4.13.9",
        "sha256": "14979d0e1bfc001070114b7fa74d1df3425bc22a6c115f6e9810cff34c48db69",
        "deps": [
            "@com_lihaoyi_sourcecode",
            "@io_bazel_rules_scala_scala_library_2",
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
    "org_scalameta_io": {
        "artifact": "org.scalameta:io_2.13:4.13.9",
        "sha256": "259b68fcc1a8138a1460e74574d2691bb89b7c93723a87a3afd2ff58187c063b",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "org_scalameta_mdoc_parser": {
        "artifact": "org.scalameta:mdoc-parser_2.13:2.6.4",
        "sha256": "d1462cf777c227a9a751ae9aae3cb7ab7c3fc1f70689f35eafe58746e33566cc",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "org_scalameta_metaconfig_core": {
        "artifact": "org.scalameta:metaconfig-core_2.13:0.15.0",
        "sha256": "c0b789c2d4468238fc325ef0a17f1a029b3635ff12b510bde03dd577a1281278",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@io_bazel_rules_scala_scala_reflect_2",
            "@org_scala_lang_modules_scala_collection_compat",
            "@org_scalameta_metaconfig_pprint",
            "@org_typelevel_paiges_core",
        ],
    },
    "org_scalameta_metaconfig_pprint": {
        "artifact": "org.scalameta:metaconfig-pprint_2.13:0.15.0",
        "sha256": "357e65682c00db62978f0dd21fea01f13a5f0fb31b45308ad74b136b1ec4f021",
        "deps": [
            "@com_lihaoyi_fansi",
            "@io_bazel_rules_scala_scala_compiler_2",
            "@io_bazel_rules_scala_scala_library_2",
            "@io_bazel_rules_scala_scala_reflect_2",
        ],
    },
    "org_scalameta_metaconfig_typesafe_config": {
        "artifact": "org.scalameta:metaconfig-typesafe-config_2.13:0.15.0",
        "sha256": "2ae5a8ecba43fb809696e419f1f98739e419534cc25918e2d8949a2d2727327e",
        "deps": [
            "@com_typesafe_config",
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scalameta_metaconfig_core",
        ],
    },
    "org_scalameta_parsers": {
        "artifact": "org.scalameta:parsers_2.13:4.13.9",
        "sha256": "c882279263ff0221049ca52c58b707e1cc7d7e91387d6e31a59b3d53870955a3",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scalameta_trees",
        ],
    },
    "org_scalameta_scalafmt_config": {
        "artifact": "org.scalameta:scalafmt-config_2.13:3.9.9",
        "sha256": "c3b40339a52c44bf6364c081ea079d283733556fe94f95d23d881ca811521352",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scalameta_metaconfig_core",
            "@org_scalameta_metaconfig_typesafe_config",
        ],
    },
    "org_scalameta_scalafmt_core": {
        "artifact": "org.scalameta:scalafmt-core_2.13:3.9.9",
        "sha256": "a943ed40928c0146cb5b3751f1cb5958f6581b09859eb477a3fae59e4b4fda73",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scalameta_mdoc_parser",
            "@org_scalameta_scalafmt_config",
            "@org_scalameta_scalafmt_macros",
            "@org_scalameta_scalafmt_sysops",
        ],
    },
    "org_scalameta_scalafmt_macros": {
        "artifact": "org.scalameta:scalafmt-macros_2.13:3.9.9",
        "sha256": "363fb96be632f5a0fc19c79401300e13381947382c7854da780fed2ad7f13433",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@io_bazel_rules_scala_scala_reflect_2",
            "@org_scalameta_scalameta",
        ],
    },
    "org_scalameta_scalafmt_sysops": {
        "artifact": "org.scalameta:scalafmt-sysops_2.13:3.9.9",
        "sha256": "ebbd33adb038a7a97ec2724ef634443596b23899b476725fd2b881ba463d4bca",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "org_scalameta_scalameta": {
        "artifact": "org.scalameta:scalameta_2.13:4.13.9",
        "sha256": "4cb2268018d01648953d9818882b35cb0722d6e2dadbe09c6670e1e8065ea784",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scalameta_parsers",
        ],
    },
    "org_scalameta_trees": {
        "artifact": "org.scalameta:trees_2.13:4.13.9",
        "sha256": "d293bf99287edc442bfc4305c7388ce35f60c65a3c8143d9e7d6f736c6c1ec3d",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@org_scalameta_common",
            "@org_scalameta_io",
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
        "artifact": "org.typelevel:cats-core_3:jar:2.7.0",
        "sha256": "6f3e17cb666886b7f21998e981ebf45966fe951898f851437a518a93cab667bd",
    },
    "org_typelevel_kind_projector": {
        "artifact": "org.typelevel:kind-projector_2.13.16:0.13.3",
        "sha256": "569fec54deba82cd143f05a6a0456c9e3bf56bff310b0968f0adb5fb3b352d92",
        "deps": [
            "@io_bazel_rules_scala_scala_compiler_2",
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "org_typelevel_paiges_core": {
        "artifact": "org.typelevel:paiges-core_2.13:0.4.4",
        "sha256": "ffbd59d3648e71c5b8f4474a54121fb3512707e7901245831669aa9e85f3bbf0",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "scala_proto_rules_disruptor": {
        "artifact": "com.lmax:disruptor:3.4.2",
        "sha256": "f412ecbb235c2460b45e63584109723dea8d94b819c78c9bfc38f50cba8546c0",
    },
    "scala_proto_rules_grpc_api": {
        "artifact": "io.grpc:grpc-api:1.74.0",
        "sha256": "7c2c39b76fd50ea4f58a7f4c12e82640e355fc92ca025be48072be1bcc2b177d",
        "deps": [
            "@com_google_code_findbugs_jsr305",
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
        ],
    },
    "scala_proto_rules_grpc_context": {
        "artifact": "io.grpc:grpc-context:1.74.0",
        "sha256": "fec0773020404a1f9b9610168692c8ed47fb77181c2ba37cc842ba7664bfc6b0",
        "deps": [
            "@scala_proto_rules_grpc_api",
        ],
    },
    "scala_proto_rules_grpc_core": {
        "artifact": "io.grpc:grpc-core:1.74.0",
        "sha256": "5175e6223ee1f0a63cf93049aabe7bd5b675cc739b286fe3b320a88fa90c320e",
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
        "artifact": "io.grpc:grpc-netty:1.74.0",
        "sha256": "8ead962173ff44752a1970b6e567225e1e9aeebb5c74af1e33e7786a45c9d620",
        "deps": [
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
            "@org_codehaus_mojo_animal_sniffer_annotations",
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
        "artifact": "io.grpc:grpc-protobuf:1.74.0",
        "sha256": "08cc7cf406d027aebf2fcb464fa82f4387c8f3e96e96900257dfa251efcce4f4",
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
        "artifact": "io.grpc:grpc-protobuf-lite:1.74.0",
        "sha256": "35182fb1225394856b738a91e414acd247e220dd90e6ca88853d9c0c6f9f4bd6",
        "deps": [
            "@com_google_code_findbugs_jsr305",
            "@io_bazel_rules_scala_guava",
            "@scala_proto_rules_grpc_api",
        ],
    },
    "scala_proto_rules_grpc_stub": {
        "artifact": "io.grpc:grpc-stub:1.74.0",
        "sha256": "5e5557b7d72a20f12e05b05ad1b4473efb3375daa36e5289a3954c200a67f284",
        "deps": [
            "@com_google_errorprone_error_prone_annotations",
            "@io_bazel_rules_scala_guava",
            "@org_codehaus_mojo_animal_sniffer_annotations",
            "@scala_proto_rules_grpc_api",
        ],
    },
    "scala_proto_rules_grpc_util": {
        "artifact": "io.grpc:grpc-util:1.74.0",
        "sha256": "296dc07438c43454afc1a7f2736086550feb1fc783f9547337ad2ae721e24350",
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
        "artifact": "com.google.api.grpc:proto-google-common-protos:2.60.0",
        "sha256": "6655d67f916b4afebc8096c9a311b75a9cbcc1327ff2660681f7de8802d541e9",
        "deps": [
            "@com_google_protobuf_protobuf_java",
        ],
    },
    "scala_proto_rules_scalapb_compilerplugin": {
        "artifact": "com.thesamet.scalapb:compilerplugin_3:1.0.0-alpha.1",
        "sha256": "e7d7156269fc23cbb539eea60f07c3230aa05a726434fc942b040495567f0a2d",
        "deps": [
            "@com_google_protobuf_protobuf_java",
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
            "@scala_proto_rules_scalapb_protoc_gen",
        ],
    },
    "scala_proto_rules_scalapb_lenses": {
        "artifact": "com.thesamet.scalapb:lenses_3:1.0.0-alpha.1",
        "sha256": "63fdffc573947402c526c49cf6ee92990ede88d55eb56af5123dfd247b365185",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
        ],
    },
    "scala_proto_rules_scalapb_protoc_bridge": {
        "artifact": "com.thesamet.scalapb:protoc-bridge_2.13:0.9.9",
        "sha256": "d3b70d7ef67e9186d25b10898b115d27bf2ccf53e9f3d136404420d2ec52ed66",
        "deps": [
            "@dev_dirs_directories",
            "@io_bazel_rules_scala_scala_library_2",
        ],
    },
    "scala_proto_rules_scalapb_protoc_gen": {
        "artifact": "com.thesamet.scalapb:protoc-gen_2.13:0.9.9",
        "sha256": "0adb3cedd175aa703d06aa58c914e3876a6e88613a63eb83d3e2a74592f1ba1b",
        "deps": [
            "@io_bazel_rules_scala_scala_library_2",
            "@scala_proto_rules_scalapb_protoc_bridge",
        ],
    },
    "scala_proto_rules_scalapb_runtime": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime_3:1.0.0-alpha.1",
        "sha256": "37ec7d72d56f58e3adb78e385e39ecb927a5097e290f4e51332bbd55fc534a65",
        "deps": [
            "@com_google_protobuf_protobuf_java",
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
            "@scala_proto_rules_scalapb_lenses",
        ],
    },
    "scala_proto_rules_scalapb_runtime_grpc": {
        "artifact": "com.thesamet.scalapb:scalapb-runtime-grpc_3:1.0.0-alpha.1",
        "sha256": "0c8574f91693cb08795ed16a601bcf6d5ba46ba8dbd71792910b706cce995c7a",
        "deps": [
            "@io_bazel_rules_scala_scala_library",
            "@org_scala_lang_modules_scala_collection_compat",
            "@scala_proto_rules_grpc_protobuf",
            "@scala_proto_rules_grpc_stub",
            "@scala_proto_rules_scalapb_runtime",
        ],
    },
}
