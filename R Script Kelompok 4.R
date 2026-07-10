# ================================================================
# Dashboard Analisis Data Kategorik Universal
# Final Project Komputasi Statistika
# ================================================================

required_packages <- c("shiny", "bs4Dash", "bslib", "DT", "plotly", "shinycssloaders")
package_errors <- vapply(required_packages, function(pkg) {
  tryCatch({
    loadNamespace(pkg)
    NA_character_
  }, error = function(e) conditionMessage(e))
}, character(1))
package_errors <- package_errors[!is.na(package_errors)]
if (length(package_errors) > 0) {
  stop(
    "Ada package yang belum siap dimuat:\n",
    paste(names(package_errors), ":", package_errors, collapse = "\n"),
    "\n\nJalankan install.packages() untuk package tersebut, lalu restart RStudio sebelum menjalankan app.",
    call. = FALSE
  )
}

library(shiny)
library(bs4Dash)
library(bslib)
library(DT)
library(plotly)
library(shinycssloaders)

options(shiny.sanitize.errors = FALSE)

alpha_default <- 0.05
