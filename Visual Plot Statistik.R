static_png_plot <- function(filename, mat, stats, plot_id) {
  grDevices::png(filename, width = 1200, height = 800, res = 140)
  oldpar <- par(no.readonly = TRUE)
  on.exit({
    par(oldpar)
    grDevices::dev.off()
  }, add = TRUE)
  if (plot_id == "grouped") {
    barplot(t(mat), beside = TRUE, legend.text = colnames(mat), col = c("#8f7cf6", "#60c6a8", "#ffbe7b", "#4fb7d8"), main = "Grouped Bar Chart", ylab = "Frekuensi")
  } else if (plot_id == "stacked") {
    barplot(t(mat), beside = FALSE, legend.text = colnames(mat), col = c("#8f7cf6", "#60c6a8", "#ffbe7b", "#4fb7d8"), main = "Stacked Bar Chart", ylab = "Frekuensi")
  } else if (plot_id == "stacked100") {
    barplot(t(prop.table(mat, 1)), beside = FALSE, legend.text = colnames(mat), col = c("#8f7cf6", "#60c6a8", "#ffbe7b", "#4fb7d8"), main = "100% Stacked Bar Chart", ylab = "Proporsi")
  } else if (plot_id == "mosaic") {
    mosaicplot(mat, color = TRUE, main = "Mosaic Plot")
  } else if (plot_id == "heatfreq") {
    image(t(mat[nrow(mat):1, ]), axes = FALSE, col = hcl.colors(20, "Blues"), main = "Heatmap Frekuensi")
    axis(1, at = seq(0, 1, length.out = ncol(mat)), labels = colnames(mat))
    axis(2, at = seq(0, 1, length.out = nrow(mat)), labels = rev(rownames(mat)))
  } else if (plot_id == "heatprop") {
    prop <- mat / sum(mat)
    image(t(prop[nrow(prop):1, ]), axes = FALSE, col = hcl.colors(20, "Greens"), main = "Heatmap Proporsi")
    axis(1, at = seq(0, 1, length.out = ncol(mat)), labels = colnames(mat))
    axis(2, at = seq(0, 1, length.out = nrow(mat)), labels = rev(rownames(mat)))
  } else if (plot_id == "residual") {
    image(t(stats$residual[nrow(stats$residual):1, ]), axes = FALSE, col = hcl.colors(20, "RdBu"), main = "Residual Plot")
    axis(1, at = seq(0, 1, length.out = ncol(mat)), labels = colnames(mat))
    axis(2, at = seq(0, 1, length.out = nrow(mat)), labels = rev(rownames(mat)))
  } else {
    df <- long_table(stats$residual, "Residual")
    barplot(df$Residual, names.arg = paste(df$Baris, df$Kolom, sep = "\n"), col = ifelse(df$Residual >= 0, "#60c6a8", "#ff9f8a"), las = 2, main = "Association Plot", ylab = "Standardized residual")
  }
}
