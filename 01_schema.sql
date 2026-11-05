-- CPU4:103 | Crownfield Eye Hospital | Final draft physical schema
-- Fictional teaching data only. Designed for MySQL 8.0.16+ (InnoDB).
-- CAUTION: running this schema deletes existing tables with these names in this database.
CREATE DATABASE IF NOT EXISTS crownfield_eye_hospital
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE crownfield_eye_hospital;

-- Drop children first, then parents: a safe way to rebuild this TEACHING database.
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS patient_account;
DROP TABLE IF EXISTS prescription_item;
DROP TABLE IF EXISTS prescription;
DROP TABLE IF EXISTS follow_up;
DROP TABLE IF EXISTS appointment_diagnosis;
DROP TABLE IF EXISTS diagnosis;
DROP TABLE IF EXISTS medicine;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS clinic;
DROP TABLE IF EXISTS clinician;
DROP TABLE IF EXISTS specialty;

CREATE TABLE specialty (
    specialty_id VARCHAR(6) PRIMARY KEY,
    specialty_name VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE clinician (
    clinician_id VARCHAR(6) PRIMARY KEY,
    clinician_name VARCHAR(100) NOT NULL,
    specialty_id VARCHAR(6) NOT NULL,
    CONSTRAINT fk_clinician_specialty FOREIGN KEY (specialty_id)
        REFERENCES specialty(specialty_id)
) ENGINE=InnoDB;

CREATE TABLE clinic (
    clinic_id VARCHAR(6) PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE patient (
    patient_id VARCHAR(6) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    postcode VARCHAR(12) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE appointment (
    appointment_id VARCHAR(6) PRIMARY KEY,
    patient_id VARCHAR(6) NOT NULL,
    clinician_id VARCHAR(6) NOT NULL,
    clinic_id VARCHAR(6) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    appointment_status VARCHAR(15) NOT NULL DEFAULT 'Scheduled',
    data_origin VARCHAR(12) NOT NULL DEFAULT 'Synthetic',
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id),
    CONSTRAINT fk_appointment_clinician FOREIGN KEY (clinician_id)
        REFERENCES clinician(clinician_id),
    CONSTRAINT fk_appointment_clinic FOREIGN KEY (clinic_id)
        REFERENCES clinic(clinic_id),
    CONSTRAINT chk_appointment_status CHECK (appointment_status IN ('Scheduled','Completed','Cancelled','NoShow')),
    CONSTRAINT chk_appointment_origin CHECK (data_origin IN ('Appendix1','Synthetic')),
    CONSTRAINT uq_clinician_timeslot UNIQUE (clinician_id, appointment_date, appointment_time),
    CONSTRAINT uq_clinic_timeslot UNIQUE (clinic_id, appointment_date, appointment_time),
    CONSTRAINT uq_patient_timeslot UNIQUE (patient_id, appointment_date, appointment_time)
) ENGINE=InnoDB;

CREATE TABLE diagnosis (
    diagnosis_id VARCHAR(6) PRIMARY KEY,
    diagnosis_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- One appointment can have multiple diagnoses; one diagnosis can occur at multiple appointments.
CREATE TABLE appointment_diagnosis (
    appointment_id VARCHAR(6) NOT NULL,
    diagnosis_id VARCHAR(6) NOT NULL,
    PRIMARY KEY (appointment_id, diagnosis_id),
    CONSTRAINT fk_ad_appointment FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),
    CONSTRAINT fk_ad_diagnosis FOREIGN KEY (diagnosis_id)
        REFERENCES diagnosis(diagnosis_id)
) ENGINE=InnoDB;

CREATE TABLE medicine (
    medicine_id VARCHAR(6) PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE prescription (
    prescription_id VARCHAR(6) PRIMARY KEY,
    appointment_id VARCHAR(6) NOT NULL,
    issued_on DATE NOT NULL,
    CONSTRAINT fk_prescription_appointment FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id)
) ENGINE=InnoDB;

-- Separating the prescription header and items removes the original repeating medicine list.
CREATE TABLE prescription_item (
    prescription_id VARCHAR(6) NOT NULL,
    item_number INT NOT NULL,
    medicine_id VARCHAR(6) NOT NULL,
    dose VARCHAR(40) NULL,
    route VARCHAR(40) NULL,
    frequency VARCHAR(60) NULL,
    duration_days INT NULL,
    PRIMARY KEY (prescription_id, item_number),
    CONSTRAINT fk_pi_prescription FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id),
    CONSTRAINT fk_pi_medicine FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id),
    CONSTRAINT chk_positive_item_number CHECK (item_number >= 1),
    CONSTRAINT chk_positive_duration CHECK (duration_days IS NULL OR duration_days > 0)
) ENGINE=InnoDB;

-- This prototype permits at most one follow-up plan per appointment.
CREATE TABLE follow_up (
    follow_up_id VARCHAR(6) PRIMARY KEY,
    appointment_id VARCHAR(6) NOT NULL UNIQUE,
    due_date DATE NOT NULL,
    priority VARCHAR(10) NOT NULL DEFAULT 'Routine',
    follow_up_status VARCHAR(12) NOT NULL DEFAULT 'Planned',
    plan_notes VARCHAR(255) NULL,
    CONSTRAINT fk_follow_up_appointment FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),
    CONSTRAINT chk_follow_priority CHECK (priority IN ('Routine','High','Urgent')),
    CONSTRAINT chk_follow_status CHECK (follow_up_status IN ('Planned','Completed','Cancelled'))
) ENGINE=InnoDB;


-- Additional teaching security records: these are not genuine hospital accounts.
CREATE TABLE patient_account (
    patient_id VARCHAR(6) PRIMARY KEY,
    db_username VARCHAR(80) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    CONSTRAINT fk_account_patient FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
) ENGINE=InnoDB;

CREATE TABLE audit_log (
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    appointment_id VARCHAR(6) NOT NULL,
    event_type VARCHAR(40) NOT NULL,
    old_value VARCHAR(100) NULL,
    new_value VARCHAR(100) NULL,
    actor VARCHAR(150) NOT NULL,
    recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_appointment FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
) ENGINE=InnoDB;

-- Example of ALTER TABLE (extra indexing after creating the tables).
CREATE INDEX idx_appointment_date ON appointment (appointment_date);
CREATE INDEX idx_follow_up_due_date ON follow_up (due_date);
