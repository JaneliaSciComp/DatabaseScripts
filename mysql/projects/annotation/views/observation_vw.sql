CREATE OR REPLACE VIEW observation_vw AS
SELECT observation.id,
       session_id,
       cv2.name cv_term,
       cv_term2.name term,
       cv.name cv,
       cv_term.name type,
       value,
       observation.create_date
FROM observation
JOIN cv_term on (observation.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id)
LEFT JOIN cv_term as cv_term2 on (observation.term_id = cv_term2.id)
LEFT JOIN cv as cv2 on (cv_term2.cv_id = cv2.id);
