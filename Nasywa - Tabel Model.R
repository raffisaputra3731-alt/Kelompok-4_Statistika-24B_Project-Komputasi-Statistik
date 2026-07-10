model_table <- function(stats) {
  if (is.null(stats$coef_table)) {
    return(data.frame(Pesan = "Regresi logistik hanya tersedia untuk tabel 2x2.", check.names = FALSE))
  }
  coef_df <- as.data.frame(stats$coef_table)
  coef_df$Term <- rownames(coef_df)
  rownames(coef_df) <- NULL
  data.frame(
    Term = coef_df$Term,
    Koefisien = coef_df$Estimate,
    `Odds Ratio` = stats$model_or,
    `Std. Error` = coef_df$`Std. Error`,
    `z value` = coef_df$`z value`,
    `p-value` = coef_df$`Pr(>|z|)`,
    check.names = FALSE
  )
}
