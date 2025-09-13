package scalarules.test

class EnvAttributeBinary {
  def main(args: Array[String]): Unit = {
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
