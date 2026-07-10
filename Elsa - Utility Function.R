make_datatable <- function(x, caption = NULL, digits = 4, rownames = TRUE) {
  x <- as.data.frame(x, check.names = FALSE)
  num_cols <- vapply(x, is.numeric, logical(1))
  x[num_cols] <- lapply(x[num_cols], function(v) round(v, digits))
  DT::datatable(
    x,
    rownames = rownames,
    caption = caption,
    options = list(pageLength = 8, dom = "tip", scrollX = TRUE),
    class = "stripe hover compact"
  )
}

safe_matrix_table <- function(mat, row_labels = rownames(mat), col_labels = colnames(mat)) {
  mat <- as.matrix(mat)
  storage.mode(mat) <- "numeric"
  rownames(mat) <- make.unique(as.character(row_labels))
  colnames(mat) <- make.unique(as.character(col_labels))
  mat
}
