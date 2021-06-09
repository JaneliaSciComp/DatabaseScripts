CREATE OR REPLACE VIEW observation_vw AS
SELECT observation.id          AS id
      ,observation.experiment_id AS experiment_id
      ,observation.session_id  AS session_id
      ,cv2.name                AS cv_term
      ,cv_term2.name           AS term
      ,cv.name                 AS cv
      ,cv_term.name            AS type
      ,observation.value       AS value
      ,observation.create_date AS create_date
FROM observation
JOIN cv_term ON (observation.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
JOIN cv_term cv_term2 ON (observation.term_id = cv_term2.id)
JOIN cv cv2 ON (cv_term2.cv_id = cv2.id)
;
