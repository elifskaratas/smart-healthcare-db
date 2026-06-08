-- Smart Healthcare Management System
-- SQL Server | Schema Definition
-- -------------------------------------------------------

USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SmartHealthcareDB')
    DROP DATABASE SmartHealthcareDB;
GO
CREATE DATABASE SmartHealthcareDB;
GO
USE SmartHealthcareDB;
GO

-- Hospital ve departman bilgileri
CREATE TABLE Hospital (
    HospitalID   INT IDENTITY(1,1) PRIMARY KEY,
    HospitalName NVARCHAR(150) NOT NULL,
    Address      NVARCHAR(255) NOT NULL,
    City         NVARCHAR(100) NOT NULL,
    Phone        NVARCHAR(20)  NOT NULL,
    Email        NVARCHAR(100) NOT NULL UNIQUE,
    EstablishedY INT CHECK (EstablishedY BETWEEN 1800 AND 2100)
);

CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    HospitalID   INT           NOT NULL,
    DeptName     NVARCHAR(100) NOT NULL,
    Location     NVARCHAR(100),
    Phone        NVARCHAR(20),
    CONSTRAINT FK_Dept_Hospital FOREIGN KEY (HospitalID)
        REFERENCES Hospital(HospitalID) ON DELETE CASCADE
);

-- User süpersınıfı; Patient, Doctor ve Admin bu tablodan türüyor (EER specialization)
CREATE TABLE [User] (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    FirstName    NVARCHAR(100) NOT NULL,
    LastName     NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(150) NOT NULL UNIQUE,
    Phone        NVARCHAR(20),
    PasswordHash NVARCHAR(255) NOT NULL,
    UserType     NVARCHAR(20)  NOT NULL CHECK (UserType IN ('Patient','Doctor','Admin')),
    DateCreated  DATETIME      NOT NULL DEFAULT GETDATE(),
    IsActive     BIT           NOT NULL DEFAULT 1
);

CREATE TABLE Insurance (
    InsuranceID   INT IDENTITY(1,1) PRIMARY KEY,
    ProviderName  NVARCHAR(150) NOT NULL,
    PolicyNumber  NVARCHAR(50)  NOT NULL UNIQUE,
    CoverageType  NVARCHAR(50)  NOT NULL,
    StartDate     DATE          NOT NULL,
    EndDate       DATE          NOT NULL,
    CoverageLimit DECIMAL(12,2) NOT NULL,
    CONSTRAINT CHK_Ins_Dates CHECK (EndDate > StartDate)
);

CREATE TABLE Patient (
    PatientID        INT IDENTITY(1,1) PRIMARY KEY,
    UserID           INT          NOT NULL UNIQUE,
    DateOfBirth      DATE         NOT NULL,
    Gender           NVARCHAR(10) NOT NULL CHECK (Gender IN ('Male','Female','Other')),
    BloodType        NVARCHAR(5),
    Address          NVARCHAR(255),
    EmergencyContact NVARCHAR(150),
    InsuranceID      INT,
    CONSTRAINT FK_Pat_User      FOREIGN KEY (UserID)      REFERENCES [User](UserID),
    CONSTRAINT FK_Pat_Insurance FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID)
);

-- DoctorType alanı EER diyagramındaki specialization'ı yansıtıyor:
-- Specialist ve Surgeon'a özgü alanlar NULL bırakılabilir
CREATE TABLE Doctor (
    DoctorID     INT IDENTITY(1,1) PRIMARY KEY,
    UserID       INT           NOT NULL UNIQUE,
    Specialty    NVARCHAR(100) NOT NULL,
    LicenseNo    NVARCHAR(50)  NOT NULL UNIQUE,
    DepartmentID INT           NOT NULL,
    HospitalID   INT           NOT NULL,
    Availability NVARCHAR(100),
    DoctorType   NVARCHAR(30)  NOT NULL CHECK (DoctorType IN ('GeneralPractitioner','Specialist','Surgeon')),
    SubSpecialty NVARCHAR(100),
    CertNo       NVARCHAR(50),
    SurgeryType  NVARCHAR(100),
    ORClearance  BIT DEFAULT 0,
    CONSTRAINT FK_Doc_User FOREIGN KEY (UserID)       REFERENCES [User](UserID),
    CONSTRAINT FK_Doc_Dept FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    CONSTRAINT FK_Doc_Hosp FOREIGN KEY (HospitalID)   REFERENCES Hospital(HospitalID)
);

CREATE TABLE Admin (
    AdminID     INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT          NOT NULL UNIQUE,
    Role        NVARCHAR(50) NOT NULL,
    HospitalID  INT          NOT NULL,
    AccessLevel NVARCHAR(20) NOT NULL DEFAULT 'Standard'
                CHECK (AccessLevel IN ('Standard','Senior','SuperAdmin')),
    CONSTRAINT FK_Adm_User FOREIGN KEY (UserID)     REFERENCES [User](UserID),
    CONSTRAINT FK_Adm_Hosp FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);

CREATE TABLE Appointment (
    AppointmentID   INT IDENTITY(1,1) PRIMARY KEY,
    PatientID       INT          NOT NULL,
    DoctorID        INT          NOT NULL,
    AppointmentDate DATETIME     NOT NULL,
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Scheduled'
                    CHECK (Status IN ('Scheduled','Completed','Cancelled','NoShow')),
    Notes           NVARCHAR(500),
    RoomNo          NVARCHAR(20),
    CreatedAt       DATETIME     NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Appt_Patient FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT FK_Appt_Doctor  FOREIGN KEY (DoctorID)  REFERENCES Doctor(DoctorID)
);

-- Prescription, Appointment'a bağımlı bir weak entity
CREATE TABLE Prescription (
    PrescriptionID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID  INT  NOT NULL,
    PatientID      INT  NOT NULL,
    DoctorID       INT  NOT NULL,
    IssueDate      DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    ExpiryDate     DATE NOT NULL,
    Diagnosis      NVARCHAR(500) NOT NULL,
    Notes          NVARCHAR(500),
    CONSTRAINT FK_Presc_Appt    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    CONSTRAINT FK_Presc_Patient FOREIGN KEY (PatientID)     REFERENCES Patient(PatientID),
    CONSTRAINT FK_Presc_Doctor  FOREIGN KEY (DoctorID)      REFERENCES Doctor(DoctorID),
    CONSTRAINT CHK_Presc_Dates  CHECK (ExpiryDate >= IssueDate)
);

-- Medication, Prescription'a bağımlı; reçete silinince ilaçlar da silinir
CREATE TABLE Medication (
    MedicationID   INT IDENTITY(1,1) PRIMARY KEY,
    PrescriptionID INT           NOT NULL,
    DrugName       NVARCHAR(150) NOT NULL,
    Dosage         NVARCHAR(50)  NOT NULL,
    Frequency      NVARCHAR(50)  NOT NULL,
    DurationDays   INT           NOT NULL CHECK (DurationDays > 0),
    Instructions   NVARCHAR(255),
    CONSTRAINT FK_Med_Presc FOREIGN KEY (PrescriptionID)
        REFERENCES Prescription(PrescriptionID) ON DELETE CASCADE
);

CREATE TABLE LabTest (
    TestID        INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT           NOT NULL,
    PatientID     INT           NOT NULL,
    TestName      NVARCHAR(150) NOT NULL,
    TestType      NVARCHAR(50)  NOT NULL,
    OrderedDate   DATETIME      NOT NULL DEFAULT GETDATE(),
    ResultDate    DATETIME,
    Status        NVARCHAR(20)  NOT NULL DEFAULT 'Pending'
                  CHECK (Status IN ('Pending','InProgress','Completed','Cancelled')),
    CONSTRAINT FK_Lab_Appt    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    CONSTRAINT FK_Lab_Patient FOREIGN KEY (PatientID)     REFERENCES Patient(PatientID)
);

CREATE TABLE LabResult (
    ResultID       INT IDENTITY(1,1) PRIMARY KEY,
    TestID         INT           NOT NULL,
    Parameter      NVARCHAR(100) NOT NULL,
    Value          NVARCHAR(100) NOT NULL,
    Unit           NVARCHAR(50),
    ReferenceRange NVARCHAR(100),
    Interpretation NVARCHAR(20) CHECK (Interpretation IN ('Normal','Low','High','Critical')),
    CONSTRAINT FK_LabRes_Test FOREIGN KEY (TestID)
        REFERENCES LabTest(TestID) ON DELETE CASCADE
);

CREATE TABLE MedicalHistory (
    HistoryID     INT IDENTITY(1,1) PRIMARY KEY,
    PatientID     INT           NOT NULL,
    Condition     NVARCHAR(200) NOT NULL,
    Treatment     NVARCHAR(500),
    DiagnosedDate DATE          NOT NULL,
    ResolvedDate  DATE,
    Status        NVARCHAR(20)  NOT NULL DEFAULT 'Active'
                  CHECK (Status IN ('Active','Resolved','Chronic')),
    CONSTRAINT FK_MH_Patient FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

-- PatientOwes hesaplanmış sütun: TotalAmount - InsurancePaid
CREATE TABLE Billing (
    BillID        INT IDENTITY(1,1) PRIMARY KEY,
    PatientID     INT           NOT NULL,
    AppointmentID INT           NOT NULL,
    InsuranceID   INT,
    TotalAmount   DECIMAL(12,2) NOT NULL CHECK (TotalAmount >= 0),
    InsurancePaid DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (InsurancePaid >= 0),
    PatientOwes   AS (TotalAmount - InsurancePaid) PERSISTED,
    BillDate      DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Status        NVARCHAR(20)  NOT NULL DEFAULT 'Unpaid'
                  CHECK (Status IN ('Unpaid','PartiallyPaid','Paid','Disputed')),
    CONSTRAINT FK_Bill_Patient FOREIGN KEY (PatientID)     REFERENCES Patient(PatientID),
    CONSTRAINT FK_Bill_Appt    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    CONSTRAINT FK_Bill_Ins     FOREIGN KEY (InsuranceID)   REFERENCES Insurance(InsuranceID)
);

PRINT 'Schema created successfully.';
GO
