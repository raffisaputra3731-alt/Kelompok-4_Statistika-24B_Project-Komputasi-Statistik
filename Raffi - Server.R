server <- function(input, output, session) {
  notify_error <- function(message) {
    showNotification(message, type = "error", duration = 8)
    validate(need(FALSE, message))
  }
  
  uploaded_raw <- reactive({
    req(input$csv_file)
    tryCatch(read_raw_csv(input$csv_file$datapath, header = isTRUE(input$csv_header)), error = function(e) notify_error(e$message))
  })
  
  output$csv_variable_selector <- renderUI({
    req(input$csv_file)
    dat <- uploaded_raw()
    if (ncol(dat) > 2) {
      tagList(
        selectInput("csv_x", "Variabel X", choices = names(dat), selected = names(dat)[1]),
        selectInput("csv_y", "Variabel Y", choices = names(dat), selected = names(dat)[2])
      )
    } else {
      tags$p(class = "small-note", paste("Variabel otomatis:", names(dat)[1], "dan", names(dat)[2]))
    }
  })
  
  manual_data <- eventReactive(input$apply_manual, {
    manual_to_data(input)
  }, ignoreNULL = FALSE)
  
  upload_data <- reactive({
    dat <- uploaded_raw()
    x_var <- if (ncol(dat) > 2) input$csv_x else names(dat)[1]
    y_var <- if (ncol(dat) > 2) input$csv_y else names(dat)[2]
    req(x_var, y_var)
    tryCatch(validate_raw_selection(dat, x_var, y_var), error = function(e) notify_error(e$message))
  })
  
  active_data <- reactive({
    if (identical(input$input_mode, "upload")) {
      req(input$csv_file)
      upload_data()
    } else {
      manual_data()
    }
  })
  
  active_matrix <- reactive(active_data()$matrix)
  
  stats <- reactive({
    alpha <- input$alpha
    if (is.null(alpha) || is.na(alpha) || !is.finite(alpha) || alpha <= 0 || alpha >= 1) alpha <- alpha_default
    calculate_statistics(active_matrix(), alpha = alpha)
  })
  
  observeEvent(active_data(), {
    showNotification(
      paste("Data aktif:", active_data()$format, "dengan total", sum(active_matrix()), "observasi."),
      type = "message",
      duration = 4
    )
  })
  
  observeEvent(input$show_help, {
    showModal(modalDialog(
      title = "Bantuan Dashboard",
      easyClose = TRUE,
      footer = modalButton("Tutup"),
      tags$p("Gunakan Input Manual untuk tabel 2x2 atau Upload CSV untuk raw data penelitian."),
      tags$p("CSV raw data berisi observasi per baris. Jika CSV memiliki lebih dari dua kolom, pilih Variabel X dan Variabel Y."),
      tags$p("Dashboard membentuk tabel kontingensi otomatis memakai table(), lalu seluruh analisis memakai tabel yang sama.")
    ))
  })
  
  output$home_total <- renderValueBox(valueBox(stats()$n, "Total Observasi", icon = icon("users"), color = "primary"))
  output$home_cramer <- renderValueBox(valueBox(fmt_num(stats()$cramers_v), "Cramer's V", icon = icon("link"), color = "success"))
  output$home_or <- renderValueBox(valueBox(fmt_num(stats()$odds_ratio), "Odds Ratio", icon = icon("balance-scale"), color = "info"))
  output$home_p <- renderValueBox(valueBox(fmt_num(stats()$chi$p.value), "p-value Chi-Square", icon = icon("flask"), color = "warning"))
  
  output$home_interpretation <- renderUI({
    dat <- active_data()
    s <- stats()
    HTML(paste0(
      "Dashboard sedang menganalisis hubungan antara <b>", dat$variable_x, "</b> dan <b>", dat$variable_y, "</b>. ",
      "Tabel kontingensi dibentuk otomatis dari data aktif. Hasil Chi-square menunjukkan p-value <b>",
      fmt_num(s$chi$p.value), "</b>, sehingga ", relationship_text(s$chi$p.value, s$alpha), " antara kedua variabel."
    ))
  })
  
  output$data_status <- renderUI({
    dat <- active_data()
    HTML(paste0(
      "<b>Sumber:</b> ", dat$format, "<br>",
      "<b>Variabel X:</b> ", dat$variable_x, "<br>",
      "<b>Variabel Y:</b> ", dat$variable_y, "<br>",
      "<b>Dimensi tabel:</b> ", nrow(dat$matrix), " x ", ncol(dat$matrix)
    ))
  })
  
  output$raw_preview <- renderDT({
    dat <- active_data()
    DT::datatable(head(dat$raw, 100), rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE), class = "stripe hover compact")
  })
  output$input_preview <- renderDT(make_datatable(active_matrix(), caption = paste("Sumber data:", active_data()$format), digits = 0))
  
  output$summary_total <- renderValueBox(valueBox(active_data()$dataset_summary$n_observations, "Jumlah Observasi", icon = icon("database"), color = "primary"))
  output$summary_vars <- renderValueBox(valueBox(active_data()$dataset_summary$n_variables, "Jumlah Variabel", icon = icon("columns"), color = "info"))
  output$summary_xcat <- renderValueBox(valueBox(active_data()$dataset_summary$x_categories, "Kategori Variabel X", icon = icon("tags"), color = "success"))
  output$summary_ycat <- renderValueBox(valueBox(active_data()$dataset_summary$y_categories, "Kategori Variabel Y", icon = icon("tags"), color = "warning"))
  output$summary_missing <- renderValueBox(valueBox(active_data()$dataset_summary$missing_values, "Missing Value", icon = icon("exclamation-triangle"), color = "danger"))
  output$summary_rows <- renderValueBox(valueBox(nrow(active_matrix()), "Baris Tabel", icon = icon("grip-lines"), color = "primary"))
  output$summary_cols <- renderValueBox(valueBox(ncol(active_matrix()), "Kolom Tabel", icon = icon("grip-lines-vertical"), color = "info"))
  output$summary_cells <- renderValueBox(valueBox(length(active_matrix()), "Jumlah Sel", icon = icon("th"), color = "success"))
  
  output$contingency_table <- renderDT(make_datatable(active_matrix(), "Tabel kontingensi frekuensi observasi", digits = 0))
  output$proportion_table <- renderDT(make_datatable(stats()$joint, "Proporsi terhadap total observasi", digits = 4))
  output$joint_table <- renderDT(make_datatable(stats()$joint, "Distribusi bersama P(X,Y)", digits = 4))
  output$row_cond_table <- renderDT(make_datatable(stats()$row_prop, "Distribusi bersyarat berdasarkan kategori X", digits = 4))
  output$col_cond_table <- renderDT(make_datatable(stats()$col_prop, "Distribusi bersyarat berdasarkan kategori Y", digits = 4))
  output$marginal_table <- renderDT({
    mat <- active_matrix()
    marginal <- data.frame(
      Variabel = c(rep(active_data()$variable_x, nrow(mat)), rep(active_data()$variable_y, ncol(mat))),
      Kategori = c(rownames(mat), colnames(mat)),
      Frekuensi = c(rowSums(mat), colSums(mat)),
      Proporsi = c(rowSums(mat), colSums(mat)) / sum(mat),
      check.names = FALSE
    )
    make_datatable(marginal, rownames = FALSE)
  })
  
  output$observed_table <- renderDT(make_datatable(active_matrix(), digits = 0))
  output$expected_table <- renderDT(make_datatable(stats()$expected, digits = 3))
  output$std_residual_table <- renderDT(make_datatable(stats()$residual, digits = 3))
  output$assumption_table <- renderDT(make_datatable(assumption_table(stats()), rownames = FALSE))
  output$assumption_warning <- renderUI({
    s <- stats()
    if (s$chi_assumption$met) {
      HTML("<span class='text-success'><b>Asumsi Chi-square terpenuhi.</b> Fisher Exact Test tetap ditampilkan sebagai pembanding.</span>")
    } else {
      HTML(paste0(
        "<span class='text-danger'><b>Warning:</b> Asumsi Chi-square tidak terpenuhi karena ada ",
        s$chi_assumption$cells_below_5, " sel expected < 5 (", fmt_pct(s$chi_assumption$pct_below_5),
        "). Gunakan Fisher Exact Test sebagai acuan utama.</span>"
      ))
    }
  })
  
  output$assoc_diff <- renderValueBox(valueBox(fmt_num(stats()$diff_prop), "Risk Difference", icon = icon("percent"), color = "primary"))
  output$assoc_rr <- renderValueBox(valueBox(fmt_num(stats()$relative_risk), "Relative Risk", icon = icon("arrow-up"), color = "success"))
  output$assoc_or <- renderValueBox(valueBox(fmt_num(stats()$odds_ratio), "Odds Ratio", icon = icon("balance-scale"), color = "info"))
  output$alpha_explanation <- renderUI({
    s <- stats()
    HTML(paste0("Alpha saat ini adalah <b>", fmt_num(s$alpha, 3), "</b>, sehingga interval kepercayaan yang digunakan adalah <b>", s$conf_label, "</b>."))
  })
  output$diff_prop_table <- renderDT({
    s <- stats()
    out <- data.frame(
      Komponen = c("Proporsi kategori X pertama", "Proporsi kategori X kedua", "Risk Difference (Difference of Proportion)", "Standard Error", paste(s$conf_label, "Lower"), paste(s$conf_label, "Upper")),
      Nilai = fmt_num(c(s$p1, s$p2, s$diff_prop, s$se_diff, s$ci_diff[1], s$ci_diff[2])),
      check.names = FALSE
    )
    make_datatable(out, rownames = FALSE)
  })
  output$rr_table <- renderDT({
    s <- stats()
    make_datatable(data.frame(Komponen = c("Relative Risk", paste(s$conf_label, "Lower"), paste(s$conf_label, "Upper")), Nilai = fmt_num(c(s$relative_risk, s$ci_rr[1], s$ci_rr[2])), check.names = FALSE), rownames = FALSE)
  })
  output$or_table <- renderDT({
    s <- stats()
    make_datatable(data.frame(Komponen = c("Odds Ratio", paste(s$conf_label, "Lower"), paste(s$conf_label, "Upper"), "Kekuatan Asosiasi"), Nilai = c(fmt_num(s$odds_ratio), fmt_num(s$ci_or[1]), fmt_num(s$ci_or[2]), association_strength(s$odds_ratio)), check.names = FALSE), rownames = FALSE)
  })
  output$association_table <- renderDT({
    out <- metric_table(stats(), active_matrix())
    out$Nilai <- fmt_num(out$Nilai)
    make_datatable(out, rownames = FALSE)
  })
  output$diff_prop_interpretation <- renderUI({
    s <- stats()
    dat <- active_data()
    if (!s$is_2x2) return(HTML("Risk Difference hanya dihitung untuk tabel 2x2."))
    HTML(paste0("Risk difference outcome <b>", colnames(dat$matrix)[1], "</b> antara kategori <b>", rownames(dat$matrix)[1], "</b> dan <b>", rownames(dat$matrix)[2], "</b> adalah <b>", fmt_num(s$diff_prop), "</b>."))
  })
  output$rr_interpretation <- renderUI({
    s <- stats()
    if (!s$is_2x2) return(HTML("Relative Risk hanya dihitung untuk tabel 2x2."))
    HTML(paste0("Relative Risk = <b>", fmt_num(s$relative_risk), "</b> dengan ", s$conf_label, " [", fmt_num(s$ci_rr[1]), ", ", fmt_num(s$ci_rr[2]), "]."))
  })
  output$or_interpretation <- renderUI({
    s <- stats()
    if (!s$is_2x2) return(HTML("Odds Ratio hanya dihitung untuk tabel 2x2."))
    HTML(paste0("Odds Ratio = <b>", fmt_num(s$odds_ratio), "</b> dan kekuatan asosiasi berdasarkan OR dikategorikan <b>", association_strength(s$odds_ratio), "</b>."))
  })
  output$association_interpretation <- renderUI({
    s <- stats()
    dat <- active_data()
    HTML(paste0(
      "Cramer's V sebesar <b>", fmt_num(s$cramers_v), "</b> dan Contingency Coefficient sebesar <b>", fmt_num(s$contingency_coef), "</b>. ",
      "Secara inferensial, ", relationship_text(s$chi$p.value, s$alpha), " antara <b>", dat$variable_x, "</b> dan <b>", dat$variable_y, "</b>."
    ))
  })
  
  output$assoc_distribution_plot <- renderPlotly({
    mat <- active_matrix()
    prop <- prop.table(mat, 1)
    df <- long_table(prop, "Proporsi")
    df$Frekuensi <- as.vector(mat)
    df$Hover <- paste0(active_data()$variable_x, ": ", df$Baris, "<br>", active_data()$variable_y, ": ", df$Kolom, "<br>Frekuensi: ", df$Frekuensi, "<br>Proporsi: ", fmt_pct(df$Proporsi))
    plot_ly(df, x = ~Baris, y = ~Proporsi, color = ~Kolom, type = "bar", text = ~Hover, hoverinfo = "text") %>%
      layout(barmode = "stack", yaxis = list(title = "Proporsi dalam kategori X", tickformat = ".0%"), xaxis = list(title = active_data()$variable_x), legend = list(orientation = "h", x = 0, y = 1.12))
  })
  
  output$assoc_ci_plot <- renderPlotly({
    s <- stats()
    validate(need(s$is_2x2, "Grafik CI RR/OR tersedia untuk tabel 2x2."))
    df <- data.frame(Ukuran = c("Relative Risk", "Odds Ratio"), Estimasi = c(s$relative_risk, s$odds_ratio), Lower = c(s$ci_rr[1], s$ci_or[1]), Upper = c(s$ci_rr[2], s$ci_or[2]))
    plot_ly(df, x = ~Estimasi, y = ~Ukuran, type = "scatter", mode = "markers", marker = list(size = 13, color = "#8f7cf6"), error_x = list(type = "data", symmetric = FALSE, array = df$Upper - df$Estimasi, arrayminus = df$Estimasi - df$Lower), text = ~paste(Ukuran, "<br>Estimasi:", fmt_num(Estimasi), "<br>CI:", fmt_num(Lower), "-", fmt_num(Upper)), hoverinfo = "text") %>%
      layout(xaxis = list(title = "Estimasi rasio dan CI", type = "log"), yaxis = list(title = ""), showlegend = FALSE, shapes = list(list(type = "line", x0 = 1, x1 = 1, y0 = 0, y1 = 1, xref = "x", yref = "paper", line = list(color = "#ff9f8a", dash = "dash", width = 2))))
  })
  
  output$hypothesis_table <- renderDT({
    table_out <- hypothesis_table(stats())
    table_out$Statistik <- fmt_num(table_out$Statistik)
    table_out$`p-value` <- fmt_num(table_out$`p-value`)
    make_datatable(table_out, rownames = FALSE)
  })
  output$hypothesis_interpretation <- renderUI({
    s <- stats()
    dat <- active_data()
    fisher_p <- if (is.null(s$fisher)) NA_real_ else s$fisher$p.value
    main_test <- if (s$chi_assumption$met) "Chi-square" else "Fisher Exact Test"
    main_p <- if (s$chi_assumption$met) s$chi$p.value else fisher_p
    HTML(paste0(
      "Uji utama yang direkomendasikan adalah <b>", main_test, "</b>. p-value = <b>", fmt_num(main_p), "</b>, sehingga ",
      relationship_text(main_p, s$alpha), " antara <b>", dat$variable_x, "</b> dan <b>", dat$variable_y, "</b>. ",
      "Fisher Exact Test ditampilkan otomatis dengan p-value <b>", fmt_num(fisher_p), "</b>."
    ))
  })
  
  output$logistic_table <- renderDT({
    out <- model_table(stats())
    num_cols <- vapply(out, is.numeric, logical(1))
    out[num_cols] <- lapply(out[num_cols], fmt_num)
    make_datatable(out, rownames = FALSE)
  })
  output$model_formula <- renderText({
    dat <- active_data()
    if (!stats()$is_2x2) return("Model regresi logistik hanya tersedia untuk tabel 2x2.")
    paste0("Model: logit(P(", dat$variable_y, " = ", colnames(dat$matrix)[1], ")) = beta0 + beta1 * ", dat$variable_x)
  })
  output$logistic_interpretation <- renderUI({
    s <- stats()
    dat <- active_data()
    if (!s$is_2x2 || is.null(s$coef_table)) return(HTML("Regresi logistik hanya tersedia untuk tabel 2x2 yang valid."))
    coef_df <- model_table(s)
    p_beta <- coef_df$`p-value`[2]
    or_beta <- coef_df$`Odds Ratio`[2]
    HTML(paste0("Model memprediksi peluang <b>", dat$variable_y, " = ", colnames(dat$matrix)[1], "</b>. Efek <b>", dat$variable_x, "</b> menghasilkan OR model <b>", fmt_num(or_beta), "</b> dengan p-value <b>", fmt_num(p_beta), "</b>."))
  })
  
  output$bar_plot <- renderPlotly({
    mat <- active_matrix()
    df <- long_table(mat, "Frekuensi")
    plot_ly(df, x = ~Baris, y = ~Frekuensi, color = ~Kolom, type = "bar", text = ~paste("X:", Baris, "<br>Y:", Kolom, "<br>Frekuensi:", Frekuensi), hoverinfo = "text") %>%
      layout(barmode = "group", xaxis = list(title = active_data()$variable_x), yaxis = list(title = "Frekuensi"))
  })
  output$stacked_bar_plot <- renderPlotly({
    mat <- active_matrix()
    df <- long_table(mat, "Frekuensi")
    plot_ly(df, x = ~Baris, y = ~Frekuensi, color = ~Kolom, type = "bar", text = ~paste("X:", Baris, "<br>Y:", Kolom, "<br>Frekuensi:", Frekuensi), hoverinfo = "text") %>%
      layout(barmode = "stack", xaxis = list(title = active_data()$variable_x), yaxis = list(title = "Frekuensi"))
  })
  output$stacked100_bar_plot <- renderPlotly({
    mat <- active_matrix()
    prop <- prop.table(mat, 1)
    df <- long_table(prop, "Proporsi")
    plot_ly(df, x = ~Baris, y = ~Proporsi, color = ~Kolom, type = "bar", text = ~paste("X:", Baris, "<br>Y:", Kolom, "<br>Proporsi:", fmt_pct(Proporsi)), hoverinfo = "text") %>%
      layout(barmode = "stack", xaxis = list(title = active_data()$variable_x), yaxis = list(title = "Proporsi", tickformat = ".0%"))
  })
  output$mosaic_plot <- renderPlotly({
    mat <- active_matrix()
    df <- long_table(mat, "Frekuensi")
    row_tot <- rowSums(mat)
    total <- sum(mat)
    row_width <- row_tot / total
    x0_by_row <- c(0, head(cumsum(row_width), -1))
    x1_by_row <- cumsum(row_width)
    shapes <- list()
    annotations <- list()
    hover_x <- numeric(0)
    hover_y <- numeric(0)
    hover_text <- character(0)
    k <- 1
    cols <- c("#8f7cf6", "#60c6a8", "#ffbe7b", "#4fb7d8", "#f28e8e", "#9ad0f5")
    for (i in seq_len(nrow(mat))) {
      y0 <- 0
      heights <- mat[i, ] / row_tot[i]
      for (j in seq_len(ncol(mat))) {
        y1 <- y0 + heights[j]
        shapes[[k]] <- list(type = "rect", x0 = x0_by_row[i], x1 = x1_by_row[i], y0 = y0, y1 = y1, line = list(color = "white", width = 2), fillcolor = cols[((i + j - 2) %% length(cols)) + 1])
        annotations[[k]] <- list(x = (x0_by_row[i] + x1_by_row[i]) / 2, y = (y0 + y1) / 2, text = paste0(round(100 * mat[i, j] / total, 1), "%"), showarrow = FALSE, font = list(color = "#223046", size = 11))
        hover_x <- c(hover_x, (x0_by_row[i] + x1_by_row[i]) / 2)
        hover_y <- c(hover_y, (y0 + y1) / 2)
        hover_text <- c(hover_text, paste0(rownames(mat)[i], " - ", colnames(mat)[j], "<br>Frekuensi: ", mat[i, j], "<br>Proporsi total: ", fmt_pct(mat[i, j] / total)))
        y0 <- y1
        k <- k + 1
      }
    }
    plot_ly(x = hover_x, y = hover_y, type = "scatter", mode = "markers", marker = list(size = 18, color = "rgba(255,255,255,0.01)"), text = hover_text, hoverinfo = "text") %>%
      layout(shapes = shapes, annotations = annotations, xaxis = list(title = "Proporsi marginal X", range = c(0, 1), showgrid = FALSE), yaxis = list(title = "Proporsi bersyarat Y", range = c(0, 1), showgrid = FALSE), showlegend = FALSE)
  })
  output$heat_freq <- renderPlotly({
    mat <- active_matrix()
    plot_ly(x = colnames(mat), y = rownames(mat), z = mat, type = "heatmap", colors = c("#f8fbff", "#8f7cf6"), hoverinfo = "x+y+z") %>%
      layout(xaxis = list(title = active_data()$variable_y), yaxis = list(title = active_data()$variable_x))
  })
  output$heat_prop <- renderPlotly({
    mat <- active_matrix()
    prop <- mat / sum(mat)
    plot_ly(x = colnames(mat), y = rownames(mat), z = prop, type = "heatmap", colors = c("#f8fbff", "#60c6a8"), hoverinfo = "x+y+z") %>%
      layout(xaxis = list(title = active_data()$variable_y), yaxis = list(title = active_data()$variable_x))
  })
  output$residual_plot <- renderPlotly({
    s <- stats()
    mat <- active_matrix()
    plot_ly(x = colnames(mat), y = rownames(mat), z = s$residual, type = "heatmap", colors = c("#ff9f8a", "#ffffff", "#60c6a8"), zmid = 0, hoverinfo = "x+y+z") %>%
      layout(xaxis = list(title = active_data()$variable_y), yaxis = list(title = active_data()$variable_x))
  })
  output$association_plot <- renderPlotly({
    mat <- active_matrix()
    s <- stats()
    df <- long_table(s$residual, "Residual")
    df$Observed <- as.vector(mat)
    df$Expected <- as.vector(s$expected)
    plot_ly(df, x = ~interaction(Baris, Kolom, sep = " | "), y = ~Residual, type = "bar", color = ~Residual > 0, colors = c("#ff9f8a", "#60c6a8"), text = ~paste("Kategori:", Baris, "-", Kolom, "<br>Observed:", Observed, "<br>Expected:", fmt_num(Expected), "<br>Std. Residual:", fmt_num(Residual)), hoverinfo = "text") %>%
      layout(showlegend = FALSE, xaxis = list(title = ""), yaxis = list(title = "Standardized residual"))
  })
  
  output$download_pdf <- downloadHandler(
    filename = function() paste0("laporan_analisis_kategorik_", Sys.Date(), ".pdf"),
    content = function(file) write_pdf_report(file, active_data(), stats())
  )
  output$download_word <- downloadHandler(
    filename = function() paste0("laporan_analisis_kategorik_", Sys.Date(), ".docx"),
    content = function(file) {
      if (!requireNamespace("officer", quietly = TRUE) || !requireNamespace("flextable", quietly = TRUE)) {
        stop("Export Word memerlukan package officer dan flextable. Jalankan install.packages(c('officer','flextable')).", call. = FALSE)
      }
      dat <- active_data()
      s <- stats()
      doc <- officer::read_docx()
      doc <- officer::body_add_par(doc, "Laporan Analisis Data Kategorik", style = "heading 1")
      doc <- officer::body_add_par(doc, paste("Variabel X:", dat$variable_x))
      doc <- officer::body_add_par(doc, paste("Variabel Y:", dat$variable_y))
      doc <- officer::body_add_par(doc, paste("Total observasi:", s$n))
      doc <- officer::body_add_flextable(doc, flextable::flextable(as.data.frame.matrix(dat$matrix)))
      doc <- officer::body_add_flextable(doc, flextable::flextable(hypothesis_table(s)))
      print(doc, target = file)
    }
  )
  output$download_excel <- downloadHandler(
    filename = function() paste0("analisis_kategorik_", Sys.Date(), ".xlsx"),
    content = function(file) {
      dat <- active_data()
      s <- stats()
      if (requireNamespace("openxlsx", quietly = TRUE)) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "Raw Data")
        openxlsx::writeData(wb, "Raw Data", dat$raw)
        openxlsx::addWorksheet(wb, "Observed")
        openxlsx::writeData(wb, "Observed", as.data.frame.matrix(dat$matrix), rowNames = TRUE)
        openxlsx::addWorksheet(wb, "Expected")
        openxlsx::writeData(wb, "Expected", as.data.frame.matrix(s$expected), rowNames = TRUE)
        openxlsx::addWorksheet(wb, "Residual")
        openxlsx::writeData(wb, "Residual", as.data.frame.matrix(s$residual), rowNames = TRUE)
        openxlsx::addWorksheet(wb, "Hypothesis")
        openxlsx::writeData(wb, "Hypothesis", hypothesis_table(s))
        openxlsx::saveWorkbook(wb, file, overwrite = TRUE)
      } else if (requireNamespace("writexl", quietly = TRUE)) {
        writexl::write_xlsx(list(
          Raw_Data = dat$raw,
          Observed = data.frame(Kategori_X = rownames(dat$matrix), as.data.frame.matrix(dat$matrix), check.names = FALSE),
          Expected = data.frame(Kategori_X = rownames(s$expected), as.data.frame.matrix(s$expected), check.names = FALSE),
          Residual = data.frame(Kategori_X = rownames(s$residual), as.data.frame.matrix(s$residual), check.names = FALSE),
          Hypothesis = hypothesis_table(s)
        ), path = file)
      } else {
        stop("Export Excel memerlukan package openxlsx atau writexl. Jalankan install.packages('openxlsx').", call. = FALSE)
      }
    }
  )
  output$download_png <- downloadHandler(
    filename = function() paste0(input$png_plot, "_", Sys.Date(), ".png"),
    content = function(file) static_png_plot(file, active_matrix(), stats(), input$png_plot)
  )
  
  output$final_conclusion <- renderUI({
    s <- stats()
    dat <- active_data()
    main_test <- if (s$chi_assumption$met) "Chi-square" else "Fisher Exact Test"
    main_p <- if (s$chi_assumption$met) s$chi$p.value else if (is.null(s$fisher)) NA_real_ else s$fisher$p.value
    rr_or <- if (s$is_2x2) {
      paste0("<p>Outcome utama <b>", colnames(dat$matrix)[1], "</b> memiliki Relative Risk <b>", fmt_num(s$relative_risk), "</b> dan Odds Ratio <b>", fmt_num(s$odds_ratio), "</b>.</p>")
    } else {
      "<p>Karena tabel bukan 2x2, RR dan OR tidak dihitung; asosiasi diringkas dengan Cramer's V dan Contingency Coefficient.</p>"
    }
    HTML(paste0(
      "<p>Berdasarkan analisis antara <b>", dat$variable_x, "</b> dan <b>", dat$variable_y, "</b>, total observasi yang dianalisis adalah <b>", s$n, "</b>.</p>",
      "<p>Uji utama yang direkomendasikan adalah <b>", main_test, "</b> dengan p-value <b>", fmt_num(main_p), "</b>. Pada taraf signifikansi ", s$alpha, ", ", relationship_text(main_p, s$alpha), " antara kedua variabel.</p>",
      "<p>Cramer's V = <b>", fmt_num(s$cramers_v), "</b> dan Contingency Coefficient = <b>", fmt_num(s$contingency_coef), "</b>.</p>",
      rr_or,
      "<p>Dengan demikian, dashboard membaca raw data, membentuk tabel kontingensi otomatis, menghitung uji statistik, ukuran asosiasi, visualisasi, dan kesimpulan ilmiah secara terpadu.</p>"
    ))
  })
}

shinyApp(ui, server)