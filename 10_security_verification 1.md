# Part D – real MySQL access-control verification (no invented evidence)

Run `06_security.sql` with an account permitted to CREATE ROLE, CREATE VIEW and GRANT.

## A. View roles (screenshot actual grants)

```sql
SHOW GRANTS FOR 'crown_admin';
SHOW GRANTS FOR 'crown_doctor';
SHOW GRANTS FOR 'crown_reception';
SHOW GRANTS FOR 'crown_patient';
```

## B. Create distinct LOCAL test users and activate roles

Use MySQL Workbench **Administration > Users and Privileges** for four (or more) local demonstration users, setting **strong, unique passwords locally**. Do not reuse or commit credentials. For patient-specific view testing, the user names must match `demo_patient_op001` and `demo_patient_op002` in `patient_account.db_username`.

Example role assignment (after local accounts exist; adapt host name to real accounts):

```sql
GRANT 'crown_patient' TO 'demo_patient_op001'@'localhost';
GRANT 'crown_patient' TO 'demo_patient_op002'@'localhost';
SET DEFAULT ROLE 'crown_patient' TO 'demo_patient_op001'@'localhost';
SET DEFAULT ROLE 'crown_patient' TO 'demo_patient_op002'@'localhost';
-- Similarly grant 'crown_doctor' and 'crown_reception' to demonstration users
-- created locally for those roles.
```

Open separate connections as those actual users and run:

```sql
SELECT USER();
SELECT * FROM crownfield_eye_hospital.vw_patient_appointments;
SELECT * FROM crownfield_eye_hospital.patient; -- EXPECT access DENIED
```

Expected outcomes using original seed: OP001 has two appointments AP001 and AP003; OP002 has AP002 only. **Only real connections prove this isolation.** Avoid administrator users for the negative permission test, because wider privileges invalidate the demonstration.

### C. Hash verification

Use `09_password_hash_demo.py` locally with a freely chosen throwaway password to demonstrate that randomly salted hashes differ and verification works. Database stored sample hashes are generated from unknown random passwords that were discarded; this is intentional and avoids publishing credentials.

### D. Transaction-controlled prescription

`03_common_integrity.sql` contains `sp_add_prescription_atomic` to insert a prescription header and first item atomically. Execute successful and failing examples **on a fresh disposable teaching copy** and capture evidence that a failed medicine reference leaves no header. COMMIT inside the procedure cannot be undone by an outer ROLLBACK.

### E. Limitations

Roles only model least privilege; a patient-view filtered on MySQL USER() is suitable for the teaching setup with one database login per patient, not a production web portal with connection pooling. Real deployment needs application authentication, authorisation checks, encryption of backups, credential rotation and reliable audit logging.
