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
    assertEquals("test/data/foo.txt", env.get("DATA_PATH"))
  }

  @Test
  def expandsMakeVariables: Unit = {
    val bindir = env.get("BINDIR")

    if (! bindir.startsWith("bazel-out/")) {
      fail("BINDIR does not start with bazel-out/: " + bindir)
    }
  }

  @Test
  def doesNotExpandEscapedVariables: Unit = {
    assertEquals(
      "$(rootpath //test/data:foo.txt) $(BINDIR)",
      env.get("ESCAPED"),
    )
  }
}
