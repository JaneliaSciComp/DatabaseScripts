DROP TABLE IF EXISTS tmp_rubin_gal4_mv;

CREATE TABLE tmp_rubin_gal4_mv AS
SELECT l.name AS line
       ,l.gene
       ,getGeneSynonymString(l.gene) AS synonyms
       ,prelim_annotation_observation_vw.term
       ,prelim_annotation_observation_vw.value AS expressed
       ,getExpressedRegionString(l.name) AS expressed_regions
       ,organ
       ,srp.url AS ref_pattern
       ,sp.url AS pattern
       ,sr.url AS registered
       ,st.url AS translation
FROM line_vw l
LEFT OUTER JOIN session prelim on (prelim.line_id = l.id)
LEFT OUTER JOIN prelim_annotation_observation_vw on (prelim_annotation_observation_vw.session_id = prelim.id and prelim_annotation_observation_vw.name ='expressed')
JOIN image_data_mv id ON (id.line=l.name)
JOIN secondary_image_vw srp ON (srp.image_id=id.id AND srp.product='projection_all')
JOIN secondary_image_vw sp ON (sp.image_id=id.id AND sp.product='projection_pattern')
LEFT OUTER JOIN secondary_image_vw sr ON (sr.image_id=id.id AND sr.product='projection_local_registered')
JOIN secondary_image_vw st ON (st.image_id=id.id AND st.product='translation')
WHERE lab='rubin'
;

CREATE INDEX rubin_gal4_mv_line_ind USING BTREE ON tmp_rubin_gal4_mv(line);
CREATE INDEX rubin_gal4_mv_gene_ind USING BTREE ON tmp_rubin_gal4_mv(gene);
CREATE INDEX rubin_gal4_mv_term_ind USING BTREE ON tmp_rubin_gal4_mv(term);
CREATE INDEX rubin_gal4_mv_expressed_ind USING BTREE ON tmp_rubin_gal4_mv(expressed(1));

DROP TABLE IF EXISTS rubin_gal4_mv;
RENAME TABLE tmp_rubin_gal4_mv TO rubin_gal4_mv;

CREATE OR REPLACE VIEW rubin_gal4_vw AS
SELECT * FROM rubin_gal4_mv;
