hypothesis_table <- function(stats) {
  fisher_stat <- if (is.null(stats$fisher) || is.null(stats$fisher$estimate)) NA_real_ else unname(stats$fisher$estimate[1])
  data.frame(
    Uji = c("Chi-Square Test", "G-Test / Likelihood Ratio Test", "Fisher Exact Test"),
    Statistik = c(unname(stats$chi$statistic), stats$g_stat, fisher_stat),
    `Derajat Bebas` = c(unname(stats$chi$parameter), stats$g_df, NA),
    `p-value` = c(stats$chi$p.value, stats$g_p, if (is.null(stats$fisher)) NA_real_ else stats$fisher$p.value),
    Keputusan = c(decision_text(stats$chi$p.value, stats$alpha), decision_text(stats$g_p, stats$alpha), decision_text(if (is.null(stats$fisher)) NA_real_ else stats$fisher$p.value, stats$alpha)),
    check.names = FALSE
  )
}
