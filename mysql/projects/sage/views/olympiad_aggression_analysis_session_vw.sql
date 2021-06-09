CREATE OR REPLACE VIEW olympiad_aggression_analysis_session_vw AS
SELECT s.id                 AS session_id
      ,s.experiment_id      AS experiment_id
      ,ct.name              AS score_array_type 
      ,uncompress(sa.value) AS value
FROM session s 
JOIN cv_term s_type ON (s_type.id = s.type_id)
JOIN cv s_cv ON (s_cv.id = s_type.cv_id AND s_cv.name = 'fly_olympiad_aggression')
JOIN experiment e ON (s.experiment_id = e.id)
JOIN score_array sa ON (s.id = sa.session_id)
JOIN cv_term ct ON (ct.id = sa.type_id)
;
