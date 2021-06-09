DELIMITER //

DROP PROCEDURE IF EXISTS createLineRelationship
//

CREATE DEFINER = sageAdmin PROCEDURE createLineRelationship
(IN child_line_id int, IN parent_line_id int)
DETERMINISTIC
BEGIN
  DECLARE v_child_type_id int DEFAULT 0;
  DECLARE v_parent_type_id int DEFAULT 0;

  -- get type id of relationship
  SELECT cv_term.id FROM cv_term, cv WHERE cv.id = cv_term.cv_id AND cv.name = 'schema' AND cv_term.name = 'child_of' collate latin1_general_cs INTO v_child_type_id;
  SELECT cv_term.id FROM cv_term, cv WHERE cv.id = cv_term.cv_id AND cv.name = 'schema' AND cv_term.name = 'parent_of' collate latin1_general_cs INTO v_parent_type_id;

  -- create bidirectional relationship
  INSERT INTO line_relationship (type_id,subject_id,object_id) VALUES (v_child_type_id,child_line_id,parent_line_id),(v_parent_type_id,parent_line_id,child_line_id);

END;
//

DELIMITER ;
