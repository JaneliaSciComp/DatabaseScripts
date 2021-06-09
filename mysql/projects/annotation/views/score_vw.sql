CREATE OR REPLACE VIEW score_vw AS
SELECT score.id,
       session_id,
       cv2.name cv_term,
       cv_term2.name term,
       cv.name cv,
       cv_term.name type,
       value,
       run,
       score.create_date
FROM score
JOIN cv_term on (score.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id)
LEFT JOIN cv_term as cv_term2 on (score.term_id = cv_term2.id)
LEFT JOIN cv as cv2 on (cv_term2.cv_id = cv2.id);

