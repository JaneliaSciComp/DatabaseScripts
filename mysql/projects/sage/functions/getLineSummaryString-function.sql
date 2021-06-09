DROP FUNCTION IF EXISTS getLineSummaryString;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getLineSummaryString
(lineName CHAR(255))
RETURNS CHAR(255)
DETERMINISTIC
BEGIN

 DECLARE v_name text DEFAULT '';
 DECLARE v_count text DEFAULT '';
 DECLARE v_string text DEFAULT '';
 DECLARE done int DEFAULT 0;

 DECLARE line_cur CURSOR FOR 
  SELECT definition,count(1)
  FROM session_vw JOIN cv on (cv.name = session_vw.cv and cv.name != 'fly_olympiad')
  WHERE line = lineName collate latin1_general_cs
  GROUP BY definition;
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
