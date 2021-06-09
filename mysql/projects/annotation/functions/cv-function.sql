DROP FUNCTION IF EXISTS getCvId;
DELIMITER //
CREATE DEFINER = annotationAdmin FUNCTION getCvId(context CHAR(255), definition CHAR(255))
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


DROP FUNCTION IF EXISTS getCvTermId;
DELIMITER //
CREATE DEFINER = annotationAdmin FUNCTION getCvTermId(context CHAR(255), term CHAR(255), definition CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_cv_id int;
  DECLARE v_cv_term_id int;

  SELECT id FROM cv WHERE name = context AND is_current = 1 INTO v_cv_id;
  IF v_cv_id is NULL THEN
    INSERT INTO cv (name,definition,version,is_current) VALUES (context,context,0,1);
    SELECT id FROM cv WHERE name = context AND is_current = 1 INTO v_cv_id;
  END IF;

  SELECT id FROM cv_term WHERE name = term AND cv_id = v_cv_id AND is_current = 1 INTO v_cv_term_id;
  IF v_cv_term_id is NULL THEN
    INSERT INTO cv_term (name,definition,cv_id,is_current) VALUES (term,IFNULL(definition,term),v_cv_id,1);
    SELECT id FROM cv_term WHERE name = term AND cv_id = v_cv_id AND is_current = 1 INTO v_cv_term_id;
  END IF;

RETURN v_cv_term_id;

END//
DELIMITER ;


DROP FUNCTION IF EXISTS getCvTermName;
DELIMITER //
CREATE DEFINER = annotationAdmin FUNCTION getCvTermName(term_id int)
RETURNS CHAR(255)
DETERMINISTIC
BEGIN
  DECLARE v_cv_term_name CHAR(255);

  SELECT name FROM cv_term WHERE id = term_id INTO v_cv_term_name;

RETURN v_cv_term_name;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS getPrimaryTerm;
DELIMITER //
CREATE DEFINER = annotationAdmin PROCEDURE getPrimaryTerm
(IN context CHAR(255), IN term CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_id int;
  DECLARE v_name char;
  DECLARE v_synonym_relationship_id int;
  DECLARE v_abbreviation_relationship_id int;

  SELECT cv_term.id FROM cv_term,cv WHERE cv.id = cv_term.cv_id AND cv_term.name ='has_synonym' AND cv.name = 'prelim_obo' INTO v_synonym_relationship_id;
  SELECT cv_term.id FROM cv_term,cv WHERE cv.id = cv_term.cv_id AND cv_term.name ='has_abbreviation' AND cv.name = 'prelim_obo' INTO v_abbreviation_relationship_id;

  IF context is NULL THEN
    SELECT object_id from cv_relationship,cv_term where object_id = cv_term.id and cv_term.name = term and (cv_relationship.type_id = v_synonym_relationship_id or cv_relationship.type_id = v_abbreviation_relationship_id) LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term;
    ELSE
     SELECT cv.name, t.id,t.name
     FROM cv_relationship  r
     JOIN cv_term t on ( r.subject_id = t.id)
     JOIN cv on (cv.id = t.cv_id)
    WHERE  r.object_id = v_id and (r.type_id = v_synonym_relationship_id or r.type_id = v_abbreviation_relationship_id);
    END IF;
  ELSE
    SELECT object_id from cv_relationship,cv_term, cv where object_id = cv_term.id and cv.id = cv_term.cv_id and cv_term.name = term and (cv_relationship.type_id = v_synonym_relationship_id or cv_relationship.type_id = v_abbreviation_relationship_id) LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term and cv.name = context;
    ELSE
     SELECT cv.name,t.id,t.name
     FROM cv_relationship  r
     JOIN cv_term t on ( r.subject_id = t.id)
     JOIN cv on (cv.id = t.cv_id and cv.name = context)
    WHERE  r.object_id = v_id and (r.type_id = v_synonym_relationship_id or r.type_id = v_abbreviation_relationship_id);
    END IF;
  END IF;

 
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS getSynonym;
DELIMITER //
CREATE DEFINER = annotationAdmin PROCEDURE getSynonym
(IN context CHAR(255), IN term CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_id int;
  DECLARE v_name char;
  DECLARE v_relationship_id int;

  SELECT cv_term.id FROM cv_term,cv WHERE cv.id = cv_term.cv_id AND cv_term.name ='has_synonym' AND cv.name = 'prelim_obo' INTO v_relationship_id;

  IF context is NULL THEN
    SELECT subject_id from cv_relationship,cv_term where subject_id = cv_term.id and cv_term.name = term and cv_relationship.type_id = v_relationship_id  LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term;
    ELSE
     SELECT cv.name, t.id,t.name
     FROM cv_relationship  r
     JOIN cv_term t on ( r.object_id = t.id)
     JOIN cv on (cv.id = t.cv_id)
    WHERE  r.subject_id = v_id and r.type_id = v_relationship_id;
    END IF;
  ELSE
    SELECT subject_id from cv_relationship,cv_term, cv where subject_id = cv_term.id and cv.id = cv_term.cv_id and cv_term.name = term and cv_relationship.type_id = v_relationship_id LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term and cv.name = context;
    ELSE
     SELECT cv.name,t.id,t.name
     FROM cv_relationship  r
     JOIN cv_term t on ( r.object_id = t.id)
     JOIN cv on (cv.id = t.cv_id and cv.name = context)
    WHERE  r.subject_id = v_id and r.type_id = v_relationship_id;
    END IF;
  END IF;


END//
DELIMITER ;


DROP PROCEDURE IF EXISTS getAbbreviation;
DELIMITER //
CREATE DEFINER = annotationAdmin PROCEDURE getAbbreviation
(IN context CHAR(255), IN term CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_id int;
  DECLARE v_name char;
  DECLARE v_relationship_id int;

  SELECT cv_term.id FROM cv_term,cv WHERE cv.id = cv_term.cv_id AND cv_term.name ='has_abbreviation' AND cv.name = 'prelim_obo' INTO v_relationship_id;

  IF context is NULL THEN
    SELECT subject_id from cv_relationship,cv_term where subject_id = cv_term.id and cv_term.name = term and cv_relationship.type_id = v_relationship_id  LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term;
    ELSE
     SELECT cv.name, t.id,t.name
     FROM cv_relationship  r
     JOIN cv_term t on ( r.object_id = t.id)
     JOIN cv on (cv.id = t.cv_id)
    WHERE  r.subject_id = v_id and r.type_id = v_relationship_id;
    END IF;
  ELSE
    SELECT subject_id from cv_relationship,cv_term, cv where subject_id = cv_term.id and cv.id = cv_term.cv_id and cv_term.name = term and cv_relationship.type_id = v_relationship_id LIMIT 1 INTO v_id;
    IF v_id is NULL THEN
     SELECT cv.name,cv_term.id,cv_term.name FROM cv_term,cv WHERE cv.id = cv_term.cv_id and cv_term.name = term and cv.name = context;
    ELSE
     SELECT cv.name,t.id,t.name
     FROM cv_relationship  r
     JOIN cv_term t on ( r.object_id = t.id)
     JOIN cv on (cv.id = t.cv_id and cv.name = context)
    WHERE  r.subject_id = v_id and r.type_id = v_relationship_id;
    END IF;
  END IF;


END//
DELIMITER ;
