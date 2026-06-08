-- Smart Healthcare Management System
-- SQL Server | Indexing & Query Optimization
-- 

USE SmartHealthcareDB;
GO

-- En sık sorgulanan sütunlara nonclustered B+ tree index
-- INCLUDE ile sorgu sadece index'ten karşılanır, tabloya gitmez (covering index)

CREATE NONCLUSTERED INDEX IX_Appointment_PatientID
    ON Appointment(PatientID)
    INCLUDE (AppointmentDate, Status);

CREATE NONCLUSTERED INDEX IX_Appointment_DoctorID
    ON Appointment(DoctorID)
    INCLUDE (AppointmentDate, Status);

CREATE NONCLUSTERED INDEX IX_Appointment_Date
    ON Appointment(AppointmentDate DESC)
    INCLUDE (PatientID, DoctorID, Status);

CREATE NONCLUSTERED INDEX IX_Prescription_PatientID
    ON Prescription(PatientID)
    INCLUDE (IssueDate, ExpiryDate, Diagnosis);

CREATE NONCLUSTERED INDEX IX_Prescription_ExpiryDate
    ON Prescription(ExpiryDate)
    INCLUDE (PatientID, DoctorID);

CREATE NONCLUSTERED INDEX IX_LabTest_PatientID
    ON LabTest(PatientID)
    INCLUDE (TestName, Status, OrderedDate);

CREATE NONCLUSTERED INDEX IX_LabResult_Interpretation
    ON LabResult(Interpretation)
    INCLUDE (TestID, Parameter, Value);

CREATE NONCLUSTERED INDEX IX_Billing_PatientID
    ON Billing(PatientID)
    INCLUDE (TotalAmount, Status, BillDate);

CREATE NONCLUSTERED INDEX IX_Billing_Status
    ON Billing(Status)
    INCLUDE (PatientID, TotalAmount, BillDate);

CREATE NONCLUSTERED INDEX IX_Doctor_Specialty
    ON Doctor(Specialty)
    INCLUDE (HospitalID, DepartmentID, DoctorType);

-- Login sorgularında email eşleşmesi için unique index
CREATE UNIQUE NONCLUSTERED INDEX IX_User_Email
    ON [User](Email);

-- SQL Server'da hash index doğrudan desteklenmez; filtered index ile benzer davranış sağlanır
-- Equality lookup için UserType + UserID üzerinde, sadece geçerli tipler kapsanır
CREATE NONCLUSTERED INDEX IX_User_UserType
    ON [User](UserType, UserID)
    WHERE UserType IN ('Patient','Doctor','Admin');

-- Aktif hasta kayıtlarına hızlı erişim için filtered index
CREATE NONCLUSTERED INDEX IX_Patient_Active
    ON [User](UserID, Email)
    WHERE IsActive = 1 AND UserType = 'Patient';

-- Performans karşılaştırması: table scan vs index
--                    

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Table scan (index kullanımı zorla devre dışı)
SELECT * FROM Appointment WITH (INDEX(0))
WHERE PatientID = 1 AND Status = 'Completed';
GO

-- Index ile aynı sorgu
SELECT * FROM Appointment WITH (INDEX(IX_Appointment_PatientID))
WHERE PatientID = 1 AND Status = 'Completed';
GO

-- Uzmanlık alanına göre doktor arama
SELECT d.DoctorID, u.FirstName, u.LastName
FROM Doctor d WITH (INDEX(IX_Doctor_Specialty))
JOIN [User] u ON d.UserID = u.UserID
WHERE d.Specialty = 'Cardiology';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

--  Relational Algebra karşılıkları (SQL olarak)
-- 

-- σ(Status='Completed')(Appointment) ⋈ π(DoctorID,Specialty)(Doctor)
SELECT a.AppointmentID, a.PatientID, a.AppointmentDate, d.Specialty
FROM Appointment a
JOIN Doctor d ON a.DoctorID = d.DoctorID
WHERE a.Status = 'Completed';
GO

-- π(PatientID, Diagnosis)(Prescription)
SELECT DISTINCT PatientID, Diagnosis FROM Prescription;
GO

-- Patient ⋈ Billing (natural join on PatientID)
SELECT p.PatientID, u.FirstName, u.LastName, b.TotalAmount, b.Status
FROM Patient p
JOIN [User] u  ON p.UserID = u.UserID
JOIN Billing b ON p.PatientID = b.PatientID;
GO

-- Patient − π(PatientID)(Appointment): randevusu olmayan hastalar
SELECT p.PatientID, u.FirstName + ' ' + u.LastName AS Name
FROM Patient p
JOIN [User] u ON p.UserID = u.UserID
WHERE p.PatientID NOT IN (SELECT DISTINCT PatientID FROM Appointment);
GO

-- γ(DoctorID, COUNT(*))(Appointment)
SELECT DoctorID, COUNT(*) AS AppCount
FROM Appointment
GROUP BY DoctorID;
GO

-- TRC: en az bir tamamlanmış randevusu olan hastalar
-- { t | ∃a ∈ Appointment (a.PatientID = t.PatientID ∧ a.Status = 'Completed') }
SELECT DISTINCT p.PatientID, u.FirstName, u.LastName
FROM Patient p
JOIN [User] u ON p.UserID = u.UserID
WHERE EXISTS (
    SELECT 1 FROM Appointment a
    WHERE a.PatientID = p.PatientID AND a.Status = 'Completed'
);
GO

PRINT 'Indexing and RA/TRC queries completed.';
GO
