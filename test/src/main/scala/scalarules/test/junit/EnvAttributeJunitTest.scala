package scalarules.test.junit

import org.junit.Assert.assertEquals
import org.junit.Assert.fail
import org.junit.Test

class EnvAttributeJunitTest {
  val env = System.getenv()

  @Test
  def plainValueRemainsUnchanged: Unit = {
    assertEquals("West of House", env.get("LOCATION"))
  }

  @Test
  def expandsLocationVariables: Unit = {
    assertEquals("in DATA_PATH", "test/data/foo.txt", env.get("DATA_PATH"))
    assertEquals("in DEP_PATH", "test/HelloLib.jar", env.get("DEP_PATH"))
    assertEquals(
      "in SRC_PATH",
      "test/src/main/scala/scalarules/test/junit/EnvAttributeJunitTest.scala",
      env.get("SRC_PATH"),
    )
  }

  @Test
  def expandsMakeVariables: Unit = {
    val bindir = env.get("BINDIR")

    if (! bindir.startsWith("bazel-out/")) {
      fail("BINDIR does not start with bazel-out/: " + bindir)
    }
  }

  @Test
  def expandsToolchainSuppliedVariables: Unit = {
    assertEquals("bazquux", env.get("FROM_TOOLCHAIN_VAR"))
  }

  @Test
  def doesNotExpandEscapedVariables: Unit = {
    assertEquals(
      "$(rootpath //test/data:foo.txt) $(BINDIR) $UNKNOWN",
      env.get("ESCAPED"),
    )
  }
}
