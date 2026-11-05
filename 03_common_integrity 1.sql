-- CPU4103 shared integrity guardrails. Run AFTER 02_sample_data.sql.
USE crownfield_eye_hospital;
DROP TRIGGER IF EXISTS trg_followup_bi;
DROP TRIGGER IF EXISTS trg_followup_bu;
DROP TRIGGER IF EXISTS trg_appointment_bu_followup;
DELIMITER $$
CREATE TRIGGER trg_followup_bi BEFORE INSERT ON follow_up FOR EACH ROW
BEGIN
  DECLARE v_date DATE;
  SELECT appointment_date INTO v_date FROM appointment WHERE appointment_id = NEW.appointment_id;
  IF v_date IS NOT NULL AND NEW.due_date < v_date THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Follow-up due date precedes appointment';
  END IF;
END$$
CREATE TRIGGER trg_followup_bu BEFORE UPDATE ON follow_up FOR EACH ROW
BEGIN
  DECLARE v_date DATE;
  SELECT appointment_date INTO v_date FROM appointment WHERE appointment_id = NEW.appointment_id;
  IF v_date IS NOT NULL AND NEW.due_date < v_date THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Follow-up due date precedes appointment';
  END IF;
END$$
CREATE TRIGGER trg_appointment_bu_followup BEFORE UPDATE ON appointment FOR EACH ROW
BEGIN
  IF NEW.appointment_date <> OLD.appointment_date
     AND EXISTS (SELECT 1 FROM follow_up f WHERE f.appointment_id=OLD.appointment_id AND f.due_date < NEW.appointment_date) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Rescheduling makes follow-up precede appointment';
  END IF;
END$$
DELIMITER ;


-- Optional transaction routine to enforce header + first medicine item on the controlled write path.
-- USE ON A FRESH TEACHING COPY: successful calls COMMIT permanently.
DROP PROCEDURE IF EXISTS sp_add_prescription_atomic;
DELIMITER $$
CREATE PROCEDURE sp_add_prescription_atomic(
  IN p_rx_id VARCHAR(6), IN p_appt_id VARCHAR(6), IN p_issued DATE,
  IN p_medicine_id VARCHAR(6)
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  INSERT INTO prescription(prescription_id,appointment_id,issued_on)
    VALUES(p_rx_id,p_appt_id,p_issued);
  INSERT INTO prescription_item(prescription_id,item_number,medicine_id)
    VALUES(p_rx_id,1,p_medicine_id);
  COMMIT;
END$$
DELIMITER ;
-- Example successful call (only against test copy):
-- CALL sp_add_prescription_atomic('RX900','AP004','2026-10-06','MD004');
-- Example failing item reference (ROLLBACK also removes header):
-- CALL sp_add_prescription_atomic('RX901','AP004','2026-10-06','MD999');
-- SELECT * FROM prescription WHERE prescription_id='RX901'; -- 0 rows expected.
