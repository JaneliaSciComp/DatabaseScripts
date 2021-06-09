-- MySQL dump 10.13  Distrib 5.1.52, for apple-darwin10.3.0 (i386)
--
-- Host: sage-db    Database: sage
-- ------------------------------------------------------
-- Server version	5.1.46-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attenuator`
--

DROP TABLE IF EXISTS `cv_term_constraint`;
CREATE TABLE `cv_term_constraint` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
assay_term_id int(10) unsigned NOT NULL,
cv_term_id int(10) unsigned NOT NULL,
required varchar(50) NULL DEFAULT 'YES',
stored varchar(255) NOT NULL,
default_value varchar(500) NULL,
`create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`id`),
UNIQUE KEY `cv_term_constraint_uk_ind` (`assay_term_id`,`cv_term_id`) USING BTREE,
CONSTRAINT `cv_term_constraint_assay_id_fk` FOREIGN KEY (`assay_term_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
CONSTRAINT `cv_term_constraint_cv_term_id_fk` FOREIGN KEY (`cv_term_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB CHARSET=latin1;

DROP TABLE IF EXISTS `attenuator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attenuator` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `track` varchar(128) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `num` int(10) unsigned NOT NULL,
  `image_id` int(10) unsigned NOT NULL,
  `wavelength` varchar(32) DEFAULT NULL,
  `transmission` varchar(32) DEFAULT NULL,
  `acquire` int(10) unsigned DEFAULT NULL,
  `detchannel_name` varchar(128) DEFAULT NULL,
  `power_bc1` float DEFAULT NULL,
  `power_bc2` float DEFAULT NULL,
  `ramp_low_power` float DEFAULT NULL,
  `ramp_high_power` float DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attenuator_uk_ind` (`track`,`image_id`,`num`) USING BTREE,
  KEY `attenuator_image_id_fk_ind` (`image_id`) USING BTREE,
  CONSTRAINT `attenuator_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=58452 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `audit_trail`
--

DROP TABLE IF EXISTS `audit_trail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_trail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) NOT NULL,
  `column_name` varchar(50) NOT NULL,
  `data_type` varchar(50) NOT NULL,
  `primary_identifier` bigint(20) NOT NULL,
  `old_value` text,
  `new_value` text,
  `modify_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `audit_trail_table_name_ind` (`table_name`) USING BTREE,
  KEY `audit_trail_primary_identifier_ind` (`primary_identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `cross_event_vw`
--

DROP TABLE IF EXISTS `cross_event_vw`;
/*!50001 DROP VIEW IF EXISTS `cross_event_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cross_event_vw` (
  `id` int(10) unsigned,
  `process` varchar(255),
  `line_event_id` int(10) unsigned,
  `line_id` int(10) unsigned,
  `line` varchar(767),
  `action` varchar(255),
  `operator` varchar(255),
  `project` text,
  `project_lab` text,
  `cross_type` text,
  `effector` text,
  `event_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cv`
--

DROP TABLE IF EXISTS `cv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cv` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `definition` text,
  `version` tinyint(3) unsigned NOT NULL,
  `is_current` tinyint(3) unsigned NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cv_name_uk_ind` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cv_relationship`
--

DROP TABLE IF EXISTS `cv_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cv_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `is_current` tinyint(3) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cv_relationship_uk_ind` (`type_id`,`subject_id`,`object_id`) USING BTREE,
  KEY `cv_relationship_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `cv_relationship_subject_id_fk_ind` (`subject_id`) USING BTREE,
  KEY `cv_relationship_object_id_fk_ind` (`object_id`) USING BTREE,
  CONSTRAINT `cv_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `cv` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cv_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `cv` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cv_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `cv_relationship_vw`
--

DROP TABLE IF EXISTS `cv_relationship_vw`;
/*!50001 DROP VIEW IF EXISTS `cv_relationship_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cv_relationship_vw` (
  `context_id` int(10) unsigned,
  `context` varchar(255),
  `subject_id` int(10) unsigned,
  `subject` varchar(255),
  `relationship_id` int(10) unsigned,
  `relationship` varchar(255),
  `object_id` int(10) unsigned,
  `object` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cv_term`
--

DROP TABLE IF EXISTS `cv_term`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cv_term` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cv_id` int(10) unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `definition` text,
  `is_current` tinyint(3) unsigned NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `data_type` varchar(255) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cv_term_name_uk_ind` (`cv_id`,`name`) USING BTREE,
  KEY `cv_term_cv_id_fk_ind` (`cv_id`) USING BTREE,
  CONSTRAINT `cv_term_cv_id_fk` FOREIGN KEY (`cv_id`) REFERENCES `cv` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1822 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cv_term_relationship`
--

DROP TABLE IF EXISTS `cv_term_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cv_term_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `is_current` tinyint(3) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cv_term_relationship_uk_ind` (`type_id`,`subject_id`,`object_id`) USING BTREE,
  KEY `cv_term_relationship_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `cv_term_relationship_subject_id_fk_ind` (`subject_id`) USING BTREE,
  KEY `cv_term_relationship_object_id_fk_ind` (`object_id`) USING BTREE,
  CONSTRAINT `cv_term_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cv_term_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cv_term_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `cv_term_relationship_vw`
--

DROP TABLE IF EXISTS `cv_term_relationship_vw`;
/*!50001 DROP VIEW IF EXISTS `cv_term_relationship_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cv_term_relationship_vw` (
  `subject_context_id` int(10) unsigned,
  `subject_context` varchar(255),
  `subject_id` int(10) unsigned,
  `subject` varchar(255),
  `relationship_context_id` int(10) unsigned,
  `relationship_context` varchar(255),
  `relationship_id` int(10) unsigned,
  `relationship` varchar(255),
  `object_context_id` int(10) unsigned,
  `object_context` varchar(255),
  `object_id` int(10) unsigned,
  `object` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `cv_term_to_table_mapping_vw`
--

DROP TABLE IF EXISTS `cv_term_to_table_mapping_vw`;
/*!50001 DROP VIEW IF EXISTS `cv_term_to_table_mapping_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cv_term_to_table_mapping_vw` (
  `cv` varchar(255),
  `cv_term_id` int(10) unsigned,
  `cv_term` varchar(255),
  `relationship` varchar(255),
  `schema_term` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `cv_term_validation_vw`
--

DROP TABLE IF EXISTS `cv_term_validation_vw`;
/*!50001 DROP VIEW IF EXISTS `cv_term_validation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cv_term_validation_vw` (
  `term_context` varchar(255),
  `term_id` int(10) unsigned,
  `term` varchar(255),
  `relationship` varchar(255),
  `rule` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `cv_term_vw`
--

DROP TABLE IF EXISTS `cv_term_vw`;
/*!50001 DROP VIEW IF EXISTS `cv_term_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `cv_term_vw` (
  `cv` varchar(255),
  `id` int(10) unsigned,
  `cv_term` varchar(255),
  `definition` text,
  `display_name` varchar(255),
  `data_type` varchar(255),
  `is_current` tinyint(3) unsigned,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `data_set`
--

DROP TABLE IF EXISTS `data_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `family_id` int(10) unsigned NOT NULL,
  `view_id` int(10) unsigned NOT NULL,
  `view_id2` int(10) unsigned DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_set_name_family_uk_ind` (`name`,`family_id`) USING BTREE,
  KEY `data_set_family_fk_ind` (`family_id`) USING BTREE,
  KEY `data_set_view_fk_ind` (`view_id`) USING BTREE,
  CONSTRAINT `data_set_family_id_fk` FOREIGN KEY (`family_id`) REFERENCES `data_set_family` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `data_set_view_id_fk` FOREIGN KEY (`view_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_set_family`
--

DROP TABLE IF EXISTS `data_set_family`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_set_family` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `lab_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_set_family_name_lab_uk_ind` (`name`,`lab_id`) USING BTREE,
  KEY `data_set_family_lab_fk_ind` (`lab_id`) USING BTREE,
  CONSTRAINT `data_set_family_lab_id_fk` FOREIGN KEY (`lab_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `data_set_family_vw`
--

DROP TABLE IF EXISTS `data_set_family_vw`;
/*!50001 DROP VIEW IF EXISTS `data_set_family_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `data_set_family_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `display_name` varchar(255),
  `lab` varchar(255),
  `lab_display_name` varchar(255),
  `description` varchar(1000)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `data_set_field`
--

DROP TABLE IF EXISTS `data_set_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_set_field` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `data_set_id` int(10) unsigned NOT NULL,
  `value` text,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_set_field_name_uk_ind` (`name`,`data_set_id`) USING BTREE,
  KEY `data_set_field_data_set_fk_ind` (`data_set_id`) USING BTREE,
  CONSTRAINT `data_set_field_data_set_id_fk` FOREIGN KEY (`data_set_id`) REFERENCES `data_set` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_set_field_value`
--

DROP TABLE IF EXISTS `data_set_field_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_set_field_value` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `data_set_field_id` int(10) unsigned NOT NULL,
  `value` text,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `data_set_field_value_data_set_field_fk_ind` (`data_set_field_id`) USING BTREE,
  CONSTRAINT `data_set_field_data_set_field_id_fk` FOREIGN KEY (`data_set_field_id`) REFERENCES `data_set_field` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=141780 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `data_set_field_value_vw`
--

DROP TABLE IF EXISTS `data_set_field_value_vw`;
/*!50001 DROP VIEW IF EXISTS `data_set_field_value_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `data_set_field_value_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `display_name` varchar(255),
  `data_set_id` int(10) unsigned,
  `data_set` varchar(255),
  `family` varchar(255),
  `lab` varchar(255),
  `value` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `data_set_field_vw`
--

DROP TABLE IF EXISTS `data_set_field_vw`;
/*!50001 DROP VIEW IF EXISTS `data_set_field_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `data_set_field_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `display_name` varchar(255),
  `data_set_id` int(10) unsigned,
  `data_set` varchar(255),
  `family` varchar(255),
  `lab` varchar(255),
  `value` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `data_set_vw`
--

DROP TABLE IF EXISTS `data_set_vw`;
/*!50001 DROP VIEW IF EXISTS `data_set_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `data_set_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `display_name` varchar(255),
  `family` varchar(255),
  `lab` varchar(255),
  `view_name` varchar(255),
  `view_name2` varchar(255),
  `description` varchar(1000)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `detector`
--

DROP TABLE IF EXISTS `detector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detector` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `track` varchar(128) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `image_channel_name` varchar(128) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `num` int(10) unsigned NOT NULL,
  `image_id` int(10) unsigned NOT NULL,
  `detector_voltage` varchar(32) DEFAULT NULL,
  `detector_voltage_first` varchar(32) DEFAULT NULL,
  `detector_voltage_last` varchar(32) DEFAULT NULL,
  `amplifier_gain` varchar(32) DEFAULT NULL,
  `amplifier_gain_first` varchar(32) DEFAULT NULL,
  `amplifier_gain_last` varchar(32) DEFAULT NULL,
  `amplifier_offset` varchar(32) DEFAULT NULL,
  `amplifier_offset_first` varchar(32) DEFAULT NULL,
  `amplifier_offset_last` varchar(32) DEFAULT NULL,
  `pinhole_diameter` varchar(32) DEFAULT NULL,
  `pinhole_name` varchar(128) DEFAULT NULL,
  `point_detector_name` varchar(128) DEFAULT NULL,
  `filter` varchar(32) DEFAULT NULL,
  `color` varchar(32) DEFAULT NULL,
  `digital_gain` varchar(32) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `detector_image_id_fk_ind` (`image_id`) USING BTREE,
  CONSTRAINT `detector_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=58452 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `process_id` int(10) unsigned NOT NULL,
  `action` varchar(255) NOT NULL,
  `operator` varchar(255) NOT NULL,
  `event_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `event_process_id_fk_ind` (`process_id`) USING BTREE,
  CONSTRAINT `event_process_id_fk` FOREIGN KEY (`process_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33337 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_property`
--

DROP TABLE IF EXISTS `event_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_property_type_uk_ind` (`type_id`,`event_id`) USING BTREE,
  KEY `event_property_event_id_fk_ind` (`event_id`) USING BTREE,
  KEY `event_propery_type_id_fk_ind` (`type_id`) USING BTREE,
  CONSTRAINT `event_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `event_property_event_id_fk` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=123082 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `event_property_vw`
--

DROP TABLE IF EXISTS `event_property_vw`;
/*!50001 DROP VIEW IF EXISTS `event_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `event_property_vw` (
  `id` int(10) unsigned,
  `event_id` int(10) unsigned,
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `event_vw`
--

DROP TABLE IF EXISTS `event_vw`;
/*!50001 DROP VIEW IF EXISTS `event_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `event_vw` (
  `id` int(10) unsigned,
  `process` varchar(255),
  `line_event_id` int(10) unsigned,
  `line_id` int(10) unsigned,
  `line` varchar(767),
  `action` varchar(255),
  `operator` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `experiment`
--

DROP TABLE IF EXISTS `experiment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `lab_id` int(10) unsigned NOT NULL,
  `experimenter` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `experiment_type_uk_ind` (`name`,`type_id`,`lab_id`) USING BTREE,
  KEY `experiment_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `experiment_lab_id_fk_ind` (`lab_id`) USING BTREE,
  CONSTRAINT `experiment_lab_id_fk` FOREIGN KEY (`lab_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `experiment_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=156862 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `experiment_property`
--

DROP TABLE IF EXISTS `experiment_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiment_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `experiment_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `experiment_property_type_uk_ind` (`type_id`,`experiment_id`) USING BTREE,
  KEY `experiment_property_experiment_id_fk_ind` (`experiment_id`) USING BTREE,
  KEY `experiment_property_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `experiment_property_value_ind` (`value`(100)) USING BTREE,
  CONSTRAINT `experiment_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `experiment_property_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1374272 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `experiment_property_vw`
--

DROP TABLE IF EXISTS `experiment_property_vw`;
/*!50001 DROP VIEW IF EXISTS `experiment_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `experiment_property_vw` (
  `id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `name` varchar(255),
  `lab` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `experiment_relationship`
--

DROP TABLE IF EXISTS `experiment_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiment_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `experiment_relationship_uk_ind` (`type_id`,`subject_id`,`object_id`) USING BTREE,
  KEY `experiment_relationship_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `experiment_relationship_subject_id_fk_ind` (`subject_id`) USING BTREE,
  KEY `experiment_relationship_object_id_fk_ind` (`object_id`) USING BTREE,
  CONSTRAINT `experiment_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `experiment_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `experiment_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=44700 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `experiment_relationship_vw`
--

DROP TABLE IF EXISTS `experiment_relationship_vw`;
/*!50001 DROP VIEW IF EXISTS `experiment_relationship_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `experiment_relationship_vw` (
  `context_id` int(10) unsigned,
  `context` varchar(255),
  `subject_id` int(10) unsigned,
  `subject` varchar(255),
  `relationship_id` int(10) unsigned,
  `relationship` varchar(255),
  `object_id` int(10) unsigned,
  `object` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `experiment_vw`
--

DROP TABLE IF EXISTS `experiment_vw`;
/*!50001 DROP VIEW IF EXISTS `experiment_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `experiment_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `experimenter` varchar(255),
  `lab` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `gene`
--

DROP TABLE IF EXISTS `gene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gene` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `organism_id` int(10) unsigned NOT NULL,
  `description` text,
  `chromosome` varchar(50) DEFAULT NULL,
  `cyto_start` varchar(10) DEFAULT NULL,
  `cyto_end` varchar(10) DEFAULT NULL,
  `synonym_string` varchar(1000) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gene_name_uk_ind` (`name`,`organism_id`) USING BTREE,
  KEY `gene_organism_fk_ind` (`organism_id`) USING BTREE,
  KEY `gene_chromosome_ind` (`chromosome`) USING BTREE,
  CONSTRAINT `gene_organism_id_fk` FOREIGN KEY (`organism_id`) REFERENCES `organism` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15986 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_data_mv`
--

DROP TABLE IF EXISTS `gene_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gene_data_mv` (
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `gene` longtext CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  KEY `gene_data_mv_gene_ind` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_synonym`
--

DROP TABLE IF EXISTS `gene_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gene_synonym` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gene_id` int(10) unsigned NOT NULL,
  `synonym` varchar(767) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `gene_synonym_gene_fk_ind` (`gene_id`) USING BTREE,
  KEY `gene_synonym_synonym_ind` (`synonym`) USING BTREE,
  CONSTRAINT `gene_synonym_gene_id_fk` FOREIGN KEY (`gene_id`) REFERENCES `gene` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37434 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `grooming_observation_vw`
--

DROP TABLE IF EXISTS `grooming_observation_vw`;
/*!50001 DROP VIEW IF EXISTS `grooming_observation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `grooming_observation_vw` (
  `name` varchar(767),
  `behavioral_courtship` longtext,
  `behavioral_hyper` longtext,
  `behavioral_intersegmental` longtext,
  `behavioral_paralyzed` longtext,
  `behavioral_uncoordinated` longtext,
  `cross_lethal` longtext,
  `overgrooming_defect` longtext,
  `head_selective_defect` longtext,
  `leg_rub_defect` longtext,
  `permissive_defect` longtext,
  `restrictive_defect` longtext,
  `restrictive_screened` longtext,
  `stock_control_defect` longtext,
  `stock_defect` longtext,
  `tnt_defect` longtext,
  `trpa_screened` longtext,
  `trpa_defect` longtext,
  `trpa_reversal` longtext,
  `trpa_proboscisextension` longtext,
  `trpa_feedingbehavior` longtext,
  `trpa_increasedgrooming` longtext,
  `trpa_headgrooming` longtext,
  `trpa_wingcleaning` longtext,
  `trpa_legrubbing` longtext,
  `expression_bristle` longtext,
  `expression_chordotonal` longtext,
  `interesting` longtext,
  `expression_imaged` longtext,
  `experimental_imaged` longtext,
  `evidence_imaged` longtext,
  `trpa_probosciscleaning` longtext,
  `trpa_abdominalcleaning` longtext,
  `trpa_genitalcleaning` longtext,
  `trpa_halterecleaning` longtext,
  `trpa_ventralthoraxcleaning` longtext,
  `trpa_antennalcleaning` longtext,
  `trpa_notumcleaning` longtext,
  `expression_eyebristle` longtext,
  `chr2_stimulated` longtext,
  `trpa_courtship` longtext,
  `trpa_posteriorcleaning` longtext,
  `trpa_decap_screened` longtext,
  `trpa_decap_phenotype` longtext,
  `expression_connected` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `grooming_score_vw`
--

DROP TABLE IF EXISTS `grooming_score_vw`;
/*!50001 DROP VIEW IF EXISTS `grooming_score_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `grooming_score_vw` (
  `session_id` int(10) unsigned,
  `run` int(10) unsigned,
  `eye_score` double,
  `head_score` double,
  `wing_score` double,
  `notum_score` double
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `url` varchar(1000) DEFAULT NULL,
  `path` varchar(1000) DEFAULT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `family_id` int(10) unsigned NOT NULL,
  `line_id` int(10) unsigned NOT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `capture_date` timestamp NULL DEFAULT NULL,
  `representative` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `display` tinyint(1) NOT NULL DEFAULT '1',
  `created_by` varchar(1000) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_name_uk_ind` (`name`,`family_id`) USING BTREE,
  KEY `image_family_fk_ind` (`family_id`) USING BTREE,
  KEY `image_source_fk_ind` (`source_id`) USING BTREE,
  KEY `image_line_fk_ind` (`line_id`) USING BTREE,
  KEY `image_experiment_id_fk` (`experiment_id`),
  CONSTRAINT `image_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `image_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `image_family_id_fk` FOREIGN KEY (`family_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `image_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=336038 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `image_data_mv`
--

DROP TABLE IF EXISTS `image_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image_data_mv` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `line` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `family` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `capture_date` timestamp NULL DEFAULT NULL,
  `representative` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `display` tinyint(1) NOT NULL DEFAULT '0',
  `age` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `area` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `bc_correction1` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `bc_correction2` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `bits_per_sample` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `channels` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `chron_hour` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `chron_interval` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `chron_stage` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `class` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `dimension_x` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `dimension_y` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `dimension_z` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `file_size` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `gender` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `genotype` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `heat_shock_hour` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `heat_shock_interval` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `height` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `hostname` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `notes` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `number_tracks` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `objective` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `organ` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `product` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `sample_0time` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `sample_0z` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `scan_type` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `short_genotype` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `specimen` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `tissue` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `uas_reporter` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `voxel_size_x` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `voxel_size_y` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `voxel_size_z` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `width` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `zoom_x` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `zoom_y` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  `zoom_z` longtext CHARACTER SET latin1 COLLATE latin1_general_cs,
  KEY `tmp_image_data_mv_id_ind` (`id`),
  KEY `image_data_mv_line_ind` (`line`),
  KEY `image_data_mv_name_ind` (`name`),
  KEY `image_data_mv_family_ind` (`family`),
  KEY `image_data_mv_capture_date_ind` (`capture_date`),
  KEY `image_data_mv_representative_ind` (`representative`),
  KEY `image_data_mv_display_ind` (`display`),
  KEY `image_data_mv_area_ind` (`area`(767)),
  KEY `image_data_mv_class_ind` (`class`(767)),
  KEY `image_data_mv_gender_ind` (`gender`(767)),
  KEY `image_data_mv_height_ind` (`height`(767)),
  KEY `image_data_mv_objective_ind` (`objective`(767)),
  KEY `image_data_mv_width_ind` (`width`(767))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `image_data_vw`
--

DROP TABLE IF EXISTS `image_data_vw`;
/*!50001 DROP VIEW IF EXISTS `image_data_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `image_data_vw` (
  `gene` longtext,
  `id` int(10) unsigned,
  `line` varchar(767),
  `name` varchar(767),
  `family` varchar(255),
  `capture_date` timestamp,
  `representative` tinyint(3) unsigned,
  `display` tinyint(1),
  `age` longtext,
  `area` longtext,
  `bc_correction1` longtext,
  `bc_correction2` longtext,
  `bits_per_sample` longtext,
  `channels` longtext,
  `chron_hour` longtext,
  `chron_interval` longtext,
  `chron_stage` longtext,
  `class` longtext,
  `dimension_x` longtext,
  `dimension_y` longtext,
  `dimension_z` longtext,
  `file_size` longtext,
  `gender` longtext,
  `genotype` longtext,
  `heat_shock_hour` longtext,
  `heat_shock_interval` longtext,
  `height` longtext,
  `hostname` longtext,
  `notes` longtext,
  `number_tracks` longtext,
  `objective` longtext,
  `organ` longtext,
  `product` longtext,
  `sample_0time` longtext,
  `sample_0z` longtext,
  `scan_type` longtext,
  `short_genotype` longtext,
  `specimen` longtext,
  `tissue` longtext,
  `uas_reporter` longtext,
  `voxel_size_x` longtext,
  `voxel_size_y` longtext,
  `voxel_size_z` longtext,
  `width` longtext,
  `zoom_x` longtext,
  `zoom_y` longtext,
  `zoom_z` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `image_gene_vw`
--

DROP TABLE IF EXISTS `image_gene_vw`;
/*!50001 DROP VIEW IF EXISTS `image_gene_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `image_gene_vw` (
  `image_id` int(10) unsigned,
  `family` varchar(255),
  `gene` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `image_property`
--

DROP TABLE IF EXISTS `image_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `image_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `image_property_image_fk_ind` (`image_id`) USING BTREE,
  KEY `image_property_type_fk_ind` (`type_id`) USING BTREE,
  KEY `image_property_value_ind` (`value`(100)) USING BTREE,
  CONSTRAINT `imageprop_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `imageprop_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1207676 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `image_property_vw`
--

DROP TABLE IF EXISTS `image_property_vw`;
/*!50001 DROP VIEW IF EXISTS `image_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `image_property_vw` (
  `id` int(10) unsigned,
  `image_id` int(10) unsigned,
  `cv` varchar(255),
  `type` varchar(255),
  `value` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `image_vw`
--

DROP TABLE IF EXISTS `image_vw`;
/*!50001 DROP VIEW IF EXISTS `image_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `image_vw` (
  `id` int(10) unsigned,
  `name` varchar(767),
  `url` varchar(1000),
  `path` varchar(1000),
  `source` varchar(255),
  `family` varchar(255),
  `line` varchar(767),
  `capture_date` timestamp,
  `representative` tinyint(3) unsigned,
  `display` tinyint(1),
  `created_by` varchar(1000),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ipcr_session_vw`
--

DROP TABLE IF EXISTS `ipcr_session_vw`;
/*!50001 DROP VIEW IF EXISTS `ipcr_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ipcr_session_vw` (
  `id` int(10) unsigned,
  `alternative` longtext,
  `balancer_status` longtext,
  `comments` longtext,
  `confidence` longtext,
  `cytology` longtext,
  `insert_viability` longtext,
  `mapped_date` longtext,
  `mspi_trimmed` longtext,
  `pelement` longtext,
  `sau3a_trimmed` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ipcr_vw`
--

DROP TABLE IF EXISTS `ipcr_vw`;
/*!50001 DROP VIEW IF EXISTS `ipcr_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `ipcr_vw` (
  `line` varchar(767),
  `lab` varchar(255),
  `gene` varchar(767),
  `id` int(10) unsigned,
  `alternative` longtext,
  `balancer_status` longtext,
  `comments` longtext,
  `confidence` longtext,
  `cytology` longtext,
  `insert_viability` longtext,
  `mapped_date` longtext,
  `mspi_trimmed` longtext,
  `pelement` longtext,
  `sau3a_trimmed` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `lab_vw`
--

DROP TABLE IF EXISTS `lab_vw`;
/*!50001 DROP VIEW IF EXISTS `lab_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `lab_vw` (
  `id` int(10) unsigned,
  `lab` varchar(255),
  `display_name` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `laser`
--

DROP TABLE IF EXISTS `laser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `laser` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `image_id` int(10) unsigned NOT NULL,
  `power` varchar(32) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `laser_image_id_fk_ind` (`image_id`) USING BTREE,
  CONSTRAINT `laser_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=55258 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `line`
--

DROP TABLE IF EXISTS `line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `line` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `lab_id` int(10) unsigned NOT NULL,
  `gene_id` int(10) unsigned DEFAULT NULL,
  `organism_id` int(10) unsigned DEFAULT NULL,
  `genotype` text,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `line_name_uk_ind` (`name`,`lab_id`) USING BTREE,
  KEY `line_lab_fk_ind` (`lab_id`) USING BTREE,
  KEY `line_gene_fk_ind` (`gene_id`) USING BTREE,
  KEY `line_organism_fk_ind` (`organism_id`) USING BTREE,
  KEY `line_name_ind` (`name`),
  CONSTRAINT `line_lab_id_fk` FOREIGN KEY (`lab_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `line_gene_id_fk` FOREIGN KEY (`gene_id`) REFERENCES `gene` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `line_organism_id_fk` FOREIGN KEY (`organism_id`) REFERENCES `organism` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10633 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `line_event`
--

DROP TABLE IF EXISTS `line_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `line_event` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `line_id` int(10) unsigned NOT NULL,
  `event_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `line_event_line_id_fk_ind` (`line_id`) USING BTREE,
  KEY `line_event_event_id_fk_ind` (`event_id`) USING BTREE,
  CONSTRAINT `line_event_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `line_event_process_id_fk` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=554664 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `line_event_property`
--

DROP TABLE IF EXISTS `line_event_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `line_event_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `line_event_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `line_event_property_type_uk_ind` (`type_id`,`line_event_id`) USING BTREE,
  KEY `line_event_property_event_id_fk_ind` (`line_event_id`) USING BTREE,
  KEY `line_event_propery_type_id_fk_ind` (`type_id`) USING BTREE,
  CONSTRAINT `line_event_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `line_event_property_event_id_fk` FOREIGN KEY (`line_event_id`) REFERENCES `line_event` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=987086 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `line_event_property_vw`
--

DROP TABLE IF EXISTS `line_event_property_vw`;
/*!50001 DROP VIEW IF EXISTS `line_event_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_event_property_vw` (
  `id` int(10) unsigned,
  `event_id` int(10) unsigned,
  `line` varchar(767),
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_experiment_type_unique_vw`
--

DROP TABLE IF EXISTS `line_experiment_type_unique_vw`;
/*!50001 DROP VIEW IF EXISTS `line_experiment_type_unique_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_experiment_type_unique_vw` (
  `experiment` varchar(255),
  `line` longtext,
  `cv` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_experiment_type_vw`
--

DROP TABLE IF EXISTS `line_experiment_type_vw`;
/*!50001 DROP VIEW IF EXISTS `line_experiment_type_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_experiment_type_vw` (
  `line` longtext,
  `fly_olympiad_aggression` bigint(21),
  `fly_olympiad_box` bigint(21),
  `fly_olympiad_gap` bigint(21),
  `fly_olympiad_lethality` bigint(21),
  `fly_olympiad_observation` bigint(21),
  `fly_olympiad_sterility` bigint(21),
  `fly_olympiad_trikinetics` bigint(21),
  `grooming` bigint(21),
  `ipcr` bigint(21),
  `proboscis_extension` bigint(21)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_experiment_vw`
--

DROP TABLE IF EXISTS `line_experiment_vw`;
/*!50001 DROP VIEW IF EXISTS `line_experiment_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_experiment_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `line` varchar(767),
  `cv` varchar(255),
  `type` varchar(255),
  `experimenter` varchar(255),
  `lab` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_gene_vw`
--

DROP TABLE IF EXISTS `line_gene_vw`;
/*!50001 DROP VIEW IF EXISTS `line_gene_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_gene_vw` (
  `line_id` int(11) unsigned,
  `gene` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `line_property`
--

DROP TABLE IF EXISTS `line_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `line_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `line_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `line_property_type_uk_ind` (`type_id`,`line_id`) USING BTREE,
  KEY `line_property_line_id_fk_ind` (`line_id`) USING BTREE,
  KEY `line_property_type_id_fk_ind` (`type_id`) USING BTREE,
  CONSTRAINT `line_property_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `line_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=64766 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `line_property_vw`
--

DROP TABLE IF EXISTS `line_property_vw`;
/*!50001 DROP VIEW IF EXISTS `line_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_property_vw` (
  `id` int(10) unsigned,
  `line_id` int(10) unsigned,
  `name` varchar(767),
  `lab` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_session_type_vw`
--

DROP TABLE IF EXISTS `line_session_type_vw`;
/*!50001 DROP VIEW IF EXISTS `line_session_type_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_session_type_vw` (
  `line` varchar(767),
  `fly_olympiad_aggression` bigint(21),
  `fly_olympiad_box` bigint(21),
  `fly_olympiad_gap` bigint(21),
  `fly_olympiad_lethality` bigint(21),
  `fly_olympiad_sterility` bigint(21),
  `grooming` bigint(21),
  `ipcr` bigint(21),
  `proboscis_extension` bigint(21)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_summary_vw`
--

DROP TABLE IF EXISTS `line_summary_vw`;
/*!50001 DROP VIEW IF EXISTS `line_summary_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_summary_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `genotype` text,
  `lab` varchar(255),
  `sessions` char(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `line_vw`
--

DROP TABLE IF EXISTS `line_vw`;
/*!50001 DROP VIEW IF EXISTS `line_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `line_vw` (
  `id` int(10) unsigned,
  `name` varchar(767),
  `lab` varchar(255),
  `lab_display_name` varchar(255),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `organism` varchar(511),
  `genotype` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `namespace_sequence_number`
--

DROP TABLE IF EXISTS `namespace_sequence_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `namespace_sequence_number` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `namespace` varchar(767) NOT NULL,
  `sequence_number` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namespace_name_uk_ind` (`namespace`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `observation`
--

DROP TABLE IF EXISTS `observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `observation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned DEFAULT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `term_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `observation_type_uk_ind` (`type_id`,`session_id`,`term_id`) USING BTREE,
  KEY `observation_session_id_fk_ind` (`session_id`) USING BTREE,
  KEY `observation_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `observation_term_id_fk_ind` (`term_id`) USING BTREE,
  KEY `observation_value_ind` (`value`(100)) USING BTREE,
  KEY `observation_experiment_id_fk_ind` (`experiment_id`) USING BTREE,
  CONSTRAINT `observation_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `observation_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `observation_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `observation_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=172669 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `observation_vw`
--

DROP TABLE IF EXISTS `observation_vw`;
/*!50001 DROP VIEW IF EXISTS `observation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `observation_vw` (
  `id` int(10) unsigned,
  `session_id` int(10) unsigned,
  `cv_term` varchar(255),
  `term` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_analysis_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_analysis_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_analysis_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_analysis_session_property_vw` (
  `session_id` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_analysis_session_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_analysis_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_analysis_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_analysis_session_vw` (
  `session_id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `score_array_type` varchar(255),
  `value` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_arena_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_arena_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_arena_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_arena_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `type` varchar(255),
  `protocol` binary(0),
  `lab` varchar(255),
  `arena` text,
  `temperature` text,
  `experimenter` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_chamber_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_chamber_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_chamber_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_chamber_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `type` varchar(255),
  `protocol` binary(0),
  `lab` varchar(255),
  `experiment_name` varchar(255),
  `arena` text,
  `temperature` text,
  `experimenter` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `olympiad_aggression_experiment_data_mv`
--

DROP TABLE IF EXISTS `olympiad_aggression_experiment_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `olympiad_aggression_experiment_data_mv` (
  `arena_experiment_name` varchar(255) NOT NULL,
  `arena_experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `experimenter` varchar(255) NOT NULL,
  `chamber_experiment_name` varchar(255) NOT NULL,
  `chamber_experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `experiment_date_time` varchar(50) NOT NULL DEFAULT '',
  `experiment_day_of_week` int(1) DEFAULT NULL,
  `file_system_path` text,
  `experiment_protocol` binary(0) DEFAULT NULL,
  `automated_pf` text,
  `manual_pf` text,
  `temperature` text NOT NULL,
  `humidity` text NOT NULL,
  `camera` text NOT NULL,
  `arena` text NOT NULL,
  `num_chambers` text NOT NULL,
  `border_width` text NOT NULL,
  `correct_orientation` text NOT NULL,
  `correct_positions` text NOT NULL,
  `courtship_present` text NOT NULL,
  `frame_rate` text NOT NULL,
  `mult_flies_present` text NOT NULL,
  `number_denoised_frames` text NOT NULL,
  `num_unprocessed_movies` text NOT NULL,
  `process_stopped` text NOT NULL,
  `radius` text NOT NULL,
  `radius_plus_border` text NOT NULL,
  `scale_calibration_file` text NOT NULL,
  `tuning_threshold` text NOT NULL,
  `notes_loading` text,
  `notes_behavioral` text,
  UNIQUE KEY `olympiad_aggression_edmv_chamber_id_ind` (`chamber_experiment_id`),
  KEY `olympiad_aggression_edmv_experiment_datetime_ind` (`experiment_date_time`),
  KEY `olympiad_aggression_edmv_experiment_dayofweek_ind` (`experiment_day_of_week`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `olympiad_aggression_feature_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_feature_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_feature_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_feature_vw` (
  `arena_experiment_name` varchar(255),
  `arena_experiment_id` int(10) unsigned,
  `experimenter` varchar(255),
  `chamber_experiment_name` varchar(255),
  `chamber_experiment_id` int(10) unsigned,
  `experiment_date_time` varchar(50),
  `experiment_day_of_week` int(1),
  `file_system_path` text,
  `experiment_protocol` binary(0),
  `automated_pf` text,
  `manual_pf` text,
  `temperature` text,
  `humidity` text,
  `camera` text,
  `arena` text,
  `num_chambers` text,
  `border_width` text,
  `correct_orientation` text,
  `correct_positions` text,
  `courtship_present` text,
  `frame_rate` text,
  `mult_flies_present` text,
  `number_denoised_frames` text,
  `num_unprocessed_movies` text,
  `process_stopped` text,
  `radius` text,
  `radius_plus_border` text,
  `scale_calibration_file` text,
  `tuning_threshold` text,
  `session_id` int(10) unsigned,
  `behavior` varchar(255),
  `session_name` varchar(767),
  `fly` char(255),
  `line_name` varchar(767),
  `line_id` int(10) unsigned,
  `line_lab` varchar(255),
  `effector` text,
  `rearing_temperature` text,
  `chamber` text,
  `genotype` text,
  `marking` text,
  `housing` text,
  `notes_loading` text,
  `data_type` char(255),
  `data` longblob,
  `data_rows` int(10) unsigned,
  `data_columns` int(10) unsigned,
  `data_format` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_feature_vw2`
--

DROP TABLE IF EXISTS `olympiad_aggression_feature_vw2`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_feature_vw2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_feature_vw2` (
  `arena_experiment_name` varchar(255),
  `arena_experiment_id` int(10) unsigned,
  `experimenter` varchar(255),
  `chamber_experiment_name` varchar(255),
  `chamber_experiment_id` int(10) unsigned,
  `experiment_date_time` varchar(50),
  `file_system_path` text,
  `experiment_protocol` binary(0),
  `automated_pf` text,
  `manual_pf` text,
  `temperature` text,
  `humidity` text,
  `camera` text,
  `arena` text,
  `num_chambers` text,
  `border_width` text,
  `correct_orientation` text,
  `correct_positions` text,
  `courtship_present` text,
  `frame_rate` text,
  `mult_flies_present` text,
  `number_denoised_frames` text,
  `num_unprocessed_movies` text,
  `process_stopped` text,
  `radius` text,
  `radius_plus_border` text,
  `scale_calibration_file` text,
  `tuning_threshold` text,
  `session_id` int(10) unsigned,
  `behavior` varchar(255),
  `session_name` varchar(767),
  `fly` char(255),
  `line_name` varchar(767),
  `line_id` int(10) unsigned,
  `line_lab` varchar(255),
  `effector` text,
  `rearing_temperature` text,
  `chamber` text,
  `genotype` text,
  `marking` text,
  `housing` text,
  `notes_loading` text,
  `data_type` char(255),
  `data` double,
  `data_rows` int(1),
  `data_columns` int(1),
  `data_format` varchar(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `olympiad_aggression_session_feature_data_mv`
--

DROP TABLE IF EXISTS `olympiad_aggression_session_feature_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `olympiad_aggression_session_feature_data_mv` (
  `chamber_experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `session_id` int(10) unsigned NOT NULL DEFAULT '0',
  `behavior` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `session_name` varchar(767) NOT NULL,
  `line_name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `line_id` int(10) unsigned NOT NULL DEFAULT '0',
  `line_lab` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `effector` text,
  `rearing_temperature` text,
  `chamber` text,
  `genotype` text NOT NULL,
  `marking` text,
  `housing` text,
  UNIQUE KEY `olympiad_aggression_sfd_mv_session_id_ind` (`session_id`),
  KEY `olympiad_aggression_sfd_mv_chamber_id_ind` (`chamber_experiment_id`),
  KEY `olympiad_aggression_sfd_mv_line_name_ind` (`line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `olympiad_aggression_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_session_property_vw` (
  `session_id` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `olympiad_aggression_session_tracking_data_mv`
--

DROP TABLE IF EXISTS `olympiad_aggression_session_tracking_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `olympiad_aggression_session_tracking_data_mv` (
  `chamber_experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `session_id` int(10) unsigned NOT NULL DEFAULT '0',
  `behavior` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `session_name` varchar(767) NOT NULL,
  `line_name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `line_id` int(10) unsigned NOT NULL DEFAULT '0',
  `line_lab` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `effector` text,
  `rearing_temperature` text,
  `chamber` text,
  `genotype` text NOT NULL,
  `marking` text,
  `housing` text,
  UNIQUE KEY `olympiad_aggression_sfd_mv_session_id_ind` (`session_id`),
  KEY `olympiad_aggression_sfd_mv_chamber_id_ind` (`chamber_experiment_id`),
  KEY `olympiad_aggression_sfd_mv_line_name_ind` (`line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `olympiad_aggression_session_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_session_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `genotype` text,
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `experiment_id` int(10) unsigned,
  `session_type` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_tracking_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_tracking_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_tracking_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_tracking_vw` (
  `arena_experiment_name` varchar(255),
  `arena_experiment_id` int(10) unsigned,
  `experimenter` varchar(255),
  `chamber_experiment_name` varchar(255),
  `chamber_experiment_id` int(10) unsigned,
  `experiment_date_time` varchar(50),
  `experiment_day_of_week` int(1),
  `file_system_path` text,
  `experiment_protocol` binary(0),
  `automated_pf` text,
  `manual_pf` text,
  `temperature` text,
  `humidity` text,
  `camera` text,
  `arena` text,
  `num_chambers` text,
  `border_width` text,
  `correct_orientation` text,
  `correct_positions` text,
  `courtship_present` text,
  `frame_rate` text,
  `mult_flies_present` text,
  `number_denoised_frames` text,
  `num_unprocessed_movies` text,
  `process_stopped` text,
  `radius` text,
  `radius_plus_border` text,
  `scale_calibration_file` text,
  `tuning_threshold` text,
  `session_id` int(10) unsigned,
  `behavior` varchar(255),
  `session_name` varchar(767),
  `fly` char(255),
  `line_name` varchar(767),
  `line_id` int(10) unsigned,
  `line_lab` varchar(255),
  `effector` text,
  `rearing_temperature` text,
  `chamber` text,
  `genotype` text,
  `marking` text,
  `housing` text,
  `notes_loading` text,
  `data_type` char(255),
  `data_rows` int(10) unsigned,
  `data_columns` int(10) unsigned,
  `data_format` varchar(255),
  `data` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_tracking_vw2`
--

DROP TABLE IF EXISTS `olympiad_aggression_tracking_vw2`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_tracking_vw2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_tracking_vw2` (
  `arena_experiment_name` varchar(255),
  `arena_experiment_id` int(10) unsigned,
  `experimenter` varchar(255),
  `chamber_experiment_name` varchar(255),
  `chamber_experiment_id` int(10) unsigned,
  `experiment_date_time` varchar(50),
  `file_system_path` text,
  `experiment_protocol` binary(0),
  `automated_pf` text,
  `manual_pf` text,
  `temperature` text,
  `humidity` text,
  `camera` text,
  `arena` text,
  `num_chambers` text,
  `border_width` text,
  `correct_orientation` text,
  `correct_positions` text,
  `courtship_present` text,
  `frame_rate` text,
  `mult_flies_present` text,
  `number_denoised_frames` text,
  `num_unprocessed_movies` text,
  `process_stopped` text,
  `radius` text,
  `radius_plus_border` text,
  `scale_calibration_file` text,
  `tuning_threshold` text,
  `session_id` int(10) unsigned,
  `behavior` varchar(255),
  `session_name` varchar(767),
  `fly` char(255),
  `line_name` varchar(767),
  `line_id` int(10) unsigned,
  `line_lab` varchar(255),
  `effector` text,
  `rearing_temperature` text,
  `chamber` text,
  `genotype` text,
  `marking` text,
  `housing` text,
  `notes_loading` text,
  `data_type` char(255),
  `data_rows` int(1),
  `data_columns` int(1),
  `data_format` varchar(6),
  `data` double
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_aggression_vw`
--

DROP TABLE IF EXISTS `olympiad_aggression_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_aggression_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `chamber` varchar(255),
  `effector` text,
  `genotype` text,
  `arena` text,
  `temperature` text,
  `session_type` char(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_analysis_info_vw`
--

DROP TABLE IF EXISTS `olympiad_box_analysis_info_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_info_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_analysis_info_vw` (
  `experiment_id` int(10) unsigned,
  `experiment_name` varchar(255),
  `experimenter` varchar(255),
  `experiment_date_time` varchar(50),
  `box_name` varchar(50),
  `top_plate_id` varchar(50),
  `experiment_protocol` varchar(50),
  `file_system_path` text,
  `failure` text,
  `errorcode` text,
  `automated_pf` text,
  `manual_pf` text,
  `cool_max_var` text,
  `hot_max_var` text,
  `transition_duration` text,
  `questionable_data` text,
  `redo_experiment` text,
  `live_notes` text,
  `operator` text,
  `max_vibration` text,
  `total_duration_seconds` text,
  `force_seq_start` text,
  `halt_early` text,
  `session_id` int(10) unsigned,
  `tube` bigint(67) unsigned,
  `line_id` int(10) unsigned,
  `line_name` varchar(767),
  `line_lab` varchar(255),
  `phase_id` int(10) unsigned,
  `sequence` bigint(67) unsigned,
  `temperature` bigint(67) unsigned,
  `genotype` text,
  `effector` text,
  `gender` text,
  `n` text,
  `n_dead` text,
  `dob` text,
  `rearing` text,
  `starved` text,
  `data_type` varchar(241),
  `data_rows` int(10) unsigned,
  `data_columns` int(10) unsigned,
  `data_format` varchar(255),
  `data` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_analysis_results_vw`
--

DROP TABLE IF EXISTS `olympiad_box_analysis_results_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_results_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_analysis_results_vw` (
  `experiment_id` int(10) unsigned,
  `experiment_name` varchar(255),
  `experimenter` varchar(255),
  `experiment_date_time` varchar(50),
  `box_name` varchar(50),
  `top_plate_id` varchar(50),
  `experiment_protocol` varchar(50),
  `file_system_path` text,
  `failure` text,
  `errorcode` text,
  `automated_pf` text,
  `manual_pf` text,
  `cool_max_var` text,
  `hot_max_var` text,
  `transition_duration` text,
  `questionable_data` text,
  `redo_experiment` text,
  `live_notes` text,
  `operator` text,
  `max_vibration` text,
  `total_duration_seconds` text,
  `force_seq_start` text,
  `halt_early` text,
  `metadata_session_id` int(10) unsigned,
  `tube` bigint(67) unsigned,
  `line_id` int(10) unsigned,
  `line_name` varchar(767),
  `line_lab` varchar(255),
  `phase_id` int(10) unsigned,
  `sequence` bigint(67) unsigned,
  `temperature` bigint(67) unsigned,
  `genotype` text,
  `effector` text,
  `gender` text,
  `n` text,
  `n_dead` text,
  `analysis_session_id` int(10) unsigned,
  `analysis_version` text,
  `dob` text,
  `rearing` text,
  `starved` text,
  `data_type` varchar(255),
  `data_rows` int(10) unsigned,
  `data_columns` int(10) unsigned,
  `data_format` varchar(255),
  `data` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_analysis_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_box_analysis_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_analysis_session_property_vw` (
  `session_id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `sequence` text,
  `region` text,
  `temperature` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_analysis_session_vw`
--

DROP TABLE IF EXISTS `olympiad_box_analysis_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_analysis_session_vw` (
  `session_id` int(10) unsigned,
  `sequence` text,
  `tube` text,
  `temperature` text,
  `experiment_id` int(10) unsigned,
  `score_array_type` varchar(255),
  `value` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_environmental_vw`
--

DROP TABLE IF EXISTS `olympiad_box_environmental_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_environmental_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_environmental_vw` (
  `experiment_id` int(10) unsigned,
  `experiment_name` varchar(255),
  `experimenter` varchar(255),
  `experiment_date_time` varchar(50),
  `experiment_day_of_week` int(1),
  `box_name` varchar(50),
  `top_plate_id` varchar(50),
  `experiment_protocol` varchar(50),
  `file_system_path` text,
  `failure` text,
  `errorcode` text,
  `automated_pf` text,
  `manual_pf` text,
  `cool_max_var` text,
  `hot_max_var` text,
  `transition_duration` text,
  `questionable_data` text,
  `redo_experiment` text,
  `live_notes` text,
  `operator` text,
  `max_vibration` text,
  `total_duration_seconds` text,
  `force_seq_start` text,
  `halt_early` text,
  `data_type` varchar(255),
  `data_rows` int(10) unsigned,
  `data_columns` int(10) unsigned,
  `data_format` varchar(255),
  `data` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `olympiad_box_experiment_data_mv`
--

DROP TABLE IF EXISTS `olympiad_box_experiment_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `olympiad_box_experiment_data_mv` (
  `experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `experiment_name` varchar(255) NOT NULL,
  `experimenter` varchar(255) NOT NULL,
  `experiment_date_time` varchar(50) NOT NULL DEFAULT '',
  `experiment_day_of_week` int(1) DEFAULT NULL,
  `box_name` varchar(50) NOT NULL DEFAULT '',
  `top_plate_id` varchar(50) NOT NULL DEFAULT '',
  `experiment_protocol` varchar(50) NOT NULL DEFAULT '',
  `file_system_path` text NOT NULL,
  `failure` text NOT NULL,
  `errorcode` text NOT NULL,
  `automated_pf` text,
  `manual_pf` text,
  `cool_max_var` text NOT NULL,
  `hot_max_var` text NOT NULL,
  `transition_duration` text NOT NULL,
  `questionable_data` text NOT NULL,
  `redo_experiment` text NOT NULL,
  `live_notes` text NOT NULL,
  `operator` text,
  `max_vibration` text NOT NULL,
  `total_duration_seconds` text NOT NULL,
  `force_seq_start` text NOT NULL,
  `halt_early` text NOT NULL,
  `phase_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sequence` bigint(67) unsigned NOT NULL DEFAULT '0',
  `temperature` bigint(67) unsigned NOT NULL DEFAULT '0',
  KEY `olympiad_box_edmv_experiment_id_ind` (`experiment_id`),
  KEY `olympiad_box_edmv_box_name_ind` (`box_name`),
  KEY `olympiad_box_edmv_top_plate_id_ind` (`top_plate_id`),
  KEY `olympiad_box_edmv_experiment_protocol_ind` (`experiment_protocol`),
  KEY `olympiad_box_edmv_experiment_datetime_ind` (`experiment_date_time`),
  KEY `olympiad_box_edmv_experiment_dayofweek_ind` (`experiment_day_of_week`),
  KEY `olympiad_box_edmv_temperature_ind` (`temperature`),
  KEY `olympiad_box_edmv_sequence_ind` (`sequence`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `olympiad_box_experiment_property_vw`
--

DROP TABLE IF EXISTS `olympiad_box_experiment_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_experiment_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_experiment_property_vw` (
  `experiment_id` int(10) unsigned,
  `date_time` longtext,
  `box_name` longtext,
  `top_plate_id` longtext,
  `failure` longtext,
  `errorcode` longtext,
  `cool_max_var` longtext,
  `hot_max_var` longtext,
  `transition_duration` longtext,
  `questionable_data` longtext,
  `redo_experiment` longtext,
  `live_notes` longtext,
  `operator` longtext,
  `max_vibration` longtext,
  `total_duration_seconds` longtext,
  `force_seq_start` longtext,
  `halt_early` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_sbfmf_stat_score_vw`
--

DROP TABLE IF EXISTS `olympiad_box_sbfmf_stat_score_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_sbfmf_stat_score_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_sbfmf_stat_score_vw` (
  `session_id` int(10) unsigned,
  `phase_id` int(10) unsigned,
  `meanerror` double,
  `maxerror` double,
  `meanwindowerror` double,
  `maxwindowerror` double,
  `compressionrate` double
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `olympiad_box_session_analysis_data_mv`
--

DROP TABLE IF EXISTS `olympiad_box_session_analysis_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `olympiad_box_session_analysis_data_mv` (
  `experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `analysis_session_id` int(10) unsigned NOT NULL DEFAULT '0',
  `analysis_version` text NOT NULL,
  `temperature` bigint(67) unsigned NOT NULL DEFAULT '0',
  `sequence` bigint(67) unsigned NOT NULL DEFAULT '0',
  `region` bigint(67) unsigned NOT NULL DEFAULT '0',
  KEY `olympiad_box_sad_mv_experiment_id_ind` (`experiment_id`),
  KEY `olympiad_box_sad_mv_session_id_ind` (`analysis_session_id`),
  KEY `olympiad_box_sad_mv_sequence_ind` (`sequence`),
  KEY `olympiad_box_sad_mv_region_ind` (`region`),
  KEY `olympiad_box_sad_mv_temperature_ind` (`temperature`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `olympiad_box_session_meta_data_mv`
--

DROP TABLE IF EXISTS `olympiad_box_session_meta_data_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `olympiad_box_session_meta_data_mv` (
  `experiment_id` int(10) unsigned NOT NULL DEFAULT '0',
  `metadata_session_id` int(10) unsigned NOT NULL DEFAULT '0',
  `tube` bigint(67) unsigned NOT NULL DEFAULT '0',
  `line_id` int(10) unsigned NOT NULL,
  `line_name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `line_lab` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `genotype` text NOT NULL,
  `effector` text NOT NULL,
  `gender` text NOT NULL,
  `n` text NOT NULL,
  `n_dead` text NOT NULL,
  `dob` text NOT NULL,
  `rearing` text NOT NULL,
  `starved` text NOT NULL,
  KEY `olympiad_box_smd_mv_experiment_id_ind` (`experiment_id`),
  KEY `olympiad_box_smd_mv_line_id_ind` (`line_id`),
  KEY `olympiad_box_smd_mv_line_name_ind` (`line_name`),
  KEY `olympiad_box_smd_mv_tube_ind` (`tube`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `olympiad_box_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_box_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_session_property_vw` (
  `session_id` int(10) unsigned,
  `effector` text,
  `genotype` text,
  `rearing` text,
  `gender` text,
  `session_type` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_session_vw`
--

DROP TABLE IF EXISTS `olympiad_box_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_session_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `experiment_id` int(10) unsigned,
  `session_type` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_box_vw`
--

DROP TABLE IF EXISTS `olympiad_box_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_box_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `effector` text,
  `genotype` text,
  `rearing` text,
  `gender` text,
  `box` text,
  `protocol` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_experiment_property_vw`
--

DROP TABLE IF EXISTS `olympiad_experiment_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_experiment_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_experiment_property_vw` (
  `id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_experiment_vw`
--

DROP TABLE IF EXISTS `olympiad_experiment_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_experiment_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_experiment_vw` (
  `id` int(10) unsigned,
  `name` varchar(255),
  `type` varchar(255),
  `protocol` text,
  `lab` varchar(255),
  `experimenter` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_analysis_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_analysis_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_analysis_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_analysis_session_property_vw` (
  `session_id` int(10) unsigned,
  `temperature` text,
  `instrument` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_analysis_session_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_analysis_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_analysis_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_analysis_session_vw` (
  `session_id` int(10) unsigned,
  `temperature` text,
  `instrument` text,
  `experiment_id` int(10) unsigned,
  `score_array_type` varchar(255),
  `value` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_analysis_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_analysis_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_analysis_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_analysis_vw` (
  `line_id` int(10) unsigned,
  `line_name` varchar(767),
  `experiment_id` int(10) unsigned,
  `experiment_name` varchar(255),
  `session_id` int(10) unsigned,
  `session_name` varchar(767),
  `first_frame_disk6_occupied` double,
  `first_max_mean_disk_frame` double,
  `first_max_mean_disk_frame_window` longblob,
  `last_mean_disk` double,
  `max_mean_disk` double,
  `min_arena_total` double,
  `max_arena_total` double,
  `mean_arena_total` double,
  `median_arena_total` double,
  `std_arena_total` double
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_counts_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_counts_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_counts_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_counts_vw` (
  `experiment_id` int(11) unsigned,
  `experiment_name` varchar(255),
  `experiment_protocol` binary(0),
  `experimenter` varchar(255),
  `file_system_path` text,
  `session_id` int(11) unsigned,
  `session_name` longtext,
  `line_id` int(11) unsigned,
  `line_name` longtext,
  `line_lab` varchar(255),
  `brightness` text,
  `center_loc_info_radius` text,
  `center_loc_info_x` text,
  `center_loc_info_y` text,
  `duration` text,
  `exposure_time` text,
  `frame_rate` text,
  `gain` text,
  `radius_disk1` text,
  `radius_disk2` text,
  `radius_disk3` text,
  `radius_disk4` text,
  `radius_disk5` text,
  `radius_disk6` text,
  `radius_gap1` text,
  `radius_gap2` text,
  `radius_gap3` text,
  `radius_gap4` text,
  `radius_gap5` text,
  `region` text,
  `threshold` text,
  `date_time` text,
  `effector` text,
  `gender` text,
  `instrument` text,
  `hours_starved` text,
  `temperature` text,
  `data_type` varchar(255),
  `data` longblob,
  `data_rows` bigint(20) unsigned,
  `data_columns` bigint(20) unsigned,
  `data_format` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_session_property_vw` (
  `session_id` int(10) unsigned,
  `effector` longtext,
  `genotype` longtext,
  `rearing` longtext,
  `gender` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_session_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_session_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `experiment_id` int(10) unsigned,
  `session_type` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_gap_vw`
--

DROP TABLE IF EXISTS `olympiad_gap_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_gap_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `effector` text,
  `genotype` text,
  `rearing` text,
  `gender` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_lethality_experiment_property_vw`
--

DROP TABLE IF EXISTS `olympiad_lethality_experiment_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_experiment_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_lethality_experiment_property_vw` (
  `experiment_id` int(10) unsigned,
  `effector` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_lethality_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_lethality_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_lethality_session_property_vw` (
  `session_id` int(10) unsigned,
  `run_date` longtext,
  `temperature` longtext,
  `notes_behavioral` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_lethality_session_vw`
--

DROP TABLE IF EXISTS `olympiad_lethality_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_lethality_session_vw` (
  `line` varchar(767),
  `line_id` int(10) unsigned,
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `experiment_id` int(10) unsigned
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_lethality_vw`
--

DROP TABLE IF EXISTS `olympiad_lethality_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_lethality_vw` (
  `Date` longtext,
  `Lab` varchar(255),
  `Line` varchar(767),
  `Effector` longtext,
  `Stage_at_Death` text,
  `Temperature` longtext,
  `Behavioral_Notes` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_observation_observation_vw`
--

DROP TABLE IF EXISTS `olympiad_observation_observation_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_observation_observation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_observation_observation_vw` (
  `line` varchar(767),
  `experiment_id` int(10) unsigned,
  `session` varchar(767),
  `display_name` varchar(255),
  `observed` text,
  `gender` text,
  `periodicity` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_observation_vw`
--

DROP TABLE IF EXISTS `olympiad_observation_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_observation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_observation_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `effector` text,
  `genotype` text,
  `no_phenotypes` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_region_property_vw`
--

DROP TABLE IF EXISTS `olympiad_region_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_region_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_region_property_vw` (
  `id` int(10) unsigned,
  `region_id` int(10) unsigned,
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_region_vw`
--

DROP TABLE IF EXISTS `olympiad_region_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_region_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_region_vw` (
  `id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `line` varchar(767),
  `name` varchar(767),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_score_vw`
--

DROP TABLE IF EXISTS `olympiad_score_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_score_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_score_vw` (
  `id` int(10) unsigned,
  `sequence_id` int(10) unsigned,
  `region_id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `type` varchar(255),
  `array_value` longblob,
  `value` binary(0),
  `data_type` varchar(255),
  `row_count` int(10) unsigned,
  `column_count` int(10) unsigned,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_sequence_property_vw`
--

DROP TABLE IF EXISTS `olympiad_sequence_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_sequence_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_sequence_property_vw` (
  `id` int(10) unsigned,
  `sequence_id` int(10) unsigned,
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_sequence_vw`
--

DROP TABLE IF EXISTS `olympiad_sequence_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_sequence_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_sequence_vw` (
  `id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `name` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_sterility_instance_vw`
--

DROP TABLE IF EXISTS `olympiad_sterility_instance_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_instance_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_sterility_instance_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `effector` text,
  `genotype` text,
  `rearing` text,
  `gender` text,
  `experimenter` text,
  `data_type` char(255),
  `data` double,
  `data_rows` int(1),
  `data_columns` int(1),
  `data_format` varchar(6)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_sterility_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_sterility_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_sterility_session_property_vw` (
  `session_id` int(10) unsigned,
  `effector` longtext,
  `genotype` longtext,
  `rearing` longtext,
  `gender` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_sterility_session_vw`
--

DROP TABLE IF EXISTS `olympiad_sterility_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_sterility_session_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `experiment_id` int(10) unsigned,
  `session_type` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_sterility_vw`
--

DROP TABLE IF EXISTS `olympiad_sterility_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_sterility_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `effector` text,
  `genotype` text,
  `rearing` text,
  `gender` text,
  `sterile` double,
  `experimenter` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_analysis_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_analysis_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_analysis_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_analysis_session_property_vw` (
  `session_id` int(10) unsigned,
  `temperature` longtext,
  `monitor` longtext,
  `channel` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_analysis_session_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_analysis_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_analysis_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_analysis_session_vw` (
  `session_id` int(10) unsigned,
  `incubator` text,
  `temperature` longtext,
  `monitor` longtext,
  `channel` longtext,
  `experiment_id` int(10) unsigned,
  `score_array_type` varchar(255),
  `value` longblob
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_analysis_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_analysis_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_analysis_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_analysis_vw` (
  `experiment_id` int(11) unsigned,
  `experiment_name` varchar(255),
  `experimenter` varchar(255),
  `experiment_date_time` text,
  `temperature` text,
  `automated_pf` text,
  `manual_pf` text,
  `l_d_cycle` text,
  `experiment_protocol` text,
  `file_system_path` text,
  `bin_size` text,
  `incubator` text,
  `env_monitor` text,
  `session_id` int(11) unsigned,
  `session_name` longtext,
  `line_id` int(11) unsigned,
  `line_name` longtext,
  `line_lab` varchar(255),
  `channel_count` bigint(67) unsigned,
  `data_type` varchar(255),
  `data` longblob,
  `data_rows` bigint(20) unsigned,
  `data_columns` bigint(20) unsigned,
  `data_format` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_monitor_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_monitor_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_monitor_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_monitor_vw` (
  `experiment_id` int(10) unsigned,
  `experiment_name` varchar(255),
  `experimenter` varchar(255),
  `experiment_date_time` text,
  `temperature` text,
  `automated_pf` text,
  `manual_pf` text,
  `l_d_cycle` text,
  `experiment_protocol` text,
  `file_system_path` text,
  `bin_size` text,
  `incubator` text,
  `env_monitor` text,
  `session_id` int(10) unsigned,
  `session_name` varchar(767),
  `session_type` varchar(255),
  `line_id` int(10) unsigned,
  `line_name` varchar(767),
  `line_lab` varchar(255),
  `monitor` text,
  `start_date_time` text,
  `effector` text,
  `channel` text,
  `dead` longtext,
  `data_type` varchar(255),
  `data` longblob,
  `data_rows` int(10) unsigned,
  `data_columns` int(10) unsigned,
  `data_format` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_session_property_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_session_property_vw` (
  `session_id` int(10) unsigned,
  `effector` longtext,
  `genotype` longtext,
  `rearing` longtext,
  `gender` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_session_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_session_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_session_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `experiment_id` int(10) unsigned,
  `session_type` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `olympiad_trikinetics_vw`
--

DROP TABLE IF EXISTS `olympiad_trikinetics_vw`;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `olympiad_trikinetics_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(1000),
  `session` varchar(767),
  `experiment` varchar(255),
  `effector` text,
  `genotype` text,
  `rearing` text,
  `gender` text,
  `incubator` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `organism`
--

DROP TABLE IF EXISTS `organism`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organism` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `abbreviation` varchar(255) NOT NULL,
  `genus` varchar(255) NOT NULL,
  `species` varchar(255) NOT NULL,
  `common_name` varchar(255) NOT NULL,
  `taxonomy_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `organism_genus_ind` (`genus`) USING BTREE,
  KEY `organism_species_ind` (`species`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phase`
--

DROP TABLE IF EXISTS `phase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `experiment_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phase_type_uk_ind` (`name`,`type_id`,`experiment_id`) USING BTREE,
  KEY `phase_experiment_id_fk_ind` (`experiment_id`) USING BTREE,
  KEY `phase_type_id_fk_ind` (`type_id`) USING BTREE,
  CONSTRAINT `phase_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `phase_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30035 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phase_property`
--

DROP TABLE IF EXISTS `phase_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phase_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phase_property_type_uk_ind` (`type_id`,`phase_id`) USING BTREE,
  KEY `phase_property_phase_id_fk_ind` (`phase_id`) USING BTREE,
  KEY `phase_property_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `phase_property_value_ind` (`value`(100)) USING BTREE,
  CONSTRAINT `phase_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `phase_property_phase_id_fk` FOREIGN KEY (`phase_id`) REFERENCES `phase` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30036 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `phase_property_vw`
--

DROP TABLE IF EXISTS `phase_property_vw`;
/*!50001 DROP VIEW IF EXISTS `phase_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `phase_property_vw` (
  `id` int(10) unsigned,
  `phase_id` int(10) unsigned,
  `name` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `phase_vw`
--

DROP TABLE IF EXISTS `phase_vw`;
/*!50001 DROP VIEW IF EXISTS `phase_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `phase_vw` (
  `id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `name` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `prelim_annotation_observation_vw`
--

DROP TABLE IF EXISTS `prelim_annotation_observation_vw`;
/*!50001 DROP VIEW IF EXISTS `prelim_annotation_observation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prelim_annotation_observation_vw` (
  `session_id` int(10) unsigned,
  `term_id` int(10) unsigned,
  `term` varchar(255),
  `name` varchar(255),
  `value` text
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `prelim_annotation_session_vw`
--

DROP TABLE IF EXISTS `prelim_annotation_session_vw`;
/*!50001 DROP VIEW IF EXISTS `prelim_annotation_session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prelim_annotation_session_vw` (
  `id` int(10) unsigned,
  `age` longtext,
  `organ` longtext,
  `projection_all_url` longtext,
  `image_name` longtext,
  `extraordinary` longtext,
  `specimen_quality` longtext,
  `very_broad` longtext,
  `done` longtext,
  `empty` longtext,
  `panneural` longtext,
  `substructure` longtext,
  `heat_shock_age` longtext,
  `representative` longtext,
  `expression_regions` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `prelim_annotation_vw`
--

DROP TABLE IF EXISTS `prelim_annotation_vw`;
/*!50001 DROP VIEW IF EXISTS `prelim_annotation_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `prelim_annotation_vw` (
  `id` int(10) unsigned,
  `age` longtext,
  `organ` longtext,
  `projection_all_url` longtext,
  `image_name` longtext,
  `extraordinary` longtext,
  `specimen_quality` longtext,
  `very_broad` longtext,
  `done` longtext,
  `empty` longtext,
  `panneural` longtext,
  `substructure` longtext,
  `heat_shock_age` longtext,
  `representative` longtext,
  `expression_regions` longtext,
  `line` varchar(767),
  `gene` varchar(767),
  `name` varchar(767),
  `lab` varchar(255),
  `region` varchar(255),
  `expressed` longtext,
  `supergroup` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rubin_lab_external_property_vw`
--

DROP TABLE IF EXISTS `rubin_lab_external_property_vw`;
/*!50001 DROP VIEW IF EXISTS `rubin_lab_external_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rubin_lab_external_property_vw` (
  `id` int(10) unsigned,
  `line` varchar(767),
  `date` timestamp,
  `disc` longtext,
  `external_lab` longtext,
  `created_by` varchar(1000)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `rubin_lab_external_vw`
--

DROP TABLE IF EXISTS `rubin_lab_external_vw`;
/*!50001 DROP VIEW IF EXISTS `rubin_lab_external_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `rubin_lab_external_vw` (
  `name` varchar(767),
  `representative` tinyint(3) unsigned,
  `created_by` varchar(1000),
  `line` varchar(767),
  `date` timestamp,
  `disc` longtext,
  `external_lab` longtext,
  `display` tinyint(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `score`
--

DROP TABLE IF EXISTS `score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned DEFAULT NULL,
  `phase_id` int(10) unsigned DEFAULT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `term_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` double NOT NULL,
  `run` int(10) unsigned NOT NULL DEFAULT '0',
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `score_session_id_fk_ind` (`session_id`) USING BTREE,
  KEY `score_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `score_term_id_fk_ind` (`term_id`) USING BTREE,
  KEY `score_value_ind` (`value`) USING BTREE,
  KEY `score_phase_id_fk_ind` (`phase_id`) USING BTREE,
  KEY `score_experiment_id_fk_ind` (`experiment_id`) USING BTREE,
  KEY `score_session_phase_id_ind` (`session_id`,`phase_id`),
  CONSTRAINT `score_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `score_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `score_phase_id_fk` FOREIGN KEY (`phase_id`) REFERENCES `phase` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `score_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `score_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3226169 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `score_array`
--

DROP TABLE IF EXISTS `score_array`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_array` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned DEFAULT NULL,
  `phase_id` int(10) unsigned DEFAULT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `term_id` int(10) unsigned NOT NULL,
  `cv_id` int(10) unsigned NOT NULL DEFAULT '0',
  `type_id` int(10) unsigned NOT NULL,
  `value` mediumtext NOT NULL,
  `run` int(10) unsigned NOT NULL DEFAULT '0',
  `data_type` varchar(255) DEFAULT NULL,
  `row_count` int(10) unsigned DEFAULT NULL,
  `column_count` int(10) unsigned DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`cv_id`),
  KEY `score_array_session_id_ind` (`session_id`),
  KEY `score_array_phase_id_ind` (`phase_id`),
  KEY `score_array_experiment_id_ind` (`experiment_id`),
  KEY `score_array_term_id_ind` (`term_id`),
  KEY `score_array_type_id_ind` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12554002 DEFAULT CHARSET=latin1
/*!50100 PARTITION BY LIST (cv_id)
(PARTITION p0 VALUES IN (30) ENGINE = InnoDB,
 PARTITION p1 VALUES IN (31) ENGINE = InnoDB,
 PARTITION p2 VALUES IN (38) ENGINE = InnoDB,
 PARTITION p3 VALUES IN (39) ENGINE = InnoDB,
 PARTITION p4 VALUES IN (50) ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `score_array_vw`
--

DROP TABLE IF EXISTS `score_array_vw`;
/*!50001 DROP VIEW IF EXISTS `score_array_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `score_array_vw` (
  `id` int(10) unsigned,
  `session_id` int(10) unsigned,
  `phase_id` int(10) unsigned,
  `experiment_id` int(10) unsigned,
  `session` varchar(767),
  `phase` varchar(255),
  `experiment` varchar(255),
  `cv_term` varchar(255),
  `term` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` mediumtext,
  `run` int(10) unsigned,
  `data_type` varchar(255),
  `row_count` int(10) unsigned,
  `column_count` int(10) unsigned,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `score_vw`
--

DROP TABLE IF EXISTS `score_vw`;
/*!50001 DROP VIEW IF EXISTS `score_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `score_vw` (
  `id` int(10) unsigned,
  `session_id` int(10) unsigned,
  `session` varchar(767),
  `cv_term` varchar(255),
  `term` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` double,
  `run` int(10) unsigned,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `secondary_image`
--

DROP TABLE IF EXISTS `secondary_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secondary_image` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `image_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `path` varchar(1000) NOT NULL,
  `url` varchar(1000) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `secondary_image_name_uk_ind` (`name`,`image_id`) USING BTREE,
  KEY `secondary_image_id_fk_ind` (`image_id`) USING BTREE,
  KEY `secondary_image_product_id_fk_ind` (`product_id`) USING BTREE,
  CONSTRAINT `secondary_image_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `secondary_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6009094 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `secondary_image_vw`
--

DROP TABLE IF EXISTS `secondary_image_vw`;
/*!50001 DROP VIEW IF EXISTS `secondary_image_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `secondary_image_vw` (
  `id` int(10) unsigned,
  `name` varchar(767),
  `image_id` int(10) unsigned,
  `product` varchar(255),
  `path` varchar(1000),
  `url` varchar(1000),
  `create_date` timestamp,
  `parent` varchar(767)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `line_id` int(10) unsigned NOT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `phase_id` int(10) unsigned DEFAULT NULL,
  `annotator` varchar(255) NOT NULL DEFAULT '',
  `lab_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_type_uk_ind` (`name`,`type_id`,`line_id`,`lab_id`,`experiment_id`) USING BTREE,
  KEY `session_line_id_fk_ind` (`line_id`) USING BTREE,
  KEY `session_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `session_lab_id_fk_ind` (`lab_id`) USING BTREE,
  KEY `session_experiment_id_fk_ind` (`experiment_id`) USING BTREE,
  KEY `session_phase_id_fk_ind` (`phase_id`) USING BTREE,
  CONSTRAINT `session_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `session_lab_id_fk` FOREIGN KEY (`lab_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `session_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `session_phase_id_fk` FOREIGN KEY (`phase_id`) REFERENCES `phase` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `session_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1768126 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `session_property`
--

DROP TABLE IF EXISTS `session_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_property_type_uk_ind` (`type_id`,`session_id`) USING BTREE,
  KEY `session_property_session_id_fk_ind` (`session_id`) USING BTREE,
  KEY `session_property_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `session_property_value_ind` (`value`(100)) USING BTREE,
  CONSTRAINT `session_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `session_property_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1725539 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `session_property_vw`
--

DROP TABLE IF EXISTS `session_property_vw`;
/*!50001 DROP VIEW IF EXISTS `session_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `session_property_vw` (
  `id` int(10) unsigned,
  `session_id` int(10) unsigned,
  `name` varchar(767),
  `lab` varchar(255),
  `cv` varchar(255),
  `type` varchar(255),
  `value` text,
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `session_relationship`
--

DROP TABLE IF EXISTS `session_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_relationship_uk_ind` (`type_id`,`subject_id`,`object_id`) USING BTREE,
  KEY `session_relationship_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `session_relationship_subject_id_fk_ind` (`subject_id`) USING BTREE,
  KEY `session_relationship_object_id_fk_ind` (`object_id`) USING BTREE,
  CONSTRAINT `session_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `session_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `session_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=297787 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `session_relationship_vw`
--

DROP TABLE IF EXISTS `session_relationship_vw`;
/*!50001 DROP VIEW IF EXISTS `session_relationship_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `session_relationship_vw` (
  `context_id` int(10) unsigned,
  `context` varchar(255),
  `subject_id` int(10) unsigned,
  `subject` varchar(767),
  `relationship_id` int(10) unsigned,
  `relationship` varchar(255),
  `object_id` int(10) unsigned,
  `object` varchar(767)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `session_vw`
--

DROP TABLE IF EXISTS `session_vw`;
/*!50001 DROP VIEW IF EXISTS `session_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `session_vw` (
  `id` int(10) unsigned,
  `name` varchar(767),
  `cv` varchar(255),
  `type` varchar(255),
  `line_id` int(10) unsigned,
  `line` varchar(767),
  `experiment_id` int(10) unsigned,
  `phase_id` int(10) unsigned,
  `annotator` varchar(255),
  `lab` varchar(255),
  `create_date` timestamp
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `simpson_gal4_mv`
--

DROP TABLE IF EXISTS `simpson_gal4_mv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `simpson_gal4_mv` (
  `line` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL,
  `gene` varchar(767) CHARACTER SET latin1 COLLATE latin1_general_cs,
  `synonyms` varchar(255) DEFAULT NULL,
  `cytology` longtext,
  `comments` longtext,
  `brain` varchar(1000) NOT NULL,
  `thorax` varchar(1000) NOT NULL,
  `term` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs,
  `expressed` text,
  `expressed_regions` varchar(255) DEFAULT NULL,
  KEY `simpson_gal4_mv_line_ind` (`line`) USING BTREE,
  KEY `simpson_gal4_mv_gene_ind` (`gene`) USING BTREE,
  KEY `simpson_gal4_mv_term_ind` (`term`) USING BTREE,
  KEY `simpson_gal4_mv_expressed_ind` (`expressed`(1)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `simpson_gal4_vw`
--

DROP TABLE IF EXISTS `simpson_gal4_vw`;
/*!50001 DROP VIEW IF EXISTS `simpson_gal4_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `simpson_gal4_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` varchar(255),
  `cytology` longtext,
  `comments` longtext,
  `brain` varchar(1000),
  `thorax` varchar(1000),
  `term` varchar(255),
  `expressed` text,
  `expressed_regions` varchar(255)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `simpson_image_class_vw`
--

DROP TABLE IF EXISTS `simpson_image_class_vw`;
/*!50001 DROP VIEW IF EXISTS `simpson_image_class_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `simpson_image_class_vw` (
  `line` varchar(767),
  `product` longtext,
  `class` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `simpson_image_property_vw`
--

DROP TABLE IF EXISTS `simpson_image_property_vw`;
/*!50001 DROP VIEW IF EXISTS `simpson_image_property_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `simpson_image_property_vw` (
  `image_id` int(10) unsigned,
  `organ` longtext,
  `specimen` longtext,
  `bits_per_sample` longtext,
  `product` longtext,
  `class` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `simpson_image_vw`
--

DROP TABLE IF EXISTS `simpson_image_vw`;
/*!50001 DROP VIEW IF EXISTS `simpson_image_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `simpson_image_vw` (
  `name` varchar(767),
  `family` varchar(255),
  `capture_date` timestamp,
  `representative` tinyint(3) unsigned,
  `created_by` varchar(1000),
  `line` varchar(767),
  `organ` longtext,
  `specimen` longtext,
  `bits_per_sample` longtext,
  `display` tinyint(1)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `simpson_pe_vw`
--

DROP TABLE IF EXISTS `simpson_pe_vw`;
/*!50001 DROP VIEW IF EXISTS `simpson_pe_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `simpson_pe_vw` (
  `line` varchar(767),
  `gene` varchar(767),
  `synonyms` char(255),
  `name` varchar(767),
  `notes` longtext,
  `temp_type` longtext
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `simpson_rep_image_vw`
--

DROP TABLE IF EXISTS `simpson_rep_image_vw`;
/*!50001 DROP VIEW IF EXISTS `simpson_rep_image_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `simpson_rep_image_vw` (
  `line_id` int(10) unsigned,
  `brain_id` bigint(20),
  `thorax_id` bigint(20)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tmp_adjacency_list`
--

DROP TABLE IF EXISTS `tmp_adjacency_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_adjacency_list` (
  `pk` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(10) unsigned DEFAULT NULL,
  `name` char(255) DEFAULT NULL,
  `path` text,
  `level` int(10) unsigned DEFAULT NULL,
  `position` int(10) unsigned DEFAULT NULL,
  `connection` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`pk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `cross_event_vw`
--

/*!50001 DROP TABLE IF EXISTS `cross_event_vw`*/;
/*!50001 DROP VIEW IF EXISTS `cross_event_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cross_event_vw` AS select `e`.`id` AS `id`,`cv_term`.`name` AS `process`,`le`.`id` AS `line_event_id`,`l`.`id` AS `line_id`,`l`.`name` AS `line`,`e`.`action` AS `action`,`e`.`operator` AS `operator`,`project`.`value` AS `project`,`lab`.`value` AS `project_lab`,`crossed`.`value` AS `cross_type`,`effector`.`value` AS `effector`,`e`.`event_date` AS `event_date` from (((((((((((`event` `e` join `cv_term` on(((`e`.`process_id` = `cv_term`.`id`) and (`cv_term`.`name` = 'cross')))) join `line_event` `le` on((`e`.`id` = `le`.`event_id`))) join `line` `l` on((`l`.`id` = `le`.`line_id`))) join `event_property` `project` on((`project`.`event_id` = `e`.`id`))) join `cv_term` `project_term` on(((`project`.`type_id` = `project_term`.`id`) and (`project_term`.`name` = 'project')))) join `event_property` `lab` on((`lab`.`event_id` = `e`.`id`))) join `cv_term` `lab_term` on(((`lab`.`type_id` = `lab_term`.`id`) and (`lab_term`.`name` = 'project_lab')))) join `event_property` `crossed` on((`crossed`.`event_id` = `e`.`id`))) join `cv_term` `crossed_term` on(((`crossed`.`type_id` = `crossed_term`.`id`) and (`crossed_term`.`name` = 'cross_type')))) join `line_event_property` `effector` on((`le`.`id` = `effector`.`line_event_id`))) join `cv_term` `effector_term` on(((`effector`.`type_id` = `effector_term`.`id`) and (`effector_term`.`name` = 'effector')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `cv_relationship_vw`
--

/*!50001 DROP TABLE IF EXISTS `cv_relationship_vw`*/;
/*!50001 DROP VIEW IF EXISTS `cv_relationship_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cv_relationship_vw` AS select `cv`.`id` AS `context_id`,`cv`.`name` AS `context`,`cv1`.`id` AS `subject_id`,`cv1`.`name` AS `subject`,`cvt`.`id` AS `relationship_id`,`cvt`.`name` AS `relationship`,`cv2`.`id` AS `object_id`,`cv2`.`name` AS `object` from ((((`cv` join `cv_relationship` `cr`) join `cv_term` `cvt`) join `cv` `cv1`) join `cv` `cv2`) where ((`cr`.`type_id` = `cvt`.`id`) and (`cr`.`subject_id` = `cv1`.`id`) and (`cr`.`object_id` = `cv2`.`id`) and (`cr`.`is_current` = 1) and (`cvt`.`is_current` = 1) and (`cv1`.`is_current` = 1) and (`cv2`.`is_current` = 1) and (`cv`.`id` = `cvt`.`cv_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `cv_term_relationship_vw`
--

/*!50001 DROP TABLE IF EXISTS `cv_term_relationship_vw`*/;
/*!50001 DROP VIEW IF EXISTS `cv_term_relationship_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cv_term_relationship_vw` AS select `cv_subject`.`id` AS `subject_context_id`,`cv_subject`.`name` AS `subject_context`,`cvt_subject`.`id` AS `subject_id`,`cvt_subject`.`name` AS `subject`,`cv_rel`.`id` AS `relationship_context_id`,`cv_rel`.`name` AS `relationship_context`,`cvt_rel`.`id` AS `relationship_id`,`cvt_rel`.`name` AS `relationship`,`cv_object`.`id` AS `object_context_id`,`cv_object`.`name` AS `object_context`,`cvt_object`.`id` AS `object_id`,`cvt_object`.`name` AS `object` from ((((((`cv_term_relationship` `cr` join `cv_term` `cvt_rel`) join `cv` `cv_rel`) join `cv_term` `cvt_subject`) join `cv` `cv_subject`) join `cv_term` `cvt_object`) join `cv` `cv_object`) where ((`cr`.`type_id` = `cvt_rel`.`id`) and (`cv_rel`.`id` = `cvt_rel`.`cv_id`) and (`cr`.`subject_id` = `cvt_subject`.`id`) and (`cv_subject`.`id` = `cvt_subject`.`cv_id`) and (`cr`.`object_id` = `cvt_object`.`id`) and (`cv_object`.`id` = `cvt_object`.`cv_id`) and (`cr`.`is_current` = 1) and (`cvt_rel`.`is_current` = 1) and (`cvt_subject`.`is_current` = 1) and (`cvt_object`.`is_current` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `cv_term_to_table_mapping_vw`
--

/*!50001 DROP TABLE IF EXISTS `cv_term_to_table_mapping_vw`*/;
/*!50001 DROP VIEW IF EXISTS `cv_term_to_table_mapping_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cv_term_to_table_mapping_vw` AS select `cv_subject`.`name` AS `cv`,`subject`.`id` AS `cv_term_id`,`subject`.`name` AS `cv_term`,`type`.`name` AS `relationship`,`object`.`name` AS `schema_term` from (((((`cv_term_relationship` join `cv_term` `type` on((`type`.`id` = `cv_term_relationship`.`type_id`))) join `cv` `cv_type` on((`cv_type`.`id` = `type`.`cv_id`))) join `cv_term` `subject` on((`subject`.`id` = `cv_term_relationship`.`subject_id`))) join `cv` `cv_subject` on((`cv_subject`.`id` = `subject`.`cv_id`))) join `cv_term` `object` on((`object`.`id` = `cv_term_relationship`.`object_id`))) where (`cv_type`.`name` = 'schema') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `cv_term_validation_vw`
--

/*!50001 DROP TABLE IF EXISTS `cv_term_validation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `cv_term_validation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cv_term_validation_vw` AS select `cv_subject`.`name` AS `term_context`,`subject`.`id` AS `term_id`,`subject`.`name` AS `term`,`type`.`name` AS `relationship`,`object`.`name` AS `rule` from (((((`cv_term_relationship` join `cv_term` `type` on((`type`.`id` = `cv_term_relationship`.`type_id`))) join `cv_term` `subject` on((`subject`.`id` = `cv_term_relationship`.`subject_id`))) join `cv` `cv_subject` on((`cv_subject`.`id` = `subject`.`cv_id`))) join `cv_term` `object` on((`object`.`id` = `cv_term_relationship`.`object_id`))) join `cv` `cv_type` on((`cv_type`.`id` = `type`.`cv_id`))) where (`type`.`name` = 'validated_by') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `cv_term_vw`
--

/*!50001 DROP TABLE IF EXISTS `cv_term_vw`*/;
/*!50001 DROP VIEW IF EXISTS `cv_term_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `cv_term_vw` AS select `cv`.`name` AS `cv`,`cvt`.`id` AS `id`,`cvt`.`name` AS `cv_term`,`cvt`.`definition` AS `definition`,`cvt`.`display_name` AS `display_name`,`cvt`.`data_type` AS `data_type`,`cvt`.`is_current` AS `is_current`,`cvt`.`create_date` AS `create_date` from (`cv` join `cv_term` `cvt`) where (`cv`.`id` = `cvt`.`cv_id`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `data_set_family_vw`
--

/*!50001 DROP TABLE IF EXISTS `data_set_family_vw`*/;
/*!50001 DROP VIEW IF EXISTS `data_set_family_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `data_set_family_vw` AS select `d`.`id` AS `id`,`d`.`name` AS `name`,`d`.`display_name` AS `display_name`,`lab`.`name` AS `lab`,`lab`.`display_name` AS `lab_display_name`,`d`.`description` AS `description` from ((`data_set_family` `d` join `cv_term` `lab` on((`d`.`lab_id` = `lab`.`id`))) join `cv` `lab_cv` on(((`lab`.`cv_id` = `lab_cv`.`id`) and (`lab_cv`.`name` = 'lab')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `data_set_field_value_vw`
--

/*!50001 DROP TABLE IF EXISTS `data_set_field_value_vw`*/;
/*!50001 DROP VIEW IF EXISTS `data_set_field_value_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `data_set_field_value_vw` AS select `df`.`id` AS `id`,`df`.`name` AS `name`,`df`.`display_name` AS `display_name`,`d`.`id` AS `data_set_id`,`d`.`name` AS `data_set`,`f`.`name` AS `family`,`f`.`lab` AS `lab`,`dv`.`value` AS `value` from (((`data_set_field_value` `dv` join `data_set_field` `df` on((`df`.`id` = `dv`.`data_set_field_id`))) join `data_set` `d` on((`d`.`id` = `df`.`data_set_id`))) join `data_set_family_vw` `f` on((`d`.`family_id` = `f`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `data_set_field_vw`
--

/*!50001 DROP TABLE IF EXISTS `data_set_field_vw`*/;
/*!50001 DROP VIEW IF EXISTS `data_set_field_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `data_set_field_vw` AS select `df`.`id` AS `id`,`df`.`name` AS `name`,`df`.`display_name` AS `display_name`,`d`.`id` AS `data_set_id`,`d`.`name` AS `data_set`,`f`.`name` AS `family`,`f`.`lab` AS `lab`,`df`.`value` AS `value` from ((`data_set_field` `df` join `data_set` `d` on((`d`.`id` = `df`.`data_set_id`))) join `data_set_family_vw` `f` on((`d`.`family_id` = `f`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `data_set_vw`
--

/*!50001 DROP TABLE IF EXISTS `data_set_vw`*/;
/*!50001 DROP VIEW IF EXISTS `data_set_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `data_set_vw` AS select `d`.`id` AS `id`,`d`.`name` AS `name`,`d`.`display_name` AS `display_name`,`f`.`name` AS `family`,`f`.`lab` AS `lab`,`schema_term`.`name` AS `view_name`,`schema_term2`.`name` AS `view_name2`,`d`.`description` AS `description` from (((((`data_set` `d` join `data_set_family_vw` `f` on((`d`.`family_id` = `f`.`id`))) join `cv_term` `schema_term` on((`d`.`view_id` = `schema_term`.`id`))) join `cv` `schema_cv` on(((`schema_term`.`cv_id` = `schema_cv`.`id`) and (`schema_cv`.`name` = 'schema')))) left join `cv_term` `schema_term2` on((`d`.`view_id2` = `schema_term2`.`id`))) left join `cv` `schema_cv2` on(((`schema_term2`.`cv_id` = `schema_cv2`.`id`) and (`schema_cv`.`name` = 'schema')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `event_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `event_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `event_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `event_property_vw` AS select `ep`.`id` AS `id`,`ep`.`event_id` AS `event_id`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`ep`.`value` AS `value`,`ep`.`create_date` AS `create_date` from ((`event_property` `ep` join `cv_term` on((`ep`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `event_vw`
--

/*!50001 DROP TABLE IF EXISTS `event_vw`*/;
/*!50001 DROP VIEW IF EXISTS `event_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `event_vw` AS select `e`.`id` AS `id`,`cv_term`.`name` AS `process`,`le`.`id` AS `line_event_id`,`l`.`id` AS `line_id`,`l`.`name` AS `line`,`e`.`action` AS `action`,`e`.`operator` AS `operator`,`e`.`create_date` AS `create_date` from (((`event` `e` join `cv_term` on((`e`.`process_id` = `cv_term`.`id`))) join `line_event` `le` on((`e`.`id` = `le`.`event_id`))) join `line` `l` on((`l`.`id` = `le`.`line_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `experiment_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `experiment_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `experiment_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `experiment_property_vw` AS select `ep`.`id` AS `id`,`ep`.`experiment_id` AS `experiment_id`,`e`.`name` AS `name`,`cvt1`.`name` AS `lab`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`ep`.`value` AS `value`,`ep`.`create_date` AS `create_date` from (((((`experiment_property` `ep` join `experiment` `e` on((`ep`.`experiment_id` = `e`.`id`))) join `cv_term` `cvt1` on((`e`.`lab_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `cv_term` on((`ep`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `experiment_relationship_vw`
--

/*!50001 DROP TABLE IF EXISTS `experiment_relationship_vw`*/;
/*!50001 DROP VIEW IF EXISTS `experiment_relationship_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `experiment_relationship_vw` AS select `cv`.`id` AS `context_id`,`cv`.`name` AS `context`,`e1`.`id` AS `subject_id`,`e1`.`name` AS `subject`,`cvt`.`id` AS `relationship_id`,`cvt`.`name` AS `relationship`,`e2`.`id` AS `object_id`,`e2`.`name` AS `object` from ((((`cv` join `experiment_relationship` `er`) join `cv_term` `cvt`) join `experiment` `e1`) join `experiment` `e2`) where ((`er`.`type_id` = `cvt`.`id`) and (`er`.`subject_id` = `e1`.`id`) and (`er`.`object_id` = `e2`.`id`) and (`cvt`.`is_current` = 1) and (`cv`.`id` = `cvt`.`cv_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `experiment_vw`
--

/*!50001 DROP TABLE IF EXISTS `experiment_vw`*/;
/*!50001 DROP VIEW IF EXISTS `experiment_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `experiment_vw` AS select `e`.`id` AS `id`,`e`.`name` AS `name`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`e`.`experimenter` AS `experimenter`,`cvt1`.`name` AS `lab`,`e`.`create_date` AS `create_date` from ((((`experiment` `e` join `cv_term` `cvt1` on((`e`.`lab_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `cv_term` on((`e`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `grooming_observation_vw`
--

/*!50001 DROP TABLE IF EXISTS `grooming_observation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `grooming_observation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `grooming_observation_vw` AS select `line`.`name` AS `name`,max(if(strcmp(`cv_term`.`name`,'behavioral'),NULL,if(strcmp(`cv_term2`.`name`,'courtship'),NULL,`observation`.`value`))) AS `behavioral_courtship`,max(if(strcmp(`cv_term`.`name`,'behavioral'),NULL,if(strcmp(`cv_term2`.`name`,'hyper'),NULL,`observation`.`value`))) AS `behavioral_hyper`,max(if(strcmp(`cv_term`.`name`,'behavioral'),NULL,if(strcmp(`cv_term2`.`name`,'intersegmental'),NULL,`observation`.`value`))) AS `behavioral_intersegmental`,max(if(strcmp(`cv_term`.`name`,'behavioral'),NULL,if(strcmp(`cv_term2`.`name`,'paralyzed'),NULL,`observation`.`value`))) AS `behavioral_paralyzed`,max(if(strcmp(`cv_term`.`name`,'behavioral'),NULL,if(strcmp(`cv_term2`.`name`,'uncoordinated'),NULL,`observation`.`value`))) AS `behavioral_uncoordinated`,max(if(strcmp(`cv_term`.`name`,'cross'),NULL,if(strcmp(`cv_term2`.`name`,'lethal'),NULL,`observation`.`value`))) AS `cross_lethal`,max(if(strcmp(`cv_term`.`name`,'overgrooming'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `overgrooming_defect`,max(if(strcmp(`cv_term`.`name`,'head_selective'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `head_selective_defect`,max(if(strcmp(`cv_term`.`name`,'leg_rub'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `leg_rub_defect`,max(if(strcmp(`cv_term`.`name`,'permissive'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `permissive_defect`,max(if(strcmp(`cv_term`.`name`,'restrictive'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `restrictive_defect`,max(if(strcmp(`cv_term`.`name`,'restrictive'),NULL,if(strcmp(`cv_term2`.`name`,'screened'),NULL,`observation`.`value`))) AS `restrictive_screened`,max(if(strcmp(`cv_term`.`name`,'stock_control'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `stock_control_defect`,max(if(strcmp(`cv_term`.`name`,'stock'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `stock_defect`,max(if(strcmp(`cv_term`.`name`,'tnt'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `tnt_defect`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'screened'),NULL,`observation`.`value`))) AS `trpa_screened`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'defect'),NULL,`observation`.`value`))) AS `trpa_defect`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'reversal'),NULL,`observation`.`value`))) AS `trpa_reversal`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'proboscisextension'),NULL,`observation`.`value`))) AS `trpa_proboscisextension`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'feedingbehavior'),NULL,`observation`.`value`))) AS `trpa_feedingbehavior`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'increasedgrooming'),NULL,`observation`.`value`))) AS `trpa_increasedgrooming`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'headgrooming'),NULL,`observation`.`value`))) AS `trpa_headgrooming`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'wingcleaning'),NULL,`observation`.`value`))) AS `trpa_wingcleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'legrubbing'),NULL,`observation`.`value`))) AS `trpa_legrubbing`,max(if(strcmp(`cv_term`.`name`,'expression'),NULL,if(strcmp(`cv_term2`.`name`,'bristle'),NULL,`observation`.`value`))) AS `expression_bristle`,max(if(strcmp(`cv_term`.`name`,'expression'),NULL,if(strcmp(`cv_term2`.`name`,'chordotonal'),NULL,`observation`.`value`))) AS `expression_chordotonal`,max(if(strcmp(`cv_term3`.`name`,'interesting'),NULL,`session_property`.`value`)) AS `interesting`,max(if(strcmp(`cv_term3`.`name`,'expression_imaged'),NULL,`session_property`.`value`)) AS `expression_imaged`,max(if(strcmp(`cv_term3`.`name`,'experimental_imaged'),NULL,`session_property`.`value`)) AS `experimental_imaged`,max(if(strcmp(`cv_term3`.`name`,'evidence_imaged'),NULL,`session_property`.`value`)) AS `evidence_imaged`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'probosciscleaning'),NULL,`observation`.`value`))) AS `trpa_probosciscleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'abdominalcleaning'),NULL,`observation`.`value`))) AS `trpa_abdominalcleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'genitalcleaning'),NULL,`observation`.`value`))) AS `trpa_genitalcleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'halterecleaning'),NULL,`observation`.`value`))) AS `trpa_halterecleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'ventralthoraxcleaning'),NULL,`observation`.`value`))) AS `trpa_ventralthoraxcleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'antennalcleaning'),NULL,`observation`.`value`))) AS `trpa_antennalcleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'notumcleaning'),NULL,`observation`.`value`))) AS `trpa_notumcleaning`,max(if(strcmp(`cv_term`.`name`,'expression'),NULL,if(strcmp(`cv_term2`.`name`,'eyebristle'),NULL,`observation`.`value`))) AS `expression_eyebristle`,max(if(strcmp(`cv_term`.`name`,'chr2'),NULL,if(strcmp(`cv_term2`.`name`,'stimulated'),NULL,`observation`.`value`))) AS `chr2_stimulated`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'courtship'),NULL,`observation`.`value`))) AS `trpa_courtship`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'posteriorcleaning'),NULL,`observation`.`value`))) AS `trpa_posteriorcleaning`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'decap_screened'),NULL,`observation`.`value`))) AS `trpa_decap_screened`,max(if(strcmp(`cv_term`.`name`,'trpa'),NULL,if(strcmp(`cv_term2`.`name`,'decap_phenotype'),NULL,`observation`.`value`))) AS `trpa_decap_phenotype`,max(if(strcmp(`cv_term`.`name`,'expression'),NULL,if(strcmp(`cv_term2`.`name`,'connected'),NULL,`observation`.`value`))) AS `expression_connected` from (((((((((`line` join `session` on((`line`.`id` = `session`.`line_id`))) join `cv_term` on((`session`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` = 'grooming')))) left join `session_property` on((`session`.`id` = `session_property`.`session_id`))) left join `cv_term` `cv_term3` on((`session_property`.`type_id` = `cv_term3`.`id`))) left join `cv` `cv3` on(((`cv_term3`.`cv_id` = `cv3`.`id`) and (`cv3`.`name` = 'grooming')))) left join `observation` on((`session`.`id` = `observation`.`session_id`))) left join `cv_term` `cv_term2` on((`observation`.`type_id` = `cv_term2`.`id`))) left join `cv` `cv2` on(((`cv_term2`.`cv_id` = `cv2`.`id`) and (`cv2`.`name` = 'grooming')))) group by `line`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `grooming_score_vw`
--

/*!50001 DROP TABLE IF EXISTS `grooming_score_vw`*/;
/*!50001 DROP VIEW IF EXISTS `grooming_score_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `grooming_score_vw` AS select `score`.`session_id` AS `session_id`,`score`.`run` AS `run`,max(if(strcmp(`cv_term`.`name`,'eye_score'),NULL,`score`.`value`)) AS `eye_score`,max(if(strcmp(`cv_term`.`name`,'head_score'),NULL,`score`.`value`)) AS `head_score`,max(if(strcmp(`cv_term`.`name`,'wing_score'),NULL,`score`.`value`)) AS `wing_score`,max(if(strcmp(`cv_term`.`name`,'notum_score'),NULL,`score`.`value`)) AS `notum_score` from (`score` join `cv_term` on((`score`.`type_id` = `cv_term`.`id`))) group by `score`.`session_id`,`score`.`run` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `image_data_vw`
--

/*!50001 DROP TABLE IF EXISTS `image_data_vw`*/;
/*!50001 DROP VIEW IF EXISTS `image_data_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `image_data_vw` AS select `gene_data_mv`.`gene` AS `gene`,`image_data_mv`.`id` AS `id`,`image_data_mv`.`line` AS `line`,`image_data_mv`.`name` AS `name`,`image_data_mv`.`family` AS `family`,`image_data_mv`.`capture_date` AS `capture_date`,`image_data_mv`.`representative` AS `representative`,`image_data_mv`.`display` AS `display`,`image_data_mv`.`age` AS `age`,`image_data_mv`.`area` AS `area`,`image_data_mv`.`bc_correction1` AS `bc_correction1`,`image_data_mv`.`bc_correction2` AS `bc_correction2`,`image_data_mv`.`bits_per_sample` AS `bits_per_sample`,`image_data_mv`.`channels` AS `channels`,`image_data_mv`.`chron_hour` AS `chron_hour`,`image_data_mv`.`chron_interval` AS `chron_interval`,`image_data_mv`.`chron_stage` AS `chron_stage`,`image_data_mv`.`class` AS `class`,`image_data_mv`.`dimension_x` AS `dimension_x`,`image_data_mv`.`dimension_y` AS `dimension_y`,`image_data_mv`.`dimension_z` AS `dimension_z`,`image_data_mv`.`file_size` AS `file_size`,`image_data_mv`.`gender` AS `gender`,`image_data_mv`.`genotype` AS `genotype`,`image_data_mv`.`heat_shock_hour` AS `heat_shock_hour`,`image_data_mv`.`heat_shock_interval` AS `heat_shock_interval`,`image_data_mv`.`height` AS `height`,`image_data_mv`.`hostname` AS `hostname`,`image_data_mv`.`notes` AS `notes`,`image_data_mv`.`number_tracks` AS `number_tracks`,`image_data_mv`.`objective` AS `objective`,`image_data_mv`.`organ` AS `organ`,`image_data_mv`.`product` AS `product`,`image_data_mv`.`sample_0time` AS `sample_0time`,`image_data_mv`.`sample_0z` AS `sample_0z`,`image_data_mv`.`scan_type` AS `scan_type`,`image_data_mv`.`short_genotype` AS `short_genotype`,`image_data_mv`.`specimen` AS `specimen`,`image_data_mv`.`tissue` AS `tissue`,`image_data_mv`.`uas_reporter` AS `uas_reporter`,`image_data_mv`.`voxel_size_x` AS `voxel_size_x`,`image_data_mv`.`voxel_size_y` AS `voxel_size_y`,`image_data_mv`.`voxel_size_z` AS `voxel_size_z`,`image_data_mv`.`width` AS `width`,`image_data_mv`.`zoom_x` AS `zoom_x`,`image_data_mv`.`zoom_y` AS `zoom_y`,`image_data_mv`.`zoom_z` AS `zoom_z` from (((`image_data_mv` join `image` on((`image`.`id` = `image_data_mv`.`id`))) join `line` on((`image`.`line_id` = `line`.`id`))) left join `gene_data_mv` on((`line`.`gene_id` = `gene_data_mv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `image_gene_vw`
--

/*!50001 DROP TABLE IF EXISTS `image_gene_vw`*/;
/*!50001 DROP VIEW IF EXISTS `image_gene_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `image_gene_vw` AS select `image`.`id` AS `image_id`,`cv_term`.`name` AS `family`,`gene`.`gene` AS `gene` from (((`image` join `line` on((`image`.`line_id` = `line`.`id`))) join `gene_data_mv` `gene` on((`line`.`gene_id` = `gene`.`id`))) join `cv_term` on((`image`.`family_id` = `cv_term`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `image_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `image_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `image_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `image_property_vw` AS select `ip`.`id` AS `id`,`ip`.`image_id` AS `image_id`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`ip`.`value` AS `value` from ((`image_property` `ip` join `cv_term` on((`ip`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `image_vw`
--

/*!50001 DROP TABLE IF EXISTS `image_vw`*/;
/*!50001 DROP VIEW IF EXISTS `image_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `image_vw` AS select `i`.`id` AS `id`,`i`.`name` AS `name`,`i`.`url` AS `url`,`i`.`path` AS `path`,`cvt1`.`name` AS `source`,`cvt2`.`name` AS `family`,`l`.`name` AS `line`,`i`.`capture_date` AS `capture_date`,`i`.`representative` AS `representative`,`i`.`display` AS `display`,`i`.`created_by` AS `created_by`,`i`.`create_date` AS `create_date` from (((((`image` `i` join `cv_term` `cvt1` on((`i`.`source_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `cv_term` `cvt2` on((`i`.`family_id` = `cvt2`.`id`))) join `cv` `cv2` on((`cvt2`.`cv_id` = `cv2`.`id`))) join `line` `l` on((`i`.`line_id` = `l`.`id`))) where ((`cv1`.`name` = 'lab') and (`cv2`.`name` = 'family')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ipcr_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `ipcr_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `ipcr_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `ipcr_session_vw` AS select `session_property_vw`.`session_id` AS `id`,max(if(strcmp(`session_property_vw`.`type`,'alternative'),NULL,`session_property_vw`.`value`)) AS `alternative`,max(if(strcmp(`session_property_vw`.`type`,'balancer_status'),NULL,`session_property_vw`.`value`)) AS `balancer_status`,max(if(strcmp(`session_property_vw`.`type`,'comments'),NULL,`session_property_vw`.`value`)) AS `comments`,max(if(strcmp(`session_property_vw`.`type`,'confidence'),NULL,`session_property_vw`.`value`)) AS `confidence`,max(if(strcmp(`session_property_vw`.`type`,'cytology'),NULL,`session_property_vw`.`value`)) AS `cytology`,max(if(strcmp(`session_property_vw`.`type`,'insert_viability'),NULL,`session_property_vw`.`value`)) AS `insert_viability`,max(if(strcmp(`session_property_vw`.`type`,'mapped_date'),NULL,`session_property_vw`.`value`)) AS `mapped_date`,max(if(strcmp(`session_property_vw`.`type`,'mspi_trimmed'),NULL,`session_property_vw`.`value`)) AS `mspi_trimmed`,max(if(strcmp(`session_property_vw`.`type`,'pelement'),NULL,`session_property_vw`.`value`)) AS `pelement`,max(if(strcmp(`session_property_vw`.`type`,'sau3a_trimmed'),NULL,`session_property_vw`.`value`)) AS `sau3a_trimmed` from `session_property_vw` where (`session_property_vw`.`cv` = 'ipcr') group by `session_property_vw`.`session_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ipcr_vw`
--

/*!50001 DROP TABLE IF EXISTS `ipcr_vw`*/;
/*!50001 DROP VIEW IF EXISTS `ipcr_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `ipcr_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`lab` AS `lab`,`line_vw`.`gene` AS `gene`,`ipcr_session_vw`.`id` AS `id`,`ipcr_session_vw`.`alternative` AS `alternative`,`ipcr_session_vw`.`balancer_status` AS `balancer_status`,`ipcr_session_vw`.`comments` AS `comments`,`ipcr_session_vw`.`confidence` AS `confidence`,`ipcr_session_vw`.`cytology` AS `cytology`,`ipcr_session_vw`.`insert_viability` AS `insert_viability`,`ipcr_session_vw`.`mapped_date` AS `mapped_date`,`ipcr_session_vw`.`mspi_trimmed` AS `mspi_trimmed`,`ipcr_session_vw`.`pelement` AS `pelement`,`ipcr_session_vw`.`sau3a_trimmed` AS `sau3a_trimmed` from ((`line_vw` join `session` on((`line_vw`.`id` = `session`.`line_id`))) join `ipcr_session_vw` on((`ipcr_session_vw`.`id` = `session`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `lab_vw`
--

/*!50001 DROP TABLE IF EXISTS `lab_vw`*/;
/*!50001 DROP VIEW IF EXISTS `lab_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `lab_vw` AS select `cv_term`.`id` AS `id`,`cv_term`.`name` AS `lab`,`cv_term`.`display_name` AS `display_name` from (`cv_term` join `cv` on((`cv`.`id` = `cv_term`.`cv_id`))) where (`cv`.`name` = 'lab') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_event_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_event_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_event_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_event_property_vw` AS select `lep`.`id` AS `id`,`le`.`event_id` AS `event_id`,`l`.`name` AS `line`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`lep`.`value` AS `value`,`lep`.`create_date` AS `create_date` from ((((`line_event_property` `lep` join `line_event` `le` on((`lep`.`line_event_id` = `le`.`id`))) join `line` `l` on((`le`.`line_id` = `l`.`id`))) join `cv_term` on((`lep`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_experiment_type_unique_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_experiment_type_unique_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_experiment_type_unique_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_experiment_type_unique_vw` AS select distinct `e`.`name` AS `experiment`,`l`.`name` AS `line`,`ec`.`name` AS `cv` from ((((`line` `l` join `session` `s` on((`s`.`line_id` = `l`.`id`))) join `experiment` `e` on((`s`.`experiment_id` = `e`.`id`))) join `cv_term` `et` on((`e`.`type_id` = `et`.`id`))) join `cv` `ec` on(((`et`.`cv_id` = `ec`.`id`) and (`ec`.`name` in ('fly_olympiad_trikinetics','fly_olympiad_box','fly_olympiad_gap','fly_olympiad_lethality','fly_olympiad_sterility','fly_olympiad_observation','grooming','ipcr','proboscis_extension'))))) union all select distinct `arena`.`name` AS `experiment`,`l`.`name` AS `line`,`ec`.`name` AS `cv` from ((((((`line` `l` join `session` `s` on((`s`.`line_id` = `l`.`id`))) join `experiment` `chamber` on((`s`.`experiment_id` = `chamber`.`id`))) join `experiment_relationship` `exp_rel` on((`chamber`.`id` = `exp_rel`.`subject_id`))) join `experiment` `arena` on((`arena`.`id` = `exp_rel`.`object_id`))) join `cv_term` `et` on((`arena`.`type_id` = `et`.`id`))) join `cv` `ec` on(((`et`.`cv_id` = `ec`.`id`) and (`ec`.`name` = 'fly_olympiad_aggression')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_experiment_type_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_experiment_type_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_experiment_type_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_experiment_type_vw` AS select `line_experiment_type_unique_vw`.`line` AS `line`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_aggression'),NULL,1)) AS `fly_olympiad_aggression`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_box'),NULL,1)) AS `fly_olympiad_box`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_gap'),NULL,1)) AS `fly_olympiad_gap`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_lethality'),NULL,1)) AS `fly_olympiad_lethality`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_observation'),NULL,1)) AS `fly_olympiad_observation`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_sterility'),NULL,1)) AS `fly_olympiad_sterility`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'fly_olympiad_trikinetics'),NULL,1)) AS `fly_olympiad_trikinetics`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'grooming'),NULL,1)) AS `grooming`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'ipcr'),NULL,1)) AS `ipcr`,count(if(strcmp(`line_experiment_type_unique_vw`.`cv`,'proboscis_extension'),NULL,1)) AS `proboscis_extension` from `line_experiment_type_unique_vw` group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_experiment_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_experiment_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_experiment_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_experiment_vw` AS select `e`.`id` AS `id`,`e`.`name` AS `name`,`l`.`name` AS `line`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`e`.`experimenter` AS `experimenter`,`cvt1`.`name` AS `lab`,`e`.`create_date` AS `create_date` from ((((((`experiment` `e` join `cv_term` `cvt1` on((`e`.`lab_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `cv_term` on((`e`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) join `session` `s` on((`s`.`experiment_id` = `e`.`id`))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_gene_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_gene_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_gene_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_gene_vw` AS select `line`.`id` AS `line_id`,`gene`.`name` AS `gene` from (`gene` join `line` on((`line`.`gene_id` = `gene`.`id`))) union select `line`.`id` AS `line_id`,(`gene_synonym`.`synonym` collate latin1_general_cs) AS `synonym` from ((`gene_synonym` join `gene` on((`gene_synonym`.`gene_id` = `gene`.`id`))) join `line` on((`line`.`gene_id` = `gene`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_property_vw` AS select `lp`.`id` AS `id`,`l`.`id` AS `line_id`,`l`.`name` AS `name`,`cvt1`.`name` AS `lab`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`lp`.`value` AS `value`,`lp`.`create_date` AS `create_date` from (((((`line_property` `lp` join `line` `l` on((`lp`.`line_id` = `l`.`id`))) join `cv_term` `cvt1` on((`l`.`lab_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `cv_term` on((`lp`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_session_type_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_session_type_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_session_type_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_session_type_vw` AS select `line_vw`.`name` AS `line`,count(if(strcmp(`session_vw`.`cv`,'fly_olympiad_aggression'),NULL,1)) AS `fly_olympiad_aggression`,count(if(strcmp(`session_vw`.`cv`,'fly_olympiad_box'),NULL,1)) AS `fly_olympiad_box`,count(if(strcmp(`session_vw`.`cv`,'fly_olympiad_gap'),NULL,1)) AS `fly_olympiad_gap`,count(if(strcmp(`session_vw`.`cv`,'fly_olympiad_lethality'),NULL,1)) AS `fly_olympiad_lethality`,count(if(strcmp(`session_vw`.`cv`,'fly_olympiad_sterility'),NULL,1)) AS `fly_olympiad_sterility`,count(if(strcmp(`session_vw`.`cv`,'grooming'),NULL,1)) AS `grooming`,count(if(strcmp(`session_vw`.`cv`,'ipcr'),NULL,1)) AS `ipcr`,count(if(strcmp(`session_vw`.`cv`,'proboscis_extension'),NULL,1)) AS `proboscis_extension` from (`line_vw` join `session_vw` on((`session_vw`.`line_id` = `line_vw`.`id`))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_summary_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_summary_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_summary_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_summary_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`line_vw`.`genotype` AS `genotype`,`line_vw`.`lab_display_name` AS `lab`,`getLineSummaryString`(`line_vw`.`name`) AS `sessions` from `line_vw` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `line_vw`
--

/*!50001 DROP TABLE IF EXISTS `line_vw`*/;
/*!50001 DROP VIEW IF EXISTS `line_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `line_vw` AS select `l`.`id` AS `id`,`l`.`name` AS `name`,`lab`.`name` AS `lab`,`lab`.`display_name` AS `lab_display_name`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,concat(`o`.`genus`,' ',`o`.`species`) AS `organism`,`lp`.`value` AS `genotype`,`l`.`create_date` AS `create_date` from (((((`line` `l` join `cv_term` `lab` on((`l`.`lab_id` = `lab`.`id`))) join `cv` `lab_cv` on(((`lab`.`cv_id` = `lab_cv`.`id`) and (`lab_cv`.`name` = 'lab')))) join `organism` `o` on((`l`.`organism_id` = `o`.`id`))) left join `line_property` `lp` on(((`lp`.`line_id` = `l`.`id`) and (`lp`.`type_id` = `getcvtermid`('fly','genotype',NULL))))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `observation_vw`
--

/*!50001 DROP TABLE IF EXISTS `observation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `observation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `observation_vw` AS select `observation`.`id` AS `id`,`observation`.`session_id` AS `session_id`,`cv2`.`name` AS `cv_term`,`cv_term2`.`name` AS `term`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`observation`.`value` AS `value`,`observation`.`create_date` AS `create_date` from ((((`observation` join `cv_term` on((`observation`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) join `cv_term` `cv_term2` on((`observation`.`term_id` = `cv_term2`.`id`))) join `cv` `cv2` on((`cv_term2`.`cv_id` = `cv2`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_analysis_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_analysis_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_analysis_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_analysis_session_property_vw` AS select `aggression_sv`.`session_id` AS `session_id` from `olympiad_aggression_session_vw` `aggression_sv` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_analysis_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_analysis_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_analysis_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_analysis_session_vw` AS select `s`.`id` AS `session_id`,`s`.`experiment_id` AS `experiment_id`,`ct`.`name` AS `score_array_type`,uncompress(`sa`.`value`) AS `value` from (((((`session` `s` join `cv_term` `s_type` on((`s_type`.`id` = `s`.`type_id`))) join `cv` `s_cv` on(((`s_cv`.`id` = `s_type`.`cv_id`) and (`s_cv`.`name` = 'fly_olympiad_aggression')))) join `experiment` `e` on((`s`.`experiment_id` = `e`.`id`))) join `score_array` `sa` on((`s`.`id` = `sa`.`session_id`))) join `cv_term` `ct` on((`ct`.`id` = `sa`.`type_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_arena_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_arena_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_arena_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_arena_vw` AS select `arena`.`id` AS `id`,`arena`.`name` AS `name`,`cvt_type`.`name` AS `type`,NULL AS `protocol`,`cvt_lab`.`name` AS `lab`,`exp_arena`.`value` AS `arena`,`exp_temp`.`value` AS `temperature`,`arena`.`experimenter` AS `experimenter`,`arena`.`create_date` AS `create_date` from ((((((((`experiment` `arena` join `cv_term` `cvt_lab` on((`arena`.`lab_id` = `cvt_lab`.`id`))) join `cv` `cv_lab` on(((`cvt_lab`.`cv_id` = `cv_lab`.`id`) and (`cv_lab`.`name` = 'lab')))) join `cv_term` `cvt_type` on((`arena`.`type_id` = `cvt_type`.`id`))) join `cv` `cv_type` on(((`cvt_type`.`cv_id` = `cv_type`.`id`) and (`cv_type`.`name` like 'fly_olympiad_aggression')))) join `experiment_property` `exp_arena` on((`exp_arena`.`experiment_id` = `arena`.`id`))) join `cv_term` `cvt_arena` on(((`cvt_arena`.`id` = `exp_arena`.`type_id`) and (`cvt_arena`.`name` = 'arena')))) join `experiment_property` `exp_temp` on((`exp_temp`.`experiment_id` = `arena`.`id`))) join `cv_term` `cvt_temp` on(((`cvt_temp`.`id` = `exp_temp`.`type_id`) and (`cvt_temp`.`name` = 'temperature')))) where exists(select `experiment_relationship`.`id` from `experiment_relationship` where (`arena`.`id` = `experiment_relationship`.`object_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_chamber_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_chamber_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_chamber_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_chamber_vw` AS select `chamber`.`id` AS `id`,`chamber`.`name` AS `name`,`cvt_type`.`name` AS `type`,NULL AS `protocol`,`cvt_lab`.`name` AS `lab`,`arena`.`name` AS `experiment_name`,`exp_arena`.`value` AS `arena`,`exp_temp`.`value` AS `temperature`,`chamber`.`experimenter` AS `experimenter`,`chamber`.`create_date` AS `create_date` from ((((((((((`experiment` `chamber` join `experiment_relationship` `exp_rel` on((`chamber`.`id` = `exp_rel`.`subject_id`))) join `experiment` `arena` on((`arena`.`id` = `exp_rel`.`object_id`))) join `cv_term` `cvt_lab` on((`chamber`.`lab_id` = `cvt_lab`.`id`))) join `cv` `cv_lab` on(((`cvt_lab`.`cv_id` = `cv_lab`.`id`) and (`cv_lab`.`name` = 'lab')))) join `cv_term` `cvt_type` on((`chamber`.`type_id` = `cvt_type`.`id`))) join `cv` `cv_type` on(((`cvt_type`.`cv_id` = `cv_type`.`id`) and (`cv_type`.`name` like 'fly_olympiad_aggression')))) join `experiment_property` `exp_arena` on((`exp_arena`.`experiment_id` = `arena`.`id`))) join `cv_term` `cvt_arena` on(((`cvt_arena`.`id` = `exp_arena`.`type_id`) and (`cvt_arena`.`name` = 'arena')))) join `experiment_property` `exp_temp` on((`exp_temp`.`experiment_id` = `arena`.`id`))) join `cv_term` `cvt_temp` on(((`cvt_temp`.`id` = `exp_temp`.`type_id`) and (`cvt_temp`.`name` = 'temperature')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_feature_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_feature_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_feature_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_feature_vw` AS select `e`.`arena_experiment_name` AS `arena_experiment_name`,`e`.`arena_experiment_id` AS `arena_experiment_id`,`e`.`experimenter` AS `experimenter`,`e`.`chamber_experiment_name` AS `chamber_experiment_name`,`e`.`chamber_experiment_id` AS `chamber_experiment_id`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`experiment_day_of_week` AS `experiment_day_of_week`,`e`.`file_system_path` AS `file_system_path`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`temperature` AS `temperature`,`e`.`humidity` AS `humidity`,`e`.`camera` AS `camera`,`e`.`arena` AS `arena`,`e`.`num_chambers` AS `num_chambers`,`e`.`border_width` AS `border_width`,`e`.`correct_orientation` AS `correct_orientation`,`e`.`correct_positions` AS `correct_positions`,`e`.`courtship_present` AS `courtship_present`,`e`.`frame_rate` AS `frame_rate`,`e`.`mult_flies_present` AS `mult_flies_present`,`e`.`number_denoised_frames` AS `number_denoised_frames`,`e`.`num_unprocessed_movies` AS `num_unprocessed_movies`,`e`.`process_stopped` AS `process_stopped`,`e`.`radius` AS `radius`,`e`.`radius_plus_border` AS `radius_plus_border`,`e`.`scale_calibration_file` AS `scale_calibration_file`,`e`.`tuning_threshold` AS `tuning_threshold`,`s`.`session_id` AS `session_id`,`s`.`behavior` AS `behavior`,`s`.`session_name` AS `session_name`,`getCvTermName`(`sa`.`term_id`) AS `fly`,`s`.`line_name` AS `line_name`,`s`.`line_id` AS `line_id`,`s`.`line_lab` AS `line_lab`,`s`.`effector` AS `effector`,`s`.`rearing_temperature` AS `rearing_temperature`,`s`.`chamber` AS `chamber`,`s`.`genotype` AS `genotype`,`s`.`marking` AS `marking`,`s`.`housing` AS `housing`,`e`.`notes_loading` AS `notes_loading`,`getCvTermName`(`sa`.`type_id`) AS `data_type`,uncompress(`sa`.`value`) AS `data`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format` from ((`olympiad_aggression_experiment_data_mv` `e` join `olympiad_aggression_session_feature_data_mv` `s` on((`e`.`chamber_experiment_id` = `s`.`chamber_experiment_id`))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_aggression',NULL)) and (`sa`.`session_id` = `s`.`session_id`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_feature_vw2`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_feature_vw2`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_feature_vw2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_feature_vw2` AS select `e`.`arena_experiment_name` AS `arena_experiment_name`,`e`.`arena_experiment_id` AS `arena_experiment_id`,`e`.`experimenter` AS `experimenter`,`e`.`chamber_experiment_name` AS `chamber_experiment_name`,`e`.`chamber_experiment_id` AS `chamber_experiment_id`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`file_system_path` AS `file_system_path`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`temperature` AS `temperature`,`e`.`humidity` AS `humidity`,`e`.`camera` AS `camera`,`e`.`arena` AS `arena`,`e`.`num_chambers` AS `num_chambers`,`e`.`border_width` AS `border_width`,`e`.`correct_orientation` AS `correct_orientation`,`e`.`correct_positions` AS `correct_positions`,`e`.`courtship_present` AS `courtship_present`,`e`.`frame_rate` AS `frame_rate`,`e`.`mult_flies_present` AS `mult_flies_present`,`e`.`number_denoised_frames` AS `number_denoised_frames`,`e`.`num_unprocessed_movies` AS `num_unprocessed_movies`,`e`.`process_stopped` AS `process_stopped`,`e`.`radius` AS `radius`,`e`.`radius_plus_border` AS `radius_plus_border`,`e`.`scale_calibration_file` AS `scale_calibration_file`,`e`.`tuning_threshold` AS `tuning_threshold`,`s2`.`session_id` AS `session_id`,`s2`.`behavior` AS `behavior`,`s2`.`session_name` AS `session_name`,`getCvTermName`(`score`.`term_id`) AS `fly`,`s2`.`line_name` AS `line_name`,`s2`.`line_id` AS `line_id`,`s2`.`line_lab` AS `line_lab`,`s2`.`effector` AS `effector`,`s2`.`rearing_temperature` AS `rearing_temperature`,`s2`.`chamber` AS `chamber`,`s2`.`genotype` AS `genotype`,`s2`.`marking` AS `marking`,`s2`.`housing` AS `housing`,`e`.`notes_loading` AS `notes_loading`,`getCvTermName`(`score`.`type_id`) AS `data_type`,`score`.`value` AS `data`,1 AS `data_rows`,1 AS `data_columns`,'double' AS `data_format` from ((`olympiad_aggression_experiment_data_mv` `e` join `olympiad_aggression_session_feature_data_mv` `s2` on((`e`.`chamber_experiment_id` = `s2`.`chamber_experiment_id`))) join `score` on((`s2`.`session_id` = `score`.`session_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_session_property_vw` AS select `spv`.`session_id` AS `session_id` from (`olympiad_aggression_session_vw` `sv` join `session_property_vw` `spv` on((`spv`.`session_id` = `sv`.`session_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_session_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`line_vw`.`genotype` AS `genotype`,`sv`.`id` AS `session_id`,`sv`.`name` AS `session`,`sv`.`experiment_id` AS `experiment_id`,`sv`.`type` AS `session_type` from (`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) where ((`sv`.`lab` = 'olympiad') and (`sv`.`cv` = 'fly_olympiad_aggression')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_tracking_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_tracking_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_tracking_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_tracking_vw` AS select `e`.`arena_experiment_name` AS `arena_experiment_name`,`e`.`arena_experiment_id` AS `arena_experiment_id`,`e`.`experimenter` AS `experimenter`,`e`.`chamber_experiment_name` AS `chamber_experiment_name`,`e`.`chamber_experiment_id` AS `chamber_experiment_id`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`experiment_day_of_week` AS `experiment_day_of_week`,`e`.`file_system_path` AS `file_system_path`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`temperature` AS `temperature`,`e`.`humidity` AS `humidity`,`e`.`camera` AS `camera`,`e`.`arena` AS `arena`,`e`.`num_chambers` AS `num_chambers`,`e`.`border_width` AS `border_width`,`e`.`correct_orientation` AS `correct_orientation`,`e`.`correct_positions` AS `correct_positions`,`e`.`courtship_present` AS `courtship_present`,`e`.`frame_rate` AS `frame_rate`,`e`.`mult_flies_present` AS `mult_flies_present`,`e`.`number_denoised_frames` AS `number_denoised_frames`,`e`.`num_unprocessed_movies` AS `num_unprocessed_movies`,`e`.`process_stopped` AS `process_stopped`,`e`.`radius` AS `radius`,`e`.`radius_plus_border` AS `radius_plus_border`,`e`.`scale_calibration_file` AS `scale_calibration_file`,`e`.`tuning_threshold` AS `tuning_threshold`,`s`.`session_id` AS `session_id`,`s`.`behavior` AS `behavior`,`s`.`session_name` AS `session_name`,`getCvTermName`(`sa`.`term_id`) AS `fly`,`s`.`line_name` AS `line_name`,`s`.`line_id` AS `line_id`,`s`.`line_lab` AS `line_lab`,`s`.`effector` AS `effector`,`s`.`rearing_temperature` AS `rearing_temperature`,`s`.`chamber` AS `chamber`,`s`.`genotype` AS `genotype`,`s`.`marking` AS `marking`,`s`.`housing` AS `housing`,`e`.`notes_loading` AS `notes_loading`,`getCvTermName`(`sa`.`type_id`) AS `data_type`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format`,uncompress(`sa`.`value`) AS `data` from ((`olympiad_aggression_experiment_data_mv` `e` join `olympiad_aggression_session_tracking_data_mv` `s` on((`e`.`chamber_experiment_id` = `s`.`chamber_experiment_id`))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_aggression',NULL)) and (`sa`.`session_id` = `s`.`session_id`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_tracking_vw2`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_tracking_vw2`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_tracking_vw2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_tracking_vw2` AS select `e`.`arena_experiment_name` AS `arena_experiment_name`,`e`.`arena_experiment_id` AS `arena_experiment_id`,`e`.`experimenter` AS `experimenter`,`e`.`chamber_experiment_name` AS `chamber_experiment_name`,`e`.`chamber_experiment_id` AS `chamber_experiment_id`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`file_system_path` AS `file_system_path`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`temperature` AS `temperature`,`e`.`humidity` AS `humidity`,`e`.`camera` AS `camera`,`e`.`arena` AS `arena`,`e`.`num_chambers` AS `num_chambers`,`e`.`border_width` AS `border_width`,`e`.`correct_orientation` AS `correct_orientation`,`e`.`correct_positions` AS `correct_positions`,`e`.`courtship_present` AS `courtship_present`,`e`.`frame_rate` AS `frame_rate`,`e`.`mult_flies_present` AS `mult_flies_present`,`e`.`number_denoised_frames` AS `number_denoised_frames`,`e`.`num_unprocessed_movies` AS `num_unprocessed_movies`,`e`.`process_stopped` AS `process_stopped`,`e`.`radius` AS `radius`,`e`.`radius_plus_border` AS `radius_plus_border`,`e`.`scale_calibration_file` AS `scale_calibration_file`,`e`.`tuning_threshold` AS `tuning_threshold`,`s2`.`session_id` AS `session_id`,`s2`.`behavior` AS `behavior`,`s2`.`session_name` AS `session_name`,`getCvTermName`(`score`.`term_id`) AS `fly`,`s2`.`line_name` AS `line_name`,`s2`.`line_id` AS `line_id`,`s2`.`line_lab` AS `line_lab`,`s2`.`effector` AS `effector`,`s2`.`rearing_temperature` AS `rearing_temperature`,`s2`.`chamber` AS `chamber`,`s2`.`genotype` AS `genotype`,`s2`.`marking` AS `marking`,`s2`.`housing` AS `housing`,`e`.`notes_loading` AS `notes_loading`,`getCvTermName`(`score`.`type_id`) AS `data_type`,1 AS `data_rows`,1 AS `data_columns`,'double' AS `data_format`,`score`.`value` AS `data` from ((`olympiad_aggression_experiment_data_mv` `e` join `olympiad_aggression_session_tracking_data_mv` `s2` on((`e`.`chamber_experiment_id` = `s2`.`chamber_experiment_id`))) join `score` on((`s2`.`session_id` = `score`.`session_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_aggression_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_aggression_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_aggression_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_aggression_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`arena`.`name` AS `experiment`,`chamber`.`name` AS `chamber`,`sp_effector`.`value` AS `effector`,`sp_genotype`.`value` AS `genotype`,`ep_arena`.`value` AS `arena`,`ep_temp`.`value` AS `temperature`,`getCvTermName`(`s`.`type_id`) AS `session_type` from (((((((((`experiment` `chamber` join `experiment_relationship` `exp_rel` on((`chamber`.`id` = `exp_rel`.`subject_id`))) join `experiment` `arena` on((`arena`.`id` = `exp_rel`.`object_id`))) join `experiment_property` `ep_arena` on(((`arena`.`id` = `ep_arena`.`experiment_id`) and (`ep_arena`.`type_id` = `getCvTermId`('fly_olympiad_aggression','arena',NULL))))) join `experiment_property` `ep_temp` on(((`arena`.`id` = `ep_temp`.`experiment_id`) and (`ep_temp`.`type_id` = `getCvTermId`('fly_olympiad_aggression','temperature',NULL))))) join `session` `s` on((`chamber`.`id` = `s`.`experiment_id`))) left join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_aggression','effector',NULL))))) left join `session_property` `sp_genotype` on(((`s`.`id` = `sp_genotype`.`session_id`) and (`sp_genotype`.`type_id` = `getCvTermId`('fly_olympiad_aggression','genotype',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`chamber`.`type_id` = `getCvTermId`('fly_olympiad_aggression','aggression',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_analysis_info_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_analysis_info_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_info_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_analysis_info_vw` AS select `e`.`experiment_id` AS `experiment_id`,`e`.`experiment_name` AS `experiment_name`,`e`.`experimenter` AS `experimenter`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`box_name` AS `box_name`,`e`.`top_plate_id` AS `top_plate_id`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`file_system_path` AS `file_system_path`,`e`.`failure` AS `failure`,`e`.`errorcode` AS `errorcode`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`cool_max_var` AS `cool_max_var`,`e`.`hot_max_var` AS `hot_max_var`,`e`.`transition_duration` AS `transition_duration`,`e`.`questionable_data` AS `questionable_data`,`e`.`redo_experiment` AS `redo_experiment`,`e`.`live_notes` AS `live_notes`,`e`.`operator` AS `operator`,`e`.`max_vibration` AS `max_vibration`,`e`.`total_duration_seconds` AS `total_duration_seconds`,`e`.`force_seq_start` AS `force_seq_start`,`e`.`halt_early` AS `halt_early`,`s_m`.`metadata_session_id` AS `session_id`,`s_m`.`tube` AS `tube`,`s_m`.`line_id` AS `line_id`,`s_m`.`line_name` AS `line_name`,`s_m`.`line_lab` AS `line_lab`,`e`.`phase_id` AS `phase_id`,`e`.`sequence` AS `sequence`,`e`.`temperature` AS `temperature`,`s_m`.`genotype` AS `genotype`,`s_m`.`effector` AS `effector`,`s_m`.`gender` AS `gender`,`s_m`.`n` AS `n`,`s_m`.`n_dead` AS `n_dead`,`s_m`.`dob` AS `dob`,`s_m`.`rearing` AS `rearing`,`s_m`.`starved` AS `starved`,substr(`sa_cv`.`name`,15) AS `data_type`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format`,uncompress(`sa`.`value`) AS `data` from (((`olympiad_box_experiment_data_mv` `e` join `olympiad_box_session_meta_data_mv` `s_m` on((`e`.`experiment_id` = `s_m`.`experiment_id`))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_box',NULL)) and (`s_m`.`metadata_session_id` = `sa`.`session_id`) and (`e`.`phase_id` = `sa`.`phase_id`)))) join `cv_term` `sa_cv` on(((`sa`.`type_id` = `sa_cv`.`id`) and (`sa_cv`.`name` like 'analysis_info.%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_analysis_results_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_analysis_results_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_results_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_analysis_results_vw` AS select `e`.`experiment_id` AS `experiment_id`,`e`.`experiment_name` AS `experiment_name`,`e`.`experimenter` AS `experimenter`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`box_name` AS `box_name`,`e`.`top_plate_id` AS `top_plate_id`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`file_system_path` AS `file_system_path`,`e`.`failure` AS `failure`,`e`.`errorcode` AS `errorcode`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`cool_max_var` AS `cool_max_var`,`e`.`hot_max_var` AS `hot_max_var`,`e`.`transition_duration` AS `transition_duration`,`e`.`questionable_data` AS `questionable_data`,`e`.`redo_experiment` AS `redo_experiment`,`e`.`live_notes` AS `live_notes`,`e`.`operator` AS `operator`,`e`.`max_vibration` AS `max_vibration`,`e`.`total_duration_seconds` AS `total_duration_seconds`,`e`.`force_seq_start` AS `force_seq_start`,`e`.`halt_early` AS `halt_early`,`s_m`.`metadata_session_id` AS `metadata_session_id`,`s_m`.`tube` AS `tube`,`s_m`.`line_id` AS `line_id`,`s_m`.`line_name` AS `line_name`,`s_m`.`line_lab` AS `line_lab`,`e`.`phase_id` AS `phase_id`,`e`.`sequence` AS `sequence`,`e`.`temperature` AS `temperature`,`s_m`.`genotype` AS `genotype`,`s_m`.`effector` AS `effector`,`s_m`.`gender` AS `gender`,`s_m`.`n` AS `n`,`s_m`.`n_dead` AS `n_dead`,`s_a`.`analysis_session_id` AS `analysis_session_id`,`s_a`.`analysis_version` AS `analysis_version`,`s_m`.`dob` AS `dob`,`s_m`.`rearing` AS `rearing`,`s_m`.`starved` AS `starved`,`sa_cv`.`name` AS `data_type`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format`,uncompress(`sa`.`value`) AS `data` from ((((`olympiad_box_experiment_data_mv` `e` join `olympiad_box_session_meta_data_mv` `s_m` on((`e`.`experiment_id` = `s_m`.`experiment_id`))) join `olympiad_box_session_analysis_data_mv` `s_a` on(((`e`.`experiment_id` = `s_a`.`experiment_id`) and (`s_a`.`sequence` = `e`.`sequence`) and (`s_a`.`temperature` = `e`.`temperature`) and (`s_a`.`region` = `s_m`.`tube`) and (`s_m`.`experiment_id` = `s_a`.`experiment_id`)))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_box',NULL)) and (`s_a`.`analysis_session_id` = `sa`.`session_id`)))) join `cv_term` `sa_cv` on((`sa`.`type_id` = `sa_cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_analysis_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_analysis_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_analysis_session_property_vw` AS select `box_s`.`id` AS `session_id`,`e`.`id` AS `experiment_id`,`sequence`.`value` AS `sequence`,`region`.`value` AS `region`,`temperature`.`value` AS `temperature` from (((((((((((`experiment` `e` join `cv_term` `e_type` on((`e`.`type_id` = `e_type`.`id`))) join `cv` `e_cv` on(((`e_cv`.`id` = `e_type`.`cv_id`) and (`e_cv`.`name` = 'fly_olympiad_box')))) join `session` `box_s` on((`e`.`id` = `box_s`.`experiment_id`))) join `cv_term` `box_s_type` on(((`box_s`.`type_id` = `box_s_type`.`id`) and (`box_s_type`.`name` = 'analysis')))) join `cv` `box_s_cv` on(((`box_s_cv`.`id` = `box_s_type`.`cv_id`) and (`box_s_cv`.`name` = 'fly_olympiad')))) join `session_property` `sequence` on((`box_s`.`id` = `sequence`.`session_id`))) join `cv_term` `sequence_type` on(((`sequence`.`type_id` = `sequence_type`.`id`) and (`sequence_type`.`name` = 'sequence')))) join `session_property` `region` on((`box_s`.`id` = `region`.`session_id`))) join `cv_term` `region_type` on(((`region`.`type_id` = `region_type`.`id`) and (`region_type`.`name` = 'region')))) join `session_property` `temperature` on((`box_s`.`id` = `temperature`.`session_id`))) join `cv_term` `temperature_type` on(((`temperature`.`type_id` = `temperature_type`.`id`) and (`temperature_type`.`name` = 'temperature')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_analysis_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_analysis_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_analysis_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_analysis_session_vw` AS select `aspv`.`session_id` AS `session_id`,`aspv`.`sequence` AS `sequence`,`aspv`.`region` AS `tube`,`aspv`.`temperature` AS `temperature`,`aspv`.`experiment_id` AS `experiment_id`,`sa_type`.`name` AS `score_array_type`,uncompress(`sa`.`value`) AS `value` from (((`olympiad_box_analysis_session_property_vw` `aspv` join `session` `s` on((`s`.`id` = `aspv`.`session_id`))) join `score_array` `sa` on((`s`.`id` = `sa`.`session_id`))) join `cv_term` `sa_type` on((`sa_type`.`id` = `sa`.`type_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_environmental_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_environmental_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_environmental_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_environmental_vw` AS select `e`.`experiment_id` AS `experiment_id`,`e`.`experiment_name` AS `experiment_name`,`e`.`experimenter` AS `experimenter`,`e`.`experiment_date_time` AS `experiment_date_time`,`e`.`experiment_day_of_week` AS `experiment_day_of_week`,`e`.`box_name` AS `box_name`,`e`.`top_plate_id` AS `top_plate_id`,`e`.`experiment_protocol` AS `experiment_protocol`,`e`.`file_system_path` AS `file_system_path`,`e`.`failure` AS `failure`,`e`.`errorcode` AS `errorcode`,`e`.`automated_pf` AS `automated_pf`,`e`.`manual_pf` AS `manual_pf`,`e`.`cool_max_var` AS `cool_max_var`,`e`.`hot_max_var` AS `hot_max_var`,`e`.`transition_duration` AS `transition_duration`,`e`.`questionable_data` AS `questionable_data`,`e`.`redo_experiment` AS `redo_experiment`,`e`.`live_notes` AS `live_notes`,`e`.`operator` AS `operator`,`e`.`max_vibration` AS `max_vibration`,`e`.`total_duration_seconds` AS `total_duration_seconds`,`e`.`force_seq_start` AS `force_seq_start`,`e`.`halt_early` AS `halt_early`,`sa_cv`.`name` AS `data_type`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format`,uncompress(`sa`.`value`) AS `data` from ((`olympiad_box_experiment_data_mv` `e` join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_box',NULL)) and (`e`.`experiment_id` = `sa`.`experiment_id`)))) join `cv_term` `sa_cv` on((`sa`.`type_id` = `sa_cv`.`id`))) where ((`e`.`temperature` in (24,25,26)) and (`e`.`sequence` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_experiment_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_experiment_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_experiment_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_experiment_property_vw` AS select `oepv`.`experiment_id` AS `experiment_id`,max(if(strcmp(`oepv`.`type`,'date_time'),NULL,`oepv`.`value`)) AS `date_time`,max(if(strcmp(`oepv`.`type`,'box_name'),NULL,`oepv`.`value`)) AS `box_name`,max(if(strcmp(`oepv`.`type`,'top_plate_id'),NULL,`oepv`.`value`)) AS `top_plate_id`,max(if(strcmp(`oepv`.`type`,'failure'),NULL,`oepv`.`value`)) AS `failure`,max(if(strcmp(`oepv`.`type`,'errorcode'),NULL,`oepv`.`value`)) AS `errorcode`,max(if(strcmp(`oepv`.`type`,'cool_max_var'),NULL,`oepv`.`value`)) AS `cool_max_var`,max(if(strcmp(`oepv`.`type`,'hot_max_var'),NULL,`oepv`.`value`)) AS `hot_max_var`,max(if(strcmp(`oepv`.`type`,'transition_duration'),NULL,`oepv`.`value`)) AS `transition_duration`,max(if(strcmp(`oepv`.`type`,'questionable_data'),NULL,`oepv`.`value`)) AS `questionable_data`,max(if(strcmp(`oepv`.`type`,'redo_experiment'),NULL,`oepv`.`value`)) AS `redo_experiment`,max(if(strcmp(`oepv`.`type`,'live_notes'),NULL,`oepv`.`value`)) AS `live_notes`,max(if(strcmp(`oepv`.`type`,'operator'),NULL,`oepv`.`value`)) AS `operator`,max(if(strcmp(`oepv`.`type`,'max_vibration'),NULL,`oepv`.`value`)) AS `max_vibration`,max(if(strcmp(`oepv`.`type`,'total_duration_seconds'),NULL,`oepv`.`value`)) AS `total_duration_seconds`,max(if(strcmp(`oepv`.`type`,'force_seq_start'),NULL,`oepv`.`value`)) AS `force_seq_start`,max(if(strcmp(`oepv`.`type`,'halt_early'),NULL,`oepv`.`value`)) AS `halt_early` from (`olympiad_experiment_property_vw` `oepv` join `olympiad_experiment_vw` `oev` on(((`oepv`.`experiment_id` = `oev`.`id`) and (`oev`.`type` = 'box')))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_sbfmf_stat_score_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_sbfmf_stat_score_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_sbfmf_stat_score_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_sbfmf_stat_score_vw` AS select `score`.`session_id` AS `session_id`,`score`.`phase_id` AS `phase_id`,max(if(strcmp(`score_type`.`name`,'sbfmf_stat_meanerror'),NULL,`score`.`value`)) AS `meanerror`,max(if(strcmp(`score_type`.`name`,'sbfmf_stat_maxerror'),NULL,`score`.`value`)) AS `maxerror`,max(if(strcmp(`score_type`.`name`,'sbfmf_stat_meanwindowerror'),NULL,`score`.`value`)) AS `meanwindowerror`,max(if(strcmp(`score_type`.`name`,'sbfmf_stat_maxwindowerror'),NULL,`score`.`value`)) AS `maxwindowerror`,max(if(strcmp(`score_type`.`name`,'sbfmf_stat_compressionrate'),NULL,`score`.`value`)) AS `compressionrate` from ((`score` join `cv_term` `score_type` on((`score`.`type_id` = `score_type`.`id`))) join `cv` `score_cv` on(((`score_cv`.`id` = `score_type`.`cv_id`) and (`score_cv`.`name` = 'fly_olympiad_qc_box')))) group by `score`.`session_id`,`score`.`phase_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_session_property_vw` AS select `s`.`id` AS `session_id`,`effector`.`value` AS `effector`,`genotype`.`value` AS `genotype`,`rearing`.`value` AS `rearing`,`gender`.`value` AS `gender`,`s_type`.`name` AS `session_type` from ((((((((((((((`session` `s` join `cv_term` `s_type` on((`s_type`.`id` = `s`.`type_id`))) join `cv` `s_cv` on((`s_cv`.`id` = `s_type`.`cv_id`))) join `experiment` `e` on((`e`.`id` = `s`.`experiment_id`))) join `cv_term` `e_type` on((`e`.`type_id` = `e_type`.`id`))) join `cv` `e_cv` on(((`e_cv`.`id` = `e_type`.`cv_id`) and (`e_cv`.`name` = 'fly_olympiad_box')))) join `session_property` `effector` on((`s`.`id` = `effector`.`session_id`))) join `cv_term` `effector_type` on(((`effector`.`type_id` = `effector_type`.`id`) and (`effector_type`.`name` = 'effector')))) join `session_property` `genotype` on((`s`.`id` = `genotype`.`session_id`))) join `cv_term` `genotype_type` on(((`genotype`.`type_id` = `genotype_type`.`id`) and (`genotype_type`.`name` = 'genotype')))) join `session_property` `rearing` on((`s`.`id` = `rearing`.`session_id`))) join `cv_term` `rearing_type` on(((`rearing`.`type_id` = `rearing_type`.`id`) and (`rearing_type`.`name` = 'rearing')))) join `session_property` `gender` on((`s`.`id` = `gender`.`session_id`))) join `cv_term` `gender_type` on(((`gender`.`type_id` = `gender_type`.`id`) and (`gender_type`.`name` = 'gender')))) join `session_property` `temperature` on((`s`.`id` = `temperature`.`session_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_session_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`sv`.`id` AS `session_id`,`sv`.`name` AS `session`,`sv`.`experiment_id` AS `experiment_id`,`sv`.`type` AS `session_type` from ((((`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) join `experiment` `e` on((`e`.`id` = `sv`.`experiment_id`))) join `cv_term` `et` on((`e`.`type_id` = `et`.`id`))) join `cv` `ec` on(((`ec`.`id` = `et`.`cv_id`) and (`ec`.`name` = 'fly_olympiad_box')))) where (`sv`.`lab` = 'olympiad') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_box_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_box_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_box_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_box_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`e`.`name` AS `experiment`,`sp_effector`.`value` AS `effector`,`sp_genotype`.`value` AS `genotype`,`sp_rearing`.`value` AS `rearing`,`sp_gender`.`value` AS `gender`,`ep_box_name`.`value` AS `box`,`ep_protocol`.`value` AS `protocol` from (((((((((`experiment` `e` join `session` `s` on((`e`.`id` = `s`.`experiment_id`))) join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_box','effector',NULL))))) join `session_property` `sp_genotype` on(((`s`.`id` = `sp_genotype`.`session_id`) and (`sp_genotype`.`type_id` = `getCvTermId`('fly_olympiad_box','genotype',NULL))))) join `session_property` `sp_rearing` on(((`s`.`id` = `sp_rearing`.`session_id`) and (`sp_rearing`.`type_id` = `getCvTermId`('fly_olympiad_box','rearing',NULL))))) join `session_property` `sp_gender` on(((`s`.`id` = `sp_gender`.`session_id`) and (`sp_gender`.`type_id` = `getCvTermId`('fly_olympiad_box','gender',NULL))))) join `experiment_property` `ep_box_name` on(((`e`.`id` = `ep_box_name`.`experiment_id`) and (`ep_box_name`.`type_id` = `getCvTermId`('fly_olympiad_box','box_name',NULL))))) join `experiment_property` `ep_protocol` on(((`e`.`id` = `ep_protocol`.`experiment_id`) and (`ep_protocol`.`type_id` = `getCvTermId`('fly_olympiad_box','protocol',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_box','box',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_experiment_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_experiment_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_experiment_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_experiment_property_vw` AS select `ep`.`id` AS `id`,`ep`.`experiment_id` AS `experiment_id`,`cv_term`.`name` AS `type`,`ep`.`value` AS `value`,`ep`.`create_date` AS `create_date` from ((`experiment_property` `ep` join `cv_term` on((`ep`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_experiment_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_experiment_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_experiment_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_experiment_vw` AS select `e`.`id` AS `id`,`e`.`name` AS `name`,`cv_term`.`name` AS `type`,`protocol`.`value` AS `protocol`,`cvt1`.`name` AS `lab`,`e`.`experimenter` AS `experimenter`,`e`.`create_date` AS `create_date` from (((((`experiment` `e` join `cv_term` `cvt1` on((`e`.`lab_id` = `cvt1`.`id`))) join `cv` `cv1` on(((`cvt1`.`cv_id` = `cv1`.`id`) and (`cv1`.`name` = 'lab')))) join `cv_term` on((`e`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) left join `experiment_property` `protocol` on(((`protocol`.`experiment_id` = `e`.`id`) and (`protocol`.`type_id` = `getCvTermId`('fly_olympiad','protocol',NULL))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_analysis_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_analysis_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_analysis_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_analysis_session_property_vw` AS select `gap_sv`.`session_id` AS `session_id`,`temperature`.`value` AS `temperature`,`instrument`.`value` AS `instrument` from ((((`olympiad_gap_session_vw` `gap_sv` join `session_property` `temperature` on((`gap_sv`.`session_id` = `temperature`.`session_id`))) join `cv_term` `temperature_type` on(((`temperature`.`type_id` = `temperature_type`.`id`) and (`temperature_type`.`name` = 'temperature')))) join `session_property` `instrument` on((`gap_sv`.`session_id` = `instrument`.`session_id`))) join `cv_term` `instrument_type` on(((`instrument`.`type_id` = `instrument_type`.`id`) and (`instrument_type`.`name` = 'instrument')))) where (`gap_sv`.`session_type` = 'gap_crossing') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_analysis_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_analysis_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_analysis_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_analysis_session_vw` AS select `s`.`id` AS `session_id`,`aspv`.`temperature` AS `temperature`,`aspv`.`instrument` AS `instrument`,`s`.`experiment_id` AS `experiment_id`,`ct`.`name` AS `score_array_type`,uncompress(`sa`.`value`) AS `value` from ((((`olympiad_gap_analysis_session_property_vw` `aspv` join `session` `s` on((`s`.`id` = `aspv`.`session_id`))) join `experiment` `e` on((`s`.`experiment_id` = `e`.`id`))) join `score_array` `sa` on((`s`.`id` = `sa`.`session_id`))) join `cv_term` `ct` on((`ct`.`id` = `sa`.`type_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_analysis_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_analysis_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_analysis_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_analysis_vw` AS select straight_join `l`.`id` AS `line_id`,`l`.`name` AS `line_name`,`e`.`id` AS `experiment_id`,`e`.`name` AS `experiment_name`,`s`.`id` AS `session_id`,`s`.`name` AS `session_name`,`first_frame_disk6_occupied`.`value` AS `first_frame_disk6_occupied`,`first_max_mean_disk_frame`.`value` AS `first_max_mean_disk_frame`,uncompress(`first_max_mean_disk_frame_window`.`value`) AS `first_max_mean_disk_frame_window`,`last_mean_disk`.`value` AS `last_mean_disk`,`max_mean_disk`.`value` AS `max_mean_disk`,`min_arena_total`.`value` AS `min_arena_total`,`max_arena_total`.`value` AS `max_arena_total`,`mean_arena_total`.`value` AS `mean_arena_total`,`median_arena_total`.`value` AS `median_arena_total`,`std_arena_total`.`value` AS `std_arena_total` from ((((((((((((`experiment` `e` join `session` `s` on(((`s`.`experiment_id` = `e`.`id`) and (`s`.`type_id` = `getCvTermId`('fly_olympiad_gap','gap_crossing',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `score` `first_frame_disk6_occupied` on(((`first_frame_disk6_occupied`.`session_id` = `s`.`id`) and (`first_frame_disk6_occupied`.`type_id` = `getCvTermId`('fly_olympiad_gap','first_frame_disk6_occupied',NULL))))) join `score` `first_max_mean_disk_frame` on(((`first_max_mean_disk_frame`.`session_id` = `s`.`id`) and (`first_max_mean_disk_frame`.`type_id` = `getCvTermId`('fly_olympiad_gap','first_max_mean_disk_frame',NULL))))) join `score` `last_mean_disk` on(((`last_mean_disk`.`session_id` = `s`.`id`) and (`last_mean_disk`.`type_id` = `getCvTermId`('fly_olympiad_gap','last_mean_disk',NULL))))) join `score` `max_arena_total` on(((`max_arena_total`.`session_id` = `s`.`id`) and (`max_arena_total`.`type_id` = `getCvTermId`('fly_olympiad_gap','max_arena_total',NULL))))) join `score` `min_arena_total` on(((`min_arena_total`.`session_id` = `s`.`id`) and (`min_arena_total`.`type_id` = `getCvTermId`('fly_olympiad_gap','min_arena_total',NULL))))) join `score` `max_mean_disk` on(((`max_mean_disk`.`session_id` = `s`.`id`) and (`max_mean_disk`.`type_id` = `getCvTermId`('fly_olympiad_gap','max_mean_disk',NULL))))) join `score` `mean_arena_total` on(((`mean_arena_total`.`session_id` = `s`.`id`) and (`mean_arena_total`.`type_id` = `getCvTermId`('fly_olympiad_gap','mean_arena_total',NULL))))) join `score` `median_arena_total` on(((`median_arena_total`.`session_id` = `s`.`id`) and (`median_arena_total`.`type_id` = `getCvTermId`('fly_olympiad_gap','median_arena_total',NULL))))) join `score` `std_arena_total` on(((`std_arena_total`.`session_id` = `s`.`id`) and (`std_arena_total`.`type_id` = `getCvTermId`('fly_olympiad_gap','std_arena_total',NULL))))) join `score_array` `first_max_mean_disk_frame_window` on(((`first_max_mean_disk_frame_window`.`session_id` = `s`.`id`) and (`first_max_mean_disk_frame_window`.`type_id` = `getCvTermId`('fly_olympiad_gap','first_max_mean_disk_frame_window',NULL))))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_gap','gap_crossing',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_counts_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_counts_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_counts_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_counts_vw` AS select straight_join `e`.`id` AS `experiment_id`,`e`.`name` AS `experiment_name`,NULL AS `experiment_protocol`,`e`.`experimenter` AS `experimenter`,`file_system_path`.`value` AS `file_system_path`,`s`.`id` AS `session_id`,`s`.`name` AS `session_name`,`s`.`line_id` AS `line_id`,`l`.`name` AS `line_name`,`lab_cv`.`name` AS `line_lab`,`brightness`.`value` AS `brightness`,`center_loc_info_radius`.`value` AS `center_loc_info_radius`,`center_loc_info_x`.`value` AS `center_loc_info_x`,`center_loc_info_y`.`value` AS `center_loc_info_y`,`duration`.`value` AS `duration`,`exposure_time`.`value` AS `exposure_time`,`frame_rate`.`value` AS `frame_rate`,`gain`.`value` AS `gain`,`radius_disk1`.`value` AS `radius_disk1`,`radius_disk2`.`value` AS `radius_disk2`,`radius_disk3`.`value` AS `radius_disk3`,`radius_disk4`.`value` AS `radius_disk4`,`radius_disk5`.`value` AS `radius_disk5`,`radius_disk6`.`value` AS `radius_disk6`,`radius_gap1`.`value` AS `radius_gap1`,`radius_gap2`.`value` AS `radius_gap2`,`radius_gap3`.`value` AS `radius_gap3`,`radius_gap4`.`value` AS `radius_gap4`,`radius_gap5`.`value` AS `radius_gap5`,`region`.`value` AS `region`,`threshold`.`value` AS `threshold`,`exp_datetime`.`value` AS `date_time`,`effector`.`value` AS `effector`,`gender`.`value` AS `gender`,`instrument`.`value` AS `instrument`,`hours_starved`.`value` AS `hours_starved`,`temperature`.`value` AS `temperature`,`getCvTermName`(`sa`.`type_id`) AS `data_type`,uncompress(`sa`.`value`) AS `data`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format` from ((((((((((((((((((((((((((((((((`experiment` `e` join `experiment_property` `file_system_path` on(((`file_system_path`.`experiment_id` = `e`.`id`) and (`file_system_path`.`type_id` = `getCvTermId`('fly_olympiad_gap','file_system_path',NULL))))) join `experiment_property` `brightness` on(((`brightness`.`experiment_id` = `e`.`id`) and (`brightness`.`type_id` = `getCvTermId`('fly_olympiad_gap','brightness',NULL))))) join `experiment_property` `center_loc_info_radius` on(((`center_loc_info_radius`.`experiment_id` = `e`.`id`) and (`center_loc_info_radius`.`type_id` = `getCvTermId`('fly_olympiad_gap','center_loc_info_radius',NULL))))) join `experiment_property` `center_loc_info_x` on(((`center_loc_info_x`.`experiment_id` = `e`.`id`) and (`center_loc_info_x`.`type_id` = `getCvTermId`('fly_olympiad_gap','center_loc_info_x',NULL))))) join `experiment_property` `center_loc_info_y` on(((`center_loc_info_y`.`experiment_id` = `e`.`id`) and (`center_loc_info_y`.`type_id` = `getCvTermId`('fly_olympiad_gap','center_loc_info_y',NULL))))) join `experiment_property` `duration` on(((`duration`.`experiment_id` = `e`.`id`) and (`duration`.`type_id` = `getCvTermId`('fly_olympiad_gap','duration',NULL))))) join `experiment_property` `exposure_time` on(((`exposure_time`.`experiment_id` = `e`.`id`) and (`exposure_time`.`type_id` = `getCvTermId`('fly_olympiad_gap','exposure_time',NULL))))) join `experiment_property` `frame_rate` on(((`frame_rate`.`experiment_id` = `e`.`id`) and (`frame_rate`.`type_id` = `getCvTermId`('fly_olympiad_gap','frame_rate',NULL))))) join `experiment_property` `gain` on(((`gain`.`experiment_id` = `e`.`id`) and (`gain`.`type_id` = `getCvTermId`('fly_olympiad_gap','gain',NULL))))) join `experiment_property` `radius_disk1` on(((`radius_disk1`.`experiment_id` = `e`.`id`) and (`radius_disk1`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk1',NULL))))) join `experiment_property` `radius_disk2` on(((`radius_disk2`.`experiment_id` = `e`.`id`) and (`radius_disk2`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk2',NULL))))) join `experiment_property` `radius_disk3` on(((`radius_disk3`.`experiment_id` = `e`.`id`) and (`radius_disk3`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk3',NULL))))) join `experiment_property` `radius_disk4` on(((`radius_disk4`.`experiment_id` = `e`.`id`) and (`radius_disk4`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk4',NULL))))) join `experiment_property` `radius_disk5` on(((`radius_disk5`.`experiment_id` = `e`.`id`) and (`radius_disk5`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk5',NULL))))) join `experiment_property` `radius_disk6` on(((`radius_disk6`.`experiment_id` = `e`.`id`) and (`radius_disk6`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk6',NULL))))) join `experiment_property` `radius_gap1` on(((`radius_gap1`.`experiment_id` = `e`.`id`) and (`radius_gap1`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap1',NULL))))) join `experiment_property` `radius_gap2` on(((`radius_gap2`.`experiment_id` = `e`.`id`) and (`radius_gap2`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap2',NULL))))) join `experiment_property` `radius_gap3` on(((`radius_gap3`.`experiment_id` = `e`.`id`) and (`radius_gap3`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap3',NULL))))) join `experiment_property` `radius_gap4` on(((`radius_gap4`.`experiment_id` = `e`.`id`) and (`radius_gap4`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap4',NULL))))) join `experiment_property` `radius_gap5` on(((`radius_gap5`.`experiment_id` = `e`.`id`) and (`radius_gap5`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap5',NULL))))) join `experiment_property` `region` on(((`region`.`experiment_id` = `e`.`id`) and (`region`.`type_id` = `getCvTermId`('fly_olympiad_gap','region',NULL))))) join `experiment_property` `threshold` on(((`threshold`.`experiment_id` = `e`.`id`) and (`threshold`.`type_id` = `getCvTermId`('fly_olympiad_gap','threshold',NULL))))) join `session` `s` on((`s`.`experiment_id` = `e`.`id`))) join `session_property` `exp_datetime` on(((`exp_datetime`.`session_id` = `s`.`id`) and (`exp_datetime`.`type_id` = `getCvTermId`('fly_olympiad_gap','exp_datetime',NULL))))) join `session_property` `effector` on(((`effector`.`session_id` = `s`.`id`) and (`effector`.`type_id` = `getCvTermId`('fly_olympiad_gap','effector',NULL))))) join `session_property` `gender` on(((`gender`.`session_id` = `s`.`id`) and (`gender`.`type_id` = `getCvTermId`('fly_olympiad_gap','gender',NULL))))) join `session_property` `instrument` on(((`instrument`.`session_id` = `s`.`id`) and (`instrument`.`type_id` = `getCvTermId`('fly_olympiad_gap','instrument',NULL))))) join `session_property` `hours_starved` on(((`hours_starved`.`session_id` = `s`.`id`) and (`hours_starved`.`type_id` = `getCvTermId`('fly_olympiad_gap','hours_starved',NULL))))) join `session_property` `temperature` on(((`temperature`.`session_id` = `s`.`id`) and (`temperature`.`type_id` = `getCvTermId`('fly_olympiad_gap','temperature',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `cv_term` `lab_cv` on((`l`.`lab_id` = `lab_cv`.`id`))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_gap',NULL)) and (`sa`.`session_id` = `s`.`id`)))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_gap','gap_crossing',NULL)) union all select straight_join `e`.`id` AS `experiment_id`,`e`.`name` AS `experiment_name`,NULL AS `experiment_protocol`,`e`.`experimenter` AS `experimenter`,`file_system_path`.`value` AS `file_system_path`,`s`.`id` AS `session_id`,`s`.`name` AS `session_name`,`s`.`line_id` AS `line_id`,`l`.`name` AS `line_name`,`lab_cv`.`name` AS `line_lab`,`brightness`.`value` AS `brightness`,`center_loc_info_radius`.`value` AS `center_loc_info_radius`,`center_loc_info_x`.`value` AS `center_loc_info_x`,`center_loc_info_y`.`value` AS `center_loc_info_y`,`duration`.`value` AS `duration`,`exposure_time`.`value` AS `exposure_time`,`frame_rate`.`value` AS `frame_rate`,`gain`.`value` AS `gain`,`radius_disk1`.`value` AS `radius_disk1`,`radius_disk2`.`value` AS `radius_disk2`,`radius_disk3`.`value` AS `radius_disk3`,`radius_disk4`.`value` AS `radius_disk4`,`radius_disk5`.`value` AS `radius_disk5`,`radius_disk6`.`value` AS `radius_disk6`,`radius_gap1`.`value` AS `radius_gap1`,`radius_gap2`.`value` AS `radius_gap2`,`radius_gap3`.`value` AS `radius_gap3`,`radius_gap4`.`value` AS `radius_gap4`,`radius_gap5`.`value` AS `radius_gap5`,`region`.`value` AS `region`,`threshold`.`value` AS `threshold`,`exp_datetime`.`value` AS `date_time`,`effector`.`value` AS `effector`,`gender`.`value` AS `gender`,`instrument`.`value` AS `instrument`,`hours_starved`.`value` AS `hours_starved`,`temperature`.`value` AS `temperature`,`score_cv`.`name` AS `data_type`,`score`.`value` AS `data`,1 AS `data_rows`,1 AS `data_columns`,'double' AS `data_format` from (((((((((((((((((((((((((((((((((`experiment` `e` join `experiment_property` `file_system_path` on(((`file_system_path`.`experiment_id` = `e`.`id`) and (`file_system_path`.`type_id` = `getCvTermId`('fly_olympiad_gap','file_system_path',NULL))))) join `experiment_property` `brightness` on(((`brightness`.`experiment_id` = `e`.`id`) and (`brightness`.`type_id` = `getCvTermId`('fly_olympiad_gap','brightness',NULL))))) join `experiment_property` `center_loc_info_radius` on(((`center_loc_info_radius`.`experiment_id` = `e`.`id`) and (`center_loc_info_radius`.`type_id` = `getCvTermId`('fly_olympiad_gap','center_loc_info_radius',NULL))))) join `experiment_property` `center_loc_info_x` on(((`center_loc_info_x`.`experiment_id` = `e`.`id`) and (`center_loc_info_x`.`type_id` = `getCvTermId`('fly_olympiad_gap','center_loc_info_x',NULL))))) join `experiment_property` `center_loc_info_y` on(((`center_loc_info_y`.`experiment_id` = `e`.`id`) and (`center_loc_info_y`.`type_id` = `getCvTermId`('fly_olympiad_gap','center_loc_info_y',NULL))))) join `experiment_property` `duration` on(((`duration`.`experiment_id` = `e`.`id`) and (`duration`.`type_id` = `getCvTermId`('fly_olympiad_gap','duration',NULL))))) join `experiment_property` `exposure_time` on(((`exposure_time`.`experiment_id` = `e`.`id`) and (`exposure_time`.`type_id` = `getCvTermId`('fly_olympiad_gap','exposure_time',NULL))))) join `experiment_property` `frame_rate` on(((`frame_rate`.`experiment_id` = `e`.`id`) and (`frame_rate`.`type_id` = `getCvTermId`('fly_olympiad_gap','frame_rate',NULL))))) join `experiment_property` `gain` on(((`gain`.`experiment_id` = `e`.`id`) and (`gain`.`type_id` = `getCvTermId`('fly_olympiad_gap','gain',NULL))))) join `experiment_property` `radius_disk1` on(((`radius_disk1`.`experiment_id` = `e`.`id`) and (`radius_disk1`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk1',NULL))))) join `experiment_property` `radius_disk2` on(((`radius_disk2`.`experiment_id` = `e`.`id`) and (`radius_disk2`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk2',NULL))))) join `experiment_property` `radius_disk3` on(((`radius_disk3`.`experiment_id` = `e`.`id`) and (`radius_disk3`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk3',NULL))))) join `experiment_property` `radius_disk4` on(((`radius_disk4`.`experiment_id` = `e`.`id`) and (`radius_disk4`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk4',NULL))))) join `experiment_property` `radius_disk5` on(((`radius_disk5`.`experiment_id` = `e`.`id`) and (`radius_disk5`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk5',NULL))))) join `experiment_property` `radius_disk6` on(((`radius_disk6`.`experiment_id` = `e`.`id`) and (`radius_disk6`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_disk6',NULL))))) join `experiment_property` `radius_gap1` on(((`radius_gap1`.`experiment_id` = `e`.`id`) and (`radius_gap1`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap1',NULL))))) join `experiment_property` `radius_gap2` on(((`radius_gap2`.`experiment_id` = `e`.`id`) and (`radius_gap2`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap2',NULL))))) join `experiment_property` `radius_gap3` on(((`radius_gap3`.`experiment_id` = `e`.`id`) and (`radius_gap3`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap3',NULL))))) join `experiment_property` `radius_gap4` on(((`radius_gap4`.`experiment_id` = `e`.`id`) and (`radius_gap4`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap4',NULL))))) join `experiment_property` `radius_gap5` on(((`radius_gap5`.`experiment_id` = `e`.`id`) and (`radius_gap5`.`type_id` = `getCvTermId`('fly_olympiad_gap','radius_gap5',NULL))))) join `experiment_property` `region` on(((`region`.`experiment_id` = `e`.`id`) and (`region`.`type_id` = `getCvTermId`('fly_olympiad_gap','region',NULL))))) join `experiment_property` `threshold` on(((`threshold`.`experiment_id` = `e`.`id`) and (`threshold`.`type_id` = `getCvTermId`('fly_olympiad_gap','threshold',NULL))))) join `session` `s` on((`s`.`experiment_id` = `e`.`id`))) join `session_property` `exp_datetime` on(((`exp_datetime`.`session_id` = `s`.`id`) and (`exp_datetime`.`type_id` = `getCvTermId`('fly_olympiad_gap','exp_datetime',NULL))))) join `session_property` `effector` on(((`effector`.`session_id` = `s`.`id`) and (`effector`.`type_id` = `getCvTermId`('fly_olympiad_gap','effector',NULL))))) join `session_property` `gender` on(((`gender`.`session_id` = `s`.`id`) and (`gender`.`type_id` = `getCvTermId`('fly_olympiad_gap','gender',NULL))))) join `session_property` `instrument` on(((`instrument`.`session_id` = `s`.`id`) and (`instrument`.`type_id` = `getCvTermId`('fly_olympiad_gap','instrument',NULL))))) join `session_property` `hours_starved` on(((`hours_starved`.`session_id` = `s`.`id`) and (`hours_starved`.`type_id` = `getCvTermId`('fly_olympiad_gap','hours_starved',NULL))))) join `session_property` `temperature` on(((`temperature`.`session_id` = `s`.`id`) and (`temperature`.`type_id` = `getCvTermId`('fly_olympiad_gap','temperature',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `cv_term` `lab_cv` on((`l`.`lab_id` = `lab_cv`.`id`))) join `score` on((`score`.`session_id` = `s`.`id`))) join `cv_term` `score_cv` on((`score`.`type_id` = `score_cv`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_gap','gap_crossing',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_session_property_vw` AS select `spv`.`session_id` AS `session_id`,max(if(strcmp(`spv`.`type`,'effector'),NULL,`spv`.`value`)) AS `effector`,max(if(strcmp(`spv`.`type`,'genotype'),NULL,`spv`.`value`)) AS `genotype`,max(if(strcmp(`spv`.`type`,'rearing'),NULL,`spv`.`value`)) AS `rearing`,max(if(strcmp(`spv`.`type`,'gender'),NULL,`spv`.`value`)) AS `gender` from (`session_property_vw` `spv` join `olympiad_gap_session_vw` `sv` on((`spv`.`session_id` = `sv`.`session_id`))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_session_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`sv`.`id` AS `session_id`,`sv`.`name` AS `session`,`sv`.`experiment_id` AS `experiment_id`,`sv`.`type` AS `session_type` from (`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) where ((`sv`.`lab` = 'olympiad') and (`sv`.`cv` = 'fly_olympiad_gap')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_gap_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_gap_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_gap_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_gap_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`e`.`name` AS `experiment`,`sp_effector`.`value` AS `effector`,`sp_genotype`.`value` AS `genotype`,`sp_rearing`.`value` AS `rearing`,`sp_gender`.`value` AS `gender` from (((((((`experiment` `e` join `session` `s` on((`e`.`id` = `s`.`experiment_id`))) join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_gap','effector',NULL))))) left join `session_property` `sp_genotype` on(((`s`.`id` = `sp_genotype`.`session_id`) and (`sp_genotype`.`type_id` = `getCvTermId`('fly_olympiad_gap','genotype',NULL))))) left join `session_property` `sp_rearing` on(((`s`.`id` = `sp_rearing`.`session_id`) and (`sp_rearing`.`type_id` = `getCvTermId`('fly_olympiad_gap','rearing',NULL))))) join `session_property` `sp_gender` on(((`s`.`id` = `sp_gender`.`session_id`) and (`sp_gender`.`type_id` = `getCvTermId`('fly_olympiad_gap','gender',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_gap','gap_crossing',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_lethality_experiment_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_lethality_experiment_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_experiment_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_lethality_experiment_property_vw` AS select `oepv`.`experiment_id` AS `experiment_id`,max(if(strcmp(`oepv`.`type`,'effector'),NULL,`oepv`.`value`)) AS `effector` from (`olympiad_experiment_property_vw` `oepv` join `olympiad_experiment_vw` `oev` on(((`oepv`.`experiment_id` = `oev`.`id`) and (`oev`.`type` = 'lethality')))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_lethality_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_lethality_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_lethality_session_property_vw` AS select `spv`.`session_id` AS `session_id`,max(if(strcmp(`spv`.`type`,'exp_datetime'),NULL,`spv`.`value`)) AS `run_date`,max(if(strcmp(`spv`.`type`,'temperature'),NULL,`spv`.`value`)) AS `temperature`,max(if(strcmp(`spv`.`type`,'notes_behavioral'),NULL,`spv`.`value`)) AS `notes_behavioral` from (`session_property_vw` `spv` join `olympiad_lethality_session_vw` `sv` on((`spv`.`session_id` = `sv`.`session_id`))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_lethality_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_lethality_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_lethality_session_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`id` AS `line_id`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`sv`.`id` AS `session_id`,`sv`.`name` AS `session`,`sv`.`experiment_id` AS `experiment_id` from (`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) where ((`sv`.`lab` = 'olympiad') and (`sv`.`cv` = 'fly_olympiad_lethality')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_lethality_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_lethality_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_lethality_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_lethality_vw` AS select `spv`.`run_date` AS `Date`,`lab`.`display_name` AS `Lab`,`sv`.`line` AS `Line`,`epv`.`effector` AS `Effector`,`o`.`value` AS `Stage_at_Death`,`spv`.`temperature` AS `Temperature`,`spv`.`notes_behavioral` AS `Behavioral_Notes` from ((((((`experiment` `e` join `olympiad_lethality_session_vw` `sv` on((`e`.`id` = `sv`.`experiment_id`))) join `olympiad_lethality_session_property_vw` `spv` on((`sv`.`session_id` = `spv`.`session_id`))) join `olympiad_lethality_experiment_property_vw` `epv` on((`e`.`id` = `epv`.`experiment_id`))) join `observation` `o` on(((`o`.`session_id` = `sv`.`session_id`) and (`o`.`type_id` = `getCvTermId`('fly_olympiad_lethality','stage_at_death',NULL))))) join `line` `l` on((`sv`.`line_id` = `l`.`id`))) join `cv_term` `lab` on((`lab`.`id` = `l`.`lab_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_observation_observation_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_observation_observation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_observation_observation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_observation_observation_vw` AS select `l`.`name` AS `line`,`e`.`id` AS `experiment_id`,`s`.`name` AS `session`,`c`.`display_name` AS `display_name`,`o_observed`.`value` AS `observed`,`o_gender`.`value` AS `gender`,`o_periodicity`.`value` AS `periodicity` from ((((((`session` `s` join `experiment` `e` on((`e`.`id` = `s`.`experiment_id`))) join `cv_term` `c` on((`c`.`id` = `s`.`type_id`))) join `observation` `o_observed` on(((`s`.`id` = `o_observed`.`session_id`) and (`o_observed`.`type_id` = `getCvTermId`('fly_olympiad_observation','observed',NULL))))) left join `observation` `o_gender` on(((`s`.`id` = `o_gender`.`session_id`) and (`o_gender`.`type_id` = `getCvTermId`('fly_olympiad_observation','gender',NULL))))) left join `observation` `o_periodicity` on(((`s`.`id` = `o_periodicity`.`session_id`) and (`o_periodicity`.`type_id` = `getCvTermId`('fly_olympiad_observation','periodicity',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_observation','observation',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_observation_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_observation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_observation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_observation_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`e`.`name` AS `experiment`,`ep_effector`.`value` AS `effector`,`ep_genotype`.`value` AS `genotype`,`ep_no_phenotypes`.`value` AS `no_phenotypes` from ((((((`experiment` `e` join `session` `s` on((`e`.`id` = `s`.`experiment_id`))) left join `experiment_property` `ep_effector` on(((`e`.`id` = `ep_effector`.`experiment_id`) and (`ep_effector`.`type_id` = `getCvTermId`('fly_olympiad_observation','effector',NULL))))) left join `experiment_property` `ep_genotype` on(((`e`.`id` = `ep_genotype`.`experiment_id`) and (`ep_genotype`.`type_id` = `getCvTermId`('fly_olympiad_observation','genotype',NULL))))) left join `experiment_property` `ep_no_phenotypes` on(((`e`.`id` = `ep_no_phenotypes`.`experiment_id`) and (`ep_no_phenotypes`.`type_id` = `getCvTermId`('fly_olympiad_observation','no_phenotypes',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_observation','observation',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_region_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_region_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_region_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_region_property_vw` AS select `rp`.`id` AS `id`,`rp`.`session_id` AS `region_id`,`cv_term`.`name` AS `type`,`rp`.`value` AS `value`,`rp`.`create_date` AS `create_date` from ((`session_property` `rp` join `cv_term` on((`rp`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_region_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_region_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_region_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_region_vw` AS select `s`.`id` AS `id`,`s`.`experiment_id` AS `experiment_id`,`l`.`name` AS `line`,`s`.`name` AS `name`,`s`.`create_date` AS `create_date` from (((`session` `s` join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `cv_term` on((`s`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_score_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_score_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_score_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_score_vw` AS select `s`.`id` AS `id`,`s`.`phase_id` AS `sequence_id`,`s`.`session_id` AS `region_id`,`s`.`experiment_id` AS `experiment_id`,`cv_term`.`name` AS `type`,uncompress(`s`.`value`) AS `array_value`,NULL AS `value`,`s`.`data_type` AS `data_type`,`s`.`row_count` AS `row_count`,`s`.`column_count` AS `column_count`,`s`.`create_date` AS `create_date` from ((`score_array` `s` join `cv_term` on((`s`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_sequence_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_sequence_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_sequence_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_sequence_property_vw` AS select `sp`.`id` AS `id`,`sp`.`phase_id` AS `sequence_id`,`cv_term`.`name` AS `type`,`sp`.`value` AS `value`,`sp`.`create_date` AS `create_date` from ((`phase_property` `sp` join `cv_term` on((`sp`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_sequence_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_sequence_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_sequence_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_sequence_vw` AS select `p`.`id` AS `id`,`p`.`experiment_id` AS `experiment_id`,`p`.`name` AS `name`,`p`.`create_date` AS `create_date` from ((`phase` `p` join `cv_term` on((`p`.`type_id` = `cv_term`.`id`))) join `cv` on(((`cv_term`.`cv_id` = `cv`.`id`) and (`cv`.`name` like 'fly_olympiad%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_sterility_instance_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_sterility_instance_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_instance_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_sterility_instance_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`e`.`name` AS `experiment`,`sp_effector`.`value` AS `effector`,`sp_genotype`.`value` AS `genotype`,`sp_rearing`.`value` AS `rearing`,`sp_gender`.`value` AS `gender`,`ep_experimenter`.`value` AS `experimenter`,`getCvTermName`(`score`.`type_id`) AS `data_type`,`score`.`value` AS `data`,1 AS `data_rows`,1 AS `data_columns`,'double' AS `data_format` from (((((((((`experiment` `e` join `session` `s` on((`e`.`id` = `s`.`experiment_id`))) join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_sterility','effector',NULL))))) left join `session_property` `sp_genotype` on(((`s`.`id` = `sp_genotype`.`session_id`) and (`sp_genotype`.`type_id` = `getCvTermId`('fly_olympiad_sterility','genotype',NULL))))) left join `session_property` `sp_rearing` on(((`s`.`id` = `sp_rearing`.`session_id`) and (`sp_rearing`.`type_id` = `getCvTermId`('fly_olympiad_sterility','rearing',NULL))))) left join `session_property` `sp_gender` on(((`s`.`id` = `sp_gender`.`session_id`) and (`sp_gender`.`type_id` = `getCvTermId`('fly_olympiad_sterility','gender',NULL))))) join `experiment_property` `ep_experimenter` on(((`e`.`id` = `ep_experimenter`.`experiment_id`) and (`ep_experimenter`.`type_id` = `getCvTermId`('fly_olympiad_sterility','experimenter',NULL))))) join `score` on((`s`.`id` = `score`.`session_id`))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_sterility','sterility',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_sterility_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_sterility_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_sterility_session_property_vw` AS select `spv`.`session_id` AS `session_id`,max(if(strcmp(`spv`.`type`,'effector'),NULL,`spv`.`value`)) AS `effector`,max(if(strcmp(`spv`.`type`,'genotype'),NULL,`spv`.`value`)) AS `genotype`,max(if(strcmp(`spv`.`type`,'rearing'),NULL,`spv`.`value`)) AS `rearing`,max(if(strcmp(`spv`.`type`,'gender'),NULL,`spv`.`value`)) AS `gender` from (`session_property_vw` `spv` join `olympiad_sterility_session_vw` `sv` on((`spv`.`session_id` = `sv`.`session_id`))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_sterility_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_sterility_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_sterility_session_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`sv`.`id` AS `session_id`,`sv`.`name` AS `session`,`sv`.`experiment_id` AS `experiment_id`,`sv`.`type` AS `session_type` from (`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) where ((`sv`.`lab` = 'olympiad') and (`sv`.`cv` = 'fly_olympiad_sterility')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_sterility_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_sterility_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_sterility_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_sterility_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`e`.`name` AS `experiment`,`sp_effector`.`value` AS `effector`,`sp_genotype`.`value` AS `genotype`,`sp_rearing`.`value` AS `rearing`,`sp_gender`.`value` AS `gender`,`sc_sterile`.`value` AS `sterile`,`ep_experimenter`.`value` AS `experimenter` from (((((((((`experiment` `e` join `session` `s` on((`e`.`id` = `s`.`experiment_id`))) join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_sterility','effector',NULL))))) left join `session_property` `sp_genotype` on(((`s`.`id` = `sp_genotype`.`session_id`) and (`sp_genotype`.`type_id` = `getCvTermId`('fly_olympiad_sterility','genotype',NULL))))) left join `session_property` `sp_rearing` on(((`s`.`id` = `sp_rearing`.`session_id`) and (`sp_rearing`.`type_id` = `getCvTermId`('fly_olympiad_sterility','rearing',NULL))))) left join `session_property` `sp_gender` on(((`s`.`id` = `sp_gender`.`session_id`) and (`sp_gender`.`type_id` = `getCvTermId`('fly_olympiad_sterility','gender',NULL))))) left join `score` `sc_sterile` on(((`s`.`id` = `sc_sterile`.`session_id`) and (`sc_sterile`.`type_id` = `getCvTermId`('fly_olympiad_sterility','sterile',NULL))))) join `experiment_property` `ep_experimenter` on(((`e`.`id` = `ep_experimenter`.`experiment_id`) and (`ep_experimenter`.`type_id` = `getCvTermId`('fly_olympiad_sterility','experimenter',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`e`.`type_id` = 1402) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_analysis_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_analysis_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_analysis_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_analysis_session_property_vw` AS select `spv`.`session_id` AS `session_id`,max(if(strcmp(`spv`.`type`,'temperature'),NULL,`spv`.`value`)) AS `temperature`,max(if(strcmp(`spv`.`type`,'monitor'),NULL,`spv`.`value`)) AS `monitor`,max(if(strcmp(`spv`.`type`,'channel'),NULL,`spv`.`value`)) AS `channel` from (`session_property_vw` `spv` join `olympiad_trikinetics_session_vw` `sv` on(((`spv`.`session_id` = `sv`.`session_id`) and (`sv`.`session_type` = 'crossings')))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_analysis_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_analysis_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_analysis_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_analysis_session_vw` AS select `s`.`id` AS `session_id`,`epv`.`value` AS `incubator`,`aspv`.`temperature` AS `temperature`,`aspv`.`monitor` AS `monitor`,`aspv`.`channel` AS `channel`,`s`.`experiment_id` AS `experiment_id`,`ct`.`name` AS `score_array_type`,uncompress(`sa`.`value`) AS `value` from (((((`olympiad_trikinetics_analysis_session_property_vw` `aspv` join `session` `s` on((`s`.`id` = `aspv`.`session_id`))) join `experiment` `e` on((`s`.`experiment_id` = `e`.`id`))) join `olympiad_experiment_property_vw` `epv` on(((`e`.`id` = `epv`.`experiment_id`) and (`epv`.`type` = 'incubator')))) join `score_array` `sa` on((`s`.`id` = `sa`.`session_id`))) join `cv_term` `ct` on((`ct`.`id` = `sa`.`type_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_analysis_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_analysis_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_analysis_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_analysis_vw` AS select `e`.`id` AS `experiment_id`,`e`.`name` AS `experiment_name`,`e`.`experimenter` AS `experimenter`,`ep_date_time`.`value` AS `experiment_date_time`,`ep_temperature`.`value` AS `temperature`,`ep_automated_pf`.`value` AS `automated_pf`,`ep_manual_pf`.`value` AS `manual_pf`,`ep_l_d_cycle`.`value` AS `l_d_cycle`,`ep_protocol`.`value` AS `experiment_protocol`,`ep_file_system_path`.`value` AS `file_system_path`,`ep_bin_size`.`value` AS `bin_size`,`ep_incubator`.`value` AS `incubator`,`ep_monitor`.`value` AS `env_monitor`,`s`.`id` AS `session_id`,`s`.`name` AS `session_name`,`s`.`line_id` AS `line_id`,`l`.`name` AS `line_name`,`lab_cv`.`name` AS `line_lab`,cast(`sp_count`.`value` as unsigned) AS `channel_count`,`sa_cv`.`name` AS `data_type`,uncompress(`sa`.`value`) AS `data`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format` from ((((((((((((((((`experiment` `e` join `experiment_property` `ep_date_time` on(((`e`.`id` = `ep_date_time`.`experiment_id`) and (`ep_date_time`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','exp_datetime',NULL))))) join `experiment_property` `ep_protocol` on(((`e`.`id` = `ep_protocol`.`experiment_id`) and (`ep_protocol`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','protocol',NULL))))) join `experiment_property` `ep_file_system_path` on(((`e`.`id` = `ep_file_system_path`.`experiment_id`) and (`ep_file_system_path`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','file_system_path',NULL))))) left join `experiment_property` `ep_automated_pf` on(((`e`.`id` = `ep_automated_pf`.`experiment_id`) and (`ep_automated_pf`.`type_id` = `getCvTermId`('fly_olympiad_qc','automated_pf',NULL))))) left join `experiment_property` `ep_manual_pf` on(((`e`.`id` = `ep_manual_pf`.`experiment_id`) and (`ep_manual_pf`.`type_id` = `getCvTermId`('fly_olympiad_qc','manual_pf',NULL))))) join `experiment_property` `ep_temperature` on(((`e`.`id` = `ep_temperature`.`experiment_id`) and (`ep_temperature`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','temperature',NULL))))) join `experiment_property` `ep_l_d_cycle` on(((`e`.`id` = `ep_l_d_cycle`.`experiment_id`) and (`ep_l_d_cycle`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','l_d_cycle',NULL))))) join `experiment_property` `ep_bin_size` on(((`e`.`id` = `ep_bin_size`.`experiment_id`) and (`ep_bin_size`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','bin_size',NULL))))) join `experiment_property` `ep_incubator` on(((`e`.`id` = `ep_incubator`.`experiment_id`) and (`ep_incubator`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','incubator',NULL))))) join `experiment_property` `ep_monitor` on(((`e`.`id` = `ep_monitor`.`experiment_id`) and (`ep_monitor`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','monitor',NULL))))) join `session` `s` on(((`e`.`id` = `s`.`experiment_id`) and (`s`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','analysis',NULL))))) join `session_property` `sp_count` on(((`s`.`id` = `sp_count`.`session_id`) and (`sp_count`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','num_flies',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `cv_term` `lab_cv` on((`l`.`lab_id` = `lab_cv`.`id`))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_trikinetics',NULL)) and (`s`.`id` = `sa`.`session_id`)))) join `cv_term` `sa_cv` on((`sa`.`type_id` = `sa_cv`.`id`))) union all select `e`.`id` AS `experiment_id`,`e`.`name` AS `experiment_name`,`e`.`experimenter` AS `experimenter`,`ep_date_time`.`value` AS `experiment_date_time`,`ep_temperature`.`value` AS `temperature`,`ep_automated_pf`.`value` AS `automated_pf`,`ep_manual_pf`.`value` AS `manual_pf`,`ep_l_d_cycle`.`value` AS `l_d_cycle`,`ep_protocol`.`value` AS `experiment_protocol`,`ep_file_system_path`.`value` AS `file_system_path`,`ep_bin_size`.`value` AS `bin_size`,`ep_incubator`.`value` AS `incubator`,`ep_monitor`.`value` AS `env_monitor`,`s`.`id` AS `session_id`,`s`.`name` AS `session_name`,`s`.`line_id` AS `line_id`,`l`.`name` AS `line_name`,`lab_cv`.`name` AS `line_lab`,cast(`sp_count`.`value` as unsigned) AS `channel_count`,`score_cv`.`name` AS `data_type`,`score`.`value` AS `data`,1 AS `data_rows`,1 AS `data_columns`,'double' AS `data_format` from ((((((((((((((((`experiment` `e` join `experiment_property` `ep_date_time` on(((`e`.`id` = `ep_date_time`.`experiment_id`) and (`ep_date_time`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','exp_datetime',NULL))))) join `experiment_property` `ep_protocol` on(((`e`.`id` = `ep_protocol`.`experiment_id`) and (`ep_protocol`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','protocol',NULL))))) join `experiment_property` `ep_file_system_path` on(((`e`.`id` = `ep_file_system_path`.`experiment_id`) and (`ep_file_system_path`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','file_system_path',NULL))))) left join `experiment_property` `ep_automated_pf` on(((`e`.`id` = `ep_automated_pf`.`experiment_id`) and (`ep_automated_pf`.`type_id` = `getCvTermId`('fly_olympiad_qc','automated_pf',NULL))))) left join `experiment_property` `ep_manual_pf` on(((`e`.`id` = `ep_manual_pf`.`experiment_id`) and (`ep_manual_pf`.`type_id` = `getCvTermId`('fly_olympiad_qc','manual_pf',NULL))))) join `experiment_property` `ep_temperature` on(((`e`.`id` = `ep_temperature`.`experiment_id`) and (`ep_temperature`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','temperature',NULL))))) join `experiment_property` `ep_l_d_cycle` on(((`e`.`id` = `ep_l_d_cycle`.`experiment_id`) and (`ep_l_d_cycle`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','l_d_cycle',NULL))))) join `experiment_property` `ep_bin_size` on(((`e`.`id` = `ep_bin_size`.`experiment_id`) and (`ep_bin_size`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','bin_size',NULL))))) join `experiment_property` `ep_incubator` on(((`e`.`id` = `ep_incubator`.`experiment_id`) and (`ep_incubator`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','incubator',NULL))))) join `experiment_property` `ep_monitor` on(((`e`.`id` = `ep_monitor`.`experiment_id`) and (`ep_monitor`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','monitor',NULL))))) join `session` `s` on(((`e`.`id` = `s`.`experiment_id`) and (`s`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','analysis',NULL))))) join `session_property` `sp_count` on(((`s`.`id` = `sp_count`.`session_id`) and (`sp_count`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','num_flies',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `cv_term` `lab_cv` on((`l`.`lab_id` = `lab_cv`.`id`))) join `score` on((`s`.`id` = `score`.`session_id`))) join `cv_term` `score_cv` on((`score`.`type_id` = `score_cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_monitor_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_monitor_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_monitor_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_monitor_vw` AS select `e`.`id` AS `experiment_id`,`e`.`name` AS `experiment_name`,`e`.`experimenter` AS `experimenter`,`ep_date_time`.`value` AS `experiment_date_time`,`ep_temperature`.`value` AS `temperature`,`ep_automated_pf`.`value` AS `automated_pf`,`ep_manual_pf`.`value` AS `manual_pf`,`ep_l_d_cycle`.`value` AS `l_d_cycle`,`ep_protocol`.`value` AS `experiment_protocol`,`ep_file_system_path`.`value` AS `file_system_path`,`ep_bin_size`.`value` AS `bin_size`,`ep_incubator`.`value` AS `incubator`,`ep_monitor`.`value` AS `env_monitor`,`s`.`id` AS `session_id`,`s`.`name` AS `session_name`,`session_cv`.`name` AS `session_type`,`s`.`line_id` AS `line_id`,`l`.`name` AS `line_name`,`lab_cv`.`name` AS `line_lab`,`sp_monitor`.`value` AS `monitor`,`sp_start_date_time`.`value` AS `start_date_time`,`sp_effector`.`value` AS `effector`,`sp_channel`.`value` AS `channel`,if((`session_cv`.`name` = 'monitor'),NULL,ifnull(`sp_dead`.`value`,'no')) AS `dead`,`sa_cv`.`name` AS `data_type`,uncompress(`sa`.`value`) AS `data`,`sa`.`row_count` AS `data_rows`,`sa`.`column_count` AS `data_columns`,`sa`.`data_type` AS `data_format` from (((((((((((((((((((((`experiment` `e` join `experiment_property` `ep_date_time` on(((`e`.`id` = `ep_date_time`.`experiment_id`) and (`ep_date_time`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','exp_datetime',NULL))))) join `experiment_property` `ep_protocol` on(((`e`.`id` = `ep_protocol`.`experiment_id`) and (`ep_protocol`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','protocol',NULL))))) join `experiment_property` `ep_file_system_path` on(((`e`.`id` = `ep_file_system_path`.`experiment_id`) and (`ep_file_system_path`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','file_system_path',NULL))))) left join `experiment_property` `ep_automated_pf` on(((`e`.`id` = `ep_automated_pf`.`experiment_id`) and (`ep_automated_pf`.`type_id` = `getCvTermId`('fly_olympiad_qc','automated_pf',NULL))))) left join `experiment_property` `ep_manual_pf` on(((`e`.`id` = `ep_manual_pf`.`experiment_id`) and (`ep_manual_pf`.`type_id` = `getCvTermId`('fly_olympiad_qc','manual_pf',NULL))))) join `experiment_property` `ep_temperature` on(((`e`.`id` = `ep_temperature`.`experiment_id`) and (`ep_temperature`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','temperature',NULL))))) join `experiment_property` `ep_l_d_cycle` on(((`e`.`id` = `ep_l_d_cycle`.`experiment_id`) and (`ep_l_d_cycle`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','l_d_cycle',NULL))))) join `experiment_property` `ep_bin_size` on(((`e`.`id` = `ep_bin_size`.`experiment_id`) and (`ep_bin_size`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','bin_size',NULL))))) join `experiment_property` `ep_incubator` on(((`e`.`id` = `ep_incubator`.`experiment_id`) and (`ep_incubator`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','incubator',NULL))))) join `experiment_property` `ep_monitor` on(((`e`.`id` = `ep_monitor`.`experiment_id`) and (`ep_monitor`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','monitor',NULL))))) join `session` `s` on(((`e`.`id` = `s`.`experiment_id`) and ((`s`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','monitor',NULL)) or (`s`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','crossings',NULL)))))) join `cv_term` `session_cv` on((`s`.`type_id` = `session_cv`.`id`))) join `session_property` `sp_monitor` on(((`s`.`id` = `sp_monitor`.`session_id`) and (`sp_monitor`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','monitor',NULL))))) join `session_property` `sp_start_date_time` on(((`s`.`id` = `sp_start_date_time`.`session_id`) and (`sp_start_date_time`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','start_date_time',NULL))))) left join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','effector',NULL))))) left join `session_property` `sp_channel` on(((`s`.`id` = `sp_channel`.`session_id`) and (`sp_channel`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','channel',NULL))))) left join `session_property` `sp_dead` on(((`s`.`id` = `sp_dead`.`session_id`) and (`sp_dead`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','dead',NULL))))) left join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `cv_term` `lab_cv` on((`l`.`lab_id` = `lab_cv`.`id`))) join `score_array` `sa` on(((`sa`.`cv_id` = `getCvId`('fly_olympiad_trikinetics',NULL)) and (`s`.`id` = `sa`.`session_id`)))) join `cv_term` `sa_cv` on((`sa`.`type_id` = `sa_cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_session_property_vw` AS select `spv`.`session_id` AS `session_id`,max(if(strcmp(`spv`.`type`,'effector'),NULL,`spv`.`value`)) AS `effector`,max(if(strcmp(`spv`.`type`,'genotype'),NULL,`spv`.`value`)) AS `genotype`,max(if(strcmp(`spv`.`type`,'rearing'),NULL,`spv`.`value`)) AS `rearing`,max(if(strcmp(`spv`.`type`,'gender'),NULL,`spv`.`value`)) AS `gender` from (`session_property_vw` `spv` join `olympiad_trikinetics_session_vw` `sv` on((`spv`.`session_id` = `sv`.`session_id`))) group by 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_session_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`line_vw`.`synonyms` AS `synonyms`,`sv`.`id` AS `session_id`,`sv`.`name` AS `session`,`sv`.`experiment_id` AS `experiment_id`,`sv`.`type` AS `session_type` from (`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) where ((`sv`.`lab` = 'olympiad') and (`sv`.`cv` = 'fly_olympiad_trikinetics')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `olympiad_trikinetics_vw`
--

/*!50001 DROP TABLE IF EXISTS `olympiad_trikinetics_vw`*/;
/*!50001 DROP VIEW IF EXISTS `olympiad_trikinetics_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `olympiad_trikinetics_vw` AS select `l`.`name` AS `line`,`g`.`name` AS `gene`,`g`.`synonym_string` AS `synonyms`,`s`.`name` AS `session`,`e`.`name` AS `experiment`,`sp_effector`.`value` AS `effector`,`sp_genotype`.`value` AS `genotype`,`sp_rearing`.`value` AS `rearing`,`sp_gender`.`value` AS `gender`,`ep_incubator`.`value` AS `incubator` from ((((((((`experiment` `e` join `session` `s` on((`e`.`id` = `s`.`experiment_id`))) left join `session_property` `sp_effector` on(((`s`.`id` = `sp_effector`.`session_id`) and (`sp_effector`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','effector',NULL))))) left join `session_property` `sp_genotype` on(((`s`.`id` = `sp_genotype`.`session_id`) and (`sp_genotype`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','genotype',NULL))))) left join `session_property` `sp_rearing` on(((`s`.`id` = `sp_rearing`.`session_id`) and (`sp_rearing`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','rearing',NULL))))) left join `session_property` `sp_gender` on(((`s`.`id` = `sp_gender`.`session_id`) and (`sp_gender`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','gender',NULL))))) join `experiment_property` `ep_incubator` on(((`e`.`id` = `ep_incubator`.`experiment_id`) and (`ep_incubator`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','incubator',NULL))))) join `line` `l` on((`s`.`line_id` = `l`.`id`))) left join `gene` `g` on((`l`.`gene_id` = `g`.`id`))) where (`e`.`type_id` = `getCvTermId`('fly_olympiad_trikinetics','trikinetics',NULL)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `phase_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `phase_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `phase_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `phase_property_vw` AS select `pp`.`id` AS `id`,`pp`.`phase_id` AS `phase_id`,`p`.`name` AS `name`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`pp`.`value` AS `value`,`pp`.`create_date` AS `create_date` from (((`phase_property` `pp` join `phase` `p` on((`pp`.`phase_id` = `p`.`id`))) join `cv_term` on((`pp`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `phase_vw`
--

/*!50001 DROP TABLE IF EXISTS `phase_vw`*/;
/*!50001 DROP VIEW IF EXISTS `phase_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `phase_vw` AS select `p`.`id` AS `id`,`p`.`experiment_id` AS `experiment_id`,`p`.`name` AS `name`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`p`.`create_date` AS `create_date` from ((`phase` `p` join `cv_term` on((`p`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `prelim_annotation_observation_vw`
--

/*!50001 DROP TABLE IF EXISTS `prelim_annotation_observation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `prelim_annotation_observation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `prelim_annotation_observation_vw` AS select `o`.`session_id` AS `session_id`,`o`.`term_id` AS `term_id`,`term`.`name` AS `term`,`observation_type`.`name` AS `name`,`o`.`value` AS `value` from ((`observation` `o` join `cv_term` `observation_type` on(((`o`.`type_id` = `observation_type`.`id`) and (`observation_type`.`name` in ('expressed','supergroup'))))) join `cv_term` `term` on((`o`.`term_id` = `term`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `prelim_annotation_session_vw`
--

/*!50001 DROP TABLE IF EXISTS `prelim_annotation_session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `prelim_annotation_session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `prelim_annotation_session_vw` AS select `session_property`.`session_id` AS `id`,max(if(strcmp(`session_property_type`.`name`,'age'),NULL,`session_property`.`value`)) AS `age`,max(if(strcmp(`session_property_type`.`name`,'organ'),NULL,`session_property`.`value`)) AS `organ`,max(if(strcmp(`session_property_type`.`name`,'projection_all_url'),NULL,`session_property`.`value`)) AS `projection_all_url`,max(if(strcmp(`session_property_type`.`name`,'image_name'),NULL,`session_property`.`value`)) AS `image_name`,max(if(strcmp(`session_property_type`.`name`,'extraordinary'),NULL,`session_property`.`value`)) AS `extraordinary`,max(if(strcmp(`session_property_type`.`name`,'specimen_quality'),NULL,`session_property`.`value`)) AS `specimen_quality`,max(if(strcmp(`session_property_type`.`name`,'very_broad'),NULL,`session_property`.`value`)) AS `very_broad`,max(if(strcmp(`session_property_type`.`name`,'done'),NULL,`session_property`.`value`)) AS `done`,max(if(strcmp(`session_property_type`.`name`,'empty'),NULL,`session_property`.`value`)) AS `empty`,max(if(strcmp(`session_property_type`.`name`,'panneural'),NULL,`session_property`.`value`)) AS `panneural`,max(if(strcmp(`session_property_type`.`name`,'substructure'),NULL,`session_property`.`value`)) AS `substructure`,max(if(strcmp(`session_property_type`.`name`,'heat_shock_age'),NULL,`session_property`.`value`)) AS `heat_shock_age`,max(if(strcmp(`session_property_type`.`name`,'representative'),NULL,`session_property`.`value`)) AS `representative`,max(if(strcmp(`session_property_type`.`name`,'expression_regions'),NULL,`session_property`.`value`)) AS `expression_regions` from ((((`session_property` join `cv_term` `session_property_type` on((`session_property`.`type_id` = `session_property_type`.`id`))) join `session` on((`session_property`.`session_id` = `session`.`id`))) join `cv_term` `session_type` on((`session`.`type_id` = `session_type`.`id`))) join `cv` on((`session_type`.`cv_id` = `cv`.`id`))) where (`cv`.`name` = 'prelim_annotation') group by `session_property`.`session_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `prelim_annotation_vw`
--

/*!50001 DROP TABLE IF EXISTS `prelim_annotation_vw`*/;
/*!50001 DROP VIEW IF EXISTS `prelim_annotation_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `prelim_annotation_vw` AS select `prelim_annotation_session_vw`.`id` AS `id`,`prelim_annotation_session_vw`.`age` AS `age`,`prelim_annotation_session_vw`.`organ` AS `organ`,`prelim_annotation_session_vw`.`projection_all_url` AS `projection_all_url`,`prelim_annotation_session_vw`.`image_name` AS `image_name`,`prelim_annotation_session_vw`.`extraordinary` AS `extraordinary`,`prelim_annotation_session_vw`.`specimen_quality` AS `specimen_quality`,`prelim_annotation_session_vw`.`very_broad` AS `very_broad`,`prelim_annotation_session_vw`.`done` AS `done`,`prelim_annotation_session_vw`.`empty` AS `empty`,`prelim_annotation_session_vw`.`panneural` AS `panneural`,`prelim_annotation_session_vw`.`substructure` AS `substructure`,`prelim_annotation_session_vw`.`heat_shock_age` AS `heat_shock_age`,`prelim_annotation_session_vw`.`representative` AS `representative`,`prelim_annotation_session_vw`.`expression_regions` AS `expression_regions`,`line`.`name` AS `line`,`gene`.`name` AS `gene`,`session`.`name` AS `name`,`lab`.`name` AS `lab`,if(strcmp(`prelim_annotation_observation_vw`.`name`,'supergroup'),`observation`.`name`,NULL) AS `region`,if(strcmp(`prelim_annotation_observation_vw`.`name`,'expressed'),NULL,`prelim_annotation_observation_vw`.`value`) AS `expressed`,if(strcmp(`prelim_annotation_observation_vw`.`name`,'supergroup'),NULL,`observation`.`name`) AS `supergroup` from ((((((`prelim_annotation_session_vw` join `session` on((`prelim_annotation_session_vw`.`id` = `session`.`id`))) join `prelim_annotation_observation_vw` on((`prelim_annotation_observation_vw`.`session_id` = `session`.`id`))) join `cv_term` `observation` on((`prelim_annotation_observation_vw`.`term_id` = `observation`.`id`))) join `line` on((`session`.`line_id` = `line`.`id`))) join `gene` on((`line`.`gene_id` = `gene`.`id`))) join `cv_term` `lab` on((`session`.`lab_id` = `lab`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rubin_lab_external_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `rubin_lab_external_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `rubin_lab_external_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `rubin_lab_external_property_vw` AS select `image_vw`.`id` AS `id`,`image_vw`.`line` AS `line`,`image_vw`.`capture_date` AS `date`,max(if(strcmp(`image_property_vw`.`type`,'disc'),NULL,`image_property_vw`.`value`)) AS `disc`,max(if(strcmp(`image_property_vw`.`type`,'external_lab'),NULL,`image_property_vw`.`value`)) AS `external_lab`,`image_vw`.`created_by` AS `created_by` from (`image_vw` join `image_property_vw` on((`image_vw`.`id` = `image_property_vw`.`image_id`))) where (`image_vw`.`family` = 'rubin_lab_external') group by `image_vw`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rubin_lab_external_vw`
--

/*!50001 DROP TABLE IF EXISTS `rubin_lab_external_vw`*/;
/*!50001 DROP VIEW IF EXISTS `rubin_lab_external_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `rubin_lab_external_vw` AS select `image_vw`.`name` AS `name`,`image_vw`.`representative` AS `representative`,`x`.`created_by` AS `created_by`,`x`.`line` AS `line`,`x`.`date` AS `date`,`x`.`disc` AS `disc`,`x`.`external_lab` AS `external_lab`,`image_vw`.`display` AS `display` from (`rubin_lab_external_property_vw` `x` join `image_vw` on((`x`.`id` = `image_vw`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `score_array_vw`
--

/*!50001 DROP TABLE IF EXISTS `score_array_vw`*/;
/*!50001 DROP VIEW IF EXISTS `score_array_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `score_array_vw` AS select `sa`.`id` AS `id`,`sa`.`session_id` AS `session_id`,`sa`.`phase_id` AS `phase_id`,`sa`.`experiment_id` AS `experiment_id`,`s`.`name` AS `session`,`p`.`name` AS `phase`,`e`.`name` AS `experiment`,`cv2`.`name` AS `cv_term`,`cv_term2`.`name` AS `term`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`sa`.`value` AS `value`,`sa`.`run` AS `run`,`sa`.`data_type` AS `data_type`,`sa`.`row_count` AS `row_count`,`sa`.`column_count` AS `column_count`,`sa`.`create_date` AS `create_date` from (((((((`score_array` `sa` join `cv_term` on((`sa`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) join `cv_term` `cv_term2` on((`sa`.`term_id` = `cv_term2`.`id`))) join `cv` `cv2` on((`cv_term2`.`cv_id` = `cv2`.`id`))) left join `session` `s` on((`sa`.`session_id` = `s`.`id`))) left join `phase` `p` on((`sa`.`phase_id` = `p`.`id`))) left join `experiment` `e` on((`sa`.`experiment_id` = `e`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `score_vw`
--

/*!50001 DROP TABLE IF EXISTS `score_vw`*/;
/*!50001 DROP VIEW IF EXISTS `score_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `score_vw` AS select `score`.`id` AS `id`,`score`.`session_id` AS `session_id`,`s`.`name` AS `session`,`cv2`.`name` AS `cv_term`,`cv_term2`.`name` AS `term`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`score`.`value` AS `value`,`score`.`run` AS `run`,`score`.`create_date` AS `create_date` from (((((`score` join `cv_term` on((`score`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) join `cv_term` `cv_term2` on((`score`.`term_id` = `cv_term2`.`id`))) join `cv` `cv2` on((`cv_term2`.`cv_id` = `cv2`.`id`))) join `session` `s` on((`score`.`session_id` = `s`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `secondary_image_vw`
--

/*!50001 DROP TABLE IF EXISTS `secondary_image_vw`*/;
/*!50001 DROP VIEW IF EXISTS `secondary_image_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `secondary_image_vw` AS select `si`.`id` AS `id`,`si`.`name` AS `name`,`si`.`image_id` AS `image_id`,`cvt1`.`name` AS `product`,`si`.`path` AS `path`,`si`.`url` AS `url`,`si`.`create_date` AS `create_date`,`i`.`name` AS `parent` from (((`secondary_image` `si` join `cv_term` `cvt1` on((`si`.`product_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `image` `i` on((`si`.`image_id` = `i`.`id`))) where (`cv1`.`name` = 'product') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `session_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `session_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `session_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `session_property_vw` AS select `sp`.`id` AS `id`,`sp`.`session_id` AS `session_id`,`s`.`name` AS `name`,`cvt1`.`name` AS `lab`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`sp`.`value` AS `value`,`sp`.`create_date` AS `create_date` from (((((`session_property` `sp` join `session` `s` on((`sp`.`session_id` = `s`.`id`))) join `cv_term` `cvt1` on((`s`.`lab_id` = `cvt1`.`id`))) join `cv` `cv1` on((`cvt1`.`cv_id` = `cv1`.`id`))) join `cv_term` on((`sp`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `session_relationship_vw`
--

/*!50001 DROP TABLE IF EXISTS `session_relationship_vw`*/;
/*!50001 DROP VIEW IF EXISTS `session_relationship_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `session_relationship_vw` AS select `cv`.`id` AS `context_id`,`cv`.`name` AS `context`,`s1`.`id` AS `subject_id`,`s1`.`name` AS `subject`,`cvt`.`id` AS `relationship_id`,`cvt`.`name` AS `relationship`,`s2`.`id` AS `object_id`,`s2`.`name` AS `object` from ((((`cv` join `session_relationship` `sr`) join `cv_term` `cvt`) join `session` `s1`) join `session` `s2`) where ((`sr`.`type_id` = `cvt`.`id`) and (`sr`.`subject_id` = `s1`.`id`) and (`sr`.`object_id` = `s2`.`id`) and (`cvt`.`is_current` = 1) and (`cv`.`id` = `cvt`.`cv_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `session_vw`
--

/*!50001 DROP TABLE IF EXISTS `session_vw`*/;
/*!50001 DROP VIEW IF EXISTS `session_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `session_vw` AS select `s`.`id` AS `id`,`s`.`name` AS `name`,`cv`.`name` AS `cv`,`cv_term`.`name` AS `type`,`s`.`line_id` AS `line_id`,`l`.`name` AS `line`,`s`.`experiment_id` AS `experiment_id`,`s`.`phase_id` AS `phase_id`,`s`.`annotator` AS `annotator`,`lab`.`name` AS `lab`,`s`.`create_date` AS `create_date` from (((((`session` `s` join `line` `l` on((`s`.`line_id` = `l`.`id`))) join `cv_term` `lab` on((`s`.`lab_id` = `lab`.`id`))) join `cv` `lab_cv` on(((`lab`.`cv_id` = `lab_cv`.`id`) and (`lab_cv`.`name` = 'lab')))) join `cv_term` on((`s`.`type_id` = `cv_term`.`id`))) join `cv` on((`cv_term`.`cv_id` = `cv`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `simpson_gal4_vw`
--

/*!50001 DROP TABLE IF EXISTS `simpson_gal4_vw`*/;
/*!50001 DROP VIEW IF EXISTS `simpson_gal4_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `simpson_gal4_vw` AS select `simpson_gal4_mv`.`line` AS `line`,`simpson_gal4_mv`.`gene` AS `gene`,`simpson_gal4_mv`.`synonyms` AS `synonyms`,`simpson_gal4_mv`.`cytology` AS `cytology`,`simpson_gal4_mv`.`comments` AS `comments`,`simpson_gal4_mv`.`brain` AS `brain`,`simpson_gal4_mv`.`thorax` AS `thorax`,`simpson_gal4_mv`.`term` AS `term`,`simpson_gal4_mv`.`expressed` AS `expressed`,`simpson_gal4_mv`.`expressed_regions` AS `expressed_regions` from `simpson_gal4_mv` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `simpson_image_class_vw`
--

/*!50001 DROP TABLE IF EXISTS `simpson_image_class_vw`*/;
/*!50001 DROP VIEW IF EXISTS `simpson_image_class_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `simpson_image_class_vw` AS select `image_vw`.`line` AS `line`,`simpson_image_property_vw`.`product` AS `product`,`simpson_image_property_vw`.`class` AS `class` from (`simpson_image_property_vw` join `image_vw` on((`simpson_image_property_vw`.`image_id` = `image_vw`.`id`))) where (`simpson_image_property_vw`.`class` is not null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `simpson_image_property_vw`
--

/*!50001 DROP TABLE IF EXISTS `simpson_image_property_vw`*/;
/*!50001 DROP VIEW IF EXISTS `simpson_image_property_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `simpson_image_property_vw` AS select `image_property_vw`.`image_id` AS `image_id`,max(if(strcmp(`image_property_vw`.`type`,'organ'),NULL,`image_property_vw`.`value`)) AS `organ`,max(if(strcmp(`image_property_vw`.`type`,'specimen'),NULL,`image_property_vw`.`value`)) AS `specimen`,max(if(strcmp(`image_property_vw`.`type`,'bits_per_sample'),NULL,`image_property_vw`.`value`)) AS `bits_per_sample`,max(if(strcmp(`image_property_vw`.`type`,'product'),NULL,`image_property_vw`.`value`)) AS `product`,max(if(strcmp(`image_property_vw`.`type`,'class'),NULL,`image_property_vw`.`value`)) AS `class` from (`image_property_vw` join `image_vw` on(((`image_property_vw`.`image_id` = `image_vw`.`id`) and (`image_vw`.`family` like 'simpson%')))) group by `image_property_vw`.`image_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `simpson_image_vw`
--

/*!50001 DROP TABLE IF EXISTS `simpson_image_vw`*/;
/*!50001 DROP VIEW IF EXISTS `simpson_image_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `simpson_image_vw` AS select `image_vw`.`name` AS `name`,`image_vw`.`family` AS `family`,`image_vw`.`capture_date` AS `capture_date`,`image_vw`.`representative` AS `representative`,`image_vw`.`created_by` AS `created_by`,`image_vw`.`line` AS `line`,`simpson_image_property_vw`.`organ` AS `organ`,`simpson_image_property_vw`.`specimen` AS `specimen`,`simpson_image_property_vw`.`bits_per_sample` AS `bits_per_sample`,`image_vw`.`display` AS `display` from (`simpson_image_property_vw` join `image_vw` on(((`simpson_image_property_vw`.`image_id` = `image_vw`.`id`) and (`image_vw`.`name` like 'simpson%')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `simpson_pe_vw`
--

/*!50001 DROP TABLE IF EXISTS `simpson_pe_vw`*/;
/*!50001 DROP VIEW IF EXISTS `simpson_pe_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `simpson_pe_vw` AS select `line_vw`.`name` AS `line`,`line_vw`.`gene` AS `gene`,`getGeneSynonymString`(`line_vw`.`gene`) AS `synonyms`,`sv`.`name` AS `name`,max(if(strcmp(`ov`.`type`,'notes'),NULL,`ov`.`value`)) AS `notes`,max(if(strcmp(`ov`.`type`,'temp_type'),NULL,`ov`.`value`)) AS `temp_type` from ((`line_vw` join `session_vw` `sv` on((`sv`.`line_id` = `line_vw`.`id`))) left join `observation_vw` `ov` on((`sv`.`id` = `ov`.`session_id`))) where ((`sv`.`lab` = 'simpson') and (`ov`.`cv` = 'proboscis_extension')) group by 1,2,3,4 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `simpson_rep_image_vw`
--

/*!50001 DROP TABLE IF EXISTS `simpson_rep_image_vw`*/;
/*!50001 DROP VIEW IF EXISTS `simpson_rep_image_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`sageAdmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `simpson_rep_image_vw` AS select `image`.`line_id` AS `line_id`,max(if(strcmp(`image_property_vw`.`value`,'Brain'),NULL,`image_property_vw`.`image_id`)) AS `brain_id`,max(if(strcmp(`image_property_vw`.`value`,'Thorax'),NULL,`image_property_vw`.`image_id`)) AS `thorax_id` from (`image` join `image_property_vw` on((`image_property_vw`.`image_id` = `image`.`id`))) where (`image_property_vw`.`type` = 'organ') group by `image`.`line_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-01-27 16:14:35
