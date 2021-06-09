CREATE OR REPLACE VIEW session_vw AS
SELECT session.id,
       session.name,
       session.lab,
       session.annotator,
       line_id,
       cv.name cv,
       cv_term.name type,
       session.create_date
FROM session
JOIN cv_term on (session.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id);
