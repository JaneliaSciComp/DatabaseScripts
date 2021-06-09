ALTER  TABLE lab_group ADD COLUMN code VARCHAR(5) AFTER name;
UPDATE lab_group SET code = substring(name,1,4);
ALTER  TABLE lab_group MODIFY COLUMN code VARCHAR(5) NOT NULL;
ALTER  TABLE lab_group ADD UNIQUE INDEX lab_group_code_uk_ind(code);

ALTER TABLE project DROP INDEX project_code_uk_ind;
ALTER TABLE project ADD UNIQUE INDEX project_code_uk_ind(lab_group_id,code);
ALTER TABLE project ADD COLUMN part_counter INTEGER UNSIGNED ZEROFILL NOT NULL AFTER status;
UPDATE project SET part_counter = (select count(*) from project_part where project_id = project.id);
ALTER TABLE part ADD COLUMN project_id INTEGER UNSIGNED AFTER id;
UPDATE part SET project_id = (select p.project_id from project_part p where p.part_id = part.id);
ALTER TABLE part MODIFY COLUMN project_id INTEGER UNSIGNED NOT NULL;
ALTER TABLE part ADD CONSTRAINT part_project_id_fk FOREIGN KEY part_project_id_fk_ind (project_id) REFERENCES project(id);

DROP table project_part;
ALTER TABLE part  CHANGE COLUMN mode_file model_file varchar(50) NOT NULL;
