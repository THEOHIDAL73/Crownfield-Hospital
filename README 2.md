# Theo: CPU4103 individual summative draft repository

**Student:** Theo | **Group:** Theo, Liviu, Leo | **Focus:** Requirements, Crow's Foot ERD and 1NF–3NF normalisation.

Fictional Crownfield Eye Hospital scenario; never use real patient data. All sample values are classroom fixtures and no medication examples are clinical advice.

## Ordered execution (MySQL Server 8.0.16+)

1. Run `01_schema.sql` **once** (destructively rebuilds all 13 tables).
2. Run `02_sample_data.sql` once (15 patients, 15 appointments; 5 Appendix1 + 10 synthetic).
3. Run `03_common_integrity.sql` to install cross-table follow-up date protection.
4. Run `04_individual_queries.sql` one query at a time; capture SQL/results.
5. Run `05_procedure_trigger.sql` to install *my* stored procedure and meaningful trigger.
6. Run `06_security.sql` with a sufficiently privileged administrator (roles and views).
7. Run `07_positive_tests.sql` and follow `08_negative_tests.md` one failure at a time.
8. Run Q5 `CALL sp_theo_clinic_schedule('CK001');` and the Q6 test from `09_individual_demo.md`.

**Predicted seed outcomes** are listed next to code. They are NOT actual execution evidence. This package has no real MySQL evidence. See `09_individual_demo.md` for the evidence you must create.

The physical schema includes 11 connected clinical tables, 1 patient credential table and 1 audit table (13 total). `patient_account.password_hash` contains salted PBKDF2-HMAC-SHA256 test-only digests (600,000 iterations); passwords used to create them were never retained. MySQL role authentication and individual login passwords are separate from the fictional application hashes.

**Assumptions and limitations:** Appendix 1 includes five encounter rows but four distinct patients; source regimens were unspecified and remain NULL. Source statuses were inferred. Synthetic historical `Scheduled` rows are intentionally not updated after the fact; insert trigger applies only to new bookings. UNIQUE on clinic/date/time assumes a single service slot per whole clinic. An EMPTY prescription header can still be added by a privileged account; direct writes should be controlled in production. No real NHS deployment is claimed.

## Individual provenance to complete before submission
- Student ID: `[STUDENT NUMBER]`
- My own GitHub URL: `[URL]`
- My commits and tested changes: `[GIT COMMIT LINKS / DATES]`
- MySQL version and test environment: `[VERSION / DATE]`
- Screenshot filenames and short result explanations: `[EVIDENCE]`
- Video recording link/file: `[MP4]`

Do not publish passwords, real personal records or secret tokens. Supply real evidence only.

Optional: see `10_security_verification.md` for four-role login tests and a transactional prescription routine; run `09_password_hash_demo.py` to verify salted password hashing locally.
