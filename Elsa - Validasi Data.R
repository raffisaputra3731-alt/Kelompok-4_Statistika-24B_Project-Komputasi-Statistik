validate_counts <- function(mat) {
  validate(
    need(length(dim(mat)) == 2, "Tabel kontingensi tidak valid."),
    need(nrow(mat) >= 2 && ncol(mat) >= 2, "Setiap variabel harus memiliki minimal dua kategori."),
    need(all(!is.na(mat)), "Seluruh sel harus terisi. Tidak boleh ada nilai NA atau kosong."),
    need(all(is.finite(mat)), "Seluruh sel harus berupa angka yang valid."),
    need(all(mat >= 0), "Frekuensi tidak boleh bernilai negatif."),
    need(all(abs(mat - round(mat)) < .Machine$double.eps^0.5), "Frekuensi harus berupa bilangan bulat."),
    need(sum(mat) > 0, "Total observasi harus lebih dari 0."),
    need(all(rowSums(mat) > 0), "Setiap kategori variabel X harus memiliki minimal satu observasi."),
    need(all(colSums(mat) > 0), "Setiap kategori variabel Y harus memiliki minimal satu observasi.")
  )
}

read_raw_csv <- function(path, header = TRUE) {
  dat <- tryCatch(
    read.csv(
      path,
      header = header,
      stringsAsFactors = FALSE,
      check.names = FALSE,
      na.strings = c("NA", "NaN", "N/A", "NULL")
    ),
    error = function(e) stop("CSV rusak atau tidak dapat dibaca. Periksa delimiter, kutipan, dan struktur file.", call. = FALSE)
  )
  if (nrow(dat) == 0 && ncol(dat) == 0) stop("File CSV kosong.", call. = FALSE)
  if (nrow(dat) == 0) stop("File CSV tidak memiliki baris data.", call. = FALSE)
  if (ncol(dat) < 2) stop("CSV hanya memiliki satu kolom. Minimal diperlukan dua variabel kategorik.", call. = FALSE)
  dat
}

is_blank_vector <- function(x) {
  y <- trimws(as.character(x))
  is.na(y) | !nzchar(y)
}

looks_continuous_numeric <- function(x) {
  if (!is.numeric(x)) return(FALSE)
  ux <- unique(x[!is.na(x)])
  length(ux) > 10 || any(abs(ux - round(ux)) > .Machine$double.eps^0.5)
}

validate_raw_selection <- function(dat, x_var, y_var) {
  if (is.null(dat)) stop("Upload CSV terlebih dahulu.", call. = FALSE)
  if (ncol(dat) < 2) stop("CSV harus memiliki minimal dua kolom.", call. = FALSE)
  if (identical(x_var, y_var)) stop("Variabel X dan Variabel Y harus berbeda.", call. = FALSE)
  if (!all(c(x_var, y_var) %in% names(dat))) stop("Variabel yang dipilih tidak ditemukan di CSV.", call. = FALSE)
  
  raw_pair <- dat[, c(x_var, y_var), drop = FALSE]
  missing_count <- sum(is.na(raw_pair))
  blank_count <- sum(vapply(raw_pair, function(z) sum(is_blank_vector(z)), integer(1)))
  if (missing_count > 0) stop(paste0("Data mengandung ", missing_count, " nilai NA pada variabel terpilih. Bersihkan data terlebih dahulu."), call. = FALSE)
  if (blank_count > 0) stop(paste0("Data mengandung ", blank_count, " kategori kosong pada variabel terpilih."), call. = FALSE)
  if (any(vapply(raw_pair, looks_continuous_numeric, logical(1)))) {
    stop("Variabel numerik kontinu terdeteksi. Pilih variabel kategorik, bukan data numerik kontinu.", call. = FALSE)
  }
  
  pair <- data.frame(
    X = trimws(as.character(raw_pair[[1]])),
    Y = trimws(as.character(raw_pair[[2]])),
    stringsAsFactors = FALSE
  )
  x_levels <- unique(pair$X)
  y_levels <- unique(pair$Y)
  if (length(x_levels) < 2 || length(y_levels) < 2) {
    stop("Setiap variabel harus memiliki minimal dua kategori.", call. = FALSE)
  }
  if (length(unique(paste(pair$X, pair$Y, sep = "\r"))) == 1) {
    stop("Seluruh data memiliki kombinasi kategori yang sama sehingga tabel kontingensi tidak dapat dianalisis.", call. = FALSE)
  }
  
  mat <- table(
    factor(pair$X, levels = x_levels),
    factor(pair$Y, levels = y_levels)
  )
  mat <- safe_matrix_table(mat, x_levels, y_levels)
  validate_counts(mat)
  
  list(
    matrix = mat,
    raw = raw_pair,
    variable_x = x_var,
    variable_y = y_var,
    format = "Upload CSV raw data penelitian",
    dataset_summary = list(
      n_observations = nrow(dat),
      n_variables = ncol(dat),
      x_categories = length(x_levels),
      y_categories = length(y_levels),
      missing_values = sum(is.na(dat))
    )
  )
}
