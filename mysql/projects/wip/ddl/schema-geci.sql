/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- construct
--
DROP TABLE IF EXISTS `construct`;
CREATE TABLE `construct` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(767) NOT NULL COLLATE latin1_general_cs,
  `type` varchar(255) NOT NULL,
  `process` varchar(255) NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX construct USING BTREE ON construct(name,type);

--
-- event
--
DROP TABLE IF EXISTS `event`;
CREATE TABLE `event` (
  `id` int unsigned NOT NULL auto_increment,
  `construct_id` int unsigned,
  `process` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `operator` varchar(255) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `event_construct_id_fk` FOREIGN KEY (`construct_id`) REFERENCES `construct` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX event_construct_fk_ind USING BTREE ON event(construct_id);
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

DROP TABLE IF EXISTS `mapping`;
CREATE TABLE `mapping` (
  `id` int unsigned NOT NULL auto_increment,
  `construct_id` int unsigned NOT NULL,
  `plate` varchar(100) NOT NULL,
  `well_row` tinyint unsigned NOT NULL,
  `well_column` varchar(100) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `mapping_construct_id_fk` FOREIGN KEY (`construct_id`) REFERENCES `construct` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX mapping_construct_fk_ind USING BTREE ON mapping(construct_id);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
