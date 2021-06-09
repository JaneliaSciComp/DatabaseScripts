CREATE OR REPLACE VIEW olympiad_score_vw AS
SELECT s.id                      AS id
      ,s.phase_id                AS sequence_id
      ,s.session_id              AS region_id
      ,s.experiment_id           AS experiment_id
      ,cv_term.name              AS type
      ,uncompress(s.value)       AS array_value
      ,NULL                      AS value
      ,s.data_type               AS data_type
      ,s.row_count               AS row_count
      ,s.column_count            AS column_count
      ,s.create_date             AS create_date
FROM score_array s
JOIN cv_term ON (s.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id and cv.name like 'fly_olympiad%')
;
