CREATE OR REPLACE VIEW line_property_vw AS
SELECT line_property.id,
       line_id,
       cv.name cv,
       cv_term.name type,
       value,
       line_property.create_date
FROM line_property
JOIN cv_term on (line_property.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id);
