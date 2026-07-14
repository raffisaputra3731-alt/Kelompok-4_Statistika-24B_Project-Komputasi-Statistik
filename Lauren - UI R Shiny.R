ui <- dashboardPage(
  title = "Dashboard Kategorik Universal",
  header = dashboardHeader(
    skin = "light",
    status = "white",
    border = FALSE,
    compact = FALSE,
    title = tags$span("Analisis Kategorik Universal")
  ),
  sidebar = dashboardSidebar(
    skin = "dark",
    status = "primary",
    brandColor = "primary",
    title = "Final Project",
    elevation = 0,
    sidebarMenu(
      id = "tabs",
      menuItem("Beranda", tabName = "home", icon = icon("home")),
      menuItem("Input Data", tabName = "input", icon = icon("keyboard")),
      menuItem("Ringkasan Data", tabName = "summary", icon = icon("table")),
      menuItem("Distribusi", tabName = "distribution", icon = icon("chart-pie")),
      menuItem("Expected & Asumsi", tabName = "expected", icon = icon("check-circle")),
      menuItem("Ukuran Asosiasi", tabName = "association", icon = icon("link")),
      menuItem("Uji Hipotesis", tabName = "hypothesis", icon = icon("flask")),
      menuItem("Regresi Logistik", tabName = "logistic", icon = icon("chart-line")),
      menuItem("Visualisasi", tabName = "visual", icon = icon("chart-bar")),
      menuItem("Export", tabName = "export", icon = icon("download")),
      menuItem("Kesimpulan", tabName = "conclusion", icon = icon("file-alt"))
    )
  ),
  body = dashboardBody(
    tags$head(tags$link(rel = "stylesheet", href = "styles.css")),
    tags$div(
      class = "custom-top-tools",
      actionButton("show_help", NULL, icon = icon("question"), class = "top-tool-btn", title = "Bantuan dashboard"),
      actionButton("toggle_theme", NULL, icon = icon("moon"), class = "top-tool-btn", title = "Mode terang / gelap")
    ),
    tags$script(HTML("
      $(document).on('click', '#toggle_theme', function() {
        $('body').toggleClass('custom-dark-mode');
        var icon = $('#toggle_theme i');
        if ($('body').hasClass('custom-dark-mode')) {
          icon.removeClass('fa-moon').addClass('fa-sun');
        } else {
          icon.removeClass('fa-sun').addClass('fa-moon');
        }
      });
    ")),
    tabItems(
      tabItem(
        tabName = "home",
        div(class = "hero-panel",
            h1(class = "dashboard-title", "Dashboard Analisis Data Kategorik Universal"),
            p(class = "dashboard-subtitle", "Aplikasi profesional untuk analisis data kategorik raw data penelitian dan input manual tabel 2x2."),
            div(
              span(class = "method-chip", "Raw CSV"),
              span(class = "method-chip", "Chi-Square"),
              span(class = "method-chip", "Fisher Exact"),
              span(class = "method-chip", "Cramer's V"),
              span(class = "method-chip", "Odds Ratio"),
              span(class = "method-chip", "Plotly Interactive")
            )
        ),
        br(),
        fluidRow(
          valueBoxOutput("home_total", width = 3),
          valueBoxOutput("home_cramer", width = 3),
          valueBoxOutput("home_or", width = 3),
          valueBoxOutput("home_p", width = 3)
        ),
        fluidRow(
          box(width = 8, title = "Alur Analisis", status = "primary", div(class = "interpretation", htmlOutput("home_interpretation"))),
          box(width = 4, title = "Status Data", status = "info", div(class = "help-panel", htmlOutput("data_status")))
        )
      ),
      tabItem(
        tabName = "input",
        fluidRow(
          box(
            width = 4,
            title = "Metode Input",
            status = "primary",
            radioButtons("input_mode", "Pilih sumber data", choices = c("Input Manual" = "manual", "Upload CSV Raw Data" = "upload"), selected = "manual"),
            div(class = "upload-panel",
                fileInput("csv_file", "Upload CSV", accept = c(".csv")),
                checkboxInput("csv_header", "CSV memiliki header", TRUE),
                uiOutput("csv_variable_selector"),
                p(class = "small-note", "CSV harus berisi raw data penelitian. Setiap baris adalah satu observasi; dashboard membentuk table() otomatis."))
          ),
          box(
            width = 8,
            title = "Input Manual Tabel 2x2",
            status = "primary",
            fluidRow(
              column(6, textInput("x_name", "Nama Variabel X", "Ikut Latihan")),
              column(6, textInput("y_name", "Nama Variabel Y", "Status Kelulusan"))
            ),
            fluidRow(
              column(6, textInput("row1", "Kategori X 1", "Ikut")),
              column(6, textInput("row2", "Kategori X 2", "Tidak Ikut"))
            ),
            fluidRow(
              column(6, textInput("col1", "Kategori Y 1 / Outcome", "Lulus")),
              column(6, textInput("col2", "Kategori Y 2 / Non-outcome", "Tidak Lulus"))
            ),
            fluidRow(
              column(3, numericInput("cell_a", "Cell A", 3, min = 0, step = 1)),
              column(3, numericInput("cell_b", "Cell B", 1, min = 0, step = 1)),
              column(3, numericInput("cell_c", "Cell C", 1, min = 0, step = 1)),
              column(3, numericInput("cell_d", "Cell D", 1, min = 0, step = 1))
            ),
            actionButton("apply_manual", "Terapkan Input Manual", icon = icon("check"), class = "btn-primary"),
            span(class = "small-note", " Semua analisis diperbarui setelah tombol ditekan.")
          )
        ),
        fluidRow(
          box(width = 6, title = "Preview Raw Data", status = "info", shinycssloaders::withSpinner(DTOutput("raw_preview"))),
          box(width = 6, title = "Preview Contingency Table", status = "info", shinycssloaders::withSpinner(DTOutput("input_preview")))
        )
      ),
      tabItem(
        tabName = "summary",
        fluidRow(
          valueBoxOutput("summary_total", width = 3),
          valueBoxOutput("summary_vars", width = 3),
          valueBoxOutput("summary_xcat", width = 3),
          valueBoxOutput("summary_ycat", width = 3)
        ),
        fluidRow(
          valueBoxOutput("summary_missing", width = 3),
          valueBoxOutput("summary_rows", width = 3),
          valueBoxOutput("summary_cols", width = 3),
          valueBoxOutput("summary_cells", width = 3)
        ),
        fluidRow(
          box(width = 6, title = "Tabel Kontingensi", status = "primary", shinycssloaders::withSpinner(DTOutput("contingency_table"))),
          box(width = 6, title = "Proporsi Total", status = "info", shinycssloaders::withSpinner(DTOutput("proportion_table")))
        )
      ),
      tabItem(
        tabName = "distribution",
        fluidRow(
          box(width = 4, title = "Distribusi Bersama", status = "primary", shinycssloaders::withSpinner(DTOutput("joint_table"))),
          box(width = 4, title = "Distribusi Bersyarat X", status = "success", shinycssloaders::withSpinner(DTOutput("row_cond_table"))),
          box(width = 4, title = "Distribusi Bersyarat Y", status = "info", shinycssloaders::withSpinner(DTOutput("col_cond_table")))
        ),
        fluidRow(box(width = 12, title = "Distribusi Marginal", status = "warning", shinycssloaders::withSpinner(DTOutput("marginal_table"))))
      ),
      tabItem(
        tabName = "expected",
        fluidRow(
          box(width = 4, title = "Observed Frequency", status = "primary", shinycssloaders::withSpinner(DTOutput("observed_table"))),
          box(width = 4, title = "Expected Frequency", status = "info", shinycssloaders::withSpinner(DTOutput("expected_table"))),
          box(width = 4, title = "Standardized Residual", status = "warning", shinycssloaders::withSpinner(DTOutput("std_residual_table")))
        ),
        fluidRow(
          box(width = 7, title = "Asumsi Chi-square", status = "primary", shinycssloaders::withSpinner(DTOutput("assumption_table"))),
          box(width = 5, title = "Warning Asumsi", status = "danger", div(class = "interpretation", htmlOutput("assumption_warning")))
        )
      ),
      tabItem(
        tabName = "association",
        fluidRow(
          box(
            width = 12,
            title = "Pengaturan Interval Kepercayaan",
            status = "primary",
            fluidRow(
              column(3, numericInput("alpha", "Alpha", value = alpha_default, min = 0.001, max = 0.20, step = 0.001)),
              column(9, div(class = "interpretation", htmlOutput("alpha_explanation")))
            )
          )
        ),
        fluidRow(
          valueBoxOutput("assoc_diff", width = 4),
          valueBoxOutput("assoc_rr", width = 4),
          valueBoxOutput("assoc_or", width = 4)
        ),
        fluidRow(
          box(width = 4, title = "Risk Difference (Difference of Proportion)", status = "primary", shinycssloaders::withSpinner(DTOutput("diff_prop_table")), div(class = "interpretation", htmlOutput("diff_prop_interpretation"))),
          box(width = 4, title = "Relative Risk dan CI", status = "success", shinycssloaders::withSpinner(DTOutput("rr_table")), div(class = "interpretation", htmlOutput("rr_interpretation"))),
          box(width = 4, title = "Odds Ratio dan CI", status = "info", shinycssloaders::withSpinner(DTOutput("or_table")), div(class = "interpretation", htmlOutput("or_interpretation")))
        ),
        fluidRow(
          box(width = 6, title = "Grafik Distribusi Outcome per Kelompok", status = "primary", shinycssloaders::withSpinner(plotlyOutput("assoc_distribution_plot", height = 340))),
          box(width = 6, title = "Grafik Interval Kepercayaan", status = "warning", shinycssloaders::withSpinner(plotlyOutput("assoc_ci_plot", height = 340)))
        ),
        fluidRow(
          box(width = 8, title = "Tabel Ringkasan Lengkap", status = "primary", shinycssloaders::withSpinner(DTOutput("association_table"))),
          box(width = 4, title = "Interpretasi Asosiasi", status = "info", div(class = "interpretation", htmlOutput("association_interpretation")))
        )
      ),
      tabItem(
        tabName = "hypothesis",
        fluidRow(
          box(width = 8, title = "Hasil Uji Hipotesis", status = "primary", shinycssloaders::withSpinner(DTOutput("hypothesis_table"))),
          box(width = 4, title = "Interpretasi Uji", status = "info", div(class = "interpretation", htmlOutput("hypothesis_interpretation")))
        )
      ),
      tabItem(
        tabName = "logistic",
        fluidRow(
          box(width = 8, title = "Koefisien Model Regresi Logistik", status = "primary", shinycssloaders::withSpinner(DTOutput("logistic_table"))),
          box(width = 4, title = "Model dan Interpretasi", status = "info", verbatimTextOutput("model_formula"), div(class = "interpretation", htmlOutput("logistic_interpretation")))
        )
      ),
      tabItem(
        tabName = "visual",
        fluidRow(
          box(width = 6, title = "Grouped Bar Chart", status = "primary", shinycssloaders::withSpinner(plotlyOutput("bar_plot", height = 340))),
          box(width = 6, title = "Stacked Bar Chart", status = "success", shinycssloaders::withSpinner(plotlyOutput("stacked_bar_plot", height = 340)))
        ),
        fluidRow(
          box(width = 6, title = "100% Stacked Bar Chart", status = "info", shinycssloaders::withSpinner(plotlyOutput("stacked100_bar_plot", height = 340))),
          box(width = 6, title = "Mosaic Plot", status = "success", shinycssloaders::withSpinner(plotlyOutput("mosaic_plot", height = 340)))
        ),
        fluidRow(
          box(width = 6, title = "Heatmap Frekuensi", status = "info", shinycssloaders::withSpinner(plotlyOutput("heat_freq", height = 340))),
          box(width = 6, title = "Heatmap Proporsi", status = "warning", shinycssloaders::withSpinner(plotlyOutput("heat_prop", height = 340)))
        ),
        fluidRow(
          box(width = 6, title = "Residual Plot", status = "danger", shinycssloaders::withSpinner(plotlyOutput("residual_plot", height = 340))),
          box(width = 6, title = "Association Plot", status = "primary", shinycssloaders::withSpinner(plotlyOutput("association_plot", height = 340)))
        )
      ),
      tabItem(
        tabName = "export",
        fluidRow(
          box(
            width = 4,
            title = "Export Laporan",
            status = "primary",
            downloadButton("download_pdf", "PDF"),
            downloadButton("download_word", "Word"),
            downloadButton("download_excel", "Excel")
          ),
          box(
            width = 8,
            title = "Export PNG Grafik",
            status = "info",
            selectInput(
              "png_plot",
              "Pilih grafik",
              choices = c(
                "Grouped Bar Chart" = "grouped",
                "Stacked Bar Chart" = "stacked",
                "100% Stacked Bar Chart" = "stacked100",
                "Mosaic Plot" = "mosaic",
                "Heatmap Frekuensi" = "heatfreq",
                "Heatmap Proporsi" = "heatprop",
                "Residual Plot" = "residual",
                "Association Plot" = "association"
              )
            ),
            downloadButton("download_png", "PNG")
          )
        )
      ),
      tabItem(
        tabName = "conclusion",
        fluidRow(box(width = 12, title = "Kesimpulan Otomatis untuk Laporan Penelitian", status = "primary", div(class = "interpretation", htmlOutput("final_conclusion"))))
      )
    )
  ),
  footer = dashboardFooter(left = "Final Project Komputasi Statistika", right = "R Shiny + bs4Dash + Plotly")
)
