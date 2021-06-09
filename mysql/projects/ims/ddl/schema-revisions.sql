ALTER TABLE `detector` DROP FOREIGN KEY `detector_image_id`;

ALTER TABLE `detector` ADD CONSTRAINT `detector_image_id` FOREIGN KEY `detector_image_id` (`image_id`)
    REFERENCES `image` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

ALTER TABLE `image_property` DROP FOREIGN KEY `image_id_fk`;

ALTER TABLE `image_property` ADD CONSTRAINT `image_id_fk` FOREIGN KEY `image_id_fk` (`image_id`)
    REFERENCES `image` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

ALTER TABLE `laser` DROP FOREIGN KEY `laser_image_id`;

ALTER TABLE `laser` ADD CONSTRAINT `laser_image_id` FOREIGN KEY `laser_image_id` (`image_id`)
    REFERENCES `image` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

ALTER TABLE `secondary_image` DROP FOREIGN KEY `secondary_image_id_fk`;

ALTER TABLE `secondary_image` ADD CONSTRAINT `secondary_image_id_fk` FOREIGN KEY `secondary_image_id_fk` (`image_id`)
    REFERENCES `image` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

ALTER TABLE image ADD COLUMN display bool NOT NULL DEFAULT TRUE AFTER representative;

alter table image add column source varchar(100) not null default "JFRC" after name;

alter table attenuator add column acquire int unsigned null;
alter table attenuator add column detchannel_name varchar(128) null;
alter table attenuator add column power_bc1 float null;
alter table attenuator add column power_bc2 float null;
