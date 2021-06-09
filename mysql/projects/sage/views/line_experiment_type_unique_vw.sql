CREATE OR REPLACE VIEW line_experiment_type_unique_vw AS
SELECT  DISTINCT 
        e.name          AS experiment
       ,l.name          AS line
       ,ec.name         AS cv
FROM line l
JOIN session s ON (s.line_id = l.id)
JOIN experiment e  ON (s.experiment_id = e.id)
JOIN cv_term et ON (e.type_id = et.id)
JOIN cv ec ON (et.cv_id = ec.id AND ec.name IN ('fly_olympiad_trikinetics','fly_olympiad_box','fly_olympiad_gap','fly_olympiad_lethality','fly_olympiad_sterility','fly_olympiad_observation','grooming','ipcr','proboscis_extension','fly_olympiad_fly_bowl'))
UNION ALL
SELECT  DISTINCT 
        arena.name      AS experiment
       ,l.name          AS line
       ,ec.name         AS cv
FROM line l
JOIN session s ON (s.line_id = l.id)
JOIN experiment chamber ON (s.experiment_id = chamber.id)
JOIN experiment_relationship exp_rel ON (chamber.id = exp_rel.subject_id)
JOIN experiment arena ON (arena.id = exp_rel.object_id)
JOIN cv_term et ON (arena.type_id = et.id)
JOIN cv ec ON (et.cv_id = ec.id AND ec.name IN ('fly_olympiad_aggression'))
;
