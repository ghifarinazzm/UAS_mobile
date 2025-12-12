# 🍳 Aplikasi Resep Makanan (UAS Mobile Programming)

Aplikasi ini adalah pengembangan lanjutan dari proyek UTS, yang kini telah diintegrasikan dengan **RESTful API Publik** dan menggunakan **State Management (Provider)**. Aplikasi ini memungkinkan pengguna untuk mencari resep dari internet serta mengelola menu resep buatan sendiri.

## 🚀 Fitur Utama

Berbeda dengan versi UTS yang menggunakan data statis, versi UAS ini memiliki fitur:

1.  **Integrasi RESTful API (TheMealDB)**
    * Data resep diambil secara *real-time* dari internet.
    * Fitur **Pencarian (Search)** berfungsi live ke server API.
    * Indikator Loading, Success, dan Error Handling saat mengambil data.

2.  **State Management dengan Provider**
    * Menggunakan pola arsitektur **MVVM** (Model-View-ViewModel).
    * Pemisahan logika bisnis (`providers`), logika data (`services`), dan tampilan (`pages`).

3.  **Simulasi Role-Based Login**
    * **Admin:** Memiliki akses penuh (Bisa Menambah, Mengedit, dan **Menghapus** resep).
    * **User:** Akses terbatas (Bisa Menambah dan Mengedit, tapi **tidak bisa Menghapus**).

4.  **CRUD Data Lokal (Menu Saya)**
    * Fitur tambahan untuk membuat resep sendiri.
    * **Create:** Tambah resep baru.
    * **Read:** Lihat detail resep.
    * **Update:** Edit resep yang sudah dibuat.
    * **Delete:** Hapus resep (Dibatasi berdasarkan role).

## 🛠️ Teknologi & Library

* **Framework:** Flutter SDK
* **Bahasa:** Dart
* **HTTP Request:** `package:http`
* **State Management:** `package:provider`

## 📡 Dokumentasi API

Aplikasi ini menggunakan layanan API publik dari **TheMealDB** (Gratis & Open Source).

* **Base URL:** `https://www.themealdb.com/api/json/v1/1/`
* **Endpoint yang digunakan:**
    * **Search Meal by Name (GET):**
        ```http
        [https://www.themealdb.com/api/json/v1/1/search.php?s=](https://www.themealdb.com/api/json/v1/1/search.php?s=){keyword}
        ```
        *Contoh:* Mencari resep ayam -> `.../search.php?s=chicken`

## 🔐 Akun Login (Simulasi)

Gunakan akun berikut untuk masuk ke dalam aplikasi:

| Role | Username | Password | Hak Akses |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin` | `admin` | Full Access (CRUD + Delete) |
| **User Biasa** | `user` | `user` | Limited Access (No Delete) |

## 📂 Struktur Proyek

Struktur folder disusun untuk memisahkan *Logic* dan *UI* (Clean Code):

```text
lib/
├── models/         # Model data (JSON Parsing)
├── pages/          # Halaman UI (View)
├── providers/      # State Management (ViewModel)
├── services/       # Logika HTTP Request (API)
├── widgets/        # Komponen UI yang dapat digunakan ulang
└── main.dart       # Entry point