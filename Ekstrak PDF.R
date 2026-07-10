write_pdf_report <- function(file, data, stats) {
  mat <- data$matrix
  grDevices::pdf(file, width = 8.27, height = 11.69)
  on.exit(grDevices::dev.off(), add = TRUE)
  plot.new()
  text(0, 0.96, "Laporan Analisis Data Kategorik", adj = 0, cex = 1.4, font = 2)
  lines <- c(
    paste("Sumber data:", data$format),
    paste("Variabel X:", data$variable_x),
    paste("Variabel Y:", data$variable_y),
    paste("Total observasi:", stats$n),
    paste("p-value Chi-square:", fmt_num(stats$chi$p.value)),
    paste("p-value Fisher:", fmt_num(if (is.null(stats$fisher)) NA_real_ else stats$fisher$p.value)),
    paste("Cramer's V:", fmt_num(stats$cramers_v)),
    paste("Kesimpulan:", relationship_text(stats$chi$p.value, stats$alpha), "antara", data$variable_x, "dan", data$variable_y)
  )
  text(0, 0.88, paste(lines, collapse = "\n"), adj = 0, cex = 0.9)
  plot.new()
  par(mar = c(7, 4, 4, 2))
  barplot(t(mat), beside = TRUE, legend.text = colnames(mat), col = c("#8f7cf6", "#60c6a8", "#ffbe7b", "#4fb7d8"), main = "Grouped Bar Chart", ylab = "Frekuensi", las = 2)
  plot.new()
  mosaicplot(mat, color = TRUE, main = "Mosaic Plot")
}
