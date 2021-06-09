DROP TABLE IF EXISTS simpson_gal4_mv;

CREATE TABLE simpson_gal4_mv AS
SELECT line_vw.name AS line
       ,line_vw.gene
       ,getGeneSynonymString(line_vw.gene) AS synonyms
       ,ipcr_session_vw.cytology
       ,ipcr_session_vw.comments
       ,siv.url AS brain
       ,siv2.url AS thorax
       ,prelim_annotation_observation_vw.term
       ,prelim_annotation_observation_vw.value AS expressed
       ,getExpressedRegionString(line_vw.name) AS expressed_regions
FROM line_vw
LEFT OUTER JOIN session ipcr on (ipcr.line_id = line_vw.id)
LEFT OUTER JOIN ipcr_session_vw on (ipcr_session_vw.id = ipcr.id)
LEFT OUTER JOIN session prelim on (prelim.line_id = line_vw.id)
LEFT OUTER JOIN prelim_annotation_observation_vw on (prelim_annotation_observation_vw.session_id = prelim.id and prelim_annotation_observation_vw.name ='expressed')
JOIN simpson_rep_image_vw ON (simpson_rep_image_vw.line_id = line_vw.id)
JOIN image_vw iv ON (iv.id = simpson_rep_image_vw.brain_id)
JOIN secondary_image_vw siv ON (siv.image_id = iv.id)
JOIN image_vw iv2 ON (iv2.id = simpson_rep_image_vw.thorax_id)
JOIN secondary_image_vw siv2 ON (siv2.image_id = iv2.id)
WHERE siv.product='projection_all' AND siv2.product='projection_all' AND line_vw.lab ='simpson'
;

CREATE INDEX simpson_gal4_mv_line_ind USING BTREE ON simpson_gal4_mv(line);
CREATE INDEX simpson_gal4_mv_gene_ind USING BTREE ON simpson_gal4_mv(gene);
CREATE INDEX simpson_gal4_mv_term_ind USING BTREE ON simpson_gal4_mv(term);
CREATE INDEX simpson_gal4_mv_expressed_ind USING BTREE ON simpson_gal4_mv(expressed(1));




CREATE OR REPLACE VIEW simpson_gal4_vw AS
SELECT * FROM simpson_gal4_mv;

-- CREATE OR REPLACE VIEW simpson_gal4_vw AS
-- SELECT line_vw.name AS line
--        ,lab
--        ,gene
--       ,getGeneSynonymString(gene) AS synonyms
--        ,ipcr_session_vw.cytology
--        ,siv.url AS brain
--        ,siv2.url AS thorax
-- FROM line_vw
-- LEFT OUTER JOIN session on (session.line_id = line_vw.id)
-- LEFT OUTER JOIN ipcr_session_vw on (ipcr_session_vw.id = session.id)
-- JOIN simpson_rep_image_vw ON (simpson_rep_image_vw.line_id = line_vw.id)
-- JOIN image_vw iv ON (iv.id = simpson_rep_image_vw.brain_id)
-- JOIN secondary_image_vw siv ON (siv.image_id = iv.id)
-- JOIN image_vw iv2 ON (iv2.id = simpson_rep_image_vw.thorax_id)
-- JOIN secondary_image_vw siv2 ON (siv2.image_id = iv2.id)
-- WHERE siv.product='projection_all' AND siv2.product='projection_all'
-- ;
