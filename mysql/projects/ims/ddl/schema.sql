-- MySQL dump 10.9
-- ------------------------------------------------------
-- Server version	5.0.45-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL COLLATE latin1_general_cs,
  `family` varchar(100) NOT NULL,
  `capture_date` timestamp NULL,
  `representative` tinyint  unsigned NOT NULL default 0,
  `display` bool NOT NULL default TRUE,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX image_name_uk_ind USING BTREE ON image(name,family);
CREATE INDEX image_family_ind USING BTREE ON image(family);

--
-- Table structure for table `secondary_image`
--

DROP TABLE IF EXISTS `secondary_image`;
CREATE TABLE `secondary_image` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL COLLATE latin1_general_cs,
  `image_id` int unsigned NOT NULL,
  `product` varchar(100) NOT NULL,
  `location` varchar(1000) NOT NULL,
  `url` varchar(1000) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `secondary_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX secondary_image_name_uk_ind USING BTREE ON secondary_image(name,image_id);
CREATE INDEX secondary_image_id_fk_ind USING BTREE ON secondary_image(image_id);
CREATE INDEX secondary_image_product_ind USING BTREE ON secondary_image(product);

--
-- Table structure for table `image_property`
--

DROP TABLE IF EXISTS `image_property`;
CREATE TABLE `image_property` (
  `id` int unsigned NOT NULL auto_increment,
  `image_id` int unsigned NOT NULL,
  `type` varchar(100) NOT NULL,
  `value` text NOT NULL COLLATE latin1_general_cs,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX imageprop_image_fk_ind USING BTREE ON image_property(image_id);
CREATE INDEX imageprop_type_ind USING BTREE ON image_property(type);
CREATE INDEX imageprop_value_ind USING BTREE ON image_property(value(1000));

--
-- Table structure for table `channel`
--

DROP TABLE IF EXISTS `detector`;
CREATE TABLE `detector` (
  `id` int unsigned NOT NULL auto_increment,
  `track` varchar(128) NOT NULL COLLATE latin1_general_cs,
  `image_channel_name` varchar(128) NOT NULL COLLATE latin1_general_cs,
  `image_id` int unsigned NOT NULL,
  `detector_voltage` varchar(32),
  `detector_voltage_first` varchar(32),
  `detector_voltage_last` varchar(32),
  `amplifier_gain` varchar(32),
  `amplifier_gain_first` varchar(32),
  `amplifier_gain_last` varchar(32),
  `amplifier_offset` varchar(32),
  `amplifier_offset_first` varchar(32),
  `amplifier_offset_last` varchar(32),
  `pinhole_diameter` varchar(32),
  `pinhole_name` varchar(128),
  `point_detector_name` varchar(128),
  `filter` varchar(32),
  `color` varchar(32),
  PRIMARY KEY  (`id`),
  CONSTRAINT `detector_image_id` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX detector_image_id_fk_ind USING BTREE ON detector(image_id);

ALTER TABLE detector add column digital_gain varchar(32);
ALTER TABLE detector add column num int unsigned after image_channel_name;

ALTER TABLE detector modify column num int unsigned not null;

--
-- Table structure for table `laser`
--

DROP TABLE IF EXISTS `laser`;
CREATE TABLE `laser` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(128) NOT NULL COLLATE latin1_general_cs,
  `image_id` int unsigned NOT NULL,
  `power` varchar(32),
  PRIMARY KEY  (`id`),
  CONSTRAINT `laser_image_id` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX laser_image_id_fk_ind USING BTREE ON laser(image_id);

--
-- Table structure for table `attenuator`
--

DROP TABLE IF EXISTS `attenuator`;
CREATE TABLE `attenuator` (
  `id` int unsigned NOT NULL auto_increment,
  `track` varchar(128) NOT NULL COLLATE latin1_general_cs,
  `num` int unsigned NOT NULL,
  `image_id` int unsigned NOT NULL,
  `wavelength` varchar(32),
  `transmission` varchar(32),
  PRIMARY KEY  (`id`),
  CONSTRAINT `attenuator_image_id` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX attenuator_image_id_fk_ind USING BTREE ON attenuator(image_id);
CREATE UNIQUE INDEX attenuator_uk_ind USING BTREE ON attenuator(track,image_id,num);


DROP TABLE IF EXISTS `namespace_sequence_number`;
CREATE TABLE `namespace_sequence_number` (
   `id` int unsigned NOT NULL auto_increment,
   `namespace` varchar(767) NOT NULL,
   `sequence_number` int  unsigned NOT NULL,
   `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
   PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
CREATE UNIQUE INDEX namespace_name_uk_ind USING BTREE ON namespace_sequence_number(namespace);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
