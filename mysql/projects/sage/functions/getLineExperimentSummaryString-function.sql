DROP FUNCTION IF EXISTS getLineExperimentSummaryString;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getLineExperimentSummaryString
(lineName CHAR(255))
RETURNS CHAR(255)
DETERMINISTIC
BEGIN

 DECLARE v_name text DEFAULT '';
 DECLARE v_count text DEFAULT '';
 DECLARE v_string text DEFAULT '';
 DECLARE done int DEFAULT 0;

 DECLARE line_cur CURSOR FOR 
  SELECT cv.definition,count(distinct e.id)
  FROM line l
  JOIN session s FORCE INDEX (session_line_id_fk_ind) on (s.line_id = l.id)
  JOIN experiment e ON (s.experiment_id = e.id) 
  JOIN cv_term ct on (e.type_id = ct.id) 
  JOIN cv on (cv.id = ct.cv_id)   
  WHERE l.name = lineName collate latin1_general_cs
  GROUP BY cv.definition;
 DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN line_cur;
    REPEAT
      FETCH line_cur INTO v_name,v_count;
      IF NOT done THEN
         IF (v_string = '') THEN
           SET v_string := CONCAT(v_name," (",v_count,")");
         ELSE
           SET v_string := CONCAT(v_string,", ",v_name," (",v_count,")");
         END IF;
      END IF;
    UNTIL done END REPEAT; 
  CLOSE line_cur;

  RETURN v_string;

END;
//
DELIMITER ;
