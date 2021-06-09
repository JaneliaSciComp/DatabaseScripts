DROP FUNCTION IF EXISTS createCvTermId;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION createCvTermId(context CHAR(255), term CHAR(255), definition CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_cv_id int;
  DECLARE v_cv_term_id int;
  DECLARE v_relationship_id int;

  SELECT id FROM cv WHERE name = context AND is_current = 1 INTO v_cv_id;
  IF v_cv_id is NULL THEN
    INSERT INTO cv (name,definition,version,is_current) VALUES (context,context,0,1);
    SELECT id FROM cv WHERE name = context AND is_current = 1 INTO v_cv_id;
  END IF;

  SELECT id FROM cv_term WHERE name = term collate latin1_general_cs AND cv_id = v_cv_id AND is_current = 1 INTO v_cv_term_id;

  IF v_cv_term_id is NULL THEN
    SELECT cv_term.id from cv_term, cv WHERE cv_term.name = 'is_sub_cv_of'  collate latin1_general_cs AND cv.name = 'cv_relationship_types' AND cv_term.cv_id = cv.id INTO v_relationship_id;
    SELECT cv_term.id FROM cv_term, cv_relationship WHERE name = term collate latin1_general_cs AND cv_id = object_id AND subject_id = v_cv_id AND type_id = v_relationship_id AND cv_term.is_current = 1 INTO v_cv_term_id;
  END IF;

  IF v_cv_term_id is NULL THEN
    INSERT INTO cv_term (name,definition,cv_id,is_current) VALUES (term,IFNULL(definition,term),v_cv_id,1);
    SELECT id FROM cv_term WHERE name = term collate latin1_general_cs AND cv_id = v_cv_id AND is_current = 1 INTO v_cv_term_id;
  END IF;

RETURN v_cv_term_id;

END//
DELIMITER ;
