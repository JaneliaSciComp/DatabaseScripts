DROP FUNCTION IF EXISTS createCvId;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION createCvId(context CHAR(255), definition CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_cv_id int;

  SELECT id FROM cv WHERE name = context AND is_current = 1 INTO v_cv_id;
  IF v_cv_id is NULL THEN
    INSERT INTO cv (name,definition,version,is_current) VALUES (context,IFNULL(definition,context),0,1);
    SELECT id FROM cv WHERE name = context AND is_current = 1 INTO v_cv_id;
  END IF;

RETURN v_cv_id;

END//
DELIMITER ;
