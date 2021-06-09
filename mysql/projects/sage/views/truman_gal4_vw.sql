DROP TABLE IF EXISTS tmp_rubin_gal4_truman_mv;

CREATE TABLE tmp_rubin_gal4_truman_mv AS
SELECT DISTINCT 
		l.id as id,
		l.name as line
      ,g.name                       AS gene
      ,getGeneSynonymString(g.name) AS synonyms
--      ,ct.display_name as type

      ,(case when lp.value='Y' THEN ct.definition else NULL end) as type 
FROM line l
-- JOIN line_property lp ON (l.id = lp.line_id AND lp.value = 'Y')
JOIN line_property lp ON (l.id = lp.line_id )
JOIN cv_term ct ON (lp.type_id = ct.id AND (ct.cv_id in (select id from cv where name='truman_line')))
LEFT JOIN gene g on (l.gene_id = g.id)
;
CREATE INDEX tmp_rubin_gal4_truman_line_ind ON tmp_rubin_gal4_truman_mv(line);



drop table if exists tmp_rubin_gal4_truman_list_mv ;
create table tmp_rubin_gal4_truman_list_mv as
SELECT id,
		line
      ,GROUP_CONCAT(DISTINCT type ORDER BY type ASC SEPARATOR ', ') AS type_list
FROM tmp_rubin_gal4_truman_mv 
GROUP BY line;


drop table if exists tmp_gal4_truman_mv ;
create table tmp_gal4_truman_mv as
SELECT gs.line
      ,gs.gene
      ,gs.synonyms
      ,gs.type as term
      ,'Y' as expressed
      ,gsl.type_list as expressed_regions
      , i.url 
      ,MAX(IF(STRCMP(si.product,'projection_green'),null,si.url)) AS 'ref_pattern'
      ,MAX(IF(STRCMP(si.product,'rock_green'),null,si.url)) AS 'rock'
      ,MAX(IF(STRCMP(si.product,'translation'),null,si.url)) AS 'translation'
FROM  tmp_rubin_gal4_truman_mv gs
LEFT OUTER JOIN tmp_rubin_gal4_truman_list_mv gsl ON (gs.line = gsl.line )
left outer join image i on (i.line_id= gs.id and i.family_id = (select id from cv_term where name='truman_chacrm'))
left outer join secondary_image_vw si on (i.id = si.image_id)
group by gs.line, gs.type;

CREATE INDEX rubin_gal4_truman_mv_line_ind USING BTREE ON tmp_gal4_truman_mv(line);
CREATE INDEX rubin_gal4_truman_mv_gene_ind USING BTREE ON tmp_gal4_truman_mv(gene);
CREATE INDEX rubin_gal4_truman_mv_term_ind USING BTREE ON tmp_gal4_truman_mv(term(255));
CREATE INDEX rubin_gal4_truman_mv_expressed_ind USING BTREE ON tmp_gal4_truman_mv(expressed);

DROP TABLE IF EXISTS tmp_rubin_gal4_truman_mv;
DROP TABLE IF EXISTS tmp_rubin_gal4_truman_list_mv;


DROP TABLE IF EXISTS truman_gal4_mv;
RENAME TABLE tmp_gal4_truman_mv TO truman_gal4_mv;

CREATE OR REPLACE VIEW truman_gal4_vw AS
SELECT * FROM truman_gal4_mv;
