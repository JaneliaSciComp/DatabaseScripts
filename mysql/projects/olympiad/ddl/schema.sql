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
-- Table structure for table `experiment`
--

DROP TABLE IF EXISTS `experiment`;
CREATE TABLE `experiment` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `protocol` varchar(255) NOT NULL,
  `lab` varchar(255) NOT NULL,
  `experimenter` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX experiment_name_ind USING BTREE ON experiment(name);
CREATE INDEX experiment_type_ind USING BTREE ON experiment(type);
CREATE INDEX experiment_lab_ind USING BTREE ON experiment(lab);

--
-- Table structure for table `experiment_property`
--

DROP TABLE IF EXISTS `experiment_property`;
CREATE TABLE `experiment_property` (
  `id` int unsigned NOT NULL auto_increment,
  `experiment_id` int unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `experiment_propperty_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE INDEX experiment_property_experiment_id_fk_ind USING BTREE ON experiment_property(experiment_id);
CREATE UNIQUE INDEX experiment_property_type_uk_ind USING BTREE ON experiment_property(type,experiment_id);
CREATE INDEX experiment_property_value_ind USING BTREE ON experiment_property(value(100));


--
-- Table structure for table `sequence`
--

DROP TABLE IF EXISTS `sequence`;
CREATE TABLE `sequence` (
  `id` int unsigned NOT NULL auto_increment,
  `experiment_id` int unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `sequence_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX sequence_experiment_id_fk_ind USING BTREE ON sequence(experiment_id);
CREATE INDEX sequence_name_ind USING BTREE ON sequence(name);

--
-- Table structure for table `sequence_scores`
--

-- DROP TABLE IF EXISTS `sequence_scores`;
-- CREATE TABLE `sequence_scores` (
--  `id` int unsigned NOT NULL auto_increment,
--  `sequence_id` int unsigned NOT NULL,
--  `type` varchar(255) NOT NULL,
--  `array_value` mediumtext NULL,
--  `value` int unsigned  NULL,
--  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
--  PRIMARY KEY  (`id`),
--  CONSTRAINT `sequence_scores_sequence_id_fk` FOREIGN KEY (`sequence_id`) REFERENCES `sequence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `sequence_property`
--

DROP TABLE IF EXISTS `sequence_property`;
CREATE TABLE `sequence_property` (
  `id` int unsigned NOT NULL auto_increment,
  `sequence_id` int unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `sequence_property_sequence_id_fk` FOREIGN KEY (`sequence_id`) REFERENCES `sequence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX sequence_property_sequence_id_fk_ind USING BTREE ON sequence_property(sequence_id);
CREATE UNIQUE INDEX sequence_property_type_uk_ind USING BTREE ON sequence_property(type,sequence_id);
CREATE INDEX sequence_property_value_ind USING BTREE ON sequence_property(value(100));
--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
CREATE TABLE `region` ( 
  `id` int unsigned NOT NULL auto_increment,
  `experiment_id` int unsigned NOT NULL,
  `line` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `region_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX region_experiment_id_fk_ind USING BTREE ON region(experiment_id);
CREATE INDEX region_line_ind USING BTREE ON region(line);
CREATE INDEX region_name_ind USING BTREE ON region(name);

--
-- Table structure for table `score`
--

DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` int unsigned NOT NULL auto_increment,
  `sequence_id` int unsigned NULL,
  `region_id` int unsigned NULL,
  `type` varchar(255) NOT NULL,
  `array_value` mediumtext NULL,
  `value` int unsigned  NULL,
  `data_type` varchar(255) NULL,
  `row_count` int unsigned NULL,
  `column_count` int unsigned NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `score_sequence_id_fk` FOREIGN KEY (`sequence_id`) REFERENCES `sequence` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `score_region_id_fk` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 KEY_BLOCK_SIZE=16;

CREATE INDEX score_sequence_id_fk_ind USING BTREE ON score(sequence_id);
CREATE INDEX score_region_id_fk_ind USING BTREE ON score(region_id);
CREATE UNIQUE INDEX score_type_uk_ind USING BTREE ON score(type,sequence_id,region_id);
CREATE INDEX score_value_ind USING BTREE ON score(value);


--
-- Table structure for table `region_property`
--

DROP TABLE IF EXISTS `region_property`;
CREATE TABLE `region_property` (
  `id` int unsigned NOT NULL auto_increment,
  `region_id` int unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `region_property_region_id_fk` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX region_property_region_id_fk_ind USING BTREE ON region_property(region_id);
CREATE UNIQUE INDEX region_property_type_uk_ind USING BTREE ON region_property(type,region_id);
CREATE INDEX region_property_value_ind USING BTREE ON region_property(value(100));

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
