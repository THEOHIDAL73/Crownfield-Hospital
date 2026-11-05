-- Theo individual Part C queries. Run after 01–03. Predicted rows are not evidence of MySQL execution.
USE crownfield_eye_hospital;

-- Q1: Q1 GROUP BY + HAVING: which clinics have at least two appointments?
-- Expected based on seed: City Road (CK001), 3 rows
SELECT cl.clinic_id, cl.clinic_name, COUNT(*) AS appointment_count
FROM appointment a INNER JOIN clinic cl ON a.clinic_id=cl.clinic_id
GROUP BY cl.clinic_id, cl.clinic_name HAVING COUNT(*) >= 2
ORDER BY appointment_count DESC;

-- Q2: Q2 INNER JOIN across four tables: full appointment register
-- Expected based on seed: 15 rows
SELECT a.appointment_id, p.patient_name, c.clinician_name, cl.clinic_name, a.appointment_date
FROM appointment a JOIN patient p ON p.patient_id=a.patient_id
JOIN clinician c ON c.clinician_id=a.clinician_id
JOIN clinic cl ON cl.clinic_id=a.clinic_id ORDER BY a.appointment_id;

-- Q3: Q3 LEFT JOIN: appointments without a diagnosis
-- Expected based on seed: 0 rows: all 15 seeded appointments have a diagnosis
SELECT a.appointment_id, a.appointment_status FROM appointment a
LEFT JOIN appointment_diagnosis ad ON a.appointment_id=ad.appointment_id
WHERE ad.appointment_id IS NULL ORDER BY a.appointment_id;

-- Q4: Q4 CTE + subquery: patients above average appointment count
-- Expected based on seed: OP001 Amina Yusuf, 2 appointments; seed average 1
WITH counts AS (
 SELECT p.patient_id,p.patient_name,COUNT(a.appointment_id) AS n
 FROM patient p LEFT JOIN appointment a ON a.patient_id=p.patient_id
 GROUP BY p.patient_id,p.patient_name
)
SELECT patient_id,patient_name,n FROM counts
WHERE n>(SELECT AVG(n) FROM counts) ORDER BY n DESC;
