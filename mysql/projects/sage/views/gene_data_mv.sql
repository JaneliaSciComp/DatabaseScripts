/*
  This materialized view creates a list of gene and gene synonym using 
  a union clause.  Unions have performance issue in 5.1+, so this mv
  is created as a work around.
*/


-- create temp table
DROP TABLE IF EXISTS tmp_gene_data_mv;

CREATE TABLE tmp_gene_data_mv AS
SELECT  gene.id as id, gene.name as gene
FROM gene 
UNION
SELECT gene.id as id, gene_synonym.synonym collate latin1_general_cs as gene
FROM gene
JOIN gene_synonym ON (gene.id = gene_synonym.gene_id);

CREATE INDEX gene_data_mv_gene_ind on tmp_gene_data_mv(id);

-- drop table
DROP TABLE IF EXISTS gene_data_mv;

-- rename temp table
RENAME TABLE tmp_gene_data_mv TO gene_data_mv;
