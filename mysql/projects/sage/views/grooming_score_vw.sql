DROP TABLE IF EXISTS tmp_grooming_score_mv;

CREATE TABLE tmp_grooming_score_mv
SELECT session_id,
       run,
       MAX(IF(STRCMP(cv_term.name,'eye_score'),null,score.value)) AS 'eye_score',
       MAX(IF(STRCMP(cv_term.name,'head_score'),null,score.value)) AS 'head_score',
       MAX(IF(STRCMP(cv_term.name,'wing_score'),null,score.value)) AS 'wing_score',
       MAX(IF(STRCMP(cv_term.name,'notum_score'),null,score.value)) AS 'notum_score'
FROM score
JOIN session on (score.session_id = session.id)
JOIN cv_term s_cv_term on (session.type_id = s_cv_term.id)
JOIN cv s_cv on (s_cv_term.cv_id = s_cv.id and s_cv.name = 'grooming')
JOIN cv_term on (score.type_id = cv_term.id)
GROUP BY session_id,run;

CREATE INDEX tmp_grooming_smv_session_id_ind ON tmp_grooming_score_mv(session_id);

DROP TABLE IF EXISTS grooming_score_mv;

RENAME TABLE tmp_grooming_score_mv TO grooming_score_mv;

CREATE OR REPLACE VIEW grooming_score_vw AS
SELECT * FROM grooming_score_mv;
