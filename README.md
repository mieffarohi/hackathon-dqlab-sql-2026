**Preview**

Hackathon ini diselenggarakan oleh Academy DQLab sebagai sarana untuk menguji kemampuan peserta dalam menyelesaikan permasalahan bisnis menggunakan SQL. Kompetisi berfokus pada analisis data penjualan dan penerapan teknik statistik untuk mengidentifikasi anomali transaksi dalam struktur organisasi sales yang bersifat hierarkis.

Peserta diberikan studi kasus mengenai perusahaan distributor makanan kering yang mengalami ketidaksesuaian antara tingginya jumlah purchase order dengan realisasi penjualan. Untuk membantu menemukan akar permasalahan tersebut, peserta ditantang melakukan analisis data guna mendeteksi transaksi pemesanan yang tergolong outlier berdasarkan kelompok Sales Manager Level 2 menggunakan metode average (rata-rata), standard deviation, dan Z-score. Seluruh proses analisis wajib diselesaikan menggunakan query SQL yang kompatibel dengan MySQL 5.7 tanpa memanfaatkan fitur modern seperti CTE, recursion, maupun window function.

Task yang dikerjakan menggunakan database yang terdiri dari dua tabel utama, yaitu **nodes** yang menyimpan struktur hierarki organisasi sales dan **orders** yang berisi data transaksi pemesanan. Setiap transaksi harus dipetakan terlebih dahulu ke kelompok Sales Manager Level 2 sebelum dilakukan perhitungan statistik untuk menentukan apakah transaksi tersebut termasuk anomali atau tidak.

Hasil pengerjaan dituangkan pada file **jawaban.sql** yang berisi query lengkap untuk menghasilkan output sesuai spesifikasi soal. Output yang dihasilkan terdiri dari dua bagian utama dalam satu hasil query, yaitu:

* Ringkasan jumlah transaksi outlier untuk setiap Sales Manager Level 2.
* Detail transaksi outlier yang menampilkan informasi statistik seperti nilai order, rata-rata kelompok, standard deviation, jarak terhadap rata-rata, dan nilai Z-score.

Solusi dikembangkan sepenuhnya menggunakan SQL MySQL 5.7 dengan memanfaatkan temporary table, subquery, join, agregasi data, fungsi statistik `STDDEV_POP`, serta perhitungan Z-score untuk mengidentifikasi transaksi yang berada di luar batas **Average ± 3 × Standard Deviation**. Pendekatan ini memungkinkan deteksi anomali dilakukan secara akurat meskipun pada lingkungan database yang memiliki keterbatasan fitur analitik modern.
