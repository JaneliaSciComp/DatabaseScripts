DELIMITER /

DROP TRIGGER IF EXISTS synonymsGene
/ 
  
CREATE TRIGGER synonymsGene AFTER INSERT ON  gene_synonym
FOR EACH ROW 
BEGIN
  DECLARE v_gene_name CHAR(100) DEFAULT 0;

  SELECT name INTO v_gene_name
  FROM gene
  WHERE id = NEW.gene_id;

  UPDATE gene SET synonym_string = getGeneSynonymString(v_gene_name) 
  WHERE id =  NEW.gene_id;

END;
/

DELIMITER ;    

