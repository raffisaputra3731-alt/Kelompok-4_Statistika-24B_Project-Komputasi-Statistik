manual_to_data <- function(input) {
  row_labels <- c(safe_name(input$row1, "Baris 1"), safe_name(input$row2, "Baris 2"))
  col_labels <- c(safe_name(input$col1, "Kolom 1"), safe_name(input$col2, "Kolom 2"))
  validate(
    need(length(unique(row_labels)) == 2, "Label baris harus berbeda."),
    need(length(unique(col_labels)) == 2, "Label kolom harus berbeda.")
  )
  mat <- matrix(
    c(input$cell_a, input$cell_b, input$cell_c, input$cell_d),
    nrow = 2,
    byrow = TRUE,
    dimnames = list(row_labels, col_labels)
  )
  mat <- safe_matrix_table(mat, row_labels, col_labels)
  validate_counts(mat)
  cell_index <- expand.grid(
    X = row_labels,
    Y = col_labels,
    stringsAsFactors = FALSE
  )
  raw <- cell_index[rep(seq_len(nrow(cell_index)), as.vector(mat)), , drop = FALSE]
  names(raw) <- c(input$x_name %||% "Variabel X", input$y_name %||% "Variabel Y")
  list(
    matrix = mat,
    raw = raw,
    variable_x = safe_name(input$x_name, "Variabel X"),
    variable_y = safe_name(input$y_name, "Variabel Y"),
    format = "Input manual tabel 2x2",
    dataset_summary = list(
      n_observations = sum(mat),
      n_variables = 2,
      x_categories = nrow(mat),
      y_categories = ncol(mat),
      missing_values = 0
    )
  )
}
