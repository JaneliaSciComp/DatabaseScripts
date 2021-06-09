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

--
-- queue
--

DROP TABLE IF EXISTS `queue`;
CREATE TABLE `queue` (
  `id` int unsigned NOT NULL auto_increment,
  `line` varchar(767) NOT NULL,
  `effector` varchar(50) NULL,
  `queue_type` varchar(100) NOT NULL,
  `comment` text NULL,
  `priority`  tinyint unsigned NOT NULL,
  `operator` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX queue_uk_ind USING BTREE ON queue(line,effector,queue_type);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
