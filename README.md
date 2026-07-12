<div align="center">

# 📊 Proyek Akhir Komputasi Statistik
## Dashboard Analisis Data Kategorik Berbasis R Shiny

**Kelompok 4 – Statistika 2024 B**  
**Program Studi Statistika**  
**Fakultas Matematika dan Ilmu Pengetahuan Alam**  
**Universitas Negeri Jakarta**

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![R Shiny](https://img.shields.io/badge/R%20Shiny-0099CC?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github)
![Statistics](https://img.shields.io/badge/Statistics-Data%20Analysis-success?style=for-the-badge)
![Academic Project](https://img.shields.io/badge/Academic-Project-orange?style=for-the-badge)

</div>

---

# 📖 Deskripsi Proyek

Dashboard ini merupakan aplikasi berbasis **R Shiny** yang dikembangkan sebagai **Proyek Akhir Mata Kuliah Komputasi Statistik**. Aplikasi dirancang untuk membantu pengguna melakukan **analisis data kategorik** secara interaktif tanpa harus menuliskan syntax R secara manual.

Pengguna dapat memasukkan data secara manual maupun mengunggah file CSV, kemudian aplikasi akan melakukan analisis statistik, menghasilkan visualisasi, serta memberikan interpretasi hasil secara otomatis.

---

# 🎯 Tujuan Pengembangan

- Mempermudah proses analisis data kategorik.
- Menyediakan antarmuka yang mudah digunakan.
- Menghasilkan analisis statistik secara otomatis.
- Menampilkan visualisasi data yang informatif.
- Mendukung proses pembelajaran analisis data kategorik menggunakan R Shiny.

---

# ✨ Fitur Aplikasi

## 📥 Input Data

- ✅ Input data manual
- ✅ Upload file CSV
- ✅ Validasi data
- ✅ Pembentukan tabel kontingensi otomatis

---

## 📊 Analisis Statistik

- ✅ Uji Chi-Square
- ✅ Fisher Exact Test
- ✅ Likelihood Ratio (G-Test)
- ✅ Continuity Correction
- ✅ McNemar Test (sesuai syarat)

---

## 📈 Ukuran Asosiasi

- ✅ Odds Ratio
- ✅ Relative Risk
- ✅ Phi Coefficient
- ✅ Cramer's V
- ✅ Contingency Coefficient
- ✅ Lambda
- ✅ Goodman-Kruskal Tau

---

## 📉 Visualisasi

- ✅ Bar Chart
- ✅ Mosaic Plot
- ✅ Heatmap
- ✅ Distribusi Frekuensi

---

## 📄 Output

- ✅ Ringkasan hasil analisis
- ✅ Interpretasi otomatis
- ✅ Tabel hasil statistik
- ✅ Export hasil analisis

---

# 🛠️ Teknologi yang Digunakan

| Teknologi | Fungsi |
|-----------|--------|
| R | Bahasa Pemrograman |
| R Shiny | Framework Web |
| bs4Dash | Dashboard Interface |
| DT | Interactive Data Table |
| ggplot2 | Visualisasi Data |
| DescTools | Analisis Statistik |
| epitools | Odds Ratio & Relative Risk |
| vcd | Visualisasi Data Kategorik |
| dplyr | Manipulasi Data |
| readr | Membaca CSV |
| readxl | Membaca Excel |

---

# 👨‍💻 Anggota Kelompok

| Nama | NIM | Peran |
|------|------|------|
| **Raffi Saputra** | **1314624074** | **Ketua Kelompok** |
| Josephine Lauren Priscilla | 1314624014 | Anggota |
| Elsa Mutiara Sari | 1314624046 | Anggota |
| I Kadek Raysia Putra Marsa | 1314624052 | Anggota |
| Nasywa Sofita | 1314624065 | Anggota |

---

# 👩‍🏫 Dosen Pengampu

**Faroh Ladayya, M.Si.**

---

# 🌳 Workflow Pengembangan

Repository ini dikelola menggunakan Git dan GitHub dengan alur pengembangan kolaboratif.

- Setiap anggota memiliki branch masing-masing.
- Setiap anggota melakukan commit sesuai kontribusinya.
- Perubahan diajukan melalui Pull Request.
- Seluruh perubahan digabungkan ke branch **main** setelah proses review.

---

# 📂 Struktur Repository

```text
Kelompok-4_Statistika-24B_Project-Komputasi-Statistik
│
├── app.R
├── README.md
├── data/
├── www/
└── documentation/
```

---

# 🚀 Cara Menjalankan Aplikasi

### 1. Clone Repository

```bash
git clone https://github.com/raffisaputra3731-alt/Kelompok-4_Statistika-24B_Project-Komputasi-Statistik.git
```

### 2. Install Package

```r
install.packages(c(
  "shiny",
  "bs4Dash",
  "DT",
  "dplyr",
  "ggplot2",
  "DescTools",
  "epitools",
  "vcd",
  "readr",
  "readxl"
))
```

### 3. Jalankan Aplikasi

```r
shiny::runApp()
```

atau buka file **app.R**, kemudian klik **Run App** pada RStudio.

---

# 🌐 Tautan Proyek

## 📂 Repository GitHub

**Repository:**  
https://github.com/raffisaputra3731-alt/Kelompok-4_Statistika-24B_Project-Komputasi-Statistik

---

## 🚀 Deploy R Shiny

**Akses aplikasi secara online:**  
https://raffisaputra.shinyapps.io/ProjectKomputasiStatistik_Kelompok4/

---

# 📸 Dokumentasi Aplikasi

Tambahkan screenshot aplikasi pada bagian ini, misalnya:

- 🏠 Halaman Beranda
- 📥 Input Manual
- 📄 Upload CSV
- 📊 Hasil Analisis
- 📈 Visualisasi
- 📤 Export Hasil

---

# 📜 Lisensi

Repository ini dikembangkan sebagai **Proyek Akhir Mata Kuliah Komputasi Statistik** Program Studi Statistika, Fakultas Matematika dan Ilmu Pengetahuan Alam, Universitas Negeri Jakarta.

Seluruh isi repository digunakan untuk **kepentingan akademik dan pembelajaran**.

---

<div align="center">

### ⭐ Terima kasih telah mengunjungi repository ini ⭐

**Kelompok 4 — Statistika 2024 B**  
**Universitas Negeri Jakarta**

</div>
