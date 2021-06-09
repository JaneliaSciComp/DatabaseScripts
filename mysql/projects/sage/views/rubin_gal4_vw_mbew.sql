DROP TABLE IF EXISTS tmp_rubin_gal4_line_mv;

CREATE TABLE tmp_rubin_gal4_line_mv AS
SELECT l.name              AS line
      ,max(lp.name)        AS line1
      ,IF(STRCMP(min(lp.name),max(lp.name)),min(lp.name),null)        AS line2
FROM line l
JOIN line_relationship lr on (lr.subject_id = l.id)
JOIN line lp on (lr.object_id = lp.id)
GROUP BY l.name;

CREATE INDEX tmp_rubin_gal4_line_line_ind ON tmp_rubin_gal4_line_mv(line);

-- =================================================
-- line intensity data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_intensity_mv;

CREATE TABLE tmp_rubin_gal4_intensity_mv AS
SELECT DISTINCT l.name              AS line
      ,getcvtermname(pa.term_id)    AS term
      ,pa.value                     AS intensity
FROM line l
JOIN session prelim on (prelim.line_id = l.id)
JOIN observation pa on (pa.session_id = prelim.id)
JOIN cv_term ct on (pa.type_id = ct.id and ct.name ='intensity');

CREATE INDEX tmp_rubin_gal4_intensity_line_ind ON tmp_rubin_gal4_intensity_mv(line);
CREATE INDEX tmp_rubin_gal4_intensity_term_ind ON tmp_rubin_gal4_intensity_mv(term);

-- =================================================
-- line region list data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_region_mv;

CREATE TABLE tmp_rubin_gal4_region_mv AS
SELECT i4.line
      ,GROUP_CONCAT(DISTINCT concat(i4.term," (",i4.intensity,")") ORDER BY i4.term ASC SEPARATOR ', ') AS expressed_regions
FROM tmp_rubin_gal4_intensity_mv i4
GROUP BY i4.line;

-- =================================================
-- line image data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_image_mv;

CREATE TABLE tmp_rubin_gal4_image_mv AS
SELECT DISTINCT l.name as sage_line
      ,id.publishing_name as line
      ,id.area AS area
      ,srp.url  AS ref_pattern
      ,sp.url   AS pattern
      ,sr.url   AS registered
      ,st.url   AS translation
      ,ip.value AS alps_release
FROM line_vw l
LEFT JOIN image_data_mv id ON (id.line=l.name)
LEFT JOIN secondary_image_vw srp ON (srp.image_id=id.id AND srp.product='projection_all')
LEFT JOIN secondary_image_vw sp ON (sp.image_id=id.id AND sp.product='projection_pattern')
LEFT JOIN secondary_image_vw st ON (st.image_id=id.id AND st.product='translation')
LEFT OUTER JOIN secondary_image_vw sr ON (sr.image_id=id.id AND sr.product='projection_local_registered')
LEFT JOIN image_property_vw ip ON (id.id = ip.image_id AND ip.type='alps_release')
;

CREATE INDEX tmp_rubin_gal4_image_line_ind ON tmp_rubin_gal4_image_mv(sage_line);

-- =================================================
-- rubin gal4 data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_mv;

CREATE TABLE tmp_rubin_gal4_mv AS
SELECT i.sage_line
      ,i.line
      ,i4.term
      ,i4.intensity
      ,r.expressed_regions
     ,i.area
      ,l.line1
      ,l.line2
      ,i.alps_release
FROM tmp_rubin_gal4_image_mv i
LEFT JOIN tmp_rubin_gal4_line_mv l ON (i.sage_line = l.line)
LEFT JOIN tmp_rubin_gal4_intensity_mv i4 ON (i4.line = i.sage_line)
-- LEFT JOIN tmp_rubin_gal4_distribution_mv ds ON (ds.line = i.sage_line and ds.term = i4.term)
-- LEFT JOIN tmp_rubin_gal4_disc_mv d ON (i.sage_line = d.line)
-- LEFT JOIN tmp_rubin_gal4_disc_list_mv dl ON (i.sage_line = dl.line)
LEFT JOIN tmp_rubin_gal4_region_mv r ON (i.sage_line = r.line)
;

CREATE INDEX splitgal4_mv_line_ind USING BTREE ON tmp_rubin_gal4_mv(sage_line);
CREATE INDEX splitgal4_mv_line1_ind USING BTREE ON tmp_rubin_gal4_mv(line1);
CREATE INDEX splitgal4_mv_line2_ind USING BTREE ON tmp_rubin_gal4_mv(line2);
CREATE INDEX splitgal4_mv_term_ind USING BTREE ON tmp_rubin_gal4_mv(term);

-- =================================================
-- create mv
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_intensity_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_region_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_image_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_line_mv;

DROP TABLE IF EXISTS splitgal4_driver_mv;
RENAME TABLE tmp_rubin_gal4_mv TO splitgal4_driver_mv;

CREATE OR REPLACE VIEW splitgal4_driver_vw AS
SELECT * FROM splitgal4_driver_mv;
