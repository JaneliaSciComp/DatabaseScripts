CREATE OR REPLACE VIEW grooming_score_vw AS
SELECT session_id,
       run,
       MAX(IF(STRCMP(cv_term.name,'eye_score'),null,score.value)) AS 'eye_score',
       MAX(IF(STRCMP(cv_term.name,'head_score'),null,score.value)) AS 'head_score',
       MAX(IF(STRCMP(cv_term.name,'wing_score'),null,score.value)) AS 'wing_score',
       MAX(IF(STRCMP(cv_term.name,'notum_score'),null,score.value)) AS 'notum_score'
FROM score
JOIN cv_term on (score.type_id = cv_term.id)
GROUP BY session_id,run;
