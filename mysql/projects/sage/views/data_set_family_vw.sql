CREATE OR REPLACE VIEW data_set_family_vw AS
SELECT d.id                             AS id
      ,d.name                           AS name
      ,d.display_name                   AS display_name
      ,lab.name                         AS lab
      ,lab.display_name                 AS lab_display_name
      ,d.description                    AS description
FROM data_set_family d
JOIN cv_term lab ON (d.lab_id = lab.id)
JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
;
