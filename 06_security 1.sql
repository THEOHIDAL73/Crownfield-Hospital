-- Shared Part D roles, views and privileges. Run with an ADMINISTRATOR capable of CREATE ROLE.
-- Never commit real credentials. Roles are defined here; creating actual login users is a separate local task.
USE crownfield_eye_hospital;
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_reception_schedule AS
 SELECT a.appointment_id, a.patient_id, p.patient_name, a.clinic_id,
        a.appointment_date, a.appointment_time, a.appointment_status
 FROM appointment a JOIN patient p ON p.patient_id=a.patient_id;

-- Per-connection patient isolation: USER() represents the login identity.
-- Production pooled logins require an application-authenticated context instead.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_patient_appointments AS
 SELECT a.appointment_id,a.appointment_date,a.appointment_time,a.appointment_status,
        cl.clinic_name
 FROM appointment a JOIN clinic cl ON cl.clinic_id=a.clinic_id
 JOIN patient_account pa ON pa.patient_id=a.patient_id
 WHERE pa.db_username=SUBSTRING_INDEX(USER(),'@',1);

CREATE ROLE IF NOT EXISTS 'crown_admin', 'crown_doctor', 'crown_reception', 'crown_patient';
-- Administrative rights for this database ONLY; no global privileges.
GRANT ALL PRIVILEGES ON crownfield_eye_hospital.* TO 'crown_admin';
-- Doctors: clinical tables but no patient_account, and no DELETE (least privilege).
GRANT SELECT ON crownfield_eye_hospital.patient TO 'crown_doctor';
GRANT SELECT ON crownfield_eye_hospital.clinician TO 'crown_doctor';
GRANT SELECT ON crownfield_eye_hospital.clinic TO 'crown_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.appointment TO 'crown_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.appointment_diagnosis TO 'crown_doctor';
GRANT SELECT ON crownfield_eye_hospital.diagnosis TO 'crown_doctor';
GRANT SELECT ON crownfield_eye_hospital.medicine TO 'crown_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.prescription TO 'crown_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.prescription_item TO 'crown_doctor';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.follow_up TO 'crown_doctor';
-- Reception sees the controlled view, not diagnosis / medicine / password hashes.
GRANT SELECT ON crownfield_eye_hospital.vw_reception_schedule TO 'crown_reception';
GRANT INSERT ON crownfield_eye_hospital.appointment TO 'crown_reception';
GRANT UPDATE (appointment_date,appointment_time,appointment_status,clinic_id)
 ON crownfield_eye_hospital.appointment TO 'crown_reception';
GRANT SELECT ON crownfield_eye_hospital.vw_patient_appointments TO 'crown_patient';
-- Run SHOW GRANTS FOR 'crown_patient'; and SHOW GRANTS FOR 'crown_doctor'; for evidence.
-- To test patient isolation create *local* users 'demo_patient_op001' and 'demo_patient_op002'
-- with unique strong passwords, GRANT 'crown_patient' to them, SET DEFAULT ROLE 'crown_patient' TO them.
-- NEVER put those login passwords in GitHub. Note that credentials are NOT the stored application hashes.
