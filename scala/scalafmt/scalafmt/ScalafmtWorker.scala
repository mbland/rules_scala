package io.bazel.rules_scala.scalafmt

import io.bazel.rulesscala.worker.Worker
import java.io.File
import java.nio.file.Files
import org.scalafmt.Scalafmt
import org.scalafmt.config.ScalafmtConfig
import org.scalafmt.sysops.FileOps
import scala.annotation.tailrec
import scala.io.Codec

object ScalafmtWorker extends Worker.Interface {

  def main(args: Array[String]): Unit = Worker.workerMain(args, ScalafmtWorker)

  def work(args: Array[String]): Unit = {
    val argName = List("config", "input", "output")
    val argFile = args.map{x => new File(x)}
    val namespace = argName.zip(argFile).toMap

    val source = FileOps.readFile(
      namespace.getOrElse("input", new File("")).toPath()
    )(Codec.UTF8)

    val config = ScalafmtConfig.fromHoconFile(
      namespace.getOrElse("config", new File("")).toPath()
    ).get

    @tailrec
    def format(code: String): String = {
      val formatted = Scalafmt.format(code, config).get
      if (code == formatted) code else format(formatted)
    }

    val output = try {
      format(source)
    } catch {
      case e @ (_: org.scalafmt.Error | _: scala.meta.parsers.ParseException) => {
        System.out.println("Unable to format file due to bug in scalafmt")
        System.out.println(e.toString)
        source
      }
    }

    Files.write(namespace.getOrElse("output", new File("")).toPath, output.getBytes)
  }
}
