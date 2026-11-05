# Appendix 1: evidenced design and normalisation

**UNF:** a source record for OP001 contains both `Latanoprost | Timolol` (non-atomic medicine list). Follow-up `6 weeks | High` combines interval and priority. Repeated OP001 details occur in the 5 source encounters (4 different patients). Repeated clinician and speciality names risk update anomalies.

**1NF:** split each medicine into separate row `(appointment_id, item_no, medicine_name)` and follow-up into `(due_date, priority)`; distinguish repeat encounters by new `appointment_id`. Use a composite identifier `(appointment_id,item_no)` for medicine item occurrences; an encounter can contain several medicines.

**2NF:** under 1NF flat item relation `(appointment_id,item_no,patient_id,patient_name,...,medicine_name)`, `appointment_id -> patient_id,clinician_id,clinic_id,date,time`; fields dependent only on `appointment_id` violate whole-key dependence. Move these fields to `appointment`; item data stays in `prescription_item`, connected via `prescription`.

**3NF:** `appointment_id -> patient_id -> patient_name,postcode` is transitive; separate `patient`. Likewise `clinician_id -> specialty_id -> specialty_name`, so `specialty` is separate. `medicine_id -> medicine_name` stored in medicine dictionary, and `diagnosis_id -> diagnosis_name` in diagnosis dictionary. `appointment_diagnosis` resolves the many-to-many case using `(appointment_id,diagnosis_id)` composite PK.

**Assumptions:** the source's 5 rows are 5 encounters; OP001 occurs twice; missing regimen detail is stored as SQL NULL, not guessed. Original status is not given: past dates assumed Completed and future Scheduled. A source 'None' means there is no prescription. Follow-up weeks converted from appointment date; one follow-up per appointment in this teaching prototype. Ten extra appointments and other records are synthetic fixtures. The historical synthetic appointments flagged Scheduled are intentionally retained as snapshots for reproducibility: a new-booking trigger prevents newly entered historical scheduled appointments after loading data.

**Structural limitations:** foreign keys alone cannot enforce that a prescription header has >=1 item. A transactional procedure can enforce it for that writing path. Unique clinic/time slot assumes one appointment per clinic at the same time (too restrictive for multi-room clinics); cancelled slots remain reserved. This is a learning prototype, not an NHS operational system.
