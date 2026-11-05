# Deliberate failure tests (run ONE at a time in MySQL Workbench)

Capture the MySQL error in the Action Output pane and explain why the database rejects the operation. DO NOT run all of these inside a single automatic script.

```sql
USE crownfield_eye_hospital;
-- Expected duplicate key error (already exists):
INSERT INTO patient(patient_id,patient_name,postcode) VALUES('OP001','Duplicate','A1 1AA');
-- Expected FK error (unknown parent):
INSERT INTO appointment_diagnosis(appointment_id,diagnosis_id) VALUES('AP999','DG001');
-- Expected CHECK error:
UPDATE follow_up SET priority='Impossible' WHERE follow_up_id='FU001';
-- Expected CHECK error:
UPDATE prescription_item SET duration_days=-3 WHERE prescription_id='RX001' AND item_number=1;
-- Expected FK RESTRICT parent delete error:
DELETE FROM patient WHERE patient_id='OP001';
-- Expected follow-up chronological guardrail:
UPDATE follow_up SET due_date='2000-01-01' WHERE follow_up_id='FU001';
```

Important: tests that change data must be rolled back or the original seed restored. To demonstrate negative errors safely, prefer running against a fresh classroom copy and save screenshots of the failure message. For demonstrations with START TRANSACTION / ROLLBACK, keep statements that intentionally error isolated.
