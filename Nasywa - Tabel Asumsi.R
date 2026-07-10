assumption_table <- function(stats) {
  data.frame(
    Pemeriksaan = c("Minimum expected count", "Jumlah sel expected < 5", "Persentase expected < 5", "Asumsi Chi-square terpenuhi"),
    Nilai = c(
      fmt_num(stats$chi_assumption$min_expected),
      stats$chi_assumption$cells_below_5,
      fmt_pct(stats$chi_assumption$pct_below_5),
      ifelse(stats$chi_assumption$met, "Ya", "Tidak")
    ),
    check.names = FALSE
  )
}
