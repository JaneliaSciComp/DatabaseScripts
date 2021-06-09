-- MySQL dump 10.13  Distrib 5.1.37, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: jira_dev
-- ------------------------------------------------------
-- Server version	5.1.37-log

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
-- Table structure for table `OS_CURRENTSTEP`
--

DROP TABLE IF EXISTS `OS_CURRENTSTEP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OS_CURRENTSTEP` (
  `ID` decimal(18,0) NOT NULL,
  `ENTRY_ID` decimal(18,0) DEFAULT NULL,
  `STEP_ID` decimal(9,0) DEFAULT NULL,
  `ACTION_ID` decimal(9,0) DEFAULT NULL,
  `OWNER` varchar(60) DEFAULT NULL,
  `START_DATE` datetime DEFAULT NULL,
  `DUE_DATE` datetime DEFAULT NULL,
  `FINISH_DATE` datetime DEFAULT NULL,
  `STATUS` varchar(60) DEFAULT NULL,
  `CALLER` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `wf_entryid` (`ENTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OS_CURRENTSTEP`
--

LOCK TABLES `OS_CURRENTSTEP` WRITE;
/*!40000 ALTER TABLE `OS_CURRENTSTEP` DISABLE KEYS */;
/*!40000 ALTER TABLE `OS_CURRENTSTEP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OS_CURRENTSTEP_PREV`
--

DROP TABLE IF EXISTS `OS_CURRENTSTEP_PREV`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OS_CURRENTSTEP_PREV` (
  `ID` decimal(18,0) NOT NULL,
  `PREVIOUS_ID` decimal(18,0) NOT NULL,
  PRIMARY KEY (`ID`,`PREVIOUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OS_CURRENTSTEP_PREV`
--

LOCK TABLES `OS_CURRENTSTEP_PREV` WRITE;
/*!40000 ALTER TABLE `OS_CURRENTSTEP_PREV` DISABLE KEYS */;
/*!40000 ALTER TABLE `OS_CURRENTSTEP_PREV` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OS_HISTORYSTEP`
--

DROP TABLE IF EXISTS `OS_HISTORYSTEP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OS_HISTORYSTEP` (
  `ID` decimal(18,0) NOT NULL,
  `ENTRY_ID` decimal(18,0) DEFAULT NULL,
  `STEP_ID` decimal(9,0) DEFAULT NULL,
  `ACTION_ID` decimal(9,0) DEFAULT NULL,
  `OWNER` varchar(60) DEFAULT NULL,
  `START_DATE` datetime DEFAULT NULL,
  `DUE_DATE` datetime DEFAULT NULL,
  `FINISH_DATE` datetime DEFAULT NULL,
  `STATUS` varchar(60) DEFAULT NULL,
  `CALLER` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OS_HISTORYSTEP`
--

LOCK TABLES `OS_HISTORYSTEP` WRITE;
/*!40000 ALTER TABLE `OS_HISTORYSTEP` DISABLE KEYS */;
/*!40000 ALTER TABLE `OS_HISTORYSTEP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OS_HISTORYSTEP_PREV`
--

DROP TABLE IF EXISTS `OS_HISTORYSTEP_PREV`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OS_HISTORYSTEP_PREV` (
  `ID` decimal(18,0) NOT NULL,
  `PREVIOUS_ID` decimal(18,0) NOT NULL,
  PRIMARY KEY (`ID`,`PREVIOUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OS_HISTORYSTEP_PREV`
--

LOCK TABLES `OS_HISTORYSTEP_PREV` WRITE;
/*!40000 ALTER TABLE `OS_HISTORYSTEP_PREV` DISABLE KEYS */;
/*!40000 ALTER TABLE `OS_HISTORYSTEP_PREV` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OS_WFENTRY`
--

DROP TABLE IF EXISTS `OS_WFENTRY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OS_WFENTRY` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `INITIALIZED` decimal(9,0) DEFAULT NULL,
  `STATE` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OS_WFENTRY`
--

LOCK TABLES `OS_WFENTRY` WRITE;
/*!40000 ALTER TABLE `OS_WFENTRY` DISABLE KEYS */;
/*!40000 ALTER TABLE `OS_WFENTRY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SEQUENCE_VALUE_ITEM`
--

DROP TABLE IF EXISTS `SEQUENCE_VALUE_ITEM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SEQUENCE_VALUE_ITEM` (
  `SEQ_NAME` varchar(60) NOT NULL,
  `SEQ_ID` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`SEQ_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SEQUENCE_VALUE_ITEM`
--

LOCK TABLES `SEQUENCE_VALUE_ITEM` WRITE;
/*!40000 ALTER TABLE `SEQUENCE_VALUE_ITEM` DISABLE KEYS */;
INSERT INTO `SEQUENCE_VALUE_ITEM` VALUES ('Avatar','10020'),('ConfigurationContext','10010'),('FieldConfigScheme','10010'),('FieldConfigSchemeIssueType','10010'),('FieldConfiguration','10010'),('FieldScreen','10000'),('FieldScreenLayoutItem','10020'),('FieldScreenScheme','10000'),('FieldScreenSchemeItem','10010'),('FieldScreenTab','10010'),('GadgetUserPreference','10010'),('GenericConfiguration','10010'),('IssueTypeScreenSchemeEntity','10010'),('ListenerConfig','10010'),('MailServer','10010'),('Notification','10050'),('NotificationScheme','10010'),('OAuthConsumer','10010'),('OptionConfiguration','10010'),('OSGroup','10010'),('OSMembership','10030'),('OSPropertyEntry','10120'),('OSUser','10020'),('PluginVersion','10060'),('PortalPage','10010'),('PortletConfiguration','10010'),('ProjectRole','10010'),('ProjectRoleActor','10010'),('SchemePermissions','10050'),('ServiceConfig','10050'),('SharePermissions','10010'),('UpgradeHistory','10050');
/*!40000 ALTER TABLE `SEQUENCE_VALUE_ITEM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avatar`
--

DROP TABLE IF EXISTS `avatar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `avatar` (
  `ID` decimal(18,0) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `contenttype` varchar(255) DEFAULT NULL,
  `avatartype` varchar(60) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `systemavatar` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `avatar_index` (`avatartype`,`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avatar`
--

LOCK TABLES `avatar` WRITE;
/*!40000 ALTER TABLE `avatar` DISABLE KEYS */;
INSERT INTO `avatar` VALUES ('10000','codegeist.png','image/png','project',NULL,'1'),('10001','eamesbird.png','image/png','project',NULL,'1'),('10002','jm_black.png','image/png','project',NULL,'1'),('10003','jm_brown.png','image/png','project',NULL,'1'),('10004','jm_orange.png','image/png','project',NULL,'1'),('10005','jm_red.png','image/png','project',NULL,'1'),('10006','jm_white.png','image/png','project',NULL,'1'),('10007','jm_yellow.png','image/png','project',NULL,'1'),('10008','monster.png','image/png','project',NULL,'1'),('10009','rainbow.png','image/png','project',NULL,'1'),('10010','kangaroo.png','image/png','project',NULL,'1'),('10011','rocket.png','image/png','project',NULL,'1');
/*!40000 ALTER TABLE `avatar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changegroup`
--

DROP TABLE IF EXISTS `changegroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changegroup` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `chggroup_issue` (`issueid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changegroup`
--

LOCK TABLES `changegroup` WRITE;
/*!40000 ALTER TABLE `changegroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `changegroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changeitem`
--

DROP TABLE IF EXISTS `changeitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changeitem` (
  `ID` decimal(18,0) NOT NULL,
  `groupid` decimal(18,0) DEFAULT NULL,
  `FIELDTYPE` varchar(255) DEFAULT NULL,
  `FIELD` varchar(255) DEFAULT NULL,
  `OLDVALUE` longtext,
  `OLDSTRING` longtext,
  `NEWVALUE` longtext,
  `NEWSTRING` longtext,
  PRIMARY KEY (`ID`),
  KEY `chgitem_chggrp` (`groupid`),
  KEY `chgitem_field` (`FIELD`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changeitem`
--

LOCK TABLES `changeitem` WRITE;
/*!40000 ALTER TABLE `changeitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `changeitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `columnlayout`
--

DROP TABLE IF EXISTS `columnlayout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `columnlayout` (
  `ID` decimal(18,0) NOT NULL,
  `USERNAME` varchar(255) DEFAULT NULL,
  `SEARCHREQUEST` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `columnlayout`
--

LOCK TABLES `columnlayout` WRITE;
/*!40000 ALTER TABLE `columnlayout` DISABLE KEYS */;
/*!40000 ALTER TABLE `columnlayout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `columnlayoutitem`
--

DROP TABLE IF EXISTS `columnlayoutitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `columnlayoutitem` (
  `ID` decimal(18,0) NOT NULL,
  `COLUMNLAYOUT` decimal(18,0) DEFAULT NULL,
  `FIELDIDENTIFIER` varchar(255) DEFAULT NULL,
  `HORIZONTALPOSITION` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `columnlayoutitem`
--

LOCK TABLES `columnlayoutitem` WRITE;
/*!40000 ALTER TABLE `columnlayoutitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `columnlayoutitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `component`
--

DROP TABLE IF EXISTS `component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `component` (
  `ID` decimal(18,0) NOT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `cname` varchar(255) DEFAULT NULL,
  `description` text,
  `URL` varchar(255) DEFAULT NULL,
  `LEAD` varchar(255) DEFAULT NULL,
  `ASSIGNEETYPE` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component`
--

LOCK TABLES `component` WRITE;
/*!40000 ALTER TABLE `component` DISABLE KEYS */;
/*!40000 ALTER TABLE `component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configurationcontext`
--

DROP TABLE IF EXISTS `configurationcontext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configurationcontext` (
  `ID` decimal(18,0) NOT NULL,
  `PROJECTCATEGORY` decimal(18,0) DEFAULT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `customfield` varchar(255) DEFAULT NULL,
  `FIELDCONFIGSCHEME` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `confcontext` (`PROJECTCATEGORY`,`PROJECT`,`customfield`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configurationcontext`
--

LOCK TABLES `configurationcontext` WRITE;
/*!40000 ALTER TABLE `configurationcontext` DISABLE KEYS */;
INSERT INTO `configurationcontext` VALUES ('10000',NULL,NULL,'issuetype','10000');
/*!40000 ALTER TABLE `configurationcontext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customfield`
--

DROP TABLE IF EXISTS `customfield`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customfield` (
  `ID` decimal(18,0) NOT NULL,
  `CUSTOMFIELDTYPEKEY` varchar(255) DEFAULT NULL,
  `CUSTOMFIELDSEARCHERKEY` varchar(255) DEFAULT NULL,
  `cfname` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `defaultvalue` varchar(255) DEFAULT NULL,
  `FIELDTYPE` decimal(18,0) DEFAULT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `ISSUETYPE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customfield`
--

LOCK TABLES `customfield` WRITE;
/*!40000 ALTER TABLE `customfield` DISABLE KEYS */;
/*!40000 ALTER TABLE `customfield` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customfieldoption`
--

DROP TABLE IF EXISTS `customfieldoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customfieldoption` (
  `ID` decimal(18,0) NOT NULL,
  `CUSTOMFIELD` decimal(18,0) DEFAULT NULL,
  `CUSTOMFIELDCONFIG` decimal(18,0) DEFAULT NULL,
  `PARENTOPTIONID` decimal(18,0) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `customvalue` varchar(255) DEFAULT NULL,
  `optiontype` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `cf_cfoption` (`CUSTOMFIELD`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customfieldoption`
--

LOCK TABLES `customfieldoption` WRITE;
/*!40000 ALTER TABLE `customfieldoption` DISABLE KEYS */;
/*!40000 ALTER TABLE `customfieldoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customfieldvalue`
--

DROP TABLE IF EXISTS `customfieldvalue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customfieldvalue` (
  `ID` decimal(18,0) NOT NULL,
  `ISSUE` decimal(18,0) DEFAULT NULL,
  `CUSTOMFIELD` decimal(18,0) DEFAULT NULL,
  `PARENTKEY` varchar(255) DEFAULT NULL,
  `STRINGVALUE` varchar(255) DEFAULT NULL,
  `NUMBERVALUE` decimal(18,6) DEFAULT NULL,
  `TEXTVALUE` longtext,
  `DATEVALUE` datetime DEFAULT NULL,
  `VALUETYPE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `cfvalue_issue` (`ISSUE`,`CUSTOMFIELD`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customfieldvalue`
--

LOCK TABLES `customfieldvalue` WRITE;
/*!40000 ALTER TABLE `customfieldvalue` DISABLE KEYS */;
/*!40000 ALTER TABLE `customfieldvalue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `external_entities`
--

DROP TABLE IF EXISTS `external_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `external_entities` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `entitytype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ext_entity_name` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `external_entities`
--

LOCK TABLES `external_entities` WRITE;
/*!40000 ALTER TABLE `external_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `external_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `externalgadget`
--

DROP TABLE IF EXISTS `externalgadget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `externalgadget` (
  `ID` decimal(18,0) NOT NULL,
  `GADGET_XML` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `externalgadget`
--

LOCK TABLES `externalgadget` WRITE;
/*!40000 ALTER TABLE `externalgadget` DISABLE KEYS */;
/*!40000 ALTER TABLE `externalgadget` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favouriteassociations`
--

DROP TABLE IF EXISTS `favouriteassociations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favouriteassociations` (
  `ID` decimal(18,0) NOT NULL,
  `USERNAME` varchar(255) DEFAULT NULL,
  `entitytype` varchar(60) DEFAULT NULL,
  `entityid` decimal(18,0) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `favourite_index` (`USERNAME`,`entitytype`,`entityid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favouriteassociations`
--

LOCK TABLES `favouriteassociations` WRITE;
/*!40000 ALTER TABLE `favouriteassociations` DISABLE KEYS */;
/*!40000 ALTER TABLE `favouriteassociations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldconfigscheme`
--

DROP TABLE IF EXISTS `fieldconfigscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldconfigscheme` (
  `ID` decimal(18,0) NOT NULL,
  `configname` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `FIELDID` varchar(60) DEFAULT NULL,
  `CUSTOMFIELD` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fcs_fieldid` (`FIELDID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldconfigscheme`
--

LOCK TABLES `fieldconfigscheme` WRITE;
/*!40000 ALTER TABLE `fieldconfigscheme` DISABLE KEYS */;
INSERT INTO `fieldconfigscheme` VALUES ('10000','Default Issue Type Scheme','Default issue type scheme is the list of global issue types. All newly created issue types will automatically be added to this scheme.','issuetype',NULL);
/*!40000 ALTER TABLE `fieldconfigscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldconfigschemeissuetype`
--

DROP TABLE IF EXISTS `fieldconfigschemeissuetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldconfigschemeissuetype` (
  `ID` decimal(18,0) NOT NULL,
  `ISSUETYPE` varchar(255) DEFAULT NULL,
  `FIELDCONFIGSCHEME` decimal(18,0) DEFAULT NULL,
  `FIELDCONFIGURATION` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fcs_issuetype` (`ISSUETYPE`),
  KEY `fcs_scheme` (`FIELDCONFIGSCHEME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldconfigschemeissuetype`
--

LOCK TABLES `fieldconfigschemeissuetype` WRITE;
/*!40000 ALTER TABLE `fieldconfigschemeissuetype` DISABLE KEYS */;
INSERT INTO `fieldconfigschemeissuetype` VALUES ('10001',NULL,'10000','10000');
/*!40000 ALTER TABLE `fieldconfigschemeissuetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldconfiguration`
--

DROP TABLE IF EXISTS `fieldconfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldconfiguration` (
  `ID` decimal(18,0) NOT NULL,
  `configname` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `FIELDID` varchar(60) DEFAULT NULL,
  `CUSTOMFIELD` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fc_fieldid` (`FIELDID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldconfiguration`
--

LOCK TABLES `fieldconfiguration` WRITE;
/*!40000 ALTER TABLE `fieldconfiguration` DISABLE KEYS */;
INSERT INTO `fieldconfiguration` VALUES ('10000','Default Configuration for Issue Type','Default configuration generated by JIRA','issuetype',NULL);
/*!40000 ALTER TABLE `fieldconfiguration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayout`
--

DROP TABLE IF EXISTS `fieldlayout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayout` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `layout_type` varchar(255) DEFAULT NULL,
  `LAYOUTSCHEME` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayout`
--

LOCK TABLES `fieldlayout` WRITE;
/*!40000 ALTER TABLE `fieldlayout` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayoutitem`
--

DROP TABLE IF EXISTS `fieldlayoutitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayoutitem` (
  `ID` decimal(18,0) NOT NULL,
  `FIELDLAYOUT` decimal(18,0) DEFAULT NULL,
  `FIELDIDENTIFIER` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `VERTICALPOSITION` decimal(18,0) DEFAULT NULL,
  `ISHIDDEN` varchar(60) DEFAULT NULL,
  `ISREQUIRED` varchar(60) DEFAULT NULL,
  `RENDERERTYPE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayoutitem`
--

LOCK TABLES `fieldlayoutitem` WRITE;
/*!40000 ALTER TABLE `fieldlayoutitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayoutitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayoutscheme`
--

DROP TABLE IF EXISTS `fieldlayoutscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayoutscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayoutscheme`
--

LOCK TABLES `fieldlayoutscheme` WRITE;
/*!40000 ALTER TABLE `fieldlayoutscheme` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayoutscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayoutschemeassociation`
--

DROP TABLE IF EXISTS `fieldlayoutschemeassociation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayoutschemeassociation` (
  `ID` decimal(18,0) NOT NULL,
  `ISSUETYPE` varchar(255) DEFAULT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `FIELDLAYOUTSCHEME` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fl_scheme_assoc` (`PROJECT`,`ISSUETYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayoutschemeassociation`
--

LOCK TABLES `fieldlayoutschemeassociation` WRITE;
/*!40000 ALTER TABLE `fieldlayoutschemeassociation` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayoutschemeassociation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldlayoutschemeentity`
--

DROP TABLE IF EXISTS `fieldlayoutschemeentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldlayoutschemeentity` (
  `ID` decimal(18,0) NOT NULL,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  `issuetype` varchar(255) DEFAULT NULL,
  `FIELDLAYOUT` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fieldlayout_scheme` (`SCHEME`),
  KEY `fieldlayout_layout` (`FIELDLAYOUT`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldlayoutschemeentity`
--

LOCK TABLES `fieldlayoutschemeentity` WRITE;
/*!40000 ALTER TABLE `fieldlayoutschemeentity` DISABLE KEYS */;
/*!40000 ALTER TABLE `fieldlayoutschemeentity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldscreen`
--

DROP TABLE IF EXISTS `fieldscreen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldscreen` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldscreen`
--

LOCK TABLES `fieldscreen` WRITE;
/*!40000 ALTER TABLE `fieldscreen` DISABLE KEYS */;
INSERT INTO `fieldscreen` VALUES ('1','Default Screen','Allows to update all system fields.'),('2','Workflow Screen','This screen is used in the workflow and enables you to assign issues'),('3','Resolve Issue Screen','Allows to set resolution, change fix versions and assign an issue.');
/*!40000 ALTER TABLE `fieldscreen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldscreenlayoutitem`
--

DROP TABLE IF EXISTS `fieldscreenlayoutitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldscreenlayoutitem` (
  `ID` decimal(18,0) NOT NULL,
  `FIELDIDENTIFIER` varchar(255) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `FIELDSCREENTAB` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fieldscitem_tab` (`FIELDSCREENTAB`),
  KEY `fieldscreen_field` (`FIELDIDENTIFIER`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldscreenlayoutitem`
--

LOCK TABLES `fieldscreenlayoutitem` WRITE;
/*!40000 ALTER TABLE `fieldscreenlayoutitem` DISABLE KEYS */;
INSERT INTO `fieldscreenlayoutitem` VALUES ('10000','summary','0','10000'),('10001','issuetype','1','10000'),('10002','security','2','10000'),('10003','priority','3','10000'),('10004','duedate','4','10000'),('10005','components','5','10000'),('10006','versions','6','10000'),('10007','fixVersions','7','10000'),('10008','assignee','8','10000'),('10009','reporter','9','10000'),('10010','environment','10','10000'),('10011','description','11','10000'),('10012','timetracking','12','10000'),('10013','attachment','13','10000'),('10014','assignee','0','10001'),('10015','resolution','0','10002'),('10016','fixVersions','1','10002'),('10017','assignee','2','10002');
/*!40000 ALTER TABLE `fieldscreenlayoutitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldscreenscheme`
--

DROP TABLE IF EXISTS `fieldscreenscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldscreenscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldscreenscheme`
--

LOCK TABLES `fieldscreenscheme` WRITE;
/*!40000 ALTER TABLE `fieldscreenscheme` DISABLE KEYS */;
INSERT INTO `fieldscreenscheme` VALUES ('1','Default Screen Scheme','Default Screen Scheme');
/*!40000 ALTER TABLE `fieldscreenscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldscreenschemeitem`
--

DROP TABLE IF EXISTS `fieldscreenschemeitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldscreenschemeitem` (
  `ID` decimal(18,0) NOT NULL,
  `OPERATION` decimal(18,0) DEFAULT NULL,
  `FIELDSCREEN` decimal(18,0) DEFAULT NULL,
  `FIELDSCREENSCHEME` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `screenitem_scheme` (`FIELDSCREENSCHEME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldscreenschemeitem`
--

LOCK TABLES `fieldscreenschemeitem` WRITE;
/*!40000 ALTER TABLE `fieldscreenschemeitem` DISABLE KEYS */;
INSERT INTO `fieldscreenschemeitem` VALUES ('10000',NULL,'1','1');
/*!40000 ALTER TABLE `fieldscreenschemeitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldscreentab`
--

DROP TABLE IF EXISTS `fieldscreentab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fieldscreentab` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `FIELDSCREEN` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fieldscreen_tab` (`FIELDSCREEN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldscreentab`
--

LOCK TABLES `fieldscreentab` WRITE;
/*!40000 ALTER TABLE `fieldscreentab` DISABLE KEYS */;
INSERT INTO `fieldscreentab` VALUES ('10000','Field Tab',NULL,'0','1'),('10001','Field Tab',NULL,'0','2'),('10002','Field Tab',NULL,'0','3');
/*!40000 ALTER TABLE `fieldscreentab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fileattachment`
--

DROP TABLE IF EXISTS `fileattachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fileattachment` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `MIMETYPE` varchar(255) DEFAULT NULL,
  `FILENAME` varchar(255) DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `FILESIZE` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `attach_issue` (`issueid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fileattachment`
--

LOCK TABLES `fileattachment` WRITE;
/*!40000 ALTER TABLE `fileattachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `fileattachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filtersubscription`
--

DROP TABLE IF EXISTS `filtersubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filtersubscription` (
  `ID` decimal(18,0) NOT NULL,
  `FILTER_I_D` decimal(18,0) DEFAULT NULL,
  `USERNAME` varchar(60) DEFAULT NULL,
  `groupname` varchar(60) DEFAULT NULL,
  `LAST_RUN` datetime DEFAULT NULL,
  `EMAIL_ON_EMPTY` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `subscrpt_user` (`FILTER_I_D`,`USERNAME`),
  KEY `subscrptn_group` (`FILTER_I_D`,`groupname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filtersubscription`
--

LOCK TABLES `filtersubscription` WRITE;
/*!40000 ALTER TABLE `filtersubscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `filtersubscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gadgetuserpreference`
--

DROP TABLE IF EXISTS `gadgetuserpreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gadgetuserpreference` (
  `ID` decimal(18,0) NOT NULL,
  `PORTLETCONFIGURATION` decimal(18,0) DEFAULT NULL,
  `USERPREFKEY` varchar(255) DEFAULT NULL,
  `USERPREFVALUE` longtext,
  PRIMARY KEY (`ID`),
  KEY `userpref_portletconfiguration` (`PORTLETCONFIGURATION`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gadgetuserpreference`
--

LOCK TABLES `gadgetuserpreference` WRITE;
/*!40000 ALTER TABLE `gadgetuserpreference` DISABLE KEYS */;
INSERT INTO `gadgetuserpreference` VALUES ('10000','10001','keys','__all_projects__'),('10001','10001','isConfigured','true'),('10002','10001','title','Janelia Issue Tracker'),('10003','10001','numofentries','5'),('10004','10002','isConfigured','true'),('10005','10003','isConfigured','true');
/*!40000 ALTER TABLE `gadgetuserpreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genericconfiguration`
--

DROP TABLE IF EXISTS `genericconfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genericconfiguration` (
  `ID` decimal(18,0) NOT NULL,
  `DATATYPE` varchar(60) DEFAULT NULL,
  `DATAKEY` varchar(60) DEFAULT NULL,
  `XMLVALUE` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `type_key` (`DATATYPE`,`DATAKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genericconfiguration`
--

LOCK TABLES `genericconfiguration` WRITE;
/*!40000 ALTER TABLE `genericconfiguration` DISABLE KEYS */;
INSERT INTO `genericconfiguration` VALUES ('10000','DefaultValue','10000','<string>1</string>');
/*!40000 ALTER TABLE `genericconfiguration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupbase`
--

DROP TABLE IF EXISTS `groupbase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groupbase` (
  `ID` decimal(18,0) NOT NULL,
  `groupname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `osgroup_name` (`groupname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupbase`
--

LOCK TABLES `groupbase` WRITE;
/*!40000 ALTER TABLE `groupbase` DISABLE KEYS */;
INSERT INTO `groupbase` VALUES ('10000','jira-administrators'),('10001','jira-developers'),('10002','jira-users');
/*!40000 ALTER TABLE `groupbase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuelink`
--

DROP TABLE IF EXISTS `issuelink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuelink` (
  `ID` decimal(18,0) NOT NULL,
  `LINKTYPE` decimal(18,0) DEFAULT NULL,
  `SOURCE` decimal(18,0) DEFAULT NULL,
  `DESTINATION` decimal(18,0) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `issuelink_src` (`SOURCE`),
  KEY `issuelink_dest` (`DESTINATION`),
  KEY `issuelink_type` (`LINKTYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuelink`
--

LOCK TABLES `issuelink` WRITE;
/*!40000 ALTER TABLE `issuelink` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuelink` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuelinktype`
--

DROP TABLE IF EXISTS `issuelinktype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuelinktype` (
  `ID` decimal(18,0) NOT NULL,
  `LINKNAME` varchar(255) DEFAULT NULL,
  `INWARD` varchar(255) DEFAULT NULL,
  `OUTWARD` varchar(255) DEFAULT NULL,
  `pstyle` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `linktypename` (`LINKNAME`),
  KEY `linktypestyle` (`pstyle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuelinktype`
--

LOCK TABLES `issuelinktype` WRITE;
/*!40000 ALTER TABLE `issuelinktype` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuelinktype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuesecurityscheme`
--

DROP TABLE IF EXISTS `issuesecurityscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuesecurityscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `DEFAULTLEVEL` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuesecurityscheme`
--

LOCK TABLES `issuesecurityscheme` WRITE;
/*!40000 ALTER TABLE `issuesecurityscheme` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuesecurityscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuestatus`
--

DROP TABLE IF EXISTS `issuestatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuestatus` (
  `ID` varchar(60) NOT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `pname` varchar(60) DEFAULT NULL,
  `DESCRIPTION` text,
  `ICONURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuestatus`
--

LOCK TABLES `issuestatus` WRITE;
/*!40000 ALTER TABLE `issuestatus` DISABLE KEYS */;
INSERT INTO `issuestatus` VALUES ('1','1','Open','The issue is open and ready for the assignee to start work on it.','/images/icons/status_open.gif'),('3','3','In Progress','This issue is being actively worked on at the moment by the assignee.','/images/icons/status_inprogress.gif'),('4','4','Reopened','This issue was once resolved, but the resolution was deemed incorrect. From here issues are either marked assigned or resolved.','/images/icons/status_reopened.gif'),('5','5','Resolved','A resolution has been taken, and it is awaiting verification by reporter. From here issues are either reopened, or are closed.','/images/icons/status_resolved.gif'),('6','6','Closed','The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.','/images/icons/status_closed.gif');
/*!40000 ALTER TABLE `issuestatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuetype`
--

DROP TABLE IF EXISTS `issuetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuetype` (
  `ID` varchar(60) NOT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `pname` varchar(60) DEFAULT NULL,
  `pstyle` varchar(60) DEFAULT NULL,
  `DESCRIPTION` text,
  `ICONURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuetype`
--

LOCK TABLES `issuetype` WRITE;
/*!40000 ALTER TABLE `issuetype` DISABLE KEYS */;
INSERT INTO `issuetype` VALUES ('1','1','Bug',NULL,'A problem which impairs or prevents the functions of the product.','/images/icons/bug.gif'),('2','2','New Feature',NULL,'A new feature of the product, which has yet to be developed.','/images/icons/newfeature.gif'),('3','3','Task',NULL,'A task that needs to be done.','/images/icons/task.gif'),('4','4','Improvement',NULL,'An improvement or enhancement to an existing feature or task.','/images/icons/improvement.gif');
/*!40000 ALTER TABLE `issuetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuetypescreenscheme`
--

DROP TABLE IF EXISTS `issuetypescreenscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuetypescreenscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuetypescreenscheme`
--

LOCK TABLES `issuetypescreenscheme` WRITE;
/*!40000 ALTER TABLE `issuetypescreenscheme` DISABLE KEYS */;
INSERT INTO `issuetypescreenscheme` VALUES ('1','Default Issue Type Screen Scheme','The default issue type screen scheme');
/*!40000 ALTER TABLE `issuetypescreenscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuetypescreenschemeentity`
--

DROP TABLE IF EXISTS `issuetypescreenschemeentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuetypescreenschemeentity` (
  `ID` decimal(18,0) NOT NULL,
  `ISSUETYPE` varchar(255) DEFAULT NULL,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  `FIELDSCREENSCHEME` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fieldscreen_scheme` (`FIELDSCREENSCHEME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuetypescreenschemeentity`
--

LOCK TABLES `issuetypescreenschemeentity` WRITE;
/*!40000 ALTER TABLE `issuetypescreenschemeentity` DISABLE KEYS */;
INSERT INTO `issuetypescreenschemeentity` VALUES ('10000',NULL,'1','1');
/*!40000 ALTER TABLE `issuetypescreenschemeentity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jiraaction`
--

DROP TABLE IF EXISTS `jiraaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jiraaction` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL,
  `actiontype` varchar(255) DEFAULT NULL,
  `actionlevel` varchar(255) DEFAULT NULL,
  `rolelevel` decimal(18,0) DEFAULT NULL,
  `actionbody` longtext,
  `CREATED` datetime DEFAULT NULL,
  `UPDATEAUTHOR` varchar(255) DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `actionnum` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `action_issue` (`issueid`,`actiontype`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jiraaction`
--

LOCK TABLES `jiraaction` WRITE;
/*!40000 ALTER TABLE `jiraaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `jiraaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jiradraftworkflows`
--

DROP TABLE IF EXISTS `jiradraftworkflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jiradraftworkflows` (
  `ID` decimal(18,0) NOT NULL,
  `PARENTNAME` varchar(255) DEFAULT NULL,
  `DESCRIPTOR` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jiradraftworkflows`
--

LOCK TABLES `jiradraftworkflows` WRITE;
/*!40000 ALTER TABLE `jiradraftworkflows` DISABLE KEYS */;
/*!40000 ALTER TABLE `jiradraftworkflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jiraeventtype`
--

DROP TABLE IF EXISTS `jiraeventtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jiraeventtype` (
  `ID` decimal(18,0) NOT NULL,
  `TEMPLATE_ID` decimal(18,0) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `event_type` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jiraeventtype`
--

LOCK TABLES `jiraeventtype` WRITE;
/*!40000 ALTER TABLE `jiraeventtype` DISABLE KEYS */;
INSERT INTO `jiraeventtype` VALUES ('1',NULL,'Issue Created','This is the \'issue created\' event.','jira.system.event.type'),('2',NULL,'Issue Updated','This is the \'issue updated\' event.','jira.system.event.type'),('3',NULL,'Issue Assigned','This is the \'issue assigned\' event.','jira.system.event.type'),('4',NULL,'Issue Resolved','This is the \'issue resolved\' event.','jira.system.event.type'),('5',NULL,'Issue Closed','This is the \'issue closed\' event.','jira.system.event.type'),('6',NULL,'Issue Commented','This is the \'issue commented\' event.','jira.system.event.type'),('7',NULL,'Issue Reopened','This is the \'issue reopened\' event.','jira.system.event.type'),('8',NULL,'Issue Deleted','This is the \'issue deleted\' event.','jira.system.event.type'),('9',NULL,'Issue Moved','This is the \'issue moved\' event.','jira.system.event.type'),('10',NULL,'Work Logged On Issue','This is the \'work logged on issue\' event.','jira.system.event.type'),('11',NULL,'Work Started On Issue','This is the \'work started on issue\' event.','jira.system.event.type'),('12',NULL,'Work Stopped On Issue','This is the \'work stopped on issue\' event.','jira.system.event.type'),('13',NULL,'Generic Event','This is the \'generic event\' event.','jira.system.event.type'),('14',NULL,'Issue Comment Edited','This is the \'issue comment edited\' event.','jira.system.event.type'),('15',NULL,'Issue Worklog Updated','This is the \'issue worklog updated\' event.','jira.system.event.type'),('16',NULL,'Issue Worklog Deleted','This is the \'issue worklog deleted\' event.','jira.system.event.type');
/*!40000 ALTER TABLE `jiraeventtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jiraissue`
--

DROP TABLE IF EXISTS `jiraissue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jiraissue` (
  `ID` decimal(18,0) NOT NULL,
  `pkey` varchar(255) DEFAULT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `REPORTER` varchar(255) DEFAULT NULL,
  `ASSIGNEE` varchar(255) DEFAULT NULL,
  `issuetype` varchar(255) DEFAULT NULL,
  `SUMMARY` varchar(255) DEFAULT NULL,
  `DESCRIPTION` longtext,
  `ENVIRONMENT` longtext,
  `PRIORITY` varchar(255) DEFAULT NULL,
  `RESOLUTION` varchar(255) DEFAULT NULL,
  `issuestatus` varchar(255) DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `DUEDATE` datetime DEFAULT NULL,
  `RESOLUTIONDATE` datetime DEFAULT NULL,
  `VOTES` decimal(18,0) DEFAULT NULL,
  `TIMEORIGINALESTIMATE` decimal(18,0) DEFAULT NULL,
  `TIMEESTIMATE` decimal(18,0) DEFAULT NULL,
  `TIMESPENT` decimal(18,0) DEFAULT NULL,
  `WORKFLOW_ID` decimal(18,0) DEFAULT NULL,
  `SECURITY` decimal(18,0) DEFAULT NULL,
  `FIXFOR` decimal(18,0) DEFAULT NULL,
  `COMPONENT` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `issue_key` (`pkey`),
  KEY `issue_proj_status` (`PROJECT`,`issuestatus`),
  KEY `issue_assignee` (`ASSIGNEE`),
  KEY `issue_workflow` (`WORKFLOW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jiraissue`
--

LOCK TABLES `jiraissue` WRITE;
/*!40000 ALTER TABLE `jiraissue` DISABLE KEYS */;
/*!40000 ALTER TABLE `jiraissue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jiraperms`
--

DROP TABLE IF EXISTS `jiraperms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jiraperms` (
  `ID` decimal(18,0) NOT NULL,
  `permtype` decimal(18,0) DEFAULT NULL,
  `projectid` decimal(18,0) DEFAULT NULL,
  `groupname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jiraperms`
--

LOCK TABLES `jiraperms` WRITE;
/*!40000 ALTER TABLE `jiraperms` DISABLE KEYS */;
/*!40000 ALTER TABLE `jiraperms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jiraworkflows`
--

DROP TABLE IF EXISTS `jiraworkflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jiraworkflows` (
  `ID` decimal(18,0) NOT NULL,
  `workflowname` varchar(255) DEFAULT NULL,
  `creatorname` varchar(255) DEFAULT NULL,
  `DESCRIPTOR` longtext,
  `ISLOCKED` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jiraworkflows`
--

LOCK TABLES `jiraworkflows` WRITE;
/*!40000 ALTER TABLE `jiraworkflows` DISABLE KEYS */;
/*!40000 ALTER TABLE `jiraworkflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listenerconfig`
--

DROP TABLE IF EXISTS `listenerconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listenerconfig` (
  `ID` decimal(18,0) NOT NULL,
  `CLAZZ` varchar(255) DEFAULT NULL,
  `listenername` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listenerconfig`
--

LOCK TABLES `listenerconfig` WRITE;
/*!40000 ALTER TABLE `listenerconfig` DISABLE KEYS */;
INSERT INTO `listenerconfig` VALUES ('10000','com.atlassian.jira.event.listeners.cache.IssueCacheListener','Issue Cache Listener'),('10001','com.atlassian.jira.event.listeners.mail.MailListener','Mail Listener'),('10002','com.atlassian.jira.event.listeners.search.IssueIndexListener','Issue Index Listener');
/*!40000 ALTER TABLE `listenerconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mailserver`
--

DROP TABLE IF EXISTS `mailserver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailserver` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `mailfrom` varchar(255) DEFAULT NULL,
  `PREFIX` varchar(60) DEFAULT NULL,
  `smtp_port` varchar(60) DEFAULT NULL,
  `server_type` varchar(60) DEFAULT NULL,
  `SERVERNAME` varchar(255) DEFAULT NULL,
  `JNDILOCATION` varchar(255) DEFAULT NULL,
  `mailusername` varchar(255) DEFAULT NULL,
  `mailpassword` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mailserver`
--

LOCK TABLES `mailserver` WRITE;
/*!40000 ALTER TABLE `mailserver` DISABLE KEYS */;
INSERT INTO `mailserver` VALUES ('10000','Janelia',NULL,'noreply@janelia.hhmi.org','[JIRA]','25','smtp','localhost',NULL,NULL,NULL);
/*!40000 ALTER TABLE `mailserver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membershipbase`
--

DROP TABLE IF EXISTS `membershipbase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `membershipbase` (
  `ID` decimal(18,0) NOT NULL,
  `USER_NAME` varchar(255) DEFAULT NULL,
  `GROUP_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `mshipbase_user` (`USER_NAME`),
  KEY `mshipbase_group` (`GROUP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membershipbase`
--

LOCK TABLES `membershipbase` WRITE;
/*!40000 ALTER TABLE `membershipbase` DISABLE KEYS */;
INSERT INTO `membershipbase` VALUES ('10000','admin','jira-administrators'),('10001','admin','jira-developers'),('10002','admin','jira-users'),('10010','daviesp','jira-users'),('10011','olbrisd','jira-users'),('10012','olbrisd','jira-administrators'),('10013','olbrisd','jira-developers'),('10014','midgleyf','jira-users'),('10015','midgleyf','jira-administrators'),('10016','midgleyf','jira-developers'),('10020','daviesp','jira-developers');
/*!40000 ALTER TABLE `membershipbase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nodeassociation`
--

DROP TABLE IF EXISTS `nodeassociation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nodeassociation` (
  `SOURCE_NODE_ID` decimal(18,0) NOT NULL,
  `SOURCE_NODE_ENTITY` varchar(60) NOT NULL,
  `SINK_NODE_ID` decimal(18,0) NOT NULL,
  `SINK_NODE_ENTITY` varchar(60) NOT NULL,
  `ASSOCIATION_TYPE` varchar(60) NOT NULL,
  `SEQUENCE` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`SOURCE_NODE_ID`,`SOURCE_NODE_ENTITY`,`SINK_NODE_ID`,`SINK_NODE_ENTITY`,`ASSOCIATION_TYPE`),
  KEY `node_source` (`SOURCE_NODE_ID`,`SOURCE_NODE_ENTITY`),
  KEY `node_sink` (`SINK_NODE_ID`,`SINK_NODE_ENTITY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nodeassociation`
--

LOCK TABLES `nodeassociation` WRITE;
/*!40000 ALTER TABLE `nodeassociation` DISABLE KEYS */;
/*!40000 ALTER TABLE `nodeassociation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification` (
  `ID` decimal(18,0) NOT NULL,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  `EVENT` varchar(60) DEFAULT NULL,
  `EVENT_TYPE_ID` decimal(18,0) DEFAULT NULL,
  `TEMPLATE_ID` decimal(18,0) DEFAULT NULL,
  `notif_type` varchar(60) DEFAULT NULL,
  `notif_parameter` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ntfctn_scheme` (`SCHEME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES ('10000','10000',NULL,'1',NULL,'Current_Assignee',NULL),('10001','10000',NULL,'1',NULL,'Current_Reporter',NULL),('10002','10000',NULL,'1',NULL,'All_Watchers',NULL),('10003','10000',NULL,'2',NULL,'Current_Assignee',NULL),('10004','10000',NULL,'2',NULL,'Current_Reporter',NULL),('10005','10000',NULL,'2',NULL,'All_Watchers',NULL),('10006','10000',NULL,'3',NULL,'Current_Assignee',NULL),('10007','10000',NULL,'3',NULL,'Current_Reporter',NULL),('10008','10000',NULL,'3',NULL,'All_Watchers',NULL),('10009','10000',NULL,'4',NULL,'Current_Assignee',NULL),('10010','10000',NULL,'4',NULL,'Current_Reporter',NULL),('10011','10000',NULL,'4',NULL,'All_Watchers',NULL),('10012','10000',NULL,'5',NULL,'Current_Assignee',NULL),('10013','10000',NULL,'5',NULL,'Current_Reporter',NULL),('10014','10000',NULL,'5',NULL,'All_Watchers',NULL),('10015','10000',NULL,'6',NULL,'Current_Assignee',NULL),('10016','10000',NULL,'6',NULL,'Current_Reporter',NULL),('10017','10000',NULL,'6',NULL,'All_Watchers',NULL),('10018','10000',NULL,'7',NULL,'Current_Assignee',NULL),('10019','10000',NULL,'7',NULL,'Current_Reporter',NULL),('10020','10000',NULL,'7',NULL,'All_Watchers',NULL),('10021','10000',NULL,'8',NULL,'Current_Assignee',NULL),('10022','10000',NULL,'8',NULL,'Current_Reporter',NULL),('10023','10000',NULL,'8',NULL,'All_Watchers',NULL),('10024','10000',NULL,'9',NULL,'Current_Assignee',NULL),('10025','10000',NULL,'9',NULL,'Current_Reporter',NULL),('10026','10000',NULL,'9',NULL,'All_Watchers',NULL),('10027','10000',NULL,'10',NULL,'Current_Assignee',NULL),('10028','10000',NULL,'10',NULL,'Current_Reporter',NULL),('10029','10000',NULL,'10',NULL,'All_Watchers',NULL),('10030','10000',NULL,'11',NULL,'Current_Assignee',NULL),('10031','10000',NULL,'11',NULL,'Current_Reporter',NULL),('10032','10000',NULL,'11',NULL,'All_Watchers',NULL),('10033','10000',NULL,'12',NULL,'Current_Assignee',NULL),('10034','10000',NULL,'12',NULL,'Current_Reporter',NULL),('10035','10000',NULL,'12',NULL,'All_Watchers',NULL),('10036','10000',NULL,'13',NULL,'Current_Assignee',NULL),('10037','10000',NULL,'13',NULL,'Current_Reporter',NULL),('10038','10000',NULL,'13',NULL,'All_Watchers',NULL),('10040','10000',NULL,'14',NULL,'Current_Assignee',NULL),('10041','10000',NULL,'14',NULL,'Current_Reporter',NULL),('10042','10000',NULL,'14',NULL,'All_Watchers',NULL),('10043','10000',NULL,'15',NULL,'Current_Assignee',NULL),('10044','10000',NULL,'15',NULL,'Current_Reporter',NULL),('10045','10000',NULL,'15',NULL,'All_Watchers',NULL),('10046','10000',NULL,'16',NULL,'Current_Assignee',NULL),('10047','10000',NULL,'16',NULL,'Current_Reporter',NULL),('10048','10000',NULL,'16',NULL,'All_Watchers',NULL);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificationinstance`
--

DROP TABLE IF EXISTS `notificationinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notificationinstance` (
  `ID` decimal(18,0) NOT NULL,
  `notificationtype` varchar(60) DEFAULT NULL,
  `SOURCE` decimal(18,0) DEFAULT NULL,
  `emailaddress` varchar(255) DEFAULT NULL,
  `MESSAGEID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `notif_source` (`SOURCE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificationinstance`
--

LOCK TABLES `notificationinstance` WRITE;
/*!40000 ALTER TABLE `notificationinstance` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificationinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificationscheme`
--

DROP TABLE IF EXISTS `notificationscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notificationscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificationscheme`
--

LOCK TABLES `notificationscheme` WRITE;
/*!40000 ALTER TABLE `notificationscheme` DISABLE KEYS */;
INSERT INTO `notificationscheme` VALUES ('10000','Default Notification Scheme',NULL);
/*!40000 ALTER TABLE `notificationscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauthconsumer`
--

DROP TABLE IF EXISTS `oauthconsumer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauthconsumer` (
  `ID` decimal(18,0) NOT NULL,
  `CREATED` datetime DEFAULT NULL,
  `consumername` varchar(255) DEFAULT NULL,
  `CONSUMER_KEY` varchar(255) DEFAULT NULL,
  `consumerservice` varchar(255) DEFAULT NULL,
  `PUBLIC_KEY` text,
  `PRIVATE_KEY` text,
  `DESCRIPTION` text,
  `CALLBACK` text,
  `SIGNATURE_METHOD` varchar(60) DEFAULT NULL,
  `SHARED_SECRET` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `oauth_consumer_index` (`CONSUMER_KEY`),
  UNIQUE KEY `oauth_consumer_service_index` (`consumerservice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauthconsumer`
--

LOCK TABLES `oauthconsumer` WRITE;
/*!40000 ALTER TABLE `oauthconsumer` DISABLE KEYS */;
INSERT INTO `oauthconsumer` VALUES ('10000','2010-04-01 15:10:37','Janelia Issue Tracker','jira:13549426','__HOST_SERVICE__','MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBGIGbWiEqfRBqkNakWCaKPQ0JwaOnOS8sZ4aU0GOIn+rckksqRiVQDQ0/0hgowGLkDKP6C+aOa8+Y1BYM3SnzWKMfY1xJseVi88owZormlcM/vmiLfXNpGW6FuWTYeWp+ixulWLENEILYaEmEdZNKfRwglGrt+2f93E4C80hcSwIDAQAB','MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMEYgZtaISp9EGqQ1qRYJoo9DQnBo6c5LyxnhpTQY4if6tySSypGJVANDT/SGCjAYuQMo/oL5o5rz5jUFgzdKfNYox9jXEmx5WLzyjBmiuaVwz++aIt9c2kZboW5ZNh5an6LG6VYsQ0QgthoSYR1k0p9HCCUau37Z/3cTgLzSFxLAgMBAAECgYAWd0x1D7p2IBDt5SYj/uGVCd9feDkbNqsHZpAg9lHuTnTb7uVx6LFkq/ATsdT/wMqAr/vQFtxfS6nepSZfnsfHhVIYR3SRhBXeJ+UiDtzO4jn4OvtaTnZh1HLogejg+GkmC0/gDEzVZkBa5skUOZm7JTuhb7RGiMEppN5Wu/wBoQJBAPY0pmMkRFM/iKcdXAmOKPHtHlVWShMQFJVOUhkFQdtz/rECb/KSyOQIYZC1/6dMyecpwoR6/6NzWSJn5+4aUBsCQQDIxvyO2GdiF9PcftXGArEdpaJ4OiGpNwlZoVPuN861hxYc2IiOJGMGcpG63w81JZvIHQ0BAa79JhWRCkcgFMeRAkAOc8K8mRllpZoY7TFE4lJm+RtJuRn6Cnya0xEgpN1by3BM5a66l4ExWYiYnQZXxLspVZs0eZ/d8VxvF5hWsra3AkBkW0ImTHjwiSR21FcaUIIjZYVePwBQSpg72u3O5spF5i3hYUJwejOdJ2s8Uv6Q/Clvz0WOuT60fnLNOqvulzRhAkBsCKm7/DSJIbJ8Rus0pCcJgCQShiYyv7gYEgzm5V0/6jq1Jzr2yiLRA88Jdyg/F0jLmR8yVkyb4yZDgYfLmx2P','Atlassian JIRA at http://daviesp-ws1:8080/jira',NULL,'RSA_SHA1',NULL);
/*!40000 ALTER TABLE `oauthconsumer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauthconsumertoken`
--

DROP TABLE IF EXISTS `oauthconsumertoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauthconsumertoken` (
  `ID` decimal(18,0) NOT NULL,
  `CREATED` datetime DEFAULT NULL,
  `TOKEN_KEY` varchar(255) DEFAULT NULL,
  `TOKEN` varchar(255) DEFAULT NULL,
  `TOKEN_SECRET` varchar(255) DEFAULT NULL,
  `TOKEN_TYPE` varchar(60) DEFAULT NULL,
  `CONSUMER_KEY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `oauth_consumer_token_key_index` (`TOKEN_KEY`),
  KEY `oauth_consumer_token_index` (`TOKEN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauthconsumertoken`
--

LOCK TABLES `oauthconsumertoken` WRITE;
/*!40000 ALTER TABLE `oauthconsumertoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauthconsumertoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauthspconsumer`
--

DROP TABLE IF EXISTS `oauthspconsumer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauthspconsumer` (
  `ID` decimal(18,0) NOT NULL,
  `CREATED` datetime DEFAULT NULL,
  `CONSUMER_KEY` varchar(255) DEFAULT NULL,
  `consumername` varchar(255) DEFAULT NULL,
  `PUBLIC_KEY` text,
  `DESCRIPTION` text,
  `CALLBACK` text,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `oauth_sp_consumer_index` (`CONSUMER_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauthspconsumer`
--

LOCK TABLES `oauthspconsumer` WRITE;
/*!40000 ALTER TABLE `oauthspconsumer` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauthspconsumer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauthsptoken`
--

DROP TABLE IF EXISTS `oauthsptoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauthsptoken` (
  `ID` decimal(18,0) NOT NULL,
  `CREATED` datetime DEFAULT NULL,
  `TOKEN` varchar(255) DEFAULT NULL,
  `TOKEN_SECRET` varchar(255) DEFAULT NULL,
  `TOKEN_TYPE` varchar(60) DEFAULT NULL,
  `CONSUMER_KEY` varchar(255) DEFAULT NULL,
  `USERNAME` varchar(255) DEFAULT NULL,
  `TTL` decimal(18,0) DEFAULT NULL,
  `spauth` varchar(60) DEFAULT NULL,
  `CALLBACK` text,
  `spverifier` varchar(255) DEFAULT NULL,
  `spversion` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `oauth_sp_token_index` (`TOKEN`),
  KEY `oauth_sp_consumer_key_index` (`CONSUMER_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauthsptoken`
--

LOCK TABLES `oauthsptoken` WRITE;
/*!40000 ALTER TABLE `oauthsptoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauthsptoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `optionconfiguration`
--

DROP TABLE IF EXISTS `optionconfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optionconfiguration` (
  `ID` decimal(18,0) NOT NULL,
  `FIELDID` varchar(60) DEFAULT NULL,
  `OPTIONID` varchar(60) DEFAULT NULL,
  `FIELDCONFIG` decimal(18,0) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fieldid_optionid` (`FIELDID`,`OPTIONID`),
  KEY `fieldid_fieldconf` (`FIELDID`,`FIELDCONFIG`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optionconfiguration`
--

LOCK TABLES `optionconfiguration` WRITE;
/*!40000 ALTER TABLE `optionconfiguration` DISABLE KEYS */;
INSERT INTO `optionconfiguration` VALUES ('10000','issuetype','1','10000','0'),('10001','issuetype','2','10000','1'),('10002','issuetype','3','10000','2'),('10003','issuetype','4','10000','3');
/*!40000 ALTER TABLE `optionconfiguration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissionscheme`
--

DROP TABLE IF EXISTS `permissionscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissionscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissionscheme`
--

LOCK TABLES `permissionscheme` WRITE;
/*!40000 ALTER TABLE `permissionscheme` DISABLE KEYS */;
INSERT INTO `permissionscheme` VALUES ('0','Default Permission Scheme','This is the default Permission Scheme. Any new projects that are created will be assigned this scheme.');
/*!40000 ALTER TABLE `permissionscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pluginversion`
--

DROP TABLE IF EXISTS `pluginversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pluginversion` (
  `ID` decimal(18,0) NOT NULL,
  `pluginname` varchar(255) DEFAULT NULL,
  `pluginkey` varchar(255) DEFAULT NULL,
  `pluginversion` varchar(255) DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pluginversion`
--

LOCK TABLES `pluginversion` WRITE;
/*!40000 ALTER TABLE `pluginversion` DISABLE KEYS */;
INSERT INTO `pluginversion` VALUES ('10000','User Format','jira.user.format','1.0','2010-04-01 13:06:17'),('10001','Gadget Directory Plugin','com.atlassian.gadgets.directory','1.1.2','2010-04-01 13:06:17'),('10002','RPC JIRA Plugin','com.atlassian.jira.ext.rpc','4.0.2-1','2010-04-01 13:06:17'),('10003','Custom Field Types & Searchers','com.atlassian.jira.plugin.system.customfieldtypes','1.0','2010-04-01 13:06:17'),('10004','Atlassian OAuth Consumer SPI','com.atlassian.oauth.atlassian-oauth-consumer-spi-1.0.8','1.0.8','2010-04-01 13:06:17'),('10005','Atlassian OAuth Admin Plugin','com.atlassian.oauth.admin','1.0.8','2010-04-01 13:06:17'),('10006','User Navigation Bar Sections','jira.webfragments.user.navigation.bar','1.0','2010-04-01 13:06:17'),('10007','Issue Tab Panels Plugin','com.atlassian.jira.plugin.system.issuetabpanels','1.0','2010-04-01 13:06:17'),('10008','Embedded Gadgets Plugin','com.atlassian.gadgets.embedded','1.1.2','2010-04-01 13:06:18'),('10009','Renderer Plugin','com.atlassian.jira.plugin.system.jirarenderers','1.0','2010-04-01 13:06:18'),('10010','Shared Application Access Layer JIRA Plugin','com.atlassian.sal.jira','2.0.14.1','2010-04-01 13:06:18'),('10011','JIRA Activity Stream Plugin','com.atlassian.streams.streams-jira-plugin','3.0.14','2010-04-01 13:06:18'),('10012','Shared Application Access Layer API','com.atlassian.sal.sal-api-2.0.14.1','2.0.14.1','2010-04-01 13:06:18'),('10013','Top Navigation Bar','jira.top.navigation.bar','1.0','2010-04-01 13:06:18'),('10014','Gadget Dashboard Plugin','com.atlassian.gadgets.dashboard','1.1.2','2010-04-01 13:06:18'),('10015','Portlets Plugin','com.atlassian.jira.plugin.system.portlets','1.0','2010-04-01 13:06:18'),('10016','Issue Views Plugin','jira.issueviews','1.0','2010-04-01 13:06:18'),('10017','JSON Library','com.atlassian.bundles.json-20070829.0.0.1','20070829.0.0.1','2010-04-01 13:06:18'),('10018','Joda-Time','joda-time-1.6','1.6','2010-04-01 13:06:18'),('10019','Content Link Resolvers Plugin','com.atlassian.jira.plugin.wiki.contentlinkresolvers','1.0','2010-04-01 13:06:18'),('10020','Wiki Renderer Macros Plugin','com.atlassian.jira.plugin.system.renderers.wiki.macros','1.0','2010-04-01 13:06:18'),('10021','Atlassian Template Renderer Velocity 1.6 Plugin','com.atlassian.templaterenderer.atlassian-template-renderer-velocity1.6-plugin','1.0.5','2010-04-01 13:06:18'),('10022','JIRA OAuth Consumer SPI Plugin','com.atlassian.jira.oauth.consumer','4.0.2','2010-04-01 13:06:19'),('10023','JIRA Gadgets Plugin','com.atlassian.jira.gadgets','4.0.2','2010-04-01 13:06:19'),('10024','Atlassian UI Plugin','com.atlassian.auiplugin','1.2.4','2010-04-01 13:06:19'),('10025','JIRA Footer','jira.footer','1.0','2010-04-01 13:06:19'),('10026','Atlassian REST - Module Types','com.atlassian.plugins.rest.atlassian-rest-module','1.0.5','2010-04-01 13:06:19'),('10027','JQL Functions','jira.jql.function','1.0','2010-04-01 13:06:19'),('10028','Admin Menu Sections','jira.webfragments.admin','1.0','2010-04-01 13:06:19'),('10029','Apache HttpClient OSGi bundle','org.apache.httpcomponents.httpclient-4.0','4.0','2010-04-01 13:06:19'),('10030','Atlassian Gadgets OAuth Service Provider Plugin','com.atlassian.gadgets.oauth.serviceprovider','1.1.2','2010-04-01 13:06:19'),('10031','Web Resources Plugin','jira.webresources','1.0','2010-04-01 13:06:19'),('10032','JDOM DOM Processor','com.springsource.org.jdom-1.0.0','1.0.0','2010-04-01 13:06:19'),('10033','Atlassian OAuth Service Provider SPI','com.atlassian.oauth.atlassian-oauth-service-provider-spi-1.0.8','1.0.8','2010-04-01 13:06:19'),('10034','Issue Operations Plugin','com.atlassian.jira.plugin.system.issueoperations','1.0','2010-04-01 13:06:19'),('10035','BND Library','biz.aQute.bndlib-0.0.255','0.0.255','2010-04-01 13:06:19'),('10036','JIRA OAuth Service Provider SPI Plugin','com.atlassian.jira.oauth.serviceprovider','4.0.2','2010-04-01 13:06:19'),('10037','Gadget Renderer Plugin','com.atlassian.gadgets.renderer','1.1.2','2010-04-01 13:06:20'),('10038','Workflow Plugin','com.atlassian.jira.plugin.system.workflow','1.0','2010-04-01 13:06:20'),('10039','Apache HttpCore OSGi bundle','org.apache.httpcomponents.httpcore-4.0','4.0','2010-04-01 13:06:20'),('10040','ICU4J','com.atlassian.bundles.icu4j-3.8.0.1','3.8.0.1','2010-04-01 13:06:20'),('10041','FishEye Plugin','com.atlassian.jirafisheyeplugin','3.0.15','2010-04-01 13:06:20'),('10042','Reports Plugin','com.atlassian.jira.plugin.system.reports','1.0','2010-04-01 13:06:20'),('10043','Renderer Component Factories Plugin','com.atlassian.jira.plugin.wiki.renderercomponentfactories','1.0','2010-04-01 13:06:20'),('10044','ROME: RSS/Atom syndication and publishing tools','com.springsource.com.sun.syndication-0.9.0','0.9.0','2010-04-01 13:06:20'),('10045','Gadget Spec Publisher Plugin','com.atlassian.gadgets.publisher','1.1.2','2010-04-01 13:06:20'),('10046','JIRA REST Plugin','com.atlassian.jira.rest','4.0.2','2010-04-01 13:06:20'),('10047','ROME, RSS and atOM utilitiEs for Java','rome.rome-1.0','1.0','2010-04-01 13:06:20'),('10048','Atlassian Template Renderer API','com.atlassian.templaterenderer.api','1.0.5','2010-04-01 13:06:20'),('10049','Webwork Plugin','com.atlassian.jira.plugin.system.webwork1','1.0','2010-04-01 13:06:20'),('10050','Preset Filters Sections','jira.webfragments.preset.filters','1.0','2010-04-01 13:06:20'),('10051','JIRA Bamboo Plugin','com.atlassian.jira.plugin.ext.bamboo','4.0','2010-04-01 13:06:21'),('10052','User Profile Links','jira.webfragments.user.profile.links','1.0','2010-04-01 13:06:21'),('10053','Neko HTML','com.atlassian.bundles.nekohtml-1.9.12.1','1.9.12.1','2010-04-01 13:06:21'),('10054','Project Panels Plugin','com.atlassian.jira.plugin.system.project','1.0','2010-04-01 13:06:21'),('10055','View Project Operations Sections','jira.webfragments.view.project.operations','1.0','2010-04-01 13:06:21'),('10056','Atlassian OAuth Service Provider Plugin','com.atlassian.oauth.serviceprovider','1.0.8','2010-04-01 13:06:21'),('10057','Atlassian OAuth Consumer Plugin','com.atlassian.oauth.consumer','1.0.8','2010-04-01 13:06:21'),('10058','Project Role Actors Plugin','com.atlassian.jira.plugin.system.projectroleactors','1.0','2010-04-01 13:06:21');
/*!40000 ALTER TABLE `pluginversion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portalpage`
--

DROP TABLE IF EXISTS `portalpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portalpage` (
  `ID` decimal(18,0) NOT NULL,
  `USERNAME` varchar(255) DEFAULT NULL,
  `PAGENAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `FAV_COUNT` decimal(18,0) DEFAULT NULL,
  `LAYOUT` varchar(255) DEFAULT NULL,
  `ppversion` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portalpage`
--

LOCK TABLES `portalpage` WRITE;
/*!40000 ALTER TABLE `portalpage` DISABLE KEYS */;
INSERT INTO `portalpage` VALUES ('10000',NULL,'System Dashboard',NULL,'0','0','AA','0');
/*!40000 ALTER TABLE `portalpage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portletconfiguration`
--

DROP TABLE IF EXISTS `portletconfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portletconfiguration` (
  `ID` decimal(18,0) NOT NULL,
  `PORTALPAGE` decimal(18,0) DEFAULT NULL,
  `PORTLET_ID` varchar(255) DEFAULT NULL,
  `COLUMN_NUMBER` decimal(9,0) DEFAULT NULL,
  `positionseq` decimal(9,0) DEFAULT NULL,
  `GADGET_XML` text,
  `COLOR` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portletconfiguration`
--

LOCK TABLES `portletconfiguration` WRITE;
/*!40000 ALTER TABLE `portletconfiguration` DISABLE KEYS */;
INSERT INTO `portletconfiguration` VALUES ('10000','10000',NULL,'0','0','rest/gadgets/1.0/g/com.atlassian.jira.gadgets:introduction-gadget/gadgets/introduction-gadget.xml',NULL),('10001','10000',NULL,'0','1','rest/gadgets/1.0/g/com.atlassian.streams.streams-jira-plugin:activitystream-gadget/gadgets/activitystream-gadget.xml',NULL),('10002','10000',NULL,'1','0','rest/gadgets/1.0/g/com.atlassian.jira.gadgets:assigned-to-me-gadget/gadgets/assigned-to-me-gadget.xml',NULL),('10003','10000',NULL,'1','1','rest/gadgets/1.0/g/com.atlassian.jira.gadgets:favourite-filters-gadget/gadgets/favourite-filters-gadget.xml',NULL),('10004','10000',NULL,'1','2','rest/gadgets/1.0/g/com.atlassian.jira.gadgets:admin-gadget/gadgets/admin-gadget.xml',NULL);
/*!40000 ALTER TABLE `portletconfiguration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `priority`
--

DROP TABLE IF EXISTS `priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `priority` (
  `ID` varchar(60) NOT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `pname` varchar(60) DEFAULT NULL,
  `DESCRIPTION` text,
  `ICONURL` varchar(255) DEFAULT NULL,
  `STATUS_COLOR` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `priority`
--

LOCK TABLES `priority` WRITE;
/*!40000 ALTER TABLE `priority` DISABLE KEYS */;
INSERT INTO `priority` VALUES ('1','1','Blocker','Blocks development and/or testing work, production could not run.','/images/icons/priority_blocker.gif','#cc0000'),('2','2','Critical','Crashes, loss of data, severe memory leak.','/images/icons/priority_critical.gif','#ff0000'),('3','3','Major','Major loss of function.','/images/icons/priority_major.gif','#009900'),('4','4','Minor','Minor loss of function, or other problem where easy workaround is present.','/images/icons/priority_minor.gif','#006600'),('5','5','Trivial','Cosmetic problem like misspelt words or misaligned text.','/images/icons/priority_trivial.gif','#003300');
/*!40000 ALTER TABLE `priority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `ID` decimal(18,0) NOT NULL,
  `pname` varchar(255) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `LEAD` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `pkey` varchar(255) DEFAULT NULL,
  `pcounter` decimal(18,0) DEFAULT NULL,
  `ASSIGNEETYPE` decimal(18,0) DEFAULT NULL,
  `AVATAR` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectcategory`
--

DROP TABLE IF EXISTS `projectcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projectcategory` (
  `ID` decimal(18,0) NOT NULL,
  `cname` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectcategory`
--

LOCK TABLES `projectcategory` WRITE;
/*!40000 ALTER TABLE `projectcategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectrole`
--

DROP TABLE IF EXISTS `projectrole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projectrole` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectrole`
--

LOCK TABLES `projectrole` WRITE;
/*!40000 ALTER TABLE `projectrole` DISABLE KEYS */;
INSERT INTO `projectrole` VALUES ('10000','Users','A project role that represents users in a project'),('10001','Developers','A project role that represents developers in a project'),('10002','Administrators','A project role that represents administrators in a project');
/*!40000 ALTER TABLE `projectrole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectroleactor`
--

DROP TABLE IF EXISTS `projectroleactor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projectroleactor` (
  `ID` decimal(18,0) NOT NULL,
  `PID` decimal(18,0) DEFAULT NULL,
  `PROJECTROLEID` decimal(18,0) DEFAULT NULL,
  `ROLETYPE` varchar(255) DEFAULT NULL,
  `ROLETYPEPARAMETER` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `role_player_idx` (`PROJECTROLEID`,`PID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectroleactor`
--

LOCK TABLES `projectroleactor` WRITE;
/*!40000 ALTER TABLE `projectroleactor` DISABLE KEYS */;
INSERT INTO `projectroleactor` VALUES ('10000',NULL,'10000','atlassian-group-role-actor','jira-users'),('10001',NULL,'10001','atlassian-group-role-actor','jira-developers'),('10002',NULL,'10002','atlassian-group-role-actor','jira-administrators');
/*!40000 ALTER TABLE `projectroleactor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectversion`
--

DROP TABLE IF EXISTS `projectversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projectversion` (
  `ID` decimal(18,0) NOT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `vname` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `RELEASED` varchar(10) DEFAULT NULL,
  `ARCHIVED` varchar(10) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `RELEASEDATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectversion`
--

LOCK TABLES `projectversion` WRITE;
/*!40000 ALTER TABLE `projectversion` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectversion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertydata`
--

DROP TABLE IF EXISTS `propertydata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertydata` (
  `ID` decimal(18,0) NOT NULL,
  `propertyvalue` blob,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertydata`
--

LOCK TABLES `propertydata` WRITE;
/*!40000 ALTER TABLE `propertydata` DISABLE KEYS */;
/*!40000 ALTER TABLE `propertydata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertydate`
--

DROP TABLE IF EXISTS `propertydate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertydate` (
  `ID` decimal(18,0) NOT NULL,
  `propertyvalue` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertydate`
--

LOCK TABLES `propertydate` WRITE;
/*!40000 ALTER TABLE `propertydate` DISABLE KEYS */;
/*!40000 ALTER TABLE `propertydate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertydecimal`
--

DROP TABLE IF EXISTS `propertydecimal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertydecimal` (
  `ID` decimal(18,0) NOT NULL,
  `propertyvalue` decimal(18,6) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertydecimal`
--

LOCK TABLES `propertydecimal` WRITE;
/*!40000 ALTER TABLE `propertydecimal` DISABLE KEYS */;
/*!40000 ALTER TABLE `propertydecimal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertyentry`
--

DROP TABLE IF EXISTS `propertyentry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertyentry` (
  `ID` decimal(18,0) NOT NULL,
  `ENTITY_NAME` varchar(255) DEFAULT NULL,
  `ENTITY_ID` decimal(18,0) DEFAULT NULL,
  `PROPERTY_KEY` varchar(255) DEFAULT NULL,
  `propertytype` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `osproperty_all` (`ENTITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertyentry`
--

LOCK TABLES `propertyentry` WRITE;
/*!40000 ALTER TABLE `propertyentry` DISABLE KEYS */;
INSERT INTO `propertyentry` VALUES ('10000','jira.properties','1','webwork.i18n.encoding','5'),('10001','BambooServerProperties','1','bamboo.config.version','2'),('10002','jira.properties','1','org.apache.shindig.common.crypto.BlobCrypter:key','5'),('10003','user.format.mapping','1','profileLink','5'),('10004','user.format.mapping','1','fullName','5'),('10005','user.format.mapping','1','profileLinkSearcher','5'),('10006','user.format.mapping','1','profileLinkExternal','5'),('10007','user.format.mapping','1','profileLinkActionHeader','5'),('10008','user.format.mapping','1','fullProfile','5'),('10009','jira.properties','1','jira.i18n.language.index','5'),('10010','jira.properties','1','jira.sid.key','5'),('10011','jira.properties','1','jira.title','5'),('10012','jira.properties','1','jira.baseurl','5'),('10013','jira.properties','1','jira.mode','5'),('10014','jira.properties','1','jira.path.index.use.default.directory','1'),('10015','jira.properties','1','jira.option.indexing','1'),('10016','jira.properties','1','jira.path.attachments','5'),('10017','jira.properties','1','jira.path.attachments.use.default.directory','1'),('10018','jira.properties','1','jira.option.allowattachments','1'),('10019','ServiceConfig','10001','USE_DEFAULT_DIRECTORY','5'),('10020','ServiceConfig','10001','USEZIP','5'),('10021','jira.properties','1','License20','6'),('10022','jira.properties','1','jira.edition','5'),('10023','OSUser','10000','email','5'),('10024','OSUser','10000','fullName','5'),('10025','jira.properties','1','jira.setup','5'),('10026','jira.properties','1','jira.option.allowunassigned','1'),('10027','jira.properties','1','jira.option.user.externalmanagement','1'),('10028','jira.properties','1','jira.option.voting','1'),('10029','jira.properties','1','jira.option.watching','1'),('10030','jira.properties','1','jira.option.issuelinking','1'),('10031','jira.properties','1','jira.option.emailvisible','5'),('10032','jira.properties','1','jira.version.patched','5'),('10035','jira.properties','1','jira.timetracking.days.per.week','5'),('10036','jira.properties','1','jira.timetracking.hours.per.day','5'),('10040','jira.properties','1','jira.scheme.default.issue.type','5'),('10041','jira.properties','1','jira.constant.default.resolution','5'),('10042','jira.properties','1','webwork.multipart.maxSize','5'),('10043','jira.properties','1','jira.avatar.default.id','5'),('10044','OSUser','10000','login.lastLoginMillis','5'),('10045','OSUser','10000','login.count','5'),('10051','fisheye-jira-plugin.properties','1','fisheye.applinks.piggyback.enabled','5'),('10052','OSUser','10000','login.previousLoginMillis','5'),('10061','jira.properties','1','jira.email.fromheader.format','5'),('10062','jira.properties','1','jira.option.captcha.on.signup','1'),('10063','jira.properties','1','jira.option.user.externalpasswordmanagement','1'),('10064','jira.properties','1','jira.option.cache.issues','1'),('10065','jira.properties','1','jira.option.logoutconfirm','5'),('10066','jira.properties','1','jira.option.web.usegzip','1'),('10067','jira.properties','1','jira.option.rpc.allow','1'),('10068','jira.properties','1','jira.option.precedence.header.exclude','1'),('10069','jira.properties','1','jira.comment.level.visibility.groups','1'),('10070','jira.properties','1','jira.ajax.autocomplete.issuepicker.enabled','1'),('10071','jira.properties','1','jira.jql.autocomplete.disabled','1'),('10072','jira.properties','1','jira.attachment.download.mime.sniffing.workaround','5'),('10073','jira.properties','1','jira.lf.logo.url','5'),('10074','jira.properties','1','jira.lf.edit.version','5'),('10075','jira.properties','1','jira.lf.logo.width','5'),('10076','jira.properties','1','jira.lf.logo.height','5'),('10081','jira.properties','1','jira.lf.top.bgcolour','5'),('10082','jira.properties','1','jira.lf.top.textcolour','5'),('10083','jira.properties','1','jira.lf.top.hilightcolour','5'),('10084','jira.properties','1','jira.lf.top.texthilightcolour','5'),('10085','jira.properties','1','jira.lf.menu.bgcolour','5'),('10086','jira.properties','1','jira.lf.text.linkcolour','5'),('10087','jira.properties','1','jira.lf.text.activelinkcolour','5'),('10088','jira.properties','1','jira.lf.text.headingcolour','5'),('10089','jira.properties','1','jira.lf.top.separator.bgcolor','5'),('10090','jira.properties','1','jira.lf.menu.textcolour','5'),('10091','jira.properties','1','jira.lf.menu.separator','5'),('10092','jira.properties','1','jira.lf.gadget.color1','5'),('10093','jira.properties','1','jira.trustedapp.key.private.data','6'),('10094','jira.properties','1','jira.trustedapp.key.public.data','6'),('10095','jira.properties','1','jira.trustedapp.uid','5'),('10096','OSUser','10010','email','5'),('10097','OSUser','10010','fullName','5'),('10098','OSUser','10010','login.lastLoginMillis','5'),('10099','OSUser','10010','login.count','5'),('10100','OSUser','10011','email','5'),('10101','OSUser','10011','fullName','5'),('10102','OSUser','10012','email','5'),('10103','OSUser','10012','fullName','5'),('10110','ServiceConfig','10040','pluginJobName','5'),('10111','OSUser','10010','login.previousLoginMillis','5'),('10112','OSUser','10011','login.lastLoginMillis','5'),('10113','OSUser','10011','login.count','5'),('10114','OSUser','10011','login.previousLoginMillis','5');
/*!40000 ALTER TABLE `propertyentry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertynumber`
--

DROP TABLE IF EXISTS `propertynumber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertynumber` (
  `ID` decimal(18,0) NOT NULL,
  `propertyvalue` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertynumber`
--

LOCK TABLES `propertynumber` WRITE;
/*!40000 ALTER TABLE `propertynumber` DISABLE KEYS */;
INSERT INTO `propertynumber` VALUES ('10001','22'),('10014','1'),('10015','1'),('10017','1'),('10018','1'),('10026','0'),('10027','0'),('10028','1'),('10029','1'),('10030','0'),('10062','0'),('10063','1'),('10064','0'),('10066','0'),('10067','0'),('10068','0'),('10069','0'),('10070','1'),('10071','0');
/*!40000 ALTER TABLE `propertynumber` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertystring`
--

DROP TABLE IF EXISTS `propertystring`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertystring` (
  `ID` decimal(18,0) NOT NULL,
  `propertyvalue` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertystring`
--

LOCK TABLES `propertystring` WRITE;
/*!40000 ALTER TABLE `propertystring` DISABLE KEYS */;
INSERT INTO `propertystring` VALUES ('10000','UTF-8'),('10002','gLE9ydUcOdugeyhgDPoxa4rqj3vbMXXsQdLPBgQRPUE='),('10003','jira.user.format:profile-link-user-format'),('10004','jira.user.format:full-name-user-format'),('10005','jira.user.format:profile-link-searcher-user-format'),('10006','jira.user.format:profile-link-external-user-format'),('10007','jira.user.format:profile-link-action-header-user-format'),('10008','jira.user.format:full-profile-user-format'),('10009','english'),('10010','BS2A-JDY6-ZNIN-5N2Q'),('10011','Janelia Issue Tracker'),('10012','http://daviesp-ws1:8080/jira'),('10013','public'),('10016','/opt/jira/data/attachments'),('10019','true'),('10020','zip'),('10022','enterprise'),('10023','daviesp@janelia.hhmi.org'),('10024','Peter Davies'),('10025','true'),('10031','show'),('10032','472'),('10035','7'),('10036','24'),('10040','10000'),('10041','1'),('10042','10485760'),('10043','10011'),('10044','1270228740380'),('10045','8'),('10051','0'),('10052','1270228103627'),('10061','${fullname} (JIRA)'),('10065','never'),('10072','workaround'),('10073','http://wiki.int.janelia.org/wiki/download/resources/org.janelia.it.confluence.theme.janelia-intranet:janelia-intranet/images/gray_logo.gif'),('10074','26'),('10075','218'),('10076','70'),('10081','#ffffff'),('10082','#666666'),('10083','#ffffff'),('10084','#666666'),('10085','#eeeeee'),('10086','#106A94'),('10087','#106A94'),('10088','#666666'),('10089','#666666'),('10090','#666666'),('10091','#666666'),('10092','#666'),('10095','jira:13549426'),('10096','daviesp@janelia.hhmi.org'),('10097','Peter Davies'),('10098','1270230414856'),('10099','3'),('10100','olbrisd@janelia.hhmi.org'),('10101','Donald Olbris'),('10102','midgleyf@janelia.hhmi.org'),('10103','Frank Midgley'),('10110','Service Provider Token Remover'),('10111','1270228716970'),('10112','1270230381653'),('10113','2'),('10114','1270229093469');
/*!40000 ALTER TABLE `propertystring` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertytext`
--

DROP TABLE IF EXISTS `propertytext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propertytext` (
  `ID` decimal(18,0) NOT NULL,
  `propertyvalue` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertytext`
--

LOCK TABLES `propertytext` WRITE;
/*!40000 ALTER TABLE `propertytext` DISABLE KEYS */;
INSERT INTO `propertytext` VALUES ('10021','AAABIg0ODAoPeNp1kNtOg0AQhu/3KTbxehtAa7QJiQhruk2hlaKJxpuRjmUbuiWzQOzbC8XGQ/Rujt//z5xlRcODirjjctebOFeT82seRhn3HNdhEdqcdFXrvfFnKg1eJly2UDbQV1hIeAwiqNHv54VzIRyPhXtTQ14nsEN/Da1GW91swWCpYVQUOz3a04ZtNcFornM0FuVaHyVkksl0maqVPDFkDLr8H/Jlxq+pwR/Q7FDh0UK4iGOZhiqYD/0Oq1scFsph9hHJ9hCPdXqmRgMmR/leaTp8O27cH7egDRhtB9HpNFZc8NldGg7spNm9Ii3eHmxH9IXLVkgtkor825UXiFn0dCmeE5WIceLds0+nXXeuolP2t+yyobwAi79//QHBMJNKMCwCFEAZQmOb2duXl9IudrkM7SCD6hHOAhRM4lL20eJM4A8EmP9YAckTKxfDBw==X02em'),('10093','MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCDuGvVY86YWNMeKpRv6IUQyxP3+pZppszM64vBsqduP/i93BypfnDx8WWTVwbhEBCX9JQuJtkUFBU5F/+dnDkDVarCzHREA3ysXsb6dXRE3vOuq39sWpt7Z2/vsRbAYqeWQH8mh8gSXa9sQXGiDn9RLOTMLF2r3DLwBVj/TMkAZotT8UnLNrQ8vThs6EAFTiMFO5iMmPYVPdzz9goP+ZGcf/T8xo3CF8NpgZy+mx25WhTzUkXTn5p9UCm/jF0mLprIJNwXhrMLs4ChjwlzVR9xw+08/Ri1/ArmCtrTbB8y7yuc2RU//kY3piRnViy1DrQ5hOHKOHxMj0h0sprRpZlFAgMBAAECggEASX0XDJMGrJDCGM6Ayn7b3qaumWfBi2h4UswHySW3rBcc3DB1/UqCEToxBadEO0UPPPhDxAwAiOc7gAMXpgOG+4lMICqZo2ieojyunwXwvIv3QLiF+xoCLTNkjEItA2EHRxjs175hrX1/ZdKNZ3DXL57wd8k46a2M7cTOBoH8kq/WmHaPvJ8HkZCjikJFBUvrf10HoP1qIVMGiPycKemNAYBs9g2r+PjmcEyqwnQgmhWa5RrluG9j5tQxQ4UoLpmJGFudEDTXApPKXFbkMF2d8K05V/88AWUXWQNsO0a6tvGoCi2HOpK0+1EAZsajlfotej/v+2Gsgtw0lI00IbTPAQKBgQC5+wLFmhJ9QbpEvwWf1TM/Mgz7uCASpAVbhD7Xb+LBdIz3T4ZfT17okSqcD1dKQIJhM0sP0zSPSPRuERdSMyE2hJGIBrVsgtRqlTi9xNrcFR/+NXELGRP8vwPRxpx43rUb0cq1A1vl0P5zDVkJFVlf2rzUlFIugvd8y09kkT+FcQKBgQC1T8QHxLZKhjnygr5rX0m85uwiWNHeYc87s79W4AOb2Rpn22K57Qt5zAYLeRTsU1sDk0pgdoKmc9i4zISzNZTw+rMiBVJjIe5QjRk2Jn9Q5ovVrQAqLJ+9SQj1gtzFPE6uVaU0aEDrfbfFIAYVneAncjUePiZTW1uH/p/W5lqXFQKBgFsBVgDlfKioMgKTyqfEhrgkwK+oEKGueySmGK4JBNePNa+KzYDz8MgyyLvm0dr2qBXyKIfM3MpEc78sQ9IoTNdFlYUPa1V2y4SAEmzh2Aqbl7Un53H7yokB21eaLVUD/XFofh2HUD+rvecEoA3O0ZYTDhWjonc6BOqe/fGDFacxAoGAQCrcu8sYoMNkWrl+3s04cYxgYb+BduyyxPRWcU6SuGNbfwobpKWJ/C8CrKjLiN/vRBKqrf0DPBmfx7dJ94qtDaQMJawwfjkR+JwXIhz5zg3py1OQzVxBpGHms8z+iSdQyU4yS5vh7fXuReuRe7EGFa/LsMpaEgIxIK4yr4GS6gkCgYEAqwDxr5JFpxKZRIN+iARMCKd/vuvDGwFqBsiBpuaZyUOEdePhzVhxb0mrhflIyu+4JEg/Cd/sIjBArIzlDI6AzHPPqQWJUHvI1jQ2xpQ2bQ44+I9NAQ9QoQ4EVeU9ybwlnmXx569zzenFN9MbUPuDLmMcPHJeMf0jjfAK3ylSq3s='),('10094','MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg7hr1WPOmFjTHiqUb+iFEMsT9/qWaabMzOuLwbKnbj/4vdwcqX5w8fFlk1cG4RAQl/SULibZFBQVORf/nZw5A1Wqwsx0RAN8rF7G+nV0RN7zrqt/bFqbe2dv77EWwGKnlkB/JofIEl2vbEFxog5/USzkzCxdq9wy8AVY/0zJAGaLU/FJyza0PL04bOhABU4jBTuYjJj2FT3c8/YKD/mRnH/0/MaNwhfDaYGcvpsduVoU81JF05+afVApv4xdJi6ayCTcF4azC7OAoY8Jc1UfccPtPP0YtfwK5gra02wfMu8rnNkVP/5GN6YkZ1YstQ60OYThyjh8TI9IdLKa0aWZRQIDAQAB');
/*!40000 ALTER TABLE `propertytext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_calendars` (
  `ID` decimal(18,0) DEFAULT NULL,
  `CALENDAR_NAME` varchar(255) NOT NULL,
  `CALENDAR` text,
  PRIMARY KEY (`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_cron_triggers` (
  `ID` decimal(18,0) NOT NULL,
  `trigger_id` decimal(18,0) DEFAULT NULL,
  `cronExperssion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_fired_triggers` (
  `ID` decimal(18,0) DEFAULT NULL,
  `ENTRY_ID` varchar(255) NOT NULL,
  `trigger_id` decimal(18,0) DEFAULT NULL,
  `TRIGGER_LISTENER` varchar(255) DEFAULT NULL,
  `FIRED_TIME` datetime DEFAULT NULL,
  `TRIGGER_STATE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ENTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_job_details` (
  `ID` decimal(18,0) NOT NULL,
  `JOB_NAME` varchar(255) DEFAULT NULL,
  `JOB_GROUP` varchar(255) DEFAULT NULL,
  `CLASS_NAME` varchar(255) DEFAULT NULL,
  `IS_DURABLE` varchar(60) DEFAULT NULL,
  `IS_STATEFUL` varchar(60) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(60) DEFAULT NULL,
  `JOB_DATA` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_listeners`
--

DROP TABLE IF EXISTS `qrtz_job_listeners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_job_listeners` (
  `ID` decimal(18,0) NOT NULL,
  `JOB` decimal(18,0) DEFAULT NULL,
  `JOB_LISTENER` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_listeners`
--

LOCK TABLES `qrtz_job_listeners` WRITE;
/*!40000 ALTER TABLE `qrtz_job_listeners` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_listeners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_simple_triggers` (
  `ID` decimal(18,0) NOT NULL,
  `trigger_id` decimal(18,0) DEFAULT NULL,
  `REPEAT_COUNT` decimal(9,0) DEFAULT NULL,
  `REPEAT_INTERVAL` decimal(18,0) DEFAULT NULL,
  `TIMES_TRIGGERED` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_trigger_listeners`
--

DROP TABLE IF EXISTS `qrtz_trigger_listeners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_trigger_listeners` (
  `ID` decimal(18,0) NOT NULL,
  `trigger_id` decimal(18,0) DEFAULT NULL,
  `TRIGGER_LISTENER` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_trigger_listeners`
--

LOCK TABLES `qrtz_trigger_listeners` WRITE;
/*!40000 ALTER TABLE `qrtz_trigger_listeners` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_trigger_listeners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_triggers` (
  `ID` decimal(18,0) NOT NULL,
  `TRIGGER_NAME` varchar(255) DEFAULT NULL,
  `TRIGGER_GROUP` varchar(255) DEFAULT NULL,
  `JOB` decimal(18,0) DEFAULT NULL,
  `NEXT_FIRE` datetime DEFAULT NULL,
  `TRIGGER_STATE` varchar(255) DEFAULT NULL,
  `TRIGGER_TYPE` varchar(60) DEFAULT NULL,
  `START_TIME` datetime DEFAULT NULL,
  `END_TIME` datetime DEFAULT NULL,
  `CALENDAR_NAME` varchar(255) DEFAULT NULL,
  `MISFIRE_INSTR` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resolution`
--

DROP TABLE IF EXISTS `resolution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resolution` (
  `ID` varchar(60) NOT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL,
  `pname` varchar(60) DEFAULT NULL,
  `DESCRIPTION` text,
  `ICONURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resolution`
--

LOCK TABLES `resolution` WRITE;
/*!40000 ALTER TABLE `resolution` DISABLE KEYS */;
INSERT INTO `resolution` VALUES ('1','1','Fixed','A fix for this issue is checked into the tree and tested.',NULL),('2','2','Won\'t Fix','The problem described is an issue which will never be fixed.',NULL),('3','3','Duplicate','The problem is a duplicate of an existing issue.',NULL),('4','4','Incomplete','The problem is not completely described.',NULL),('5','5','Cannot Reproduce','All attempts at reproducing this issue failed, or not enough information was available to reproduce the issue. Reading the code produces no clues as to why this behavior would occur. If more information appears later, please reopen the issue.',NULL);
/*!40000 ALTER TABLE `resolution` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schemeissuesecurities`
--

DROP TABLE IF EXISTS `schemeissuesecurities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schemeissuesecurities` (
  `ID` decimal(18,0) NOT NULL,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  `SECURITY` decimal(18,0) DEFAULT NULL,
  `sec_type` varchar(255) DEFAULT NULL,
  `sec_parameter` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `sec_scheme` (`SCHEME`),
  KEY `sec_security` (`SECURITY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schemeissuesecurities`
--

LOCK TABLES `schemeissuesecurities` WRITE;
/*!40000 ALTER TABLE `schemeissuesecurities` DISABLE KEYS */;
/*!40000 ALTER TABLE `schemeissuesecurities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schemeissuesecuritylevels`
--

DROP TABLE IF EXISTS `schemeissuesecuritylevels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schemeissuesecuritylevels` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schemeissuesecuritylevels`
--

LOCK TABLES `schemeissuesecuritylevels` WRITE;
/*!40000 ALTER TABLE `schemeissuesecuritylevels` DISABLE KEYS */;
/*!40000 ALTER TABLE `schemeissuesecuritylevels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schemepermissions`
--

DROP TABLE IF EXISTS `schemepermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schemepermissions` (
  `ID` decimal(18,0) NOT NULL,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  `PERMISSION` decimal(18,0) DEFAULT NULL,
  `perm_type` varchar(255) DEFAULT NULL,
  `perm_parameter` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `prmssn_scheme` (`SCHEME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schemepermissions`
--

LOCK TABLES `schemepermissions` WRITE;
/*!40000 ALTER TABLE `schemepermissions` DISABLE KEYS */;
INSERT INTO `schemepermissions` VALUES ('10000',NULL,'0','group','jira-administrators'),('10001',NULL,'1','group','jira-users'),('10002',NULL,'27','group','jira-developers'),('10003',NULL,'24','group','jira-developers'),('10004','0','23','projectrole','10002'),('10005','0','10','projectrole','10000'),('10006','0','11','projectrole','10000'),('10007','0','15','projectrole','10000'),('10008','0','19','projectrole','10000'),('10009','0','13','projectrole','10001'),('10010','0','17','projectrole','10001'),('10011','0','14','projectrole','10001'),('10012','0','21','projectrole','10001'),('10013','0','12','projectrole','10001'),('10014','0','16','projectrole','10002'),('10015','0','18','projectrole','10001'),('10016','0','25','projectrole','10001'),('10017','0','28','projectrole','10001'),('10018','0','30','projectrole','10002'),('10019','0','20','projectrole','10001'),('10020','0','43','projectrole','10002'),('10021','0','42','projectrole','10000'),('10022','0','41','projectrole','10001'),('10023','0','40','projectrole','10000'),('10024','0','31','projectrole','10001'),('10025','0','32','projectrole','10002'),('10026','0','34','projectrole','10001'),('10027','0','35','projectrole','10000'),('10028','0','36','projectrole','10002'),('10029','0','37','projectrole','10000'),('10030','0','38','projectrole','10002'),('10031','0','39','projectrole','10000'),('10032',NULL,'22','group','jira-users'),('10033','0','29','projectrole','10001'),('10040',NULL,'33','group','jira-users'),('10041',NULL,'44','group','jira-administrators');
/*!40000 ALTER TABLE `schemepermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `searchrequest`
--

DROP TABLE IF EXISTS `searchrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `searchrequest` (
  `ID` decimal(18,0) NOT NULL,
  `filtername` varchar(255) DEFAULT NULL,
  `authorname` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `username` varchar(255) DEFAULT NULL,
  `groupname` varchar(255) DEFAULT NULL,
  `projectid` decimal(18,0) DEFAULT NULL,
  `reqcontent` longtext,
  `FAV_COUNT` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `sr_author` (`authorname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `searchrequest`
--

LOCK TABLES `searchrequest` WRITE;
/*!40000 ALTER TABLE `searchrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `searchrequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serviceconfig`
--

DROP TABLE IF EXISTS `serviceconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serviceconfig` (
  `ID` decimal(18,0) NOT NULL,
  `delaytime` decimal(18,0) DEFAULT NULL,
  `CLAZZ` varchar(255) DEFAULT NULL,
  `servicename` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serviceconfig`
--

LOCK TABLES `serviceconfig` WRITE;
/*!40000 ALTER TABLE `serviceconfig` DISABLE KEYS */;
INSERT INTO `serviceconfig` VALUES ('10000','60000','com.atlassian.jira.service.services.mail.MailQueueService','Mail Queue Service'),('10001','43200000','com.atlassian.jira.service.services.export.ExportService','Backup Service'),('10040','28800000','com.atlassian.sal.jira.scheduling.JiraPluginSchedulerService','Service Provider Token Remover');
/*!40000 ALTER TABLE `serviceconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sharepermissions`
--

DROP TABLE IF EXISTS `sharepermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sharepermissions` (
  `ID` decimal(18,0) NOT NULL,
  `entityid` decimal(18,0) DEFAULT NULL,
  `entitytype` varchar(60) DEFAULT NULL,
  `sharetype` varchar(10) DEFAULT NULL,
  `PARAM1` varchar(255) DEFAULT NULL,
  `PARAM2` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `share_index` (`entityid`,`entitytype`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sharepermissions`
--

LOCK TABLES `sharepermissions` WRITE;
/*!40000 ALTER TABLE `sharepermissions` DISABLE KEYS */;
INSERT INTO `sharepermissions` VALUES ('10000','10000','PortalPage','global',NULL,NULL);
/*!40000 ALTER TABLE `sharepermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trackback_ping`
--

DROP TABLE IF EXISTS `trackback_ping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trackback_ping` (
  `ID` decimal(18,0) NOT NULL,
  `ISSUE` decimal(18,0) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `TITLE` varchar(255) DEFAULT NULL,
  `BLOGNAME` varchar(255) DEFAULT NULL,
  `EXCERPT` varchar(255) DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackback_ping`
--

LOCK TABLES `trackback_ping` WRITE;
/*!40000 ALTER TABLE `trackback_ping` DISABLE KEYS */;
/*!40000 ALTER TABLE `trackback_ping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trustedapp`
--

DROP TABLE IF EXISTS `trustedapp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trustedapp` (
  `ID` decimal(18,0) NOT NULL,
  `APPLICATION_ID` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `PUBLIC_KEY` text,
  `IP_MATCH` text,
  `URL_MATCH` text,
  `TIMEOUT` decimal(18,0) DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `trustedapp_id` (`APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trustedapp`
--

LOCK TABLES `trustedapp` WRITE;
/*!40000 ALTER TABLE `trustedapp` DISABLE KEYS */;
/*!40000 ALTER TABLE `trustedapp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upgradehistory`
--

DROP TABLE IF EXISTS `upgradehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upgradehistory` (
  `ID` decimal(18,0) DEFAULT NULL,
  `UPGRADECLASS` varchar(255) NOT NULL,
  PRIMARY KEY (`UPGRADECLASS`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upgradehistory`
--

LOCK TABLES `upgradehistory` WRITE;
/*!40000 ALTER TABLE `upgradehistory` DISABLE KEYS */;
INSERT INTO `upgradehistory` VALUES ('10001','com.atlassian.jira.upgrade.tasks.professional.UpgradeTask1_2_1'),('10000','com.atlassian.jira.upgrade.tasks.UpgradeTask1_2'),('10002','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build10'),('10021','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build101'),('10022','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build102'),('10003','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build11'),('10023','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build130'),('10024','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build132'),('10025','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build150'),('10026','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build151'),('10027','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build152'),('10028','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build175'),('10029','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build176'),('10030','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build205'),('10031','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build207'),('10032','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build257'),('10033','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build258'),('10004','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build27'),('10034','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build296'),('10035','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build317'),('10036','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build325'),('10037','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build326'),('10005','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build35'),('10038','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build412'),('10039','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build418'),('10040','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build437'),('10041','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build438'),('10006','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build47'),('10007','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build48'),('10008','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build51'),('10009','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build56'),('10010','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build60'),('10020','com.atlassian.jira.upgrade.tasks.UpgradeTask_Build83');
/*!40000 ALTER TABLE `upgradehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userassociation`
--

DROP TABLE IF EXISTS `userassociation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userassociation` (
  `SOURCE_NAME` varchar(60) NOT NULL,
  `SINK_NODE_ID` decimal(18,0) NOT NULL,
  `SINK_NODE_ENTITY` varchar(60) NOT NULL,
  `ASSOCIATION_TYPE` varchar(60) NOT NULL,
  `SEQUENCE` decimal(9,0) DEFAULT NULL,
  PRIMARY KEY (`SOURCE_NAME`,`SINK_NODE_ID`,`SINK_NODE_ENTITY`,`ASSOCIATION_TYPE`),
  KEY `user_source` (`SOURCE_NAME`),
  KEY `user_sink` (`SINK_NODE_ID`,`SINK_NODE_ENTITY`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userassociation`
--

LOCK TABLES `userassociation` WRITE;
/*!40000 ALTER TABLE `userassociation` DISABLE KEYS */;
/*!40000 ALTER TABLE `userassociation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userbase`
--

DROP TABLE IF EXISTS `userbase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userbase` (
  `ID` decimal(18,0) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `PASSWORD_HASH` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `osuser_name` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userbase`
--

LOCK TABLES `userbase` WRITE;
/*!40000 ALTER TABLE `userbase` DISABLE KEYS */;
INSERT INTO `userbase` VALUES ('10000','admin','uQ8MxA4ydF1+fxXHcbPc/vX0hEFeGqc5kirLjSoPfp9w+3rjflTGn1uC//2aGZX/M5+pdGczdyvD58JQ8EZtzw=='),('10010','daviesp','ZB7Zlsy2y3s4rT+y9DKCRSepzzlCNoBpNVj6zewjKeXA0Bv8/iK6qiRjszcPmuoT8Vwi9WTTxpbKr5G8P1weMw=='),('10011','olbrisd','yQXfJTJqH6acPOoWtPhaDPkp8WDyTN0UT07eBeg1wGtVVHixuEusfdTuCvTNLDV4uBbhwRsxjXa+o5/AEeR1DA=='),('10012','midgleyf','Ctf/oIaY6v6cPH1No1TcjonifOIfJ1sm70YdrctIp/fZX+vwrzfGq0w155FaG8gwS/WFZQUjkPDuartcBEUBEg==');
/*!40000 ALTER TABLE `userbase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userhistoryitem`
--

DROP TABLE IF EXISTS `userhistoryitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userhistoryitem` (
  `ID` decimal(18,0) NOT NULL,
  `entitytype` varchar(10) DEFAULT NULL,
  `entityid` varchar(60) DEFAULT NULL,
  `USERNAME` varchar(255) DEFAULT NULL,
  `lastviewed` decimal(18,0) DEFAULT NULL,
  `data` longtext,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uh_type_user_entity` (`entitytype`,`USERNAME`,`entityid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userhistoryitem`
--

LOCK TABLES `userhistoryitem` WRITE;
/*!40000 ALTER TABLE `userhistoryitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `userhistoryitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versioncontrol`
--

DROP TABLE IF EXISTS `versioncontrol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versioncontrol` (
  `ID` decimal(18,0) NOT NULL,
  `vcsname` varchar(255) DEFAULT NULL,
  `vcsdescription` varchar(255) DEFAULT NULL,
  `vcstype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versioncontrol`
--

LOCK TABLES `versioncontrol` WRITE;
/*!40000 ALTER TABLE `versioncontrol` DISABLE KEYS */;
/*!40000 ALTER TABLE `versioncontrol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflowscheme`
--

DROP TABLE IF EXISTS `workflowscheme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflowscheme` (
  `ID` decimal(18,0) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflowscheme`
--

LOCK TABLES `workflowscheme` WRITE;
/*!40000 ALTER TABLE `workflowscheme` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflowscheme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflowschemeentity`
--

DROP TABLE IF EXISTS `workflowschemeentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflowschemeentity` (
  `ID` decimal(18,0) NOT NULL,
  `SCHEME` decimal(18,0) DEFAULT NULL,
  `WORKFLOW` varchar(255) DEFAULT NULL,
  `issuetype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `workflow_scheme` (`SCHEME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflowschemeentity`
--

LOCK TABLES `workflowschemeentity` WRITE;
/*!40000 ALTER TABLE `workflowschemeentity` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflowschemeentity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worklog`
--

DROP TABLE IF EXISTS `worklog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worklog` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) DEFAULT NULL,
  `grouplevel` varchar(255) DEFAULT NULL,
  `rolelevel` decimal(18,0) DEFAULT NULL,
  `worklogbody` longtext,
  `CREATED` datetime DEFAULT NULL,
  `UPDATEAUTHOR` varchar(255) DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `timeworked` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `worklog_issue` (`issueid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worklog`
--

LOCK TABLES `worklog` WRITE;
/*!40000 ALTER TABLE `worklog` DISABLE KEYS */;
/*!40000 ALTER TABLE `worklog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'jira_dev'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-05 14:44:39
