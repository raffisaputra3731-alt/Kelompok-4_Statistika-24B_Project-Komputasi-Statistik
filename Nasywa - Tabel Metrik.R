metric_table <- function(stats, mat) {
  risk_label <- if (stats$is_2x2) {
    paste0("Risk Difference (Difference of Proportion): ", rownames(mat)[1], " vs ", rownames(mat)[2], " untuk outcome ", colnames(mat)[1])
  } else {
    "Risk Difference (Difference of Proportion) - hanya untuk tabel 2x2"
  }
  data.frame(
    Ukuran = c(risk_label, "Relative Risk", "Odds Ratio", "Phi Coefficient", "Cramer's V", "Contingency Coefficient"),
    Nilai = c(stats$diff_prop, stats$relative_risk, stats$odds_ratio, stats$phi, stats$cramers_v, stats$contingency_coef),
    Interpretasi = c(
      "Selisih risiko outcome utama antar kategori variabel X.",
      "Rasio risiko outcome utama antar kategori variabel X; tersedia untuk tabel 2x2.",
      "Rasio odds outcome utama antar kategori variabel X; tersedia untuk tabel 2x2.",
      "Kekuatan asosiasi khusus tabel 2x2.",
      "Kekuatan asosiasi untuk tabel kontingensi umum.",
      "Ukuran asosiasi berbasis Chi-square untuk tabel kontingensi umum."
    ),
    check.names = FALSE
  )
}
