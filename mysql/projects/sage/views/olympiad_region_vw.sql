CREATE OR REPLACE VIEW olympiad_region_vw AS
SELECT s.id            AS id
      ,s.experiment_id AS experiment_id
      ,l.name          AS line
      ,s.name          AS name
      ,s.create_date   AS create_date
FROM session s
JOIN line l on (s.line_id = l.id)
JOIN cv_term ON (s.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id and cv.name like 'fly_olympiad%')
;
