DELIMITER //

CREATE TRIGGER updateModifyDate before UPDATE ON observation 
FOR EACH ROW 
BEGIN 
  SET NEW.modify_date = now(); 
END;//

DELIMITER ;
