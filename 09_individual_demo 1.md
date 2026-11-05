# Theo – individual Part C evidence guide

Each capture must show query SQL, actual MySQL result pane, date and a one-sentence interpretation. DO NOT insert fabricated output screenshots.

Q1–Q4: execute in `04_individual_queries.sql` individually. Predictions:
* Q1 GROUP BY + HAVING: which clinics have at least two appointments?: City Road (CK001), 3 rows
* Q2 INNER JOIN across four tables: full appointment register: 15 rows
* Q3 LEFT JOIN: appointments without a diagnosis: 0 rows: all 15 seeded appointments have a diagnosis
* Q4 CTE + subquery: patients above average appointment count: OP001 Amina Yusuf, 2 appointments; seed average 1

**Q5 procedure**: `CALL sp_theo_clinic_schedule('CK001');`. Predicted: AP001, AP002 and AP004, 3 appointments.

**Q6 trigger demonstration**: after running `05_procedure_trigger.sql`, test in Workbench (separate execution):

```sql
INSERT INTO appointment(appointment_id,patient_id,clinician_id,clinic_id,appointment_date,appointment_time,appointment_status,data_origin) VALUES ('AP900','OP015','CL013','CK013','2001-01-01','16:30:00','Scheduled','Synthetic');
```

Prediction: ERROR SQLSTATE 45000: cannot create new scheduled appointment in the past.

**Security**: show `SHOW GRANTS FOR 'crown_patient'`, `SHOW GRANTS FOR 'crown_reception'` and test at least one denied permission using a separately-created locally authorised test account. Do not include passwords in screenshots.

**Transactions**: show `START TRANSACTION`, controlled UPDATE, SELECT, `ROLLBACK` and check original value; screenshot outputs.

**Contributor attribution**: insert your personally performed edits/tests and GitHub commits; shared template code is not proof of individual authorship.
