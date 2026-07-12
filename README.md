<div align="center">

<img src="download.png" alt="Logo Universitas Negeri Jakarta" width="170"/>

# 📊 Proyek Akhir Komputasi Statistik
## Dashboard Analisis Data Kategorik Berbasis R Shiny

**Kelompok 4 – Statistika 2024 B**

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![R Shiny](https://img.shields.io/badge/R%20Shiny-0099CC?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github)
![Statistics](https://img.shields.io/badge/Statistics-Analysis-success?style=for-the-badge)
![Academic Project](https://img.shields.io/badge/Academic-Project-orange?style=for-the-badge)

</div>

---

# 📖 Deskripsi Proyek

Aplikasi ini merupakan **dashboard interaktif berbasis R Shiny** yang dikembangkan sebagai **Proyek Akhir Mata Kuliah Komputasi Statistik** Program Studi Statistika Universitas Negeri Jakarta.

Dashboard ini dirancang untuk mempermudah mahasiswa, dosen, maupun peneliti dalam melakukan **analisis data kategorik** secara cepat, interaktif, dan tanpa harus menuliskan syntax R secara manual.

Pengguna cukup mengunggah data atau memasukkan data secara manual, kemudian aplikasi akan melakukan berbagai analisis statistik secara otomatis beserta interpretasi hasilnya.

---

# 🎯 Tujuan Pengembangan

- Mempermudah analisis data kategorik secara interaktif.
- Mengurangi kesalahan perhitungan manual.
- Menyediakan interpretasi hasil secara otomatis.
- Menampilkan visualisasi data yang informatif.
- Mendukung proses pembelajaran Analisis Data Kategorik.

---

# ✨ Fitur Aplikasi

## 📥 Input Data

- ✅ Input Data Manual
- ✅ Upload CSV
- ✅ Validasi Data
- ✅ Pembentukan Tabel Kontingensi Otomatis

---

## 📊 Analisis Statistik

- ✅ Uji Chi-Square
- ✅ Fisher Exact Test
- ✅ Likelihood Ratio (G-Test)
- ✅ Continuity Correction
- ✅ McNemar Test (jika memenuhi syarat)

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

- ✅ Ringkasan Statistik
- ✅ Interpretasi Otomatis
- ✅ Tabel Hasil Analisis
- ✅ Export Hasil

---

# 🛠️ Teknologi yang Digunakan

| Teknologi | Keterangan |
|-----------|------------|
| R | Bahasa Pemrograman |
| R Shiny | Framework Dashboard |
| bs4Dash | Dashboard UI |
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

# 🌳 Workflow GitHub

Repository ini dikelola menggunakan workflow Git.

- Setiap anggota memiliki branch masing-masing.
- Setiap anggota melakukan commit sesuai kontribusinya.
- Perubahan diajukan melalui Pull Request.
- Seluruh perubahan digabungkan ke branch **main** setelah proses review.

---

# 📂 Struktur Repository

```
Kelompok-4_Statistika-24B_Project-Komputasi-Statistik
│
├── app.R
├── README.md
├── data/
├── www/
├── assets/
└── documentation/
```

---

# 🚀 Cara Menjalankan

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
  "readxl",
  "readr",
  "vcd"
))
```

### 3. Jalankan Aplikasi

```r
shiny::runApp()
```

atau buka file

```
app.R
```

kemudian klik

```
Run App
```

---

# 🌐 Deploy Aplikasi

## GitHub Repository

https://github.com/raffisaputra3731-alt/Kelompok-4_Statistika-24B_Project-Komputasi-Statistik

## R Shiny Apps

https://raffisaputra.shinyapps.io/ProjectKomputasiStatistik_Kelompok4/

---

# 📸 Tampilan Aplikasi

> Tambahkan screenshot aplikasi pada bagian ini.

Contoh:

- Halaman Beranda
- Input Manual
- Upload CSV
- Hasil Analisis
- Visualisasi
- Export

---

# 📜 Academic Project

Repository ini dikembangkan sebagai **Proyek Akhir Mata Kuliah Komputasi Statistik** Program Studi Statistika, Fakultas Matematika dan Ilmu Pengetahuan Alam, Universitas Negeri Jakarta.

Seluruh kode sumber disusun untuk tujuan akademik dan pembelajaran.

---

<div align="center">

### Universitas Negeri Jakarta

**Program Studi Statistika**

Kelompok 4 • 2026

</div>
