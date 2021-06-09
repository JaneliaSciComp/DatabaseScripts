DELIMITER //

DROP PROCEDURE IF EXISTS getSibling
//

CREATE DEFINER = annotationAdmin PROCEDURE getSibling
(IN context CHAR(255), IN term CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_id int DEFAULT 0;

  -- get id of term passed in 
  SELECT cv_term.id FROM cv_term, cv WHERE cv.id = cv_term.cv_id AND cv.name = context AND cv_term.name = term INTO v_id;

  -- show the result
  SELECT sibling.name siblings
  FROM cv_relationship parent_rel
  INNER JOIN cv_term parent ON parent_rel.object_id = parent.id
  INNER JOIN cv_term self on (parent_rel.subject_id = self.id and self.id = v_id)
  INNER JOIN cv_term rel_type ON (parent_rel.type_id = rel_type.id and rel_type.name = 'part_of')
  INNER JOIN cv_relationship sibling_rel ON (sibling_rel.object_id = parent.id)
  INNER JOIN cv_term sibling_rel_type ON (sibling_rel.type_id = sibling_rel_type.id and sibling_rel_type.name = 'part_of')
  INNER JOIN cv_term sibling on (sibling_rel.subject_id = sibling.id and sibling.id != v_id);

END;
//

DELIMITER ;
