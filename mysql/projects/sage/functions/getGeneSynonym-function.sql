DROP PROCEDURE IF EXISTS getGeneSynonym;
DELIMITER //
CREATE DEFINER = sageAdmin PROCEDURE getGeneSynonym
(IN gene CHAR(255))
DETERMINISTIC
BEGIN

  SELECT synonym
  FROM gene_synonym
  JOIN gene on (gene.id = gene_id)
  WHERE gene.name = gene collate latin1_general_cs;

END//
DELIMITER ;
