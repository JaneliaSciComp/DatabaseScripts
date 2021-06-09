-- MySQL dump 10.13  Distrib 5.1.35, for apple-darwin9.5.0 (i386)
--
-- Host: mysql2    Database: looger_lemur
-- ------------------------------------------------------
-- Server version	5.0.56sp1-enterprise-gpl-log

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
-- Not dumping tablespaces as no INFORMATION_SCHEMA.FILES table on this server
--

--
-- Table structure for table `constructannos`
--

DROP TABLE IF EXISTS `constructannos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `constructannos` (
  `id` int(11) NOT NULL auto_increment,
  `constructid` int(11) NOT NULL,
  `annotype` varchar(100) NOT NULL,
  `startnucleotide` mediumint(9) NOT NULL,
  `endnucleotide` mediumint(9) NOT NULL,
  `information` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1362 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `constructcategories`
--

DROP TABLE IF EXISTS `constructcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `constructcategories` (
  `id` int(11) NOT NULL auto_increment,
  `categoryname` varchar(255) NOT NULL,
  `categorynumber` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `constructs`
--

DROP TABLE IF EXISTS `constructs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `constructs` (
  `id` int(11) NOT NULL auto_increment,
  `constructname` varchar(100) NOT NULL,
  `sequence` text NOT NULL,
  `vector` varchar(100) NOT NULL,
  `parent` int(11) NOT NULL,
  `categorynumber` int(11) NOT NULL,
  `location` varchar(400) NOT NULL,
  `comments` text NOT NULL,
  `submitter` varchar(255) NOT NULL,
  `dateadded` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labmembers`
--

DROP TABLE IF EXISTS `labmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `labmembers` (
  `id` int(11) NOT NULL auto_increment,
  `firstname` varchar(120) NOT NULL,
  `lastname` varchar(120) NOT NULL,
  `email` varchar(300) NOT NULL,
  `birthday` datetime NOT NULL,
  `cellphone` varchar(100) NOT NULL,
  `janeliaphone` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primerannos`
--

DROP TABLE IF EXISTS `primerannos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `primerannos` (
  `id` int(11) NOT NULL auto_increment,
  `primerid` int(11) NOT NULL,
  `annotype` varchar(100) collate latin1_general_ci NOT NULL,
  `startnucleotide` smallint(6) NOT NULL,
  `endnucleotide` smallint(6) NOT NULL,
  `information` text collate latin1_general_ci NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `primerannos_primerid_fk_ind` (`primerid`),
  CONSTRAINT `primerannos_primerid_fk` FOREIGN KEY (`primerid`) REFERENCES `primers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24425 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primercategories`
--

DROP TABLE IF EXISTS `primercategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `primercategories` (
  `id` int(11) NOT NULL auto_increment,
  `categoryname` varchar(255) collate latin1_general_ci NOT NULL,
  `categorynumber` varchar(2) collate latin1_general_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `primers`
--

DROP TABLE IF EXISTS `primers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `primers` (
  `id` int(11) NOT NULL auto_increment,
  `primername` varchar(20) collate latin1_general_ci NOT NULL,
  `sequence` varchar(500) collate latin1_general_ci NOT NULL,
  `primertype` varchar(1) collate latin1_general_ci NOT NULL,
  `frame` smallint(6) NOT NULL,
  `categorynumber` varchar(2) collate latin1_general_ci NOT NULL,
  `primernumber` int(11) NOT NULL,
  `location` varchar(400) collate latin1_general_ci NOT NULL,
  `comments` text collate latin1_general_ci NOT NULL,
  `submitter` varchar(255) collate latin1_general_ci NOT NULL,
  `dateadded` datetime NOT NULL,
  `dateordered` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6815 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-26 18:22:53
