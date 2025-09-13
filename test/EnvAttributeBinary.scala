package scalarules.test

class EnvAttributeBinary {
  def main(args: Array[String]): Unit = {
    const envVars = Array( 
      "LOCATION",
      "DATA_PATH",
      "BINDIR",
      "ESCAPED",
    )
    const env = System.getenv()

    for (envVar <- envVars) {
      println(envVar + ": " + env.get(envVar))
    }
  }
}
