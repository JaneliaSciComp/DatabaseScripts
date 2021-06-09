CREATE OR REPLACE VIEW data_set_vw AS
SELECT d.id                             AS id
      ,d.name                           AS name
      ,d.display_name                   AS display_name
      ,f.name                           AS family
      ,f.lab                            AS lab
      ,GROUP_CONCAT(cv_term.name SEPARATOR ',')                 AS view_name
      ,d.description                    AS description
FROM data_set d
JOIN data_set_family_vw f ON (d.family_id = f.id)
JOIN data_set_view dv on (d.id = dv.data_set_id)
JOIN cv_term ON (dv.view_id = cv_term.id)
GROUP BY  d.id
;
