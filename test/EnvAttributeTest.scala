package scalarules.test

import org.scalatest.flatspec._

class EnvAttributeTest extends AnyFlatSpec {
  var env = System.getenv()

  "the env attribute" should "contain a plain value" in {
    assert(env.get("LOCATION") == "West of House")
  }

  "the env attribute" should "expand location variables" in {
    assert(env.get("DATA_PATH") == "test/data/foo.txt")
  }

  "the env attribute" should "expand Make variables" in {
    assert(env.get("BINDIR").startsWith("bazel-out"))
  }

  "the env attribute" should "not expand escaped variables" in {
    assert(env.get("ESCAPED") == "$(rootpath //test/data:foo.txt) $(BINDIR)")
  }
}
