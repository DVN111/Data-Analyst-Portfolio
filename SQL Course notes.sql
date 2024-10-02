-- ==========================================
-- MySQL Course Notes
-- Course : MySQL Full Course for free 🐬 [from: Bro Code]
-- link   : (https://youtu.be/5OdVJbNCSso?si=sajc9gcwa4Iy12N3
-- Author: Muhammad Daniyal
-- Date: 30 Sep 2024 - 02 Oct 2024
-- Description: script ini berisi catatan saya selama mengikuti course. mencakup pembuatan database, manajemen tabel, manipulasi data, constraint, dan lainnya."
-- ==========================================

-- ** 1. Database Management **

-- Membuat database 
CREATE DATABASE myDB;

-- Akses database 
USE myDB;

-- Menjaga database supaya tidak dapat dihapus 
ALTER DATABASE myDB READ ONLY = 1;

-- Menghapus database
DROP DATABASE myDB;

-- ** 2. Tabel Management **

-- Membuat tabel 
CREATE TABLE karyawan (
    karyawan_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gaji_perjam INT,
    tanggal_hire DATE
);

-- Menampilkan data dari tabel
SELECT * FROM karyawan;

-- Mengganti nama tabel
RENAME TABLE pekerja TO karyawan; 

-- Menambahkan kolom baru 
ALTER TABLE karyawan ADD kota_asal VARCHAR(25);

-- Menambah kolom baru untuk menyimpan nama lengkap
ALTER TABLE karyawan ADD COLUMN full_name VARCHAR(50) AFTER last_name;

-- ** 3. Data Manipulation (DML) **

-- Menambahkan data atau record ke dalam tabel
INSERT INTO karyawan (karyawan_id, first_name, last_name)
VALUES 
(5, 'Patrick', 'Star'),
(2, 'Patrick', 'Star', 40.00, '2023-12-12'),
(3, 'Squidward', 'Tentacles', 60.00, '2023-01-02'),
(4, 'Sandy', 'Cheeks', 40.00, '2023-01-06');

-- Mengisi data yang kosong pada record tertentu
UPDATE karyawan 
SET gaji_perjam = 10, tanggal_hire='2023-01-04' 
WHERE karyawan_id=5; 

-- Menghapus data record dari tabel
DELETE FROM karyawan WHERE karyawan_id = 5;

-- ** 4. Query Data (DQL) **

-- Menampilkan karyawan yang gaji perjamnya kurang dari 50 
SELECT * FROM karyawan WHERE gaji_perjam < 50;

-- Menampilkan karyawan yang di-hire sebelum tanggal 10 Januari 2023
SELECT * FROM karyawan WHERE tanggal_hire <= "2023-01-10";

-- Menampilkan karyawan kecuali yang bernama awal Spongebob dan bernama akhir Tentacles
SELECT * FROM karyawan WHERE first_name != 'Spongebob' AND last_name != 'Tentacles';

-- Mengecek apakah ada nilai NULL dalam data 
SELECT * FROM karyawan WHERE tanggal_hire IS NULL;

-- Menampilkan karyawan dengan full name
SELECT CONCAT(first_name, " ", last_name) AS full_name FROM karyawan;

-- Mengambil data gaji per jam dan membandingkannya dengan rata-rata
SELECT 
    CONCAT(first_name, " ", last_name) AS full_name, 
    gaji_perjam, 
    (SELECT AVG(gaji_perjam) FROM karyawan) AS avg_gaji_perjam,
    CASE
        WHEN gaji_perjam > (SELECT AVG(gaji_perjam) FROM karyawan) THEN 'di atas rata-rata'
        WHEN gaji_perjam < (SELECT AVG(gaji_perjam) FROM karyawan) THEN 'di bawah rata-rata'
    END AS keterangan
FROM karyawan;

-- ** 5. Constraint Management **

-- Membuat tabel dengan constraint UNIQUE
CREATE TABLE products (
    id_product INT, 
    product_name VARCHAR(25) UNIQUE, 
    price DECIMAL(4,2)
);

-- Menambah constraint UNIQUE ke kolom dalam tabel
ALTER TABLE products ADD CONSTRAINT UNIQUE (product_name);

-- Menambah constraint NOT NULL pada kolom dalam tabel
ALTER TABLE products 
MODIFY id_product INT NOT NULL,
MODIFY product_name VARCHAR(25) NOT NULL,
MODIFY price DECIMAL(4,2) NOT NULL;

-- Menambah constraint CHECK pada tabel karyawan
ALTER TABLE karyawan 
ADD CONSTRAINT chk_gaji_perjam CHECK (gaji_perjam >= 2.00);

-- Menghapus constraint dari kolom dalam tabel
ALTER TABLE karyawan 
DROP CONSTRAINT chk_gaji_perjam;

-- ** 6. Primary Key dan Foreign Key Management **

-- Membuat tabel Users dengan primary key dan auto increment
CREATE TABLE Users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30),
    city VARCHAR(25)
);

-- Membuat tabel Transaksi dengan foreign key
CREATE TABLE transaksi (
    id_trans INT PRIMARY KEY AUTO_INCREMENT,
    jumlah DECIMAL(5,2),
    `datetime` DATETIME DEFAULT NOW(),
    id INT,
    FOREIGN KEY (id) REFERENCES Users(id)
);

-- Menambah foreign key ke tabel yang sudah ada
ALTER TABLE transaksi 
ADD CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES Users(id);

-- ** 7. Views Management **

-- Membuat view untuk karyawan dengan gaji tertinggi
CREATE VIEW top_3_karyawan_gaji_tertinggi AS
SELECT * FROM karyawan ORDER BY gaji_perjam DESC LIMIT 3;

-- Membuat view untuk pengguna yang paling menguntungkan
CREATE VIEW user_paling_menguntungkan AS
SELECT u.username, SUM(t.jumlah) AS `total keuntungan` 
FROM Users AS u 
JOIN transaksi AS t ON t.id = u.id 
GROUP BY u.username 
ORDER BY `total keuntungan` DESC LIMIT 10;

-- ** 8. Index Management **

-- Membuat index
CREATE INDEX last_name_first_name_idx ON karyawan(first_name, last_name);

-- Menghapus index
ALTER TABLE karyawan DROP INDEX last_name_first_name_idx;

-- ** 9. Stored Procedures **

-- Membuat stored procedure untuk mendapatkan semua karyawan
DELIMITER $$
CREATE PROCEDURE get_karyawan()
BEGIN 
    SELECT * FROM karyawan;
END$$
DELIMITER ;

-- Stored procedure dengan parameter untuk mencari karyawan
DELIMITER $$
CREATE PROCEDURE cari_karyawan(IN id INT)
BEGIN 
    SELECT * FROM karyawan WHERE karyawan_id = id;
END$$
DELIMITER ;

-- ** 10. Trigger Management **

-- Membuat trigger untuk menghitung gaji perjam
CREATE TRIGGER before_update_gaji_perjam 
BEFORE UPDATE ON karyawan
FOR EACH ROW
SET NEW.gaji = (NEW.gaji_perjam * 2080); 

-- ** 11. Joins dan Subqueries **

-- Menginsert data ke users
INSERT INTO users (username, city) VALUES 
('Kia', 'Malang'),
('John', 'Sidoarjo'),
('Aji', 'Banyuwangi'),
('Risky', 'Jakarta');

-- Menginsert data ke transaksi
INSERT INTO transaksi (jumlah, id) VALUES 
(10.00, 2),
(5.00, 2),
(200.00, 3),
(10.00, 4);

-- Menggunakan join untuk analisis transaksi
SELECT t.id_trans, t.jumlah, t.id, u.username 
FROM transaksi AS t
JOIN users AS u ON t.id = u.id;

-- Menggunakan left join untuk menampilkan seluruh transaksi
SELECT t.id_trans, t.jumlah, t.id, u.username 
FROM transaksi AS t
LEFT JOIN users AS u ON t.id = u.id;

-- Menggunakan right join untuk menampilkan seluruh pengguna
SELECT t.id_trans, t.jumlah, t.id, u.username 
FROM transaksi AS t
RIGHT JOIN users AS u ON t.id = u.id;

-- Subquery untuk menemukan pelanggan yang belum melakukan transaksi
SELECT username FROM users WHERE id NOT IN 
(SELECT DISTINCT id FROM transaksi WHERE id IS NOT NULL);

-- ** 12. Transactions Management **

-- Cara membuat checkpoint untuk data supaya bisa di rollback
SET AUTOCOMMIT = OFF; 
COMMIT; 
DELETE FROM karyawan; 
ROLLBACK; 

-- ** 13. Aggregate Functions dan Rollup **

-- Menggunakan ROLLUP untuk mendapatkan total keseluruhan
SELECT first_name, last_name, SUM(gaji_perjam) 
FROM karyawan 
GROUP BY first_name WITH ROLLUP;

SELECT id, SUM(jumlah) AS "total benefit" 
FROM transaksi 
GROUP BY id WITH ROLLUP;

-- ** 14. Cleanup **

-- Menghapus view
DROP VIEW top_3_karyawan_gaji_tertinggi;
DROP VIEW user_paling_menguntungkan;

-- Menghapus foreign key
ALTER TABLE transaksi DROP FOREIGN KEY fk_id;

-- Menghapus data pengguna tertentu
DELETE FROM users WHERE id = 2;

-- ** 15. Other Notes **

-- Fungsi untuk mendapatkan tanggal saat ini
SELECT CURRENT_DATE(), CURRENT_TIME(), NOW();
