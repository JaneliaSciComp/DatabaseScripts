CREATE OR REPLACE VIEW olympiad_aggression_chamber_vw AS
SELECT chamber.id            AS id
      ,chamber.name          AS name
      ,cvt_type.name         AS type
      ,null                  AS protocol
      ,cvt_lab.name          AS lab
      ,arena.name            AS experiment_name
      ,exp_arena.value       AS arena
      ,exp_temp.value        AS temperature
      ,chamber.experimenter  AS experimenter
      ,chamber.create_date   AS create_date
FROM experiment chamber
JOIN experiment_relationship exp_rel ON (chamber.id = exp_rel.subject_id)
JOIN experiment arena ON (arena.id = exp_rel.object_id)
JOIN cv_term cvt_lab ON (chamber.lab_id = cvt_lab.id)
JOIN cv cv_lab ON (cvt_lab.cv_id = cv_lab.id and cv_lab.name = 'lab')
JOIN cv_term cvt_type ON (chamber.type_id = cvt_type.id)
JOIN cv cv_type ON (cvt_type.cv_id = cv_type.id and cv_type.name like 'fly_olympiad_aggression')
JOIN experiment_property exp_arena ON (exp_arena.experiment_id = arena.id)
JOIN cv_term cvt_arena ON (cvt_arena.id = exp_arena.type_id and cvt_arena.name = 'arena')
JOIN experiment_property exp_temp ON (exp_temp.experiment_id = arena.id)
JOIN cv_term cvt_temp ON (cvt_temp.id = exp_temp.type_id and cvt_temp.name = 'temperature')
;
