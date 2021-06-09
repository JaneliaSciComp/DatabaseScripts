DROP PROCEDURE IF EXISTS getGene;
DELIMITER //
CREATE DEFINER = sageAdmin PROCEDURE getGene
(IN  name CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_gene char(255);
  
  SELECT gene.name INTO v_gene FROM gene WHERE gene.name = name collate latin1_general_cs;

  IF (ISNULL(v_gene)) THEN
    SELECT gene.name
    FROM gene
    JOIN gene_synonym on (gene.id = gene_id)
    WHERE synonym = name;
  ELSE
    SELECT v_gene;
  END IF;

  
END//
DELIMITER ;
