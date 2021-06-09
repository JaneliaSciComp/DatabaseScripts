CREATE OR REPLACE VIEW line_vw AS
SELECT l.id                             AS id
      ,l.name                           AS name
      ,lab.name                         AS lab
      ,lab.display_name                 AS lab_display_name
      ,g.name                           AS gene
      ,g.synonym_string                 AS synonyms
      ,concat(o.genus,' ',o.species)    AS organism
      ,lp.value                         AS genotype
      ,lp2.value                        AS robot_id
      ,lp3.value                        AS flycore_id
      ,lp4.value                        AS hide
      ,l.create_date                    AS create_date
FROM line l
JOIN cv_term lab ON (l.lab_id = lab.id)
JOIN cv lab_cv ON (lab.cv_id = lab_cv.id AND lab_cv.name = 'lab')
LEFT JOIN organism o ON (l.organism_id = o.id)
LEFT JOIN line_property lp ON (lp.line_id = l.id AND lp.type_id = getcvtermid('line','genotype',null))
LEFT JOIN line_property lp2 ON (lp2.line_id = l.id AND lp2.type_id = getcvtermid('line','robot_id',null))
LEFT JOIN line_property lp3 ON (lp3.line_id = l.id AND lp3.type_id = getcvtermid('line','flycore_id',null))
LEFT JOIN line_property lp4 ON (lp4.line_id = l.id AND lp4.type_id = getcvtermid('line','hide',null))
LEFT JOIN gene g ON (l.gene_id = g.id)
;
