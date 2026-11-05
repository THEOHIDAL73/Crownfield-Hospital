-- Theo: Q5 stored procedure and Q6 meaningful trigger.
-- After shared data + integrity triggers are installed.
USE crownfield_eye_hospital;

-- Q5
DROP PROCEDURE IF EXISTS sp_theo_clinic_schedule;
DELIMITER $$
CREATE PROCEDURE sp_theo_clinic_schedule(IN p_clinic_id VARCHAR(6))
BEGIN
 SELECT a.appointment_id, a.appointment_date, a.appointment_time, p.patient_name, a.appointment_status
 FROM appointment a JOIN patient p ON p.patient_id=a.patient_id
 WHERE a.clinic_id=p_clinic_id ORDER BY a.appointment_date,a.appointment_time;
END$$
DELIMITER ;

-- Q6
DROP TRIGGER IF EXISTS trg_theo_no_past_booking;
DELIMITER $$
CREATE TRIGGER trg_theo_no_past_booking BEFORE INSERT ON appointment FOR EACH ROW
BEGIN
  IF NEW.appointment_status='Scheduled' AND NEW.appointment_date < CURRENT_DATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Cannot create new scheduled appointment in the past';
  END IF;
END$$
DELIMITER ;
