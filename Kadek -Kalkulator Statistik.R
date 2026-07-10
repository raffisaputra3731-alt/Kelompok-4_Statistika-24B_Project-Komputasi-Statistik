calculate_statistics <- function(mat, alpha = alpha_default) {
  validate_counts(mat)
  n <- sum(mat)
  r <- nrow(mat)
  c <- ncol(mat)
  joint <- mat / n
  row_prop <- prop.table(mat, 1)
  col_prop <- prop.table(mat, 2)
  expected <- outer(rowSums(mat), colSums(mat)) / n
  residual <- (mat - expected) / sqrt(expected)
  chi <- suppressWarnings(chisq.test(mat, correct = FALSE))
  g_terms <- ifelse(mat == 0, 0, mat * log(mat / expected))
  g_stat <- 2 * sum(g_terms)
  g_df <- (r - 1) * (c - 1)
  g_p <- pchisq(g_stat, df = g_df, lower.tail = FALSE)
  fisher <- tryCatch(fisher.test(mat), error = function(e) NULL)
  
  chi_assumption <- list(
    min_expected = min(expected),
    cells_below_5 = sum(expected < 5),
    pct_below_5 = mean(expected < 5),
    met = all(expected >= 5)
  )
  
  chi_sq <- unname(chi$statistic)
  phi <- if (r == 2 && c == 2) sqrt(chi_sq / n) else NA_real_
  cramers_v <- sqrt(chi_sq / (n * min(r - 1, c - 1)))
  contingency_coef <- sqrt(chi_sq / (chi_sq + n))
  
  out <- list(
    n = n,
    joint = joint,
    row_prop = row_prop,
    col_prop = col_prop,
    expected = expected,
    residual = residual,
    chi = chi,
    g_stat = g_stat,
    g_df = g_df,
    g_p = g_p,
    fisher = fisher,
    chi_assumption = chi_assumption,
    phi = phi,
    cramers_v = cramers_v,
    contingency_coef = contingency_coef,
    alpha = alpha,
    conf_label = ci_label(alpha),
    is_2x2 = is_2x2(mat)
  )
  
  if (is_2x2(mat)) {
    a <- mat[1, 1]
    b <- mat[1, 2]
    cc <- mat[2, 1]
    d <- mat[2, 2]
    p1 <- a / (a + b)
    p2 <- cc / (cc + d)
    diff_prop <- p1 - p2
    se_diff <- sqrt((p1 * (1 - p1) / (a + b)) + (p2 * (1 - p2) / (cc + d)))
    z_crit <- qnorm(1 - alpha / 2)
    ci_diff <- diff_prop + c(-1, 1) * z_crit * se_diff
    correction <- if (any(mat == 0)) 0.5 else 0
    ac <- a + correction
    bc <- b + correction
    ccor <- cc + correction
    dc <- d + correction
    odds_ratio <- (ac * dc) / (bc * ccor)
    se_log_or <- sqrt(1 / ac + 1 / bc + 1 / ccor + 1 / dc)
    ci_or <- exp(log(odds_ratio) + c(-1, 1) * z_crit * se_log_or)
    risk1 <- ac / (ac + bc)
    risk2 <- ccor / (ccor + dc)
    relative_risk <- risk1 / risk2
    se_log_rr <- sqrt((bc / (ac * (ac + bc))) + (dc / (ccor * (ccor + dc))))
    ci_rr <- exp(log(relative_risk) + c(-1, 1) * z_crit * se_log_rr)
    glm_data <- data.frame(
      exposure = factor(rownames(mat), levels = rownames(mat)),
      success = c(a, cc),
      failure = c(b, d)
    )
    model <- tryCatch(suppressWarnings(glm(cbind(success, failure) ~ exposure, data = glm_data, family = binomial())), error = function(e) NULL)
    coef_table <- if (is.null(model)) NULL else suppressWarnings(summary(model)$coefficients)
    model_or <- if (is.null(model)) NA_real_ else exp(coef(model))
    out <- c(out, list(
      a = a, b = b, c = cc, d = d,
      p1 = p1,
      p2 = p2,
      diff_prop = diff_prop,
      se_diff = se_diff,
      ci_diff = ci_diff,
      odds_ratio = odds_ratio,
      ci_or = ci_or,
      relative_risk = relative_risk,
      ci_rr = ci_rr,
      correction_used = correction > 0,
      model = model,
      coef_table = coef_table,
      model_or = model_or
    ))
  } else {
    out <- c(out, list(
      a = NA_real_, b = NA_real_, c = NA_real_, d = NA_real_,
      p1 = NA_real_, p2 = NA_real_, diff_prop = NA_real_, se_diff = NA_real_,
      ci_diff = c(NA_real_, NA_real_), odds_ratio = NA_real_, ci_or = c(NA_real_, NA_real_),
      relative_risk = NA_real_, ci_rr = c(NA_real_, NA_real_), correction_used = FALSE,
      model = NULL, coef_table = NULL, model_or = NA_real_
    ))
  }
  out
}
