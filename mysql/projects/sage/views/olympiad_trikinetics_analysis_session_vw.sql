CREATE OR REPLACE VIEW olympiad_trikinetics_analysis_session_vw AS
SELECT s.id                 AS session_id
      ,epv.value             AS incubator
      ,aspv.temperature     AS temperature
      ,aspv.monitor         AS monitor 
      ,aspv.channel         AS channel
      ,s.experiment_id      AS experiment_id
      ,ct.name              AS score_array_type 
      ,uncompress(sa.value) AS value
FROM olympiad_trikinetics_analysis_session_property_vw aspv
JOIN session s ON (s.id = aspv.session_id)
JOIN experiment e ON (s.experiment_id = e.id)
JOIN olympiad_experiment_property_vw epv ON (e.id = epv.experiment_id and epv.type='incubator')
JOIN score_array sa ON (s.id = sa.session_id)
JOIN cv_term ct ON (ct.id = sa.type_id)
;
