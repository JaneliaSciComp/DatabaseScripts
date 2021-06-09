DROP FUNCTION IF EXISTS getExpressedRegionString;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getExpressedRegionString
(line CHAR(255))
RETURNS CHAR(255)
DETERMINISTIC
BEGIN

  DECLARE v_name text DEFAULT '';
  DECLARE v_abbr text DEFAULT '';
  DECLARE v_string text DEFAULT '';
  DECLARE done int DEFAULT 0;
  DECLARE v_relationship_id int;

  DECLARE line_cur CURSOR FOR 
    SELECT DISTINCT term 
    FROM session_vw JOIN prelim_annotation_observation_vw on (prelim_annotation_observation_vw.session_id = session_vw.id and prelim_annotation_observation_vw.name ='expressed' and prelim_annotation_observation_vw.value = 'Y')
    WHERE session_vw.line = line collate latin1_general_cs
    ORDER BY term;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;


  SELECT cv_term.id FROM cv_term,cv WHERE cv.id = cv_term.cv_id AND cv_term.name ='has_abbreviation' collate latin1_general_cs AND cv.name = 'obo' INTO v_relationship_id;

  OPEN line_cur;
    REPEAT
      FETCH line_cur INTO v_name;
      IF NOT done THEN

        SELECT o.name
        FROM  cv_term_relationship r
        JOIN cv_term s on ( r.subject_id = s.id and s.name = v_name collate latin1_general_cs)
--        JOIN cv c ON (s.cv_id=c.id AND c.name='flylight_public_annotation_abbreviations')
        JOIN cv_term o on ( r.object_id = o.id)
        WHERE r.type_id = v_relationship_id 
        INTO v_abbr;

        IF (v_string = '') THEN
          SET v_string := v_abbr;
        ELSE
          SET v_string := CONCAT(v_string,", ",v_abbr);
        END IF;
      END IF;
    UNTIL done END REPEAT; 
  CLOSE line_cur;

  RETURN v_string;

END;
//
DELIMITER ;
