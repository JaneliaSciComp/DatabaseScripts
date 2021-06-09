-- MySQL dump 10.13  Distrib 5.1.52, for apple-darwin10.3.0 (i386)
--
-- Host: dev-db    Database: genie
-- ------------------------------------------------------
-- Server version	5.5.16-enterprise-commercial-advanced-log

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
-- Table structure for table `construct`
--

DROP TABLE IF EXISTS `construct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `construct` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `construct_name_uk` (`name`),
  KEY `construct_type_id_fk` (`type_id`),
  CONSTRAINT `construct_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `construct_property`
--

DROP TABLE IF EXISTS `construct_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `construct_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `construct_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `construct_property_type_uk` (`construct_id`,`type_id`),
  KEY `construct_property_construct_id_fk` (`construct_id`),
  KEY `construct_property_type_id_fk` (`type_id`),
  CONSTRAINT `construct_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `construct_property_construct_id_fk` FOREIGN KEY (`construct_id`) REFERENCES `construct` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `construct_relationship`
--

DROP TABLE IF EXISTS `construct_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `construct_relationship` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `subject_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `is_current` tinyint(3) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `construct_relationship_uk_ind` (`type_id`,`subject_id`,`object_id`) USING BTREE,
  KEY `construct_relationship_object_id_fk` (`object_id`),
  KEY `construct_relationship_subject_id_fk` (`subject_id`),
  CONSTRAINT `construct_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `construct_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `construct` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `construct_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `construct` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `imaging_plate`
--

DROP TABLE IF EXISTS `imaging_plate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imaging_plate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `plate_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `imaging_plate_name_uk` (`name`),
  KEY `imaging_plate_plate_id_fk` (`plate_id`),
  KEY `imaging_plate_type_id_fk` (`type_id`),
  CONSTRAINT `imaging_plate_plate_id_fk` FOREIGN KEY (`plate_id`) REFERENCES `plate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `imaging_plate_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `imaging_plate_well`
--

DROP TABLE IF EXISTS `imaging_plate_well`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imaging_plate_well` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `replicate_id` int(10) unsigned NOT NULL,
  `imaging_plate_id` int(10) unsigned NOT NULL,
  `plate_well_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `well` char(10) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `imaging_plate_well_uk` (`imaging_plate_id`,`well`),
  KEY `imaging_plate_well_plate_well_id_fk` (`plate_well_id`),
  KEY `imaging_plate_well_replicate_id_fk` (`replicate_id`),
  KEY `imaging_plate_well_type_id_fk` (`type_id`),
  CONSTRAINT `imaging_plate_well_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `imaging_plate_well_imaging_plate_id_fk` FOREIGN KEY (`imaging_plate_id`) REFERENCES `imaging_plate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `imaging_plate_well_plate_well_id_fk` FOREIGN KEY (`plate_well_id`) REFERENCES `plate_well` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `imaging_plate_well_replicate_id_fk` FOREIGN KEY (`replicate_id`) REFERENCES `replicate` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `imaging_plate_well_property`
--

DROP TABLE IF EXISTS `imaging_plate_well_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imaging_plate_well_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `imaging_plate_well_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `imaging_plate_well_property_type_uk` (`imaging_plate_well_id`,`type_id`),
  KEY `imaging_plate_well_property_type_id_fk` (`type_id`),
  KEY `imaging_plate_well_property_imaging_plate_well_id_fk` (`imaging_plate_well_id`),
  CONSTRAINT `imaging_plate_well_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `imaging_plate_well_property_imaging_plate_well_id_fk` FOREIGN KEY (`imaging_plate_well_id`) REFERENCES `imaging_plate_well` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plate`
--

DROP TABLE IF EXISTS `plate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate_name_uk` (`name`),
  KEY `plate_type_id_fk` (`type_id`),
  CONSTRAINT `plate_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plate_well`
--

DROP TABLE IF EXISTS `plate_well`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plate_well` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `replicate_id` int(10) unsigned NOT NULL,
  `plate_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `well` char(10) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate_well_uk` (`plate_id`,`well`),
  KEY `plate_well_replicate_id_fk` (`replicate_id`),
  KEY `plate_well_type_id_fk` (`type_id`),
  CONSTRAINT `plate_well_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `plate_well_plate_id_fk` FOREIGN KEY (`plate_id`) REFERENCES `plate` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `plate_well_replicate_id_fk` FOREIGN KEY (`replicate_id`) REFERENCES `replicate` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plate_well_property`
--

DROP TABLE IF EXISTS `plate_well_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plate_well_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plate_well_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate_well_property_type_uk` (`plate_well_id`,`type_id`),
  KEY `plate_well_property_type_id_fk` (`type_id`),
  KEY `plate_well_property_plate_well_id_fk` (`plate_well_id`),
  CONSTRAINT `plate_well_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `plate_well_property_plate_well_id_fk` FOREIGN KEY (`plate_well_id`) REFERENCES `plate_well` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replicate`
--

DROP TABLE IF EXISTS `replicate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `replicate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `construct_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `replicate_name_uk` (`name`),
  KEY `replicate_construct_id_fk` (`construct_id`),
  KEY `replicate_type_id_fk` (`type_id`),
  CONSTRAINT `replicate_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `replicate_construct_id_fk` FOREIGN KEY (`construct_id`) REFERENCES `construct` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `replicate_property`
--

DROP TABLE IF EXISTS `replicate_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `replicate_property` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `replicate_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `replicate_property_type_uk` (`replicate_id`,`type_id`),
  KEY `replicate_property_type_id_fk` (`type_id`),
  KEY `replicate_property_replicate_id_fk` (`replicate_id`),
  CONSTRAINT `replicate_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `replicate_property_replicate_id_fk` FOREIGN KEY (`replicate_id`) REFERENCES `replicate` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-06-26 16:43:04
