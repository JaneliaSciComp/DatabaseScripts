CREATE OR REPLACE VIEW audit_trail_observation_vw AS
SELECT o.id
      ,structural_term.name structural_term
      ,observation_type.name observation_type
      ,o.value as current_value
      ,o.create_date
      ,at.old_value
      ,at.new_value
      ,at.modify_date  
FROM observation o 
INNER JOIN audit_trail at ON (at.primary_identifier = o.id and at.table_name = 'observation') 
INNER JOIN cv_term structural_term ON (structural_term.id = o.term_id) 
INNER JOIN cv_term observation_type ON (observation_type.id = o.type_id) 
;
