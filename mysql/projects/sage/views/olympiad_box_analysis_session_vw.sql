CREATE OR REPLACE VIEW olympiad_box_analysis_session_vw AS
SELECT aspv.session_id      AS session_id
      ,aspv.sequence        AS sequence
      ,aspv.region          AS tube
      ,aspv.temperature     AS temperature
      ,aspv.experiment_id   AS experiment_id
      ,sa_type.name         AS score_array_type 
      ,uncompress(sa.value) AS value
FROM olympiad_box_analysis_session_property_vw aspv
JOIN session s ON (s.id = aspv.session_id)
JOIN score_array sa ON (s.id = sa.session_id)
JOIN cv_term sa_type ON (sa_type.id = sa.type_id)
;
