/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- batch
--
DROP TABLE IF EXISTS `batch`;
CREATE TABLE `batch` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL COLLATE latin1_general_cs,
  `alt_name` varchar(767) NULL,
  `comment` text NULL,
  `is_active` tinyint  unsigned NOT NULL,
  `pfa` float  unsigned NULL,
  `process` varchar(255) NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX batch_name_uk_ind USING BTREE ON batch(name);

--
-- line
--
DROP TABLE IF EXISTS `line`;
CREATE TABLE `line` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL COLLATE latin1_general_cs,
  `lab` varchar(100) NOT NULL,
  `batch_id` int unsigned,
  `process` varchar(255) NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `line_batch_id_fk` FOREIGN KEY (`batch_id`) REFERENCES `batch` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX line_name_uk_ind USING BTREE ON line(name,lab,batch_id);
CREATE INDEX line_batch_fk_ind USING BTREE ON line(batch_id);

--
-- event
--
DROP TABLE IF EXISTS `event`;
CREATE TABLE `event` (
  `id` int unsigned NOT NULL auto_increment,
  `item_type` varchar(100) NOT NULL,
  `batch_id` int unsigned,
  `line_id` int unsigned,
  `process` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `operator` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `event_batch_id_fk` FOREIGN KEY (`batch_id`) REFERENCES `batch` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `event_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX event_batch_fk_ind USING BTREE ON event(batch_id);
CREATE INDEX event_line_fk_ind USING BTREE ON event(line_id);
--
-- Table structure for table `event_property`
--

DROP TABLE IF EXISTS `event_property`;
CREATE TABLE `event_property` (
  `id` int unsigned NOT NULL auto_increment,
  `event_id` int unsigned NOT NULL,
  `type` varchar(100) NOT NULL,
  `value` varchar(1000) NOT NULL COLLATE latin1_general_cs,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `event_id_fk` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX event_property_event_fk_ind USING BTREE ON event_property(event_id);
CREATE INDEX event_property_type_ind USING BTREE ON event_property(type);
CREATE INDEX event_property_value_ind USING BTREE ON event_property(value);
CREATE UNIQUE INDEX event_property_type_uk_ind USING BTREE ON event_property(event_id,type);

--
-- slide
--

DROP TABLE IF EXISTS `slide`;
CREATE TABLE `slide` (
  `id` int unsigned NOT NULL auto_increment,
  `label` varchar(100) NOT NULL,
  `batch_id` int unsigned NOT NULL,
  `member` tinyint unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `slide_batch_id_fk` FOREIGN KEY (`batch_id`) REFERENCES `batch` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX slide_batch_fk_ind USING BTREE ON slide(batch_id);

--
-- slot
--

DROP TABLE IF EXISTS `slot`;
CREATE TABLE `slot` (
  `id` int unsigned NOT NULL auto_increment,
  `slide_id` int unsigned NOT NULL,
  `line_id` int unsigned NOT NULL,
  `position` tinyint unsigned NOT NULL,
  `is_redo` tinyint unsigned NOT NULL default 0,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `slot_line_id_fk` FOREIGN KEY (`line_id`) REFERENCES `line` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `slot_slide_id_fk` FOREIGN KEY (`slide_id`) REFERENCES `slide` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX slot_line_fk_ind USING BTREE ON slot(line_id);
CREATE INDEX slot_slide_fk_ind USING BTREE ON slot(slide_id);

-- ============
--
-- process flow module
--
-- ===========

--
-- Table structure for table `process_flow`
--

DROP TABLE IF EXISTS `process_flow`;
CREATE TABLE `process_flow` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE UNIQUE INDEX process_flow_name_uk_ind USING BTREE ON process_flow(name);

--
-- Table structure for table `process_step`
--

DROP TABLE IF EXISTS `process_step`;
CREATE TABLE `process_step` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `process_flow_id` int unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `process_step_process_flow_id_fk` FOREIGN KEY (`process_flow_id`) REFERENCES `process_flow` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE UNIQUE INDEX process_step_name_uk_ind USING BTREE ON process_step(name);
CREATE INDEX process_step_process_flow_fk_ind USING BTREE ON process_step(process_flow_id);

--
-- Table structure for table `process_flow_decision`
--

DROP TABLE IF EXISTS `process_decision`;
CREATE TABLE `process_decision` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `process_step_id` int unsigned NOT NULL,
  `next_process_step_id` int unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `process_decision_process_step_id_fk` FOREIGN KEY (`process_step_id`) REFERENCES `process_step` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `process_decision_next_process_step_id_fk` FOREIGN KEY (`next_process_step_id`) REFERENCES `process_step` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE INDEX process_decision_process_step_fk_ind USING BTREE ON process_decision(process_step_id);
CREATE INDEX process_decision_next_process_step_fk_ind USING BTREE ON process_decision(next_process_step_id);



-- =============
--
-- cv module
-- 
-- =============

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
  CONSTRAINT `cv_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `cv_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `cv` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `cv_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `cv` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX cv_relationship_type_id_fk_ind USING BTREE ON cv_relationship(type_id);
CREATE INDEX cv_relationship_subject_id_fk_ind USING BTREE ON cv_relationship(subject_id);
CREATE INDEX cv_relationship_object_id_fk_ind USING BTREE ON cv_relationship(object_id);
CREATE UNIQUE INDEX cv_relationship_uk_ind USING BTREE ON cv_relationship(type_id,subject_id,object_id);

--
-- Table structure for table `cv_term_relationship`
--

DROP TABLE IF EXISTS `cv_term_relationship`;
CREATE TABLE `cv_term_relationship` (
  `id` int unsigned NOT NULL auto_increment,
  `type_id` int unsigned NOT NULL,
  `subject_id` int unsigned NOT NULL,
  `object_id` int unsigned NOT NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `cv_term_relationship_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `cv_term_relationship_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `cv_term_relationship_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `cv_term` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX cv_term_relationship_type_id_fk_ind USING BTREE ON cv_term_relationship(type_id);
CREATE INDEX cv_term_relationship_subject_id_fk_ind USING BTREE ON cv_term_relationship(subject_id);
CREATE INDEX cv_term_relationship_object_id_fk_ind USING BTREE ON cv_term_relationship(object_id);
CREATE UNIQUE INDEX cv_term_relationship_uk_ind USING BTREE ON cv_term_relationship(type_id,subject_id,object_id);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
