-- MySQL dump 10.9
--
-- Host: db-dev    Database: miva
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
-- Table structure for table `controlled_vocabulary`
--

DROP TABLE IF EXISTS `controlled_vocabulary`;
CREATE TABLE `controlled_vocabulary` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `definition` text NOT NULL,
  `version` tinyint  unsigned NOT NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX cv_name_uk_ind USING BTREE ON controlled_vocabulary(name);


--
-- Table structure for table `controlled_vocabulary_term`
--

DROP TABLE IF EXISTS `controlled_vocabulary_term`;
CREATE TABLE `controlled_vocabulary_term` (
  `id` int unsigned NOT NULL auto_increment,
  `controlled_vocabulary_id` int unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `definition` text NOT NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `controlled_vocabulary_id_fk` FOREIGN KEY (`controlled_vocabulary_id`) REFERENCES `controlled_vocabulary` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX cvterm_name_uk_ind USING BTREE ON controlled_vocabulary_term(name,controlled_vocabulary_id);

--
-- Table structure for table `controlled_vocabulary_relationship`
--

DROP TABLE IF EXISTS `controlled_vocabulary_relationship`;
CREATE TABLE `controlled_vocabulary_relationship` (
  `id` int unsigned NOT NULL auto_increment,
  `type_id` int unsigned NOT NULL,
  `subject_id` int unsigned NOT NULL,
  `object_id` int unsigned NOT NULL,
  `is_current` tinyint  unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX cvrel_uk_ind USING BTREE ON controlled_vocabulary_relationship(type_id,subject_id,object_id);

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
CREATE TABLE `person` (
  `id` int unsigned NOT NULL auto_increment,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) default NULL,
  `email_address` varchar(100) default NULL, 
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX person_name_uk_ind USING BTREE ON person(first_name,last_name,middle_name);

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX project_name_uk_ind USING BTREE ON project(name);

--
-- Table structure for table `project_property`
--

DROP TABLE IF EXISTS `project_property`;
CREATE TABLE `project_property` (
  `id` int unsigned NOT NULL auto_increment,
  `project_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `projectprop_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `projectprop_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX projectprop_uk_ind USING BTREE ON project_property(project_id,type_id);

--
-- Table structure for table `stack`
--

DROP TABLE IF EXISTS `stack`;
CREATE TABLE `stack` (
  `id` int unsigned NOT NULL auto_increment,
  `project_id` int unsigned NOT NULL,
  `name` varchar(767) NOT NULL,
  `location` varchar(767) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `stack_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX stack_name_uk_ind USING BTREE ON stack(name);

--
-- Table structure for table `stack_property`
--

DROP TABLE IF EXISTS `stack_property`;
CREATE TABLE `stack_property` (
  `id` int unsigned NOT NULL auto_increment,
  `stack_id` int unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `stack_id_fk` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `stackprop_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX stackprop_uk_ind USING BTREE ON stack_property(stack_id,type_id);

--
-- Table structure for table `tile`
--

DROP TABLE IF EXISTS `tile`;
CREATE TABLE `tile` (
  `id` int unsigned NOT NULL auto_increment,
  `stack_id` int unsigned NOT NULL,
  `name` varchar(767) NOT NULL,
  `gray_scale_name` varchar(1000) default NULL,
  `segmented_tile_name` varchar(1000) default NULL,
  `traces_name` varchar(1000) default NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tile_stack_id_fk` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX tile_name_uk_ind USING BTREE ON tile(name);

--
-- Table structure for table `tiles`
--

DROP TABLE IF EXISTS `tiles`;
CREATE TABLE `tiles` (
  `id` int unsigned NOT NULL auto_increment,
  `tile_id` int unsigned NOT NULL,
  `region_id` int unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `tiles_tile_id_fk` FOREIGN KEY (`tile_id`) REFERENCES `tile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tiles_region_id_fk` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX tiles_uk_ind USING BTREE ON tiles(tile_id,region_id);

--
-- Table structure for table `superpixel`
--

DROP TABLE IF EXISTS `superpixel`;
CREATE TABLE `superpixel` (
  `id` bigint unsigned NOT NULL auto_increment,
  `identifier` int unsigned NOT NULL,
  `tile_id` int unsigned NOT NULL,
  `body_id` bigint unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `superpixel_tile_id_fk` FOREIGN KEY (`tile_id`) REFERENCES `tile` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `superpixel_body_id_fk` FOREIGN KEY (`body_id`) REFERENCES `body` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX superpixel_uk_ind USING BTREE ON superpixel(identifier,tile_id);

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
CREATE TABLE `region` (
  `id` int unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX region_name_uk_ind USING BTREE ON region(name);

--
-- Table structure for table `body`
--

DROP TABLE IF EXISTS `body`;
CREATE TABLE `body` (
  `id` bigint unsigned NOT NULL auto_increment,
  `identifier` int unsigned NOT NULL,
  `region_id` int unsigned default NULL,
  `volume` float unsigned default NULL,
  `surface` float unsigned default NULL,
  `xmin` double unsigned default NULL,
  `xmax` double unsigned default NULL,
  `ymin` double unsigned default NULL,
  `ymax` double unsigned default NULL,
  `zmin` double unsigned default NULL,
  `zmax` double unsigned default NULL,
  `mesh_image_name` varchar(767) default NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `body_region_id_fk` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX body_uk_ind USING BTREE ON body(identifier,region_id);
CREATE UNIQUE INDEX body_mesh_uk_ind USING BTREE ON body(mesh_image_name);

--
-- Table structure for table `bodies`
--

DROP TABLE IF EXISTS `bodies`;
CREATE TABLE `bodies` (
  `id` bigint unsigned NOT NULL auto_increment,
  `body_id` bigint unsigned NOT NULL,
  `body_set_id` bigint unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  CONSTRAINT `bodies_body_set_id_fk` FOREIGN KEY (`body_set_id`) REFERENCES `body_set` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `bodies_body_id_fk` FOREIGN KEY (`body_id`) REFERENCES `body` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX bodies_uk_ind USING BTREE ON bodies(body_id,body_set_id);

--
-- Table structure for table `body_set`
--

DROP TABLE IF EXISTS `body_set`;
CREATE TABLE `body_set` (
  `id` bigint unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `type_id` int unsigned NOT NULL,
  `mesh_image_name` varchar(767) default NULL,
  `owner_id` int unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `bodyset_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `bodyset_owner_id_fk` FOREIGN KEY (`owner_id`) REFERENCES `person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX body_set_name_uk_ind USING BTREE ON body_set(name);
CREATE UNIQUE INDEX body_set_mesh_uk_ind USING BTREE ON body_set(mesh_image_name);

--
-- Table structure for table `body_set_property`
--

DROP TABLE IF EXISTS `body_set_property`;
CREATE TABLE `body_set_property` (
  `id` bigint unsigned NOT NULL auto_increment,
  `body_set_id` bigint unsigned NOT NULL,
  `type_id` int unsigned NOT NULL,
  `value` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `bodysetprop_body_set_id_fk` FOREIGN KEY (`body_set_id`) REFERENCES `body_set` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `bodysetprop_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX body_set_prop_uk_ind USING BTREE ON body_set_property(body_set_id,type_id);

--
-- Table structure for table `body_set_relationship`
--

DROP TABLE IF EXISTS `body_set_relationship`;
CREATE TABLE `body_set_relationship` (
  `id` bigint unsigned NOT NULL auto_increment,
  `relationship_id` int unsigned NOT NULL,
  `subject_id` bigint unsigned NOT NULL,
  `object_id` bigint unsigned NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `bodysetrel_relationship_id_fk` FOREIGN KEY (`relationship_id`) REFERENCES `controlled_vocabulary_relationship` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `bodysetrel_subject_id_fk` FOREIGN KEY (`subject_id`) REFERENCES `body_set` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `bodysetrel_object_id_fk` FOREIGN KEY (`object_id`) REFERENCES `body_set` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE UNIQUE INDEX body_set_rel_uk_ind USING BTREE ON body_set_relationship(relationship_id,subject_id,object_id);

--
-- Table structure for table `corrections`
--

DROP TABLE IF EXISTS `corrections`;
CREATE TABLE `corrections` (
  `id` bigint unsigned NOT NULL auto_increment,
  `body_set_id` bigint unsigned NOT NULL,
  `proofread_id` bigint unsigned NOT NULL,
  `action` text NOT NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `corrections_body_set_id_fk` FOREIGN KEY (`body_set_id`) REFERENCES `body_set` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION, 
  CONSTRAINT `corrections_proofread_id_fk` FOREIGN KEY (`proofread_id`) REFERENCES `proofread` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `proofread`
--

DROP TABLE IF EXISTS `proofread`;
CREATE TABLE `proofread` (
  `id` bigint unsigned NOT NULL auto_increment,
  `proofreader_id` int unsigned NOT NULL,
  `status_id` int unsigned NOT NULL,  
  `note` text default NULL,
  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  CONSTRAINT `proofread_status_id_fk` FOREIGN KEY (`status_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `proofread_proofreader_id_fk` FOREIGN KEY (`proofreader_id`) REFERENCES `person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Table structure for table `post_synaptic_touch`
--

DROP TABLE IF EXISTS `post_synaptic_touch`;
--CREATE TABLE `post_synaptic_touch` (
--  `id` bigint unsigned NOT NULL auto_increment,
--  `synapse_id` bigint unsigned NOT NULL,
--  `post_synaptic_body_annot_id` bigint unsigned NOT NULL,
--  `post_synaptic_surface` float unsigned default NULL,
--  `post_synaptic_volume` float unsigned default NULL,
--  `gap` float unsigned default NULL,
--  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
--  PRIMARY KEY  (`id`),
--  CONSTRAINT `post_synaptic_touch_synapse_id_fk` FOREIGN KEY (`synapse_id`) REFERENCES `synapse` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION 
--) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `synapse`
--

DROP TABLE IF EXISTS `synapse`;
--CREATE TABLE `synapse` (
--  `id` bigint unsigned NOT NULL auto_increment,
--  `identifier` int unsigned NOT NULL,
--  `type_id` int unsigned NOT NULL,
--  `pre_synaptic_body_annot_id` bigint unsigned NOT NULL,
--  `pre_synaptic_volume` float unsigned default NULL,
--  `pre_synaptic_vesicles` int unsigned default NULL,
--  `create_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
--  PRIMARY KEY  (`id`),
--  CONSTRAINT `synapse_type_id_fk` FOREIGN KEY (`type_id`) REFERENCES `controlled_vocabulary_term` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
--) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

