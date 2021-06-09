CREATE OR REPLACE VIEW score_vw AS
SELECT score.id            AS id
      ,score.experiment_id AS experiment_id
      ,score.session_id    AS session_id
      ,score.phase_id      AS phase_id
      ,s.name              AS session
      ,cv2.name            AS cv_term
      ,cv_term2.name       AS term
      ,cv.name             AS cv
      ,cv_term.name        AS type
      ,score.value         AS value
      ,score.run           AS run
      ,score.create_date   AS create_date
FROM score
JOIN cv_term ON (score.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
JOIN cv_term cv_term2 ON (score.term_id = cv_term2.id)
JOIN cv cv2 ON (cv_term2.cv_id = cv2.id)
JOIN session s on (score.session_id = s.id)
;
