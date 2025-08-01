"""Providers for Scalafmt rules"""

ScalafmtScriptInfo = provider(
    doc = "Info for generating Scalafmt script targets from Scalafmt targets",
    fields = {
        "manifest": "File mapping original source files to formatted files",
        "files": "Scalafmt formatted output files",
    },
)
