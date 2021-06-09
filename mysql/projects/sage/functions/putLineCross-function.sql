DROP FUNCTION IF EXISTS putLineCross;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION putLineCross(line1 CHAR(255), line2 CHAR(255), lab CHAR(255), genotype text)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_line1_id int;
  DECLARE v_line2_id int;
  DECLARE v_lab_id int;
  DECLARE v_line_id int;

  SELECT t.id FROM cv_term t, cv c WHERE t.name = lab collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'lab' AND t.is_current = 1 INTO v_lab_id;

  IF (ISNULL(genotype)) THEN SET genotype = 'see parents';
  END IF;

  SELECT l.id FROM line l WHERE l.name = line1 INTO v_line1_id;
  SELECT l.id FROM line l WHERE l.name = line2 INTO v_line2_id;
 
  INSERT INTO line (name,lab_id) VALUES (concat(line1,'-x-',line2),v_lab_id);

  SELECT id FROM line WHERE line.name = concat(line1,'-x-',line2) collate latin1_general_cs AND lab_id = v_lab_id INTO v_line_id;

  INSERT INTO line_property (line_id,type_id,value) 
  SELECT v_line_id
        ,t.id
        ,genotype
  FROM cv_term t
      ,cv c
  WHERE t.name = 'genotype' collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'line' AND t.is_current = 1;

  CALL createLineRelationship (v_line_id,v_line1_id);
  CALL createLineRelationship (v_line_id,v_line2_id);

RETURN v_line_id;

END//
DELIMITER ;
