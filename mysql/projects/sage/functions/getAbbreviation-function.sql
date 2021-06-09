DROP PROCEDURE IF EXISTS getAbbreviation;
DELIMITER //
CREATE DEFINER = sageAdmin PROCEDURE getAbbreviation
(IN context CHAR(255), IN term CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_id int;
  DECLARE v_name char;
  DECLARE v_relationship_id int;

  SELECT cv_term.id FROM cv_term,cv WHERE cv.id = cv_term.cv_id AND cv_term.name ='has_abbreviation' AND cv.name = 'obo' INTO v_relationship_id;

  IF context is NULL THEN
    SELECT subject_id from cv_term_relationship,cv_term where subject_id = cv_term.id and cv_term.name = term collate latin1_general_cs and cv_term_relationship.type_id = v_relationship_id  LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term collate latin1_general_cs;
    ELSE
     SELECT cv.name, t.id,t.name
     FROM cv_term_relationship  r
     JOIN cv_term t on ( r.object_id = t.id)
     JOIN cv on (cv.id = t.cv_id)
    WHERE  r.subject_id = v_id and r.type_id = v_relationship_id;
    END IF;
  ELSE
    SELECT subject_id from cv_term_relationship,cv_term, cv where subject_id = cv_term.id and cv.id = cv_term.cv_id and cv_term.name = term collate latin1_general_cs and cv_term_relationship.type_id = v_relationship_id LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term collate latin1_general_cs and cv.name = context;
    ELSE
     SELECT cv.name,t.id,t.name
     FROM cv_term_relationship  r
     JOIN cv_term t on ( r.object_id = t.id)
     JOIN cv on (cv.id = t.cv_id and cv.name = context)
    WHERE  r.subject_id = v_id and r.type_id = v_relationship_id;
    END IF;
  END IF;


END//
DELIMITER ;
