/*
  step 4 of 4 for converting score to a partitioned table.
  index partitioned score table.
*/
CREATE INDEX score_session_id_fk_ind ON score(session_id);
CREATE INDEX score_type_id_fk_ind ON score(type_id);
CREATE INDEX score_term_id_fk_ind ON score(term_id);
CREATE INDEX score_value_ind ON score(value);
CREATE INDEX score_phase_id_fk_ind ON score(phase_id);
CREATE INDEX score_experiment_id_fk_ind ON score(experiment_id);
