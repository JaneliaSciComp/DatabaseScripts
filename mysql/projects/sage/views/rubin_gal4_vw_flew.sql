
-- =================================================
-- line data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_line_mv;

CREATE TABLE tmp_rubin_gal4_line_mv AS
SELECT DISTINCT l.name              AS line
      ,g.name                       AS gene
      ,getGeneSynonymString(g.name) AS synonyms
FROM line l
LEFT JOIN gene g on (l.gene_id = g.id);

CREATE INDEX tmp_rubin_gal4_line_line_ind ON tmp_rubin_gal4_line_mv(line);

-- =================================================
-- line disc data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_disc_mv;

CREATE TABLE tmp_rubin_gal4_disc_mv AS
SELECT DISTINCT line
      ,disc
FROM image_data_mv
WHERE external_lab='Mann';

CREATE INDEX tmp_rubin_gal4_disc_line_ind ON tmp_rubin_gal4_disc_mv(line);

-- =================================================
-- line disc list data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_disc_list_mv;

CREATE TABLE tmp_rubin_gal4_disc_list_mv AS
SELECT line
      ,GROUP_CONCAT(DISTINCT disc ORDER BY disc ASC SEPARATOR ', ') AS disc_list
FROM image_data_mv
WHERE external_lab='Mann'
GROUP BY line;

CREATE INDEX tmp_rubin_gal4_disc_list_line_ind ON tmp_rubin_gal4_disc_list_mv(line);

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
-- line distribution data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_distribution_mv;

CREATE TABLE tmp_rubin_gal4_distribution_mv AS
SELECT DISTINCT l.name              AS line
      ,getcvtermname(pa.term_id)    AS term
      ,pa.value                     AS distribution
FROM line l
JOIN session prelim on (prelim.line_id = l.id)
JOIN observation pa on (pa.session_id = prelim.id)
JOIN cv_term ct on (pa.type_id = ct.id and ct.name ='distribution');

CREATE INDEX tmp_rubin_gal4_distribution_line_ind ON tmp_rubin_gal4_distribution_mv(line);
CREATE INDEX tmp_rubin_gal4_distribution_term_ind ON tmp_rubin_gal4_distribution_mv(term);

-- =================================================
-- line region list data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_region_mv;

CREATE TABLE tmp_rubin_gal4_region_mv AS
SELECT i4.line
      ,GROUP_CONCAT(DISTINCT concat(i4.term," (",i4.intensity,",",ifnull(d.distribution,'vnc'),")") ORDER BY i4.term ASC SEPARATOR ', ') AS expressed_regions
FROM tmp_rubin_gal4_intensity_mv i4
LEFT JOIN tmp_rubin_gal4_distribution_mv d on (i4.line = d.line and i4.term=d.term)
GROUP BY i4.line;

-- =================================================
-- line image data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_image_mv;

CREATE TABLE tmp_rubin_gal4_image_mv AS
SELECT DISTINCT id.line
      ,id.organ AS organ
      ,srp.url  AS ref_pattern
      ,sp.url   AS pattern
      ,sr.url   AS registered
      ,st.url   AS translation
FROM line_vw l
JOIN image_data_mv id ON (id.line=l.name)
LEFT JOIN secondary_image_vw srp ON (srp.image_id=id.id AND srp.product='projection_all')
LEFT JOIN secondary_image_vw sp ON (sp.image_id=id.id AND sp.product='projection_pattern')
LEFT JOIN secondary_image_vw st ON (st.image_id=id.id AND st.product='translation')
LEFT OUTER JOIN secondary_image_vw sr ON (sr.image_id=id.id AND sr.product='projection_local_registered')
WHERE lab IN ('dickson','rubin');

CREATE INDEX tmp_rubin_gal4_image_line_ind ON tmp_rubin_gal4_image_mv(line);

-- =================================================
-- line gfp_pattern data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_mann_gfp_pattern_mv;

CREATE TABLE tmp_rubin_mann_gfp_pattern_mv AS
select l.name as line
      ,tr.display_name as disc_type      
      ,ty.name as gfp_pattern
      ,ty.display_name as gfp_pattern_display_name
from line l
join session s on (s.line_id = l.id)
join observation o on (o.session_id = s.id)
join cv_term tr on (o.term_id = tr.id)
join cv c on (tr.cv_id = c.id and c.name = 'imaginal_disc_expression')
join cv_term ty on (o.type_id = ty.id)
;

CREATE INDEX tmp_rubin_mann_gfp_pattern_mv_line_ind ON tmp_rubin_mann_gfp_pattern_mv(line);

-- =================================================
-- line gfp_pattern list data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_mann_gfp_pattern_list_mv;

CREATE TABLE tmp_rubin_mann_gfp_pattern_list_mv AS
select l.name as line
      ,GROUP_CONCAT(DISTINCT tr.display_name ORDER BY tr.display_name ASC SEPARATOR ', ') AS disc_type_list
from line l
join session s on (s.line_id = l.id)
join observation o on (o.session_id = s.id)
join cv_term tr on (o.term_id = tr.id)
join cv c on (tr.cv_id = c.id and c.name = 'imaginal_disc_expression')
join cv_term ty on (o.type_id = ty.id)
group by l.name
;

CREATE INDEX tmp_rubin_mann_gfp_pattern_list_mv_line_ind ON tmp_rubin_mann_gfp_pattern_list_mv(line);

-- =================================================
-- rubin gal4 data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_mv;

CREATE TABLE tmp_rubin_gal4_mv AS
SELECT i.line
      ,l.gene
      ,l.synonyms
      ,i4.term
      ,i4.intensity
      ,ds.distribution
      ,r.expressed_regions
      ,dl.disc_list
      ,d.disc
      ,i.organ
      ,i.ref_pattern
      ,i.pattern
      ,i.registered
      ,i.translation
FROM tmp_rubin_gal4_image_mv i
LEFT JOIN tmp_rubin_gal4_line_mv l ON (i.line = l.line)
LEFT JOIN tmp_rubin_gal4_intensity_mv i4 ON (i4.line = i.line)
LEFT JOIN tmp_rubin_gal4_distribution_mv ds ON (ds.line = i.line and ds.term = i4.term)
LEFT JOIN tmp_rubin_gal4_disc_mv d ON (i.line = d.line)
LEFT JOIN tmp_rubin_gal4_disc_list_mv dl ON (i.line = dl.line)
LEFT JOIN tmp_rubin_gal4_region_mv r ON (i.line = r.line)
;

CREATE INDEX rubin_gal4_mv_line_ind USING BTREE ON tmp_rubin_gal4_mv(line);
CREATE INDEX rubin_gal4_mv_gene_ind USING BTREE ON tmp_rubin_gal4_mv(gene);
CREATE INDEX rubin_gal4_mv_term_ind USING BTREE ON tmp_rubin_gal4_mv(term);

-- =================================================
-- rubin mann gal4 data
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_mann_gal4_mv;

CREATE TABLE tmp_rubin_mann_gal4_mv
SELECT l.line
      ,l.gene
      ,l.synonyms
      ,g.disc_type
      ,g.gfp_pattern
      ,g.gfp_pattern_display_name
      ,gl.disc_type_list
FROM tmp_rubin_mann_gfp_pattern_mv g
LEFT OUTER JOIN tmp_rubin_gal4_line_mv l ON (g.line = l.line)
LEFT OUTER JOIN tmp_rubin_mann_gfp_pattern_list_mv gl ON (g.line = gl.line)
;

CREATE INDEX rubin_mann_gal4_mv_line_ind USING BTREE ON tmp_rubin_mann_gal4_mv(line);
CREATE INDEX rubin_mann_gal4_mv_gene_ind USING BTREE ON tmp_rubin_mann_gal4_mv(gene);
CREATE INDEX rubin_mann_gal4_mv_disc_type_ind USING BTREE ON tmp_rubin_mann_gal4_mv(disc_type);
CREATE INDEX rubin_mann_gal4_mv_gfp_pattern_ind USING BTREE ON tmp_rubin_mann_gal4_mv(gfp_pattern);
CREATE INDEX rubin_mann_gal4_mv_gfp_pattern_name_ind USING BTREE ON tmp_rubin_mann_gal4_mv(gfp_pattern_display_name);
CREATE INDEX rubin_mann_gal4_mv_gfp_pattern_disc_list_ind USING BTREE ON tmp_rubin_mann_gal4_mv(disc_type_list(250));

-- =================================================
-- create mv
-- =================================================
DROP TABLE IF EXISTS tmp_rubin_gal4_line_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_disc_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_disc_list_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_intensity_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_distribution_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_region_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_image_mv;
DROP TABLE IF EXISTS tmp_rubin_mann_gfp_pattern_mv;

DROP TABLE IF EXISTS rubin_gal4_mv;
RENAME TABLE tmp_rubin_gal4_mv TO rubin_gal4_mv;

CREATE OR REPLACE VIEW rubin_gal4_vw AS
SELECT * FROM rubin_gal4_mv;

DROP TABLE IF EXISTS rubin_mann_gal4_mv;
RENAME TABLE tmp_rubin_mann_gal4_mv TO rubin_mann_gal4_mv;

CREATE OR REPLACE VIEW rubin_mann_gal4_vw AS
SELECT * FROM rubin_mann_gal4_mv;

