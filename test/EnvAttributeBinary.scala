package scalarules.test

object EnvAttributeBinary {
  def main(args: Array[String]) {
    val envVars = Array(
      "LOCATION",
      "DATA_PATH",
      "DEP_PATH",
      "SRC_PATH",
      "BINDIR",
      "FROM_TOOLCHAIN_VAR",
      "ESCAPED",
    )
    val env = System.getenv()

    for (envVar <- envVars) {
      println(envVar + ": " + env.get(envVar))
    }
  }
}
