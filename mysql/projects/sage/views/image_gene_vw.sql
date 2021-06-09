CREATE OR REPLACE VIEW image_gene_vw AS
SELECT image.id as image_id,
       cv_term.name family,
       gene.gene as gene
FROM image 
JOIN line ON (image.line_id = line.id)
JOIN gene_data_mv gene ON (line.gene_id = gene.id)
JOIN cv_term ON (image.family_id = cv_term.id)
;
