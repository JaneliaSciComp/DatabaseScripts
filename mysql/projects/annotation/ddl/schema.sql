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
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int unsigned NOT NULL auto_increment,
  `uri` varchar(767) NOT NULL,
  `name` varchar(767) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX project_uri_uk_ind USING BTREE ON project(uri);

DROP TABLE IF EXISTS `property_set`;
CREATE TABLE `property_set` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL,
  `project_id` int unsigned NOT NULL,
  `ontology_id` int unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `property_set_ontology_id_fk` FOREIGN KEY (`ontology_id`) REFERENCES `cv` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `property_set_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX property_set_project_id_fk_ind USING BTREE ON property_set(project_id);
CREATE INDEX property_set_ontology_id_fk_ind USING BTREE ON property_set(ontology_id);


DROP TABLE IF EXISTS `property`;
CREATE TABLE `property` (
  `id` int unsigned NOT NULL auto_increment,
  `property_set_id` int unsigned NOT NULL,
  `term_id` int unsigned NOT NULL,
  `embedded_property_set_id` int unsigned NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `property_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `property_property_set_id_fk` FOREIGN KEY (`property_set_id`) REFERENCES `property_set` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `property_embedded_property_set_id_fk` FOREIGN KEY (`embedded_property_set_id`) REFERENCES `property_set` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX property_term_id_fk_ind USING BTREE ON property(term_id);
CREATE INDEX property_property_set_id_fk_ind USING BTREE ON property(property_set_id);
CREATE INDEX property_embedded_property_set_id_fk_ind USING BTREE ON property(embedded_property_set_id);


DROP TABLE IF EXISTS `property_constraint`;
CREATE TABLE `property_constraint` (
  `id` int unsigned NOT NULL auto_increment,
  `property_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `property_constraint_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `property_constraint_property_id_fk` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX property_constraint_property_id_fk_ind USING BTREE ON property_constraint(property_id);
CREATE INDEX property_constraint_type_id_fk_ind USING BTREE ON property_constraint(type_id);

DROP TABLE IF EXISTS `line`;
CREATE TABLE `line` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL COLLATE latin1_general_cs,
  `lab` varchar(100) NOT NULL,
  `source_lab` varchar(100) NOT NULL,
  `gene` varchar(767) NULL,
  `sequence` text NULL,
  `comment` text NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX line_name_uk_ind USING BTREE ON line(name);

--
-- Table structure for table `line_property`
--

DROP TABLE IF EXISTS `line_property`;
CREATE TABLE `line_property` (
  `id` int unsigned NOT NULL auto_increment,
  `line_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `line_property_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `line_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX line_property_type_uk_ind USING BTREE ON line_property(type_id,line_id);
CREATE INDEX line_property_line_id_fk_ind USING BTREE ON line_property(line_id);
CREATE INDEX line_property_type_id_fk_ind USING BTREE ON line_property(type_id);

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL,
  `type_id` int unsigned NOT NULL,
  `line_id` int unsigned NOT NULL,
  `annotator` varchar(255) NOT NULL default '',
  `lab` varchar(255) NOT NULL default '',
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `session_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `session_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX session_type_uk_ind USING BTREE ON session(name,type_id);
CREATE INDEX session_line_id_fk_ind USING BTREE ON session(line_id);
CREATE INDEX session_type_id_fk_ind USING BTREE ON session(type_id);

--
-- Table structure for table `session_property`
--

DROP TABLE IF EXISTS `session_property`;
CREATE TABLE `session_property` (
  `id` int unsigned NOT NULL auto_increment,
  `session_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `session_property_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `session_property_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX session_property_type_uk_ind USING BTREE ON session_property(type_id,session_id);
CREATE INDEX session_property_session_id_fk_ind USING BTREE ON session_property(session_id);
CREATE INDEX session_property_type_id_fk_ind USING BTREE ON session_property(type_id);

--
-- Table structure for table `observation`
--

DROP TABLE IF EXISTS `observation`;
CREATE TABLE `observation` (
  `id` int unsigned NOT NULL auto_increment,
  `session_id` int unsigned NOT NULL,
  `term_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `observation_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `observation_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `observation_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX observation_type_uk_ind USING BTREE ON observation(type_id,session_id,term_id);
CREATE INDEX observation_session_id_fk_ind USING BTREE ON observation(session_id);
CREATE INDEX observation_type_id_fk_ind USING BTREE ON observation(type_id);


--
-- Table structure for table `score`
--

DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` int unsigned NOT NULL auto_increment,
  `session_id` int unsigned NOT NULL,
  `term_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` double signed NOT NULL, 
  `run` int unsigned NOT NULL default 0,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `score_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `score_term_id_fk` FOREIGN KEY (`term_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `score_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX score_run_uk_ind USING BTREE ON score(session_id,type_id,run,term_id);
CREATE INDEX score_session_id_fk_ind USING BTREE ON score(session_id);
CREATE INDEX score_type_id_fk_ind USING BTREE ON score(type_id);

--
-- Table structure for table `cv`
--

DROP TABLE IF EXISTS `cv`;
CREATE TABLE `cv` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `definition` text NULL,
  `version` tinyint  unsigned NOT NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX cv_name_uk_ind USING BTREE ON cv(name);

--
-- Table structure for table `cv_term`
--

DROP TABLE IF EXISTS `cv_term`;
CREATE TABLE `cv_term` (
  `id` int unsigned NOT NULL auto_increment,
  `cv_id` int unsigned NOT NULL,
  `name` varchar(255) NOT NULL COLLATE latin1_general_cs,
  `definition` text NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `display_name` varchar(255) NULL,
  `data_type` varchar(255) NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `cv_term_cv_id_fk` FOREIGN KEY (`cv_id`) REFERENCES `cv` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX cv_term_cv_id_fk_ind USING BTREE ON cv_term(cv_id);
CREATE UNIQUE INDEX cv_term_name_uk_ind USING BTREE ON cv_term(cv_id,name);

--
-- Table structure for table `cv_relationship`
--

DROP TABLE IF EXISTS `cv_relationship`;
CREATE TABLE `cv_relationship` (
  `id` int unsigned NOT NULL auto_increment,
  `type_id` int unsigned NOT NULL,
  `subject_id` int unsigned NOT NULL,
  `object_id` int unsigned NOT NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX cv_relationship_type_id_fk_ind USING BTREE ON cv_relationship(type_id);
CREATE INDEX cv_relationship_subject_id_fk_ind USING BTREE ON cv_relationship(subject_id);
CREATE INDEX cv_relationship_object_id_fk_ind USING BTREE ON cv_relationship(object_id);
CREATE UNIQUE INDEX cv_relationship_uk_ind USING BTREE ON cv_relationship(type_id,subject_id,object_id);

--
-- Table structure for table `annotation_symbol`
--

DROP TABLE IF EXISTS `annotation_symbol`;
CREATE TABLE `annotation_symbol` (
  `id` int unsigned NOT NULL auto_increment,
  `annotation_symbol` varchar(255) NOT NULL,
  `symbol` varchar(255) NOT NULL,
   PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX annotation_symbol_annotation_symbol_ind USING BTREE ON annotation_symbol(annotation_symbol);
CREATE INDEX annotation_symbol_symbol_ind USING BTREE ON annotation_symbol(symbol);


--
-- Table structure for table `audit_trail`
--

CREATE TABLE audit_trail (
  id BIGINT NOT NULL AUTO_INCREMENT,
  table_name  VARCHAR(50) NOT NULL,
  column_name VARCHAR(50) NOT NULL,
  data_type   VARCHAR(50) NOT NULL,
  primary_identifier BIGINT NOT NULL,
  old_value   text,
  new_value   text,
  modify_date timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY(id)
) ENGINE INNODB;

CREATE INDEX audit_trail_table_name_ind USING BTREE ON audit_trail(table_name);
CREATE INDEX audit_trail_primary_identifier_ind USING BTREE ON audit_trail(primary_identifier);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
