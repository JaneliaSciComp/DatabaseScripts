CREATE OR REPLACE VIEW line_gene_vw AS
SELECT line.id   AS line_id
      ,gene.name AS gene
FROM gene
JOIN line ON (line.gene_id = gene.id)
UNION
SELECT line.id AS line_id
      ,gene_synonym.synonym collate latin1_general_cs AS synonym
FROM gene_synonym
JOIN gene ON ( gene_synonym.gene_id = gene.id)
JOIN line ON (line.gene_id = gene.id)
;
