CREATE OR REPLACE VIEW construct_vw AS
SELECT  c.id AS construct_id
       ,c.name AS construct
       ,c.constructdb_number
       ,c.category
       ,ct.name AS type
       ,cp.value
FROM construct c
JOIN construct_property cp ON (cp.construct_id = c.id)
JOIN cv_term ct ON (cp.type_id = ct.id)
;
