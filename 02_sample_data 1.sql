-- CPU4:103 | Seed data from Appendix 1 + labelled fictional additions
-- Run AFTER 01_schema.sql. Source blanks remain NULL: no invented clinical doses.
USE crownfield_eye_hospital;

-- SPECIALTY: 13 total records
INSERT INTO specialty (specialty_id, specialty_name) VALUES
    ('SP001', 'Glaucoma'),
    ('SP002', 'Retina'),
    ('SP003', 'Cornea'),
    ('SP004', 'Paediatric Ophthalmology'),
    ('SP005', 'Neuro-ophthalmology'),
    ('SP006', 'Oculoplastics'),
    ('SP007', 'Cataract'),
    ('SP008', 'Uveitis'),
    ('SP009', 'Ocular Oncology'),
    ('SP010', 'Low Vision'),
    ('SP011', 'Medical Retina'),
    ('SP012', 'External Eye'),
    ('SP013', 'Eye Emergency');

-- CLINICIAN: 13 total records
INSERT INTO clinician (clinician_id, clinician_name, specialty_id) VALUES
    ('CL001', 'Dr Maya Shah', 'SP001'),
    ('CL002', 'Dr Leo Grant', 'SP002'),
    ('CL003', 'Dr Priya Nair', 'SP003'),
    ('CL004', 'Dr Emma Collins', 'SP004'),
    ('CL005', 'Dr James Patel', 'SP005'),
    ('CL006', 'Dr Sofia Mendes', 'SP006'),
    ('CL007', 'Dr Daniel Brooks', 'SP007'),
    ('CL008', 'Dr Sara Wilson', 'SP008'),
    ('CL009', 'Dr Ben Carter', 'SP009'),
    ('CL010', 'Dr Nadia Rahman', 'SP010'),
    ('CL011', 'Dr Alex Moore', 'SP011'),
    ('CL012', 'Dr Olivia Hayes', 'SP012'),
    ('CL013', 'Dr Hamza Iqbal', 'SP013');

-- CLINIC: 13 total records
INSERT INTO clinic (clinic_id, clinic_name) VALUES
    ('CK001', 'City Road'),
    ('CK002', 'Bedford'),
    ('CK003', 'Croydon'),
    ('CK004', 'Paediatric Eye Clinic'),
    ('CK005', 'Neuro-ophthalmology Unit'),
    ('CK006', 'Oculoplastics Suite'),
    ('CK007', 'Cataract Assessment Clinic'),
    ('CK008', 'Uveitis Clinic'),
    ('CK009', 'Ocular Oncology Clinic'),
    ('CK010', 'Low Vision Centre'),
    ('CK011', 'Medical Retina Suite'),
    ('CK012', 'External Eye Clinic'),
    ('CK013', 'Urgent Eye Care');

-- PATIENT: 15 total records
INSERT INTO patient (patient_id, patient_name, postcode) VALUES
    ('OP001', 'Amina Yusuf', 'NE1 4AB'),
    ('OP002', 'Daniel Reed', 'N16 7QP'),
    ('OP003', 'Sofia Bennett', 'E8 2LD'),
    ('OP004', 'Michael Okoro', 'SE6 3RT'),
    ('OP005', 'Oliver Finch', 'NE3 5LA'),
    ('OP006', 'Fatima Ali', 'E13 0RQ'),
    ('OP007', 'Grace Turner', 'SW11 4BN'),
    ('OP008', 'Yusuf Rahman', 'NW5 2PF'),
    ('OP009', 'Ellie Morgan', 'CR0 6AA'),
    ('OP010', 'Harpreet Singh', 'B1 3PL'),
    ('OP011', 'Maya Clarke', 'SE15 5JT'),
    ('OP012', 'Noah Williams', 'E2 8BZ'),
    ('OP013', 'Zara Hussain', 'HA1 1SP'),
    ('OP014', 'Emily Foster', 'EC1V 7DH'),
    ('OP015', 'Samuel Brooks', 'W5 1DS');

-- APPOINTMENT: 15 total records
INSERT INTO appointment (appointment_id, patient_id, clinician_id, clinic_id, appointment_date, appointment_time, appointment_status, data_origin) VALUES
    ('AP001', 'OP001', 'CL001', 'CK001', '2026-10-05', '09:00:00', 'Completed', 'Appendix1'),
    ('AP002', 'OP002', 'CL002', 'CK001', '2026-10-05', '09:30:00', 'Completed', 'Appendix1'),
    ('AP003', 'OP001', 'CL001', 'CK002', '2026-11-16', '10:15:00', 'Scheduled', 'Appendix1'),
    ('AP004', 'OP003', 'CL001', 'CK001', '2026-10-06', '11:00:00', 'Completed', 'Appendix1'),
    ('AP005', 'OP004', 'CL003', 'CK003', '2026-10-07', '14:00:00', 'Completed', 'Appendix1'),
    ('AP006', 'OP005', 'CL004', 'CK004', '2026-10-12', '09:00:00', 'Scheduled', 'Synthetic'),
    ('AP007', 'OP006', 'CL005', 'CK005', '2026-10-13', '09:30:00', 'Scheduled', 'Synthetic'),
    ('AP008', 'OP007', 'CL006', 'CK006', '2026-10-14', '10:00:00', 'Scheduled', 'Synthetic'),
    ('AP009', 'OP008', 'CL007', 'CK007', '2026-10-15', '10:30:00', 'Scheduled', 'Synthetic'),
    ('AP010', 'OP009', 'CL008', 'CK008', '2026-10-16', '11:00:00', 'Scheduled', 'Synthetic'),
    ('AP011', 'OP010', 'CL009', 'CK009', '2026-10-19', '11:30:00', 'Scheduled', 'Synthetic'),
    ('AP012', 'OP011', 'CL010', 'CK010', '2026-10-20', '12:00:00', 'Scheduled', 'Synthetic'),
    ('AP013', 'OP012', 'CL011', 'CK011', '2026-10-21', '13:00:00', 'Scheduled', 'Synthetic'),
    ('AP014', 'OP013', 'CL012', 'CK012', '2026-10-22', '14:00:00', 'Scheduled', 'Synthetic'),
    ('AP015', 'OP014', 'CL013', 'CK013', '2026-10-23', '15:00:00', 'Scheduled', 'Synthetic');

-- DIAGNOSIS: 14 total records
INSERT INTO diagnosis (diagnosis_id, diagnosis_name) VALUES
    ('DG001', 'Ocular hypertension'),
    ('DG002', 'Diabetic macular oedema'),
    ('DG003', 'Glaucoma suspect'),
    ('DG004', 'Keratoconus'),
    ('DG005', 'Amblyopia'),
    ('DG006', 'Optic neuritis'),
    ('DG007', 'Blepharitis'),
    ('DG008', 'Cataract'),
    ('DG009', 'Anterior uveitis'),
    ('DG010', 'Choroidal naevus'),
    ('DG011', 'Age-related macular degeneration'),
    ('DG012', 'Diabetic retinopathy'),
    ('DG013', 'Dry eye syndrome'),
    ('DG014', 'Conjunctivitis');

-- APPOINTMENT_DIAGNOSIS: 15 total records
INSERT INTO appointment_diagnosis (appointment_id, diagnosis_id) VALUES
    ('AP001', 'DG001'),
    ('AP002', 'DG002'),
    ('AP003', 'DG001'),
    ('AP004', 'DG003'),
    ('AP005', 'DG004'),
    ('AP006', 'DG005'),
    ('AP007', 'DG006'),
    ('AP008', 'DG007'),
    ('AP009', 'DG008'),
    ('AP010', 'DG009'),
    ('AP011', 'DG010'),
    ('AP012', 'DG011'),
    ('AP013', 'DG012'),
    ('AP014', 'DG013'),
    ('AP015', 'DG014');

-- MEDICINE: 14 total records
INSERT INTO medicine (medicine_id, medicine_name) VALUES
    ('MD001', 'Latanoprost'),
    ('MD002', 'Timolol'),
    ('MD003', 'Aflibercept'),
    ('MD004', 'Sodium chloride drops'),
    ('MD005', 'Atropine'),
    ('MD006', 'Preservative-free lubricating drops'),
    ('MD007', 'Lid hygiene solution'),
    ('MD008', 'Sodium hyaluronate drops'),
    ('MD009', 'Cyclopentolate'),
    ('MD010', 'Artificial tears'),
    ('MD011', 'Lubricating eye gel'),
    ('MD012', 'Hypromellose drops'),
    ('MD013', 'Carbomer eye gel'),
    ('MD014', 'Chloramphenicol eye drops');

-- PRESCRIPTION: 14 total records
INSERT INTO prescription (prescription_id, appointment_id, issued_on) VALUES
    ('RX001', 'AP001', '2026-10-05'),
    ('RX002', 'AP002', '2026-10-05'),
    ('RX003', 'AP003', '2026-11-16'),
    ('RX004', 'AP005', '2026-10-07'),
    ('RX005', 'AP006', '2026-10-12'),
    ('RX006', 'AP007', '2026-10-13'),
    ('RX007', 'AP008', '2026-10-14'),
    ('RX008', 'AP009', '2026-10-15'),
    ('RX009', 'AP010', '2026-10-16'),
    ('RX010', 'AP011', '2026-10-19'),
    ('RX011', 'AP012', '2026-10-20'),
    ('RX012', 'AP013', '2026-10-21'),
    ('RX013', 'AP014', '2026-10-22'),
    ('RX014', 'AP015', '2026-10-23');

-- PRESCRIPTION_ITEM: 15 total records
INSERT INTO prescription_item (prescription_id, item_number, medicine_id, dose, route, frequency, duration_days) VALUES
    ('RX001', 1, 'MD001', NULL, NULL, NULL, NULL),
    ('RX001', 2, 'MD002', NULL, NULL, NULL, NULL),
    ('RX002', 1, 'MD003', NULL, NULL, NULL, NULL),
    ('RX003', 1, 'MD001', NULL, NULL, NULL, NULL),
    ('RX004', 1, 'MD004', NULL, NULL, NULL, NULL),
    ('RX005', 1, 'MD005', 'As directed', 'Ophthalmic', 'As directed', 7),
    ('RX006', 1, 'MD006', '1 drop', 'Ophthalmic', 'As needed', 14),
    ('RX007', 1, 'MD007', 'As directed', 'Topical', 'Twice daily', 14),
    ('RX008', 1, 'MD008', '1 drop', 'Ophthalmic', 'As needed', 21),
    ('RX009', 1, 'MD009', 'As directed', 'Ophthalmic', 'As directed', 7),
    ('RX010', 1, 'MD010', '1 drop', 'Ophthalmic', 'As needed', 14),
    ('RX011', 1, 'MD011', 'As directed', 'Ophthalmic', 'As needed', 14),
    ('RX012', 1, 'MD012', '1 drop', 'Ophthalmic', 'As needed', 28),
    ('RX013', 1, 'MD013', 'As directed', 'Ophthalmic', 'As needed', 14),
    ('RX014', 1, 'MD014', 'As directed', 'Ophthalmic', 'As directed', 5);

-- FOLLOW_UP: 15 total records
INSERT INTO follow_up (follow_up_id, appointment_id, due_date, priority, follow_up_status, plan_notes) VALUES
    ('FU001', 'AP001', '2026-11-16', 'High', 'Planned', 'Review IOP'),
    ('FU002', 'AP002', '2026-11-02', 'Urgent', 'Planned', 'OCT before review'),
    ('FU003', 'AP003', '2027-02-08', 'Routine', 'Planned', 'Visual field test'),
    ('FU004', 'AP004', '2027-04-06', 'Routine', 'Planned', 'Monitor'),
    ('FU005', 'AP005', '2026-12-02', 'Routine', 'Planned', 'Corneal topography'),
    ('FU006', 'AP006', '2026-11-09', 'Routine', 'Planned', 'Review response to management'),
    ('FU007', 'AP007', '2026-10-27', 'High', 'Planned', 'Check neuro-ophthalmology findings'),
    ('FU008', 'AP008', '2026-11-11', 'Routine', 'Planned', 'Review eyelid symptoms'),
    ('FU009', 'AP009', '2026-11-26', 'Routine', 'Planned', 'Discuss cataract care plan'),
    ('FU010', 'AP010', '2026-10-30', 'High', 'Planned', 'Assess inflammation'),
    ('FU011', 'AP011', '2027-01-11', 'Routine', 'Planned', 'Review retinal imaging'),
    ('FU012', 'AP012', '2026-11-17', 'Routine', 'Planned', 'Review visual aids'),
    ('FU013', 'AP013', '2026-11-18', 'High', 'Planned', 'Repeat retinal assessment'),
    ('FU014', 'AP014', '2026-11-19', 'Routine', 'Planned', 'Check ocular surface comfort'),
    ('FU015', 'AP015', '2026-10-30', 'Routine', 'Planned', 'Confirm symptom resolution');



-- Synthetic accounts; passwords are randomly generated, discarded and NOT recoverable.
INSERT INTO patient_account (patient_id, db_username, password_hash) VALUES
    ('OP001','demo_patient_op001','pbkdf2_sha256$600000$fbb5107747cf732413e491841214e65a$5c810b86af7be93b73a59e0077ca346cb18efec31555327ef29a06f757e1fe26'),
    ('OP002','demo_patient_op002','pbkdf2_sha256$600000$1bacbc6a065ad4691d51c38640b42cbe$19425ee4b142278dede84cd54fecd910adaa8d60dcb5ba3acaf555a86d3a30ac');
