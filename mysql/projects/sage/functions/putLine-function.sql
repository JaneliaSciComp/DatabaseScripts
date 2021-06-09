DROP FUNCTION IF EXISTS putLine;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION putLine(name CHAR(255), lab CHAR(255), gene CHAR(255), organism_id INT, genotype text, registered_by CHAR(255),robot_id CHAR(255), description CHAR(255),flycore_id  CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_line_id int;
  DECLARE v_gene_id int;
  DECLARE v_lab_id int;

  SELECT t.id FROM cv_term t, cv c WHERE t.name = lab collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'lab' AND t.is_current = 1 INTO v_lab_id;
 
  SELECT gene.id INTO v_gene_id FROM gene WHERE gene.name = gene collate latin1_general_cs;

  IF (ISNULL(v_gene_id)) THEN
    SELECT gene.id
    INTO v_gene_id
    FROM gene
    JOIN gene_synonym on (gene.id = gene_id)
    WHERE synonym = gene;
  END IF;

  INSERT INTO line (name,lab_id,gene_id,organism_id) VALUES (name,v_lab_id,v_gene_id,organism_id);
    IF (ISNULL(v_gene_id)) THEN
      SELECT id FROM line WHERE line.name = name collate latin1_general_cs AND lab_id = v_lab_id INTO v_line_id;
    ELSE
      SELECT id FROM line WHERE line.name = name collate latin1_general_cs AND lab_id = v_lab_id AND gene_id = v_gene_id INTO v_line_id;
    END IF;


  INSERT INTO line_property (line_id,type_id,value) 
  SELECT v_line_id
        ,t.id
        ,registered_by
  FROM cv_term t
      ,cv c
  WHERE t.name = 'registered_by' collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'line' AND t.is_current = 1;

  INSERT INTO line_property (line_id,type_id,value) 
  SELECT v_line_id
        ,t.id
        ,genotype
  FROM cv_term t
      ,cv c
  WHERE t.name = 'genotype' collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'line' AND t.is_current = 1;

  INSERT INTO line_property (line_id,type_id,value)
  SELECT v_line_id
        ,t.id
        ,robot_id
  FROM cv_term t
      ,cv c
  WHERE t.name = 'robot_id' collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'line' AND t.is_current = 1;

  INSERT INTO line_property (line_id,type_id,value)
  SELECT v_line_id
        ,t.id
        ,description
  FROM cv_term t
      ,cv c
  WHERE t.name = 'description' collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'line' AND t.is_current = 1;

  INSERT INTO line_property (line_id,type_id,value)
  SELECT v_line_id
        ,t.id
        ,flycore_id
  FROM cv_term t
      ,cv c
  WHERE t.name = 'flycore_id' collate latin1_general_cs AND t.cv_id = c.id AND c.name = 'line' AND t.is_current = 1;

RETURN v_line_id;

END//
DELIMITER ;
