-- Non-destructive verification. Run each statement; screenshot actual MySQL output.
USE crownfield_eye_hospital;
SELECT VERSION() AS mysql_version;
SELECT (SELECT COUNT(*) FROM patient) patients,
       (SELECT COUNT(*) FROM appointment) appointments,
       (SELECT COUNT(*) FROM prescription_item) prescription_items,
       (SELECT COUNT(*) FROM follow_up) follow_ups;
SELECT data_origin,COUNT(*) AS records FROM appointment GROUP BY data_origin;
-- UPDATE demonstration; ROLLBACK preserves source record.
START TRANSACTION;
UPDATE patient SET postcode='NE1 9ZZ' WHERE patient_id='OP005';
SELECT patient_id,postcode FROM patient WHERE patient_id='OP005';
ROLLBACK;
SELECT patient_id,postcode FROM patient WHERE patient_id='OP005';
-- DELETE demonstration; deletes temporary unreferenced synthetic test medicine only.
START TRANSACTION;
INSERT INTO medicine(medicine_id,medicine_name) VALUES('MD999','TEST MEDICINE DELETE');
DELETE FROM medicine WHERE medicine_id='MD999';
SELECT COUNT(*) AS temporary_medicine_rows FROM medicine WHERE medicine_id='MD999';
ROLLBACK;
-- Inspect installed triggers and routine(s) independently.
SHOW TRIGGERS FROM crownfield_eye_hospital;
-- D1 roles (administrator rights required to show grants of other roles):
SHOW GRANTS FOR 'crown_patient';
SHOW GRANTS FOR 'crown_reception';
