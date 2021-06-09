CREATE OR REPLACE VIEW olympiad_region_property_vw AS
SELECT rp.id            AS id
      ,rp.session_id    AS region_id
      ,cv_term.name     AS type
      ,rp.value         AS value
      ,rp.create_date   AS create_date
FROM session_property rp
JOIN cv_term ON (rp.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id and cv.name like 'fly_olympiad%')
;
