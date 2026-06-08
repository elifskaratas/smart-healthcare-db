# Smart Healthcare Management System

SQL Server üzerinde geliştirilmiş ilişkisel bir sağlık yönetim sistemi. Hastane, doktor, hasta, randevu, laboratuvar ve faturalandırma süreçlerini kapsayan 14 tablolu bir şema içeriyor.

## Şema

EER diyagramında `User` süpersınıfından `Patient`, `Doctor` ve `Admin` alt sınıfları türetildi. Hesaplanmış sütun (`PatientOwes`), weak entity ilişkileri (`Prescription → Medication`, `LabTest → LabResult`) ve çoklu foreign key zincirleri uygulandı.

**Tablolar:** Hospital · Department · User · Patient · Doctor · Admin · Insurance · Appointment · Prescription · Medication · LabTest · LabResult · MedicalHistory · Billing

## Dosyalar

| Dosya | İçerik |
|-------|--------|
| `01_create_tables.sql` | Şema tanımı, constraint'ler, foreign key'ler |
| `02_insert_data.sql` | Örnek veri |
| `03_queries.sql` | 12 sorgu — JOIN, subquery, EXISTS, GROUP BY/HAVING, ALTER TABLE |
| `04_indexing.sql` | B+ tree nonclustered index'ler, filtered index'ler, performans karşılaştırması, Relational Algebra karşılıkları |

## Öne Çıkan Sorgular

- Tamamlanmış randevusu 2'den fazla olan doktorlar (GROUP BY + HAVING)
- Hiç randevusu olmayan hastalar (LEFT JOIN + NULL kontrolü)
- Sigortanın %20'den fazlasını karşılamadığı faturalar (NULLIF, HAVING üzerinde ifade)
- Kronik hastalar: geçerli reçetesi olan ve birden fazla tamamlanmış randevusu bulunanlar (iç içe subquery)
- Anormal lab sonuçları olan hastalar (EXISTS)
- Hasta özet görünümü: SELECT içinde birden fazla scalar subquery

## Index Stratejisi

Sık sorgulanan sütunlara (`PatientID`, `DoctorID`, `Status`, `Specialty`) covering index eklendi. `INCLUDE` ile secondary lookup önlendi. SQL Server'ın hash index desteği olmadığından filtered index ile benzer davranış sağlandı. `SET STATISTICS IO/TIME` ile table scan vs index karşılaştırması yapıldı.

## Kullanım

```sql
-- Sırayla çalıştır:
01_create_tables.sql
02_insert_data.sql
03_queries.sql
04_indexing.sql
```

SQL Server 2019+ ve SQL Server Management Studio (SSMS) ile test edildi.
