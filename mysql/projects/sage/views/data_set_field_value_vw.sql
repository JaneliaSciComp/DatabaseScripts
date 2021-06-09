CREATE OR REPLACE VIEW data_set_field_value_vw AS
SELECT df.id                            AS id
      ,df.name                          AS name
      ,df.display_name                  AS display_name
      ,d.id                             AS data_set_id
      ,d.name                           AS data_set
      ,f.name                           AS family
      ,f.lab                            AS lab
      ,dv.value                         AS value
FROM data_set_field_value dv   
JOIN data_set_field df ON (df.id = dv.data_set_field_id)
JOIN data_set d ON (d.id = df.data_set_id)
JOIN data_set_family_vw f ON (d.family_id = f.id)
;
