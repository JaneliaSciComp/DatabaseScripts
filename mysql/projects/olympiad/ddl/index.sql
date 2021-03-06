CREATE INDEX experiment_name_ind USING BTREE ON experiment(name);
CREATE INDEX experiment_type_ind USING BTREE ON experiment(type);
CREATE INDEX experiment_lab_ind USING BTREE ON experiment(lab);
CREATE INDEX experiment_property_experiment_id_fk_ind USING BTREE ON experiment_property(experiment_id);
CREATE UNIQUE INDEX experiment_property_type_uk_ind USING BTREE ON experiment_property(type,experiment_id);
CREATE INDEX experiment_property_value_ind USING BTREE ON experiment_property(value(100));
CREATE INDEX sequence_experiment_id_fk_ind USING BTREE ON sequence(experiment_id);
CREATE INDEX sequence_name_ind USING BTREE ON sequence(name);
CREATE INDEX sequence_property_sequence_id_fk_ind USING BTREE ON sequence_property(sequence_id);
CREATE UNIQUE INDEX sequence_property_type_uk_ind USING BTREE ON sequence_property(type,sequence_id);
CREATE INDEX sequence_property_value_ind USING BTREE ON sequence_property(value(100));
CREATE INDEX region_experiment_id_fk_ind USING BTREE ON region(experiment_id);
CREATE INDEX region_line_ind USING BTREE ON region(line);
CREATE INDEX region_name_ind USING BTREE ON region(name);
CREATE INDEX score_sequence_id_fk_ind USING BTREE ON score(sequence_id);
CREATE INDEX score_region_id_fk_ind USING BTREE ON score(region_id);
CREATE UNIQUE INDEX score_type_uk_ind USING BTREE ON score(type,sequence_id,region_id);
CREATE INDEX score_value_ind USING BTREE ON score(value);
CREATE INDEX region_property_region_id_fk_ind USING BTREE ON region_property(region_id);
CREATE UNIQUE INDEX region_property_type_uk_ind USING BTREE ON region_property(type,region_id);
CREATE INDEX region_property_value_ind USING BTREE ON region_property(value(100));
