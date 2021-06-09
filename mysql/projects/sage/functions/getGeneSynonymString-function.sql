DROP FUNCTION IF EXISTS getGeneSynonymString;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getGeneSynonymString
(gene CHAR(255))
RETURNS CHAR(255)
DETERMINISTIC
BEGIN

 DECLARE v_name text DEFAULT '';
 DECLARE v_string text DEFAULT '';
 DECLARE done int DEFAULT 0;

 DECLARE gene_cur CURSOR FOR 
  SELECT synonym
  FROM gene_synonym
  JOIN gene on (gene.id = gene_id)
  WHERE gene.name = gene collate latin1_general_cs;
 DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN gene_cur;
    REPEAT
      FETCH gene_cur INTO v_name;
      IF NOT done THEN
         IF (v_string = '') THEN
           SET v_string := v_name;
         ELSE
           SET v_string := CONCAT(v_string,", ",v_name);
         END IF;
      END IF;
    UNTIL done END REPEAT; 
  CLOSE gene_cur;

  RETURN v_string;

END;
//
DELIMITER ;
