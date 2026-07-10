long_table <- function(mat, value_name = "Nilai") {
  out <- expand.grid(
    Baris = rownames(mat),
    Kolom = colnames(mat),
    stringsAsFactors = FALSE
  )
  out[[value_name]] <- as.vector(mat)
  out
}
