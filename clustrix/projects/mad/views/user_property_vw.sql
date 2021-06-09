CREATE OR REPLACE VIEW user_property_vw AS
SELECT up.id
      ,up.user_id
      ,u.name as user
      ,up.type_id
      ,ct.name as type
      ,up.value
FROM user_property up
JOIN user u on (up.user_id = u.id)
JOIN cv_term ct ON (up.type_id = ct.id)
;
