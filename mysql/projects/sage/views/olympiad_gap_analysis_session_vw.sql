CREATE OR REPLACE VIEW olympiad_gap_analysis_session_vw AS
SELECT s.id                 AS session_id
      ,aspv.temperature     AS temperature
      ,aspv.instrument      AS instrument 
      ,s.experiment_id      AS experiment_id
      ,ct.name              AS score_array_type 
      ,uncompress(sa.value) AS value
FROM olympiad_gap_analysis_session_property_vw aspv
JOIN session s ON (s.id = aspv.session_id)
JOIN experiment e ON (s.experiment_id = e.id)
JOIN score_array sa ON (s.id = sa.session_id)
JOIN cv_term ct ON (ct.id = sa.type_id)
;
