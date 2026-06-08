-- ============================================================
-- File 2: Sample Data (30+ records per major table)
-- ============================================================
USE SmartHealthcareDB;
GO

-- HOSPITALS
INSERT INTO Hospital (HospitalName, Address, City, Phone, Email, EstablishedY) VALUES
('City General Hospital',     '14 Atatürk Blvd',    'Istanbul', '02121110001', 'info@citygeneral.com',   1968),
('North Medical Center',      '88 Republic Ave',    'Ankara',   '03124440002', 'contact@northmed.com',   1975),
('Coastal Health Institute',  '5 Seaside Road',     'Izmir',    '02329990003', 'admin@coastalhi.com',    1990);

-- DEPARTMENTS
INSERT INTO Department (HospitalID, DeptName, Location, Phone) VALUES
(1, 'Cardiology',       'Block A, Floor 2', '02121110011'),
(1, 'Neurology',        'Block B, Floor 3', '02121110012'),
(1, 'General Surgery',  'Block C, Floor 1', '02121110013'),
(1, 'Orthopedics',      'Block A, Floor 4', '02121110014'),
(1, 'Pediatrics',       'Block D, Floor 1', '02121110015'),
(2, 'Internal Medicine','Wing 1, Floor 2',  '03124440021'),
(2, 'Oncology',         'Wing 2, Floor 3',  '03124440022'),
(3, 'Dermatology',      'Unit A',           '02329990031'),
(3, 'Ophthalmology',    'Unit B',           '02329990032');

-- INSURANCE
INSERT INTO Insurance (ProviderName, PolicyNumber, CoverageType, StartDate, EndDate, CoverageLimit) VALUES
('TürkSağlık Plus',    'TSP-10001', 'Comprehensive',  '2023-01-01','2026-01-01', 50000.00),
('MediGuard Gold',     'MGG-20002', 'Standard',       '2022-06-01','2025-06-01', 30000.00),
('AnadoluSigorta',     'ANS-30003', 'Basic',          '2024-01-01','2027-01-01', 20000.00),
('GlobalHealth Cover', 'GHC-40004', 'Comprehensive',  '2023-09-01','2026-09-01', 75000.00),
('StateSocialInsur',   'SSI-50005', 'State',          '2020-01-01','2027-01-01', 15000.00);

-- USERS (superclass)
INSERT INTO [User] (FirstName, LastName, Email, Phone, PasswordHash, UserType) VALUES
-- Patients (1-10)
('Ahmet',   'Yılmaz',   'ahmet.yilmaz@mail.com',   '05321234501', 'hashed_pw_1',  'Patient'),
('Fatma',   'Kaya',     'fatma.kaya@mail.com',      '05321234502', 'hashed_pw_2',  'Patient'),
('Mehmet',  'Demir',    'mehmet.demir@mail.com',    '05321234503', 'hashed_pw_3',  'Patient'),
('Ayşe',    'Çelik',    'ayse.celik@mail.com',      '05321234504', 'hashed_pw_4',  'Patient'),
('Mustafa', 'Şahin',    'mustafa.sahin@mail.com',   '05321234505', 'hashed_pw_5',  'Patient'),
('Zeynep',  'Arslan',   'zeynep.arslan@mail.com',   '05321234506', 'hashed_pw_6',  'Patient'),
('İbrahim', 'Doğan',    'ibrahim.dogan@mail.com',   '05321234507', 'hashed_pw_7',  'Patient'),
('Elif',    'Kurt',     'elif.kurt@mail.com',       '05321234508', 'hashed_pw_8',  'Patient'),
('Burak',   'Öztürk',   'burak.ozturk@mail.com',   '05321234509', 'hashed_pw_9',  'Patient'),
('Selin',   'Erdoğan',  'selin.erdogan@mail.com',   '05321234510', 'hashed_pw_10', 'Patient'),
-- Doctors (11-20)
('Dr. Ali',    'Bozkurt',  'ali.bozkurt@hospital.com',  '05327777701', 'hashed_pw_11', 'Doctor'),
('Dr. Canan',  'Güneş',    'canan.gunes@hospital.com',  '05327777702', 'hashed_pw_12', 'Doctor'),
('Dr. Tarık',  'Aydın',    'tarik.aydin@hospital.com',  '05327777703', 'hashed_pw_13', 'Doctor'),
('Dr. Merve',  'Polat',    'merve.polat@hospital.com',  '05327777704', 'hashed_pw_14', 'Doctor'),
('Dr. Serkan', 'Yıldız',   'serkan.yildiz@hospital.com','05327777705', 'hashed_pw_15', 'Doctor'),
('Dr. Hande',  'Aksoy',    'hande.aksoy@hospital.com',  '05327777706', 'hashed_pw_16', 'Doctor'),
('Dr. Osman',  'Kılıç',    'osman.kilic@hospital.com',  '05327777707', 'hashed_pw_17', 'Doctor'),
('Dr. Pınar',  'Çetin',    'pinar.cetin@hospital.com',  '05327777708', 'hashed_pw_18', 'Doctor'),
('Dr. Volkan', 'Uçar',     'volkan.ucar@hospital.com',  '05327777709', 'hashed_pw_19', 'Doctor'),
('Dr. Seda',   'Bilgin',   'seda.bilgin@hospital.com',  '05327777710', 'hashed_pw_20', 'Doctor'),
-- Admins (21-23)
('Admin',  'Root',    'admin.root@citygeneral.com',  '05300000001', 'hashed_pw_21', 'Admin'),
('System', 'Manager', 'sys.manager@northmed.com',   '05300000002', 'hashed_pw_22', 'Admin'),
('Data',   'Officer', 'data.officer@coastalhi.com', '05300000003', 'hashed_pw_23', 'Admin');

-- PATIENTS
INSERT INTO Patient (UserID, DateOfBirth, Gender, BloodType, Address, EmergencyContact, InsuranceID) VALUES
(1,  '1985-03-15', 'Male',   'A+',  '12 Oak Street, Istanbul',  'Wife: 05399990001', 1),
(2,  '1990-07-22', 'Female', 'B+',  '7 Pine Ave, Istanbul',     'Husband: 05399990002', 2),
(3,  '1978-11-05', 'Male',   'O+',  '34 Elm Blvd, Ankara',      'Sister: 05399990003', 3),
(4,  '1995-01-30', 'Female', 'AB-', '55 Cedar Rd, Ankara',      'Mother: 05399990004', 1),
(5,  '1965-09-12', 'Male',   'A-',  '88 Birch Lane, Izmir',     'Son: 05399990005',    4),
(6,  '2000-04-18', 'Female', 'O-',  '3 Maple Drive, Istanbul',  'Father: 05399990006', 5),
(7,  '1982-12-25', 'Male',   'B-',  '19 Walnut St, Istanbul',   'Wife: 05399990007',   2),
(8,  '1998-08-08', 'Female', 'A+',  '62 Spruce Ave, Ankara',    'Brother: 05399990008',3),
(9,  '1973-06-14', 'Male',   'AB+', '77 Aspen Rd, Izmir',       'Wife: 05399990009',   4),
(10, '1988-02-27', 'Female', 'B+',  '4 Willow Way, Istanbul',   'Mother: 05399990010', 1);

-- DOCTORS
INSERT INTO Doctor (UserID, Specialty, LicenseNo, DepartmentID, HospitalID, Availability, DoctorType, SubSpecialty, CertNo, SurgeryType, ORClearance) VALUES
(11, 'Cardiology',       'LIC-C001', 1, 1, 'Mon-Fri 09-17', 'Specialist',          'Interventional Cardiology', 'CERT-IC01', NULL,           0),
(12, 'Neurology',        'LIC-N002', 2, 1, 'Mon-Thu 08-16', 'Specialist',          'Epileptology',              'CERT-EP02', NULL,           0),
(13, 'General Surgery',  'LIC-S003', 3, 1, 'Mon-Fri 07-15', 'Surgeon',             NULL,                        NULL,        'Laparoscopic', 1),
(14, 'Orthopedics',      'LIC-O004', 4, 1, 'Tue-Sat 10-18', 'Specialist',          'Spine Surgery',             'CERT-SS04', NULL,           0),
(15, 'Pediatrics',       'LIC-P005', 5, 1, 'Mon-Fri 09-17', 'GeneralPractitioner', NULL,                        NULL,        NULL,           0),
(16, 'Internal Medicine','LIC-I006', 6, 2, 'Mon-Fri 08-16', 'GeneralPractitioner', NULL,                        NULL,        NULL,           0),
(17, 'Oncology',         'LIC-K007', 7, 2, 'Mon-Wed 09-15', 'Specialist',          'Medical Oncology',          'CERT-MO07', NULL,           0),
(18, 'Dermatology',      'LIC-D008', 8, 3, 'Mon-Fri 10-18', 'Specialist',          'Cosmetic Dermatology',      'CERT-CD08', NULL,           0),
(19, 'Ophthalmology',    'LIC-E009', 9, 3, 'Mon-Fri 09-17', 'Surgeon',             NULL,                        NULL,        'Refractive',   1),
(20, 'Cardiology',       'LIC-C010', 1, 1, 'Wed-Sun 08-16', 'Surgeon',             NULL,                        NULL,        'Open-Heart',   1);

-- ADMINS
INSERT INTO Admin (UserID, Role, HospitalID, AccessLevel) VALUES
(21, 'IT Administrator',   1, 'SuperAdmin'),
(22, 'Operations Manager', 2, 'Senior'),
(23, 'Data Compliance',    3, 'Standard');

-- APPOINTMENTS (30 records)
INSERT INTO Appointment (PatientID, DoctorID, AppointmentDate, Status, Notes, RoomNo) VALUES
(1,  1,  '2025-01-10 09:00', 'Completed', 'Routine cardiac checkup',          'A201'),
(2,  2,  '2025-01-12 10:30', 'Completed', 'Headache and dizziness',           'B301'),
(3,  3,  '2025-01-15 08:00', 'Completed', 'Appendectomy follow-up',           'C101'),
(4,  4,  '2025-01-18 14:00', 'Completed', 'Back pain consultation',           'A401'),
(5,  5,  '2025-01-20 09:30', 'Completed', 'Annual pediatric checkup',         'D101'),
(6,  6,  '2025-02-01 11:00', 'Completed', 'Fever and fatigue',                'W201'),
(7,  7,  '2025-02-05 09:00', 'Completed', 'Chemotherapy session 1',           'W301'),
(8,  8,  '2025-02-10 15:00', 'Completed', 'Skin rash evaluation',             'UA01'),
(9,  9,  '2025-02-14 10:00', 'Completed', 'Vision correction consultation',   'UB01'),
(10, 10, '2025-02-20 09:00', 'Completed', 'Chest pain evaluation',            'A202'),
(1,  1,  '2025-03-05 09:00', 'Completed', 'Echocardiogram follow-up',         'A201'),
(2,  6,  '2025-03-08 11:00', 'Completed', 'Blood pressure management',        'W202'),
(3,  3,  '2025-03-12 08:30', 'Completed', 'Post-op hernia repair',            'C102'),
(4,  2,  '2025-03-15 10:00', 'Cancelled', 'Patient cancelled',                'B302'),
(5,  5,  '2025-03-20 09:00', 'Completed', 'Vaccination schedule',             'D102'),
(6,  8,  '2025-04-02 14:00', 'Completed', 'Acne treatment follow-up',         'UA02'),
(7,  7,  '2025-04-07 09:00', 'Completed', 'Chemotherapy session 2',           'W302'),
(8,  4,  '2025-04-10 13:00', 'Completed', 'Knee pain — sports injury',        'A402'),
(9,  9,  '2025-04-15 10:30', 'Completed', 'LASIK pre-op evaluation',          'UB02'),
(10, 1,  '2025-04-22 09:00', 'Completed', 'Holter monitor review',            'A203'),
(1,  6,  '2025-05-01 11:00', 'Completed', 'General health check',             'W203'),
(2,  2,  '2025-05-06 10:00', 'Scheduled', 'MRI brain follow-up',              'B303'),
(3,  10, '2025-05-09 09:00', 'Scheduled', 'Cardiac stress test',              'A204'),
(4,  4,  '2025-05-12 14:00', 'Scheduled', 'Spinal MRI review',                'A403'),
(5,  15, '2025-05-15 09:30', 'Scheduled', 'Growth assessment',                'D103'),
(6,  6,  '2025-05-18 11:00', 'NoShow',    'Patient did not show',             'W204'),
(7,  17, '2025-05-21 09:00', 'Scheduled', 'Chemotherapy session 3',           'W303'),
(8,  8,  '2025-05-24 15:00', 'Scheduled', 'Eczema treatment',                 'UA03'),
(9,  19, '2025-05-27 10:00', 'Scheduled', 'LASIK surgery date',               'UB03'),
(10, 20, '2025-05-30 09:00', 'Scheduled', 'Pre-op open heart surgery',        'A205');

-- PRESCRIPTIONS (20 records)
INSERT INTO Prescription (AppointmentID, PatientID, DoctorID, IssueDate, ExpiryDate, Diagnosis, Notes) VALUES
(1,  1,  1,  '2025-01-10', '2025-04-10', 'Hypertension Stage 1',         'Monitor BP daily'),
(2,  2,  2,  '2025-01-12', '2025-02-12', 'Migraine without aura',        'Avoid triggers'),
(3,  3,  3,  '2025-01-15', '2025-01-25', 'Post-appendectomy care',       'Rest, no heavy lifting'),
(4,  4,  4,  '2025-01-18', '2025-04-18', 'Lumbar disc herniation',       'Physiotherapy recommended'),
(5,  5,  5,  '2025-01-20', '2025-04-20', 'Vitamin D deficiency',         'Sun exposure 30 min/day'),
(6,  6,  6,  '2025-02-01', '2025-02-15', 'Upper respiratory infection',  'Bed rest, fluids'),
(7,  7,  7,  '2025-02-05', '2025-05-05', 'Colon cancer stage 2',         'FOLFOX protocol'),
(8,  8,  8,  '2025-02-10', '2025-03-10', 'Contact dermatitis',           'Avoid allergens'),
(11, 1,  1,  '2025-03-05', '2025-06-05', 'Hypertension — maintained',    'Continue current regimen'),
(12, 2,  6,  '2025-03-08', '2025-06-08', 'Essential hypertension',       'Low-sodium diet'),
(13, 3,  3,  '2025-03-12', '2025-03-22', 'Inguinal hernia post-op',      'Follow-up in 2 weeks'),
(15, 5,  5,  '2025-03-20', '2025-06-20', 'Growth monitoring',            'Dietary plan attached'),
(16, 6,  8,  '2025-04-02', '2025-05-02', 'Acne vulgaris grade 2',        'Avoid oily foods'),
(17, 7,  7,  '2025-04-07', '2025-07-07', 'Colon cancer — ongoing tx',    'Continue FOLFOX'),
(18, 8,  4,  '2025-04-10', '2025-07-10', 'Anterior cruciate tear',       'Surgery recommended'),
(20, 10, 1,  '2025-04-22', '2025-07-22', 'Atrial fibrillation',          'Anti-coagulation therapy'),
(21, 1,  6,  '2025-05-01', '2025-08-01', 'General fatigue — anemia',     'Iron supplementation'),
(1,  1,  1,  '2025-01-10', '2025-02-10', 'Hypercholesterolemia',         'Low-fat diet'),
(6,  6,  6,  '2025-02-01', '2025-03-01', 'Sinusitis',                    'Steam inhalation'),
(10, 10, 10, '2025-02-20', '2025-05-20', 'Costochondritis',              'NSAIDs, rest');

-- MEDICATIONS (30 records)
INSERT INTO Medication (PrescriptionID, DrugName, Dosage, Frequency, DurationDays, Instructions) VALUES
(1,  'Amlodipine',      '10mg',   'Once daily',       90,  'Take in the morning'),
(1,  'Losartan',        '50mg',   'Once daily',       90,  'Take with food'),
(2,  'Sumatriptan',     '50mg',   'As needed',        30,  'Max 2 per day during migraine'),
(3,  'Amoxicillin',     '500mg',  'Three times daily', 7,  'Complete full course'),
(3,  'Ibuprofen',       '400mg',  'Twice daily',       5,  'Take after meals'),
(4,  'Diclofenac',      '75mg',   'Twice daily',       30, 'Take with food'),
(4,  'Pregabalin',      '75mg',   'Twice daily',       60, 'May cause drowsiness'),
(5,  'Vitamin D3',      '1000IU', 'Once daily',        90, 'Take with fatty meal'),
(5,  'Calcium',         '500mg',  'Twice daily',       90, 'Do not take with iron'),
(6,  'Paracetamol',     '500mg',  'Three times daily', 5,  'Do not exceed 4g/day'),
(6,  'Cetirizine',      '10mg',   'Once daily',        7,  'Take at bedtime'),
(7,  'Oxaliplatin',     '85mg/m2','Every 2 weeks',     60, 'IV infusion only'),
(7,  'Leucovorin',      '200mg/m2','Every 2 weeks',    60, 'IV infusion before 5-FU'),
(8,  'Hydrocortisone',  '1%',     'Twice daily',       30, 'Apply thin layer to affected area'),
(9,  'Amlodipine',      '10mg',   'Once daily',        90, 'Continue previous prescription'),
(10, 'Lisinopril',      '5mg',    'Once daily',        90, 'Monitor kidney function'),
(11, 'Metronidazole',   '500mg',  'Three times daily', 7,  'Avoid alcohol'),
(16, 'Warfarin',        '5mg',    'Once daily',        90, 'INR monitoring weekly'),
(17, 'Ferrous Sulfate', '325mg',  'Twice daily',       60, 'Take on empty stomach'),
(20, 'Naproxen',        '250mg',  'Twice daily',       14, 'Take with food');

-- LAB TESTS
INSERT INTO LabTest (AppointmentID, PatientID, TestName, TestType, OrderedDate, ResultDate, Status) VALUES
(1,  1,  'Complete Blood Count',     'Hematology',   '2025-01-10','2025-01-11','Completed'),
(1,  1,  'Lipid Panel',              'Biochemistry', '2025-01-10','2025-01-11','Completed'),
(2,  2,  'Brain MRI',                'Radiology',    '2025-01-12','2025-01-15','Completed'),
(6,  6,  'Throat Culture',           'Microbiology', '2025-02-01','2025-02-03','Completed'),
(7,  7,  'CEA Tumor Marker',         'Oncology',     '2025-02-05','2025-02-07','Completed'),
(10, 10, 'ECG',                      'Cardiology',   '2025-02-20','2025-02-20','Completed'),
(10, 10, 'Troponin I',               'Biochemistry', '2025-02-20','2025-02-21','Completed'),
(11, 1,  'Echocardiogram',           'Cardiology',   '2025-03-05','2025-03-05','Completed'),
(17, 7,  'CEA Follow-up',            'Oncology',     '2025-04-07','2025-04-09','Completed'),
(20, 10, 'Holter Monitor 24h',       'Cardiology',   '2025-04-22','2025-04-23','Completed'),
(21, 1,  'Hemoglobin',               'Hematology',   '2025-05-01','2025-05-02','Completed'),
(22, 2,  'Brain MRI w/contrast',     'Radiology',    '2025-05-06', NULL,       'Pending'),
(23, 3,  'Stress Echocardiogram',    'Cardiology',   '2025-05-09', NULL,       'Pending');

-- LAB RESULTS
INSERT INTO LabResult (TestID, Parameter, Value, Unit, ReferenceRange, Interpretation) VALUES
(1, 'WBC',         '7.2',   '10^9/L', '4.0-11.0',  'Normal'),
(1, 'RBC',         '4.8',   '10^12/L','4.5-5.5',   'Normal'),
(1, 'Hemoglobin',  '13.5',  'g/dL',   '13.5-17.5', 'Normal'),
(1, 'Hematocrit',  '41',    '%',      '41-53',      'Normal'),
(2, 'Total Chol',  '235',   'mg/dL',  '<200',       'High'),
(2, 'LDL',         '145',   'mg/dL',  '<100',       'High'),
(2, 'HDL',         '45',    'mg/dL',  '>40',        'Normal'),
(2, 'Triglycerides','180',  'mg/dL',  '<150',       'High'),
(5, 'CEA',         '12.4',  'ng/mL',  '<3.0',       'High'),
(7, 'Troponin I',  '0.02',  'ng/mL',  '<0.04',      'Normal'),
(9, 'CEA Follow',  '9.1',   'ng/mL',  '<3.0',       'High'),
(11,'Hemoglobin',  '10.2',  'g/dL',   '13.5-17.5',  'Low');

-- MEDICAL HISTORY
INSERT INTO MedicalHistory (PatientID, Condition, Treatment, DiagnosedDate, ResolvedDate, Status) VALUES
(1,  'Hypertension',           'Antihypertensives',      '2018-05-10', NULL,         'Chronic'),
(1,  'Hypercholesterolemia',   'Statins, diet',          '2020-01-15', NULL,         'Chronic'),
(2,  'Migraine',               'Triptans, lifestyle',    '2019-03-20', NULL,         'Chronic'),
(3,  'Appendicitis',           'Appendectomy',           '2025-01-14', '2025-01-25', 'Resolved'),
(3,  'Inguinal Hernia',        'Herniorrhaphy',          '2025-03-11', '2025-03-25', 'Resolved'),
(4,  'Lumbar Disc Herniation', 'Physiotherapy, NSAIDs',  '2025-01-18', NULL,         'Active'),
(5,  'Vitamin D Deficiency',   'Supplementation',        '2025-01-20', NULL,         'Active'),
(6,  'Recurrent Sinusitis',    'Antibiotics',            '2021-09-05', NULL,         'Chronic'),
(7,  'Colon Cancer Stage 2',   'FOLFOX Chemotherapy',    '2025-02-04', NULL,         'Active'),
(8,  'Atopic Dermatitis',      'Topical corticosteroids','2017-08-12', NULL,         'Chronic'),
(9,  'Myopia',                 'Glasses, LASIK eval',    '2010-03-01', NULL,         'Active'),
(10, 'Atrial Fibrillation',    'Anti-coagulation',       '2025-02-20', NULL,         'Active');

-- BILLING
INSERT INTO Billing (PatientID, AppointmentID, InsuranceID, TotalAmount, InsurancePaid, BillDate, Status) VALUES
(1,  1,  1,  850.00,   680.00,  '2025-01-10', 'Paid'),
(2,  2,  2,  600.00,   450.00,  '2025-01-12', 'Paid'),
(3,  3,  3,  3500.00,  2800.00, '2025-01-15', 'Paid'),
(4,  4,  1,  400.00,   320.00,  '2025-01-18', 'Paid'),
(5,  5,  4,  300.00,   270.00,  '2025-01-20', 'Paid'),
(6,  6,  5,  250.00,   150.00,  '2025-02-01', 'Paid'),
(7,  7,  2,  4200.00,  3150.00, '2025-02-05', 'Paid'),
(8,  8,  3,  350.00,   280.00,  '2025-02-10', 'Paid'),
(9,  9,  4,  500.00,   450.00,  '2025-02-14', 'Paid'),
(10, 10, 1,  750.00,   600.00,  '2025-02-20', 'Paid'),
(1,  11, 1,  950.00,   760.00,  '2025-03-05', 'Paid'),
(2,  12, 2,  300.00,   225.00,  '2025-03-08', 'Paid'),
(3,  13, 3,  2800.00,  2240.00, '2025-03-12', 'Paid'),
(5,  15, 4,  280.00,   252.00,  '2025-03-20', 'Paid'),
(6,  16, 5,  320.00,   192.00,  '2025-04-02', 'Paid'),
(7,  17, 2,  4000.00,  3000.00, '2025-04-07', 'PartiallyPaid'),
(8,  18, 3,  600.00,   480.00,  '2025-04-10', 'Paid'),
(9,  19, 4,  800.00,   720.00,  '2025-04-15', 'Paid'),
(10, 20, 1,  700.00,   560.00,  '2025-04-22', 'Paid'),
(1,  21, 1,  200.00,   160.00,  '2025-05-01', 'Paid');

PRINT 'Sample data inserted successfully.';
GO
