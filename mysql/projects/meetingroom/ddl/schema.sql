-- MySQL dump 10.9
--
-- Host: mysql1    Database: scheduleit
-- ------------------------------------------------------
-- Server version	5.0.56sp1-enterprise-gpl-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `additional_resources`
--

DROP TABLE IF EXISTS `additional_resources`;
CREATE TABLE `additional_resources` (
  `resourceid` char(16) NOT NULL,
  `name` varchar(75) NOT NULL,
  `status` char(1) NOT NULL default 'a',
  `number_available` int(11) NOT NULL default '-1',
  PRIMARY KEY  (`resourceid`),
  KEY `ar_name` (`name`),
  KEY `ar_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
CREATE TABLE `announcements` (
  `announcementid` char(16) NOT NULL,
  `announcement` varchar(255) NOT NULL default '',
  `number` smallint(6) NOT NULL default '0',
  `start_datetime` int(11) default NULL,
  `end_datetime` int(11) default NULL,
  PRIMARY KEY  (`announcementid`),
  KEY `announcements_startdatetime` (`start_datetime`),
  KEY `announcements_enddatetime` (`end_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `anonymous_users`
--

DROP TABLE IF EXISTS `anonymous_users`;
CREATE TABLE `anonymous_users` (
  `memberid` char(16) NOT NULL,
  `email` varchar(75) NOT NULL,
  `fname` varchar(30) NOT NULL,
  `lname` varchar(30) NOT NULL,
  PRIMARY KEY  (`memberid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `groupid` char(16) NOT NULL,
  `group_name` varchar(50) NOT NULL,
  PRIMARY KEY  (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE `login` (
  `memberid` char(16) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` char(32) NOT NULL,
  `fname` varchar(30) NOT NULL,
  `lname` varchar(30) NOT NULL,
  `phone` varchar(16) NOT NULL,
  `institution` varchar(255) default NULL,
  `position` varchar(100) default NULL,
  `e_add` char(1) NOT NULL default 'y',
  `e_mod` char(1) NOT NULL default 'y',
  `e_del` char(1) NOT NULL default 'y',
  `e_app` char(1) NOT NULL default 'y',
  `e_html` char(1) NOT NULL default 'y',
  `logon_name` varchar(30) default NULL,
  `is_admin` smallint(6) default '0',
  `lang` varchar(5) default NULL,
  `timezone` float NOT NULL default '0',
  PRIMARY KEY  (`memberid`),
  KEY `login_email` (`email`),
  KEY `login_password` (`password`),
  KEY `login_logonname` (`logon_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `mutex`
--

DROP TABLE IF EXISTS `mutex`;
CREATE TABLE `mutex` (
  `i` int(11) NOT NULL,
  PRIMARY KEY  (`i`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `memberid` char(16) NOT NULL,
  `machid` char(16) NOT NULL,
  PRIMARY KEY  (`memberid`,`machid`),
  KEY `per_memberid` (`memberid`),
  KEY `per_machid` (`machid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `reminders`
--

DROP TABLE IF EXISTS `reminders`;
CREATE TABLE `reminders` (
  `reminderid` char(16) NOT NULL,
  `memberid` char(16) NOT NULL,
  `resid` char(16) NOT NULL,
  `reminder_time` bigint(20) NOT NULL,
  PRIMARY KEY  (`reminderid`),
  KEY `reminders_time` (`reminder_time`),
  KEY `reminders_memberid` (`memberid`),
  KEY `reminders_resid` (`resid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `reservation_resources`
--

DROP TABLE IF EXISTS `reservation_resources`;
CREATE TABLE `reservation_resources` (
  `resid` char(16) NOT NULL,
  `resourceid` char(16) NOT NULL,
  `owner` smallint(6) default NULL,
  PRIMARY KEY  (`resid`,`resourceid`),
  KEY `resresources_resid` (`resid`),
  KEY `resresources_resourceid` (`resourceid`),
  KEY `resresources_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `reservation_users`
--

DROP TABLE IF EXISTS `reservation_users`;
CREATE TABLE `reservation_users` (
  `resid` char(16) NOT NULL,
  `memberid` char(16) NOT NULL,
  `owner` smallint(6) default NULL,
  `invited` smallint(6) default NULL,
  `perm_modify` smallint(6) default NULL,
  `perm_delete` smallint(6) default NULL,
  `accept_code` char(16) default NULL,
  PRIMARY KEY  (`resid`,`memberid`),
  KEY `resusers_resid` (`resid`),
  KEY `resusers_memberid` (`memberid`),
  KEY `resusers_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `resid` char(16) NOT NULL,
  `machid` char(16) NOT NULL,
  `scheduleid` char(16) NOT NULL,
  `start_date` int(11) NOT NULL default '0',
  `end_date` int(11) NOT NULL default '0',
  `starttime` int(11) NOT NULL,
  `endtime` int(11) NOT NULL,
  `created` int(11) NOT NULL,
  `modified` int(11) default NULL,
  `parentid` char(16) default NULL,
  `is_blackout` smallint(6) NOT NULL default '0',
  `is_pending` smallint(6) NOT NULL default '0',
  `summary` text,
  `allow_participation` smallint(6) NOT NULL default '0',
  `allow_anon_participation` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`resid`),
  KEY `res_machid` (`machid`),
  KEY `res_scheduleid` (`scheduleid`),
  KEY `reservations_startdate` (`start_date`),
  KEY `reservations_enddate` (`end_date`),
  KEY `res_startTime` (`starttime`),
  KEY `res_endTime` (`endtime`),
  KEY `res_created` (`created`),
  KEY `res_modified` (`modified`),
  KEY `res_parentid` (`parentid`),
  KEY `res_isblackout` (`is_blackout`),
  KEY `reservations_pending` (`is_pending`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
CREATE TABLE `resources` (
  `machid` char(16) NOT NULL,
  `scheduleid` char(16) NOT NULL,
  `name` varchar(75) NOT NULL,
  `location` varchar(250) default NULL,
  `rphone` varchar(16) default NULL,
  `notes` text,
  `status` char(1) NOT NULL default 'a',
  `minres` int(11) NOT NULL,
  `maxres` int(11) NOT NULL,
  `autoassign` smallint(6) default NULL,
  `approval` smallint(6) default NULL,
  `allow_multi` smallint(6) default NULL,
  `max_participants` int(11) default NULL,
  `min_notice_time` int(11) default NULL,
  `max_notice_time` int(11) default NULL,
  PRIMARY KEY  (`machid`),
  KEY `rs_scheduleid` (`scheduleid`),
  KEY `rs_name` (`name`),
  KEY `rs_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `schedule_permission`
--

DROP TABLE IF EXISTS `schedule_permission`;
CREATE TABLE `schedule_permission` (
  `scheduleid` char(16) NOT NULL,
  `memberid` char(16) NOT NULL,
  PRIMARY KEY  (`scheduleid`,`memberid`),
  KEY `sp_scheduleid` (`scheduleid`),
  KEY `sp_memberid` (`memberid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
CREATE TABLE `schedules` (
  `scheduleid` char(16) NOT NULL,
  `scheduletitle` char(75) default NULL,
  `daystart` int(11) NOT NULL,
  `dayend` int(11) NOT NULL,
  `timespan` int(11) NOT NULL,
  `timeformat` int(11) NOT NULL,
  `weekdaystart` int(11) NOT NULL,
  `viewdays` int(11) NOT NULL,
  `usepermissions` smallint(6) default NULL,
  `ishidden` smallint(6) default NULL,
  `showsummary` smallint(6) default NULL,
  `adminemail` varchar(75) default NULL,
  `isdefault` smallint(6) default NULL,
  PRIMARY KEY  (`scheduleid`),
  KEY `sh_hidden` (`ishidden`),
  KEY `sh_perms` (`usepermissions`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
CREATE TABLE `user_groups` (
  `groupid` char(16) NOT NULL,
  `memberid` char(50) NOT NULL,
  `is_admin` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`groupid`,`memberid`),
  KEY `usergroups_groupid` (`groupid`),
  KEY `usergroups_memberid` (`memberid`),
  KEY `usergroups_is_admin` (`is_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

