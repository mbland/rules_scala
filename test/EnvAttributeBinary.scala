package scalarules.test

object EnvAttributeBinary {
  def main(args: Array[String]) {
    val envVars = Array(
      "LOCATION",
      "DATA_PATH",
      "BINDIR",
      "ESCAPED",
    )
    val env = System.getenv()

    for (envVar <- envVars) {
      println(envVar + ": " + env.get(envVar))
    }
  }
}
