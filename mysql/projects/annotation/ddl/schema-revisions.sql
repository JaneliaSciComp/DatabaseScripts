ALTER TABLE score add `term_id` int unsigned NOT NULL after `session_id`;

ALTER TABLE observation add `term_id` int unsigned NOT NULL after `session_id`;

ALTER TABLE observation add  CONSTRAINT `observation_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE score add  CONSTRAINT `score_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

DROP INDEX score_run_uk_ind ON score;

CREATE UNIQUE INDEX score_run_uk_ind USING BTREE ON score(session_id,type_id,run,term_id);

DROP INDEX observation_type_uk_ind ON observation;
CREATE UNIQUE INDEX observation_type_uk_ind USING BTREE ON observation(type_id,session_id,term_id);

ALTER TABLE session add `name` varchar(767) NOT NULL after `id`;

DROP INDEX session_type_uk_ind ON session;

CREATE UNIQUE INDEX session_type_uk_ind USING BTREE ON session(name,type_id,line_id);

ALTER TABLE line CHANGE enhancer_reference gene varchar(767);

--ALTER TABLE observation add `modified_date`  timestamp NULL default null after `session_id`;

ALTER TABLE observation modify `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP;

ALTER TABLE score modify column `value` double signed NOT NULL;

ALTER TABLE session DROP  INDEX session_type_uk_ind;
CREATE UNIQUE INDEX session_type_uk_ind USING BTREE ON session(name,type_id);

ALTER TABLE cv_term add `display_name` varchar(255) NULL after is_current;
ALTER TABLE cv_term add `data_type` varchar(255) NULL after display_name;

ALTER TABLE cv_term modify `name` varchar(255) NOT NULL COLLATE latin1_general_cs;

DROP INDEX session_type_uk_ind ON session;
CREATE UNIQUE INDEX session_type_uk_ind USING BTREE ON session(name,type_id,line_id,lab);
