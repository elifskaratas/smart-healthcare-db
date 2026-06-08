-- Smart Healthcare Management System
-- SQL Server | Queries
-- -------------------------------------------------------

USE SmartHealthcareDB;
GO

-- 2'den fazla tamamlanmış randevusu olan doktorlar
SELECT
    d.DoctorID,
    u.FirstName + ' ' + u.LastName AS DoctorName,
    d.Specialty,
    COUNT(a.AppointmentID) AS CompletedAppointments
FROM Doctor d
JOIN [User] u      ON d.UserID = u.UserID
JOIN Appointment a ON d.DoctorID = a.DoctorID
WHERE a.Status = 'Completed'
GROUP BY d.DoctorID, u.FirstName, u.LastName, d.Specialty
HAVING COUNT(a.AppointmentID) > 2
ORDER BY CompletedAppointments DESC;
GO

-- Hiç randevusu olmayan hastalar (LEFT JOIN + NULL kontrolü)
SELECT
    p.PatientID,
    u.FirstName + ' ' + u.LastName AS PatientName,
    u.Email,
    p.BloodType
FROM Patient p
JOIN [User] u ON p.UserID = u.UserID
LEFT JOIN Appointment a ON p.PatientID = a.PatientID
WHERE a.AppointmentID IS NULL;
GO

-- En sık görülen tanılar
SELECT TOP 10
    Diagnosis,
    COUNT(*) AS DiagnosisCount
FROM Prescription
GROUP BY Diagnosis
ORDER BY DiagnosisCount DESC;
GO

-- Hastane bazında aylık gelir raporu
SELECT
    h.HospitalName,
    YEAR(b.BillDate)  AS BillYear,
    MONTH(b.BillDate) AS BillMonth,
    COUNT(b.BillID)   AS TotalBills,
    SUM(b.TotalAmount)   AS GrossRevenue,
    SUM(b.InsurancePaid) AS InsuranceCovered,
    SUM(b.PatientOwes)   AS PatientRevenue
FROM Billing b
JOIN Appointment a ON b.AppointmentID = a.AppointmentID
JOIN Doctor d      ON a.DoctorID = d.DoctorID
JOIN Hospital h    ON d.HospitalID = h.HospitalID
GROUP BY h.HospitalName, YEAR(b.BillDate), MONTH(b.BillDate)
ORDER BY h.HospitalName, BillYear, BillMonth;
GO

-- Anormal lab sonuçları olan hastalar (High / Critical / Low)
SELECT DISTINCT
    u.FirstName + ' ' + u.LastName AS PatientName,
    lt.TestName,
    lr.Parameter,
    lr.Value,
    lr.Unit,
    lr.ReferenceRange,
    lr.Interpretation
FROM LabResult lr
JOIN LabTest lt ON lr.TestID = lt.TestID
JOIN Patient p  ON lt.PatientID = p.PatientID
JOIN [User] u   ON p.UserID = u.UserID
WHERE lr.Interpretation IN ('High','Critical','Low')
ORDER BY PatientName, lt.TestName;
GO

-- Hasta özet görünümü: randevu, reçete, fatura sayıları tek sorguda
SELECT
    u.FirstName + ' ' + u.LastName AS PatientName,
    p.BloodType,
    (SELECT COUNT(*) FROM Appointment   a  WHERE a.PatientID  = p.PatientID) AS TotalAppointments,
    (SELECT COUNT(*) FROM Prescription  pr WHERE pr.PatientID = p.PatientID) AS TotalPrescriptions,
    (SELECT COUNT(*) FROM MedicalHistory mh WHERE mh.PatientID = p.PatientID) AS HistoryEntries,
    (SELECT ISNULL(SUM(b.TotalAmount),0) FROM Billing b WHERE b.PatientID = p.PatientID) AS TotalBilled,
    ins.ProviderName AS InsuranceProvider
FROM Patient p
JOIN [User] u ON p.UserID = u.UserID
LEFT JOIN Insurance ins ON p.InsuranceID = ins.InsuranceID
ORDER BY TotalAppointments DESC;
GO

-- Her doktorun baktığı benzersiz hasta sayısı
SELECT
    u.FirstName + ' ' + u.LastName AS DoctorName,
    d.Specialty,
    h.HospitalName,
    COUNT(DISTINCT a.PatientID) AS UniquePatients,
    COUNT(a.AppointmentID)      AS TotalAppointments
FROM Doctor d
JOIN [User] u      ON d.UserID = u.UserID
JOIN Hospital h    ON d.HospitalID = h.HospitalID
JOIN Appointment a ON d.DoctorID = a.DoctorID
GROUP BY u.FirstName, u.LastName, d.Specialty, h.HospitalName
ORDER BY UniquePatients DESC;
GO

-- Sigortanın karşılamadığı payı %20'yi geçen hastalar
SELECT
    u.FirstName + ' ' + u.LastName AS PatientName,
    ins.ProviderName,
    ins.CoverageType,
    SUM(b.TotalAmount)   AS TotalBilled,
    SUM(b.InsurancePaid) AS TotalInsurancePaid,
    SUM(b.PatientOwes)   AS TotalPatientOwes,
    CAST(SUM(b.PatientOwes)*100.0/NULLIF(SUM(b.TotalAmount),0) AS DECIMAL(5,2)) AS PatientSharePct
FROM Billing b
JOIN Patient p     ON b.PatientID = p.PatientID
JOIN [User] u      ON p.UserID = u.UserID
JOIN Insurance ins ON b.InsuranceID = ins.InsuranceID
GROUP BY u.FirstName, u.LastName, ins.ProviderName, ins.CoverageType
HAVING SUM(b.PatientOwes)*100.0/NULLIF(SUM(b.TotalAmount),0) > 20
ORDER BY PatientSharePct DESC;
GO

-- Kronik hastalar: geçerli reçetesi olan ve en az 2 tamamlanmış randevusu bulunanlar
SELECT
    u.FirstName + ' ' + u.LastName AS PatientName,
    mh.Condition,
    mh.Status AS ConditionStatus,
    pr.Diagnosis,
    pr.IssueDate,
    pr.ExpiryDate
FROM MedicalHistory mh
JOIN Patient p      ON mh.PatientID = p.PatientID
JOIN [User] u       ON p.UserID = u.UserID
JOIN Prescription pr ON pr.PatientID = p.PatientID
WHERE mh.Status = 'Chronic'
  AND pr.ExpiryDate >= CAST(GETDATE() AS DATE)
  AND pr.PatientID IN (
      SELECT PatientID FROM Appointment
      WHERE Status = 'Completed'
      GROUP BY PatientID
      HAVING COUNT(*) >= 2
  )
ORDER BY PatientName;
GO

-- Departman iş yükü: aylık randevu sayısı ve ortalama fatura
SELECT
    h.HospitalName,
    dep.DeptName,
    YEAR(a.AppointmentDate)  AS Yr,
    MONTH(a.AppointmentDate) AS Mo,
    COUNT(a.AppointmentID)      AS AppointmentCount,
    COUNT(DISTINCT a.PatientID) AS UniquePatients,
    ISNULL(AVG(b.TotalAmount),0) AS AvgBillAmount
FROM Appointment a
JOIN Doctor d       ON a.DoctorID = d.DoctorID
JOIN Department dep ON d.DepartmentID = dep.DepartmentID
JOIN Hospital h     ON d.HospitalID = h.HospitalID
LEFT JOIN Billing b ON a.AppointmentID = b.AppointmentID
GROUP BY h.HospitalName, dep.DeptName, YEAR(a.AppointmentDate), MONTH(a.AppointmentDate)
HAVING COUNT(a.AppointmentID) >= 1
ORDER BY h.HospitalName, dep.DeptName, Yr, Mo;
GO

-- Onkoloji testinde yüksek sonuç çıkan kanser tanılı hastalar (EXISTS)
SELECT DISTINCT
    u.FirstName + ' ' + u.LastName AS PatientName,
    p.PatientID,
    mh.Condition
FROM Patient p
JOIN [User] u          ON p.UserID = u.UserID
JOIN MedicalHistory mh ON p.PatientID = mh.PatientID
WHERE mh.Condition LIKE '%Cancer%'
  AND EXISTS (
      SELECT 1
      FROM LabTest lt
      JOIN LabResult lr ON lt.TestID = lr.TestID
      WHERE lt.PatientID = p.PatientID
        AND lr.Interpretation = 'High'
        AND lt.TestType = 'Oncology'
  );
GO

-- Şema güncellemeleri
ALTER TABLE Patient     ADD EmergencyRelation NVARCHAR(50);
ALTER TABLE Appointment ADD Duration INT DEFAULT 30;
ALTER TABLE Doctor      ADD ConsultationFee DECIMAL(8,2) DEFAULT 200.00;
GO

PRINT 'All queries executed successfully.';
GO
