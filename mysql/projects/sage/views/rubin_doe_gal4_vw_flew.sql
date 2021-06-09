
-- =================================================
-- line doe data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_gbe_st16_mv;

CREATE TABLE tmp_rubin_gal4_gbe_st16_mv AS
SELECT DISTINCT l.name as line
      ,g.name                       AS gene
      ,getGeneSynonymString(g.name) AS synonyms
--      ,ct.display_name as type
      ,(case when lp.value='Y' THEN ct.display_name else NULL end) as type 
      ,(case when ct.name like 'st16%' then '16' else 'GBE' end) as stage
FROM line l
-- JOIN line_property lp ON (l.id = lp.line_id AND lp.value = 'Y')
JOIN line_property lp ON (l.id = lp.line_id )
JOIN cv_term ct ON (lp.type_id = ct.id AND (ct.name like 'gbe%' or ct.name like 'st16%'))
LEFT JOIN gene g on (l.gene_id = g.id)
;

CREATE INDEX tmp_rubin_gal4_gbe_st16_line_ind ON tmp_rubin_gal4_gbe_st16_mv(line);

-- =================================================
-- line doe list data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_gbe_st16_list_mv;

CREATE TABLE tmp_rubin_gal4_gbe_st16_list_mv AS
SELECT line
      ,GROUP_CONCAT(DISTINCT type ORDER BY type ASC SEPARATOR ', ') AS type_list
      ,'GBE' as stage
FROM tmp_rubin_gal4_gbe_st16_mv
WHERE type like 'GBE%' 
GROUP BY line, stage;

INSERT INTO tmp_rubin_gal4_gbe_st16_list_mv
SELECT line
      ,GROUP_CONCAT(DISTINCT type ORDER BY type ASC SEPARATOR ', ') AS type_list
      ,'16' as stage
FROM tmp_rubin_gal4_gbe_st16_mv
WHERE type like 'Stage 16%'
GROUP BY line, stage;

INSERT INTO tmp_rubin_gal4_gbe_st16_list_mv
SELECT line
       ,NULL AS type_list
       ,stage
FROM tmp_rubin_gal4_gbe_st16_mv
WHERE type IS NULL
      AND stage='16'
      AND NOT EXISTS (SELECT 1 FROM tmp_rubin_gal4_gbe_st16_list_mv x
                      WHERE x.line=tmp_rubin_gal4_gbe_st16_mv.line
                      AND tmp_rubin_gal4_gbe_st16_mv.stage='16')
GROUP BY line, stage;

INSERT INTO tmp_rubin_gal4_gbe_st16_list_mv
SELECT line
       ,NULL AS type_list
       ,stage
FROM tmp_rubin_gal4_gbe_st16_mv
WHERE type IS NULL
      AND stage='GBE'
      AND NOT EXISTS (SELECT 1 FROM tmp_rubin_gal4_gbe_st16_list_mv x
                      WHERE x.line=tmp_rubin_gal4_gbe_st16_mv.line
                      AND tmp_rubin_gal4_gbe_st16_mv.stage='GBE')
GROUP BY line, stage;

CREATE INDEX tmp_rubin_gal4_gbe_st16_list_line_ind ON tmp_rubin_gal4_gbe_st16_list_mv(line);


-- =================================================
-- line stage data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_stage_mv;

CREATE TABLE tmp_rubin_gal4_stage_mv AS
SELECT DISTINCT line
      ,stage 
FROM image_data_mv
WHERE external_lab='Doe';

CREATE INDEX tmp_rubin_gal4_stage_line_ind ON tmp_rubin_gal4_stage_mv(line);

-- =================================================
-- line image data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_doe_gal4_image_mv;

CREATE TABLE tmp_rubin_doe_gal4_image_mv AS
SELECT DISTINCT l.name as line
      ,i.url  AS url
      ,(case when ct.name = 'st16_stage_image' then '16' else 'GBE' end) as stage
FROM line l
JOIN image i ON (i.line_id = l.id)
JOIN image_property ip ON (ip.image_id=i.id and ip.value = 'Y')
JOIN cv_term ct ON (ct.id = ip.type_id AND (ct.name = 'st16_stage_image' or ct.name = 'gbe_stage_image'))
;

CREATE INDEX tmp_rubin_doe_gal4_image_line_ind ON tmp_rubin_doe_gal4_image_mv(line);

-- =================================================
-- rubin doe gal4 data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_doe_gal4_mv;

CREATE TABLE tmp_rubin_doe_gal4_mv AS
SELECT i.line
      ,gs.gene
      ,gs.synonyms
      ,gs.type as term
      ,'Y' as expressed
      ,gsl.type_list as expressed_regions
      ,s.stage  
      ,i.url
FROM tmp_rubin_doe_gal4_image_mv i
JOIN tmp_rubin_gal4_gbe_st16_mv gs ON (i.line = gs.line and i.stage = gs.stage)
LEFT OUTER JOIN tmp_rubin_gal4_gbe_st16_list_mv gsl ON (i.line = gsl.line and i.stage = gsl.stage)
LEFT OUTER JOIN tmp_rubin_gal4_stage_mv s ON (i.line = s.line and i.stage = s.stage collate latin1_general_cs)
;

CREATE INDEX rubin_doe_gal4_mv_line_ind USING BTREE ON tmp_rubin_doe_gal4_mv(line);
CREATE INDEX rubin_doe_gal4_mv_gene_ind USING BTREE ON tmp_rubin_doe_gal4_mv(gene);
CREATE INDEX rubin_doe_gal4_mv_term_ind USING BTREE ON tmp_rubin_doe_gal4_mv(term);
CREATE INDEX rubin_doe_gal4_mv_expressed_ind USING BTREE ON tmp_rubin_doe_gal4_mv(expressed);

-- =================================================
-- create mv
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_gbe_st16_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_gbe_st16_list_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_stage_mv;
DROP TABLE IF EXISTS tmp_rubin_doe_gal4_image_mv;

DROP TABLE IF EXISTS rubin_doe_gal4_mv;
RENAME TABLE tmp_rubin_doe_gal4_mv TO rubin_doe_gal4_mv;

CREATE OR REPLACE VIEW rubin_doe_gal4_vw AS
SELECT * FROM rubin_doe_gal4_mv;
