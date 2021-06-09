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
  KEY `image_experiment_id_fk` (`experiment_id`),
  CONSTRAINT `image_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `image_family_id_fk` FOREIGN KEY (`family_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `image_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=336038 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `image_session`
--

CREATE TABLE `image_session` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `image_id` int(10) unsigned NOT NULL,
  `session_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_session_uk_ind` (`image_id`,`session_id`) USING BTREE,
  KEY `image_session_session_id_fk` (`session_id`),
  CONSTRAINT `image_session_image_id_fk` FOREIGN KEY (`image_id`) REFERENCES `image` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `image_session_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB;

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
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(767) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `experiment_id` int(10) unsigned DEFAULT NULL,
  `phase_id` int(10) unsigned DEFAULT NULL,
  `annotator` varchar(255) NOT NULL DEFAULT '',
  `lab_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_type_uk_ind` (`name`,`type_id`,`lab_id`,`experiment_id`) USING BTREE,
  KEY `session_type_id_fk_ind` (`type_id`) USING BTREE,
  KEY `session_lab_id_fk_ind` (`lab_id`) USING BTREE,
  KEY `session_experiment_id_fk_ind` (`experiment_id`) USING BTREE,
  KEY `session_phase_id_fk_ind` (`phase_id`) USING BTREE,
  CONSTRAINT `session_experiment_id_fk` FOREIGN KEY (`experiment_id`) REFERENCES `experiment` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `session_lab_id_fk` FOREIGN KEY (`lab_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
