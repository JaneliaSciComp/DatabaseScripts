CREATE OR REPLACE VIEW session_property_vw AS
SELECT session_property.id,
       session_id,
       session.lab,
       cv.name cv,
       cv_term.name type,
       value,
       session_property.create_date
FROM session_property
JOIN session on (session_property.session_id = session.id)
JOIN cv_term on (session_property.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id);
