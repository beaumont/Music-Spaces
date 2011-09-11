-- MySQL dump 10.13  Distrib 5.1.47, for apple-darwin10.3.0 (i386)
--
-- Host: localhost    Database: krugi_test
-- ------------------------------------------------------
-- Server version	5.1.47

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
-- Table structure for table `account_settings`
--

DROP TABLE IF EXISTS `account_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `paypal_email` varchar(50) DEFAULT NULL,
  `donation_title` varchar(255) DEFAULT 'Please support our project!',
  `donation_button_label` varchar(255) DEFAULT 'Contribute',
  `donation_request_explanation` text,
  `donation_amount` decimal(10,2) DEFAULT NULL,
  `show_donation_basket` tinyint(1) DEFAULT '0',
  `default_language` varchar(255) DEFAULT '1819',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `money_status` varchar(255) DEFAULT NULL,
  `webmoney_wmz` varchar(255) DEFAULT NULL,
  `webmoney_wme` varchar(255) DEFAULT NULL,
  `webmoney_wmr` varchar(255) DEFAULT NULL,
  `allow_sponsorships` tinyint(1) DEFAULT '0',
  `donation_title_ru` varchar(255) DEFAULT 'Пожалуйста поддержите наш проект!',
  `donation_button_label_ru` varchar(255) DEFAULT 'Поблагодарить',
  `donation_request_explanation_ru` text,
  `donation_title_fr` varchar(255) DEFAULT NULL,
  `donation_button_label_fr` varchar(255) DEFAULT NULL,
  `donation_request_explanation_fr` text,
  `notified_of_delay` tinyint(1) DEFAULT '0',
  `yandex_scid` varchar(255) DEFAULT NULL,
  `yandex_shopid` varchar(255) DEFAULT NULL,
  `allow_yandex` tinyint(1) DEFAULT '0',
  `paypal_transaction` varchar(255) DEFAULT NULL,
  `webmoney_account` varchar(255) DEFAULT NULL,
  `webmoney_passport_minimum` int(11) DEFAULT NULL,
  `webmoney_account_verified` tinyint(1) DEFAULT NULL,
  `webmoney_wmz_attached` tinyint(1) DEFAULT NULL,
  `webmoney_wmr_attached` tinyint(1) DEFAULT NULL,
  `webmoney_wme_attached` tinyint(1) DEFAULT NULL,
  `paypal_status` varchar(255) DEFAULT NULL,
  `paypal_status_last_updated_at` datetime DEFAULT NULL,
  `paypal_status_last_updated_by` int(11) DEFAULT NULL,
  `verified_by_kroogi` tinyint(1) DEFAULT '0',
  `webmoney_attached_at` datetime DEFAULT NULL,
  `webmoney_passport_level` int(11) DEFAULT NULL,
  `paypal_user_id` varchar(255) DEFAULT NULL,
  `paypal_denial_reason` varchar(255) DEFAULT NULL,
  `billable` tinyint(1) DEFAULT '0',
  `invoice_agreement_accepted_at` datetime DEFAULT NULL,
  `collected_usd` decimal(11,2) DEFAULT '0.00',
  `balance_usd` decimal(11,2) DEFAULT '0.00',
  `waiting_period` int(11) DEFAULT NULL,
  `movable_broker_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `minimum_withdrawal_amount` decimal(8,2) DEFAULT NULL,
  `withdrawal_limit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_account_settings_on_user_id` (`user_id`),
  KEY `index_account_settings_on_paypal_status` (`paypal_status`)
) ENGINE=InnoDB AUTO_INCREMENT=431 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_settings`
--

LOCK TABLES `account_settings` WRITE;
/*!40000 ALTER TABLE `account_settings` DISABLE KEYS */;
INSERT INTO `account_settings` VALUES (1,1,NULL,'Donate','Donate',NULL,NULL,0,'1819','2008-04-01 19:23:48','2009-02-15 20:33:40','money_inactive',NULL,NULL,NULL,0,'Поддержать',NULL,'Пожалуйста, окажите поддержку&hellip;',NULL,NULL,NULL,0,NULL,NULL,1,NULL,NULL,120,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'0.00','0.00',NULL,1,NULL,NULL),(2,2,NULL,'Donate','Donate','',NULL,1,'1819','2008-04-01 19:23:48','2010-07-19 14:57:06','money_inactive',NULL,NULL,NULL,0,'Donate','','Donate',NULL,NULL,NULL,0,NULL,NULL,1,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,1,'2010-05-06 07:38:08','0.03','0.00',NULL,1,'10.00',NULL),(427,441,NULL,NULL,'Donate',NULL,NULL,0,'1819','2010-06-24 13:49:31','2010-08-25 14:56:02',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,1,NULL,NULL,120,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,1,'2010-08-25 14:56:02','0.00','0.00',NULL,1,NULL,NULL),(428,442,NULL,NULL,'Donate',NULL,NULL,0,'1819','2010-06-24 13:49:32','2010-06-24 13:49:32',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,1,NULL,NULL,120,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'0.00','0.00',NULL,1,NULL,NULL),(429,443,NULL,NULL,'Donate',NULL,NULL,0,'1819','2010-06-25 15:49:27','2010-06-25 15:49:27',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,1,NULL,NULL,120,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'0.00','0.00',NULL,1,NULL,NULL),(430,444,NULL,NULL,'Donate',NULL,NULL,0,'1819','2010-07-13 17:21:07','2010-07-13 17:21:07',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,120,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'0.00','0.00',NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `account_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `crypted_password` varchar(255) NOT NULL DEFAULT '',
  `verified` tinyint(1) DEFAULT '0',
  `last_sync` datetime DEFAULT '1970-01-01 00:00:00',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `login` varchar(255) DEFAULT NULL,
  `connect_friends` tinyint(1) DEFAULT '1',
  `last_manual_sync` datetime DEFAULT NULL,
  `usejournal` varchar(255) DEFAULT NULL,
  `friend_circle` int(11) DEFAULT NULL,
  `allow_friends` tinyint(1) DEFAULT NULL,
  `import_mine` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_accounts_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `activity_type_id` int(4) DEFAULT NULL,
  `status` int(4) NOT NULL DEFAULT '1',
  `db_file_id` int(11) DEFAULT NULL,
  `from_user_id` int(11) DEFAULT NULL,
  `from_username` varchar(30) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `content_type` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `friendcast` tinyint(1) DEFAULT '0',
  `monetary_transaction_id` int(11) DEFAULT NULL,
  `from_related` tinyint(1) DEFAULT NULL,
  `show` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `activity_idx` (`user_id`,`from_user_id`,`activity_type_id`,`status`),
  KEY `index_activities_on_from_user_id_and_created_at` (`from_user_id`,`created_at`),
  KEY `activities_content_id` (`content_id`),
  KEY `index_activities_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=39057 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (7,2,100,1,NULL,2,'chief',27,'Content','2007-07-26 18:59:03','2008-06-12 00:27:22',0,NULL,0,1),(14,2,4,1,NULL,2,'chief',32,'Image','2007-07-26 21:58:48','2008-06-12 00:27:22',0,NULL,0,1),(16,2,1,1,NULL,2,'chief',60,'Comment','2007-07-26 21:59:10','2008-06-12 00:27:22',0,NULL,0,1),(18,2,2,1,NULL,2,'chief',61,'Comment','2007-07-26 21:59:23','2008-06-12 00:27:22',0,NULL,0,1),(414,2,1,1,NULL,2,'chief',95,'Comment','2007-10-19 06:21:08','2008-06-12 00:27:32',0,NULL,0,1),(804,2,1,1,NULL,2,'chief',138,'Comment','2008-02-08 06:15:00','2008-06-12 00:27:42',0,NULL,0,1),(8542,2,11,1,NULL,2,'chief',91,'User','2008-07-28 22:07:07','2008-07-28 22:07:07',0,NULL,0,1),(8822,2,210,1,NULL,2,'chief',78,'MonetaryTransaction','2008-09-10 20:57:00','2008-09-10 20:57:00',0,NULL,0,1),(23201,2,150,1,NULL,2,'chief',224,'User','2009-03-18 13:22:08','2009-03-18 13:22:08',0,NULL,0,1),(32676,2,1,1,NULL,2,'chief',570,'Comment','2009-08-03 18:44:37','2009-08-03 18:44:37',0,NULL,0,1),(38935,2,107,1,NULL,2,'chief',9418,'Content','2010-05-06 07:47:57','2010-05-06 07:47:57',0,NULL,NULL,1),(38941,2,101,1,NULL,2,'chief',9419,'Content','2010-05-06 07:50:21','2010-05-06 07:50:21',0,NULL,NULL,1),(39028,2,14,1,NULL,2,'chief',2,'AdvancedUser','2010-05-13 18:14:25','2010-05-13 18:14:25',0,NULL,NULL,1),(39029,2,14,1,NULL,2,'chief',2,'AdvancedUser','2010-05-13 18:18:44','2010-05-13 18:18:44',0,NULL,NULL,1),(39030,2,14,1,NULL,2,'chief',2,'AdvancedUser','2010-06-24 13:47:46','2010-06-24 13:47:46',0,NULL,NULL,1),(39032,2,14,1,NULL,2,'chief',2,'AdvancedUser','2010-06-24 13:49:37','2010-06-24 13:49:37',0,NULL,NULL,1),(39033,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-24 13:50:12','2010-06-24 13:50:12',0,NULL,NULL,1),(39034,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-25 15:48:36','2010-06-25 15:48:36',0,NULL,NULL,1),(39035,441,150,3,NULL,441,'joe',443,'User','2010-06-25 15:49:27','2010-06-25 15:49:27',0,NULL,NULL,1),(39036,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-25 19:29:01','2010-06-25 19:29:01',0,NULL,NULL,1),(39037,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-28 17:39:21','2010-06-28 17:39:21',0,NULL,NULL,1),(39038,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-28 17:46:18','2010-06-28 17:46:18',0,NULL,NULL,1),(39039,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-28 17:47:20','2010-06-28 17:47:20',0,NULL,NULL,1),(39040,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-28 17:48:02','2010-06-28 17:48:02',0,NULL,NULL,1),(39041,441,14,1,NULL,441,'joe',441,'AdvancedUser','2010-06-28 18:30:12','2010-06-28 18:30:12',0,NULL,NULL,1),(39042,2,14,1,NULL,2,'chief',2,'User','2010-07-13 17:18:45','2010-07-13 17:18:45',0,NULL,NULL,1),(39043,441,14,1,NULL,441,'joe',441,'User','2010-07-13 17:18:54','2010-07-13 17:18:54',0,NULL,NULL,1),(39044,2,14,1,NULL,2,'chief',2,'User','2010-07-13 17:21:13','2010-07-13 17:21:13',0,NULL,NULL,1),(39045,444,14,1,NULL,444,'basic',444,'User','2010-07-13 17:22:12','2010-07-13 17:22:12',0,NULL,NULL,1),(39046,444,14,1,NULL,444,'basic',444,'User','2010-07-13 17:24:46','2010-07-13 17:24:46',0,NULL,NULL,1),(39047,2,14,1,NULL,2,'chief',2,'User','2010-07-19 14:56:29','2010-07-19 14:56:29',0,NULL,NULL,1),(39048,2,14,1,NULL,2,'chief',2,'User','2010-07-19 14:57:42','2010-07-19 14:57:42',0,NULL,NULL,1),(39049,2,14,1,NULL,2,'chief',2,'User','2010-07-19 14:58:24','2010-07-19 14:58:24',0,NULL,NULL,1),(39050,441,14,1,NULL,441,'joe',441,'User','2010-07-19 14:58:56','2010-07-19 14:58:56',0,NULL,NULL,1),(39051,444,14,1,NULL,444,'basic',444,'User','2010-07-19 14:59:03','2010-07-19 14:59:03',0,NULL,NULL,1),(39052,2,14,1,NULL,2,'chief',2,'User','2010-08-04 14:45:18','2010-08-04 14:45:18',0,NULL,NULL,1),(39053,441,14,1,NULL,441,'joe',441,'User','2010-08-13 15:50:31','2010-08-13 15:50:31',0,NULL,NULL,1),(39054,441,106,3,NULL,441,'joe',9426,'Content','2010-08-13 15:50:44','2010-08-13 15:50:44',0,NULL,NULL,1),(39055,2,14,1,NULL,2,'chief',2,'User','2010-08-25 14:48:40','2010-08-25 14:48:40',0,NULL,NULL,1),(39056,441,14,1,NULL,441,'joe',441,'User','2010-08-25 14:55:05','2010-08-25 14:55:05',0,NULL,NULL,1);
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_counts`
--

DROP TABLE IF EXISTS `activity_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_counts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `activity_type_id` int(4) DEFAULT NULL,
  `total` int(6) NOT NULL DEFAULT '0',
  `unread` int(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_activity_counts_on_user_id_and_activity_count_id` (`user_id`,`activity_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1964 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_counts`
--

LOCK TABLES `activity_counts` WRITE;
/*!40000 ALTER TABLE `activity_counts` DISABLE KEYS */;
INSERT INTO `activity_counts` VALUES (6,2,100,124,124),(13,2,102,485,485),(14,2,3,8,8),(21,2,101,55,55),(35,2,5,17,14),(57,2,104,80,80),(98,2,6,28,28),(115,2,150,23,23),(122,2,103,73,72),(131,2,1,5,4),(410,2,11,4,4),(452,2,4,7,7),(453,2,2,1,1),(537,1,302,1,1),(563,2,106,14,14),(601,2,210,1,1),(630,2,303,2,2),(1137,2,107,7,7),(1180,2,109,2,2),(1221,2,120,10,10),(1363,2,319,3,3),(1370,-1,319,25,25),(1393,1,162,1,1),(1495,2,201,1,1),(1496,2,202,1,1),(1498,2,200,1,1),(1519,1,5,1,1),(1725,2,112,11,11),(1961,2,14,11,11),(1962,441,14,12,12),(1963,444,14,3,3);
/*!40000 ALTER TABLE `activity_counts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_log_configs`
--

DROP TABLE IF EXISTS `activity_log_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `monitoring` tinyint(1) DEFAULT '0',
  `guests` tinyint(1) DEFAULT NULL,
  `bots` tinyint(1) DEFAULT NULL,
  `all_users` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log_configs`
--

LOCK TABLES `activity_log_configs` WRITE;
/*!40000 ALTER TABLE `activity_log_configs` DISABLE KEYS */;
INSERT INTO `activity_log_configs` VALUES (1,0,NULL,NULL,1,'2010-12-21 14:05:36','2010-12-21 14:05:36');
/*!40000 ALTER TABLE `activity_log_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_log_even`
--

DROP TABLE IF EXISTS `activity_log_even`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log_even` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ip` varchar(16) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `path` varchar(255) DEFAULT '',
  `referrer` varchar(255) DEFAULT '',
  `user_agent` varchar(255) DEFAULT '',
  `session_id` varchar(50) DEFAULT '',
  `login` varchar(255) DEFAULT '',
  `user_id` int(11) DEFAULT NULL,
  `actor_login` varchar(255) DEFAULT '',
  `actor_id` int(11) DEFAULT NULL,
  `system_message_type` varchar(255) DEFAULT '',
  `admin_flash_id` int(11) DEFAULT NULL,
  `content_type` varchar(50) DEFAULT '',
  `content_id` int(11) DEFAULT NULL,
  `content` text,
  `accept_language` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log_even`
--

LOCK TABLES `activity_log_even` WRITE;
/*!40000 ALTER TABLE `activity_log_even` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_log_even` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_log_odd`
--

DROP TABLE IF EXISTS `activity_log_odd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log_odd` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ip` varchar(16) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `path` varchar(255) DEFAULT '',
  `referrer` varchar(255) DEFAULT '',
  `user_agent` varchar(255) DEFAULT '',
  `session_id` varchar(50) DEFAULT '',
  `login` varchar(255) DEFAULT '',
  `user_id` int(11) DEFAULT NULL,
  `actor_login` varchar(255) DEFAULT '',
  `actor_id` int(11) DEFAULT NULL,
  `system_message_type` varchar(255) DEFAULT '',
  `admin_flash_id` int(11) DEFAULT NULL,
  `content_type` varchar(50) DEFAULT '',
  `content_id` int(11) DEFAULT NULL,
  `content` text,
  `accept_language` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log_odd`
--

LOCK TABLES `activity_log_odd` WRITE;
/*!40000 ALTER TABLE `activity_log_odd` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_log_odd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_log_users`
--

DROP TABLE IF EXISTS `activity_log_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_log_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `login` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log_users`
--

LOCK TABLES `activity_log_users` WRITE;
/*!40000 ALTER TABLE `activity_log_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_log_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_mails`
--

DROP TABLE IF EXISTS `activity_mails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activity_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `payload` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_activity_mails_on_user_id_and_created_at` (`user_id`,`created_at`),
  KEY `index_activity_mails_on_activity_id` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_mails`
--

LOCK TABLES `activity_mails` WRITE;
/*!40000 ALTER TABLE `activity_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_mails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_flashes`
--

DROP TABLE IF EXISTS `admin_flashes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_flashes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `priority` int(11) DEFAULT '0',
  `shown` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `message_ru` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_admin_flashes_on_shown_and_priority` (`shown`,`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_flashes`
--

LOCK TABLES `admin_flashes` WRITE;
/*!40000 ALTER TABLE `admin_flashes` DISABLE KEYS */;
INSERT INTO `admin_flashes` VALUES (96,'<b>Act from principle.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:37:08','2008-07-21 21:12:47','<b>Действуй в соответствии с принципами.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(97,'<b>Begin where you are.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:51:51','2008-07-21 21:07:19','<b>Начинай оттуда, где находишься.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(98,'<b>Define your aim simply, clearly, briefly.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:53:17','2008-07-21 21:07:23','<b>Определяй свою цель просто, ясно, коротко.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(99,'<b>Establish the possible and move gradually towards the impossible.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:53:38','2008-07-21 21:07:26','<b>Сделай возможное и постепенно продвигайся к невозможному.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(100,'<b>Exercise commitment, and all the rules change.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:53:57','2008-07-21 21:13:55','<b>Будь предан выбранному пути, и все правила поменяются.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(101,'<b>Honor necessity. Honor sufficiency.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:54:16','2008-07-21 21:14:50','<b>Чти необходимость. Чти достаточность.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(102,'<b>Offer no violence.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:54:30','2008-07-21 21:07:36','<b>Не прибегай к насилию.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(103,'<b>Take our work seriously, but not solemnly.  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-06-11 13:55:52','2008-07-21 21:07:39','<b>Относись к работе серьезно, но без пафоса.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>'),(104,'<b>A quote!!</b> &nbsp;&mdash; <a href=\"some site\" target=\"_new\">Some Dude</a>',NULL,NULL,0,1,'2008-06-11 13:56:01','2009-03-24 15:22:45','<b>A quote!!</b> &nbsp;— <a href=\"\" target=\"_new\">Some Dude</a>'),(105,'<b>A person should design the way he makes a living around how he wishes to make a life.  — <a href=\"http://en.wikipedia.org/wiki/Charlie_Byrd\" target=\"_new\">Charlie Byrd</a></b>',NULL,NULL,0,1,'2008-06-14 05:21:34','2008-07-21 21:07:43','<b>Стоит придумывать себе способ заработка исходя из того, какой хочешь сделать свою жизнь.</b>  — <a href=\"http://en.wikipedia.org/wiki/Charlie_Byrd\" target=\"_new\">Charlie Byrd</a>'),(106,'<b>In ancient India, brahmins were not allowed to charge money, but were allowed to accept donations.</b>',NULL,NULL,0,1,'2008-06-14 05:22:54','2008-07-21 21:07:46','<b>В древней Индии браминам–музыкантам возбранялось брать плату, но разрешалось принимать дары и подношения.</b>'),(107,'<b>Delay always breeds danger; and to protract a great design is often to ruin it.  — <a href=\"http://en.wikipedia.org/wiki/Miguel_de_Cervantes\" target=\"_new\">Miguel de Cervantes</a></b>',NULL,NULL,0,1,'2008-06-18 03:51:17','2008-07-21 21:08:00','<b>Промедление порождает опасность; задержка в воплощении великого замысла часто разрушает его.</b>  — <a href=\"http://en.wikipedia.org/wiki/Miguel_de_Cervantes\" target=\"_new\">Мигель де Сервантес</a>'),(108,'<b>Assume the virtue.  — <a href=\"http://www.guitarcraft.com\">Robert Fripp</a></b>',NULL,NULL,0,1,'2008-07-21 21:02:18','2008-07-21 21:17:08','<b>Предполагай, что вокруг тебя действуют из лучших побуждений.</b>  — <a href=\"http://guitarcraft.com\" target=\"_new\">Robert Fripp</a>');
/*!40000 ALTER TABLE `admin_flashes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admission_pass_name_list`
--

DROP TABLE IF EXISTS `admission_pass_name_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admission_pass_name_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_admission_pass_name_list_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admission_pass_name_list`
--

LOCK TABLES `admission_pass_name_list` WRITE;
/*!40000 ALTER TABLE `admission_pass_name_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `admission_pass_name_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `album_items`
--

DROP TABLE IF EXISTS `album_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `album_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `album_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_album_items_on_album_id_and_position` (`album_id`,`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album_items`
--

LOCK TABLES `album_items` WRITE;
/*!40000 ALTER TABLE `album_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `album_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `board_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `generate_donor_coupons` tinyint(1) DEFAULT '0',
  `require_minimum_to_get_coupon` tinyint(1) DEFAULT '1',
  `coupon_expiration_date` date DEFAULT NULL,
  `max_coupons` int(11) DEFAULT NULL,
  `priority` tinyint(1) NOT NULL DEFAULT '0',
  `reason_for_kroogi_pass` text,
  `reason_for_kroogi_pass_ru` text,
  `reason_for_kroogi_pass_fr` text,
  PRIMARY KEY (`id`),
  KEY `index_announcements_on_board_id` (`board_id`),
  KEY `index_announcements_on_generate_donor_coupons` (`generate_donor_coupons`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answer_interval_counters`
--

DROP TABLE IF EXISTS `answer_interval_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer_interval_counters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `artist_id` int(11) NOT NULL,
  `counter` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_answer_interval_counters_on_artist_id_and_user_id` (`artist_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer_interval_counters`
--

LOCK TABLES `answer_interval_counters` WRITE;
/*!40000 ALTER TABLE `answer_interval_counters` DISABLE KEYS */;
/*!40000 ALTER TABLE `answer_interval_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audits`
--

DROP TABLE IF EXISTS `audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auditable_id` int(11) DEFAULT NULL,
  `auditable_type` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `changes` text,
  `version` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `auditable_index` (`auditable_id`,`auditable_type`),
  KEY `user_index` (`user_id`,`user_type`),
  KEY `index_audits_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3322 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audits`
--

LOCK TABLES `audits` WRITE;
/*!40000 ALTER TABLE `audits` DISABLE KEYS */;
INSERT INTO `audits` VALUES (3315,2,'AccountSetting',NULL,NULL,NULL,'update','--- \ndonation_button_label_ru: \"\"\nshow_donation_basket: true\ndonation_request_explanation: \"\"\n',1,'2010-05-19 17:50:15'),(3316,427,'AccountSetting',NULL,NULL,NULL,'create','--- \ndonation_button_label: Donate\npaypal_status_last_updated_at: \nwebmoney_passport_minimum: 130\nwebmoney_wme_attached: \nwebmoney_wmr: \nbillable: false\nwebmoney_passport_level: \ndefault_language: \"1819\"\nwebmoney_account_verified: \nbalance_usd: 0.0\ndonation_button_label_fr: \nmovable_broker_enabled: true\ndonation_title: \ninvoice_agreement_accepted_at: \nnotified_of_delay: false\nwebmoney_account: \ncollected_usd: 0.0\ndonation_amount: \ndonation_button_label_ru: \npaypal_denial_reason: \npaypal_status_last_updated_by: \nyandex_scid: \ndonation_request_explanation_fr: \ndonation_title_fr: \nshow_donation_basket: false\nuser_id: 441\ndonation_title_ru: \npaypal_transaction: \npaypal_user_id: \ndonation_request_explanation_ru: \nminimum_withdrawal_amount: \nmoney_status: \nverified_by_kroogi: false\nwebmoney_wme: \nwebmoney_wmr_attached: \nwebmoney_wmz: \nallow_yandex: false\npaypal_email: \nwebmoney_attached_at: \nwebmoney_wmz_attached: \nyandex_shopid: \nallow_sponsorships: false\ndonation_request_explanation: \npaypal_status: \nwaiting_period: \n',1,'2010-06-24 13:49:31'),(3317,428,'AccountSetting',NULL,NULL,NULL,'create','--- \ndonation_button_label: Donate\npaypal_status_last_updated_at: \nwebmoney_passport_minimum: 130\nwebmoney_wme_attached: \nwebmoney_wmr: \nbillable: false\nwebmoney_passport_level: \ndefault_language: \"1819\"\nwebmoney_account_verified: \nbalance_usd: 0.0\ndonation_button_label_fr: \nmovable_broker_enabled: true\ndonation_title: \ninvoice_agreement_accepted_at: \nnotified_of_delay: false\nwebmoney_account: \ncollected_usd: 0.0\ndonation_amount: \ndonation_button_label_ru: \npaypal_denial_reason: \npaypal_status_last_updated_by: \nyandex_scid: \ndonation_request_explanation_fr: \ndonation_title_fr: \nshow_donation_basket: false\nuser_id: 442\ndonation_title_ru: \npaypal_transaction: \npaypal_user_id: \ndonation_request_explanation_ru: \nminimum_withdrawal_amount: \nmoney_status: \nverified_by_kroogi: false\nwebmoney_wme: \nwebmoney_wmr_attached: \nwebmoney_wmz: \nallow_yandex: false\npaypal_email: \nwebmoney_attached_at: \nwebmoney_wmz_attached: \nyandex_shopid: \nallow_sponsorships: false\ndonation_request_explanation: \npaypal_status: \nwaiting_period: \n',1,'2010-06-24 13:49:32'),(3318,429,'AccountSetting',NULL,NULL,NULL,'create','--- \ndonation_button_label: Donate\npaypal_status_last_updated_at: \nwebmoney_passport_minimum: 130\nwebmoney_wme_attached: \nwebmoney_wmr: \nbillable: false\nwebmoney_passport_level: \ndefault_language: \"1819\"\nwebmoney_account_verified: \nbalance_usd: 0.0\ndonation_button_label_fr: \nmovable_broker_enabled: true\ndonation_title: \ninvoice_agreement_accepted_at: \nnotified_of_delay: false\nwebmoney_account: \ncollected_usd: 0.0\ndonation_amount: \ndonation_button_label_ru: \npaypal_denial_reason: \npaypal_status_last_updated_by: \nyandex_scid: \ndonation_request_explanation_fr: \ndonation_title_fr: \nshow_donation_basket: false\nuser_id: 443\ndonation_title_ru: \npaypal_transaction: \npaypal_user_id: \ndonation_request_explanation_ru: \nminimum_withdrawal_amount: \nmoney_status: \nverified_by_kroogi: false\nwebmoney_wme: \nwebmoney_wmr_attached: \nwebmoney_wmz: \nallow_yandex: false\npaypal_email: \nwebmoney_attached_at: \nwebmoney_wmz_attached: \nyandex_shopid: \nallow_sponsorships: false\ndonation_request_explanation: \npaypal_status: \nwaiting_period: \n',1,'2010-06-25 15:49:27'),(3319,430,'AccountSetting',NULL,NULL,NULL,'create','--- \ndonation_button_label: Donate\npaypal_status_last_updated_at: \nwebmoney_passport_minimum: 130\nwebmoney_wme_attached: \nwebmoney_wmr: \nbillable: false\nwebmoney_passport_level: \ndefault_language: \"1819\"\nwebmoney_account_verified: \nbalance_usd: 0.0\ndonation_button_label_fr: \nmovable_broker_enabled: true\ndonation_title: \ninvoice_agreement_accepted_at: \nnotified_of_delay: false\nwebmoney_account: \ncollected_usd: 0.0\ndonation_amount: \ndonation_button_label_ru: \npaypal_denial_reason: \npaypal_status_last_updated_by: \nyandex_scid: \ndonation_request_explanation_fr: \ndonation_title_fr: \nshow_donation_basket: false\nuser_id: 444\ndonation_title_ru: \npaypal_transaction: \npaypal_user_id: \ndonation_request_explanation_ru: \nminimum_withdrawal_amount: \nmoney_status: \nverified_by_kroogi: false\nwebmoney_wme: \nwebmoney_wmr_attached: \nwebmoney_wmz: \nallow_yandex: false\npaypal_email: \nwebmoney_attached_at: \nwebmoney_wmz_attached: \nyandex_shopid: \nallow_sponsorships: false\ndonation_request_explanation: \npaypal_status: \nwaiting_period: \n',1,'2010-07-13 17:21:07'),(3320,2,'AccountSetting',NULL,NULL,NULL,'update','--- \ndonation_title_ru: Donate\ndonation_request_explanation_ru: Donate\n',2,'2010-07-19 14:57:06'),(3321,427,'AccountSetting',NULL,NULL,NULL,'update','--- \nbillable: true\ninvoice_agreement_accepted_at: 2010-08-25 14:56:02.916572 Z\n',2,'2010-08-25 14:56:02');
/*!40000 ALTER TABLE `audits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bdrb_job_queues`
--

DROP TABLE IF EXISTS `bdrb_job_queues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bdrb_job_queues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `args` blob,
  `worker_name` varchar(255) DEFAULT NULL,
  `worker_method` varchar(255) DEFAULT NULL,
  `job_key` varchar(255) DEFAULT NULL,
  `taken` bigint(11) DEFAULT NULL,
  `finished` bigint(11) DEFAULT NULL,
  `timeout` bigint(11) DEFAULT NULL,
  `priority` bigint(11) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `archived_at` datetime DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `submitter_info` varchar(255) DEFAULT NULL,
  `runner_info` varchar(255) DEFAULT NULL,
  `worker_key` varchar(255) DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bdrb_job_queues_on_worker_name_and_scheduled_at` (`worker_name`,`scheduled_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bdrb_job_queues`
--

LOCK TABLES `bdrb_job_queues` WRITE;
/*!40000 ALTER TABLE `bdrb_job_queues` DISABLE KEYS */;
/*!40000 ALTER TABLE `bdrb_job_queues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocked_emails`
--

DROP TABLE IF EXISTS `blocked_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `blocked_because_of` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_blocked_emails_on_email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_emails`
--

LOCK TABLES `blocked_emails` WRITE;
/*!40000 ALTER TABLE `blocked_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `blocked_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blocked_users`
--

DROP TABLE IF EXISTS `blocked_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blocked_by_id` int(11) DEFAULT NULL,
  `blocked_user_id` int(11) DEFAULT NULL,
  `blocked_type` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blocked_users`
--

LOCK TABLES `blocked_users` WRITE;
/*!40000 ALTER TABLE `blocked_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `blocked_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_inclusions`
--

DROP TABLE IF EXISTS `collection_inclusions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_inclusions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `child_pac_id` int(11) NOT NULL,
  `child_user_id` int(11) NOT NULL,
  `direct_parent_id` int(11) NOT NULL,
  `child_is_collection` tinyint(1) NOT NULL,
  `stopped` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_collection_inclusions_on_child_pac_id` (`child_pac_id`),
  KEY `index_collection_inclusions_on_child_user_id` (`child_user_id`),
  KEY `index_collection_inclusions_on_parent_id_and_child_is_collection` (`parent_id`,`child_is_collection`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_inclusions`
--

LOCK TABLES `collection_inclusions` WRITE;
/*!40000 ALTER TABLE `collection_inclusions` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_inclusions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_stop_list_items`
--

DROP TABLE IF EXISTS `collection_stop_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collection_stop_list_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_collection_stop_list_items_on_parent_id_and_child_id` (`parent_id`,`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_stop_list_items`
--

LOCK TABLES `collection_stop_list_items` WRITE;
/*!40000 ALTER TABLE `collection_stop_list_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_stop_list_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT '',
  `created_at` datetime NOT NULL,
  `commentable_id` int(11) NOT NULL DEFAULT '0',
  `commentable_type` varchar(32) DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `comments_count` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `avatar_id` int(11) DEFAULT NULL,
  `db_store_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int(11) DEFAULT NULL,
  `private` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_comments_user` (`user_id`),
  KEY `index_comments_on_parent_id` (`parent_id`),
  KEY `tuned_comment_index` (`commentable_type`,`commentable_id`,`deleted_at`,`parent_id`),
  KEY `index_comments_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configurations`
--

DROP TABLE IF EXISTS `configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configurations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(255) DEFAULT NULL,
  `description` text,
  `value` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_configurations_on_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configurations`
--

LOCK TABLES `configurations` WRITE;
/*!40000 ALTER TABLE `configurations` DISABLE KEYS */;
INSERT INTO `configurations` VALUES (1,'standard_charge_percent',NULL,'--- \"15.0\"\n','2009-08-20 14:31:52','2009-08-20 14:31:52'),(2,'sms_charge_percent',NULL,'--- \"8.0\"\n','2009-08-20 14:31:52','2009-08-20 14:31:52');
/*!40000 ALTER TABLE `configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_import_details`
--

DROP TABLE IF EXISTS `content_import_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_import_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `original_content_id` int(11) NOT NULL,
  `previous_content_id` int(11) NOT NULL,
  `previous_owner_id` int(11) NOT NULL,
  `inbox_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `new_owner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_import_details_unique_content_id` (`content_id`),
  KEY `content_import_details_original_content_id` (`original_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_import_details`
--

LOCK TABLES `content_import_details` WRITE;
/*!40000 ALTER TABLE `content_import_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_import_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_stats`
--

DROP TABLE IF EXISTS `content_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `content_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `viewed` int(11) DEFAULT NULL,
  `viewed_today` int(11) DEFAULT NULL,
  `favorited` int(11) DEFAULT NULL,
  `favorited_today` int(11) DEFAULT NULL,
  `commented` int(11) DEFAULT NULL,
  `commented_today` int(11) DEFAULT NULL,
  `played` int(11) DEFAULT NULL,
  `played_today` int(11) DEFAULT NULL,
  `content_type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_content_stats_on_content_type_and_content_id` (`content_type`,`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=918 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_stats`
--

LOCK TABLES `content_stats` WRITE;
/*!40000 ALTER TABLE `content_stats` DISABLE KEYS */;
INSERT INTO `content_stats` VALUES (916,2,2,1,NULL,NULL,NULL,NULL,NULL,NULL,'AdvancedUser'),(917,441,1,1,NULL,NULL,NULL,NULL,NULL,NULL,'AdvancedUser');
/*!40000 ALTER TABLE `content_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents`
--

DROP TABLE IF EXISTS `contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `type` varchar(255) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `filepath` varchar(255) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `is_in_gallery` tinyint(1) DEFAULT '0',
  `db_file_id` int(11) DEFAULT NULL,
  `foruser_id` int(11) DEFAULT NULL,
  `cat_id` int(11) NOT NULL DEFAULT '0',
  `is_in_startpage` tinyint(1) DEFAULT '0',
  `is_in_myplaylist` tinyint(1) DEFAULT '0',
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `updated_by_id` int(11) NOT NULL DEFAULT '0',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `artist` varchar(80) DEFAULT NULL,
  `album` varchar(80) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  `genre` varchar(60) DEFAULT NULL,
  `bitrate` int(4) DEFAULT NULL,
  `chanels` varchar(20) DEFAULT NULL,
  `samplerate` int(4) DEFAULT NULL,
  `length` int(6) DEFAULT NULL,
  `post_db_store_id` int(11) DEFAULT NULL,
  `language_code` varchar(8) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `title_ru` varchar(255) DEFAULT NULL,
  `description_ru` text,
  `title_fr` varchar(255) DEFAULT NULL,
  `description_fr` text,
  `post_db_store_ru_id` int(11) DEFAULT NULL,
  `post_db_store_fr_id` int(11) DEFAULT NULL,
  `state` varchar(255) DEFAULT 'active',
  `state_changed_at` datetime DEFAULT NULL,
  `artist_ru` varchar(255) DEFAULT NULL,
  `album_ru` varchar(255) DEFAULT NULL,
  `artist_fr` varchar(255) DEFAULT NULL,
  `album_fr` varchar(255) DEFAULT NULL,
  `downloadable` tinyint(1) DEFAULT '0',
  `downloadable_album_id` int(11) DEFAULT NULL,
  `relationshiptype_id` int(11) DEFAULT NULL,
  `body_project_id` int(11) DEFAULT NULL,
  `original_owner` varchar(255) DEFAULT NULL,
  `popularity` float DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_contents_on_type_and_created_at` (`type`,`created_at`),
  KEY `index_contents_on_user_id` (`user_id`),
  KEY `index_contents_on_state` (`state`),
  KEY `index_contents_on_parent_id` (`parent_id`),
  KEY `index_contents_on_type_and_downloadable` (`type`,`downloadable`),
  KEY `index_contents_on_original_owner` (`original_owner`),
  KEY `index_contents_on_popularity` (`popularity`)
) ENGINE=InnoDB AUTO_INCREMENT=9427 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
INSERT INTO `contents` VALUES (9422,2,NULL,NULL,'Album',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-05-13 16:15:57','2010-05-13 16:15:57',0,NULL,NULL,11,0,0,-1,-1,-1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ru',NULL,'Content on Kroogi Page',NULL,NULL,NULL,NULL,NULL,'active',NULL,NULL,NULL,NULL,NULL,0,NULL,-2,NULL,NULL,0),(9423,442,'Content on Kroogi Page',NULL,'Album',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-06-24 13:52:08','2010-06-24 13:52:08',0,NULL,NULL,11,0,0,441,441,442,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'en',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',NULL,NULL,NULL,NULL,NULL,0,NULL,-1,NULL,NULL,0),(9424,441,'Content on Kroogi Page',NULL,'Album',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-06-25 19:28:50','2010-06-25 19:28:50',0,NULL,NULL,11,0,0,-1,-1,-1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'en',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',NULL,NULL,NULL,NULL,NULL,0,NULL,-2,NULL,NULL,0),(9425,444,'Content on Kroogi Page',NULL,'Album',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-07-19 14:59:19','2010-07-19 14:59:19',0,NULL,NULL,11,0,0,444,444,444,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'en',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',NULL,NULL,NULL,NULL,NULL,0,NULL,-2,NULL,NULL,0),(9426,441,'test folder','','Album',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-08-13 15:50:44','2010-08-13 15:50:44',1,NULL,NULL,10,0,0,441,441,441,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'en',NULL,'','',NULL,NULL,NULL,NULL,'active',NULL,NULL,NULL,NULL,NULL,0,NULL,-2,NULL,NULL,0);
/*!40000 ALTER TABLE `contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents_i18n`
--

DROP TABLE IF EXISTS `contents_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contents_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `hide_from_eng_top` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_contents_i18n_on_content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contents_i18n`
--

LOCK TABLES `contents_i18n` WRITE;
/*!40000 ALTER TABLE `contents_i18n` DISABLE KEYS */;
/*!40000 ALTER TABLE `contents_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contest_submissions`
--

DROP TABLE IF EXISTS `contest_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contest_submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `level` int(11) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `contest_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contest_submissions_on_content_id` (`content_id`),
  KEY `index_contest_submissions_on_created_by_id` (`created_by_id`),
  KEY `index_contest_submissions_on_contest_id` (`contest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contest_submissions`
--

LOCK TABLES `contest_submissions` WRITE;
/*!40000 ALTER TABLE `contest_submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `contest_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contribution_settings`
--

DROP TABLE IF EXISTS `contribution_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contribution_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `min_amount` decimal(10,2) DEFAULT NULL,
  `recommended_amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contribution_settings_on_content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contribution_settings`
--

LOCK TABLES `contribution_settings` WRITE;
/*!40000 ALTER TABLE `contribution_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `contribution_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency_types`
--

DROP TABLE IF EXISTS `currency_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountable_id` int(11) DEFAULT NULL,
  `accountable_type` varchar(255) DEFAULT 'AccountSetting',
  `roubles` decimal(10,2) DEFAULT NULL,
  `euros` decimal(10,2) DEFAULT NULL,
  `dollars` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sponsorship_prices` tinyint(1) DEFAULT '0',
  `show_donation_button` tinyint(1) DEFAULT '0',
  `donation_button_label` varchar(255) DEFAULT NULL,
  `message_to_donors` text,
  `message_to_donors_ru` text,
  `donation_button_label_ru` varchar(255) DEFAULT NULL,
  `message_to_donors_fr` text,
  `donation_button_label_fr` varchar(255) DEFAULT NULL,
  `amount_required_for_circle_invite_usd` decimal(10,2) DEFAULT NULL,
  `circle_to_invite_to` int(11) DEFAULT NULL,
  `amount_required_for_circle_invite_rur` decimal(10,2) DEFAULT NULL,
  `amount_required_for_circle_invite_eur` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_currency_types_on_accountable_type_and_accountable_id` (`accountable_type`,`accountable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency_types`
--

LOCK TABLES `currency_types` WRITE;
/*!40000 ALTER TABLE `currency_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `currency_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `db_files`
--

DROP TABLE IF EXISTS `db_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `db_files`
--

LOCK TABLES `db_files` WRITE;
/*!40000 ALTER TABLE `db_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `db_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `db_store`
--

DROP TABLE IF EXISTS `db_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_store` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` mediumtext,
  `updated_by_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2629 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `db_store`
--

LOCK TABLES `db_store` WRITE;
/*!40000 ALTER TABLE `db_store` DISABLE KEYS */;
INSERT INTO `db_store` VALUES (2611,'Get invited into joe\'s circle of close friends',-1,'2010-06-24 13:49:32'),(2612,'Get invited into joe\'s circle of close friends',-1,'2010-06-24 13:49:32'),(2613,'Express interest in joe, get updates from him',-1,'2010-06-24 13:49:32'),(2614,'Express interest in joe, get updates from him',-1,'2010-06-24 13:49:32'),(2615,'Be the Chosen One',-1,'2010-06-24 13:49:32'),(2616,'Be the Chosen One',-1,'2010-06-24 13:49:32'),(2617,'Join the Inner Circle',-1,'2010-06-24 13:49:32'),(2618,'Join the Inner Circle',-1,'2010-06-24 13:49:32'),(2619,'Appreciate joes-band',-1,'2010-06-24 13:49:32'),(2620,'Appreciate joes-band',-1,'2010-06-24 13:49:32'),(2621,'Be the Chosen One',441,'2010-06-25 15:49:27'),(2622,'Be the Chosen One',441,'2010-06-25 15:49:27'),(2623,'Join the Inner Circle',441,'2010-06-25 15:49:27'),(2624,'Join the Inner Circle',441,'2010-06-25 15:49:27'),(2625,'Appreciate avatar-band',441,'2010-06-25 15:49:27'),(2626,'Appreciate avatar-band',441,'2010-06-25 15:49:27'),(2627,'Express interest in basic, get updates from him',-1,'2010-07-13 17:21:07'),(2628,'Express interest in basic, get updates from him',-1,'2010-07-13 17:21:07');
/*!40000 ALTER TABLE `db_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation_settings`
--

DROP TABLE IF EXISTS `donation_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donation_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountable_id` int(11) DEFAULT NULL,
  `accountable_type` varchar(255) DEFAULT 'AccountSetting',
  `roubles` decimal(10,2) DEFAULT NULL,
  `euros` decimal(10,2) DEFAULT NULL,
  `dollars` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sponsorship_prices` tinyint(1) DEFAULT '0',
  `show_donation_button` tinyint(1) DEFAULT '0',
  `donation_button_label` varchar(255) DEFAULT NULL,
  `message_to_donors` text,
  `message_to_donors_ru` text,
  `donation_button_label_ru` varchar(255) DEFAULT NULL,
  `message_to_donors_fr` text,
  `donation_button_label_fr` varchar(255) DEFAULT NULL,
  `amount_required_for_circle_invite_usd` decimal(10,2) DEFAULT NULL,
  `circle_to_invite_to` int(11) DEFAULT NULL,
  `amount_required_for_circle_invite_rur` decimal(10,2) DEFAULT NULL,
  `amount_required_for_circle_invite_eur` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_currency_types_on_accountable_type_and_accountable_id` (`accountable_type`,`accountable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9192 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation_settings`
--

LOCK TABLES `donation_settings` WRITE;
/*!40000 ALTER TABLE `donation_settings` DISABLE KEYS */;
INSERT INTO `donation_settings` VALUES (4532,1,'AccountSetting',NULL,NULL,NULL,'2009-02-15 20:33:40','2009-02-15 20:33:40',0,0,'Donate','Thank you for your donation',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4533,2,'AccountSetting',NULL,NULL,NULL,'2009-02-15 20:33:40','2010-07-19 14:57:06',0,0,'Donate','Thank you for your donation','','Donate',NULL,NULL,NULL,NULL,NULL,NULL),(9173,427,'AccountSetting',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9174,1074,'UserKroog',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9175,1075,'UserKroog',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9176,1076,'UserKroog',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9177,1077,'UserKroog',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9178,1078,'UserKroog',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9179,428,'AccountSetting',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9180,1079,'UserKroog',NULL,NULL,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9181,9423,'Content',NULL,NULL,NULL,'2010-06-24 13:52:08','2010-06-24 13:52:08',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9182,1080,'UserKroog',NULL,NULL,NULL,'2010-06-25 15:49:26','2010-06-25 15:49:26',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9183,1081,'UserKroog',NULL,NULL,NULL,'2010-06-25 15:49:26','2010-06-25 15:49:26',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9184,1082,'UserKroog',NULL,NULL,NULL,'2010-06-25 15:49:26','2010-06-25 15:49:26',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9185,429,'AccountSetting',NULL,NULL,NULL,'2010-06-25 15:49:27','2010-06-25 15:49:27',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9186,1083,'UserKroog',NULL,NULL,NULL,'2010-06-25 15:49:27','2010-06-25 15:49:27',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9187,9424,'Content',NULL,NULL,NULL,'2010-06-25 19:28:50','2010-06-25 19:28:50',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9188,430,'AccountSetting',NULL,NULL,NULL,'2010-07-13 17:21:07','2010-07-13 17:21:07',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9189,1084,'UserKroog',NULL,NULL,NULL,'2010-07-13 17:21:07','2010-07-13 17:21:07',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9190,9425,'Content',NULL,NULL,NULL,'2010-07-19 14:59:19','2010-07-19 14:59:19',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9191,9426,'Content',NULL,NULL,NULL,'2010-08-13 15:50:44','2010-08-13 15:50:44',0,0,'Contribute Now','Thank you for your contribution',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `donation_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor_coupons`
--

DROP TABLE IF EXISTS `donor_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `donor_coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `board_id` int(11) DEFAULT NULL,
  `monetary_donation_id` int(11) DEFAULT NULL,
  `coupon_code` varchar(255) DEFAULT NULL,
  `message` text,
  `expires_at` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `access_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `relationship_to_contribution` (`board_id`,`monetary_donation_id`),
  KEY `index_donor_coupons_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor_coupons`
--

LOCK TABLES `donor_coupons` WRITE;
/*!40000 ALTER TABLE `donor_coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `donor_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `last_send_attempt` int(11) DEFAULT '0',
  `mail` mediumtext,
  `created_on` datetime DEFAULT NULL,
  `ready` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails`
--

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_invites`
--

DROP TABLE IF EXISTS `event_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `event_access_key` varchar(255) DEFAULT NULL,
  `message` text,
  `rsvp` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `monetary_donation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_event_invites_on_user_id_and_event_id` (`user_id`,`event_id`),
  KEY `index_event_invites_on_monetary_contribution_id` (`monetary_donation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_invites`
--

LOCK TABLES `event_invites` WRITE;
/*!40000 ALTER TABLE `event_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `max_attendees` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `description` text,
  `category` int(2) DEFAULT NULL,
  `homepage` varchar(255) DEFAULT NULL,
  `number_of_guests` int(11) DEFAULT NULL,
  `board_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `venue_id` int(11) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `extra_folder_with_downloadables_fields`
--

DROP TABLE IF EXISTS `extra_folder_with_downloadables_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extra_folder_with_downloadables_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) DEFAULT NULL,
  `require_terms_acceptance` tinyint(1) DEFAULT '0',
  `number_of_tracks` varchar(255) DEFAULT NULL,
  `terms_db_store_id` int(11) DEFAULT NULL,
  `terms_db_store_ru_id` int(11) DEFAULT NULL,
  `preset_terms_and_conditions_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `terms_and_conditions_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_extra_music_album_fields_on_music_album_id` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extra_folder_with_downloadables_fields`
--

LOCK TABLES `extra_folder_with_downloadables_fields` WRITE;
/*!40000 ALTER TABLE `extra_folder_with_downloadables_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `extra_folder_with_downloadables_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `extra_inbox_fields`
--

DROP TABLE IF EXISTS `extra_inbox_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extra_inbox_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inbox_id` int(11) DEFAULT NULL,
  `tagline` varchar(255) DEFAULT NULL,
  `tagline_ru` varchar(255) DEFAULT NULL,
  `tagline_fr` varchar(255) DEFAULT NULL,
  `images` tinyint(1) DEFAULT '1',
  `tracks` tinyint(1) DEFAULT '1',
  `videos` tinyint(1) DEFAULT '1',
  `writings` tinyint(1) DEFAULT '1',
  `archived` tinyint(1) DEFAULT '0',
  `feature_most_recent` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `require_allowing_content_adoption` tinyint(1) DEFAULT '0',
  `voting_restriction` int(11) DEFAULT '-2',
  PRIMARY KEY (`id`),
  KEY `index_extra_inbox_fields_on_inbox_id` (`inbox_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extra_inbox_fields`
--

LOCK TABLES `extra_inbox_fields` WRITE;
/*!40000 ALTER TABLE `extra_inbox_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `extra_inbox_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facebook_templates`
--

DROP TABLE IF EXISTS `facebook_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facebook_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bundle_id` varchar(255) DEFAULT NULL,
  `template_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facebook_templates`
--

LOCK TABLES `facebook_templates` WRITE;
/*!40000 ALTER TABLE `facebook_templates` DISABLE KEYS */;
INSERT INTO `facebook_templates` VALUES (1,'127972677302','Facebook::Publisher::profile_feed','2009-08-27 17:00:17','2009-08-27 17:00:17');
/*!40000 ALTER TABLE `facebook_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faqs`
--

DROP TABLE IF EXISTS `faqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) DEFAULT NULL,
  `answer` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `question_ru` varchar(255) DEFAULT NULL,
  `answer_ru` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faqs`
--

LOCK TABLES `faqs` WRITE;
/*!40000 ALTER TABLE `faqs` DISABLE KEYS */;
/*!40000 ALTER TABLE `faqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `favorable_type` varchar(30) DEFAULT NULL,
  `favorable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_favorites_on_user_id_and_created_at` (`user_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fb_friends`
--

DROP TABLE IF EXISTS `fb_friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fb_friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fb_friends`
--

LOCK TABLES `fb_friends` WRITE;
/*!40000 ALTER TABLE `fb_friends` DISABLE KEYS */;
/*!40000 ALTER TABLE `fb_friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fb_user_details`
--

DROP TABLE IF EXISTS `fb_user_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fb_user_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `fb_user_id` bigint(20) DEFAULT NULL,
  `fb_session_key` varchar(255) DEFAULT NULL,
  `linked_artist_id` int(11) DEFAULT NULL,
  `header_text` text,
  `is_kd_user` tinyint(1) DEFAULT '0',
  `is_fb_connected` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fb_user_details`
--

LOCK TABLES `fb_user_details` WRITE;
/*!40000 ALTER TABLE `fb_user_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `fb_user_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `featured_items`
--

DROP TABLE IF EXISTS `featured_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `featured_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `item_type` varchar(255) DEFAULT NULL,
  `is_content` tinyint(1) DEFAULT NULL,
  `is_project` tinyint(1) DEFAULT NULL,
  `currently_featured` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `editorial_db_store_id` int(11) DEFAULT NULL,
  `editorial_db_store_ru_id` int(11) DEFAULT NULL,
  `synopsis` varchar(255) DEFAULT NULL,
  `synopsis_ru` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_featured_items_on_currently_featured` (`currently_featured`),
  KEY `index_featured_items_on_db_store_ru_id` (`editorial_db_store_ru_id`),
  KEY `featured_item_idx` (`currently_featured`,`is_content`,`is_project`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `featured_items`
--

LOCK TABLES `featured_items` WRITE;
/*!40000 ALTER TABLE `featured_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `featured_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_entries`
--

DROP TABLE IF EXISTS `feed_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user_id` int(11) NOT NULL,
  `content_category` int(11) DEFAULT NULL,
  `from_collections` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_feed_entries_on_to_user_id_and_created_at` (`to_user_id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_entries`
--

LOCK TABLES `feed_entries` WRITE;
/*!40000 ALTER TABLE `feed_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_entries_archive`
--

DROP TABLE IF EXISTS `feed_entries_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_entries_archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user_id` int(11) NOT NULL,
  `content_category` int(11) DEFAULT NULL,
  `from_collections` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_entries_archive`
--

LOCK TABLES `feed_entries_archive` WRITE;
/*!40000 ALTER TABLE `feed_entries_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_entries_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_entry_activities`
--

DROP TABLE IF EXISTS `feed_entry_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_entry_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feed_entry_id` int(11) NOT NULL,
  `activity_type_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `position` int(11) DEFAULT NULL,
  `from_user_id` int(11) DEFAULT NULL,
  `to_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_feed_entry_activities_on_feed_entry_id` (`feed_entry_id`),
  KEY `feed_entry_activities_by_type_and_content` (`activity_type_id`,`content_type`,`content_id`),
  KEY `index_feed_entry_activities_on_from_user_id_and_feed_entry_id` (`from_user_id`,`feed_entry_id`),
  KEY `index_feed_entry_activities_on_activity_id` (`activity_id`),
  KEY `index_feed_entry_activities_on_content` (`content_type`,`content_id`),
  KEY `index_feed_entry_activities_on_to_user_id_and_from_user_id` (`to_user_id`,`from_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_entry_activities`
--

LOCK TABLES `feed_entry_activities` WRITE;
/*!40000 ALTER TABLE `feed_entry_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_entry_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_entry_activities_archive`
--

DROP TABLE IF EXISTS `feed_entry_activities_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_entry_activities_archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feed_entry_id` int(11) NOT NULL,
  `activity_type_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `position` int(11) DEFAULT NULL,
  `from_user_id` int(11) DEFAULT NULL,
  `to_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_entry_activities_archive`
--

LOCK TABLES `feed_entry_activities_archive` WRITE;
/*!40000 ALTER TABLE `feed_entry_activities_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_entry_activities_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedbacks`
--

DROP TABLE IF EXISTS `feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `complaint` text,
  `environment` text,
  `ip` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sent_from` varchar(255) DEFAULT NULL,
  `junk` tinyint(1) DEFAULT '0',
  `created_by_id` bigint(11) NOT NULL DEFAULT '0',
  `updated_by_id` bigint(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedbacks`
--

LOCK TABLES `feedbacks` WRITE;
/*!40000 ALTER TABLE `feedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `globalize_countries`
--

DROP TABLE IF EXISTS `globalize_countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `globalize_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(2) DEFAULT NULL,
  `english_name` varchar(255) DEFAULT NULL,
  `date_format` varchar(255) DEFAULT NULL,
  `currency_format` varchar(255) DEFAULT NULL,
  `currency_code` varchar(3) DEFAULT NULL,
  `thousands_sep` varchar(2) DEFAULT NULL,
  `decimal_sep` varchar(2) DEFAULT NULL,
  `currency_decimal_sep` varchar(2) DEFAULT NULL,
  `number_grouping_scheme` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_globalize_countries_on_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `globalize_countries`
--

LOCK TABLES `globalize_countries` WRITE;
/*!40000 ALTER TABLE `globalize_countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `globalize_countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `globalize_languages`
--

DROP TABLE IF EXISTS `globalize_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `globalize_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iso_639_1` varchar(2) DEFAULT NULL,
  `iso_639_2` varchar(3) DEFAULT NULL,
  `iso_639_3` varchar(3) DEFAULT NULL,
  `rfc_3066` varchar(255) DEFAULT NULL,
  `english_name` varchar(255) DEFAULT NULL,
  `english_name_locale` varchar(255) DEFAULT NULL,
  `english_name_modifier` varchar(255) DEFAULT NULL,
  `native_name` varchar(255) DEFAULT NULL,
  `native_name_locale` varchar(255) DEFAULT NULL,
  `native_name_modifier` varchar(255) DEFAULT NULL,
  `macro_language` tinyint(1) DEFAULT NULL,
  `direction` varchar(255) DEFAULT NULL,
  `pluralization` varchar(255) DEFAULT NULL,
  `scope` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_globalize_languages_on_iso_639_1` (`iso_639_1`),
  KEY `index_globalize_languages_on_iso_639_2` (`iso_639_2`),
  KEY `index_globalize_languages_on_iso_639_3` (`iso_639_3`),
  KEY `index_globalize_languages_on_rfc_3066` (`rfc_3066`)
) ENGINE=InnoDB AUTO_INCREMENT=7597 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `globalize_languages`
--

LOCK TABLES `globalize_languages` WRITE;
/*!40000 ALTER TABLE `globalize_languages` DISABLE KEYS */;
INSERT INTO `globalize_languages` VALUES (15,'aa','aar','aar',NULL,'Afar',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(33,'ab','abk','abk',NULL,'Abkhazian',NULL,NULL,'аҧсуа бызшәа',NULL,NULL,0,'ltr',NULL,'L'),(114,'af','afr','afr',NULL,'Afrikaans',NULL,NULL,'Afrikaans',NULL,NULL,0,'ltr',NULL,'L'),(191,'ak','aka','aka',NULL,'Akan',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(247,'am','amh','amh',NULL,'Amharic',NULL,NULL,'አማርኛ',NULL,NULL,0,'ltr',NULL,'L'),(340,'ar','ara','ara',NULL,'Arabic',NULL,NULL,'العربية',NULL,NULL,1,'rtl',NULL,'L'),(346,'an','arg','arg',NULL,'Aragonese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(376,'as','asm','asm',NULL,'Assamese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(438,'av','ava','ava',NULL,'Avaric',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(441,'ae','ave','ave',NULL,'Avestan',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'A'),(483,'ay','aym','aym',NULL,'Aymara',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(496,'az','aze','aze',NULL,'Azerbaijani',NULL,NULL,'azərbaycan',NULL,NULL,1,'ltr',NULL,'L'),(512,'ba','bak','bak',NULL,'Bashkir',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(514,'bm','bam','bam',NULL,'Bambara',NULL,NULL,'Bamanankan',NULL,NULL,0,'ltr',NULL,'L'),(614,'be','bel','bel',NULL,'Belarusian',NULL,NULL,'Беларуская',NULL,NULL,0,'ltr',NULL,'L'),(616,'bn','ben','ben',NULL,'Bengali',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(721,'bi','bis','bis',NULL,'Bislama',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(860,'bo','bod','bod',NULL,'Tibetan',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(875,'bs','bos','bos',NULL,'Bosnian',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(936,'br','bre','bre',NULL,'Breton',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1020,'bg','bul','bul',NULL,'Bulgarian',NULL,NULL,'Български',NULL,NULL,0,'ltr',NULL,'L'),(1177,'ca','cat','cat',NULL,'Catalan',NULL,NULL,'Català',NULL,NULL,0,'ltr',NULL,'L'),(1233,'cs','ces','ces',NULL,'Czech',NULL,NULL,'čeština',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c%10>=2 && c%10<=4 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(1242,'ch','cha','cha',NULL,'Chamorro',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1246,'ce','che','che',NULL,'Chechen',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1261,'cu','chu','chu',NULL,'Slavic',NULL,'Church',NULL,NULL,NULL,0,'ltr',NULL,'A'),(1262,'cv','chv','chv',NULL,'Chuvash',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1372,'kw','cor','cor',NULL,'Cornish',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1373,'co','cos','cos',NULL,'Corsican',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1397,'cr','cre','cre',NULL,'Cree',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(1481,'cy','cym','cym',NULL,'Welsh',NULL,NULL,'Cymraeg',NULL,NULL,0,'ltr',NULL,'L'),(1499,'da','dan','dan',NULL,'Danish',NULL,NULL,'Dansk',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1556,'de','deu','deu',NULL,'German',NULL,NULL,'Deutsch',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1607,'dv','div','div',NULL,'Divehi',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1760,'dz','dzo','dzo',NULL,'Dzongkha',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1793,'el','ell','ell',NULL,'Greek',NULL,'Modern (1453-)','Ελληνικά',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1819,'en','eng','eng',NULL,'English',NULL,NULL,NULL,NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1831,'eo','epo','epo',NULL,'Esperanto',NULL,NULL,NULL,NULL,NULL,0,'ltr','c == 1 ? 1 : 2','C'),(1851,'et','est','est',NULL,'Estonian',NULL,NULL,'Eesti',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1865,'eu','eus','eus',NULL,'Basque',NULL,NULL,'euskera',NULL,NULL,0,'ltr',NULL,'L'),(1869,'ee','ewe','ewe',NULL,'Ewe',NULL,NULL,'Ɛʋɛ',NULL,NULL,0,'ltr',NULL,'L'),(1886,'fo','fao','fao',NULL,'Faroese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1889,'fa','fas','fas',NULL,'Persian',NULL,NULL,'فارسی',NULL,NULL,1,'ltr',NULL,'L'),(1901,'fj','fij','fij',NULL,'Fijian',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(1903,'fi','fin','fin',NULL,'Finnish',NULL,NULL,'suomi',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1930,'fr','fra','fra',NULL,'French',NULL,NULL,'Français',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(1942,'fy','fry','fry',NULL,'Frisian',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(1954,'ff','ful','ful',NULL,'Fulah',NULL,NULL,'Fulfulde, Pulaar, Pular',NULL,NULL,1,'ltr',NULL,'L'),(2112,'gd','gla','gla',NULL,'Gaelic','Scots',NULL,NULL,NULL,NULL,0,'ltr','c==1 ? 1 : c==2 ? 2 : 3','L'),(2115,'ga','gle','gle',NULL,'Irish',NULL,NULL,'Gaeilge',NULL,NULL,0,'ltr','c==1 ? 1 : c==2 ? 2 : 3','L'),(2116,'gl','glg','glg',NULL,'Gallegan',NULL,NULL,'Galego',NULL,NULL,0,'ltr',NULL,'L'),(2125,'gv','glv','glv',NULL,'Manx',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'E'),(2194,'gn','grn','grn',NULL,'Guarani',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(2226,'gu','guj','guj',NULL,'Gujarati',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2304,'ht','hat','hat',NULL,'Haitian; Haitian Creole',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2305,'ha','hau','hau',NULL,'Hausa',NULL,NULL,'Hausa',NULL,NULL,0,'ltr',NULL,'L'),(2315,'sh',NULL,'hbs',NULL,'Serbo-Croatian',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(2323,'he','heb','heb',NULL,'Hebrew',NULL,NULL,'עברית',NULL,NULL,0,'rtl','c == 1 ? 1 : 2','L'),(2329,'hz','her','her',NULL,'Herero',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2343,'hi','hin','hin',NULL,'Hindi',NULL,NULL,'हिंदी',NULL,NULL,0,'ltr',NULL,'L'),(2370,'ho','hmo','hmo',NULL,'Hiri Motu',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2418,'hr','hrv','hrv',NULL,'Croatian',NULL,NULL,'Hrvatski',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c%10>=2 && c%10<=4 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(2443,'hu','hun','hun',NULL,'Hungarian',NULL,NULL,'Magyar',NULL,NULL,0,'ltr','c = 1','L'),(2466,'hy','hye','hye',NULL,'Armenian',NULL,NULL,'Հայերեն',NULL,NULL,0,'ltr',NULL,'L'),(2480,'ig','ibo','ibo',NULL,'Igbo',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2494,'io','ido','ido',NULL,'Ido',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'C'),(2519,'ii','iii','iii',NULL,'Yi',NULL,'Sichuan',NULL,NULL,NULL,0,'ltr',NULL,'L'),(2532,'iu','iku','iku',NULL,'Inuktitut',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(2539,'ie','ile','ile',NULL,'Interlingue',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'C'),(2556,'ia','ina','ina',NULL,'Interlingua','International Auxiliary Language Association',NULL,NULL,NULL,NULL,0,'ltr',NULL,'C'),(2558,'id','ind','ind',NULL,'Indonesian',NULL,NULL,'Bahasa indonesia',NULL,NULL,0,'ltr',NULL,'L'),(2574,'ik','ipk','ipk',NULL,'Inupiaq',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(2593,'is','isl','isl',NULL,'Icelandic',NULL,NULL,'Íslenska',NULL,NULL,0,'ltr',NULL,'L'),(2600,'it','ita','ita',NULL,'Italian',NULL,NULL,'italiano',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(2652,'jv','jav','jav',NULL,'Javanese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2723,'ja','jpn','jpn',NULL,'Japanese',NULL,NULL,'日本語',NULL,NULL,0,'ltr','c = 1','L'),(2763,'kl','kal','kal',NULL,'Kalaallisut',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2765,'kn','kan','kan',NULL,'Kannada',NULL,NULL,'ಕನ್ನಡ',NULL,NULL,0,'ltr',NULL,'L'),(2769,'ks','kas','kas',NULL,'Kashmiri',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2770,'ka','kat','kat',NULL,'Georgian',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2771,'kr','kau','kau',NULL,'Kanuri',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(2776,'kk','kaz','kaz',NULL,'Kazakh',NULL,NULL,'Қазақ',NULL,NULL,0,'ltr',NULL,'L'),(2939,'km','khm','khm',NULL,'Khmer',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2963,'ki','kik','kik',NULL,'Kikuyu',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(2966,'rw','kin','kin',NULL,'Kinyarwanda',NULL,NULL,'Kinyarwanda',NULL,NULL,0,'ltr',NULL,'L'),(2970,'ky','kir','kir',NULL,'Kirghiz',NULL,NULL,'Кыргыз',NULL,NULL,0,'ltr',NULL,'L'),(3117,'kv','kom','kom',NULL,'Komi',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(3118,'kg','kon','kon',NULL,'Kongo',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(3122,'ko','kor','kor',NULL,'Korean',NULL,NULL,'한국어',NULL,NULL,0,'ltr','c = 1','L'),(3260,'kj','kua','kua',NULL,'Kuanyama',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3276,'ku','kur','kur',NULL,'Kurdish',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(3428,'lo','lao','lao',NULL,'Lao',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3433,'la','lat','lat',NULL,'Latin',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'A'),(3435,'lv','lav','lav',NULL,'Latvian',NULL,NULL,'Latviešu',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c != 0 ? 2 : 3','L'),(3546,'li','lim','lim',NULL,'Limburgish',NULL,'Limburger',NULL,NULL,NULL,0,'ltr',NULL,'L'),(3547,'ln','lin','lin',NULL,'Lingala',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3553,'lt','lit','lit',NULL,'Lithuanian',NULL,NULL,'Lietuviškai',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c%10>=2 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(3687,'lb','ltz','ltz',NULL,'Letzeburgesch',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3689,'lu','lub','lub',NULL,'Luba-Katanga',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3694,'lg','lug','lug',NULL,'Ganda',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3732,'mh','mah','mah',NULL,'Marshall',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3736,'ml','mal','mal',NULL,'Malayalam',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3740,'mr','mar','mar',NULL,'Marathi',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(3981,'mk','mkd','mkd',NULL,'Macedonian',NULL,NULL,'Македонски',NULL,NULL,0,'ltr',NULL,'L'),(4009,'mg','mlg','mlg',NULL,'Malagasy',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(4022,'mt','mlt','mlt',NULL,'Maltese',NULL,NULL,'Malti',NULL,NULL,0,'ltr',NULL,'L'),(4091,'mo','mol','mol',NULL,'Moldavian',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4093,'mn','mon','mon',NULL,'Mongolian',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(4166,'mi','mri','mri',NULL,'Maori',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4184,'ms','msa','msa',NULL,'Malay','generic',NULL,'Bahasa melayu',NULL,NULL,1,'ltr',NULL,'L'),(4338,'my','mya','mya',NULL,'Burmese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4406,'na','nau','nau',NULL,'Nauru',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4407,'nv','nav','nav',NULL,'Navajo',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4423,'nr','nbl','nbl',NULL,'Ndebele',NULL,'South',NULL,NULL,NULL,0,'ltr',NULL,'L'),(4463,'nd','nde','nde',NULL,'Ndebele',NULL,'North',NULL,NULL,NULL,0,'ltr',NULL,'L'),(4473,'ng','ndo','ndo',NULL,'Ndonga',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4499,'ne','nep','nep',NULL,'Nepali',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4628,'nl','nld','nld',NULL,'Dutch',NULL,NULL,'Nederlands',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(4682,'nn','nno','nno',NULL,'Norwegian Nynorsk',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4695,'nb','nob','nob',NULL,'Norwegian Bokmål',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4709,'no','nor','nor',NULL,'Norwegian',NULL,NULL,'Norsk',NULL,NULL,1,'ltr','c == 1 ? 1 : 2','L'),(4821,'ny','nya','nya',NULL,'Chichewa; Nyanja',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4867,'oc','oci','oci',NULL,'Occitan','post 1500',NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(4891,'oj','oji','oji',NULL,'Ojibwa',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(4965,'or','ori','ori',NULL,'Oriya',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(4967,'om','orm','orm',NULL,'Oromo',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(4984,'os','oss','oss',NULL,'Ossetian; Ossetic',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5031,'pa','pan','pan',NULL,'Panjabi',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5176,'pi','pli','pli',NULL,'Pali',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'A'),(5244,'pl','pol','pol',NULL,'Polish',NULL,NULL,'Polski',NULL,NULL,0,'ltr','c==1 ? 1 : c%10>=2 && c%10<=4 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(5250,'pt','por','por',NULL,'Portuguese',NULL,NULL,'português',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(5343,'ps','pus','pus',NULL,'Pushto',NULL,NULL,'پښتو',NULL,NULL,1,'ltr',NULL,'L'),(5368,'qu','que','que',NULL,'Quechua',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(5525,'rm','roh','roh',NULL,'Raeto-Romance',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5528,'ro','ron','ron',NULL,'Romanian',NULL,NULL,'Română',NULL,NULL,0,'ltr',NULL,'L'),(5552,'rn','run','run',NULL,'Rundi',NULL,NULL,'Kirundi',NULL,NULL,0,'ltr',NULL,'L'),(5556,'ru','rus','rus',NULL,'Russian',NULL,NULL,'Pyccĸий',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c%10>=2 && c%10<=4 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(5576,'sg','sag','sag',NULL,'Sango',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5581,'sa','san','san',NULL,'Sanskrit',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'A'),(5738,'si','sin','sin',NULL,'Sinhalese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5800,'sk','slk','slk',NULL,'Slovak',NULL,NULL,'Slovenčina',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c%10>=2 && c%10<=4 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(5810,'sl','slv','slv',NULL,'Slovenian',NULL,NULL,'Slovenščina',NULL,NULL,0,'ltr','c%100==1 ? 1 : c%100==2 ? 2 : c%100==3 || c%100==4 ? 3 : 4','L'),(5819,'se','sme','sme',NULL,'Northern Sami',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5828,'sm','smo','smo',NULL,'Samoan',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5840,'sn','sna','sna',NULL,'Shona',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5843,'sd','snd','snd',NULL,'Sindhi',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(5876,'so','som','som',NULL,'Somali',NULL,NULL,'Somali',NULL,NULL,0,'ltr',NULL,'L'),(5882,'st','sot','sot',NULL,'Sotho',NULL,'Southern',NULL,NULL,NULL,0,'ltr',NULL,'L'),(5889,'es','spa','spa',NULL,'Spanish',NULL,NULL,'Español',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(5910,'sq','sqi','sqi',NULL,'Albanian',NULL,NULL,'shqip',NULL,NULL,1,'ltr',NULL,'L'),(5921,'sc','srd','srd',NULL,'Sardinian',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(5933,'sr','srp','srp',NULL,'Serbian',NULL,NULL,'Srpski',NULL,NULL,0,'ltr',NULL,'L'),(5964,'ss','ssw','ssw',NULL,'Swati',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6002,'su','sun','sun',NULL,'Sundanese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6021,'sw','swa','swa',NULL,'Swahili','generic',NULL,'Kiswahili',NULL,NULL,1,'ltr',NULL,'L'),(6024,'sv','swe','swe',NULL,'Swedish',NULL,NULL,'svenska',NULL,NULL,0,'ltr','c == 1 ? 1 : 2','L'),(6086,'ty','tah','tah',NULL,'Tahitian',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6090,'ta','tam','tam',NULL,'Tamil',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6097,'tt','tat','tat',NULL,'Tatar',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6182,'te','tel','tel',NULL,'Telugu',NULL,NULL,'తెలుగు',NULL,NULL,0,'ltr',NULL,'L'),(6210,'tg','tgk','tgk',NULL,'Tajik',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6211,'tl','tgl','tgl',NULL,'Tagalog',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6223,'th','tha','tha',NULL,'Thai',NULL,NULL,'ภาษาไทย',NULL,NULL,0,'ltr',NULL,'L'),(6260,'ti','tir','tir',NULL,'Tigrinya',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6383,'to','ton','ton',NULL,'Tonga','Tonga Islands',NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6466,'tn','tsn','tsn',NULL,'Tswana',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6467,'ts','tso','tso',NULL,'Tsonga',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6513,'tk','tuk','tuk',NULL,'Turkmen',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6519,'tr','tur','tur',NULL,'Turkish',NULL,NULL,'Tϋrkçe',NULL,NULL,0,'ltr','c = 1','L'),(6546,'tw','twi','twi',NULL,'Twi',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6630,'ug','uig','uig',NULL,'Uighur',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6640,'uk','ukr','ukr',NULL,'Ukrainian',NULL,NULL,'Українська',NULL,NULL,0,'ltr','c%10==1 && c%100!=11 ? 1 : c%10>=2 && c%10<=4 && (c%100<10 || c%100>=20) ? 2 : 3','L'),(6679,'ur','urd','urd',NULL,'Urdu',NULL,NULL,'اردو',NULL,NULL,0,'ltr',NULL,'L'),(6719,'uz','uzb','uzb',NULL,'Uzbek',NULL,NULL,'o\'zbek',NULL,NULL,1,'ltr',NULL,'L'),(6744,'ve','ven','ven',NULL,'Venda',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6751,'vi','vie','vie',NULL,'Vietnamese',NULL,NULL,'Tiếng Việt',NULL,NULL,0,'ltr',NULL,'L'),(6800,'vo','vol','vol',NULL,'Volapük',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'C'),(6911,'wa','wln','wln',NULL,'Walloon',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(6952,'wo','wol','wol',NULL,'Wolof',NULL,NULL,'Wolof',NULL,NULL,0,'ltr',NULL,'L'),(7078,'xh','xho','xho',NULL,'Xhosa',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(7324,'yi','yid','yid',NULL,'Yiddish',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(7481,'za','zha','zha',NULL,'Zhuang',NULL,NULL,NULL,NULL,NULL,1,'ltr',NULL,'L'),(7484,'zh','zho','zho',NULL,'Chinese',NULL,NULL,'中文',NULL,NULL,1,'ltr',NULL,'L'),(7594,'zu','zul','zul',NULL,'Zulu',NULL,NULL,'isiZulu',NULL,NULL,0,'ltr',NULL,'L'),(7595,NULL,NULL,NULL,'zh-Hant','Traditional Chinese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L'),(7596,NULL,NULL,NULL,'zh-Hans','Simplified Chinese',NULL,NULL,NULL,NULL,NULL,0,'ltr',NULL,'L');
/*!40000 ALTER TABLE `globalize_languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `globalize_translations`
--

DROP TABLE IF EXISTS `globalize_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `globalize_translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `tr_key` varchar(255) DEFAULT NULL,
  `table_name` varchar(255) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `facet` varchar(255) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `pluralization_index` int(11) DEFAULT NULL,
  `text` text,
  `namespace` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tr_origin` varchar(255) DEFAULT NULL,
  `obsolete` tinyint(1) DEFAULT '0',
  `from_bundle` varchar(255) DEFAULT NULL,
  `to_dump` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_globalize_translations_on_tr_key_and_language_id` (`tr_key`,`language_id`),
  KEY `globalize_translations_table_name_and_item_and_language` (`table_name`,`item_id`,`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `globalize_translations`
--

LOCK TABLES `globalize_translations` WRITE;
/*!40000 ALTER TABLE `globalize_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `globalize_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gt`
--

DROP TABLE IF EXISTS `gt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `tr_key` varchar(255) DEFAULT NULL,
  `table_name` varchar(255) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `facet` varchar(255) DEFAULT NULL,
  `built_in` tinyint(1) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `pluralization_index` int(11) DEFAULT NULL,
  `text` text,
  `namespace` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=302 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gt`
--

LOCK TABLES `gt` WRITE;
/*!40000 ALTER TABLE `gt` DISABLE KEYS */;
/*!40000 ALTER TABLE `gt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `impact_counters`
--

DROP TABLE IF EXISTS `impact_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `impact_counters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `counter_kind_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `depth` mediumtext,
  `to_user_id` int(11) DEFAULT NULL,
  `referral_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_impact_counters_on_user_id` (`user_id`),
  KEY `index_impact_counters_on_to_user_id` (`to_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `impact_counters`
--

LOCK TABLES `impact_counters` WRITE;
/*!40000 ALTER TABLE `impact_counters` DISABLE KEYS */;
/*!40000 ALTER TABLE `impact_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inbox_items`
--

DROP TABLE IF EXISTS `inbox_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inbox_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inbox_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `created_by_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `allow_take_to_showcase` tinyint(1) DEFAULT '1',
  `user_id` int(11) DEFAULT NULL,
  `original_content_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_inbox_items_on_inbox_id_and_position` (`inbox_id`,`position`),
  KEY `index_inbox_items_on_content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbox_items`
--

LOCK TABLES `inbox_items` WRITE;
/*!40000 ALTER TABLE `inbox_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `inbox_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invite_requests`
--

DROP TABLE IF EXISTS `invite_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invite_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `circle_id` int(11) DEFAULT NULL,
  `wants_to_join_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` varchar(255) DEFAULT 'pending',
  `invitation_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_invite_requests_on_wants_to_join_id` (`wants_to_join_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invite_requests`
--

LOCK TABLES `invite_requests` WRITE;
/*!40000 ALTER TABLE `invite_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `invite_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invites`
--

DROP TABLE IF EXISTS `invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inviter_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `invitation` text,
  `activation_code` varchar(40) DEFAULT NULL,
  `accepted_at` datetime DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `role_name` varchar(255) DEFAULT NULL,
  `circle_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `reinvited_at` datetime DEFAULT NULL,
  `rejected_at` datetime DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `privacylevel` int(4) NOT NULL DEFAULT '0',
  `free` tinyint(1) DEFAULT NULL,
  `from_lj` tinyint(1) DEFAULT '0',
  `state` varchar(255) DEFAULT 'pending',
  `album_contribution_id` int(11) DEFAULT NULL,
  `join_inviter_to_invited` tinyint(1) NOT NULL DEFAULT '0',
  `initiated_by_invited` tinyint(1) NOT NULL DEFAULT '0',
  `needs_link_to_download` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invite_idx` (`inviter_id`,`circle_id`,`accepted_at`),
  KEY `index_invites_on_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invites`
--

LOCK TABLES `invites` WRITE;
/*!40000 ALTER TABLE `invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_to_locations`
--

DROP TABLE IF EXISTS `ip_to_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_to_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_ip` bigint(20) NOT NULL,
  `to_ip` bigint(20) NOT NULL,
  `country_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ip_to_locations_on_from_ip` (`from_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_to_locations`
--

LOCK TABLES `ip_to_locations` WRITE;
/*!40000 ALTER TABLE `ip_to_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_to_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `karma_points`
--

DROP TABLE IF EXISTS `karma_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `karma_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referrer_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `referral_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `referred_id` int(11) DEFAULT NULL,
  `points` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `karma_lookup` (`referrer_id`,`content_id`),
  KEY `karma_action` (`action`),
  KEY `karma_referrer_action` (`referrer_id`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `karma_points`
--

LOCK TABLES `karma_points` WRITE;
/*!40000 ALTER TABLE `karma_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `karma_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `live_journal_comments`
--

DROP TABLE IF EXISTS `live_journal_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `live_journal_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `comment_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `journal_item_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `state` varchar(1) DEFAULT 'A',
  `user` varchar(255) DEFAULT NULL,
  `property` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  `posted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lj_account_and_post_date` (`account_id`,`posted_at`),
  KEY `lj_comment_account_and_comment` (`account_id`,`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_journal_comments`
--

LOCK TABLES `live_journal_comments` WRITE;
/*!40000 ALTER TABLE `live_journal_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_journal_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `live_journal_entries`
--

DROP TABLE IF EXISTS `live_journal_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `live_journal_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `anum` int(11) DEFAULT NULL,
  `journal_item_id` int(11) DEFAULT NULL,
  `backdated` tinyint(1) DEFAULT NULL,
  `preformatted` tinyint(1) DEFAULT NULL,
  `event` text,
  `subject` varchar(255) DEFAULT NULL,
  `music` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `security` varchar(255) DEFAULT NULL,
  `screening` varchar(255) DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content_id` int(11) NOT NULL DEFAULT '0',
  `comments` int(11) NOT NULL DEFAULT '0',
  `taglist` varchar(2048) DEFAULT NULL,
  `event_cut` text,
  `event_formatted` text,
  PRIMARY KEY (`id`),
  KEY `lj_entries_account_and_item` (`account_id`,`journal_item_id`),
  KEY `index_live_journal_entries_on_content_id_and_posted_at` (`content_id`,`posted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_journal_entries`
--

LOCK TABLES `live_journal_entries` WRITE;
/*!40000 ALTER TABLE `live_journal_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_journal_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `live_journal_friends`
--

DROP TABLE IF EXISTS `live_journal_friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `live_journal_friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `last_sync` datetime DEFAULT '1970-01-01 00:00:00',
  PRIMARY KEY (`id`),
  KEY `index_live_journal_friends_on_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_journal_friends`
--

LOCK TABLES `live_journal_friends` WRITE;
/*!40000 ALTER TABLE `live_journal_friends` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_journal_friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moderation_events`
--

DROP TABLE IF EXISTS `moderation_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `moderation_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `message` text,
  `reportable_type` varchar(255) DEFAULT NULL,
  `reportable_id` int(11) DEFAULT NULL,
  `flag_type` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reports_on_reportable_type_and_reportable_id` (`reportable_type`,`reportable_id`),
  KEY `index_reports_on_reason` (`reason`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_events`
--

LOCK TABLES `moderation_events` WRITE;
/*!40000 ALTER TABLE `moderation_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `moderation_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monetary_contributions`
--

DROP TABLE IF EXISTS `monetary_contributions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monetary_contributions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `account_setting_id` int(11) DEFAULT NULL,
  `payer_id` int(11) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `payer_email` varchar(255) DEFAULT NULL,
  `auth_amount` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `payment_api` varchar(255) DEFAULT NULL,
  `user_kroog_id` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `param_set` text,
  `verified` tinyint(1) DEFAULT '0',
  `invite_id` int(11) DEFAULT NULL,
  `currency_type` varchar(255) DEFAULT NULL,
  `suspect` tinyint(1) DEFAULT '1',
  `sponsorship_expiration_date` datetime DEFAULT NULL,
  `last_notified_of_expiration` datetime DEFAULT NULL,
  `sms_payload_id` int(11) DEFAULT NULL,
  `amount_transferred_after_fees` decimal(10,2) DEFAULT NULL,
  `gross_usd` decimal(11,6) DEFAULT NULL,
  `conversion_rate` decimal(11,6) DEFAULT NULL,
  `billable` tinyint(1) DEFAULT '1',
  `bill_id` int(11) DEFAULT NULL,
  `billable_usd` decimal(11,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_monetary_contributions_on_announcement_id` (`content_id`),
  KEY `index_monetary_contributions_on_account_setting_id` (`account_setting_id`),
  KEY `index_monetary_contributions_on_user_kroog_id` (`user_kroog_id`),
  KEY `index_monetary_contributions_on_bill_id` (`bill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monetary_contributions`
--

LOCK TABLES `monetary_contributions` WRITE;
/*!40000 ALTER TABLE `monetary_contributions` DISABLE KEYS */;
/*!40000 ALTER TABLE `monetary_contributions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monetary_processor_accounts`
--

DROP TABLE IF EXISTS `monetary_processor_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monetary_processor_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_setting_id` int(11) DEFAULT NULL,
  `monetary_processor_id` int(11) DEFAULT NULL,
  `account_identifier` varchar(255) DEFAULT NULL,
  `account_type` varchar(255) DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `account_level` int(11) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_mpas_on_account_setting_id_and_verified_at` (`account_setting_id`,`verified_at`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monetary_processor_accounts`
--

LOCK TABLES `monetary_processor_accounts` WRITE;
/*!40000 ALTER TABLE `monetary_processor_accounts` DISABLE KEYS */;
INSERT INTO `monetary_processor_accounts` VALUES (82,2,2,'2',NULL,'2010-05-19 17:42:52','2010-05-19 17:42:52','2010-05-26 15:58:12','2010-05-26 15:58:11','WebMoneyAccount','chief',NULL,'removed',NULL,2,2),(83,427,1,'kuryokhin.center@gmail.com',NULL,'2010-05-27 17:02:59','2010-08-25 14:56:44','2010-08-25 14:56:44',NULL,'PaypalAccount',NULL,NULL,'verified',NULL,441,441);
/*!40000 ALTER TABLE `monetary_processor_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monetary_processors`
--

DROP TABLE IF EXISTS `monetary_processors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monetary_processors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `short_name` varchar(255) DEFAULT NULL,
  `allow_withdrawal` tinyint(1) DEFAULT '0',
  `allow_donation` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `allow_donations_in_regions` varchar(255) NOT NULL,
  `display_order` int(11) NOT NULL,
  `currency` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_monetary_processors_on_display_order` (`display_order`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monetary_processors`
--

LOCK TABLES `monetary_processors` WRITE;
/*!40000 ALTER TABLE `monetary_processors` DISABLE KEYS */;
INSERT INTO `monetary_processors` VALUES (1,'PayPal','paypal',1,1,'2009-08-21 21:45:39','2010-05-06 14:22:11','NA EU RU OTHER',10,'usd'),(2,'WebMoney (USD)','webmoney_usd',1,0,'2009-08-21 21:45:39','2010-05-06 14:22:11','NA EU RU OTHER',20,'usd'),(3,'WebMoney (RUR)','webmoney_rur',0,0,'2009-08-21 21:45:39','2010-05-06 14:22:11','NA EU RU OTHER',30,'rur'),(4,'WebMoney (EUR)','webmoney_eur',0,0,'2009-08-21 21:45:39','2010-05-06 14:22:11','NA EU RU OTHER',40,'eur'),(5,'SMS','movable_broker',0,0,'2009-08-21 21:45:39','2010-05-26 15:58:12','NA EU RU OTHER',50,NULL),(6,'Visa, MasterCard, American Express, Discover','credit_card',0,1,'2009-10-07 12:43:47','2010-05-06 14:22:11','NA EU RU OTHER',15,'usd'),(7,'WebMoney','webmoney_all',0,1,'2009-10-12 22:05:25','2009-10-12 22:05:25','NA EU RU OTHER',20,NULL),(8,'Yandex.Money','yandex',0,1,'2009-10-21 19:46:51','2010-07-08 17:11:04','NA EU RU OTHER',17,'usd'),(9,'SMS','smscoin',0,1,'2010-04-23 13:34:53','2010-04-23 13:34:53','NA EU RU OTHER',60,NULL);
/*!40000 ALTER TABLE `monetary_processors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monetary_transactions`
--

DROP TABLE IF EXISTS `monetary_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monetary_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receiver_account_setting_id` int(11) DEFAULT NULL,
  `sender_account_setting_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `monetary_processor_account_id` int(11) DEFAULT NULL,
  `currency_id` int(11) DEFAULT NULL,
  `monetary_processor_id` int(11) DEFAULT NULL,
  `monetary_processor_log` text,
  `gross_amount` decimal(11,2) DEFAULT '0.00',
  `gross_amount_usd` decimal(11,2) DEFAULT '0.00',
  `monetary_processor_fee_usd` decimal(11,2) DEFAULT '0.00',
  `net_amount_usd` decimal(11,2) DEFAULT '0.00',
  `payable_amount_usd` decimal(11,2) DEFAULT '0.00',
  `handling_fee_usd` decimal(11,2) DEFAULT '0.00',
  `applied_to_balance` tinyint(1) DEFAULT '0',
  `suspicious` tinyint(1) DEFAULT '0',
  `paid` tinyint(1) DEFAULT '0',
  `type` varchar(255) DEFAULT NULL,
  `available_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `invite_id` int(11) DEFAULT NULL,
  `sms_payload_id` int(11) DEFAULT NULL,
  `conversion_rate` decimal(11,6) DEFAULT NULL,
  `sender_email` varchar(255) DEFAULT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `params` text,
  `user_kroog_id` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `billable` tinyint(1) DEFAULT '0',
  `state` varchar(255) DEFAULT NULL,
  `karma_point_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mt_r_c` (`receiver_account_setting_id`,`content_id`),
  KEY `mt_t` (`type`),
  KEY `index_monetary_transactions_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monetary_transactions`
--

LOCK TABLES `monetary_transactions` WRITE;
/*!40000 ALTER TABLE `monetary_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `monetary_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movable_countries`
--

DROP TABLE IF EXISTS `movable_countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movable_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `force_prefix` varchar(255) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `default_brand` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25571 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movable_countries`
--

LOCK TABLES `movable_countries` WRITE;
/*!40000 ALTER TABLE `movable_countries` DISABLE KEYS */;
INSERT INTO `movable_countries` VALUES (25568,'Литва','LTL',NULL,'0.18',22,NULL,4261),(25567,'Латвия','LVL',NULL,'0.18',21,NULL,4261),(25566,'Эстония','EEK',NULL,'0.18',20,NULL,4261),(25565,'Киргизия','USD',NULL,'0.20',5,NULL,4261),(25564,'Казахстан','KZT',NULL,'0.13',4,NULL,4261),(25563,'Украина','UAH',NULL,'0.20',2,NULL,4261),(25562,'Россия','RUB',NULL,'0.18',1,NULL,4261),(25569,'Германия','EUR',NULL,'0.19',24,NULL,4261),(25570,'Израиль','ILS',NULL,'0.16',26,NULL,4261);
/*!40000 ALTER TABLE `movable_countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movable_numbers`
--

DROP TABLE IF EXISTS `movable_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movable_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `force_prefix` varchar(255) DEFAULT NULL,
  `movable_operator_id` int(11) DEFAULT NULL,
  `formatted_cost` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_movable_numbers_on_movable_operator_id_and_version` (`movable_operator_id`,`version`)
) ENGINE=MyISAM AUTO_INCREMENT=1186258 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movable_numbers`
--

LOCK TABLES `movable_numbers` WRITE;
/*!40000 ALTER TABLE `movable_numbers` DISABLE KEYS */;
INSERT INTO `movable_numbers` VALUES (1186244,4070,300,'zm1+',198812,'3.00',4261),(1186243,4070,200,'zm3+',198812,'2.00',4261),(1186242,4070,100,'zm4+',198812,'1.00',4261),(1186241,82300,500,'zm3+',198811,'5.00',4261),(1186240,82300,300,'zm2+',198811,'3.00',4261),(1186239,82300,200,'zm1+',198811,'2.00',4261),(1186238,82300,500,'zm3+',198810,'5.00',4261),(1186237,82300,300,'zm2+',198810,'3.00',4261),(1186236,82300,200,'zm1+',198810,'2.00',4261),(1186235,82300,500,'zm3+',198809,'5.00',4261),(1186234,82300,300,'zm2+',198809,'3.00',4261),(1186233,82300,200,'zm1+',198809,'2.00',4261),(1186232,82300,500,'zm3+',198808,'5.00',4261),(1186231,82300,300,'zm2+',198808,'3.00',4261),(1186230,82300,200,'zm1+',198808,'2.00',4261),(1186229,1624,450,'zm9+',198807,'4.50',4261),(1186228,1624,400,'zm8+',198807,'4.00',4261),(1186227,1624,350,'zm7+',198807,'3.50',4261),(1186226,1624,300,'zm6+',198807,'3.00',4261),(1186225,1624,250,'zm5+',198807,'2.50',4261),(1186224,1624,200,'zm4+',198807,'2.00',4261),(1186223,1624,150,'zm3+',198807,'1.50',4261),(1186222,1624,100,'zm2+',198807,'1.00',4261),(1186221,1624,50,'zm1+',198807,'0.50',4261),(1186220,1624,450,'zm9+',198806,'4.50',4261),(1186219,1624,400,'zm8+',198806,'4.00',4261),(1186218,1624,350,'zm7+',198806,'3.50',4261),(1186217,1624,300,'zm6+',198806,'3.00',4261),(1186216,1624,250,'zm5+',198806,'2.50',4261),(1186215,1624,200,'zm4+',198806,'2.00',4261),(1186214,1624,150,'zm3+',198806,'1.50',4261),(1186213,1624,100,'zm2+',198806,'1.00',4261),(1186212,1624,50,'zm1+',198806,'0.50',4261),(1186211,1624,450,'zm9+',198805,'4.50',4261),(1186210,1624,400,'zm8+',198805,'4.00',4261),(1186209,1624,350,'zm7+',198805,'3.50',4261),(1186208,1624,300,'zm6+',198805,'3.00',4261),(1186207,1624,250,'zm5+',198805,'2.50',4261),(1186206,1624,200,'zm4+',198805,'2.00',4261),(1186205,1624,150,'zm3+',198805,'1.50',4261),(1186204,1624,100,'zm2+',198805,'1.00',4261),(1186203,1624,50,'zm1+',198805,'0.50',4261),(1186202,1824,300,'zm4+',198804,'3.00',4261),(1186201,1824,200,'zm3+',198804,'2.00',4261),(1186200,1824,100,'zm2+',198804,'1.00',4261),(1186199,1824,50,'zm1+',198804,'0.50',4261),(1186198,1824,300,'zm4+',198803,'3.00',4261),(1186197,1824,200,'zm3+',198803,'2.00',4261),(1186196,1824,100,'zm2+',198803,'1.00',4261),(1186195,1824,50,'zm1+',198803,'0.50',4261),(1186194,1824,300,'zm4+',198802,'3.00',4261),(1186193,1824,200,'zm3+',198802,'2.00',4261),(1186192,1824,100,'zm2+',198802,'1.00',4261),(1186191,1824,50,'zm1+',198802,'0.50',4261),(1186190,1206,400,'zm',198801,'4.00',4261),(1186189,1204,300,'zm',198801,'3.00',4261),(1186188,1302,100,'zm',198801,'1.00',4261),(1186187,1206,400,'zm',198800,'4.00',4261),(1186186,1204,300,'zm',198800,'3.00',4261),(1186185,1302,100,'zm',198800,'1.00',4261),(1186184,1206,400,'zm',198799,'4.00',4261),(1186183,1204,300,'zm',198799,'3.00',4261),(1186182,1302,100,'zm',198799,'1.00',4261),(1186181,4161,500,'-z',198798,'5.00',4261),(1186180,4449,400,'-z',198798,'4.00',4261),(1186179,4446,100,'-z',198798,'1.00',4261),(1186178,4444,30,'-z',198798,'0.30',4261),(1186177,4161,400,'-z',198797,'4.00',4261),(1186176,4449,300,'-z',198797,'3.00',4261),(1186175,4446,100,'-z',198797,'1.00',4261),(1186174,4444,30,'-z',198797,'0.30',4261),(1186173,4161,400,'-z',198796,'4.00',4261),(1186172,8444,200,'-z',198796,'2.00',4261),(1186171,4446,100,'-z',198796,'1.00',4261),(1186170,4445,50,'-z',198796,'0.50',4261),(1186169,4444,30,'-z',198796,'0.30',4261),(1186168,4443,15,'-z',198796,'0.15',4261),(1186167,4161,400,'-z',198795,'4.00',4261),(1186166,4449,300,'-z',198795,'3.00',4261),(1186165,8444,200,'-z',198795,'2.00',4261),(1186164,4446,100,'-z',198795,'1.00',4261),(1186163,4161,400,'-z',198794,'4.00',4261),(1186162,4449,300,'-z',198794,'3.00',4261),(1186161,4446,100,'-z',198794,'1.00',4261),(1186160,4444,30,'-z',198794,'0.30',4261),(1186159,4161,400,'-z',198793,'4.00',4261),(1186158,4449,300,'-z',198793,'3.00',4261),(1186157,4448,200,'-z',198793,'2.00',4261),(1186156,4446,100,'-z',198793,'1.00',4261),(1186155,4445,50,'-z',198793,'0.50',4261),(1186154,4444,30,'-z',198793,'0.30',4261),(1186153,4443,15,'-z',198793,'0.15',4261),(1186152,4161,400,'-z',198792,'4.00',4261),(1186151,4449,300,'-z',198792,'3.00',4261),(1186150,4448,200,'-z',198792,'2.00',4261),(1186149,4446,100,'-z',198792,'1.00',4261),(1186148,4445,50,'-z',198792,'0.50',4261),(1186147,4444,30,'-z',198792,'0.30',4261),(1186146,4443,15,'-z',198792,'0.15',4261),(1186145,4161,400,'-z',198791,'4.00',4261),(1186144,4449,300,'-z',198791,'3.00',4261),(1186143,4448,200,'-z',198791,'2.00',4261),(1186142,4446,100,'-z',198791,'1.00',4261),(1186141,4445,50,'-z',198791,'0.50',4261),(1186140,4444,30,'-z',198791,'0.30',4261),(1186139,4443,15,'-z',198791,'0.15',4261),(1186138,4161,400,'-z',198790,'4.00',4261),(1186137,4449,300,'-z',198790,'3.00',4261),(1186136,4448,200,'-z',198790,'2.00',4261),(1186135,4446,100,'-z',198790,'1.00',4261),(1186134,4445,50,'-z',198790,'0.50',4261),(1186133,4444,30,'-z',198790,'0.30',4261),(1186132,4443,15,'-z',198790,'0.15',4261),(1186131,7733,1000,'zam',198789,'10.00',4261),(1186130,4161,500,'zam',198789,'5.00',4261),(1186129,4449,300,'-z',198789,'3.00',4261),(1186128,4448,200,'-z',198789,'2.00',4261),(1186127,4446,100,'zam',198789,'1.00',4261),(1186126,4445,50,'-z',198789,'0.50',4261),(1186125,4444,30,'-z',198789,'0.30',4261),(1186124,4443,15,'-z',198789,'0.15',4261),(1186123,4161,500,'zam',198788,'5.00',4261),(1186122,4449,300,'-z',198788,'3.00',4261),(1186121,4448,200,'-z',198788,'2.00',4261),(1186120,4446,100,'zam',198788,'1.00',4261),(1186119,4445,50,'-z',198788,'0.50',4261),(1186118,4444,30,'-z',198788,'0.30',4261),(1186117,4443,15,'-z',198788,'0.15',4261),(1186116,4449,300,'-z',198787,'3.00',4261),(1186115,4448,200,'-z',198787,'2.00',4261),(1186114,4446,100,'zam',198787,'1.00',4261),(1186113,4445,50,'-z',198787,'0.50',4261),(1186112,4444,30,'-z',198787,'0.30',4261),(1186111,4443,15,'-z',198787,'0.15',4261),(1186110,7733,1000,'zam',198786,'10.00',4261),(1186109,4161,500,'zam',198786,'5.00',4261),(1186108,4449,300,'-z',198786,'3.00',4261),(1186107,4448,200,'-z',198786,'2.00',4261),(1186106,4446,100,'zam',198786,'1.00',4261),(1186105,4445,50,'-z',198786,'0.50',4261),(1186104,4444,30,'-z',198786,'0.30',4261),(1186103,4161,500,'zam',198785,'5.00',4261),(1186102,4449,300,'-z',198785,'3.00',4261),(1186101,4448,200,'-z',198785,'2.00',4261),(1186100,4445,50,'-z',198785,'0.50',4261),(1186099,4444,30,'-z',198785,'0.30',4261),(1186098,4443,15,'-z',198785,'0.15',4261),(1186097,4161,500,'zam',198784,'5.00',4261),(1186096,4449,300,'-z',198784,'3.00',4261),(1186095,4448,200,'-z',198784,'2.00',4261),(1186094,4446,100,'zam',198784,'1.00',4261),(1186093,4445,50,'-z',198784,'0.50',4261),(1186092,4444,30,'-z',198784,'0.30',4261),(1186091,4443,15,'-z',198784,'0.15',4261),(1186090,4449,300,'-z',198783,'3.00',4261),(1186089,4448,200,'-z',198783,'2.00',4261),(1186088,4446,100,'zam',198783,'1.00',4261),(1186087,4445,50,'-z',198783,'0.50',4261),(1186086,4444,30,'-z',198783,'0.30',4261),(1186085,4443,15,'-z',198783,'0.15',4261),(1186084,4161,500,'zam',198782,'5.00',4261),(1186083,4449,300,'-z',198782,'3.00',4261),(1186082,4448,200,'-z',198782,'2.00',4261),(1186081,4446,100,'zam',198782,'1.00',4261),(1186080,4445,50,'-z',198782,'0.50',4261),(1186079,4444,30,'-z',198782,'0.30',4261),(1186078,4443,15,'-z',198782,'0.15',4261),(1186077,4449,300,'-z',198781,'3.00',4261),(1186076,4448,200,'-z',198781,'2.00',4261),(1186075,4448,200,'-z',198781,'2.00',4261),(1186074,4446,100,'zam',198781,'1.00',4261),(1186073,4445,50,'-z',198781,'0.50',4261),(1186072,4444,30,'-z',198781,'0.30',4261),(1186071,4443,15,'-z',198781,'0.15',4261),(1186070,7733,1000,'zam',198780,'10.00',4261),(1186069,4161,500,'zam',198780,'5.00',4261),(1186068,4449,300,'-z',198780,'3.00',4261),(1186067,4448,200,'-z',198780,'2.00',4261),(1186066,4446,100,'zam',198780,'1.00',4261),(1186065,4445,50,'-z',198780,'0.50',4261),(1186064,4444,30,'-z',198780,'0.30',4261),(1186063,4443,15,'-z',198780,'0.15',4261),(1186062,7733,1000,'zam',198779,'10.00',4261),(1186061,4161,500,'zam',198779,'5.00',4261),(1186060,4449,300,'-z',198779,'3.00',4261),(1186059,4448,200,'-z',198779,'2.00',4261),(1186058,4446,100,'zam',198779,'1.00',4261),(1186057,4445,50,'-z',198779,'0.50',4261),(1186056,4444,30,'-z',198779,'0.30',4261),(1186055,4443,15,'-z',198779,'0.15',4261),(1186054,7733,1000,'zam',198778,'10.00',4261),(1186053,4161,500,'zam',198778,'5.00',4261),(1186052,4449,300,'-z',198778,'3.00',4261),(1186051,4448,200,'-z',198778,'2.00',4261),(1186050,4446,100,'zam',198778,'1.00',4261),(1186049,4445,50,'-z',198778,'0.50',4261),(1186048,4444,30,'-z',198778,'0.30',4261),(1186047,4443,15,'-z',198778,'0.15',4261),(1186046,7733,1000,'zam',198777,'10.00',4261),(1186045,4161,500,'zam',198777,'5.00',4261),(1186044,4449,300,'-z',198777,'3.00',4261),(1186043,4448,200,'-z',198777,'2.00',4261),(1186042,4446,100,'zam',198777,'1.00',4261),(1186041,4445,50,'-z',198777,'0.50',4261),(1186040,4444,30,'-z',198777,'0.30',4261),(1186039,4443,15,'-z',198777,'0.15',4261),(1186038,4449,300,'-z',198776,'3.00',4261),(1186037,4448,200,'-z',198776,'2.00',4261),(1186036,4446,100,'zam',198776,'1.00',4261),(1186035,4445,50,'-z',198776,'0.50',4261),(1186034,4444,30,'-z',198776,'0.30',4261),(1186033,4443,15,'-z',198776,'0.15',4261),(1186032,7733,1000,'zam',198775,'10.00',4261),(1186031,4161,500,'zam',198775,'5.00',4261),(1186030,4449,300,'-z',198775,'3.00',4261),(1186029,4448,200,'-z',198775,'2.00',4261),(1186028,4446,100,'zam',198775,'1.00',4261),(1186027,4445,50,'-z',198775,'0.50',4261),(1186026,4444,30,'-z',198775,'0.30',4261),(1186025,4443,15,'-z',198775,'0.15',4261),(1186024,7733,1000,'zam',198774,'10.00',4261),(1186023,4161,500,'zam',198774,'5.00',4261),(1186022,4449,300,'-z',198774,'3.00',4261),(1186021,4448,200,'-z',198774,'2.00',4261),(1186020,4446,100,'zam',198774,'1.00',4261),(1186019,4445,50,'-z',198774,'0.50',4261),(1186018,4444,30,'-z',198774,'0.30',4261),(1186017,4443,15,'-z',198774,'0.15',4261),(1186016,4161,400,'zam',198773,'4.00',4261),(1186015,4449,300,'-z',198773,'3.00',4261),(1186014,4448,200,'-z',198773,'2.00',4261),(1186013,4446,100,'zam',198773,'1.00',4261),(1186012,4445,50,'-z',198773,'0.50',4261),(1186011,4444,30,'-z',198773,'0.30',4261),(1186010,4443,15,'-z',198773,'0.15',4261),(1186009,7733,1000,'zam',198772,'10.00',4261),(1186008,4161,500,'zam',198772,'5.00',4261),(1186007,4449,300,'-z',198772,'3.00',4261),(1186006,4448,200,'-z',198772,'2.00',4261),(1186005,4446,100,'zam',198772,'1.00',4261),(1186004,4445,50,'-z',198772,'0.50',4261),(1186003,4444,30,'-z',198772,'0.30',4261),(1186002,4443,15,'-z',198772,'0.15',4261),(1186001,7733,1000,'zam',198771,'10.00',4261),(1186000,4161,500,'zam',198771,'5.00',4261),(1185999,4449,300,'-z',198771,'3.00',4261),(1185998,4448,200,'-z',198771,'2.00',4261),(1185997,4446,100,'zam',198771,'1.00',4261),(1185996,4445,50,'-z',198771,'0.50',4261),(1185995,4444,30,'-z',198771,'0.30',4261),(1185994,4443,15,'-z',198771,'0.15',4261),(1185993,7733,1000,'zam',198770,'10.00',4261),(1185992,4161,500,'zam',198770,'5.00',4261),(1185991,4449,300,'-z',198770,'3.00',4261),(1185990,4448,200,'-z',198770,'2.00',4261),(1185989,4446,100,'zam',198770,'1.00',4261),(1185988,4445,50,'-z',198770,'0.50',4261),(1185987,4444,30,'-z',198770,'0.30',4261),(1185986,4443,15,'-z',198770,'0.15',4261),(1185985,7733,500,'zam',198769,'5.00',4261),(1185984,4161,400,'zam',198769,'4.00',4261),(1185983,4449,300,'-z',198769,'3.00',4261),(1185982,4448,200,'-z',198769,'2.00',4261),(1185981,4446,100,'zam',198769,'1.00',4261),(1185980,4445,50,'-z',198769,'0.50',4261),(1185979,4444,30,'-z',198769,'0.30',4261),(1185978,4443,15,'-z',198769,'0.15',4261),(1185977,7733,400,'zam',198768,'4.00',4261),(1185976,4445,50,'-z',198768,'0.50',4261),(1185975,4444,30,'-z',198768,'0.30',4261),(1185974,4443,15,'-z',198768,'0.15',4261),(1185973,7733,1000,'zam',198767,'10.00',4261),(1185972,4161,500,'zam',198767,'5.00',4261),(1185971,4449,300,'-z',198767,'3.00',4261),(1185970,4448,200,'-z',198767,'2.00',4261),(1185969,4446,100,'zam',198767,'1.00',4261),(1185968,4445,50,'-z',198767,'0.50',4261),(1185967,4444,30,'-z',198767,'0.30',4261),(1185966,4443,15,'-z',198767,'0.15',4261),(1185965,7733,1000,'zam',198766,'10.00',4261),(1185964,4161,500,'zam',198766,'5.00',4261),(1185963,4449,300,'-z',198766,'3.00',4261),(1185962,4448,200,'-z',198766,'2.00',4261),(1185961,4446,100,'zam',198766,'1.00',4261),(1185960,4445,50,'zam',198766,'0.50',4261),(1185959,4444,30,'-z',198766,'0.30',4261),(1185958,4443,15,'-z',198766,'0.15',4261),(1185957,7733,1000,'zam',198765,'10.00',4261),(1185956,4161,500,'zam',198765,'5.00',4261),(1185955,4449,250,'-z',198765,'2.50',4261),(1185954,4448,200,'-z',198765,'2.00',4261),(1185953,4446,100,'zam',198765,'1.00',4261),(1185952,4445,50,'zam',198765,'0.50',4261),(1185951,4444,30,'-z',198765,'0.30',4261),(1185950,4443,15,'-z',198765,'0.15',4261),(1185949,7733,1000,'zam',198764,'10.00',4261),(1185948,4161,500,'zam',198764,'5.00',4261),(1185947,4449,300,'-z',198764,'3.00',4261),(1185946,4448,200,'-z',198764,'2.00',4261),(1185945,4446,100,'zam',198764,'1.00',4261),(1185944,4445,50,'zam',198764,'0.50',4261),(1185943,4444,30,'-z',198764,'0.30',4261),(1185942,4443,15,'-z',198764,'0.15',4261),(1185941,7733,500,'zam',198763,'5.00',4261),(1185940,4449,300,'-z',198763,'3.00',4261),(1185939,4448,200,'-z',198763,'2.00',4261),(1185938,4446,100,'zam',198763,'1.00',4261),(1185937,4445,50,'zam',198763,'0.50',4261),(1185936,4444,30,'-z',198763,'0.30',4261),(1185935,4443,15,'-z',198763,'0.15',4261),(1186245,4070,400,'zm2+',198812,'4.00',4261),(1186246,4070,100,'zm4+',198813,'1.00',4261),(1186247,4070,200,'zm3+',198813,'2.00',4261),(1186248,4070,300,'zm1+',198813,'3.00',4261),(1186249,4070,400,'zm2+',198813,'4.00',4261),(1186250,4070,100,'zm4+',198814,'1.00',4261),(1186251,4070,200,'zm3+',198814,'2.00',4261),(1186252,4070,300,'zm1+',198814,'3.00',4261),(1186253,4070,400,'zm2+',198814,'4.00',4261),(1186254,4070,100,'zm4+',198815,'1.00',4261),(1186255,4070,200,'zm3+',198815,'2.00',4261),(1186256,4070,300,'zm1+',198815,'3.00',4261),(1186257,4070,400,'zm2+',198815,'4.00',4261);
/*!40000 ALTER TABLE `movable_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movable_operators`
--

DROP TABLE IF EXISTS `movable_operators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movable_operators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `mid` varchar(255) DEFAULT NULL,
  `movable_country_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_movable_operators_on_movable_country_id_and_version` (`movable_country_id`,`version`)
) ENGINE=MyISAM AUTO_INCREMENT=198816 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movable_operators`
--

LOCK TABLES `movable_operators` WRITE;
/*!40000 ALTER TABLE `movable_operators` DISABLE KEYS */;
INSERT INTO `movable_operators` VALUES (198815,'Mirs','76',25570,4261),(198814,'Cellcom','57',25570,4261),(198813,'Pelephone','56',25570,4261),(198812,'Orange','55',25570,4261),(198811,'O2','48',25569,4261),(198810,'E-Plus','47',25569,4261),(198809,'Vodafone','46',25569,4261),(198808,'T-Mobile','45',25569,4261),(198807,'Bite','96',25568,4261),(198806,'Tele2','95',25568,4261),(198805,'Omnitel','94',25568,4261),(198804,'Bite','61',25567,4261),(198803,'Tele2','60',25567,4261),(198802,'LMT','59',25567,4261),(198801,'Tele2','82',25566,4261),(198800,'EMT','81',25566,4261),(198799,'Elisa','80',25566,4261),(198798,'Bitel','37',25565,4261),(198797,'NEO','78',25564,4261),(198796,'Altel','77',25564,4261),(198795,'Билайн Казахстан','41',25564,4261),(198794,'KCell','13',25564,4261),(198793,'КиевСтар, DJUICE','21',25563,4261),(198792,'Life','20',25563,4261),(198791,'Билайн (WellCOM)','19',25563,4261),(198790,'МТС, UMC JEANS','18',25563,4261),(198789,'НСС Саратовский филиал','92',25562,4261),(198788,'НСС РМ','91',25562,4261),(198787,'НСС Чувашия','90',25562,4261),(198786,'Мобилфон','89',25562,4261),(198784,'Шупашкар GSM','87',25562,4261),(198785,'Ярославль GSM','88',25562,4261),(198783,'Волгоград GSM','86',25562,4261),(198782,'Астрахань GSM','85',25562,4261),(198781,'Пенза GSM','67',25562,4261),(198780,'БашСелл','66',25562,4261),(198779,'АКОС GSM','65',25562,4261),(198778,'УралСвязьИнформ','42',25562,4261),(198777,'Ульяновск GSM','30',25562,4261),(198775,'СТеК GSM','28',25562,4261),(198776,'Татинком-Т','29',25562,4261),(198774,'Оренбург-GSM','27',25562,4261),(198773,'Нижегородская сотовая связь','26',25562,4261),(198772,'Байкалвестком','22',25562,4261),(198771,'МОТИВ','15',25562,4261),(198770,'СМАРТС','12',25562,4261),(198769,'НТК','10',25562,4261),(198768,'ВолгаТелеком','8',25562,4261),(198767,'Skylink','7',25562,4261),(198766,'BEE LINE','6',25562,4261),(198765,'TELE2','5',25562,4261),(198764,'МТС','4',25562,4261),(198763,'Мегафон','3',25562,4261);
/*!40000 ALTER TABLE `movable_operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movable_version`
--

DROP TABLE IF EXISTS `movable_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movable_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `current` int(11) DEFAULT '1',
  `last_updated` datetime DEFAULT NULL,
  `last_updated_from_ip` varchar(255) DEFAULT NULL,
  `last_update_attempted` datetime DEFAULT NULL,
  `last_update_succeeded` datetime DEFAULT NULL,
  `cached_data_digest` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movable_version`
--

LOCK TABLES `movable_version` WRITE;
/*!40000 ALTER TABLE `movable_version` DISABLE KEYS */;
INSERT INTO `movable_version` VALUES (1,4261,'2009-02-20 14:01:22',NULL,'2009-09-06 11:25:01','2009-09-06 11:25:01','f55c152b074f58d2c5acc70bffc636e0');
/*!40000 ALTER TABLE `movable_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `music_contest_details`
--

DROP TABLE IF EXISTS `music_contest_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `music_contest_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `second_title` varchar(255) DEFAULT NULL,
  `second_title_ru` varchar(255) DEFAULT NULL,
  `second_title_fr` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `accepts_submissions` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `terms_and_conditions_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_music_contest_details_on_content_id` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `music_contest_details`
--

LOCK TABLES `music_contest_details` WRITE;
/*!40000 ALTER TABLE `music_contest_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `music_contest_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `new_contents`
--

DROP TABLE IF EXISTS `new_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `new_contents_content_id` (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=757 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `new_contents`
--

LOCK TABLES `new_contents` WRITE;
/*!40000 ALTER TABLE `new_contents` DISABLE KEYS */;
INSERT INTO `new_contents` VALUES (756,9426);
/*!40000 ALTER TABLE `new_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_associations`
--

DROP TABLE IF EXISTS `open_id_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_id_associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` blob,
  `handle` varchar(255) DEFAULT NULL,
  `secret` blob,
  `issued` int(11) DEFAULT NULL,
  `lifetime` int(11) DEFAULT NULL,
  `assoc_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_id_associations`
--

LOCK TABLES `open_id_associations` WRITE;
/*!40000 ALTER TABLE `open_id_associations` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_associations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `open_id_nonces`
--

DROP TABLE IF EXISTS `open_id_nonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `open_id_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `salt` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `open_id_nonces`
--

LOCK TABLES `open_id_nonces` WRITE;
/*!40000 ALTER TABLE `open_id_nonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `open_id_nonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `crypted_password` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_items`
--

DROP TABLE IF EXISTS `playlist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playlist_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `track_id` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `is_playing` tinyint(1) DEFAULT '0',
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_playlist_items_on_playlist_id_and_position` (`playlist_id`,`position`),
  KEY `index_playlist_items_on_playlist_id_and_is_playing` (`playlist_id`,`is_playing`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_items`
--

LOCK TABLES `playlist_items` WRITE;
/*!40000 ALTER TABLE `playlist_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlist_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `session_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_playlists_on_user_id_and_name` (`user_id`,`name`),
  KEY `index_playlists_on_id_and_user_id_and_session_id_and_name` (`id`,`user_id`,`session_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferences`
--

DROP TABLE IF EXISTS `preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '1',
  `email_notifications` int(11) NOT NULL DEFAULT '1',
  `name_context` varchar(255) DEFAULT 'general',
  `email_locale` varchar(255) DEFAULT 'en',
  `anonymous_stats` tinyint(1) DEFAULT '0',
  `shy_founders_ids` varchar(255) DEFAULT NULL,
  `show_founders_tab` tinyint(1) DEFAULT '1',
  `show_founders_module` tinyint(1) DEFAULT '1',
  `active_circle_ids` varchar(255) DEFAULT '--- []',
  `show_last_active` tinyint(1) DEFAULT '1',
  `getting_around_open` tinyint(1) DEFAULT '1',
  `current_locale` varchar(10) DEFAULT NULL,
  `email_searchable` tinyint(1) DEFAULT '0',
  `show_feed_music` tinyint(1) NOT NULL DEFAULT '1',
  `show_feed_pics` tinyint(1) NOT NULL DEFAULT '1',
  `show_feed_texts` tinyint(1) NOT NULL DEFAULT '1',
  `show_feed_videos` tinyint(1) NOT NULL DEFAULT '1',
  `show_feed_people` tinyint(1) NOT NULL DEFAULT '1',
  `show_feed_dirs` tinyint(1) NOT NULL DEFAULT '1',
  `fb_like_consolidation` varchar(255) DEFAULT NULL,
  `is_reconnect_with_fb_friends` tinyint(1) DEFAULT '0',
  `notify_invitations_and_requests` tinyint(1) DEFAULT '1',
  `notify_joins_interested_circle` tinyint(1) DEFAULT '1',
  `notify_leaves_interested_circle` tinyint(1) DEFAULT '1',
  `notify_private_messages` tinyint(1) DEFAULT '1',
  `kroogi_notify_joins_interested_circle` tinyint(1) DEFAULT '1',
  `kroogi_notify_leaves_interested_circle` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_preferences_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=434 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferences`
--

LOCK TABLES `preferences` WRITE;
/*!40000 ALTER TABLE `preferences` DISABLE KEYS */;
INSERT INTO `preferences` VALUES (1,1,2,'general','en',0,NULL,1,1,'--- \n- 5\n',1,0,NULL,1,1,1,1,1,1,1,NULL,0,1,1,1,1,1,1),(2,2,2,'general','en',0,NULL,1,1,'--- \n- 1\n- 2\n- 5\n',1,0,'ru',1,1,1,1,1,1,1,NULL,0,1,1,1,1,1,1),(430,441,2,'general','en',0,NULL,1,1,'--- \n- 2\n- 5\n',1,1,'en',1,1,1,1,1,1,1,NULL,0,1,1,1,1,1,1),(431,442,2,'general','en',0,NULL,1,1,'--- \n- 1\n- 4\n- 5\n',1,1,NULL,1,1,1,1,1,1,1,NULL,0,1,1,1,1,1,1),(432,443,2,'general','en',0,NULL,1,1,'--- \n- 1\n- 4\n- 5\n',1,1,NULL,1,1,1,1,1,1,1,NULL,0,1,1,1,1,1,1),(433,444,2,'general','en',0,NULL,1,1,'--- \n- 5\n',1,1,'en',1,1,1,1,1,1,1,NULL,0,1,1,1,1,1,1);
/*!40000 ALTER TABLE `preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preset_terms_and_conditions`
--

DROP TABLE IF EXISTS `preset_terms_and_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preset_terms_and_conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `title_ru` varchar(255) DEFAULT NULL,
  `body` text,
  `body_ru` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preset_terms_and_conditions`
--

LOCK TABLES `preset_terms_and_conditions` WRITE;
/*!40000 ALTER TABLE `preset_terms_and_conditions` DISABLE KEYS */;
INSERT INTO `preset_terms_and_conditions` VALUES (2,'Standard terms for music remixes','Стандартное соглашение для музыкальных ремиксов','Hello, before you download this material, please carefully read these terms and conditions (the “Terms”). By downloading this material you agree to be bound by these Terms.\n\nThis is not a competition. Mixes will not automatically be awarded prizes.\n\nYou (the Entrant) hereby agree, confirm, represent and warrant that:\n\n1. You understand that the owner of the account, which offers you this download for remixes (the “Owner”) owns the copyrights and all intellectual property associated with the downloadable samples of music (the “Song”) made available under this online promotion (the “Promotion”). Owner hereby grants You a license to combine and arrange the Song only to create derivative works of such Songs solely in the form of sound recordings (the “Remixes of the Song”).  All intellectual property rights, including copyrights, in and to any Remixes of the Song created  by You (the Entrant), are  owned by Owner, owner of the rights to the original material.  You, the Entrant, hereby irrevocably assign, transfer and convey  all rights, including without limitation, all intellectual property rights, title, interests, and all copyrights and moral rights, to the extend these can be transferred, in and to the Remixes of the Song to Owner, including the right to create derivative works, throughout the universe, for the full life of copyright and any and all extensions and renewals thereof. If requested by Owner, You, the Entrant, shall complete and sign a formal assignment of copyright and moral rights to give effect to the foregoing;  including any and all documents and other instruments necessary or desirable to confirm such assignment.  In the event that Entrant does not, for any reason, execute such documents within a reasonable time of Owner’s request, Entrant hereby irrevocably appoints Owner as Entrant’s attorney-in-fact for the purpose of executing such documents on Entrant’s behalf. Entrant shall not attempt to register any works created by Entrant pursuant to this Promotion at any copyright office, patent, or trademark registry. Entrant retains no rights in the Remix and agrees not to challenge Owner’s ownership of the rights embodied in the Remix.  If Entrant has any rights, including without limitation “artist’s rights” or “moral rights,” in the Remix which cannot be assigned (the “Non-Assignable Rights”), Entrant agrees to waive enforcement worldwide of such rights against Owner. In the event that Entrant has any such rights that cannot be assigned or waived Entrant hereby grants to Owner a royalty-free, paid-up, exclusive, worldwide, irrevocable, perpetual license under the Non-Assignable Rights to (i) use, make, have made, sell, offer to sell, import, and further sublicense the Remix, and (ii) to reproduce, distribute, create derivative works of, publicly perform and publicly display the Remix in any medium or format, whether now known or later developed.\n\n2. Owner will give attribution to the Entrant as the co-author of the Remixes of the Song created by the Entrant, along with Owner;\n\n3. the Entrant will not acquire a copyright interest in the Song by virtue of creating Remixes of the Song, nor does it acquire rights to use, publicly perform, publicly display, distribute, adapt, modify, and/or create derivative works beyond any rights granted by these Terms;\n\n4. the Entrant will not use any other elements or parts of the Song (“Stems”) otherwise than to create Remixes of the Song for entry into this particular Kroogi event;\n\n5. the Remixes of the Song do not incorporate any samples or other materials which are subject to third party proprietary rights or otherwise infringe the rights of any third party;\n\n6. the Remixes of the Song are not obscene, defamatory, libelous, threatening, harassing, hateful, racially or ethnically offensive, or encouraging of conduct that would be considered a criminal offense, gives rise to civil liability, or violate any law;\n\n7. You understand that you are not authorized to  exploit, or allow others to exploit, and/or to use, publicly perform, publicly display, distribute, adapt, modify, and/or create derivative works of the Remixes of the Song created by You, the Entrant,  without  prior express authorization  of Owner. Accordingly, if You, the Entrant, wish to use their Remix outside of this Promotion  you will have to contact Owner through Kroogi private messaging module or via any other reasonable and traceable means; please make sure to send full details in your communication; and\n\n8. by submitting Remixes to Owner, the Entrant agrees to release and hold harmless Owner and Your Net Works, Inc. from and against any claim or cause of action arising out of such Remixes or Entrant’s participation in the event.\n\nIn submitting Remixes to Owner the Entrant confirms and warrants that they have full power and authority to enter into this agreement and hereby indemnify Your Net Works, Inc. and Owner from and against any and all costs and damages incurred as a result of any breach of the representations and warranties made by the Entrant herein.\n\nOwner reserves the right, in its absolute discretion, to remove Remixes from the website that it deems offensive or inappropriate and/or Remixes that breach any of the above terms and conditions.\n','Превед, прежде чем you download this material, please carefully read these terms and conditions (the “Terms”). By downloading this material you agree to be bound by these Terms.\n\nThis is not a competition. Mixes will not automatically be awarded prizes.\n\nYou (the Entrant) hereby agree, confirm, represent and warrant that:\n\n1. You understand that the owner of the account, which offers you this download for remixes (the “Owner”) owns the copyrights and all intellectual property associated with the downloadable samples of music (the “Song”) made available under this online promotion (the “Promotion”). Owner hereby grants You a license to combine and arrange the Song only to create derivative works of such Songs solely in the form of sound recordings (the “Remixes of the Song”).  All intellectual property rights, including copyrights, in and to any Remixes of the Song created  by You (the Entrant), are  owned by Owner, owner of the rights to the original material.  You, the Entrant, hereby irrevocably assign, transfer and convey  all rights, including without limitation, all intellectual property rights, title, interests, and all copyrights and moral rights, to the extend these can be transferred, in and to the Remixes of the Song to Owner, including the right to create derivative works, throughout the universe, for the full life of copyright and any and all extensions and renewals thereof. If requested by Owner, You, the Entrant, shall complete and sign a formal assignment of copyright and moral rights to give effect to the foregoing;  including any and all documents and other instruments necessary or desirable to confirm such assignment.  In the event that Entrant does not, for any reason, execute such documents within a reasonable time of Owner’s request, Entrant hereby irrevocably appoints Owner as Entrant’s attorney-in-fact for the purpose of executing such documents on Entrant’s behalf. Entrant shall not attempt to register any works created by Entrant pursuant to this Promotion at any copyright office, patent, or trademark registry. Entrant retains no rights in the Remix and agrees not to challenge Owner’s ownership of the rights embodied in the Remix.  If Entrant has any rights, including without limitation “artist’s rights” or “moral rights,” in the Remix which cannot be assigned (the “Non-Assignable Rights”), Entrant agrees to waive enforcement worldwide of such rights against Owner. In the event that Entrant has any such rights that cannot be assigned or waived Entrant hereby grants to Owner a royalty-free, paid-up, exclusive, worldwide, irrevocable, perpetual license under the Non-Assignable Rights to (i) use, make, have made, sell, offer to sell, import, and further sublicense the Remix, and (ii) to reproduce, distribute, create derivative works of, publicly perform and publicly display the Remix in any medium or format, whether now known or later developed.\n\n2. Owner will give attribution to the Entrant as the co-author of the Remixes of the Song created by the Entrant, along with Owner;\n\n3. the Entrant will not acquire a copyright interest in the Song by virtue of creating Remixes of the Song, nor does it acquire rights to use, publicly perform, publicly display, distribute, adapt, modify, and/or create derivative works beyond any rights granted by these Terms;\n\n4. the Entrant will not use any other elements or parts of the Song (“Stems”) otherwise than to create Remixes of the Song for entry into this particular Kroogi event;\n\n5. the Remixes of the Song do not incorporate any samples or other materials which are subject to third party proprietary rights or otherwise infringe the rights of any third party;\n\n6. the Remixes of the Song are not obscene, defamatory, libelous, threatening, harassing, hateful, racially or ethnically offensive, or encouraging of conduct that would be considered a criminal offense, gives rise to civil liability, or violate any law;\n\n7. You understand that you are not authorized to  exploit, or allow others to exploit, and/or to use, publicly perform, publicly display, distribute, adapt, modify, and/or create derivative works of the Remixes of the Song created by You, the Entrant,  without  prior express authorization  of Owner. Accordingly, if You, the Entrant, wish to use their Remix outside of this Promotion  you will have to contact Owner through Kroogi private messaging module or via any other reasonable and traceable means; please make sure to send full details in your communication; and\n\n8. by submitting Remixes to Owner, the Entrant agrees to release and hold harmless Owner and Your Net Works, Inc. from and against any claim or cause of action arising out of such Remixes or Entrant’s participation in the event.\n\nIn submitting Remixes to Owner the Entrant confirms and warrants that they have full power and authority to enter into this agreement and hereby indemnify Your Net Works, Inc. and Owner from and against any and all costs and damages incurred as a result of any breach of the representations and warranties made by the Entrant herein.\n\nOwner reserves the right, in its absolute discretion, to remove Remixes from the website that it deems offensive or inappropriate and/or Remixes that breach any of the above terms and conditions.','2009-02-04 21:59:04','2010-02-09 14:07:13',10);
/*!40000 ALTER TABLE `preset_terms_and_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_datas`
--

DROP TABLE IF EXISTS `profile_datas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_datas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL DEFAULT '1',
  `user_id` int(11) NOT NULL DEFAULT '1',
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_profile_datas_on_profile_id` (`profile_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_datas`
--

LOCK TABLES `profile_datas` WRITE;
/*!40000 ALTER TABLE `profile_datas` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile_datas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_questions`
--

DROP TABLE IF EXISTS `profile_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL DEFAULT '1',
  `user_id` int(11) NOT NULL DEFAULT '1',
  `position` int(11) DEFAULT NULL,
  `answer` text,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `updated_by_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `show_on_kroogi_page` tinyint(1) DEFAULT '0',
  `show_on_profile` tinyint(1) DEFAULT NULL,
  `question_key` varchar(30) DEFAULT NULL,
  `question` varchar(255) DEFAULT NULL,
  `answer_ru` text,
  `question_ru` varchar(255) DEFAULT NULL,
  `answer_fr` text,
  `question_fr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_profile_questions_on_profile_id_and_question_and_position` (`profile_id`,`question_key`,`position`)
) ENGINE=InnoDB AUTO_INCREMENT=3701 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_questions`
--

LOCK TABLES `profile_questions` WRITE;
/*!40000 ALTER TABLE `profile_questions` DISABLE KEYS */;
INSERT INTO `profile_questions` VALUES (3,2,1,1,'Sims',0,91,'2007-07-18 07:43:51','2008-10-10 18:00:57',0,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(4,24,1,1,'anya2606',8,8,'1970-01-01 00:00:00','2008-06-12 00:26:25',8,0,0,'skype',NULL,NULL,NULL,NULL,NULL),(5,24,1,2,'Ho-ho-ho',8,8,'1970-01-01 00:00:00','2008-06-12 00:26:25',8,0,0,'old_question',NULL,NULL,NULL,NULL,NULL),(6,24,1,3,'anya260676',8,8,'1970-01-01 00:00:00','2008-06-12 00:26:25',8,0,0,'yahoo',NULL,NULL,NULL,NULL,NULL),(7,24,1,4,'anya260676',8,8,'1970-01-01 00:00:00','2008-06-12 00:26:25',8,0,0,'msn',NULL,NULL,NULL,NULL,NULL),(8,24,1,5,'aika99',8,8,'1970-01-01 00:00:00','2008-06-12 00:26:25',8,0,0,'lj',NULL,NULL,NULL,NULL,NULL),(9,24,1,6,'anya.nikulina',8,8,'1970-01-01 00:00:00','2008-06-12 00:26:25',8,0,0,'gmail',NULL,NULL,NULL,NULL,NULL),(10,6,1,1,'San Francisco',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'city',NULL,NULL,NULL,NULL,NULL),(11,6,1,2,'sasha lerner',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'skype',NULL,NULL,NULL,NULL,NULL),(12,6,1,3,'shut up little man',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'favorite_music',NULL,NULL,NULL,NULL,NULL),(13,6,1,4,'US',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'country',NULL,NULL,NULL,NULL,NULL),(14,6,1,5,'shutuplittleman',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,1,'yahoo',NULL,NULL,NULL,NULL,NULL),(15,6,1,6,'http://www.myspace.com/shutuplittleman',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'website',NULL,NULL,NULL,NULL,NULL),(16,6,1,7,'1951-05-15',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'birthdate',NULL,NULL,NULL,NULL,NULL),(17,6,1,8,'I never giggle falsely. Where are the police? well then don\'t talk to me about it, you are saying that the police are coming, I am waiting for them. Where are my keys? where is my Billfold? So I get put in stony lonesome because of you? YOU GONNA STICK ME WITH THAT FORK?? I will put you down.',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'bio',NULL,NULL,NULL,NULL,NULL),(18,6,1,9,'shutuplittleman',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,1,'myspace',NULL,NULL,NULL,NULL,NULL),(19,6,1,10,'littleman',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'gmail',NULL,NULL,NULL,NULL,NULL),(20,6,1,11,'alcoholism, smoking, drinking, screaming',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'interests',NULL,NULL,NULL,NULL,NULL),(21,6,1,12,'one million dollars... an hour',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(22,6,1,13,'of course',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(23,6,1,14,'drinking and cursing',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(24,6,1,15,'lotsa booze',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(25,6,1,16,'for one million dollars',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(26,6,1,17,'Smoke / Drink',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(27,6,1,18,'Yes',7,7,'1970-01-01 00:00:00','2009-02-03 08:54:11',7,0,0,'trivia','Smoke / Drink',NULL,NULL,NULL,NULL),(28,6,1,19,'Body type',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,0,0,'old_question',NULL,NULL,NULL,NULL,NULL),(29,6,1,20,'5\' 8\" / Some extra baggage',7,7,'1970-01-01 00:00:00','2009-02-03 08:54:11',7,0,0,'trivia','Body type',NULL,NULL,NULL,NULL),(30,6,1,21,'Occupation',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',7,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(31,6,1,22,'Alcoholic',7,7,'1970-01-01 00:00:00','2009-02-03 08:54:11',7,0,0,'trivia','Occupation',NULL,NULL,NULL,NULL),(32,30,1,1,'http://what the fuck is the website?',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',31,0,0,'website',NULL,NULL,NULL,NULL,NULL),(33,30,1,2,'The Shut Up Little Man recordings feature the belligerent rants, hateful harangues, drunken soliloquies, and audible fistfights of Raymond and Peter -- two booze-swilling homicidal roommates in a low-rent area of San Francisco. These recordings were made by their frustrated and much-bereaved next door neighbors, Eddie Lee Sausage and Mitchell D.',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',31,1,0,'bio',NULL,NULL,NULL,NULL,NULL),(34,30,1,3,'whats this all about?',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',31,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(35,30,1,4,'read here: http://members.aol.com/leesausage/History/index.html',7,27,'1970-01-01 00:00:00','2009-10-23 12:28:32',31,0,0,'trivia','whats this all about?',NULL,NULL,NULL,NULL),(36,30,1,5,'for one million dollars',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',31,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(37,30,1,6,'you always giggle falsely',7,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',31,0,0,'myspace',NULL,NULL,NULL,NULL,NULL),(40,10,1,1,'Moscow',11,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',11,1,0,'city',NULL,NULL,NULL,NULL,NULL),(41,10,1,2,'tvmatveeva',11,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',11,1,0,'skype',NULL,NULL,NULL,NULL,NULL),(42,10,1,3,'Rhapsody in Blue (Gershwin)',11,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',11,1,0,'favorite_music',NULL,NULL,NULL,NULL,NULL),(43,10,1,4,'some words about me',11,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',11,1,0,'bio',NULL,NULL,NULL,NULL,NULL),(44,10,1,5,'musics, photo',11,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',11,1,0,'interests',NULL,NULL,NULL,NULL,NULL),(45,39,1,1,'xusha_ra',40,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',40,0,0,'skype',NULL,NULL,NULL,NULL,NULL),(46,39,1,2,'xura',40,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',40,0,0,'lj',NULL,NULL,NULL,NULL,NULL),(57,17,1,1,'San Francisco',18,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',18,1,0,'city',NULL,NULL,NULL,NULL,NULL),(58,17,1,2,'sanderwright',18,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',18,1,1,'skype',NULL,NULL,NULL,NULL,NULL),(59,17,1,3,'USA',18,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',18,1,0,'country',NULL,NULL,NULL,NULL,NULL),(60,17,1,4,'1974-12-11',18,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',18,1,0,'birthdate',NULL,NULL,NULL,NULL,NULL),(61,43,1,1,'San Francisco',44,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',44,1,0,'city',NULL,NULL,NULL,NULL,NULL),(62,43,1,2,'USA',44,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',44,1,0,'country',NULL,NULL,NULL,NULL,NULL),(63,43,1,3,'Of course',44,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',44,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(64,43,1,4,'Rock and Roll baby',44,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',44,0,0,'favorite_music',NULL,NULL,NULL,NULL,NULL),(65,43,1,5,'I am who I am.',44,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',44,1,0,'bio',NULL,NULL,NULL,NULL,NULL),(66,43,1,6,'I have no interests.',44,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',44,0,0,'interests',NULL,NULL,NULL,NULL,NULL),(73,7,1,0,'yes!',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(74,7,1,0,'yes',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(75,7,1,0,'Psy trance, best music in the world',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(78,9,1,1,'людмила зыкинаaa',10,10,'1970-01-01 00:00:00','2008-06-25 18:45:23',10,1,0,'favorite_music',NULL,NULL,NULL,NULL,NULL),(87,50,1,1,'What is the ugliest part of your body?',8,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',51,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(88,50,1,2,'It\'s your mind',8,8,'1970-01-01 00:00:00','2009-02-12 01:57:03',51,0,0,'trivia','What is the ugliest part of your body?',NULL,NULL,NULL,NULL),(90,59,1,1,'San Diego',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,0,'city',NULL,NULL,NULL,NULL,NULL),(91,59,1,2,'blizzart',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,1,'skype',NULL,NULL,NULL,NULL,NULL),(92,59,1,3,'USA',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,0,'country',NULL,NULL,NULL,NULL,NULL),(93,59,1,4,'CBuHTyC',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,1,'yahoo',NULL,NULL,NULL,NULL,NULL),(94,59,1,5,'1975-06-04',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,0,'birthdate',NULL,NULL,NULL,NULL,NULL),(95,59,1,6,'konsumptionjunktion@hotmail.com',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,1,'msn',NULL,NULL,NULL,NULL,NULL),(96,59,1,7,'krace',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,1,'lj',NULL,NULL,NULL,NULL,NULL),(97,59,1,8,'dharmasaurus',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,1,'aol',NULL,NULL,NULL,NULL,NULL),(98,59,1,9,'blizzart',60,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',60,0,1,'gmail',NULL,NULL,NULL,NULL,NULL),(100,51,1,1,'Что это за хуйня?',10,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',10,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(101,51,1,2,'Мы, такието сякието собрались здесь вместе чтобы хуярить тяжёлый рок',10,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',10,0,0,'trivia','Что это за хуйня?',NULL,NULL,NULL,NULL),(102,7,1,0,'what is the ugliest part of your body?',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(104,7,1,0,'ky-ky',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(106,76,1,1,'Albania',77,77,'1970-01-01 00:00:00','2008-06-12 00:26:26',77,0,0,'country',NULL,NULL,NULL,NULL,NULL),(107,55,1,1,'Recording',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(108,55,1,2,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(109,55,1,3,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(110,55,1,4,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(111,55,1,5,'Expensive',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(112,55,1,6,'Weekends only',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(113,55,1,7,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'uknown',NULL,NULL,NULL,NULL,NULL),(114,55,1,8,'Always',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(115,55,1,9,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(116,55,1,10,'An qui magna semper tincidunt.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(117,55,1,11,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'trivia','An qui magna semper tincidunt.',NULL,NULL,NULL,NULL),(118,55,1,12,'An qui magna semper tincidunt.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(119,55,1,13,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'trivia','An qui magna semper tincidunt.',NULL,NULL,NULL,NULL),(120,55,1,14,'An qui magna semper tincidunt.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(121,55,1,15,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'trivia','An qui magna semper tincidunt.',NULL,NULL,NULL,NULL),(122,55,1,16,'An qui magna semper tincidunt.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(123,55,1,17,'An qui magna semper tincidunt. Dicunt ullamcorper mel ne, vis prima dicit referrentur ea. Singulis hendrerit pertinacia nam ad, erroribus evertitur cotidieque ea eos. At vis malis augue, nam cu semper neglegentur. Nec ad adhuc accusamus voluptatibus, eos possim omittantur no, falli altera moderatius ex has.',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',56,0,0,'trivia','An qui magna semper tincidunt.',NULL,NULL,NULL,NULL),(128,50,1,3,'USA',8,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',51,0,0,'country',NULL,NULL,NULL,NULL,NULL),(129,69,1,1,'San Francisco',70,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',70,0,0,'city',NULL,NULL,NULL,NULL,NULL),(130,69,1,2,'USA',70,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',70,0,0,'country',NULL,NULL,NULL,NULL,NULL),(131,69,1,3,'miro-kto-to',70,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',70,1,1,'skype',NULL,NULL,NULL,NULL,NULL),(132,69,1,4,'available',70,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',70,0,0,'uknown',NULL,NULL,NULL,NULL,NULL),(133,11,1,1,'San Francisco',12,12,'1970-01-01 00:00:00','2008-06-12 00:26:25',12,0,0,'city',NULL,NULL,NULL,NULL,NULL),(134,11,1,2,'USA',12,12,'1970-01-01 00:00:00','2008-06-12 00:26:25',12,0,0,'country',NULL,NULL,NULL,NULL,NULL),(135,11,1,3,'http://zzgor.com',12,12,'1970-01-01 00:00:00','2008-06-12 00:26:25',12,1,0,'website',NULL,NULL,NULL,NULL,NULL),(137,92,1,1,'San Fran',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'city',NULL,NULL,NULL,NULL,NULL),(138,92,1,2,'April 21, 1978',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,1,0,'birthdate',NULL,NULL,NULL,NULL,NULL),(139,92,1,3,'USA',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'country',NULL,NULL,NULL,NULL,NULL),(140,92,1,4,'Real Estate, Interior design',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'interests',NULL,NULL,NULL,NULL,NULL),(141,93,1,1,'SF',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'city',NULL,NULL,NULL,NULL,NULL),(142,93,1,2,'USA',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'country',NULL,NULL,NULL,NULL,NULL),(143,92,1,5,'test',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'old_question',NULL,NULL,NULL,NULL,NULL),(144,92,1,6,'test',93,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',93,0,0,'trivia','test',NULL,NULL,NULL,NULL),(145,95,1,1,'http://www.test.com',8,8,'1970-01-01 00:00:00','2008-07-17 00:21:44',8,1,0,'website',NULL,NULL,NULL,NULL,NULL),(146,9,1,2,'q1',10,10,'1970-01-01 00:00:00','2008-06-25 18:45:23',10,1,0,'old_question',NULL,NULL,NULL,NULL,NULL),(148,66,1,1,NULL,67,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',67,1,0,'website',NULL,NULL,NULL,NULL,NULL),(150,69,1,5,'http://www.google.com',70,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',70,1,0,'website',NULL,NULL,NULL,NULL,NULL),(151,9,1,2,'q2',10,10,'1970-01-01 00:00:00','2008-06-25 18:45:23',10,0,0,'old_question',NULL,NULL,NULL,NULL,NULL),(154,106,1,1,'Project for Kroogi Team',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(155,107,1,1,'Kroogi Design Discussions',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',107,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(157,56,1,2,'Kroogi Network Center',8,8,'1970-01-01 00:00:00','2008-11-11 01:25:15',57,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(232,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(233,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(238,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(239,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(240,108,1,1,'',74,74,'1970-01-01 00:00:00','2008-06-24 17:31:45',74,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(241,109,1,1,'',74,74,'1970-01-01 00:00:00','2008-06-24 17:31:45',74,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(242,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(243,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(244,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(245,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(246,7,1,0,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(247,7,1,1,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(248,7,1,1,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(249,7,1,1,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(250,110,1,1,'yahh',74,74,'1970-01-01 00:00:00','2008-06-24 17:31:45',110,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(251,111,1,1,'yahh',74,74,'1970-01-01 00:00:00','2008-06-24 17:31:45',74,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(268,7,1,4,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(269,7,1,5,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(286,7,1,22,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(287,7,1,23,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(304,7,1,40,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(305,7,1,41,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(322,7,1,58,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(323,7,1,59,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(340,7,1,76,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(341,7,1,77,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(358,7,1,94,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(359,7,1,95,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(376,7,1,112,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(377,7,1,113,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(394,7,1,130,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(395,7,1,131,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(400,7,1,136,'No music',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,'favorite_music',NULL,NULL,NULL,NULL,NULL),(412,7,1,148,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(413,7,1,149,'',8,8,'1970-01-01 00:00:00','2008-10-15 22:23:41',8,0,NULL,NULL,'',NULL,NULL,NULL,NULL),(428,54,1,0,'Blah',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,1,NULL,'trivia','Ky-ky',NULL,NULL,NULL,NULL),(429,54,1,1,'Blah',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'trivia','Ky-ky',NULL,NULL,NULL,NULL),(432,26,1,14,'SF',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(433,26,1,15,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(434,26,1,16,'miroktoto',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(435,26,1,17,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(436,26,1,18,'1967-07-19',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,1,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(437,26,1,19,'USA',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(438,26,1,20,'miro_ora',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(439,26,1,21,'http://www.gnsi-inc.com',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(440,26,1,22,'Here\'s some stuff about me.',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(441,26,1,23,'miros',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(442,26,1,24,'kto-to',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(443,26,1,25,'ktototo',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(444,26,1,26,'mirkas',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(445,26,1,27,'kto-to',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(446,26,1,28,'Alpha, Bravo, Charlie, Delta, Echo, Foxtrot, Golf, Hotel, India, Juliet, Kilo, Lima, Mike, November, Oscar, Papa, Quebec, Romeo, Sierra, Tango, Uniform, Victor, Whiskey, X-ray, Yankee, Zulu',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(447,26,1,29,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(448,26,1,30,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'trivia','',NULL,NULL,NULL,NULL),(449,26,1,31,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'trivia','',NULL,NULL,NULL,NULL),(450,26,1,32,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'trivia','',NULL,NULL,NULL,NULL),(451,26,1,33,'',27,27,'1970-01-01 00:00:00','2008-06-25 22:37:32',27,0,NULL,'trivia','',NULL,NULL,NULL,NULL),(470,54,1,19,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(471,54,1,20,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(472,54,1,21,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(473,54,1,22,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(474,54,1,23,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(475,54,1,22,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(476,54,1,23,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(477,54,1,24,'http://www.anyanikulina.com',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(478,54,1,25,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(479,54,1,26,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(480,54,1,27,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(481,54,1,28,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(482,54,1,29,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(483,54,1,30,'',8,8,'1970-01-01 00:00:00','2008-07-18 23:14:47',55,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(516,115,1,0,'Help kroogi succeed',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,1,NULL,'trivia','What is your current project?','','',NULL,NULL),(517,116,1,1,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(518,116,1,2,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(519,116,1,3,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(520,116,1,4,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(521,116,1,5,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(522,116,1,6,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(523,116,1,7,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(524,116,1,8,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(525,116,1,9,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(526,116,1,10,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(527,116,1,11,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(528,116,1,12,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(529,116,1,13,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(530,116,1,14,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(531,116,1,15,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(532,116,1,16,'',117,117,'1970-01-01 00:00:00','2008-08-21 21:35:49',117,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(549,32,1,0,'Da pokazat\'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,1,NULL,'trivia','Vopros 1',NULL,NULL,NULL,NULL),(550,32,1,1,'Net ne pokazat\'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'trivia','Vopros 2',NULL,NULL,NULL,NULL),(551,32,1,2,'Da inogda pokazat\'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'trivia','Vopros 3',NULL,NULL,NULL,NULL),(584,34,1,0,'Answer6',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,1,NULL,'trivia','Q1 show6',NULL,NULL,NULL,NULL),(585,34,1,1,'Answer 2 No show',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'trivia','Q2 No show',NULL,NULL,NULL,NULL),(586,34,1,2,'Answer 3 Show6',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'trivia','Q3 show6',NULL,NULL,NULL,NULL),(603,117,1,1,'Non Profit',35,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',35,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(620,34,1,52,'Lake Dallas',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(621,34,1,53,'Project manager',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(622,34,1,54,'Show4',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(623,34,1,55,'',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(624,34,1,56,'eight fifteen no show',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(625,34,1,57,'USA',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(626,34,1,58,'noShow',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(627,34,1,59,'http://www.show1.test',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(628,34,1,60,'Some project -- have not decided yet --- show2',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,1,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(629,34,1,61,'Show5',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,1,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(630,34,1,62,'noshow',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(631,34,1,63,'',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(632,34,1,64,'',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(633,34,1,65,'',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(634,34,1,66,'show 3',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(635,34,1,67,'noShow',35,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',35,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(636,32,1,36,'Moscow',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(637,32,1,37,'Nikto',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(638,32,1,38,'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(639,32,1,39,'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(640,32,1,40,'August 15',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,1,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(641,32,1,41,'Russia',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(642,32,1,42,'nepokazat\'@yahoo.com',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(643,32,1,43,'http://www.bigmig.com',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(644,32,1,44,'Novui proekt',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,1,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(645,32,1,45,'lpokazat\'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,1,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(646,32,1,46,'ludastage ne pokazat\'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(647,32,1,47,'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(648,32,1,48,'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(649,32,1,49,'ldillon pokazat\'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,1,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(650,32,1,50,'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(651,32,1,51,'',33,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',33,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(652,118,1,1,'plano',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(653,118,1,2,'entertainer',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(654,118,1,3,'testskype',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(655,118,1,4,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(656,118,1,5,'09051986',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(657,118,1,6,'usa',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(658,118,1,7,'testyahoo',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(659,118,1,8,'http://www.some.com',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(660,118,1,9,'I am an entertainer',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,1,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(661,118,1,10,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(662,118,1,11,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(663,118,1,12,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(664,118,1,13,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(665,118,1,14,'testmyspace',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,1,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(666,118,1,15,'skiing, parties, friends',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(667,118,1,16,'don\'t show',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(668,118,1,17,'Meet new friends show',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,1,NULL,'trivia','What do I like to do?',NULL,NULL,NULL,NULL),(669,118,1,18,'answer 2 no show',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',119,0,NULL,'trivia','q2',NULL,NULL,NULL,NULL),(671,119,1,2,'Dallas',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(672,119,1,3,'sports',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(673,119,1,4,'Organizae tournaments, compete for the prize',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,1,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(674,119,1,5,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(675,119,1,6,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(676,119,1,7,'USA',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(677,119,1,8,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(678,119,1,9,'http://www..    ..',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(679,119,1,10,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(680,119,1,11,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(681,119,1,12,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(682,119,1,13,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(683,119,1,14,'',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(684,119,1,15,'tennis',119,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',120,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(701,121,1,0,'The Russian music legend has produced more than 50 albums since the formation of his legendary band Aquarium in 1972. His music over the years has incorporated a range of styles, from folk and blues to translucent acoustics - and includes a whole slew of various ethnic and folklore influences.\r\n\r\nAs a young student in the Soviet Union he started experimenting with poetry, music and theatre - merging Eastern philosophies and traditional Russian themes. His big break came in 1980, when he was invited to perform at the Tbilisi Rock Festival. Although his band was officially banned by the State following the festival his underground profile continued to rise sharply over the next 7 years until Perestroika ushered in a new era of opportunity. Boris became the first Russian musician to record in the West.\r\n\r\nIn Russia he can sell out any stadium. With his smoky tenor voice he continues to \'express the inexpressable\' in a lyrical language that has earned him the affectionate title, \"Poet Laureate of Russia\". When he performs to non-Russian speaking audiences he says, \"There are things that are universal enough that every person who listens will perk up their ears\".\r\n\r\nIn 1989 he was the subject of \"The Long Way Home,\" a film by Michael Apted documenting Grebenshikov\'s struggle to record his album \"Radio Silence\" with Dave Stewart of Eurythmics.\r\n\r\nIn February, 2006 Grebenshikov met the Indian spiritual teacher Sri Chinmoy who blessed him with the name Purushottama, which relates to the one who is beyond all limitations. In May 2007, inspired by Sri Chinmoy, Boris Purushottama Grebenshikov performed with his band Aquarium to a capacity audience at the Royal Albert Hall.\r\n',122,122,'1970-01-01 00:00:00','2008-09-12 18:54:46',122,0,NULL,'trivia','Biography',NULL,NULL,NULL,NULL),(789,121,1,34,'St.-Petersburg',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(790,121,1,35,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(791,121,1,36,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(792,121,1,37,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(793,121,1,38,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(794,121,1,39,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(795,121,1,40,'Russia',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(796,121,1,41,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(797,121,1,42,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(798,121,1,43,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(799,121,1,44,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(800,121,1,45,'\"There is a great silence inside of everybody, the source of all inspiration, of everything. I always prefer to let music speak for itself and then the human puppet has no further words\".',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,1,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(801,121,1,46,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(802,121,1,47,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(803,121,1,48,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(804,121,1,49,'',122,122,'1970-01-01 00:00:00','2008-09-12 22:04:28',122,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(805,134,1,72,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(806,134,1,73,'Memorial Concert',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(807,134,1,74,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(808,134,1,75,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(809,134,1,76,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(810,134,1,77,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(811,134,1,78,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(812,134,1,79,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(813,134,1,80,'http://www.grebenshikovconcert.com/',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(814,134,1,81,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(815,134,1,82,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(816,134,1,83,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(817,134,1,84,'In a prolific career that has spanned almost four decades, BG (Boris Purushottama Grebenshikov) has continued to enchant his audiences with new sounds and a lyrical language that has earned him the affectionate title \"Poet Laureate of Russia\".\r\n\r\nAccompanied by an international ensemble of musicians performing on instruments from the sitar and tabla to the violin and flute, he presents a fusion of his own classic folk melodies with sounds from around the world.\r\n\r\n<i>\"Music is an ocean. I just venture into the ocean and follow the waves\".</i>',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,1,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(818,134,1,85,'',122,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',135,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(819,120,1,1,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(820,120,1,2,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(821,120,1,3,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(822,120,1,4,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(823,120,1,5,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(824,120,1,6,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(825,120,1,7,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(826,120,1,8,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(827,120,1,9,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(828,120,1,10,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(829,120,1,11,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(830,120,1,12,'this is about me',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,1,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(831,120,1,13,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(832,120,1,14,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(833,120,1,15,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(834,120,1,16,'',121,121,'1970-01-01 00:00:00','2008-09-15 17:37:17',121,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(835,89,1,1,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(836,89,1,2,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(837,89,1,3,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(838,89,1,4,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(839,89,1,5,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(840,89,1,6,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(841,89,1,7,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(842,89,1,8,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(843,89,1,9,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(844,89,1,10,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(845,89,1,11,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(846,89,1,12,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(847,89,1,13,'this is my project',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,1,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(848,89,1,14,'',87,87,'1970-01-01 00:00:00','2008-09-15 17:41:21',90,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1214,143,1,1,'a test',91,91,'1970-01-01 00:00:00','2008-10-01 17:56:29',91,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1215,135,1,29,'commercial',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1216,135,1,30,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1217,135,1,31,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1218,135,1,32,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1219,135,1,33,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1220,135,1,34,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1221,135,1,35,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1222,135,1,36,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1223,135,1,37,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1224,135,1,38,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1225,135,1,39,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1226,135,1,40,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1227,135,1,41,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1228,135,1,42,'',116,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',136,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1277,145,1,1,'best project in the world',8,91,'1970-01-01 00:00:00','2008-10-10 18:01:03',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1280,147,1,3,'a test of login',148,148,'1970-01-01 00:00:00','2008-10-06 22:30:55',148,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1281,148,1,1,'city',149,149,'1970-01-01 00:00:00','2008-10-07 02:13:19',149,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1282,148,1,2,'usa',149,149,'1970-01-01 00:00:00','2008-10-07 02:13:19',149,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1283,148,1,3,'another test of login',149,149,'1970-01-01 00:00:00','2008-10-07 02:13:19',149,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1286,149,1,3,'sf',150,150,'1970-01-01 00:00:00','2008-10-07 17:56:08',150,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1287,150,1,1,'',151,151,'1970-01-01 00:00:00','2008-10-07 17:58:27',151,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1288,150,1,2,'asf',151,151,'1970-01-01 00:00:00','2008-10-07 17:58:27',151,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1289,150,1,3,'',151,151,'1970-01-01 00:00:00','2008-10-07 17:58:27',151,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1290,152,1,1,NULL,153,153,'1970-01-01 00:00:00','2008-10-08 02:12:27',153,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1291,152,1,2,NULL,153,153,'1970-01-01 00:00:00','2008-10-08 02:12:27',153,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1292,152,1,3,NULL,153,153,'1970-01-01 00:00:00','2008-10-08 02:12:27',153,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1311,153,1,3,'Meat Popsicle',154,154,'1970-01-01 00:00:00','2008-10-09 04:14:12',154,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1318,154,1,7,NULL,155,155,'1970-01-01 00:00:00','2008-10-09 23:12:55',155,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1319,154,1,8,'Russia',155,155,'1970-01-01 00:00:00','2008-10-09 23:12:55',155,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1320,154,1,9,'хороший человек',155,155,'1970-01-01 00:00:00','2008-10-09 23:12:55',155,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1321,155,1,1,NULL,155,155,'1970-01-01 00:00:00','2008-10-09 23:35:33',155,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1322,155,1,2,NULL,155,155,'1970-01-01 00:00:00','2008-10-09 23:35:33',155,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1339,153,1,20,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:58',154,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1340,153,1,21,'SF',154,154,'1970-01-01 00:00:00','2008-10-10 05:24:58',154,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1341,153,1,22,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:58',154,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1342,153,1,23,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1343,153,1,24,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1344,153,1,25,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1345,153,1,26,'USA',154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1346,153,1,27,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1347,153,1,28,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1348,153,1,29,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1349,153,1,30,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1350,153,1,31,'',154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1351,153,1,32,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1352,153,1,33,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1353,153,1,34,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1354,153,1,35,NULL,154,154,'1970-01-01 00:00:00','2008-10-10 05:24:59',154,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1360,156,1,6,'traffic school dropout',157,157,'1970-01-01 00:00:00','2008-10-10 05:31:21',157,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1457,156,1,103,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1458,156,1,104,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1459,156,1,105,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1460,156,1,106,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1461,156,1,107,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1462,156,1,108,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1463,156,1,109,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1464,156,1,110,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1465,156,1,111,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1466,156,1,112,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1467,156,1,113,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1468,156,1,114,'',157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1469,156,1,115,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1470,156,1,116,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1471,156,1,117,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1472,156,1,118,NULL,157,157,'1970-01-01 00:00:00','2008-10-10 06:10:08',157,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1473,1,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1474,1,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1475,1,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1477,2,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1478,2,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1479,3,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1480,3,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1481,3,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1482,6,1,23,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1483,6,1,24,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1484,6,1,25,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:57',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1485,8,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1486,8,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1487,8,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1488,10,1,6,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1489,10,1,7,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1490,10,1,8,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1491,12,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1492,12,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1493,12,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1494,13,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1495,13,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1496,13,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1497,17,1,5,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1498,17,1,6,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1499,17,1,7,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1500,30,1,7,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1501,30,1,8,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1502,30,1,9,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:58',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1503,35,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1504,35,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1505,35,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1506,37,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1507,37,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1508,37,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1509,39,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1510,39,1,4,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1511,39,1,5,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1512,40,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1513,40,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1514,40,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1515,43,1,7,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1516,43,1,8,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1517,43,1,9,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1518,49,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1519,49,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1520,49,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1521,50,1,4,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1522,50,1,5,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1523,50,1,6,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:00:59',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1524,51,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1525,51,1,4,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1526,51,1,5,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1527,55,1,18,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1528,55,1,19,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1529,55,1,20,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1530,59,1,10,NULL,91,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1531,59,1,11,NULL,91,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1532,59,1,12,NULL,91,10,'1970-01-01 00:00:00','2008-12-26 20:16:48',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1533,60,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1534,60,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1535,60,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1536,65,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1537,65,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1538,65,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1539,66,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1540,66,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1541,66,1,4,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1542,69,1,6,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1543,69,1,7,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1544,69,1,8,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1545,74,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1546,74,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1547,74,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:00',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1548,77,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1549,77,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1550,77,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1551,78,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1552,78,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1553,78,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1554,80,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1555,80,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1556,80,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1557,82,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1558,82,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1559,82,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1560,85,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1561,85,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1562,85,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1563,92,1,7,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1564,92,1,8,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1565,92,1,9,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1566,93,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1567,93,1,4,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1568,93,1,5,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1569,94,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1570,94,1,2,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:01',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1571,94,1,3,NULL,91,91,'1970-01-01 00:00:00','2008-10-10 18:01:02',144,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1575,157,1,1,NULL,158,158,'1970-01-01 00:00:00','2008-10-10 20:38:35',158,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1576,157,1,2,NULL,158,158,'1970-01-01 00:00:00','2008-10-10 20:38:35',158,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1577,157,1,3,NULL,158,158,'1970-01-01 00:00:00','2008-10-10 20:38:35',158,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1580,158,1,3,'i\'m a project creator:)',159,159,'1970-01-01 00:00:00','2008-10-10 20:53:47',159,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1581,158,1,4,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1582,158,1,5,'SPb - Moscow',159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1583,158,1,6,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1584,158,1,7,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1585,158,1,8,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1586,158,1,9,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1587,158,1,10,'Russia',159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1588,158,1,11,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1589,158,1,12,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1590,158,1,13,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1591,158,1,14,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1592,158,1,15,'little helper for explore Kroogi',159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1593,158,1,16,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1594,158,1,17,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1595,158,1,18,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1596,158,1,19,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:01:14',159,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1599,159,1,5,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1600,159,1,6,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1601,159,1,7,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1602,159,1,8,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1603,159,1,9,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1604,159,1,10,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1605,159,1,11,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1606,159,1,12,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1607,159,1,13,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1608,159,1,14,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1609,159,1,15,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1610,159,1,16,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:03',160,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1611,159,1,17,'',159,159,'1970-01-01 00:00:00','2008-10-10 21:35:04',160,0,NULL,'about_project',NULL,'',NULL,NULL,NULL),(1612,159,1,18,NULL,159,159,'1970-01-01 00:00:00','2008-10-10 21:35:04',160,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1613,160,1,1,'Lake Dallas',161,161,'1970-01-01 00:00:00','2008-10-10 23:45:52',161,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1614,160,1,2,'USA',161,161,'1970-01-01 00:00:00','2008-10-10 23:45:52',161,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1615,160,1,3,'A software developer',161,161,'1970-01-01 00:00:00','2008-10-10 23:45:52',161,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1616,161,1,4,'test only',161,161,'1970-01-01 00:00:00','2008-10-11 00:14:52',161,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1617,161,1,5,NULL,161,161,'1970-01-01 00:00:00','2008-10-11 00:14:52',161,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1619,162,1,4,NULL,33,33,'1970-01-01 00:00:00','2008-10-11 03:32:13',33,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1620,162,1,5,NULL,33,33,'1970-01-01 00:00:00','2008-10-11 03:32:13',33,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1621,163,1,1,NULL,164,164,'1970-01-01 00:00:00','2008-10-11 04:50:32',164,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1622,163,1,2,'usa',164,164,'1970-01-01 00:00:00','2008-10-11 04:50:32',164,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1623,163,1,3,NULL,164,164,'1970-01-01 00:00:00','2008-10-11 04:50:32',164,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1624,115,1,34,'Freelance consultant',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1625,115,1,35,'Redwood City',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1626,115,1,36,'Skiing, reading, sports, stocks, ideas',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1627,115,1,37,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1628,115,1,38,'luda dallas',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1629,115,1,39,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1630,115,1,40,'US',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1631,115,1,41,'August 15',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1632,115,1,42,'lnikifor',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,1,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1633,115,1,43,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1634,115,1,44,'http://www.thousandarts.com',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1635,115,1,45,'This is a test user',116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'bio',NULL,NULL,NULL,NULL,NULL),(1636,115,1,46,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1637,115,1,47,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1638,115,1,48,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1639,115,1,49,NULL,116,116,'1970-01-01 00:00:00','2008-10-13 23:16:23',116,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1640,164,1,1,'Великие Говнищи',165,165,'1970-01-01 00:00:00','2008-10-15 23:34:44',165,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1641,164,1,2,'La-la land',165,165,'1970-01-01 00:00:00','2008-10-15 23:34:44',165,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1642,164,1,3,'буй коржовый',165,165,'1970-01-01 00:00:00','2008-10-15 23:34:44',165,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1643,168,1,1,'lake dallas',169,169,'1970-01-01 00:00:00','2008-10-16 00:14:36',169,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1644,168,1,2,'usa',169,169,'1970-01-01 00:00:00','2008-10-16 00:14:36',169,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1645,168,1,3,'qa',169,169,'1970-01-01 00:00:00','2008-10-16 00:14:36',169,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1646,169,1,1,'plano',170,170,'1970-01-01 00:00:00','2008-10-16 00:20:35',170,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1647,169,1,2,'france',170,170,'1970-01-01 00:00:00','2008-10-16 00:20:35',170,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1648,169,1,3,'somebody',170,170,'1970-01-01 00:00:00','2008-10-16 00:20:36',170,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1665,170,1,4,'Need to test for emails',74,74,'1970-01-01 00:00:00','2008-10-17 21:41:09',74,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1666,170,1,5,NULL,74,74,'1970-01-01 00:00:00','2008-10-17 21:41:09',74,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1667,171,1,1,'dssalkdksald',172,172,'1970-01-01 00:00:00','2008-10-17 22:20:47',172,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1668,171,1,2,'nndkdsa',172,172,'1970-01-01 00:00:00','2008-10-17 22:20:47',172,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1669,171,1,3,'tester',172,172,'1970-01-01 00:00:00','2008-10-17 22:20:47',172,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1670,172,1,1,'kdsfjskdfalfj',173,173,'1970-01-01 00:00:00','2008-10-17 22:22:27',173,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1671,172,1,2,'fdkgfdlgj',173,173,'1970-01-01 00:00:00','2008-10-17 22:22:27',173,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1672,172,1,3,'dkfldsjfdslkf',173,173,'1970-01-01 00:00:00','2008-10-17 22:22:27',173,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1674,173,1,4,NULL,74,74,'1970-01-01 00:00:00','2008-10-17 23:32:29',74,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1675,173,1,5,NULL,74,74,'1970-01-01 00:00:00','2008-10-17 23:32:29',74,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1678,174,1,4,NULL,8,8,'1970-01-01 00:00:00','2008-10-17 23:34:34',8,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1679,174,1,5,NULL,8,8,'1970-01-01 00:00:00','2008-10-17 23:34:34',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1680,175,1,4,NULL,8,8,'1970-01-01 00:00:00','2008-10-17 23:36:15',8,0,NULL,'about_project',NULL,NULL,NULL,NULL,NULL),(1681,175,1,5,NULL,8,8,'1970-01-01 00:00:00','2008-10-17 23:36:15',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1794,86,1,145,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1795,86,1,146,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1796,86,1,147,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1797,86,1,148,'school',87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1798,86,1,149,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1799,86,1,150,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1800,86,1,151,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1801,86,1,152,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1802,86,1,153,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1803,86,1,154,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1804,86,1,155,'http://casual.kroogi.com',87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1805,86,1,156,'',87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1806,86,1,157,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1807,86,1,158,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1808,86,1,159,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1809,86,1,160,NULL,87,87,'1970-01-01 00:00:00','2008-10-22 20:47:15',87,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1810,188,1,1,'Corpus Christi',189,189,'1970-01-01 00:00:00','2008-11-08 01:03:44',189,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1811,188,1,2,'USA',189,189,'1970-01-01 00:00:00','2008-11-08 01:03:44',189,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1812,189,1,1,NULL,190,190,'1970-01-01 00:00:00','2008-11-10 02:43:50',190,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1813,189,1,2,NULL,190,190,'1970-01-01 00:00:00','2008-11-10 02:43:50',190,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1831,190,1,0,'English',191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,1,NULL,'trivia','English','Russian','Russian',NULL,NULL),(1832,190,1,1,'English 1',191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,1,NULL,'trivia','English 1','Russian 1','Russian 1',NULL,NULL),(1833,190,1,2,'English 2',191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,1,NULL,'trivia','English 2','Russian 2','Russian 2',NULL,NULL),(1834,190,1,18,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1835,190,1,19,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1836,190,1,20,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1837,190,1,21,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1838,190,1,22,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1839,190,1,23,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1840,190,1,24,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1841,190,1,25,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1843,190,1,26,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1844,190,1,27,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1845,190,1,28,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1846,190,1,29,'',191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1847,190,1,30,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1848,190,1,31,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1849,190,1,32,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1850,190,1,33,NULL,191,191,'1970-01-01 00:00:00','2008-11-10 22:37:15',191,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1870,191,1,0,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:44:10',192,1,NULL,'trivia','','Russ','Russ',NULL,NULL),(1871,191,1,1,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,1,NULL,'trivia','','RussTestWillEnglish change?','Russ1',NULL,NULL),(1872,191,1,2,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:44:10',192,1,NULL,'trivia','','Russ2','Russ2',NULL,NULL),(1890,191,1,35,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1891,191,1,36,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1892,191,1,37,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1893,191,1,38,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1894,191,1,39,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1895,191,1,40,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1896,191,1,41,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1897,191,1,42,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1899,191,1,43,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1900,191,1,44,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1901,191,1,45,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1902,191,1,46,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1903,191,1,47,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1904,191,1,48,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1905,191,1,49,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1906,191,1,50,'',192,192,'1970-01-01 00:00:00','2008-11-10 23:45:33',192,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1907,193,1,1,'',194,194,'1970-01-01 00:00:00','2008-11-10 23:48:03',194,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1908,193,1,2,'usa',194,194,'1970-01-01 00:00:00','2008-11-10 23:48:03',194,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1909,194,1,1,'',195,195,'1970-01-01 00:00:00','2008-11-11 00:25:25',195,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1910,194,1,2,'',195,195,'1970-01-01 00:00:00','2008-11-11 00:25:25',195,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1911,195,1,1,'',196,8,'1970-01-01 00:00:00','2009-01-16 19:00:47',196,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1912,195,1,2,'',196,8,'1970-01-01 00:00:00','2009-01-16 19:00:47',196,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1913,196,1,1,'Xmelnitsky',197,33,'1970-01-01 00:00:00','2008-11-27 05:45:48',197,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1914,196,1,2,'Ukraine',197,33,'1970-01-01 00:00:00','2008-11-27 05:45:48',197,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1915,197,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-11-12 02:16:03',91,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1952,198,1,1,'',199,199,'1970-01-01 00:00:00','2008-11-27 20:51:30',199,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1953,198,1,2,'',199,199,'1970-01-01 00:00:00','2008-11-27 20:51:30',199,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1954,199,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-11-28 19:05:12',91,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1955,200,1,1,'spb',201,10,'1970-01-01 00:00:00','2008-12-06 10:53:40',201,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1956,200,1,2,'rus',201,10,'1970-01-01 00:00:00','2008-12-06 10:53:40',201,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1957,201,1,1,'lis',202,202,'1970-01-01 00:00:00','2008-12-06 11:14:14',202,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1958,201,1,2,'portugal',202,202,'1970-01-01 00:00:00','2008-12-06 11:14:14',202,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1959,202,1,1,NULL,91,91,'1970-01-01 00:00:00','2008-12-09 02:30:26',91,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1960,204,1,1,NULL,204,204,'1970-01-01 00:00:00','2008-12-09 19:06:22',204,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1963,177,1,1,'',178,178,'1970-01-01 00:00:00','2009-01-30 01:47:39',178,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1964,177,1,2,'',178,178,'1970-01-01 00:00:00','2009-01-30 01:47:39',178,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1965,167,1,1,'test',168,168,'1970-01-01 00:00:00','2009-01-31 01:17:05',168,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1966,167,1,2,'test',168,168,'1970-01-01 00:00:00','2009-01-31 01:17:05',168,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1967,209,1,1,'SF',210,210,'1970-01-01 00:00:00','2009-01-31 04:28:00',210,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1968,209,1,2,'USA',210,210,'1970-01-01 00:00:00','2009-01-31 04:28:00',210,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1969,210,1,1,'',211,211,'1970-01-01 00:00:00','2009-01-31 05:57:07',211,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1970,210,1,2,'',211,211,'1970-01-01 00:00:00','2009-01-31 05:57:07',211,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1971,211,1,1,'Sky',212,212,'1970-01-01 00:00:00','2009-02-01 00:00:32',212,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1972,211,1,2,'Heaven',212,212,'1970-01-01 00:00:00','2009-02-01 00:00:32',212,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1973,213,1,1,'SF',214,214,'1970-01-01 00:00:00','2009-02-01 04:38:55',214,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1974,213,1,2,'US',214,214,'1970-01-01 00:00:00','2009-02-01 04:38:55',214,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1975,205,1,1,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1976,205,1,2,'Dubna',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1977,205,1,2,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(1978,205,1,3,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(1979,205,1,3,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(1980,205,1,4,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(1981,205,1,5,'Russia',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1982,205,1,6,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(1987,205,1,7,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(1988,205,1,8,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(1989,205,1,9,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(1990,205,1,10,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(1991,205,1,11,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(1992,205,1,12,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(1993,205,1,13,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(1994,205,1,14,'',206,206,'1970-01-01 00:00:00','2009-02-02 17:47:31',206,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(1995,214,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-02-13 19:40:08',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(1996,151,1,1,'',152,152,'1970-01-01 00:00:00','2009-02-16 19:50:27',152,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1997,151,1,2,'',152,152,'1970-01-01 00:00:00','2009-02-16 19:50:27',152,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(1998,147,1,4,'',148,148,'1970-01-01 00:00:00','2009-02-16 21:33:52',148,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(1999,147,1,5,'',148,148,'1970-01-01 00:00:00','2009-02-16 21:33:52',148,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2000,149,1,4,'',150,150,'1970-01-01 00:00:00','2009-02-17 20:36:54',150,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2001,149,1,5,'',150,150,'1970-01-01 00:00:00','2009-02-17 20:36:55',150,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2002,215,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-02-20 19:29:56',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2003,216,1,1,NULL,206,206,'1970-01-01 00:00:00','2009-02-24 09:08:10',206,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2005,217,1,0,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:11',218,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2007,217,1,1,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:11',218,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(2008,217,1,2,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:11',218,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(2009,217,1,2,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:11',218,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(2015,217,1,4,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(2016,217,1,5,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(2017,217,1,6,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(2018,217,1,7,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(2019,217,1,8,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(2020,217,1,9,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(2021,217,1,10,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'about_project',NULL,'',NULL,NULL,NULL),(2022,217,1,11,'',8,8,'1970-01-01 00:00:00','2009-02-27 19:10:12',218,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(2023,218,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-03-03 19:55:13',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2043,219,1,8,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2044,219,1,9,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2045,219,1,10,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(2046,219,1,11,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(2047,219,1,12,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(2048,219,1,13,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2053,219,1,14,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(2054,219,1,15,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:50',220,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(2055,219,1,16,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:51',220,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(2056,219,1,17,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:51',220,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(2057,219,1,18,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:51',220,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(2058,219,1,19,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:51',220,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(2059,219,1,20,'Lorem ipsum ne commodo dolorum accommodare est, falli fabellas eu mea, cu nec nisl salutatus. Omnes molestie vituperata pri at, duo ex nostro sanctus constituam. Id graece sapientem dissentiunt mel, ne populo noster officiis has, sea consul quidam accusam no. Quo at paulo blandit repudiare. Id facilis nostrum posidonium has, an quo quas indoctum intellegebat. Et vel nihil indoctum, zzril ornatus albucius te duo, vel at omnes labore dolorem. Oratio debitis volumus per an, meis dolor sadipscing no eos, dolorem elaboraret scribentur ius ne.',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:51',220,1,NULL,'about_project',NULL,'Не джоель пишете продукт нью, от это надо этого, про собой продлить случается во. Том бы хороша против работаешь, во ничего полностью потратите это. Почту быстрее на так. Пора медицинское возможностей эти мы, всё те новые станет получаете. Мог то иначе трудовой обнаженного, вас не работник исправляя программировать. Ну код пирог правила проходят, по назад которое чем, уровня который касается них их. Ты налево порулил премирования нас, бы пусть усилий обеспечения фон.',NULL,NULL,NULL),(2060,219,1,21,'',8,8,'1970-01-01 00:00:00','2009-03-03 20:30:51',220,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(2150,222,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-03-17 13:51:12',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2209,100,1,9,'asdfasdafsdf',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:45',101,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2210,100,1,10,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:45',101,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2211,100,1,11,'asf as, asdfas dfa, dfasf',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:45',101,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(2212,100,1,12,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:45',101,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(2213,100,1,13,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:45',101,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(2214,100,1,14,'asdfasdf asdf asd',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:45',101,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2218,100,1,15,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(2219,100,1,16,'asdfasf asdfasf',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,1,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(2220,100,1,17,'http://www.dom.com.ru',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(2221,100,1,18,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(2222,100,1,19,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(2223,100,1,20,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(2224,100,1,21,'ABOUTME!',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,1,NULL,'about_project',NULL,'',NULL,NULL,NULL),(2225,100,1,22,'',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(2226,100,1,23,'sf asfasf',91,91,'1970-01-01 00:00:00','2009-03-17 23:26:46',101,1,NULL,'trivia','kpage stuff','','',NULL,NULL),(2227,223,1,1,NULL,2,2,'1970-01-01 00:00:00','2009-03-18 13:22:08',2,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2228,224,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-03-18 17:21:13',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2229,225,1,1,NULL,10,10,'1970-01-01 00:00:00','2009-03-19 12:01:48',10,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2230,227,1,1,NULL,201,201,'1970-01-01 00:00:00','2009-03-20 10:54:55',201,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2231,228,1,1,NULL,201,201,'1970-01-01 00:00:00','2009-03-20 13:45:56',201,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2249,229,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-03-20 19:31:42',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2250,90,1,70,'My Occupation',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2251,90,1,71,'san diego',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2252,90,1,72,'my, taggable, tags',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(2253,90,1,73,'Stanford University',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'school',NULL,NULL,NULL,NULL,NULL),(2254,90,1,74,'kalikode',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(2255,90,1,75,'itest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(2256,90,1,76,'USA',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2257,90,1,77,'july sometime',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(2261,90,1,78,'ytest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(2262,90,1,79,'mtest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(2263,90,1,80,'http://www.kroogi.com',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(2264,90,1,81,'asdfasf asfasf ABOUT ME',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'bio',NULL,'',NULL,NULL,NULL),(2265,90,1,82,'atest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(2266,90,1,83,'ljtest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(2267,90,1,84,'mtest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(2268,90,1,85,'gtest',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(2269,90,1,86,'anwer',91,91,'1970-01-01 00:00:00','2009-03-20 23:22:52',91,1,NULL,'trivia','My Quetion -E','RUSSIAN  answer','RUSSSIAN quest',NULL,NULL),(2343,9,1,0,'answer1',10,10,'1970-01-01 00:00:00','2010-02-15 16:29:34',10,0,NULL,'trivia','й1','ответ1','q1',NULL,NULL),(2362,9,1,1,'answer2',10,10,'1970-01-01 00:00:00','2010-02-15 16:29:34',10,0,NULL,'trivia','question 2 - english language','ответ2','вопрос 2 - русский язык',NULL,NULL),(2769,231,1,177,'a1',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:41',232,1,NULL,'trivia','q1','','',NULL,NULL),(2770,231,1,178,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2771,231,1,179,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2772,231,1,180,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(2773,231,1,181,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(2774,231,1,182,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(2775,231,1,183,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(2776,231,1,184,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2777,231,1,185,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(2781,231,1,186,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(2782,231,1,187,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(2783,231,1,188,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(2784,231,1,189,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(2785,231,1,190,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(2786,231,1,191,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(2787,231,1,192,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(2788,231,1,193,'',232,232,'1970-01-01 00:00:00','2009-03-24 17:24:51',232,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(2882,7,1,0,'dgfhf',8,8,'1970-01-01 00:00:00','2009-03-26 14:49:29',8,1,NULL,'trivia','q1__','прпар___','й1__',NULL,NULL),(2883,7,1,1,'fhtht__cvc',8,8,'1970-01-01 00:00:00','2009-03-26 14:50:33',8,1,NULL,'trivia','q2__!','арар__cc','й2__!',NULL,NULL),(2919,7,1,2,'cghgj',8,8,'1970-01-01 00:00:00','2009-03-26 14:50:33',8,1,NULL,'trivia','q3','варпар','й3',NULL,NULL),(2939,234,1,1,'',235,235,'1970-01-01 00:00:00','2009-03-27 15:47:33',235,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2940,234,1,2,'',235,235,'1970-01-01 00:00:00','2009-03-27 15:47:33',235,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2941,235,1,1,'',236,236,'1970-01-01 00:00:00','2009-03-27 15:48:06',236,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2942,235,1,2,'',236,236,'1970-01-01 00:00:00','2009-03-27 15:48:06',236,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2943,236,1,1,'Ashdod',237,237,'1970-01-01 00:00:00','2009-04-01 16:06:07',237,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2944,236,1,2,'Isreal',237,237,'1970-01-01 00:00:00','2009-04-01 16:06:07',237,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2945,238,1,1,'11',239,239,'1970-01-01 00:00:00','2009-04-02 15:22:52',239,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2946,238,1,2,'11',239,239,'1970-01-01 00:00:00','2009-04-02 15:22:53',239,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2947,241,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-04-02 15:53:11',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2948,73,1,13,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2949,73,1,14,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2950,73,1,15,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(2951,73,1,16,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(2952,73,1,17,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(2953,73,1,18,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(2954,73,1,19,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2955,73,1,20,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(2960,73,1,21,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:28',74,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(2961,73,1,22,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(2962,73,1,23,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(2963,73,1,24,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(2964,73,1,25,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(2965,73,1,26,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(2966,73,1,27,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(2967,73,1,28,'',74,74,'1970-01-01 00:00:00','2009-04-06 13:41:29',74,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(2985,246,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-04-17 19:13:06',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2986,247,1,1,'',248,248,'1970-01-01 00:00:00','2009-05-08 18:16:15',248,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2987,247,1,2,'',248,248,'1970-01-01 00:00:00','2009-05-08 18:16:15',248,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2988,250,1,1,NULL,248,248,'1970-01-01 00:00:00','2009-05-13 04:24:39',248,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2989,251,1,1,NULL,248,248,'1970-01-01 00:00:00','2009-05-13 04:33:04',248,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2991,254,1,1,NULL,248,248,'1970-01-01 00:00:00','2009-05-18 10:50:18',248,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2992,255,1,1,NULL,248,248,'1970-01-01 00:00:00','2009-05-18 10:52:21',248,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(2993,259,1,1,'dd',262,262,'1970-01-01 00:00:00','2009-05-21 15:16:50',262,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2994,259,1,2,'cc',262,262,'1970-01-01 00:00:00','2009-05-21 15:16:50',262,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2995,264,1,1,'dsfgg',268,268,'1970-01-01 00:00:00','2009-05-22 16:14:24',268,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2996,264,1,2,'dfg',268,268,'1970-01-01 00:00:00','2009-05-22 16:14:24',268,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2997,244,1,1,'fg',245,245,'1970-01-01 00:00:00','2009-05-26 21:41:14',245,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(2998,244,1,2,'fg',245,245,'1970-01-01 00:00:00','2009-05-26 21:41:14',245,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(2999,265,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-05-27 14:57:06',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3020,250,1,2,'',248,248,'1970-01-01 00:00:00','2009-06-30 18:43:59',251,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3021,250,1,3,'',248,248,'1970-01-01 00:00:00','2009-06-30 18:43:59',251,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3022,255,1,2,'',248,248,'1970-01-01 00:00:00','2009-06-30 18:44:13',256,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3023,255,1,3,'',248,248,'1970-01-01 00:00:00','2009-06-30 18:44:13',256,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3026,251,1,2,'',248,248,'1970-01-01 00:00:00','2009-06-30 18:44:40',252,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3027,251,1,3,'',248,248,'1970-01-01 00:00:00','2009-06-30 18:44:40',252,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3028,217,1,12,'',8,8,'1970-01-01 00:00:00','2009-06-30 18:48:25',218,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3029,217,1,13,'',8,8,'1970-01-01 00:00:00','2009-06-30 18:48:25',218,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3030,175,1,6,'',8,8,'1970-01-01 00:00:00','2009-06-30 18:49:58',176,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3031,175,1,7,'',8,8,'1970-01-01 00:00:00','2009-06-30 18:49:58',176,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3032,241,1,2,'',8,8,'1970-01-01 00:00:00','2009-07-01 14:13:53',242,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3033,241,1,3,'',8,8,'1970-01-01 00:00:00','2009-07-01 14:13:53',242,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3034,214,1,2,'',8,8,'1970-01-01 00:00:00','2009-07-01 15:51:04',215,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3035,214,1,3,'',8,8,'1970-01-01 00:00:00','2009-07-01 15:51:04',215,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3056,230,1,23,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:09',231,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3057,230,1,24,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3058,230,1,25,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3059,230,1,26,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3060,230,1,27,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3061,230,1,28,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3062,230,1,29,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3063,230,1,30,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(3068,230,1,31,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3069,230,1,32,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3070,230,1,33,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3071,230,1,34,'Nearly 100 years after D.W. Griffith\'s epic The Birth of a Nation was released, performance artist and musician Paul D. Miller, a.k.a DJ Spooky That Subliminal Kid, has applied a \"DJ mix\" to one of the most revered and reviled films ever made. Miller\'s reading of the overt racism depicted in a Reconstruction-era South hurtles Griffith\'s images into the 21st Century, a socio-political landscape that has evolved beyond all expectations. Originally commissioned as a live multimedia performance, this theatrical version features an original score by Miller, performed by Kronos Quartet.',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(3072,230,1,35,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3073,230,1,36,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3074,230,1,37,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3075,230,1,38,'',231,231,'1970-01-01 00:00:00','2009-07-03 12:41:10',231,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3079,267,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-07-06 16:49:40',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3080,267,1,2,'a',8,8,'1970-01-01 00:00:00','2009-07-06 17:07:51',294,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3081,267,1,3,'q',8,8,'1970-01-01 00:00:00','2009-07-06 17:07:51',294,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3082,227,1,2,'Oblomovsk',201,201,'1970-01-01 00:00:00','2009-07-06 18:02:54',228,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3083,227,1,3,'Rus\'',201,201,'1970-01-01 00:00:00','2009-07-06 18:02:54',228,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3084,203,1,1,'Spokane',204,204,'1970-01-01 00:00:00','2009-07-21 23:22:04',204,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3085,203,1,2,'USA',204,204,'1970-01-01 00:00:00','2009-07-21 23:22:04',204,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3086,223,1,2,'',2,2,'1970-01-01 00:00:00','2009-08-03 16:22:06',224,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3087,223,1,3,'',2,2,'1970-01-01 00:00:00','2009-08-03 16:22:06',224,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3088,265,1,2,'',8,8,'1970-01-01 00:00:00','2009-08-05 21:18:58',272,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3089,265,1,3,'',8,8,'1970-01-01 00:00:00','2009-08-05 21:18:58',272,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3090,268,1,1,'2',300,300,'1970-01-01 00:00:00','2009-08-06 19:52:05',300,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3091,268,1,2,'1',300,300,'1970-01-01 00:00:00','2009-08-06 19:52:05',300,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3092,269,1,1,NULL,300,300,'1970-01-01 00:00:00','2009-08-06 19:57:56',300,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3093,269,1,2,'2',300,300,'1970-01-01 00:00:00','2009-08-06 19:58:14',301,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3094,269,1,3,'1',300,300,'1970-01-01 00:00:00','2009-08-06 19:58:14',301,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3095,270,1,1,NULL,300,300,'1970-01-01 00:00:00','2009-08-06 20:01:14',300,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3096,270,1,2,'2',300,300,'1970-01-01 00:00:00','2009-08-06 20:01:36',302,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3097,270,1,3,'324',300,300,'1970-01-01 00:00:00','2009-08-06 20:01:36',302,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3132,7,1,876,'... with diamonds',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3133,7,1,877,'Prague',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3134,7,1,878,'sports, nesports',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3135,7,1,879,'gfhgfhfg',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3136,7,1,880,'anya2606',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3137,7,1,881,'6y5765767',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3138,7,1,882,'The Earth',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3139,7,1,883,'06-26',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(3141,7,1,884,'anya260676',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3142,7,1,885,'aika99',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3143,7,1,886,'http://anyanikulina.com',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3144,7,1,887,'\"Anya in The Sky\" is a DJ project of Anita Goldwin. Enjoy the experience! aaasdaмсрпа',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'bio',NULL,'perevodнеоp-9oo0риои',NULL,NULL,NULL),(3145,7,1,888,'anyanik',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3146,7,1,889,'aika99',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3147,7,1,890,'anya260676',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3148,7,1,891,'aaa',8,8,'1970-01-01 00:00:00','2009-08-13 17:36:40',8,1,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3149,229,1,2,'',8,8,'1970-01-01 00:00:00','2009-08-15 22:22:08',230,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3150,229,1,3,'',8,8,'1970-01-01 00:00:00','2009-08-15 22:22:08',230,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3151,271,1,1,'SF',304,304,'1970-01-01 00:00:00','2009-08-21 02:23:51',304,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3152,271,1,2,'US',304,304,'1970-01-01 00:00:00','2009-08-21 02:23:51',304,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3153,174,1,6,'',8,8,'1970-01-01 00:00:00','2009-08-21 23:07:45',175,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3154,174,1,7,'',8,8,'1970-01-01 00:00:00','2009-08-21 23:07:45',175,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3155,272,1,1,NULL,234,234,'1970-01-01 00:00:00','2009-08-26 17:11:11',234,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3156,272,1,2,'c',234,234,'1970-01-01 00:00:00','2009-08-26 17:14:11',305,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3157,272,1,3,'c',234,234,'1970-01-01 00:00:00','2009-08-26 17:14:11',305,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3158,233,1,3,'prof',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3159,233,1,4,'city',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3160,233,1,5,'sdf. tag2, tag45',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3161,233,1,6,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3162,233,1,7,'sfd',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3163,233,1,8,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3164,233,1,9,'country',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3165,233,1,10,'11.09.1973',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(3166,233,1,11,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3167,233,1,12,'dsf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:03',234,1,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3168,233,1,13,'http://dfs',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3169,233,1,14,'d',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'bio',NULL,'sdf',NULL,NULL,NULL),(3170,233,1,15,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3171,233,1,16,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3172,233,1,17,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3173,233,1,18,'df',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3174,233,1,19,'sdf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'trivia','sdf','cbg','cvb',NULL,NULL),(3175,233,1,20,'gbgf',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'trivia','gb','gdf','dfgfd',NULL,NULL),(3176,233,1,21,'xvb',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'trivia','vbc','zzz','fgdf',NULL,NULL),(3177,233,1,22,'xcvb',234,234,'1970-01-01 00:00:00','2009-08-26 17:18:04',234,1,NULL,'trivia','xdf','dbf','dfgfd',NULL,NULL),(3178,273,1,1,NULL,10,10,'1970-01-01 00:00:00','2009-09-01 12:30:45',10,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3179,273,1,2,'',10,10,'1970-01-01 00:00:00','2009-09-01 12:30:51',306,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3180,273,1,3,'',10,10,'1970-01-01 00:00:00','2009-09-01 12:30:51',306,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3181,274,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-09-03 15:48:45',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3182,274,1,2,'',8,8,'1970-01-01 00:00:00','2009-09-03 16:53:08',307,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3183,274,1,3,'',8,8,'1970-01-01 00:00:00','2009-09-03 16:53:09',307,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3184,19,1,0,'qwerty',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3185,19,1,1,'dsna',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3186,19,1,1,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3187,19,1,2,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3188,19,1,2,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3189,19,1,3,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3190,19,1,3,'country',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3191,19,1,4,'19/02/1077',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(3196,19,1,5,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3197,19,1,6,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3198,19,1,7,'http://www.ya.ru',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3199,19,1,8,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(3200,19,1,9,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3201,19,1,10,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3202,19,1,11,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3203,19,1,12,'',20,20,'1970-01-01 00:00:00','2009-09-03 16:57:33',20,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3204,275,1,1,NULL,8,8,'1970-01-01 00:00:00','2009-09-04 11:18:00',8,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3205,275,1,2,'c',8,8,'1970-01-01 00:00:00','2009-09-04 11:19:00',308,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3206,275,1,3,'c',8,8,'1970-01-01 00:00:00','2009-09-04 11:19:00',308,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3207,248,1,1,'',249,249,'1970-01-01 00:00:00','2009-09-04 13:45:28',249,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3208,248,1,2,'',249,249,'1970-01-01 00:00:00','2009-09-04 13:45:28',249,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3209,262,1,1,'',265,265,'1970-01-01 00:00:00','2009-09-05 13:56:18',265,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3210,262,1,2,'',265,265,'1970-01-01 00:00:00','2009-09-05 13:56:18',265,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3211,216,1,2,'',206,206,'1970-01-01 00:00:00','2009-10-20 15:44:23',217,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3212,216,1,3,'',206,206,'1970-01-01 00:00:00','2009-10-20 15:44:23',217,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3231,97,1,3,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:20:04',98,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3249,97,1,16,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:22:28',98,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3267,97,1,30,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3268,97,1,31,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3269,97,1,32,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'about_project',NULL,'',NULL,NULL,NULL),(3270,97,1,33,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3271,97,1,34,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3276,97,1,35,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3277,97,1,36,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3278,97,1,37,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3279,97,1,38,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3280,97,1,39,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3281,97,1,40,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3282,97,1,41,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3283,97,1,42,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3284,97,1,43,'',10,10,'1970-01-01 00:00:00','2009-11-25 12:27:35',98,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3285,266,1,2,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:48',293,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3286,266,1,2,'Stadt',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:48',293,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3287,266,1,3,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:48',293,0,NULL,'about_project',NULL,'',NULL,NULL,NULL),(3288,266,1,3,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:48',293,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3289,266,1,4,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:48',293,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3294,266,1,5,'Country',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3295,266,1,6,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3296,266,1,7,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3297,266,1,8,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3298,266,1,9,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3299,266,1,10,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3300,266,1,11,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3301,266,1,12,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3302,266,1,13,'',231,231,'1970-01-01 00:00:00','2010-02-04 21:30:49',293,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3429,252,1,30,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3430,252,1,31,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3431,252,1,32,'iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii iiiiiiii',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,1,NULL,'about_project',NULL,'',NULL,NULL,NULL),(3432,252,1,33,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3433,252,1,34,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3438,252,1,35,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3439,252,1,36,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3440,252,1,37,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3441,252,1,38,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3442,252,1,39,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3443,252,1,40,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3444,252,1,41,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3445,252,1,42,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3446,252,1,43,'',248,248,'1970-01-01 00:00:00','2010-02-15 17:30:33',252,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3447,166,1,1,'',167,167,'1970-01-01 00:00:00','2010-02-18 14:40:51',167,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3448,166,1,2,'',167,167,'1970-01-01 00:00:00','2010-02-18 14:40:51',167,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3449,294,1,1,'',327,327,'1970-01-01 00:00:00','2010-02-22 15:08:03',327,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3450,294,1,2,'',327,327,'1970-01-01 00:00:00','2010-02-22 15:08:03',327,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3451,301,1,1,'',334,334,'1970-01-01 00:00:00','2010-02-25 16:06:25',334,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3452,301,1,2,'',334,334,'1970-01-01 00:00:00','2010-02-25 16:06:25',334,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3453,312,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 19:44:55',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3454,314,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 20:10:19',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3455,316,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 21:16:27',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3456,318,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 21:19:57',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3457,320,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 21:32:52',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3458,322,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 21:48:56',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3459,325,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 22:22:31',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3460,327,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 22:53:37',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3461,329,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-02-25 22:58:33',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3462,331,1,1,'',364,364,'1970-01-01 00:00:00','2010-03-02 18:01:50',364,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3463,331,1,2,'',364,364,'1970-01-01 00:00:00','2010-03-02 18:01:50',364,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3464,336,1,1,'',369,369,'1970-01-01 00:00:00','2010-03-03 23:01:05',369,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3465,336,1,2,'',369,369,'1970-01-01 00:00:00','2010-03-03 23:01:05',369,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3466,337,1,1,'',370,370,'1970-01-01 00:00:00','2010-03-03 23:30:20',370,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3467,337,1,2,'',370,370,'1970-01-01 00:00:00','2010-03-03 23:30:20',370,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3468,352,1,1,NULL,10,10,'1970-01-01 00:00:00','2010-03-12 20:20:58',10,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3469,367,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-15 20:22:48',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3470,369,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-15 20:37:53',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3471,370,1,1,NULL,401,401,'1970-01-01 00:00:00','2010-03-15 20:50:05',401,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3472,373,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 12:30:33',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3473,375,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 12:36:49',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3474,377,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 12:41:13',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3475,379,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 12:56:00',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3476,378,1,1,'',411,411,'1970-01-01 00:00:00','2010-03-23 13:01:13',411,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3477,378,1,2,'',411,411,'1970-01-01 00:00:00','2010-03-23 13:01:13',411,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3478,381,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 13:18:05',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3479,383,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 13:24:47',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3480,385,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 13:38:39',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3481,388,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-03-23 14:02:37',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3482,387,1,1,'',423,423,'1970-01-01 00:00:00','2010-03-23 16:54:33',423,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3483,387,1,2,'',423,423,'1970-01-01 00:00:00','2010-03-23 16:54:33',423,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3484,350,1,1,'',383,383,'1970-01-01 00:00:00','2010-04-06 08:55:28',383,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3485,350,1,2,'',383,383,'1970-01-01 00:00:00','2010-04-06 08:55:28',383,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(3486,350,1,3,'',383,383,'1970-01-01 00:00:00','2010-04-06 08:55:28',383,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3487,350,1,4,'',383,383,'1970-01-01 00:00:00','2010-04-06 08:55:28',383,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(3488,402,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-05-04 08:29:00',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3489,403,1,1,NULL,10,10,'1970-01-01 00:00:00','2010-05-04 08:53:55',10,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3490,9,1,200,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:02',10,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3491,9,1,201,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:02',10,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3492,9,1,202,'miro-kto-to',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:02',10,1,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3493,9,1,203,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:02',10,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3496,9,1,204,'1967-07-17',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'birthdate',NULL,NULL,NULL,NULL,NULL),(3497,9,1,205,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3498,9,1,206,'miro_ora',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3499,9,1,207,'http://www.your-net-works.com',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,1,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3500,9,1,208,'I need lil',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,1,NULL,'bio',NULL,'Мне мало надо\r\nКраюшку хлеба\r\nИ каплю молока\r\nДа это небо\r\nДа эти облака',NULL,NULL,NULL),(3501,9,1,209,'miros',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3502,9,1,210,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3503,9,1,211,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3504,9,1,212,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3505,9,1,213,'',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3506,9,1,214,'alpha beta charlie bravo delta',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,1,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3507,9,1,215,'ленинский университет миллионов',10,10,'1970-01-01 00:00:00','2010-05-07 17:16:03',10,1,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3508,406,1,1,NULL,-1,-1,'1970-01-01 00:00:00','2010-06-24 13:49:32',-1,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3525,405,1,0,'Default answer 1',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'trivia','Default question 1','','',NULL,NULL),(3526,405,1,1,'Default answer 2',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'trivia','Default question 2','','',NULL,NULL),(3527,405,1,2,'Default answer 3',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'trivia','Default question 3','','',NULL,NULL),(3528,405,1,3,'Default answer 4',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'trivia','Default question 4','','',NULL,NULL),(3649,405,1,140,'user',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3650,405,1,141,'Berlin',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3651,405,1,142,'music, computers, web',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3652,405,1,143,'HumboldtUniversity',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3653,405,1,144,'joe303',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3654,405,1,145,'123456789',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3655,405,1,146,'Germany',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3656,405,1,147,'joooe',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3657,405,1,148,'joe303',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3658,405,1,149,'http://www.kroogi.com',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3659,405,1,150,'I\'m very nice guy.',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:35',441,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(3660,405,1,151,'joooe',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:36',441,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3661,405,1,152,'joe-magnificient',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:36',441,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3662,405,1,153,'joe-joe',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:36',441,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3663,405,1,154,'joe',441,441,'1970-01-01 00:00:00','2010-06-28 17:48:36',441,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3664,407,1,1,'fundraising',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:16',441,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3665,407,1,2,'Berlin',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3666,407,1,3,'avatar, band, navi',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3667,407,1,4,'avatar-band',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3668,407,1,5,'333444555',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3669,407,1,6,'Germany',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3670,407,1,7,'avatar',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3671,407,1,8,'avavatar',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3672,407,1,9,'http://www.avatarband.com',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3673,407,1,10,'avataar',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3674,407,1,11,'avatar303',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3675,407,1,12,'avatar',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3676,407,1,13,'Visit our site to learn more.',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'about_project',NULL,'',NULL,NULL,NULL),(3677,407,1,14,'avatar_',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL),(3678,407,1,15,'Answer 1',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'trivia','Question 1','','',NULL,NULL),(3679,407,1,16,'Answer 2',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'trivia','Question 2','','',NULL,NULL),(3680,407,1,17,'Answer 3',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'trivia','Question 3','','',NULL,NULL),(3681,407,1,18,'Answer 4',441,441,'1970-01-01 00:00:00','2010-06-28 18:38:17',441,0,NULL,'trivia','Question 4','','',NULL,NULL),(3682,2,1,3,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'occupation',NULL,NULL,NULL,NULL,NULL),(3683,2,1,4,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'city',NULL,NULL,NULL,NULL,NULL),(3684,2,1,5,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'interests',NULL,NULL,NULL,NULL,NULL),(3685,2,1,6,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'school',NULL,NULL,NULL,NULL,NULL),(3686,2,1,7,'sashalerner',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'skype',NULL,NULL,NULL,NULL,NULL),(3687,2,1,8,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'icq',NULL,NULL,NULL,NULL,NULL),(3688,2,1,9,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'country',NULL,NULL,NULL,NULL,NULL),(3693,2,1,10,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'yahoo',NULL,NULL,NULL,NULL,NULL),(3694,2,1,11,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'myspace',NULL,NULL,NULL,NULL,NULL),(3695,2,1,12,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:32',2,0,NULL,'website',NULL,NULL,NULL,NULL,NULL),(3696,2,1,13,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:33',2,0,NULL,'bio',NULL,'',NULL,NULL,NULL),(3697,2,1,14,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:33',2,0,NULL,'aol',NULL,NULL,NULL,NULL,NULL),(3698,2,1,15,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:33',2,0,NULL,'lj',NULL,NULL,NULL,NULL,NULL),(3699,2,1,16,'',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:33',2,0,NULL,'msn',NULL,NULL,NULL,NULL,NULL),(3700,2,1,17,'gmail',2,2,'1970-01-01 00:00:00','2010-07-19 14:57:33',2,0,NULL,'gmail',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `profile_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_types`
--

DROP TABLE IF EXISTS `profile_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL DEFAULT '1',
  `user_id` int(11) NOT NULL DEFAULT '1',
  `profile_name_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_types`
--

LOCK TABLES `profile_types` WRITE;
/*!40000 ALTER TABLE `profile_types` DISABLE KEYS */;
INSERT INTO `profile_types` VALUES (1,1,1,1),(2,2,2,1),(14,2,2,5);
/*!40000 ALTER TABLE `profile_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '1',
  `account_type_id` int(11) DEFAULT NULL,
  `avatar_id` int(11) DEFAULT NULL,
  `userpic_id` int(11) DEFAULT NULL,
  `wizard_completed` tinyint(1) DEFAULT '0',
  `tagline` varchar(255) DEFAULT NULL,
  `tagline_ru` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_profiles_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=409 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,1,0,NULL,NULL,1,'Musician','Musician'),(2,2,0,8895,NULL,1,'Musician, Photographer','Musician, Photographer'),(405,441,0,NULL,NULL,0,'live and let live',''),(406,442,1,NULL,NULL,0,NULL,NULL),(407,443,1,NULL,NULL,0,'save navi!',''),(408,444,0,NULL,NULL,0,'basic motto','');
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `public_answers`
--

DROP TABLE IF EXISTS `public_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `text` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `avatar_id` int(11) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_public_answers_on_question_id_and_deleted` (`question_id`,`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `public_answers`
--

LOCK TABLES `public_answers` WRITE;
/*!40000 ALTER TABLE `public_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `public_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `public_questions`
--

DROP TABLE IF EXISTS `public_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `text` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `text_ru` text,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `show_on_events` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_public_questions_on_user_id_and_state` (`user_id`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `public_questions`
--

LOCK TABLES `public_questions` WRITE;
/*!40000 ALTER TABLE `public_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `public_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rare_user_settings`
--

DROP TABLE IF EXISTS `rare_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rare_user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `questions_enabled` tinyint(1) DEFAULT NULL,
  `questions_interval` int(11) DEFAULT NULL,
  `questions_interval_random_delta` int(11) DEFAULT NULL,
  `allows_guest_comments` tinyint(1) DEFAULT NULL,
  `fwd_tos_allowed` tinyint(1) DEFAULT NULL,
  `need_to_show_wizard` tinyint(1) DEFAULT NULL,
  `wall_notes_tab_index` tinyint(4) DEFAULT NULL,
  `questions_kit_id` varchar(255) DEFAULT NULL,
  `tps_setup_enabled` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rare_user_settings`
--

LOCK TABLES `rare_user_settings` WRITE;
/*!40000 ALTER TABLE `rare_user_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `rare_user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating_stats`
--

DROP TABLE IF EXISTS `rating_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rated_id` int(11) DEFAULT NULL,
  `rated_type` varchar(255) DEFAULT NULL,
  `rating_count` int(11) DEFAULT NULL,
  `rating_total` decimal(10,0) DEFAULT NULL,
  `rating_avg` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rating_stats_on_rated_type_and_rated_id` (`rated_type`,`rated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating_stats`
--

LOCK TABLES `rating_stats` WRITE;
/*!40000 ALTER TABLE `rating_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rater_id` int(11) DEFAULT NULL,
  `rated_id` int(11) DEFAULT NULL,
  `rated_type` varchar(255) DEFAULT NULL,
  `rating` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ratings_on_rater_id` (`rater_id`),
  KEY `index_ratings_on_rated_type_and_rated_id` (`rated_type`,`rated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `related_contents`
--

DROP TABLE IF EXISTS `related_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `related_contents` (
  `first_content_id` int(11) NOT NULL,
  `second_content_id` int(11) DEFAULT NULL,
  `download_count` int(11) DEFAULT '0',
  `download_percentage` float DEFAULT '0',
  `relatedness` float DEFAULT '0',
  KEY `index_related_contents_on_first_content_id_and_relatedness` (`first_content_id`,`relatedness`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_contents`
--

LOCK TABLES `related_contents` WRITE;
/*!40000 ALTER TABLE `related_contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `related_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `related_contents_work_table`
--

DROP TABLE IF EXISTS `related_contents_work_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `related_contents_work_table` (
  `first_content_id` int(11) NOT NULL,
  `second_content_id` int(11) DEFAULT NULL,
  `download_count` int(11) DEFAULT '0',
  `download_percentage` float DEFAULT '0',
  `relatedness` float DEFAULT '0',
  KEY `index_related_contents_work_table_on_first_content_id` (`first_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_contents_work_table`
--

LOCK TABLES `related_contents_work_table` WRITE;
/*!40000 ALTER TABLE `related_contents_work_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `related_contents_work_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationships`
--

DROP TABLE IF EXISTS `relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `related_user_id` int(11) NOT NULL DEFAULT '0',
  `relationshiptype_id` int(4) NOT NULL DEFAULT '0',
  `related_entity_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `attributebits` int(11) NOT NULL DEFAULT '0',
  `expires_at` datetime DEFAULT '2038-01-01 00:00:00',
  `privacylevel` int(4) NOT NULL DEFAULT '0',
  `display_order` int(11) DEFAULT '0',
  `last_notified_of_expiration` datetime DEFAULT NULL,
  `created_with_fb` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_relationships_on_userid_typeid_ts` (`user_id`,`relationshiptype_id`,`created_at`),
  KEY `index_relationships_on_relateduserid_typeid_ts` (`related_user_id`,`relationshiptype_id`,`created_at`),
  KEY `index_relationships_on_related_entity_id` (`related_entity_id`),
  KEY `index_relationships_on_created_at` (`created_at`),
  KEY `index_relationships_on_relationshiptype_id_and_user_id` (`relationshiptype_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1183 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationships`
--

LOCK TABLES `relationships` WRITE;
/*!40000 ALTER TABLE `relationships` DISABLE KEYS */;
INSERT INTO `relationships` VALUES (1182,443,441,0,NULL,'2010-06-25 15:49:27',0,'2037-12-31 23:00:00',0,0,NULL,0);
/*!40000 ALTER TABLE `relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationshiptypes`
--

DROP TABLE IF EXISTS `relationshiptypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relationshiptypes` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `restricted` int(4) NOT NULL DEFAULT '0',
  `position` int(4) NOT NULL DEFAULT '0',
  `explanation_db_store_id` int(11) DEFAULT NULL,
  `explanation_db_store_ru_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationshiptypes`
--

LOCK TABLES `relationshiptypes` WRITE;
/*!40000 ALTER TABLE `relationshiptypes` DISABLE KEYS */;
INSERT INTO `relationshiptypes` VALUES (-2,'Everyone',1,10,NULL,NULL),(-1,'Only me',1,2,NULL,NULL),(0,'Founders',2,3,NULL,NULL),(1,'Family',0,4,354,361),(2,'Backstage',0,5,355,362),(3,'Front row',0,6,356,363),(4,'Fan club',0,7,357,364),(5,'Interested',0,8,358,365),(7,'Watching',0,9,NULL,NULL);
/*!40000 ALTER TABLE `relationshiptypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `status` int(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_roles_on_name` (`name`),
  KEY `index_roles_on_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'anonymous',1),(2,'admin',1),(3,'user',1),(4,'moderator',1);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  UNIQUE KEY `index_roles_users_on_user_id_and_role_id` (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('1'),('10'),('100'),('101'),('102'),('103'),('104'),('105'),('106'),('107'),('108'),('109'),('11'),('110'),('111'),('112'),('113'),('114'),('115'),('116'),('117'),('118'),('119'),('12'),('120'),('121'),('122'),('123'),('124'),('125'),('126'),('127'),('128'),('129'),('13'),('130'),('131'),('132'),('133'),('134'),('135'),('136'),('137'),('138'),('139'),('14'),('140'),('141'),('142'),('143'),('144'),('145'),('146'),('147'),('148'),('149'),('15'),('150'),('151'),('152'),('153'),('154'),('155'),('156'),('157'),('158'),('159'),('16'),('160'),('161'),('162'),('163'),('164'),('165'),('166'),('167'),('168'),('169'),('17'),('170'),('171'),('172'),('174'),('18'),('19'),('2'),('20'),('20080806000908'),('20080806212115'),('20080807012708'),('20080807191214'),('20080811231748'),('20080812011105'),('20080815010748'),('20080819232837'),('20080819234322'),('20080821170757'),('20080822175858'),('20080825175137'),('20080825185652'),('20080825191659'),('20080826161401'),('20080826183853'),('20080827014251'),('20080903185544'),('20080904142122'),('20080904223801'),('20080904232257'),('20080905201040'),('20080906021734'),('20080906184650'),('20080907233937'),('20080908234254'),('20080909013756'),('20080912000744'),('20080912052348'),('20080912153430'),('20080912172647'),('20080915171332'),('20080916215553'),('20080917174232'),('20080918003239'),('20080918211701'),('20080920021107'),('20080922181556'),('20080923185339'),('20080924002757'),('20080924010459'),('20080925011717'),('20081001193453'),('20081003001827'),('20081003002150'),('20081003010042'),('20081003191441'),('20081006184148'),('20081006211752'),('20081007011320'),('20081007123000'),('20081007191020'),('20081007231849'),('20081008032842'),('20081008180621'),('20081008183047'),('20081009183132'),('20081010040640'),('20081010052342'),('20081010172953'),('20081010231358'),('20081011043438'),('20081011044141'),('20081014223842'),('20081016211935'),('20081016222543'),('20081017223709'),('20081021154754'),('20081022172712'),('20081023214927'),('20081027230919'),('20081028193108'),('20081028221616'),('20081030220039'),('20081105184147'),('20081105202004'),('20081106211627'),('20081110045500'),('20081110235002'),('20081111044359'),('20081111045828'),('20081113010420'),('20081118004557'),('20081121234116'),('20081125165902'),('20081125165903'),('20081125165909'),('20081127201644'),('20081127201645'),('20081201215836'),('20081201224531'),('20081202003955'),('20081202212850'),('20081203231432'),('20081204222755'),('20081208212009'),('20081209231331'),('20081210004804'),('20081210014255'),('20081210190328'),('20081210192213'),('20081212025454'),('20081212200747'),('20081212210339'),('20081213044402'),('20081216011341'),('20081216193011'),('20081216221014'),('20081216224705'),('20081217231727'),('20081222175239'),('20081224151519'),('20090105205048'),('20090106005106'),('20090106025708'),('20090107055114'),('20090113205609'),('20090115130316'),('20090116222827'),('20090117214115'),('20090118192138'),('20090118211851'),('20090122024205'),('20090122225444'),('20090122225708'),('20090122234300'),('20090123193637'),('20090123215543'),('20090123231556'),('20090126194039'),('20090127224322'),('20090130090507'),('20090131063336'),('20090203020339'),('20090203210157'),('20090204002839'),('20090209192231'),('20090209194807'),('20090210004551'),('20090211210709'),('20090211215827'),('20090211221438'),('20090211222143'),('20090212135816'),('20090213174339'),('20090213180806'),('20090213205020'),('20090214194429'),('20090214211924'),('20090216212515'),('20090216230234'),('20090220180953'),('20090220193940'),('20090223174015'),('20090224102801'),('20090225201707'),('20090304012207'),('20090307182025'),('20090313233015'),('20090318185037'),('20090318205724'),('20090319220921'),('20090320073517'),('20090324162535'),('20090414183615'),('20090509183615'),('20090512130713'),('20090514042602'),('20090515151615'),('20090522142659'),('20090525141055'),('20090525154430'),('20090529172640'),('20090602204144'),('20090605165211'),('20090608181001'),('20090609163145'),('20090616175338'),('20090616221342'),('20090621184654'),('20090707174621'),('20090709191135'),('20090715195719'),('20090719163927'),('20090729182251'),('20090730231859'),('20090730232636'),('20090805190210'),('20090810144230'),('20090812152709'),('20090813145216'),('20090813201429'),('20090813224248'),('20090814063036'),('20090814172711'),('20090817220513'),('20090818161450'),('20090818190530'),('20090818231608'),('20090819013043'),('20090819205821'),('20090820013006'),('20090820172711'),('20090820205344'),('20090821001358'),('20090822161503'),('20090822165156'),('20090822165942'),('20090822180512'),('20090822234127'),('20090823013842'),('20090825093032'),('20090825185714'),('20090825212818'),('20090827151755'),('20090828193000'),('20090901062609'),('20090902122408'),('20090902183440'),('20090903173730'),('20090904180156'),('20090905000001'),('20090906184102'),('20090906191142'),('20090907163814'),('20090907180724'),('20090907201643'),('20090909015523'),('20090921150814'),('20091005200038'),('20091005214802'),('20091009172441'),('20091013172441'),('20091019162609'),('20091019200802'),('20091020173234'),('20091021194605'),('20091026194738'),('20091029233134'),('20091030184226'),('20091102203953'),('20091103222230'),('20091106201246'),('20091109225024'),('20091111120812'),('20091112144718'),('20091116144802'),('20091118103234'),('20091119191337'),('20091123141455'),('20091126114333'),('20091126181045'),('20091213181248'),('20091214192413'),('20091215160542'),('20091216170131'),('20091222135127'),('20091222205900'),('20100109213622'),('20100109221109'),('20100112203224'),('20100113084241'),('20100113203417'),('20100122144846'),('20100124155411'),('20100208104944'),('20100208113344'),('20100208142227'),('20100212153145'),('20100224202924'),('20100301164144'),('20100317185348'),('20100318135525'),('20100325093019'),('20100326150725'),('20100404200020'),('20100405182606'),('20100407184000'),('20100408194252'),('20100421123551'),('20100421123552'),('20100421123553'),('20100423130736'),('20100423131031'),('20100423150159'),('20100423150312'),('20100426200722'),('20100429094221'),('20100429094602'),('20100505122637'),('20100506132544'),('20100507134122'),('20100511191957'),('20100511235043'),('20100511235802'),('20100512083020'),('20100512181650'),('20100512190951'),('20100512201753'),('20100517115141'),('20100518083806'),('20100518170020'),('20100520152736'),('20100520161710'),('20100525100828'),('20100525145346'),('20100525181423'),('20100601172335'),('20100602181042'),('20100604142306'),('20100608123459'),('20100609131757'),('20100610171728'),('20100618103930'),('20100623161826'),('20100623171834'),('20100624175745'),('20100630171442'),('20100702165815'),('20100706145236'),('20100707175453'),('20100712120041'),('20100715140022'),('20100721175832'),('20100722150359'),('20100804174022'),('20100810151007'),('20100810184526'),('20100813143132'),('20100819132000'),('20100824090333'),('20100824141546'),('20100825194926'),('20100826171226'),('20100826171725'),('20100830093756'),('20100901150341'),('20100902123609'),('20100903092745'),('20100903114904'),('20100903125620'),('20100903140307'),('20100903205138'),('20100906211457'),('20100907192606'),('20100907192608'),('20100908131338'),('20100908131339'),('20100916113641'),('20100917155509'),('20100924132456'),('20100927081325'),('20100927123211'),('20100928091711'),('20100929134337'),('20101001143142'),('20101004135149'),('20101006114730'),('20101006200700'),('20101007140701'),('20101007140702'),('20101007164713'),('20101008200947'),('20101008205708'),('20101008234705'),('20101011065243'),('20101018171346'),('20101102174917'),('20101102175831'),('20101108181255'),('20101109171450'),('20101111181412'),('20101111185436'),('20101112153337'),('20101112154061'),('20101117171449'),('20101123170129'),('20101123202740'),('20101124142617'),('20101124142618'),('20101124142620'),('20101124142621'),('20101124142622'),('20101203123801'),('20101203132700'),('20101212052833'),('20101217110301'),('20101217110302'),('20101217110401'),('20101217110402'),('20101220085851'),('20101220110704'),('20101220155056'),('20101220203026'),('20101221152410'),('20101223142555'),('20101223165111'),('20101224163021'),('20101227130206'),('20101227161054'),('20110105200135'),('20110110190718'),('20110112075455'),('20110118150252'),('20110121121902'),('20110123165312'),('20110124094156'),('20110125123245'),('20110125125649'),('20110125153633'),('20110126132632'),('20110126161937'),('20110127183049'),('20110201144026'),('20110203145729'),('20110210091755'),('20110211120338'),('20110214182348'),('20110216145057'),('20110216161456'),('20110222195124'),('20110223082256'),('21'),('22'),('23'),('24'),('25'),('26'),('27'),('28'),('29'),('3'),('30'),('31'),('32'),('33'),('34'),('35'),('36'),('37'),('38'),('39'),('4'),('40'),('41'),('42'),('43'),('44'),('45'),('46'),('47'),('48'),('49'),('5'),('50'),('51'),('52'),('53'),('54'),('55'),('56'),('57'),('58'),('59'),('6'),('60'),('61'),('62'),('63'),('64'),('65'),('66'),('67'),('68'),('69'),('7'),('70'),('71'),('72'),('73'),('74'),('75'),('76'),('77'),('78'),('79'),('8'),('80'),('81'),('82'),('83'),('84'),('85'),('86'),('87'),('88'),('89'),('9'),('90'),('91'),('92'),('93'),('94'),('95'),('96'),('97'),('98'),('99');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_payloads`
--

DROP TABLE IF EXISTS `sms_payloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_payloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user_id` int(11) DEFAULT NULL,
  `to_account_setting_id` int(11) DEFAULT NULL,
  `payment_for_id` int(11) DEFAULT NULL,
  `payment_for_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `postback_received_at` datetime DEFAULT NULL,
  `cloned_from_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sms_payloads_on_from_user_id` (`from_user_id`),
  KEY `index_sms_payloads_on_to_account_setting_id` (`to_account_setting_id`),
  KEY `index_sms_payloads_on_payment_for_type_and_payment_for_id` (`payment_for_type`,`payment_for_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_payloads`
--

LOCK TABLES `sms_payloads` WRITE;
/*!40000 ALTER TABLE `sms_payloads` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_payloads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smscoin_cost_options`
--

DROP TABLE IF EXISTS `smscoin_cost_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smscoin_cost_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_id` int(11) NOT NULL DEFAULT '0',
  `country_name` varchar(255) DEFAULT NULL,
  `country_name_ru` varchar(255) DEFAULT NULL,
  `country_code` varchar(255) DEFAULT NULL,
  `local_gross` decimal(11,2) DEFAULT NULL,
  `gross_usd` decimal(11,2) DEFAULT NULL,
  `net_usd` decimal(11,2) DEFAULT NULL,
  `profit` decimal(11,2) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `provider_code` varchar(255) DEFAULT NULL,
  `provider_name` varchar(255) DEFAULT NULL,
  `provider_name_ru` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_smscoin_cost_options_on_version_id` (`version_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1869 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smscoin_cost_options`
--

LOCK TABLES `smscoin_cost_options` WRITE;
/*!40000 ALTER TABLE `smscoin_cost_options` DISABLE KEYS */;
INSERT INTO `smscoin_cost_options` VALUES (1393,6,'UAE','ОАЭ','AE','10.00','2.72','0.81','30.00','AED','du','DU','DU','2010-05-13 18:22:40'),(1394,6,'UAE','ОАЭ','AE','10.00','2.72','0.81','30.00','AED','etisalat','Etisalat','Etisalat','2010-05-13 18:22:40'),(1395,6,'Albania','Албания','AL','120.00','0.96','0.24','25.00','ALL',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1396,6,'Armenia','Армения','AM','480.00','1.01','0.25','25.00','AMD',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1397,6,'Armenia','Армения','AM','1200.00','2.53','0.63','25.00','AMD',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1398,6,'Armenia','Армения','AM','2000.00','4.23','1.05','25.00','AMD',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1399,6,'Argentina','Аргентина','AR','4.84','1.03','0.15','15.00','ARS',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1400,6,'Austria','Австрия','AT','0.50','0.56','0.14','25.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1401,6,'Austria','Австрия','AT','1.99','2.21','0.88','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1402,6,'Austria','Австрия','AT','2.99','3.32','1.32','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1403,6,'Austria','Австрия','AT','4.99','5.54','2.21','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1404,6,'Australia','Австралия','AU','4.00','3.37','1.17','35.00','AUD',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1405,6,'Australia','Австралия','AU','6.60','5.55','1.38','25.00','AUD',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1406,6,'Azerbaijan','Азербайджан','AZ','5.00','5.22','1.82','35.00','AZN','azercell','Azercell','Azercell','2010-05-13 18:22:40'),(1407,6,'Azerbaijan','Азербайджан','AZ','1.00','1.04','0.36','35.00','AZN','azercell','Azercell','Azercell','2010-05-13 18:22:40'),(1408,6,'Azerbaijan','Азербайджан','AZ','0.50','0.51','0.17','35.00','AZN','azercell','Azercell','Azercell','2010-05-13 18:22:40'),(1409,6,'Azerbaijan','Азербайджан','AZ','0.10','0.09','0.03','35.00','AZN','azercell','Azercell','Azercell','2010-05-13 18:22:40'),(1410,6,'Azerbaijan','Азербайджан','AZ','5.00','5.22','1.82','35.00','AZN','azerfon','Nar Mobile','Nar Mobile','2010-05-13 18:22:40'),(1411,6,'Azerbaijan','Азербайджан','AZ','5.00','5.22','1.82','35.00','AZN','bakcell','Bakcell','Bakcell','2010-05-13 18:22:40'),(1412,6,'Bosnia and Herzegovina','Босния и Герцеговина','BA','0.59','0.34','0.10','30.00','BAM',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1413,6,'Bosnia and Herzegovina','Босния и Герцеговина','BA','1.40','0.82','0.24','30.00','BAM',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1414,6,'Bosnia and Herzegovina','Босния и Герцеговина','BA','1.87','1.09','0.38','35.00','BAM',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1415,6,'Bosnia and Herzegovina','Босния и Герцеговина','BA','2.34','1.36','0.47','35.00','BAM',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1416,6,'Belgium','Бельгия','BE','2.00','2.20','0.88','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1417,6,'Belgium','Бельгия','BE','3.00','3.30','1.32','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1418,6,'Belgium','Бельгия','BE','4.00','4.41','1.76','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1419,6,'Bulgaria','Болгария','BG','0.60','0.34','0.10','30.00','BGN',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1420,6,'Bulgaria','Болгария','BG','1.20','0.68','0.23','35.00','BGN',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1421,6,'Bulgaria','Болгария','BG','2.40','1.36','0.54','40.00','BGN',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1422,6,'Bulgaria','Болгария','BG','4.80','2.73','1.09','40.00','BGN',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1423,6,'Bolivia','Боливия','BO','8.85','1.26','0.18','15.00','BOB',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1424,6,'Belarus','Белоруссия','BY','2500.00','0.84','0.21','25.00','BYR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1425,6,'Belarus','Белоруссия','BY','5900.00','1.98','0.49','25.00','BYR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1426,6,'Belarus','Белоруссия','BY','9900.00','3.32','0.83','25.00','BYR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1427,6,'Switzerland','Швейцария','CH','0.50','0.42','0.16','40.00','CHF',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1428,6,'Switzerland','Швейцария','CH','1.00','0.86','0.34','40.00','CHF',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1429,6,'Switzerland','Швейцария','CH','2.00','1.73','0.69','40.00','CHF',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1430,6,'Switzerland','Швейцария','CH','3.00','2.60','1.04','40.00','CHF',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1431,6,'Switzerland','Швейцария','CH','5.00','4.34','1.73','40.00','CHF',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1432,6,'Chile','Чили','CL','750.00','1.19','0.23','20.00','CLP',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1433,6,'Colombia','Колумбия','CO','3596.00','1.59','0.31','20.00','COP',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1434,6,'Cyprus','Кипр','CY','3.93','4.56','1.36','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1435,6,'Czech Republic','Чехия','CZ','20.00','0.88','0.30','35.00','CZK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1436,6,'Czech Republic','Чехия','CZ','50.00','2.20','0.77','35.00','CZK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1437,6,'Czech Republic','Чехия','CZ','99.00','4.36','1.52','35.00','CZK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1438,6,'Germany','Германия','DE','0.99','1.10','0.44','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1439,6,'Germany','Германия','DE','1.99','2.22','0.88','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1440,6,'Germany','Германия','DE','2.99','3.34','1.33','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1441,6,'Germany','Германия','DE','3.99','4.46','1.78','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1442,6,'Germany','Германия','DE','4.99','5.58','2.23','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1443,6,'Germany','Германия','DE','9.99','11.20','4.48','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1444,6,'Denmark','Дания','DK','5.00','0.71','0.28','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1445,6,'Denmark','Дания','DK','10.00','1.43','0.57','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1446,6,'Denmark','Дания','DK','15.00','2.15','0.86','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1447,6,'Denmark','Дания','DK','20.00','2.87','1.14','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1448,6,'Denmark','Дания','DK','30.00','4.31','1.72','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1449,6,'Denmark','Дания','DK','50.00','7.19','2.87','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1450,6,'Denmark','Дания','DK','60.00','8.63','3.45','40.00','DKK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1451,6,'Ecuador','Эквадор','EC','1.25','1.12','0.22','20.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1452,6,'Estonia','Эстония','EE','5.00','0.35','0.12','35.00','EEK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1453,6,'Estonia','Эстония','EE','10.00','0.71','0.24','35.00','EEK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1454,6,'Estonia','Эстония','EE','15.00','1.07','0.48','45.00','EEK',NULL,NULL,NULL,'2010-05-13 18:22:40'),(1455,6,'Estonia','Эстония','EE','25.00','1.78','0.80','45.00','EEK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1456,6,'Estonia','Эстония','EE','39.00','2.78','1.25','45.00','EEK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1457,6,'Estonia','Эстония','EE','50.00','3.56','1.60','45.00','EEK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1458,6,'Egypt','Египет','EG','5.00','0.90','0.18','20.00','EGP',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1459,6,'Spain','Испания','ES','0.90','1.20','0.42','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1460,6,'Spain','Испания','ES','2.00','2.66','1.06','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1461,6,'Spain','Испания','ES','3.00','4.00','1.60','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1462,6,'Spain','Испания','ES','4.00','5.33','2.13','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1463,6,'Spain','Испания','ES','5.00','6.66','2.66','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1464,6,'Spain','Испания','ES','6.00','8.00','3.20','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1465,6,'Finland','Финляндия','FI','1.30','1.42','0.56','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1466,6,'Finland','Финляндия','FI','2.50','2.73','1.09','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1467,6,'Finland','Финляндия','FI','3.00','3.28','1.31','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1468,6,'Finland','Финляндия','FI','5.00','5.46','2.18','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1469,6,'Finland','Финляндия','FI','10.00','10.93','4.37','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1470,6,'France','Франция','FR','0.50','0.56','0.22','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1471,6,'France','Франция','FR','1.50','1.66','0.66','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1472,6,'France','Франция','FR','3.00','3.34','1.33','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1473,6,'Georgia','Грузия','GE','1.00','0.48','0.19','40.00','GEL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1474,6,'Georgia','Грузия','GE','2.00','0.96','0.38','40.00','GEL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1475,6,'Georgia','Грузия','GE','4.30','2.08','0.83','40.00','GEL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1476,6,'Georgia','Грузия','GE','5.00','2.42','0.96','40.00','GEL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1477,6,'Greece','Греция','GR','0.30','0.33','0.08','25.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1478,6,'Greece','Греция','GR','0.61','0.66','0.16','25.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1479,6,'Greece','Греция','GR','1.21','1.33','0.33','25.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1480,6,'Greece','Греция','GR','3.56','3.92','1.17','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1481,6,'Hong Kong','Гонконг','HK','30.00','3.87','1.16','30.00','HKD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1482,6,'Croatia','Хорватия','HR','1.22','0.18','0.03','20.00','HRK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1483,6,'Croatia','Хорватия','HR','3.66','0.54','0.21','40.00','HRK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1484,6,'Croatia','Хорватия','HR','6.10','0.91','0.36','40.00','HRK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1485,6,'Hungary','Венгрия','HU','200.00','1.01','0.35','35.00','HUF',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1486,6,'Hungary','Венгрия','HU','600.00','3.04','1.21','40.00','HUF',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1487,6,'Hungary','Венгрия','HU','1600.00','8.11','3.24','40.00','HUF',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1488,6,'Israel','Израиль','IL','0.50','0.11','0.01','17.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1489,6,'Israel','Израиль','IL','1.00','0.23','0.05','24.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1490,6,'Israel','Израиль','IL','2.00','0.46','0.13','29.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1491,6,'Israel','Израиль','IL','3.00','0.69','0.22','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1492,6,'Israel','Израиль','IL','4.00','0.92','0.30','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1493,6,'Israel','Израиль','IL','5.00','1.15','0.37','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1494,6,'Israel','Израиль','IL','6.00','1.38','0.45','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1495,6,'Israel','Израиль','IL','7.00','1.61','0.53','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1496,6,'Israel','Израиль','IL','8.00','1.84','0.60','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1497,6,'Israel','Израиль','IL','10.00','2.30','0.75','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1498,6,'Israel','Израиль','IL','11.00','2.53','0.83','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1499,6,'Israel','Израиль','IL','12.00','2.76','0.91','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1500,6,'Israel','Израиль','IL','15.00','3.46','1.14','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1501,6,'Israel','Израиль','IL','18.00','4.15','1.36','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1502,6,'Israel','Израиль','IL','20.00','4.61','1.52','33.00','Sheqel',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1503,6,'India','Индия','IN','20.00','0.43','0.06','15.00','INR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1504,6,'India','Индия','IN','30.00','0.64','0.09','15.00','INR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1505,6,'India','Индия','IN','50.00','1.07','0.16','15.00','INR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1506,6,'India','Индия','IN','99.00','2.13','0.31','15.00','INR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1507,6,'Jordan','Иордания','JO','0.90','0.71','0.21','30.00','JOD','orange','Orange','Orange','2010-05-13 18:22:41'),(1508,6,'Jordan','Иордания','JO','0.90','0.71','0.21','30.00','JOD','umniah','Umniah','Umniah','2010-05-13 18:22:41'),(1509,6,'Kyrgyzstan','Киргизия','KG','1.00','1.00','0.25','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1510,6,'Kyrgyzstan','Киргизия','KG','3.00','3.00','0.75','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1511,6,'Cambodia','Камбоджа','KH','0.99','0.90','0.22','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1512,6,'Cambodia','Камбоджа','KH','1.39','1.26','0.31','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1513,6,'Cambodia','Камбоджа','KH','1.99','1.81','0.45','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1514,6,'Cambodia','Камбоджа','KH','2.99','2.72','0.68','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1515,6,'Kazakhstan','Казахстан','KZ','950.00','5.78','1.73','30.00','KZT','altel','Dalacom','Dalacom','2010-05-13 18:22:41'),(1516,6,'Kazakhstan','Казахстан','KZ','375.00','2.28','0.91','40.00','KZT','altel','Dalacom','Dalacom','2010-05-13 18:22:41'),(1517,6,'Kazakhstan','Казахстан','KZ','170.00','1.03','0.41','40.00','KZT','altel','Dalacom','Dalacom','2010-05-13 18:22:41'),(1518,6,'Kazakhstan','Казахстан','KZ','535.00','3.25','1.30','40.00','KZT','beeline','Beeline','Beeline','2010-05-13 18:22:41'),(1519,6,'Kazakhstan','Казахстан','KZ','375.00','2.28','0.91','40.00','KZT','beeline','Beeline','Beeline','2010-05-13 18:22:41'),(1520,6,'Kazakhstan','Казахстан','KZ','170.00','1.03','0.41','40.00','KZT','beeline','Beeline','Beeline','2010-05-13 18:22:41'),(1521,6,'Kazakhstan','Казахстан','KZ','75.00','0.45','0.11','25.00','KZT','beeline','Beeline','Beeline','2010-05-13 18:22:41'),(1522,6,'Kazakhstan','Казахстан','KZ','700.00','4.26','1.70','40.00','KZT','kcell','Kcell','Kcell','2010-05-13 18:22:41'),(1523,6,'Kazakhstan','Казахстан','KZ','535.00','3.25','0.81','25.00','KZT','kcell','Kcell','Kcell','2010-05-13 18:22:41'),(1524,6,'Kazakhstan','Казахстан','KZ','170.00','1.03','0.25','25.00','KZT','kcell','Kcell','Kcell','2010-05-13 18:22:41'),(1525,6,'Kazakhstan','Казахстан','KZ','75.00','0.45','0.11','25.00','KZT','kcell','Kcell','Kcell','2010-05-13 18:22:41'),(1526,6,'Kazakhstan','Казахстан','KZ','700.00','4.26','1.70','40.00','KZT','mobiletelecomservice','Mobile Telecom Service','Mobile Telecom Service','2010-05-13 18:22:41'),(1527,6,'Kazakhstan','Казахстан','KZ','535.00','3.25','0.81','25.00','KZT','mobiletelecomservice','Mobile Telecom Service','Mobile Telecom Service','2010-05-13 18:22:41'),(1528,6,'Kazakhstan','Казахстан','KZ','170.00','1.03','0.25','25.00','KZT','mobiletelecomservice','Mobile Telecom Service','Mobile Telecom Service','2010-05-13 18:22:41'),(1529,6,'Kazakhstan','Казахстан','KZ','75.00','0.45','0.11','25.00','KZT','mobiletelecomservice','Mobile Telecom Service','Mobile Telecom Service','2010-05-13 18:22:41'),(1530,6,'Lebanon','Ливан','LB','0.90','0.81','0.20','25.00','USD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1531,6,'Lithuania','Литва','LT','0.51','0.16','0.05','35.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1532,6,'Lithuania','Литва','LT','1.02','0.32','0.11','35.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1533,6,'Lithuania','Литва','LT','2.03','0.65','0.22','35.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1534,6,'Lithuania','Литва','LT','3.05','0.97','0.43','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1535,6,'Lithuania','Литва','LT','4.07','1.30','0.58','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1536,6,'Lithuania','Литва','LT','5.08','1.62','0.72','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1537,6,'Lithuania','Литва','LT','6.10','1.95','0.68','35.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1538,6,'Lithuania','Литва','LT','7.11','2.27','1.02','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1539,6,'Lithuania','Литва','LT','8.13','2.60','1.17','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1540,6,'Lithuania','Литва','LT','9.15','2.93','1.31','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1541,6,'Lithuania','Литва','LT','10.16','3.25','1.46','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1542,6,'Lithuania','Литва','LT','15.26','4.88','2.19','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1543,6,'Lithuania','Литва','LT','20.34','6.51','2.92','45.00','LTL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1544,6,'Luxembourg','Люксембург','LU','1.50','1.73','0.60','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1545,6,'Latvia','Латвия','LV','0.25','0.39','0.15','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1546,6,'Latvia','Латвия','LV','0.50','0.77','0.30','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1547,6,'Latvia','Латвия','LV','1.00','1.56','0.62','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1548,6,'Latvia','Латвия','LV','1.50','2.33','0.93','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1549,6,'Latvia','Латвия','LV','2.00','3.11','1.24','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1550,6,'Latvia','Латвия','LV','2.50','3.90','1.56','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1551,6,'Latvia','Латвия','LV','3.00','4.67','1.86','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1552,6,'Latvia','Латвия','LV','4.00','6.24','2.49','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1553,6,'Latvia','Латвия','LV','5.00','7.79','3.11','40.00','LVL',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1554,6,'Montenegro','Черногория','ME','0.60','0.68','0.23','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1555,6,'Macedonia','Македония','MK','59.00','1.11','0.38','35.00','MKD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1556,6,'Macedonia','Македония','MK','106.20','2.00','0.70','35.00','MKD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1557,6,'Mexico','Мексика','MX','15.00','1.06','0.21','20.00','MXN','telcel','TELCEL','TELCEL','2010-05-13 18:22:41'),(1558,6,'Mexico','Мексика','MX','15.00','1.06','0.21','20.00','MXN','iusacell','IUSACELL','IUSACELL','2010-05-13 18:22:41'),(1559,6,'Mexico','Мексика','MX','15.00','1.06','0.21','20.00','MXN','movistar','MOVISTAR','MOVISTAR','2010-05-13 18:22:41'),(1560,6,'Malaysia','Малайзия','MY','10.00','3.12','0.78','25.00','MYR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1561,6,'Nigeria','Нигерия','NG','100.00','0.66','0.09','15.00','NGN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1562,6,'Netherlands','Нидерланды','NL','0.55','0.61','0.18','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1563,6,'Netherlands','Нидерланды','NL','1.50','1.68','0.67','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1564,6,'Norway','Норвегия','NO','10.00','1.35','0.54','40.00','NOK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1565,6,'Norway','Норвегия','NO','30.00','4.06','1.62','40.00','NOK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1566,6,'Norway','Норвегия','NO','50.00','6.77','2.70','40.00','NOK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1567,6,'Norway','Норвегия','NO','60.00','8.13','3.25','40.00','NOK',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1568,6,'Peru','Перу','PE','5.00','1.47','0.29','20.00','PEN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1569,6,'Poland','Польша','PL','2.00','0.69','0.17','25.00','PLN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1570,6,'Poland','Польша','PL','4.00','1.38','0.37','27.00','PLN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1571,6,'Poland','Польша','PL','6.00','2.07','0.55','27.00','PLN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1572,6,'Poland','Польша','PL','9.00','3.11','0.93','30.00','PLN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1573,6,'Poland','Польша','PL','19.00','6.57','2.29','35.00','PLN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1574,6,'Poland','Польша','PL','25.00','8.65','3.02','35.00','PLN',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1575,6,'Portugal','Португалия','PT','0.72','0.80','0.20','25.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1576,6,'Portugal','Португалия','PT','1.00','1.09','0.32','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1577,6,'Portugal','Португалия','PT','2.00','2.20','0.77','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1578,6,'Portugal','Португалия','PT','4.00','4.40','1.54','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1579,6,'Qatar','Катар','QA','8.00','2.19','0.54','25.00','QAR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1580,6,'Romania','Румыния','RO','0.70','0.93','0.27','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1581,6,'Romania','Румыния','RO','1.50','2.00','0.70','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1582,6,'Romania','Румыния','RO','2.00','2.66','0.93','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1583,6,'Romania','Румыния','RO','3.00','4.00','1.40','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1584,6,'Romania','Румыния','RO','5.00','6.66','2.33','35.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1585,6,'Serbia','Сербия','RS','29.50','0.36','0.10','30.00','RSD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1586,6,'Serbia','Сербия','RS','128.00','1.46','0.51','35.00','RSD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1587,6,'Serbia','Сербия','RS','354.00','4.04','1.41','35.00','RSD',NULL,NULL,NULL,'2010-05-13 18:22:41'),(1588,6,'Russia','Россия','RU','254.24','7.94','4.81','60.69','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1589,6,'Russia','Россия','RU','144.07','4.50','2.73','60.80','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1590,6,'Russia','Россия','RU','84.75','2.64','1.61','61.31','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1591,6,'Russia','Россия','RU','59.32','1.85','1.13','61.58','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1592,6,'Russia','Россия','RU','37.29','1.16','0.65','56.68','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1593,6,'Russia','Россия','RU','29.66','0.92','0.52','57.40','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1594,6,'Russia','Россия','RU','16.95','0.52','0.30','57.71','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1595,6,'Russia','Россия','RU','8.48','0.26','0.14','53.96','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1596,6,'Russia','Россия','RU','4.24','0.13','0.05','42.17','рубль','beeline','Beeline','Билайн','2010-05-13 18:22:41'),(1597,6,'Russia','Россия','RU','300.00','9.37','4.15','44.33','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1598,6,'Russia','Россия','RU','169.49','5.29','2.33','44.20','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1599,6,'Russia','Россия','RU','90.00','2.81','1.26','45.00','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1600,6,'Russia','Россия','RU','60.00','1.87','0.84','45.00','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1601,6,'Russia','Россия','RU','39.00','1.21','0.54','45.00','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1602,6,'Russia','Россия','RU','30.00','0.93','0.46','50.00','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1603,6,'Russia','Россия','RU','18.00','0.56','0.28','50.56','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1604,6,'Russia','Россия','RU','10.00','0.31','0.17','55.00','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1605,6,'Russia','Россия','RU','5.00','0.15','0.05','37.00','рубль','megafon','Megafon','МегаФон','2010-05-13 18:22:41'),(1606,6,'Russia','Россия','RU','258.30','8.07','4.52','56.08','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1607,6,'Russia','Россия','RU','172.20','5.38','2.94','54.81','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1608,6,'Russia','Россия','RU','85.81','2.68','1.56','58.40','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1609,6,'Russia','Россия','RU','54.53','1.70','0.98','58.08','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1610,6,'Russia','Россия','RU','37.31','1.16','0.62','53.97','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1611,6,'Russia','Россия','RU','28.41','0.88','0.50','56.95','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1612,6,'Russia','Россия','RU','17.22','0.53','0.26','50.17','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1613,6,'Russia','Россия','RU','8.61','0.26','0.11','45.00','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1614,6,'Russia','Россия','RU','4.31','0.13','0.05','45.00','рубль','mts','MTS','МТС','2010-05-13 18:22:41'),(1615,6,'Russia','Россия','RU','300.00','9.37','3.56','38.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1616,6,'Russia','Россия','RU','169.49','5.29','2.01','38.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1617,6,'Russia','Россия','RU','90.80','2.83','1.41','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1618,6,'Russia','Россия','RU','60.60','1.89','0.94','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1619,6,'Russia','Россия','RU','39.40','1.23','0.61','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1620,6,'Russia','Россия','RU','27.39','0.85','0.42','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1621,6,'Russia','Россия','RU','18.20','0.56','0.28','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1622,6,'Russia','Россия','RU','9.10','0.28','0.14','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:41'),(1623,6,'Russia','Россия','RU','4.50','0.14','0.07','50.00','рубль','akos','Akos','АКОС','2010-05-13 18:22:42'),(1624,6,'Russia','Россия','RU','300.00','9.37','3.74','40.00','рубль','altaysvyaz','AltaySvyaz','АлтайСвязь','2010-05-13 18:22:42'),(1625,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','altaysvyaz','AltaySvyaz','АлтайСвязь','2010-05-13 18:22:42'),(1626,6,'Russia','Россия','RU','90.00','2.81','1.12','40.00','рубль','altaysvyaz','AltaySvyaz','АлтайСвязь','2010-05-13 18:22:42'),(1627,6,'Russia','Россия','RU','60.00','1.87','0.74','40.00','рубль','altaysvyaz','AltaySvyaz','АлтайСвязь','2010-05-13 18:22:42'),(1628,6,'Russia','Россия','RU','30.00','0.93','0.37','40.00','рубль','altaysvyaz','AltaySvyaz','АлтайСвязь','2010-05-13 18:22:42'),(1629,6,'Russia','Россия','RU','300.00','9.37','3.09','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1630,6,'Russia','Россия','RU','169.49','5.29','1.74','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1631,6,'Russia','Россия','RU','81.36','2.54','0.83','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1632,6,'Russia','Россия','RU','55.09','1.72','0.56','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1633,6,'Russia','Россия','RU','38.98','1.21','0.39','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1634,6,'Russia','Россия','RU','22.12','0.69','0.22','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1635,6,'Russia','Россия','RU','16.95','0.52','0.17','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1636,6,'Russia','Россия','RU','8.47','0.26','0.08','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1637,6,'Russia','Россия','RU','4.24','0.13','0.04','33.00','рубль','astragsm','Astrahan GSM','Астрахань GSM','2010-05-13 18:22:42'),(1638,6,'Russia','Россия','RU','169.50','5.29','2.38','45.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1639,6,'Russia','Россия','RU','169.00','5.28','2.37','45.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1640,6,'Russia','Россия','RU','89.00','2.78','1.39','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1641,6,'Russia','Россия','RU','59.00','1.84','0.92','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1642,6,'Russia','Россия','RU','39.00','1.21','0.60','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1643,6,'Russia','Россия','RU','29.00','0.90','0.45','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1644,6,'Russia','Россия','RU','19.00','0.59','0.29','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1645,6,'Russia','Россия','RU','10.00','0.31','0.15','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1646,6,'Russia','Россия','RU','5.00','0.15','0.07','50.00','рубль','baikalwestcom','BaicalWestCom','БайкалВестКом','2010-05-13 18:22:42'),(1647,6,'Russia','Россия','RU','144.07','4.50','2.02','45.00','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1648,6,'Russia','Россия','RU','88.98','2.78','1.25','45.00','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1649,6,'Russia','Россия','RU','59.32','1.85','0.83','45.00','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1650,6,'Russia','Россия','RU','38.14','1.19','0.53','45.00','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1651,6,'Russia','Россия','RU','29.66','0.92','0.41','45.00','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1652,6,'Russia','Россия','RU','16.95','0.52','0.23','44.97','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1653,6,'Russia','Россия','RU','8.47','0.26','0.11','45.06','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1654,6,'Russia','Россия','RU','4.66','0.14','0.06','45.00','рубль','bashsel','BashSEL','BashSEL','2010-05-13 18:22:42'),(1655,6,'Russia','Россия','RU','300.00','9.37','3.74','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1656,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1657,6,'Russia','Россия','RU','90.00','2.81','1.12','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1658,6,'Russia','Россия','RU','60.00','1.87','0.74','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1659,6,'Russia','Россия','RU','39.00','1.21','0.48','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1660,6,'Russia','Россия','RU','30.00','0.93','0.37','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1661,6,'Russia','Россия','RU','18.00','0.56','0.22','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1662,6,'Russia','Россия','RU','9.00','0.28','0.11','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1663,6,'Russia','Россия','RU','4.50','0.14','0.05','40.00','рубль','enisey','Enisey Telecom','Енисейтелеком','2010-05-13 18:22:42'),(1664,6,'Russia','Россия','RU','39.00','1.21','0.54','45.00','рубль','mobilphone','MobilPhone','Мобилфон','2010-05-13 18:22:42'),(1665,6,'Russia','Россия','RU','254.24','7.94','3.17','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1666,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1667,6,'Russia','Россия','RU','90.00','2.81','1.12','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1668,6,'Russia','Россия','RU','60.00','1.87','0.74','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1669,6,'Russia','Россия','RU','38.98','1.21','0.60','50.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1670,6,'Russia','Россия','RU','30.00','0.93','0.37','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1671,6,'Russia','Россия','RU','17.22','0.53','0.21','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1672,6,'Russia','Россия','RU','9.00','0.28','0.11','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1673,6,'Russia','Россия','RU','4.50','0.14','0.05','40.00','рубль','motiv','MOTIV','МОТИВ','2010-05-13 18:22:42'),(1674,6,'Russia','Россия','RU','254.24','7.94','3.17','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1675,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1676,6,'Russia','Россия','RU','90.68','2.83','1.13','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1677,6,'Russia','Россия','RU','60.17','1.88','0.75','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1678,6,'Russia','Россия','RU','38.98','1.21','0.48','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1679,6,'Russia','Россия','RU','29.70','0.92','0.36','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1680,6,'Russia','Россия','RU','18.64','0.58','0.23','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1681,6,'Russia','Россия','RU','9.32','0.29','0.11','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1682,6,'Russia','Россия','RU','4.49','0.14','0.05','40.00','рубль','nss_chuvashia','NSS Chuvashiya','НСС Чувашия','2010-05-13 18:22:42'),(1683,6,'Russia','Россия','RU','254.24','7.94','3.17','40.00','рубль','nss_mordovia','NSS Mordovia','НСС Мордовия','2010-05-13 18:22:42'),(1684,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','nss_mordovia','NSS Mordovia','НСС Мордовия','2010-05-13 18:22:42'),(1685,6,'Russia','Россия','RU','84.36','2.63','1.05','40.00','рубль','nss_mordovia','NSS Mordovia','НСС Мордовия','2010-05-13 18:22:42'),(1686,6,'Russia','Россия','RU','56.24','1.75','0.57','32.77','рубль','nss_mordovia','NSS Mordovia','НСС Мордовия','2010-05-13 18:22:42'),(1687,6,'Russia','Россия','RU','254.24','7.94','3.17','40.00','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1688,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1689,6,'Russia','Россия','RU','84.36','2.63','1.05','40.00','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1690,6,'Russia','Россия','RU','56.24','1.75','0.57','32.77','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1691,6,'Russia','Россия','RU','36.56','1.14','0.37','32.60','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1692,6,'Russia','Россия','RU','27.84','0.87','0.28','32.54','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1693,6,'Russia','Россия','RU','16.68','0.52','0.20','40.00','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1694,6,'Russia','Россия','RU','8.43','0.26','0.10','40.00','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1695,6,'Russia','Россия','RU','4.22','0.13','0.05','40.00','рубль','nss_nn','NCC Nizhniy Novgorod','НСС Нижний Новгород','2010-05-13 18:22:42'),(1696,6,'Russia','Россия','RU','254.24','7.94','3.17','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1697,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1698,6,'Russia','Россия','RU','89.83','2.80','1.12','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1699,6,'Russia','Россия','RU','60.17','1.88','0.75','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1700,6,'Russia','Россия','RU','38.98','1.21','0.48','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1701,6,'Russia','Россия','RU','27.12','0.84','0.33','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1702,6,'Russia','Россия','RU','18.64','0.58','0.23','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1703,6,'Russia','Россия','RU','9.32','0.29','0.11','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1704,6,'Russia','Россия','RU','4.49','0.14','0.05','40.00','рубль','nss_pm','NSS-PM','НСС-РМ','2010-05-13 18:22:42'),(1705,6,'Russia','Россия','RU','254.23','7.94','3.57','45.00','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1706,6,'Russia','Россия','RU','169.49','5.29','2.29','43.38','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1707,6,'Russia','Россия','RU','90.00','2.81','1.27','45.26','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1708,6,'Russia','Россия','RU','60.00','1.87','0.86','45.99','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1709,6,'Russia','Россия','RU','39.00','1.21','0.42','34.74','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1710,6,'Russia','Россия','RU','29.70','0.92','0.41','45.05','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1711,6,'Russia','Россия','RU','18.00','0.56','0.25','45.37','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1712,6,'Russia','Россия','RU','9.00','0.28','0.12','45.34','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1713,6,'Russia','Россия','RU','4.50','0.14','0.06','46.11','рубль','nss_saratov','NSS Saratov','НСС Саратов','2010-05-13 18:22:42'),(1714,6,'Russia','Россия','RU','260.00','8.12','3.32','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1715,6,'Russia','Россия','RU','169.00','5.28','2.16','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1716,6,'Russia','Россия','RU','86.71','2.70','1.10','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1717,6,'Russia','Россия','RU','58.00','1.81','0.74','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1718,6,'Russia','Россия','RU','37.70','1.17','0.47','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1719,6,'Russia','Россия','RU','28.71','0.89','0.36','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1720,6,'Russia','Россия','RU','17.40','0.54','0.22','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1721,6,'Russia','Россия','RU','8.70','0.27','0.11','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1722,6,'Russia','Россия','RU','4.35','0.13','0.05','41.00','рубль','ntk','NTK','НТК','2010-05-13 18:22:42'),(1723,6,'Russia','Россия','RU','300.00','9.37','4.68','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1724,6,'Russia','Россия','RU','169.49','5.29','2.64','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1725,6,'Russia','Россия','RU','89.83','2.80','1.40','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1726,6,'Russia','Россия','RU','60.17','1.88','0.94','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1727,6,'Russia','Россия','RU','38.98','1.21','0.60','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1728,6,'Russia','Россия','RU','29.00','0.90','0.45','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1729,6,'Russia','Россия','RU','18.64','0.58','0.29','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1730,6,'Russia','Россия','RU','9.32','0.29','0.14','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1731,6,'Russia','Россия','RU','4.49','0.14','0.07','50.00','рубль','orenburggsm','Orenburg-GSM','Оренбург-GSM','2010-05-13 18:22:42'),(1732,6,'Russia','Россия','RU','296.61','9.26','2.96','32.00','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1733,6,'Russia','Россия','RU','169.49','5.29','1.69','32.00','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1734,6,'Russia','Россия','RU','81.36','2.54','0.81','32.00','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1735,6,'Russia','Россия','RU','55.08','1.72','0.55','32.00','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1736,6,'Russia','Россия','RU','38.98','1.21','0.42','34.76','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1737,6,'Russia','Россия','RU','27.12','0.84','0.28','33.73','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1738,6,'Russia','Россия','RU','16.95','0.52','0.17','32.74','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1739,6,'Russia','Россия','RU','9.32','0.29','0.07','27.17','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1740,6,'Russia','Россия','RU','4.24','0.13','0.02','18.60','рубль','penzagsm','Penza-GSM','Пенза-GSM','2010-05-13 18:22:42'),(1741,6,'Russia','Россия','RU','296.61','9.26','3.05','33.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1742,6,'Russia','Россия','RU','169.49','5.29','1.74','33.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1743,6,'Russia','Россия','RU','90.68','2.83','1.13','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1744,6,'Russia','Россия','RU','60.17','1.88','0.75','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1745,6,'Russia','Россия','RU','38.98','1.21','0.48','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1746,6,'Russia','Россия','RU','29.00','0.90','0.36','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1747,6,'Russia','Россия','RU','18.64','0.58','0.23','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1748,6,'Russia','Россия','RU','9.32','0.29','0.11','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1749,6,'Russia','Россия','RU','4.49','0.14','0.05','40.00','рубль','shupashkargsm','Shupashkar-GSM','Шупашкар-GSM','2010-05-13 18:22:42'),(1750,6,'Russia','Россия','RU','300.00','9.37','3.74','40.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1751,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1752,6,'Russia','Россия','RU','89.83','2.80','1.40','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1753,6,'Russia','Россия','RU','59.32','1.85','0.92','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1754,6,'Russia','Россия','RU','38.98','1.21','0.60','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1755,6,'Russia','Россия','RU','29.00','0.90','0.45','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1756,6,'Russia','Россия','RU','18.64','0.58','0.29','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1757,6,'Russia','Россия','RU','10.17','0.31','0.15','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1758,6,'Russia','Россия','RU','4.49','0.14','0.07','50.00','рубль','sibirtelecom','STeK GSM','СТеК GSM','2010-05-13 18:22:42'),(1759,6,'Russia','Россия','RU','300.00','9.37','4.02','43.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1760,6,'Russia','Россия','RU','169.49','5.29','2.27','43.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1761,6,'Russia','Россия','RU','90.00','2.81','1.40','50.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1762,6,'Russia','Россия','RU','50.00','1.56','0.78','50.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1763,6,'Russia','Россия','RU','24.17','0.75','0.37','50.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1764,6,'Russia','Россия','RU','15.83','0.49','0.24','50.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1765,6,'Russia','Россия','RU','8.33','0.26','0.13','50.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1766,6,'Russia','Россия','RU','4.17','0.13','0.06','50.00','рубль','skylink','SkyLink','SkyLink','2010-05-13 18:22:42'),(1767,6,'Russia','Россия','RU','296.61','9.26','2.96','32.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:42'),(1768,6,'Russia','Россия','RU','169.49','5.29','1.69','32.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:42'),(1769,6,'Russia','Россия','RU','81.36','2.54','1.01','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:42'),(1770,6,'Russia','Россия','RU','55.08','1.72','0.68','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:42'),(1771,6,'Russia','Россия','RU','50.85','1.58','0.63','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:42'),(1772,6,'Russia','Россия','RU','27.12','0.84','0.33','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:43'),(1773,6,'Russia','Россия','RU','16.95','0.52','0.20','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:43'),(1774,6,'Russia','Россия','RU','8.47','0.26','0.10','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:43'),(1775,6,'Russia','Россия','RU','4.24','0.13','0.05','40.00','рубль','smarts','SMARTS','SMARTS','2010-05-13 18:22:43'),(1776,6,'Russia','Россия','RU','254.24','7.94','3.17','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1777,6,'Russia','Россия','RU','169.49','5.29','2.11','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1778,6,'Russia','Россия','RU','84.36','2.63','1.05','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1779,6,'Russia','Россия','RU','60.17','1.88','0.75','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1780,6,'Russia','Россия','RU','38.98','1.21','0.48','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1781,6,'Russia','Россия','RU','27.12','0.84','0.33','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1782,6,'Russia','Россия','RU','17.80','0.55','0.22','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1783,6,'Russia','Россия','RU','9.32','0.29','0.11','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1784,6,'Russia','Россия','RU','4.49','0.14','0.05','40.00','рубль','tatinkom','TATINKOM-T','ТАТИНКОМ-Т','2010-05-13 18:22:43'),(1785,6,'Russia','Россия','RU','211.86','6.62','3.23','48.93','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1786,6,'Russia','Россия','RU','169.00','5.28','2.63','49.84','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1787,6,'Russia','Россия','RU','85.81','2.68','1.33','49.69','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1788,6,'Russia','Россия','RU','57.11','1.78','0.88','49.61','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1789,6,'Russia','Россия','RU','29.85','0.93','0.45','48.60','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1790,6,'Russia','Россия','RU','28.41','0.88','0.43','49.06','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1791,6,'Russia','Россия','RU','17.22','0.53','0.26','49.49','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1792,6,'Russia','Россия','RU','8.61','0.26','0.12','48.91','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1793,6,'Russia','Россия','RU','4.31','0.13','0.05','43.04','рубль','tele2','Tele2','Теле2','2010-05-13 18:22:43'),(1794,6,'Russia','Россия','RU','260.00','8.12','3.24','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1795,6,'Russia','Россия','RU','170.00','5.31','2.12','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1796,6,'Russia','Россия','RU','90.68','2.83','1.13','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1797,6,'Russia','Россия','RU','60.17','1.88','0.75','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1798,6,'Russia','Россия','RU','38.98','1.21','0.48','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1799,6,'Russia','Россия','RU','28.81','0.90','0.36','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1800,6,'Russia','Россия','RU','18.64','0.58','0.23','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1801,6,'Russia','Россия','RU','9.32','0.29','0.11','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1802,6,'Russia','Россия','RU','4.49','0.14','0.05','40.00','рубль','ulianovskgsm','Ulianovsk-GSM','Ульяновск-GSM','2010-05-13 18:22:43'),(1803,6,'Russia','Россия','RU','260.00','8.12','3.52','43.38','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1804,6,'Russia','Россия','RU','150.00','4.68','2.02','43.33','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1805,6,'Russia','Россия','RU','90.00','2.81','1.21','43.14','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1806,6,'Russia','Россия','RU','60.00','1.87','0.80','43.00','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1807,6,'Russia','Россия','RU','39.00','1.21','0.51','42.44','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1808,6,'Russia','Россия','RU','21.00','0.65','0.24','38.33','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1809,6,'Russia','Россия','RU','9.00','0.28','0.09','32.78','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1810,6,'Russia','Россия','RU','4.50','0.14','0.02','17.22','рубль','uralsvyasinform','Uralsviazinform','Уралсвязьинформ','2010-05-13 18:22:43'),(1811,6,'Russia','Россия','RU','300.00','9.37','3.74','40.00','рубль','uuss','UUSS','УУСС','2010-05-13 18:22:43'),(1812,6,'Russia','Россия','RU','169.24','5.28','2.11','40.00','рубль','uuss','UUSS','УУСС','2010-05-13 18:22:43'),(1813,6,'Russia','Россия','RU','90.00','2.81','1.12','40.00','рубль','uuss','UUSS','УУСС','2010-05-13 18:22:43'),(1814,6,'Russia','Россия','RU','60.00','1.87','0.74','40.00','рубль','uuss','UUSS','УУСС','2010-05-13 18:22:43'),(1815,6,'Russia','Россия','RU','30.00','0.93','0.37','40.00','рубль','uuss','UUSS','УУСС','2010-05-13 18:22:43'),(1816,6,'Russia','Россия','RU','300.00','9.37','3.74','40.00','рубль','volgatelecom','VolgaTelecom','ВолгаТелеком','2010-05-13 18:22:43'),(1817,6,'Russia','Россия','RU','169.24','5.28','2.11','40.00','рубль','volgatelecom','VolgaTelecom','ВолгаТелеком','2010-05-13 18:22:43'),(1818,6,'Russia','Россия','RU','90.00','2.81','1.12','40.00','рубль','volgatelecom','VolgaTelecom','ВолгаТелеком','2010-05-13 18:22:43'),(1819,6,'Russia','Россия','RU','60.00','1.87','0.74','40.00','рубль','volgatelecom','VolgaTelecom','ВолгаТелеком','2010-05-13 18:22:43'),(1820,6,'Russia','Россия','RU','30.00','0.93','0.37','40.00','рубль','volgatelecom','VolgaTelecom','ВолгаТелеком','2010-05-13 18:22:43'),(1821,6,'Russia','Россия','RU','150.00','4.68','1.87','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1822,6,'Russia','Россия','RU','89.00','2.78','1.11','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1823,6,'Russia','Россия','RU','59.00','1.84','0.73','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1824,6,'Russia','Россия','RU','39.00','1.21','0.48','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1825,6,'Russia','Россия','RU','29.00','0.90','0.36','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1826,6,'Russia','Россия','RU','19.00','0.59','0.23','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1827,6,'Russia','Россия','RU','10.00','0.31','0.12','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1828,6,'Russia','Россия','RU','5.00','0.15','0.06','40.00','рубль','volgogradgsm','Volgograd GSM','Волгоград GSM','2010-05-13 18:22:43'),(1829,6,'Russia','Россия','RU','296.61','9.26','2.96','32.00','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1830,6,'Russia','Россия','RU','169.49','5.29','1.69','32.00','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1831,6,'Russia','Россия','RU','89.83','2.80','0.76','27.15','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1832,6,'Russia','Россия','RU','58.47','1.82','0.60','33.44','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1833,6,'Russia','Россия','RU','38.14','1.19','0.42','35.64','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1834,6,'Russia','Россия','RU','28.81','0.90','0.34','38.52','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1835,6,'Russia','Россия','RU','18.64','0.58','0.20','35.80','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1836,6,'Russia','Россия','RU','10.17','0.31','0.09','31.98','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1837,6,'Russia','Россия','RU','5.08','0.15','0.05','34.33','рубль','yaroslavlgsm','Yaroslavl-GSM','Ярославль-GSM','2010-05-13 18:22:43'),(1838,6,'KSA','Саудовская Аравия','SA','5.00','1.33','0.33','25.00','SAR','stc','STC','STC','2010-05-13 18:22:43'),(1839,6,'KSA','Саудовская Аравия','SA','5.00','1.33','0.33','25.00','SAR','zain','Zain','Zain','2010-05-13 18:22:43'),(1840,6,'Sweden','Швеция','SE','10.00','1.11','0.44','40.00','SEK',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1841,6,'Sweden','Швеция','SE','30.00','3.34','1.16','35.00','SEK',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1842,6,'Sweden','Швеция','SE','30.00','3.34','1.33','40.00','SEK',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1843,6,'Sweden','Швеция','SE','50.00','5.57','2.22','40.00','SEK',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1844,6,'Sweden','Швеция','SE','80.00','8.92','3.56','40.00','SEK',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1845,6,'Slovenia','Словения','SI','2.49','2.77','1.10','40.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1846,6,'Slovakia','Словакия','SK','0.80','0.88','0.26','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1847,6,'Slovakia','Словакия','SK','1.59','1.77','0.53','30.00','EUR',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1848,6,'Taiwan','Тайвань','TW','50.00','1.51','0.45','30.00','TWD',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1849,6,'Ukraine','Украина','UA','1.00','0.10','0.01','10.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1850,6,'Ukraine','Украина','UA','2.00','0.21','0.04','20.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1851,6,'Ukraine','Украина','UA','3.80','0.39','0.07','20.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1852,6,'Ukraine','Украина','UA','8.00','0.84','0.33','40.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1853,6,'Ukraine','Украина','UA','12.00','1.26','0.50','40.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1854,6,'Ukraine','Украина','UA','16.00','1.68','0.65','39.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1855,6,'Ukraine','Украина','UA','30.00','3.15','1.26','40.00','UAH',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1856,6,'United Kingdom','Великобритания','UK','0.25','0.32','0.04','15.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1857,6,'United Kingdom','Великобритания','UK','0.50','0.66','0.19','30.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1858,6,'United Kingdom','Великобритания','UK','0.50','0.66','0.19','30.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1859,6,'United Kingdom','Великобритания','UK','1.00','1.30','0.45','35.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1860,6,'United Kingdom','Великобритания','UK','1.00','1.30','0.45','35.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1861,6,'United Kingdom','Великобритания','UK','1.50','1.96','0.78','40.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1862,6,'United Kingdom','Великобритания','UK','1.50','1.96','0.78','40.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1863,6,'United Kingdom','Великобритания','UK','5.00','6.55','2.94','45.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1864,6,'United Kingdom','Великобритания','UK','5.00','6.55','2.94','45.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1865,6,'United Kingdom','Великобритания','UK','10.00','13.09','5.89','45.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1866,6,'United Kingdom','Великобритания','UK','10.00','13.09','5.89','45.00','GBP',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1867,6,'Venezuela','Венесуэла','VE','3.10','0.66','0.09','15.00','VEF',NULL,NULL,NULL,'2010-05-13 18:22:43'),(1868,6,'South Africa','Южная Африка','ZA','30.00','4.04','1.61','40.00','ZAR',NULL,NULL,NULL,'2010-05-13 18:22:43');
/*!40000 ALTER TABLE `smscoin_cost_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smscoin_transactions`
--

DROP TABLE IF EXISTS `smscoin_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smscoin_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipient_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `donor_id` int(11) DEFAULT NULL,
  `karma_point_id` int(11) DEFAULT NULL,
  `state` varchar(255) NOT NULL,
  `return_url` varchar(255) NOT NULL,
  `monetary_donation_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `cost_option_dump` text,
  `content_type` varchar(255) DEFAULT NULL,
  `download` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smscoin_transactions`
--

LOCK TABLES `smscoin_transactions` WRITE;
/*!40000 ALTER TABLE `smscoin_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `smscoin_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smscoin_versions`
--

DROP TABLE IF EXISTS `smscoin_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smscoin_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `json` mediumtext,
  `created_at` datetime NOT NULL,
  `last_checked_at` datetime NOT NULL,
  `cached_data_digest` varchar(255) NOT NULL,
  `finished` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_smscoin_versions_on_finished` (`finished`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smscoin_versions`
--

LOCK TABLES `smscoin_versions` WRITE;
/*!40000 ALTER TABLE `smscoin_versions` DISABLE KEYS */;
INSERT INTO `smscoin_versions` VALUES (6,'[\n  {\n	\"country\" : \"AE\",\n	\"country_name\" : \"UAE\",\n	\"special\" : \"\",\n[{\n	\"code\" : \"du\",\n	\"name\" : \"DU\",\n	\"number\" : \"2420\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 2.72,\n	\"profit\" : 30,\n	\"vat\" : 0,\n	\"currency\" : \"AED\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"etisalat\",\n	\"name\" : \"Etisalat\",\n	\"number\" : \"2252\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 2.72,\n	\"profit\" : 30,\n	\"vat\" : 0,\n	\"currency\" : \"AED\",\n	\"special\" : \"\"\n}]\n},{\n	\"country\" : \"AL\",\n	\"country_name\" : \"Albania\",\n	\"number\" : \"15191\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 120.00,\n	\"usd\" : 0.96,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"ALL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AM\",\n	\"country_name\" : \"Armenia\",\n	\"number\" : \"5124\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 480.00,\n	\"usd\" : 1.01,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"AMD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AM\",\n	\"country_name\" : \"Armenia\",\n	\"number\" : \"5125\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1200.00,\n	\"usd\" : 2.53,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"AMD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AM\",\n	\"country_name\" : \"Armenia\",\n	\"number\" : \"5126\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2000.00,\n	\"usd\" : 4.23,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"AMD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AR\",\n	\"country_name\" : \"Argentina\",\n	\"number\" : \"22588\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.84,\n	\"usd\" : 1.03,\n	\"profit\" : 15.00,\n	\"vat\" : 1,\n	\"currency\" : \"ARS\",\n	\"special\" : \"Servicio disponible para Movistar. Costo por mensaje : ARS 4.84 IVA   incluido. Atención a cliente : support@smscoin.com\",\n[]\n},{\n	\"country\" : \"AT\",\n	\"country_name\" : \"Austria\",\n	\"number\" : \"0900333838\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.56,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AT\",\n	\"country_name\" : \"Austria\",\n	\"number\" : \"0900242240\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.99,\n	\"usd\" : 2.21,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AT\",\n	\"country_name\" : \"Austria\",\n	\"number\" : \"0930400880\",\n	\"prefix\" : \"530\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.99,\n	\"usd\" : 3.32,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AT\",\n	\"country_name\" : \"Austria\",\n	\"number\" : \"0930400880\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.99,\n	\"usd\" : 5.54,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AU\",\n	\"country_name\" : \"Australia\",\n	\"number\" : \"19995577\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 3.37,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"AUD\",\n	\"special\" : \"Price $4.00 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to 1300767306\",\n[]\n},{\n	\"country\" : \"AU\",\n	\"country_name\" : \"Australia\",\n	\"number\" : \"19911119\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 6.60,\n	\"usd\" : 5.55,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"AUD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"AZ\",\n	\"country_name\" : \"Azerbaijan\",\n	\"special\" : \"\",\n[{\n	\"code\" : \"azercell\",\n	\"name\" : \"Azercell\",\n	\"number\" : \"9525\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 5.22,\n	\"profit\" : 35,\n	\"vat\" : 1,\n	\"currency\" : \"AZN\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"azercell\",\n	\"name\" : \"Azercell\",\n	\"number\" : \"8797\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 1.04,\n	\"profit\" : 35,\n	\"vat\" : 1,\n	\"currency\" : \"AZN\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"azercell\",\n	\"name\" : \"Azercell\",\n	\"number\" : \"93101\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.51,\n	\"profit\" : 35,\n	\"vat\" : 1,\n	\"currency\" : \"AZN\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"azercell\",\n	\"name\" : \"Azercell\",\n	\"number\" : \"9426\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.10,\n	\"usd\" : 0.09,\n	\"profit\" : 35,\n	\"vat\" : 1,\n	\"currency\" : \"AZN\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"azerfon\",\n	\"name\" : \"Nar Mobile\",\n	\"number\" : \"3304\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 5.22,\n	\"profit\" : 35,\n	\"vat\" : 1,\n	\"currency\" : \"AZN\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bakcell\",\n	\"name\" : \"Bakcell\",\n	\"number\" : \"3304\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 5.22,\n	\"profit\" : 35,\n	\"vat\" : 1,\n	\"currency\" : \"AZN\",\n	\"special\" : \"\"\n}]\n},{\n	\"country\" : \"BA\",\n	\"country_name\" : \"Bosnia and Herzegovina\",\n	\"number\" : \"091410701\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.59,\n	\"usd\" : 0.34,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"BAM\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BA\",\n	\"country_name\" : \"Bosnia and Herzegovina\",\n	\"number\" : \"091610702\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.40,\n	\"usd\" : 0.82,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"BAM\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BA\",\n	\"country_name\" : \"Bosnia and Herzegovina\",\n	\"number\" : \"091710708\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.87,\n	\"usd\" : 1.09,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"BAM\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BA\",\n	\"country_name\" : \"Bosnia and Herzegovina\",\n	\"number\" : \"091810700\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.34,\n	\"usd\" : 1.36,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"BAM\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BE\",\n	\"country_name\" : \"Belgium\",\n	\"number\" : \"7233\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 2.20,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BE\",\n	\"country_name\" : \"Belgium\",\n	\"number\" : \"3907\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 3.30,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BE\",\n	\"country_name\" : \"Belgium\",\n	\"number\" : \"3331\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 4.41,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BG\",\n	\"country_name\" : \"Bulgaria\",\n	\"number\" : \"1855\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.60,\n	\"usd\" : 0.34,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"BGN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BG\",\n	\"country_name\" : \"Bulgaria\",\n	\"number\" : \"1915\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.20,\n	\"usd\" : 0.68,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"BGN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BG\",\n	\"country_name\" : \"Bulgaria\",\n	\"number\" : \"1916\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.40,\n	\"usd\" : 1.36,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"BGN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BG\",\n	\"country_name\" : \"Bulgaria\",\n	\"number\" : \"1816\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.80,\n	\"usd\" : 2.73,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"BGN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BO\",\n	\"country_name\" : \"Bolivia\",\n	\"number\" : \"636\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.85,\n	\"usd\" : 1.26,\n	\"profit\" : 15.00,\n	\"vat\" : 1,\n	\"currency\" : \"BOB\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BY\",\n	\"country_name\" : \"Belarus\",\n	\"number\" : \"3338\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2500.00,\n	\"usd\" : 0.84,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"BYR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BY\",\n	\"country_name\" : \"Belarus\",\n	\"number\" : \"3337\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5900.00,\n	\"usd\" : 1.98,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"BYR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"BY\",\n	\"country_name\" : \"Belarus\",\n	\"number\" : \"3336\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9900.00,\n	\"usd\" : 3.32,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"BYR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CH\",\n	\"country_name\" : \"Switzerland\",\n	\"number\" : \"543\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.42,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"CHF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CH\",\n	\"country_name\" : \"Switzerland\",\n	\"number\" : \"543\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 0.86,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"CHF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CH\",\n	\"country_name\" : \"Switzerland\",\n	\"number\" : \"543\",\n	\"prefix\" : \"520\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 1.73,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"CHF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CH\",\n	\"country_name\" : \"Switzerland\",\n	\"number\" : \"543\",\n	\"prefix\" : \"530\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 2.60,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"CHF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CH\",\n	\"country_name\" : \"Switzerland\",\n	\"number\" : \"543\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 4.34,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"CHF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CL\",\n	\"country_name\" : \"Chile\",\n	\"number\" : \"3113\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 750.00,\n	\"usd\" : 1.19,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"CLP\",\n	\"special\" : \"Servicio disponible para Movistar, Claro. Attencion a cliente: help@smscoin.com\",\n[]\n},{\n	\"country\" : \"CO\",\n	\"country_name\" : \"Colombia\",\n	\"number\" : \"3585\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3596.00,\n	\"usd\" : 1.59,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"COP\",\n	\"special\" : \"Servicio disponible para Comcel, Movistar y Tigo. Attencion a cliente: help@smscoin.com\",\n[]\n},{\n	\"country\" : \"CY\",\n	\"country_name\" : \"Cyprus\",\n	\"number\" : \"7500\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.93,\n	\"usd\" : 4.56,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"Cellular operator: &lt;b&gt;Cyta&lt;/b&gt;\",\n[]\n},{\n	\"country\" : \"CZ\",\n	\"country_name\" : \"Czech Republic\",\n	\"number\" : \"9033320\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 20.00,\n	\"usd\" : 0.88,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"CZK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CZ\",\n	\"country_name\" : \"Czech Republic\",\n	\"number\" : \"9033350\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 2.20,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"CZK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"CZ\",\n	\"country_name\" : \"Czech Republic\",\n	\"number\" : \"9033399\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 99.00,\n	\"usd\" : 4.36,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"CZK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DE\",\n	\"country_name\" : \"Germany\",\n	\"number\" : \"66777\",\n	\"prefix\" : \"501\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.99,\n	\"usd\" : 1.10,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DE\",\n	\"country_name\" : \"Germany\",\n	\"number\" : \"66777\",\n	\"prefix\" : \"502\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.99,\n	\"usd\" : 2.22,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DE\",\n	\"country_name\" : \"Germany\",\n	\"number\" : \"66777\",\n	\"prefix\" : \"503\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.99,\n	\"usd\" : 3.34,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DE\",\n	\"country_name\" : \"Germany\",\n	\"number\" : \"66777\",\n	\"prefix\" : \"504\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.99,\n	\"usd\" : 4.46,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DE\",\n	\"country_name\" : \"Germany\",\n	\"number\" : \"66777\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.99,\n	\"usd\" : 5.58,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DE\",\n	\"country_name\" : \"Germany\",\n	\"number\" : \"66777\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.99,\n	\"usd\" : 11.20,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1273\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 0.71,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1273\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 1.43,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1273\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.00,\n	\"usd\" : 2.15,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1273\",\n	\"prefix\" : \"520\",\n	\"rewrite\" : \"\",\n	\"price\" : 20.00,\n	\"usd\" : 2.87,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1273\",\n	\"prefix\" : \"530\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 4.31,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1230\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 7.19,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"DK\",\n	\"country_name\" : \"Denmark\",\n	\"number\" : \"1230\",\n	\"prefix\" : \"560\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 8.63,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"DKK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EC\",\n	\"country_name\" : \"Ecuador\",\n	\"number\" : \"7722\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.25,\n	\"usd\" : 1.12,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EE\",\n	\"country_name\" : \"Estonia\",\n	\"number\" : \"1311\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 0.35,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"EEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EE\",\n	\"country_name\" : \"Estonia\",\n	\"number\" : \"13011\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 0.71,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"EEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EE\",\n	\"country_name\" : \"Estonia\",\n	\"number\" : \"15330\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.00,\n	\"usd\" : 1.07,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"EEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EE\",\n	\"country_name\" : \"Estonia\",\n	\"number\" : \"13013\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 25.00,\n	\"usd\" : 1.78,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"EEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EE\",\n	\"country_name\" : \"Estonia\",\n	\"number\" : \"13015\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 2.78,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"EEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EE\",\n	\"country_name\" : \"Estonia\",\n	\"number\" : \"13017\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 3.56,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"EEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"EG\",\n	\"country_name\" : \"Egypt\",\n	\"number\" : \"95206\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 0.90,\n	\"profit\" : 20.00,\n	\"vat\" : 0,\n	\"currency\" : \"EGP\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ES\",\n	\"country_name\" : \"Spain\",\n	\"number\" : \"27333\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.90,\n	\"usd\" : 1.20,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ES\",\n	\"country_name\" : \"Spain\",\n	\"number\" : \"35000\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 2.66,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ES\",\n	\"country_name\" : \"Spain\",\n	\"number\" : \"37333\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 4.00,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ES\",\n	\"country_name\" : \"Spain\",\n	\"number\" : \"35989\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 5.33,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ES\",\n	\"country_name\" : \"Spain\",\n	\"number\" : \"37555\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 6.66,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ES\",\n	\"country_name\" : \"Spain\",\n	\"number\" : \"35969\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 6.00,\n	\"usd\" : 8.00,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FI\",\n	\"country_name\" : \"Finland\",\n	\"number\" : \"17159\",\n	\"prefix\" : \"513\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.30,\n	\"usd\" : 1.42,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FI\",\n	\"country_name\" : \"Finland\",\n	\"number\" : \"17159\",\n	\"prefix\" : \"525\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.50,\n	\"usd\" : 2.73,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FI\",\n	\"country_name\" : \"Finland\",\n	\"number\" : \"17211\",\n	\"prefix\" : \"503\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 3.28,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FI\",\n	\"country_name\" : \"Finland\",\n	\"number\" : \"17211\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 5.46,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FI\",\n	\"country_name\" : \"Finland\",\n	\"number\" : \"17211\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 10.93,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FR\",\n	\"country_name\" : \"France\",\n	\"number\" : \"71004\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.56,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FR\",\n	\"country_name\" : \"France\",\n	\"number\" : \"81027\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 1.66,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"FR\",\n	\"country_name\" : \"France\",\n	\"number\" : \"81015\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 3.34,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GE\",\n	\"country_name\" : \"Georgia\",\n	\"number\" : \"8886\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 0.48,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"GEL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GE\",\n	\"country_name\" : \"Georgia\",\n	\"number\" : \"8889\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 0.96,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"GEL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GE\",\n	\"country_name\" : \"Georgia\",\n	\"number\" : \"8882\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.30,\n	\"usd\" : 2.08,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"GEL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GE\",\n	\"country_name\" : \"Georgia\",\n	\"number\" : \"6210\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 2.42,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"GEL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GR\",\n	\"country_name\" : \"Greece\",\n	\"number\" : \"54045\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.30,\n	\"usd\" : 0.33,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GR\",\n	\"country_name\" : \"Greece\",\n	\"number\" : \"54340\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.61,\n	\"usd\" : 0.66,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GR\",\n	\"country_name\" : \"Greece\",\n	\"number\" : \"54344\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.21,\n	\"usd\" : 1.33,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"GR\",\n	\"country_name\" : \"Greece\",\n	\"number\" : \"54345\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.56,\n	\"usd\" : 3.92,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HK\",\n	\"country_name\" : \"Hong Kong\",\n	\"number\" : \"503230\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 3.87,\n	\"profit\" : 30.00,\n	\"vat\" : 0,\n	\"currency\" : \"HKD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HR\",\n	\"country_name\" : \"Croatia\",\n	\"number\" : \"62580\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.22,\n	\"usd\" : 0.18,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"HRK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HR\",\n	\"country_name\" : \"Croatia\",\n	\"number\" : \"66354\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.66,\n	\"usd\" : 0.54,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"HRK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HR\",\n	\"country_name\" : \"Croatia\",\n	\"number\" : \"67454\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 6.10,\n	\"usd\" : 0.91,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"HRK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HU\",\n	\"country_name\" : \"Hungary\",\n	\"number\" : \"0691222322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 200.00,\n	\"usd\" : 1.01,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"HUF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HU\",\n	\"country_name\" : \"Hungary\",\n	\"number\" : \"0691227910\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 600.00,\n	\"usd\" : 3.04,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"HUF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"HU\",\n	\"country_name\" : \"Hungary\",\n	\"number\" : \"0690619916\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1600.00,\n	\"usd\" : 8.11,\n	\"profit\" : 40.00,\n	\"vat\" : 0,\n	\"currency\" : \"HUF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.11,\n	\"profit\" : 17.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"501\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 0.23,\n	\"profit\" : 24.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"502\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 0.46,\n	\"profit\" : 29.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"503\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 0.69,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"504\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 0.92,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 1.15,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"506\",\n	\"rewrite\" : \"\",\n	\"price\" : 6.00,\n	\"usd\" : 1.38,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"507\",\n	\"rewrite\" : \"\",\n	\"price\" : 7.00,\n	\"usd\" : 1.61,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"508\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.00,\n	\"usd\" : 1.84,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 2.30,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"511\",\n	\"rewrite\" : \"\",\n	\"price\" : 11.00,\n	\"usd\" : 2.53,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"512\",\n	\"rewrite\" : \"\",\n	\"price\" : 12.00,\n	\"usd\" : 2.76,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.00,\n	\"usd\" : 3.46,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"518\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.00,\n	\"usd\" : 4.15,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IL\",\n	\"country_name\" : \"Israel\",\n	\"number\" : \"5111\",\n	\"prefix\" : \"520\",\n	\"rewrite\" : \"\",\n	\"price\" : 20.00,\n	\"usd\" : 4.61,\n	\"profit\" : 33.00,\n	\"vat\" : 1,\n	\"currency\" : \"Sheqel\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IN\",\n	\"country_name\" : \"India\",\n	\"number\" : \"5499959\",\n	\"prefix\" : \"520\",\n	\"rewrite\" : \"\",\n	\"price\" : 20.00,\n	\"usd\" : 0.43,\n	\"profit\" : 15.00,\n	\"vat\" : 0,\n	\"currency\" : \"INR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IN\",\n	\"country_name\" : \"India\",\n	\"number\" : \"5499959\",\n	\"prefix\" : \"530\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.64,\n	\"profit\" : 15.00,\n	\"vat\" : 0,\n	\"currency\" : \"INR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IN\",\n	\"country_name\" : \"India\",\n	\"number\" : \"5499959\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 1.07,\n	\"profit\" : 15.00,\n	\"vat\" : 0,\n	\"currency\" : \"INR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"IN\",\n	\"country_name\" : \"India\",\n	\"number\" : \"5499959\",\n	\"prefix\" : \"599\",\n	\"rewrite\" : \"\",\n	\"price\" : 99.00,\n	\"usd\" : 2.13,\n	\"profit\" : 15.00,\n	\"vat\" : 0,\n	\"currency\" : \"INR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"JO\",\n	\"country_name\" : \"Jordan\",\n	\"special\" : \"\",\n[{\n	\"code\" : \"orange\",\n	\"name\" : \"Orange\",\n	\"number\" : \"99036\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.90,\n	\"usd\" : 0.71,\n	\"profit\" : 30,\n	\"vat\" : 1,\n	\"currency\" : \"JOD\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"umniah\",\n	\"name\" : \"Umniah\",\n	\"number\" : \"98743\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.90,\n	\"usd\" : 0.71,\n	\"profit\" : 30,\n	\"vat\" : 1,\n	\"currency\" : \"JOD\",\n	\"special\" : \"\"\n}]\n},{\n	\"country\" : \"KG\",\n	\"country_name\" : \"Kyrgyzstan\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 1.00,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"KG\",\n	\"country_name\" : \"Kyrgyzstan\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 3.00,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"KH\",\n	\"country_name\" : \"Cambodia\",\n	\"number\" : \"3350\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.99,\n	\"usd\" : 0.90,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"KH\",\n	\"country_name\" : \"Cambodia\",\n	\"number\" : \"3349\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.39,\n	\"usd\" : 1.26,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"KH\",\n	\"country_name\" : \"Cambodia\",\n	\"number\" : \"3340\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.99,\n	\"usd\" : 1.81,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"KH\",\n	\"country_name\" : \"Cambodia\",\n	\"number\" : \"3339\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.99,\n	\"usd\" : 2.72,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"KZ\",\n	\"country_name\" : \"Kazakhstan\",\n	\"special\" : \"\",\n[{\n	\"code\" : \"altel\",\n	\"name\" : \"Dalacom\",\n	\"number\" : \"4161\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 950.00,\n	\"usd\" : 5.78,\n	\"profit\" : 30,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altel\",\n	\"name\" : \"Dalacom\",\n	\"number\" : \"8444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 375.00,\n	\"usd\" : 2.28,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altel\",\n	\"name\" : \"Dalacom\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 170.00,\n	\"usd\" : 1.03,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 535.00,\n	\"usd\" : 3.25,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"8444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 375.00,\n	\"usd\" : 2.28,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 170.00,\n	\"usd\" : 1.03,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 75.00,\n	\"usd\" : 0.45,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"kcell\",\n	\"name\" : \"Kcell\",\n	\"number\" : \"4161\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 700.00,\n	\"usd\" : 4.26,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"kcell\",\n	\"name\" : \"Kcell\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 535.00,\n	\"usd\" : 3.25,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"kcell\",\n	\"name\" : \"Kcell\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 170.00,\n	\"usd\" : 1.03,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"kcell\",\n	\"name\" : \"Kcell\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 75.00,\n	\"usd\" : 0.45,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mobiletelecomservice\",\n	\"name\" : \"Mobile Telecom Service\",\n	\"number\" : \"4161\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 700.00,\n	\"usd\" : 4.26,\n	\"profit\" : 40,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mobiletelecomservice\",\n	\"name\" : \"Mobile Telecom Service\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 535.00,\n	\"usd\" : 3.25,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mobiletelecomservice\",\n	\"name\" : \"Mobile Telecom Service\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 170.00,\n	\"usd\" : 1.03,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mobiletelecomservice\",\n	\"name\" : \"Mobile Telecom Service\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 75.00,\n	\"usd\" : 0.45,\n	\"profit\" : 25,\n	\"vat\" : 1,\n	\"currency\" : \"KZT\",\n	\"special\" : \"\"\n}]\n},{\n	\"country\" : \"LB\",\n	\"country_name\" : \"Lebanon\",\n	\"number\" : \"1081\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.90,\n	\"usd\" : 0.81,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"USD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.51,\n	\"usd\" : 0.16,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"501\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.02,\n	\"usd\" : 0.32,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"502\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.03,\n	\"usd\" : 0.65,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"503\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.05,\n	\"usd\" : 0.97,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"504\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.07,\n	\"usd\" : 1.30,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.08,\n	\"usd\" : 1.62,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"506\",\n	\"rewrite\" : \"\",\n	\"price\" : 6.10,\n	\"usd\" : 1.95,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"507\",\n	\"rewrite\" : \"\",\n	\"price\" : 7.11,\n	\"usd\" : 2.27,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"508\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.13,\n	\"usd\" : 2.60,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"509\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.15,\n	\"usd\" : 2.93,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.16,\n	\"usd\" : 3.25,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.26,\n	\"usd\" : 4.88,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LT\",\n	\"country_name\" : \"Lithuania\",\n	\"number\" : \"1394\",\n	\"prefix\" : \"520\",\n	\"rewrite\" : \"\",\n	\"price\" : 20.34,\n	\"usd\" : 6.51,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"LTL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LU\",\n	\"country_name\" : \"Luxembourg\",\n	\"number\" : \"64747\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 1.73,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"502\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.25,\n	\"usd\" : 0.39,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.77,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 1.56,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 2.33,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"520\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 3.11,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"525\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.50,\n	\"usd\" : 3.90,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"530\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 4.67,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"540\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 6.24,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"LV\",\n	\"country_name\" : \"Latvia\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 7.79,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"LVL\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ME\",\n	\"country_name\" : \"Montenegro\",\n	\"number\" : \"14941\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.60,\n	\"usd\" : 0.68,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"MK\",\n	\"country_name\" : \"Macedonia\",\n	\"number\" : \"141591\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 59.00,\n	\"usd\" : 1.11,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"MKD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"MK\",\n	\"country_name\" : \"Macedonia\",\n	\"number\" : \"141991\",\n	\"prefix\" : \"590\",\n	\"rewrite\" : \"\",\n	\"price\" : 106.20,\n	\"usd\" : 2.00,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"MKD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"MX\",\n	\"country_name\" : \"Mexico\",\n	\"special\" : \"\",\n[{\n	\"code\" : \"telcel\",\n	\"name\" : \"TELCEL\",\n	\"number\" : \"40000\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.00,\n	\"usd\" : 1.06,\n	\"profit\" : 20,\n	\"vat\" : 1,\n	\"currency\" : \"MXN\",\n	\"special\" : \"Servicio disponible solamente para usuarios Telcel. $15 IVA incluido por SMS, (o $14.35 en ciudades fronterizas en donde aplica el 10% de IVA). El servicio &lt;Service&gt; tiene un limite mensual de 70 SMS. Este limite se establece para evitar abusos y proteger a los usuarios. No utilice este sistema si lo ha alcanzado, ya sera el unico responsable por intentar sobrepasarlo. Telcel no se hace responsable de este servicio, ni de su contenido ni de su publicidad. Atencion a clientes : llame sin costo al 01 800 6991515\"\n},{\n	\"code\" : \"iusacell\",\n	\"name\" : \"IUSACELL\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.00,\n	\"usd\" : 1.06,\n	\"profit\" : 20,\n	\"vat\" : 1,\n	\"currency\" : \"MXN\",\n	\"special\" : \"Servicio disponible solamente para usuarios Movistar, Iusacell y Unefon. $15 IVA incluido por SMS, (o $14.35 en ciudades fronterizas en donde aplica el 10% de IVA). Atencion a clientes : llame sin costo al 01 800 699 20 20 desde todo el pais.\"\n},{\n	\"code\" : \"movistar\",\n	\"name\" : \"MOVISTAR\",\n	\"number\" : \"1819\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.00,\n	\"usd\" : 1.06,\n	\"profit\" : 20,\n	\"vat\" : 1,\n	\"currency\" : \"MXN\",\n	\"special\" : \"Servicio disponible solamente para usuarios Movistar, Iusacell y Unefon. $15 IVA incluido por SMS, (o $14.35 en ciudades fronterizas en donde aplica el 10% de IVA). Atencion a clientes : llame sin costo al 01 800 699 20 20 desde todo el pais.\"\n}]\n},{\n	\"country\" : \"MY\",\n	\"country_name\" : \"Malaysia\",\n	\"number\" : \"32088\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 3.12,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"MYR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"NG\",\n	\"country_name\" : \"Nigeria\",\n	\"number\" : \"35810\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 100.00,\n	\"usd\" : 0.66,\n	\"profit\" : 15.00,\n	\"vat\" : 1,\n	\"currency\" : \"NGN\",\n	\"special\" : \"Zain and Globacom only\",\n[]\n},{\n	\"country\" : \"NL\",\n	\"country_name\" : \"Netherlands\",\n	\"number\" : \"4466\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.55,\n	\"usd\" : 0.61,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"NL\",\n	\"country_name\" : \"Netherlands\",\n	\"number\" : \"4466\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 1.68,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"NO\",\n	\"country_name\" : \"Norway\",\n	\"number\" : \"2223\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 1.35,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"NOK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"NO\",\n	\"country_name\" : \"Norway\",\n	\"number\" : \"2227\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 4.06,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"NOK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"NO\",\n	\"country_name\" : \"Norway\",\n	\"number\" : \"2223\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 6.77,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"NOK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"NO\",\n	\"country_name\" : \"Norway\",\n	\"number\" : \"2223\",\n	\"prefix\" : \"560\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 8.13,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"NOK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PE\",\n	\"country_name\" : \"Peru\",\n	\"number\" : \"2447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 1.47,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"PEN\",\n	\"special\" : \"Servicio disponible para Claro y Movistar. Costo por mensaje : 5 nuevos soles   (PEN 5.00) IGV incluido. Atención a cliente : support@smscoin.com\",\n[]\n},{\n	\"country\" : \"PL\",\n	\"country_name\" : \"Poland\",\n	\"number\" : \"72240\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 0.69,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"PLN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PL\",\n	\"country_name\" : \"Poland\",\n	\"number\" : \"74240\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 1.38,\n	\"profit\" : 27.00,\n	\"vat\" : 0,\n	\"currency\" : \"PLN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PL\",\n	\"country_name\" : \"Poland\",\n	\"number\" : \"7643\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 6.00,\n	\"usd\" : 2.07,\n	\"profit\" : 27.00,\n	\"vat\" : 0,\n	\"currency\" : \"PLN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PL\",\n	\"country_name\" : \"Poland\",\n	\"number\" : \"7943\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.00,\n	\"usd\" : 3.11,\n	\"profit\" : 30.00,\n	\"vat\" : 0,\n	\"currency\" : \"PLN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PL\",\n	\"country_name\" : \"Poland\",\n	\"number\" : \"91909\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 19.00,\n	\"usd\" : 6.57,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"PLN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PL\",\n	\"country_name\" : \"Poland\",\n	\"number\" : \"92505\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 25.00,\n	\"usd\" : 8.65,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"PLN\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PT\",\n	\"country_name\" : \"Portugal\",\n	\"number\" : \"68632\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.72,\n	\"usd\" : 0.80,\n	\"profit\" : 25.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PT\",\n	\"country_name\" : \"Portugal\",\n	\"number\" : \"68634\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 1.09,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PT\",\n	\"country_name\" : \"Portugal\",\n	\"number\" : \"68636\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 2.20,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"PT\",\n	\"country_name\" : \"Portugal\",\n	\"number\" : \"68638\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.00,\n	\"usd\" : 4.40,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"QA\",\n	\"country_name\" : \"Qatar\",\n	\"number\" : \"92921\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.00,\n	\"usd\" : 2.19,\n	\"profit\" : 25.00,\n	\"vat\" : 0,\n	\"currency\" : \"QAR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"RO\",\n	\"country_name\" : \"Romania\",\n	\"number\" : \"1266\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.70,\n	\"usd\" : 0.93,\n	\"profit\" : 30.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"RO\",\n	\"country_name\" : \"Romania\",\n	\"number\" : \"1380\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 2.00,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"RO\",\n	\"country_name\" : \"Romania\",\n	\"number\" : \"1314\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 2.66,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"RO\",\n	\"country_name\" : \"Romania\",\n	\"number\" : \"1277\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.00,\n	\"usd\" : 4.00,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"RO\",\n	\"country_name\" : \"Romania\",\n	\"number\" : \"1255\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 6.66,\n	\"profit\" : 35.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"RS\",\n	\"country_name\" : \"Serbia\",\n	\"number\" : \"1552\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.50,\n	\"usd\" : 0.36,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"RSD\",\n	\"special\" : \"+ price of the standard SMS\",\n[]\n},{\n	\"country\" : \"RS\",\n	\"country_name\" : \"Serbia\",\n	\"number\" : \"1553\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 128.00,\n	\"usd\" : 1.46,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"RSD\",\n	\"special\" : \"+ price of the standard SMS\",\n[]\n},{\n	\"country\" : \"RS\",\n	\"country_name\" : \"Serbia\",\n	\"number\" : \"4828\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 354.00,\n	\"usd\" : 4.04,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"RSD\",\n	\"special\" : \"+ price of the standard SMS\",\n[]\n},{\n	\"country\" : \"RU\",\n	\"country_name\" : \"Russia\",\n	\"special\" : \"Итоговая стоимость в рублях зависит от провайдера\",\n[{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 60.69,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 144.07,\n	\"usd\" : 4.50,\n	\"profit\" : 60.8,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 84.75,\n	\"usd\" : 2.64,\n	\"profit\" : 61.31,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 59.32,\n	\"usd\" : 1.85,\n	\"profit\" : 61.58,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 37.29,\n	\"usd\" : 1.16,\n	\"profit\" : 56.68,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.66,\n	\"usd\" : 0.92,\n	\"profit\" : 57.4,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.95,\n	\"usd\" : 0.52,\n	\"profit\" : 57.71,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.48,\n	\"usd\" : 0.26,\n	\"profit\" : 53.96,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"beeline\",\n	\"name\" : \"Beeline\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.24,\n	\"usd\" : 0.13,\n	\"profit\" : 42.17,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 44.33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 44.2,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.93,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.00,\n	\"usd\" : 0.56,\n	\"profit\" : 50.56,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 0.31,\n	\"profit\" : 55,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"megafon\",\n	\"name\" : \"Megafon\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 0.15,\n	\"profit\" : 37,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 258.30,\n	\"usd\" : 8.07,\n	\"profit\" : 56.08,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 172.20,\n	\"usd\" : 5.38,\n	\"profit\" : 54.81,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 85.81,\n	\"usd\" : 2.68,\n	\"profit\" : 58.4,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 54.53,\n	\"usd\" : 1.70,\n	\"profit\" : 58.08,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 37.31,\n	\"usd\" : 1.16,\n	\"profit\" : 53.97,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 28.41,\n	\"usd\" : 0.88,\n	\"profit\" : 56.95,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 17.22,\n	\"usd\" : 0.53,\n	\"profit\" : 50.17,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.61,\n	\"usd\" : 0.26,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mts\",\n	\"name\" : \"MTS\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.31,\n	\"usd\" : 0.13,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 38,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 38,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.80,\n	\"usd\" : 2.83,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.60,\n	\"usd\" : 1.89,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.40,\n	\"usd\" : 1.23,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 27.39,\n	\"usd\" : 0.85,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.20,\n	\"usd\" : 0.56,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.10,\n	\"usd\" : 0.28,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"akos\",\n	\"name\" : \"Akos\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.50,\n	\"usd\" : 0.14,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altaysvyaz\",\n	\"name\" : \"AltaySvyaz\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altaysvyaz\",\n	\"name\" : \"AltaySvyaz\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altaysvyaz\",\n	\"name\" : \"AltaySvyaz\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altaysvyaz\",\n	\"name\" : \"AltaySvyaz\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"altaysvyaz\",\n	\"name\" : \"AltaySvyaz\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.93,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 81.36,\n	\"usd\" : 2.54,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 55.09,\n	\"usd\" : 1.72,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 22.12,\n	\"usd\" : 0.69,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.95,\n	\"usd\" : 0.52,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"3533\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.47,\n	\"usd\" : 0.26,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"astragsm\",\n	\"name\" : \"Astrahan GSM\",\n	\"number\" : \"2880\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.24,\n	\"usd\" : 0.13,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.50,\n	\"usd\" : 5.29,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.00,\n	\"usd\" : 5.28,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 89.00,\n	\"usd\" : 2.78,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 59.00,\n	\"usd\" : 1.84,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.00,\n	\"usd\" : 0.90,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 19.00,\n	\"usd\" : 0.59,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 0.31,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"baikalwestcom\",\n	\"name\" : \"BaicalWestCom\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 0.15,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4161\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 144.07,\n	\"usd\" : 4.50,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 88.98,\n	\"usd\" : 2.78,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 59.32,\n	\"usd\" : 1.85,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.14,\n	\"usd\" : 1.19,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.66,\n	\"usd\" : 0.92,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.95,\n	\"usd\" : 0.52,\n	\"profit\" : 44.97,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.47,\n	\"usd\" : 0.26,\n	\"profit\" : 45.06,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"bashsel\",\n	\"name\" : \"BashSEL\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.66,\n	\"usd\" : 0.14,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.93,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.00,\n	\"usd\" : 0.56,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"3533\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.00,\n	\"usd\" : 0.28,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"enisey\",\n	\"name\" : \"Enisey Telecom\",\n	\"number\" : \"2880\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.50,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"mobilphone\",\n	\"name\" : \"MobilPhone\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.93,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 17.22,\n	\"usd\" : 0.53,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"3533\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.00,\n	\"usd\" : 0.28,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"motiv\",\n	\"name\" : \"MOTIV\",\n	\"number\" : \"2880\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.50,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.68,\n	\"usd\" : 2.83,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.17,\n	\"usd\" : 1.88,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.70,\n	\"usd\" : 0.92,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_chuvashia\",\n	\"name\" : \"NSS Chuvashiya\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_mordovia\",\n	\"name\" : \"NSS Mordovia\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_mordovia\",\n	\"name\" : \"NSS Mordovia\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_mordovia\",\n	\"name\" : \"NSS Mordovia\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 84.36,\n	\"usd\" : 2.63,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_mordovia\",\n	\"name\" : \"NSS Mordovia\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 56.24,\n	\"usd\" : 1.75,\n	\"profit\" : 32.77,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 84.36,\n	\"usd\" : 2.63,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 56.24,\n	\"usd\" : 1.75,\n	\"profit\" : 32.77,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 36.56,\n	\"usd\" : 1.14,\n	\"profit\" : 32.6,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 27.84,\n	\"usd\" : 0.87,\n	\"profit\" : 32.54,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.68,\n	\"usd\" : 0.52,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.43,\n	\"usd\" : 0.26,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_nn\",\n	\"name\" : \"NCC Nizhniy Novgorod\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.22,\n	\"usd\" : 0.13,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 89.83,\n	\"usd\" : 2.80,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.17,\n	\"usd\" : 1.88,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 27.12,\n	\"usd\" : 0.84,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_pm\",\n	\"name\" : \"NSS-PM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.23,\n	\"usd\" : 7.94,\n	\"profit\" : 45,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 43.38,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 45.26,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 45.99,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 34.74,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.70,\n	\"usd\" : 0.92,\n	\"profit\" : 45.05,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.00,\n	\"usd\" : 0.56,\n	\"profit\" : 45.37,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.00,\n	\"usd\" : 0.28,\n	\"profit\" : 45.34,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"nss_saratov\",\n	\"name\" : \"NSS Saratov\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.50,\n	\"usd\" : 0.14,\n	\"profit\" : 46.11,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 260.00,\n	\"usd\" : 8.12,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.00,\n	\"usd\" : 5.28,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 86.71,\n	\"usd\" : 2.70,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 58.00,\n	\"usd\" : 1.81,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 37.70,\n	\"usd\" : 1.17,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 28.71,\n	\"usd\" : 0.89,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 17.40,\n	\"usd\" : 0.54,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"3533\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.70,\n	\"usd\" : 0.27,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ntk\",\n	\"name\" : \"NTK\",\n	\"number\" : \"2880\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.35,\n	\"usd\" : 0.13,\n	\"profit\" : 41,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 89.83,\n	\"usd\" : 2.80,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.17,\n	\"usd\" : 1.88,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.00,\n	\"usd\" : 0.90,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"orenburggsm\",\n	\"name\" : \"Orenburg-GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 296.61,\n	\"usd\" : 9.26,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 81.36,\n	\"usd\" : 2.54,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 55.08,\n	\"usd\" : 1.72,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 34.76,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 27.12,\n	\"usd\" : 0.84,\n	\"profit\" : 33.73,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.95,\n	\"usd\" : 0.52,\n	\"profit\" : 32.74,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 27.17,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"penzagsm\",\n	\"name\" : \"Penza-GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.24,\n	\"usd\" : 0.13,\n	\"profit\" : 18.6,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 296.61,\n	\"usd\" : 9.26,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.68,\n	\"usd\" : 2.83,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.17,\n	\"usd\" : 1.88,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.00,\n	\"usd\" : 0.90,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"shupashkargsm\",\n	\"name\" : \"Shupashkar-GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 89.83,\n	\"usd\" : 2.80,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 59.32,\n	\"usd\" : 1.85,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.00,\n	\"usd\" : 0.90,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.17,\n	\"usd\" : 0.31,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"sibirtelecom\",\n	\"name\" : \"STeK GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 43,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 43,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 1.56,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 24.17,\n	\"usd\" : 0.75,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 15.83,\n	\"usd\" : 0.49,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.33,\n	\"usd\" : 0.26,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"skylink\",\n	\"name\" : \"SkyLink\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.17,\n	\"usd\" : 0.13,\n	\"profit\" : 50,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 296.61,\n	\"usd\" : 9.26,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 81.36,\n	\"usd\" : 2.54,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 55.08,\n	\"usd\" : 1.72,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.85,\n	\"usd\" : 1.58,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 27.12,\n	\"usd\" : 0.84,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.95,\n	\"usd\" : 0.52,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"3533\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.47,\n	\"usd\" : 0.26,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"smarts\",\n	\"name\" : \"SMARTS\",\n	\"number\" : \"2880\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.24,\n	\"usd\" : 0.13,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 254.24,\n	\"usd\" : 7.94,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 84.36,\n	\"usd\" : 2.63,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.17,\n	\"usd\" : 1.88,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 27.12,\n	\"usd\" : 0.84,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 17.80,\n	\"usd\" : 0.55,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tatinkom\",\n	\"name\" : \"TATINKOM-T\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 211.86,\n	\"usd\" : 6.62,\n	\"profit\" : 48.93,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.00,\n	\"usd\" : 5.28,\n	\"profit\" : 49.84,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 85.81,\n	\"usd\" : 2.68,\n	\"profit\" : 49.69,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 57.11,\n	\"usd\" : 1.78,\n	\"profit\" : 49.61,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.85,\n	\"usd\" : 0.93,\n	\"profit\" : 48.6,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 28.41,\n	\"usd\" : 0.88,\n	\"profit\" : 49.06,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"3833\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 17.22,\n	\"usd\" : 0.53,\n	\"profit\" : 49.49,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"3533\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.61,\n	\"usd\" : 0.26,\n	\"profit\" : 48.91,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"tele2\",\n	\"name\" : \"Tele2\",\n	\"number\" : \"2880\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.31,\n	\"usd\" : 0.13,\n	\"profit\" : 43.04,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 260.00,\n	\"usd\" : 8.12,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 170.00,\n	\"usd\" : 5.31,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.68,\n	\"usd\" : 2.83,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.17,\n	\"usd\" : 1.88,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.98,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 28.81,\n	\"usd\" : 0.90,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.32,\n	\"usd\" : 0.29,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"ulianovskgsm\",\n	\"name\" : \"Ulianovsk-GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.49,\n	\"usd\" : 0.14,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 260.00,\n	\"usd\" : 8.12,\n	\"profit\" : 43.38,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 150.00,\n	\"usd\" : 4.68,\n	\"profit\" : 43.33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 43.14,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 43,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 42.44,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 21.00,\n	\"usd\" : 0.65,\n	\"profit\" : 38.33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 9.00,\n	\"usd\" : 0.28,\n	\"profit\" : 32.78,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uralsvyasinform\",\n	\"name\" : \"Uralsviazinform\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 4.50,\n	\"usd\" : 0.14,\n	\"profit\" : 17.22,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uuss\",\n	\"name\" : \"UUSS\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uuss\",\n	\"name\" : \"UUSS\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.24,\n	\"usd\" : 5.28,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uuss\",\n	\"name\" : \"UUSS\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uuss\",\n	\"name\" : \"UUSS\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"uuss\",\n	\"name\" : \"UUSS\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.93,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgatelecom\",\n	\"name\" : \"VolgaTelecom\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 300.00,\n	\"usd\" : 9.37,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgatelecom\",\n	\"name\" : \"VolgaTelecom\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.24,\n	\"usd\" : 5.28,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgatelecom\",\n	\"name\" : \"VolgaTelecom\",\n	\"number\" : \"2322\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 90.00,\n	\"usd\" : 2.81,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgatelecom\",\n	\"name\" : \"VolgaTelecom\",\n	\"number\" : \"3933\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 60.00,\n	\"usd\" : 1.87,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgatelecom\",\n	\"name\" : \"VolgaTelecom\",\n	\"number\" : \"2990\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 0.93,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4161\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 150.00,\n	\"usd\" : 4.68,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 89.00,\n	\"usd\" : 2.78,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 59.00,\n	\"usd\" : 1.84,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 39.00,\n	\"usd\" : 1.21,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 29.00,\n	\"usd\" : 0.90,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 19.00,\n	\"usd\" : 0.59,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 0.31,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"volgogradgsm\",\n	\"name\" : \"Volgograd GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 0.15,\n	\"profit\" : 40,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"2474\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 296.61,\n	\"usd\" : 9.26,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"2476\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 169.49,\n	\"usd\" : 5.29,\n	\"profit\" : 32,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 89.83,\n	\"usd\" : 2.80,\n	\"profit\" : 27.15,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4448\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 58.47,\n	\"usd\" : 1.82,\n	\"profit\" : 33.44,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4447\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 38.14,\n	\"usd\" : 1.19,\n	\"profit\" : 35.64,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4446\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 28.81,\n	\"usd\" : 0.90,\n	\"profit\" : 38.52,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 18.64,\n	\"usd\" : 0.58,\n	\"profit\" : 35.8,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.17,\n	\"usd\" : 0.31,\n	\"profit\" : 31.98,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"yaroslavlgsm\",\n	\"name\" : \"Yaroslavl-GSM\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.08,\n	\"usd\" : 0.15,\n	\"profit\" : 34.33,\n	\"vat\" : 0,\n	\"currency\" : \"рубль\",\n	\"special\" : \"\"\n}]\n},{\n	\"country\" : \"SA\",\n	\"country_name\" : \"KSA\",\n	\"special\" : \"\",\n[{\n	\"code\" : \"stc\",\n	\"name\" : \"STC\",\n	\"number\" : \"81720\",\n	\"prefix\" : \"507\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 1.33,\n	\"profit\" : 25,\n	\"vat\" : 0,\n	\"currency\" : \"SAR\",\n	\"special\" : \"\"\n},{\n	\"code\" : \"zain\",\n	\"name\" : \"Zain\",\n	\"number\" : \"81720\",\n	\"prefix\" : \"507\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 1.33,\n	\"profit\" : 25,\n	\"vat\" : 0,\n	\"currency\" : \"SAR\",\n	\"special\" : \"\"\n}]\n},{\n	\"country\" : \"SE\",\n	\"country_name\" : \"Sweden\",\n	\"number\" : \"72401\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 1.11,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"SEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SE\",\n	\"country_name\" : \"Sweden\",\n	\"number\" : \"72702\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 3.34,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"SEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SE\",\n	\"country_name\" : \"Sweden\",\n	\"number\" : \"72401\",\n	\"prefix\" : \"530\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 3.34,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"SEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SE\",\n	\"country_name\" : \"Sweden\",\n	\"number\" : \"72401\",\n	\"prefix\" : \"550\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 5.57,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"SEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SE\",\n	\"country_name\" : \"Sweden\",\n	\"number\" : \"72401\",\n	\"prefix\" : \"580\",\n	\"rewrite\" : \"\",\n	\"price\" : 80.00,\n	\"usd\" : 8.92,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"SEK\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SI\",\n	\"country_name\" : \"Slovenia\",\n	\"number\" : \"3838\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.49,\n	\"usd\" : 2.77,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SK\",\n	\"country_name\" : \"Slovakia\",\n	\"number\" : \"6667\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.80,\n	\"usd\" : 0.88,\n	\"profit\" : 30.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"SK\",\n	\"country_name\" : \"Slovakia\",\n	\"number\" : \"6674\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.59,\n	\"usd\" : 1.77,\n	\"profit\" : 30.00,\n	\"vat\" : 0,\n	\"currency\" : \"EUR\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"TW\",\n	\"country_name\" : \"Taiwan\",\n	\"number\" : \"55123\",\n	\"prefix\" : \"500\",\n	\"rewrite\" : \"\",\n	\"price\" : 50.00,\n	\"usd\" : 1.51,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"TWD\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"4443\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 0.10,\n	\"profit\" : 10.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"4444\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 2.00,\n	\"usd\" : 0.21,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"4445\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.80,\n	\"usd\" : 0.39,\n	\"profit\" : 20.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"7054\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 8.00,\n	\"usd\" : 0.84,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"7074\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 12.00,\n	\"usd\" : 1.26,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"4449\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 16.00,\n	\"usd\" : 1.68,\n	\"profit\" : 39.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UA\",\n	\"country_name\" : \"Ukraine\",\n	\"number\" : \"7094\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 3.15,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"UAH\",\n	\"special\" : \"Дополнительно удерживается сбор в пенсионный фонд в размере 7,5% от стоимости услуги без учета НДС\",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"60999\",\n	\"prefix\" : \"625\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.25,\n	\"usd\" : 0.32,\n	\"profit\" : 15.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £0.25 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to +442033550074 \",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"80079\",\n	\"prefix\" : \"500\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.66,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £0.50 + normal network rates apply/ Need help? Mail to help@smscoin.com\",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"60999\",\n	\"prefix\" : \"650\",\n	\"rewrite\" : \"\",\n	\"price\" : 0.50,\n	\"usd\" : 0.66,\n	\"profit\" : 30.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £0.50 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to +442033550074 \",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"80079\",\n	\"prefix\" : \"501\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 1.30,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £1.00 + normal network rates apply/ Need help? Mail to help@smscoin.com\",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"60999\",\n	\"prefix\" : \"601\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.00,\n	\"usd\" : 1.30,\n	\"profit\" : 35.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £1.00 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to +442033550074 \",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"80079\",\n	\"prefix\" : \"515\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 1.96,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £1.50 + normal network rates apply/ Need help? Mail to help@smscoin.com\",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"60999\",\n	\"prefix\" : \"615\",\n	\"rewrite\" : \"\",\n	\"price\" : 1.50,\n	\"usd\" : 1.96,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £1.50 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to +442033550074 \",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"80079\",\n	\"prefix\" : \"505\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 6.55,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £5.00 + normal network rates apply/ Need help? Mail to help@smscoin.com\",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"60999\",\n	\"prefix\" : \"605\",\n	\"rewrite\" : \"\",\n	\"price\" : 5.00,\n	\"usd\" : 6.55,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £5.00 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to +442033550074 \",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"80079\",\n	\"prefix\" : \"510\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 13.09,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £10.00 + normal network rates apply/ Need help? Mail to help@smscoin.com\",\n[]\n},{\n	\"country\" : \"UK\",\n	\"country_name\" : \"United Kingdom\",\n	\"number\" : \"60999\",\n	\"prefix\" : \"610\",\n	\"rewrite\" : \"\",\n	\"price\" : 10.00,\n	\"usd\" : 13.09,\n	\"profit\" : 45.00,\n	\"vat\" : 1,\n	\"currency\" : \"GBP\",\n	\"special\" : \"Price £10.00 + normal network rates apply/ Need help? Mail to help@smscoin.com or call to +442033550074 \",\n[]\n},{\n	\"country\" : \"VE\",\n	\"country_name\" : \"Venezuela\",\n	\"number\" : \"7766\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 3.10,\n	\"usd\" : 0.66,\n	\"profit\" : 15.00,\n	\"vat\" : 1,\n	\"currency\" : \"VEF\",\n	\"special\" : \"\",\n[]\n},{\n	\"country\" : \"ZA\",\n	\"country_name\" : \"South Africa\",\n	\"number\" : \"42994\",\n	\"prefix\" : \"dam\",\n	\"rewrite\" : \"\",\n	\"price\" : 30.00,\n	\"usd\" : 4.04,\n	\"profit\" : 40.00,\n	\"vat\" : 1,\n	\"currency\" : \"ZAR\",\n	\"special\" : \"\",\n[]\n}\n]','2010-05-13 18:22:40','2010-05-13 18:22:40','d2a256f30b249f3ba0a75db6e54c3e40',1);
/*!40000 ALTER TABLE `smscoin_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content_type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_stats_on_type_and_content_id` (`type`,`content_id`),
  KEY `index_stats_on_created_at` (`created_at`),
  KEY `index_stats_on_content_type_and_content_id` (`content_type`,`content_id`),
  KEY `hit_recently` (`user_id`,`content_id`,`content_type`,`created_at`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1695 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stats`
--

LOCK TABLES `stats` WRITE;
/*!40000 ALTER TABLE `stats` DISABLE KEYS */;
INSERT INTO `stats` VALUES (1693,441,0,'Stats::View',NULL,NULL,'2010-06-25 19:28:50','2010-06-25 19:28:50','AdvancedUser'),(1694,2,0,'Stats::View',NULL,NULL,'2010-07-13 17:18:36','2010-07-13 17:18:36','AdvancedUser');
/*!40000 ALTER TABLE `stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_messages_responses`
--

DROP TABLE IF EXISTS `system_messages_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_messages_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `system_message_type` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_messages_responses`
--

LOCK TABLES `system_messages_responses` WRITE;
/*!40000 ALTER TABLE `system_messages_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_messages_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_messages_show_triggers`
--

DROP TABLE IF EXISTS `system_messages_show_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_messages_show_triggers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `system_message_type` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `show_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_messages_show_triggers`
--

LOCK TABLES `system_messages_show_triggers` WRITE;
/*!40000 ALTER TABLE `system_messages_show_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_messages_show_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `context` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_taggings_on_taggable_type_and_taggable_id` (`taggable_type`,`taggable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1423 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1410,408,405,'Profile','2010-06-28 17:48:35',441,'occupation'),(1411,409,405,'Profile','2010-06-28 17:48:35',441,'city'),(1412,410,405,'Profile','2010-06-28 17:48:35',441,'interests'),(1413,411,405,'Profile','2010-06-28 17:48:35',441,'interests'),(1414,412,405,'Profile','2010-06-28 17:48:35',441,'interests'),(1415,413,405,'Profile','2010-06-28 17:48:35',441,'school'),(1416,414,405,'Profile','2010-06-28 17:48:35',441,'country'),(1417,422,407,'Profile','2010-06-28 18:38:16',441,'occupation'),(1418,409,407,'Profile','2010-06-28 18:38:17',441,'city'),(1419,423,407,'Profile','2010-06-28 18:38:17',441,'interests'),(1420,424,407,'Profile','2010-06-28 18:38:17',441,'interests'),(1421,425,407,'Profile','2010-06-28 18:38:17',441,'interests'),(1422,414,407,'Profile','2010-06-28 18:38:17',441,'country');
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (408,'user'),(409,'berlin'),(410,'music'),(411,'computers'),(412,'web'),(413,'humboldtuniversity'),(414,'germany'),(415,'advanced user'),(416,'moscow'),(417,'girls'),(418,'drugs'),(419,'rocknroll'),(420,'msu'),(421,'russia'),(422,'fundraising'),(423,'avatar'),(424,'band'),(425,'navi');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terms_acceptances`
--

DROP TABLE IF EXISTS `terms_acceptances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `terms_acceptances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `termable_id` int(11) DEFAULT NULL,
  `termable_type` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `terms_and_conditions_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terms_acceptances`
--

LOCK TABLES `terms_acceptances` WRITE;
/*!40000 ALTER TABLE `terms_acceptances` DISABLE KEYS */;
/*!40000 ALTER TABLE `terms_acceptances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terms_and_conditions`
--

DROP TABLE IF EXISTS `terms_and_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `terms_and_conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `require_terms_acceptance` tinyint(1) NOT NULL,
  `terms_db_store_id` int(11) DEFAULT NULL,
  `terms_db_store_ru_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terms_and_conditions`
--

LOCK TABLES `terms_and_conditions` WRITE;
/*!40000 ALTER TABLE `terms_and_conditions` DISABLE KEYS */;
/*!40000 ALTER TABLE `terms_and_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toggles`
--

DROP TABLE IF EXISTS `toggles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `toggles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_toggles_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toggles`
--

LOCK TABLES `toggles` WRITE;
/*!40000 ALTER TABLE `toggles` DISABLE KEYS */;
/*!40000 ALTER TABLE `toggles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tps_content_details`
--

DROP TABLE IF EXISTS `tps_content_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tps_content_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `short_description` varchar(255) DEFAULT NULL,
  `short_description_ru` varchar(255) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `related_content_id` int(11) DEFAULT NULL,
  `participated_count` int(11) DEFAULT '0',
  `goal_amount` decimal(10,2) DEFAULT '0.00',
  `currently_collected` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `stopped` tinyint(1) NOT NULL DEFAULT '0',
  `currency` varchar(10) DEFAULT 'usd',
  `specific_amount` tinyint(1) DEFAULT '1',
  `duration` int(11) DEFAULT '0',
  `started_at` date DEFAULT NULL,
  `offer_goodies` tinyint(1) DEFAULT '0',
  `goodies_delivery_description` text,
  `goodies_delivery_description_ru` text,
  `invite_to_interested_circle` tinyint(1) DEFAULT '1',
  `specific_end_date` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tps_content_details`
--

LOCK TABLES `tps_content_details` WRITE;
/*!40000 ALTER TABLE `tps_content_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `tps_content_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tps_goodie_tickets`
--

DROP TABLE IF EXISTS `tps_goodie_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tps_goodie_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goodie_id` int(11) NOT NULL,
  `buyer_id` int(11) NOT NULL,
  `state` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tps_goodie_tickets_on_buyer_id_and_goodie_id_and_state` (`buyer_id`,`goodie_id`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tps_goodie_tickets`
--

LOCK TABLES `tps_goodie_tickets` WRITE;
/*!40000 ALTER TABLE `tps_goodie_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tps_goodie_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tps_goodies`
--

DROP TABLE IF EXISTS `tps_goodies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tps_goodies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `identifier` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `title_ru` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT '0.00',
  `left` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `donation` tinyint(1) NOT NULL DEFAULT '0',
  `downloadable_album_id` int(11) DEFAULT NULL,
  `needs_document` tinyint(1) NOT NULL DEFAULT '0',
  `needs_address` tinyint(1) NOT NULL DEFAULT '0',
  `currency` varchar(255) DEFAULT 'usd',
  `delivery_method_group` varchar(255) DEFAULT 'A',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tps_goodies_on_content_id_and_identifier` (`content_id`,`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tps_goodies`
--

LOCK TABLES `tps_goodies` WRITE;
/*!40000 ALTER TABLE `tps_goodies` DISABLE KEYS */;
/*!40000 ALTER TABLE `tps_goodies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tps_participant_info_requests`
--

DROP TABLE IF EXISTS `tps_participant_info_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tps_participant_info_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL,
  `address_needed` tinyint(1) NOT NULL,
  `document_needed` tinyint(1) NOT NULL,
  `answered` tinyint(1) NOT NULL DEFAULT '0',
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `document_kind` varchar(255) DEFAULT NULL,
  `document_identifier` varchar(255) DEFAULT NULL,
  `address` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tps_participant_info_requests_on_participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tps_participant_info_requests`
--

LOCK TABLES `tps_participant_info_requests` WRITE;
/*!40000 ALTER TABLE `tps_participant_info_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `tps_participant_info_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tps_participants`
--

DROP TABLE IF EXISTS `tps_participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tps_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `document_kind` varchar(255) DEFAULT NULL,
  `document_identifier` varchar(255) DEFAULT NULL,
  `address` text,
  `address_missing` tinyint(1) DEFAULT NULL,
  `document_missing` tinyint(1) DEFAULT NULL,
  `state` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tps_participants_on_content_id_and_user_id` (`content_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tps_participants`
--

LOCK TABLES `tps_participants` WRITE;
/*!40000 ALTER TABLE `tps_participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `tps_participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trackings`
--

DROP TABLE IF EXISTS `trackings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trackings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracking_user_id` int(11) DEFAULT NULL,
  `tracked_item_id` int(11) DEFAULT NULL,
  `tracked_item_type` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `reference_item_id` int(11) DEFAULT NULL,
  `reference_item_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_trackings_on_tracking_user_id` (`tracking_user_id`),
  KEY `index_trackings_on_tracked_item_type_and_tracked_item_id` (`tracked_item_type`,`tracked_item_id`),
  KEY `index_trackings_on_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=526 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trackings`
--

LOCK TABLES `trackings` WRITE;
/*!40000 ALTER TABLE `trackings` DISABLE KEYS */;
INSERT INTO `trackings` VALUES (522,441,441,'User','Tracking::EmailDelivery','2010-06-24 13:49:32','2010-06-24 13:49:32',NULL,NULL),(523,441,442,'User','Tracking::EmailDelivery','2010-06-24 13:49:32','2010-06-24 13:49:32',NULL,NULL),(524,441,443,'User','Tracking::EmailDelivery','2010-06-25 15:49:27','2010-06-25 15:49:27',NULL,NULL),(525,444,444,'User','Tracking::EmailDelivery','2010-07-13 17:21:07','2010-07-13 17:21:07',NULL,NULL);
/*!40000 ALTER TABLE `trackings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `translation_bundles`
--

DROP TABLE IF EXISTS `translation_bundles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translation_bundles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `bulk` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_translation_bundles_on_version` (`version`)
) ENGINE=InnoDB AUTO_INCREMENT=372 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `translation_bundles`
--

LOCK TABLES `translation_bundles` WRITE;
/*!40000 ALTER TABLE `translation_bundles` DISABLE KEYS */;
INSERT INTO `translation_bundles` VALUES (150,20091119125404,0,'2009-11-19 13:33:48'),(193,20091115131536,1,'2009-11-20 12:18:30'),(194,20091117140927,0,'2009-11-20 12:18:30'),(195,20091117143443,0,'2009-11-20 12:18:31'),(196,20091117152814,0,'2009-11-20 12:18:31'),(197,20091117155445,0,'2009-11-20 12:18:31'),(198,20091117160525,0,'2009-11-20 12:18:31'),(199,20091117181025,0,'2009-11-20 12:18:31'),(200,20091117181525,0,'2009-11-20 12:18:31'),(201,20091118160204,0,'2009-11-20 12:18:31'),(202,20091118192940,0,'2009-11-20 12:18:31'),(203,20091119124537,0,'2009-11-20 12:18:31'),(204,20091119133948,0,'2009-11-20 12:18:32'),(205,20091119135352,0,'2009-11-20 12:18:32'),(206,20091119170156,0,'2009-11-20 12:18:32'),(207,20091119181341,0,'2009-11-20 12:18:32'),(208,20091120105544,0,'2009-11-20 12:18:32'),(209,20091120121543,0,'2009-11-20 12:18:32'),(210,20091120150625,0,'2009-11-20 15:07:41'),(211,20091120150626,0,'2009-11-20 15:11:10'),(212,20091120203731,0,'2009-11-21 13:31:47'),(213,20091120231706,0,'2009-11-21 13:32:29'),(214,20091120233109,0,'2009-11-21 13:33:06'),(215,20091121050929,0,'2009-11-21 13:33:06'),(216,20091121162144,0,'2009-11-23 19:30:16'),(217,20091123142309,0,'2009-11-23 19:30:16'),(218,20091123193503,0,'2009-11-23 22:09:28'),(219,20091123221809,0,'2009-11-25 15:22:49'),(220,20091123230252,0,'2009-11-25 15:22:49'),(221,20091124182205,0,'2009-11-25 15:22:49'),(222,20091126194909,0,'2009-11-30 17:43:55'),(223,20091130180252,0,'2009-12-07 23:23:43'),(224,20091207231627,0,'2009-12-07 23:23:43'),(225,20091204093441,0,'2009-12-09 18:00:59'),(226,20091209000647,0,'2009-12-09 18:01:00'),(227,20091209191847,0,'2009-12-09 20:05:06'),(228,20091209194347,0,'2009-12-09 20:05:06'),(229,20091209003339,0,'2009-12-16 22:07:30'),(230,20091210205937,0,'2009-12-16 22:07:31'),(231,20091214123150,0,'2009-12-16 22:07:31'),(232,20091216220438,0,'2009-12-16 22:33:04'),(233,20091217142710,0,'2010-01-14 12:47:44'),(234,20091218100654,0,'2010-01-14 12:47:44'),(235,20091218114420,0,'2010-01-14 12:47:44'),(236,20091218214044,0,'2010-01-14 12:47:44'),(237,20091219225228,0,'2010-01-14 12:47:44'),(238,20091224125511,0,'2010-01-14 12:47:44'),(239,20091225092930,0,'2010-01-14 12:47:45'),(240,20091225185706,0,'2010-01-14 12:47:45'),(241,20100111191151,0,'2010-01-14 12:47:45'),(242,20100114230820,0,'2010-01-14 12:47:46'),(243,20100114230920,0,'2010-01-14 12:47:46'),(244,20100115011020,0,'2010-01-15 11:40:21'),(245,20101215220703,0,'2010-01-15 11:40:21'),(246,20100115104503,0,'2010-01-15 11:52:16'),(247,20100115115215,0,'2010-01-15 11:52:16'),(248,20100115163906,0,'2010-01-15 16:39:08'),(249,20100115220703,0,'2010-01-22 15:20:41'),(250,20100122130103,0,'2010-01-22 15:20:41'),(251,20100122162608,0,'2010-01-22 16:28:30'),(252,20100122204115,0,'2010-01-24 16:13:45'),(253,20100122224426,0,'2010-01-24 16:13:46'),(254,20100124162826,0,'2010-01-28 15:54:59'),(255,20100127204747,0,'2010-01-28 15:55:03'),(256,20100127205638,0,'2010-01-28 15:55:07'),(257,20100127233307,0,'2010-01-28 15:55:09'),(258,20100128225739,0,'2010-02-01 09:37:55'),(259,20100129222153,0,'2010-02-01 09:37:55'),(260,20100202105627,0,'2010-02-02 14:05:07'),(261,20100202124027,0,'2010-02-02 14:12:19'),(262,20100202130529,0,'2010-02-02 14:12:19'),(263,20100202162306,0,'2010-02-02 22:51:34'),(264,20100202221929,0,'2010-02-02 22:51:35'),(265,20100202224329,0,'2010-02-02 22:51:35'),(266,20100202183905,0,'2010-02-04 21:54:45'),(267,20100203125244,0,'2010-02-04 21:54:46'),(268,20100204204044,0,'2010-02-04 21:54:47'),(269,20100204221640,0,'2010-02-04 22:27:03'),(270,20100204205044,0,'2010-02-04 22:33:24'),(271,20100204205544,0,'2010-02-06 14:33:16'),(272,20100205191514,0,'2010-02-06 14:33:17'),(273,20100205195059,0,'2010-02-06 14:33:17'),(274,20100205201805,0,'2010-02-06 14:33:17'),(275,20100210091933,0,'2010-02-11 20:11:58'),(276,20100210233444,0,'2010-02-11 20:11:58'),(277,20100211200844,0,'2010-02-11 20:11:59'),(278,20100210235323,0,'2010-02-25 21:15:58'),(279,20100212180114,0,'2010-02-25 21:15:59'),(280,20100212234846,0,'2010-02-25 21:16:00'),(281,20100215014402,0,'2010-02-25 21:16:00'),(282,20100221172949,0,'2010-02-25 21:16:00'),(283,20100223120000,0,'2010-02-25 21:16:00'),(284,20100223234514,0,'2010-02-25 21:16:02'),(285,20100224214419,0,'2010-02-25 21:16:02'),(286,20100225172957,0,'2010-02-25 21:16:03'),(287,20100226004206,0,'2010-02-26 10:37:30'),(288,20100226231627,0,'2010-02-26 23:50:05'),(289,20100227214123,0,'2010-03-01 18:15:54'),(290,20100301103023,0,'2010-03-01 18:15:55'),(291,20100301122920,0,'2010-03-01 18:15:55'),(292,20100301131652,0,'2010-03-01 18:15:55'),(293,20100302101750,0,'2010-03-03 16:41:34'),(294,20100302103127,0,'2010-03-03 16:41:35'),(295,20100302155352,0,'2010-03-03 16:41:35'),(296,20100302200525,0,'2010-03-03 16:41:35'),(297,20100303164846,0,'2010-03-05 13:25:43'),(298,20100305132614,0,'2010-03-05 13:32:31'),(299,20100305133014,0,'2010-03-05 13:32:31'),(300,20100311042933,0,'2010-03-11 10:43:39'),(301,20100311050127,0,'2010-03-11 10:43:39'),(302,20100311200700,1,'2010-03-12 14:18:33'),(303,20100311224020,0,'2010-03-12 14:18:33'),(304,20100312220904,0,'2010-03-15 20:26:52'),(305,20100312221202,0,'2010-03-15 20:26:52'),(306,20100312230623,0,'2010-03-15 20:26:53'),(307,20100315203537,0,'2010-03-15 20:42:06'),(310,20100316191737,0,'2010-03-16 21:27:04'),(311,20100316173215,0,'2010-03-22 13:32:13'),(312,20100316183416,0,'2010-03-22 13:32:13'),(313,20100316183756,0,'2010-03-22 13:32:13'),(314,20100316185806,0,'2010-03-22 13:32:13'),(315,20100317073413,0,'2010-03-22 13:32:13'),(316,20100317111014,0,'2010-03-22 13:32:13'),(317,20100318174137,0,'2010-03-22 13:32:13'),(318,20100320075058,0,'2010-03-22 13:32:14'),(319,20100320083302,0,'2010-03-22 13:32:15'),(320,20100323085411,0,'2010-03-23 11:19:05'),(321,20100323122314,0,'2010-03-23 11:19:05'),(322,20100323142714,0,'2010-03-26 20:55:29'),(323,20100323183614,0,'2010-03-26 20:55:30'),(324,20100323194145,0,'2010-03-26 20:55:37'),(325,20100323205725,0,'2010-03-26 20:55:47'),(326,20100323211332,0,'2010-03-26 20:55:48'),(327,20100323212233,0,'2010-03-26 20:55:49'),(328,20100325104042,0,'2010-03-26 20:55:53'),(329,20100325121433,0,'2010-03-26 20:55:53'),(330,20100325155733,0,'2010-03-26 20:55:54'),(331,20100325192533,0,'2010-03-26 20:55:54'),(332,20100326144233,0,'2010-03-26 20:55:54'),(333,20100326122617,0,'2010-03-26 21:33:55'),(334,20100326193357,0,'2010-03-26 21:33:56'),(335,20100326214901,0,'2010-03-29 15:35:13'),(336,20100327002501,0,'2010-03-29 15:35:13'),(337,20100329195929,0,'2010-03-29 22:03:13'),(338,20100330115448,0,'2010-03-30 17:48:47'),(339,20100330182248,0,'2010-03-31 16:08:13'),(340,20100331092112,0,'2010-03-31 16:08:14'),(341,20100401082713,0,'2010-04-05 06:19:21'),(342,20100403054617,0,'2010-04-05 06:19:21'),(343,20100405120624,0,'2010-04-09 20:12:31'),(344,20100407062935,0,'2010-04-09 20:12:32'),(345,20100407065357,0,'2010-04-09 20:12:32'),(346,20100407073439,0,'2010-04-09 20:12:33'),(347,20100408055823,0,'2010-04-09 20:12:33'),(348,20100409064413,0,'2010-04-09 20:12:33'),(349,20100409202215,0,'2010-04-29 17:31:30'),(350,20100410000341,0,'2010-04-29 17:31:30'),(351,20100411074440,0,'2010-04-29 17:31:31'),(352,20100412074626,0,'2010-04-29 17:31:31'),(353,20100416105225,0,'2010-04-29 17:31:33'),(354,20100416213848,0,'2010-04-29 17:31:33'),(355,20100419033657,0,'2010-04-29 17:31:33'),(356,20100419042935,0,'2010-04-29 17:31:33'),(357,20100419071254,0,'2010-04-29 17:31:33'),(358,20100419134836,0,'2010-04-29 17:31:33'),(359,20100420214824,0,'2010-04-29 17:31:33'),(360,20100422070021,0,'2010-04-29 17:31:33'),(361,20100422205132,0,'2010-04-29 17:31:34'),(362,20100423000257,0,'2010-04-29 17:31:34'),(363,20100423063510,0,'2010-04-29 17:31:34'),(364,20100426091910,0,'2010-04-29 17:31:34'),(365,20100430084019,0,'2010-05-06 07:53:51'),(366,20100430084112,0,'2010-05-06 07:53:51'),(367,20100503062506,0,'2010-05-06 07:53:52'),(368,20100504083446,0,'2010-05-06 07:53:52'),(369,20100505121157,0,'2010-05-06 07:53:52'),(370,20100505124103,0,'2010-05-06 07:53:52'),(371,20100505130146,0,'2010-05-06 07:53:52');
/*!40000 ALTER TABLE `translation_bundles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address_book_items`
--

DROP TABLE IF EXISTS `user_address_book_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_address_book_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address_book_items`
--

LOCK TABLES `user_address_book_items` WRITE;
/*!40000 ALTER TABLE `user_address_book_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_address_book_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_change_notification_to_realtimes`
--

DROP TABLE IF EXISTS `user_change_notification_to_realtimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_change_notification_to_realtimes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT '',
  `user_id` int(11) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT '0',
  `token` varchar(255) DEFAULT '',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_change_notification_to_realtimes`
--

LOCK TABLES `user_change_notification_to_realtimes` WRITE;
/*!40000 ALTER TABLE `user_change_notification_to_realtimes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_change_notification_to_realtimes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_flashes`
--

DROP TABLE IF EXISTS `user_flashes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_flashes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_flashes_on_user_id_and_key` (`user_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_flashes`
--

LOCK TABLES `user_flashes` WRITE;
/*!40000 ALTER TABLE `user_flashes` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_flashes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_kroogs`
--

DROP TABLE IF EXISTS `user_kroogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_kroogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `relationshiptype_id` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  `updated_by_id` int(11) NOT NULL DEFAULT '0',
  `teaser_db_store_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `open` tinyint(1) DEFAULT '1',
  `can_request_invite` tinyint(1) DEFAULT '0',
  `name_ru` varchar(255) DEFAULT NULL,
  `name_fr` varchar(255) DEFAULT NULL,
  `teaser_db_store_ru_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_kroogi_settings_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1085 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_kroogs`
--

LOCK TABLES `user_kroogs` WRITE;
/*!40000 ALTER TABLE `user_kroogs` DISABLE KEYS */;
INSERT INTO `user_kroogs` VALUES (37,2,2,NULL,'2008-05-14 18:05:56','2008-06-12 00:25:00',8,8,NULL,NULL,0,1,NULL,NULL,NULL),(38,2,5,NULL,'2008-05-14 18:06:04','2008-06-12 00:25:00',8,8,NULL,NULL,1,1,NULL,NULL,NULL),(39,2,1,NULL,'2008-05-14 18:07:05','2008-06-12 00:25:00',8,8,NULL,NULL,0,0,NULL,NULL,NULL),(197,2,3,NULL,'2008-09-10 21:15:25','2008-09-10 21:15:25',2,2,NULL,NULL,0,1,NULL,NULL,NULL),(198,2,4,NULL,'2008-09-10 21:15:25','2008-09-10 21:15:25',2,2,NULL,NULL,0,1,NULL,NULL,NULL),(274,1,1,NULL,'2008-09-18 18:03:55','2008-09-18 18:03:55',1,1,NULL,NULL,0,0,NULL,NULL,NULL),(275,1,2,NULL,'2008-09-18 18:03:55','2008-09-18 18:03:55',1,1,NULL,NULL,0,1,NULL,NULL,NULL),(276,1,5,NULL,'2008-09-18 18:03:55','2008-09-18 18:03:55',1,1,NULL,NULL,1,1,NULL,NULL,NULL),(1074,441,2,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',-1,-1,2612,NULL,0,1,NULL,NULL,2611),(1075,441,5,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',-1,-1,2614,NULL,1,1,NULL,NULL,2613),(1076,442,1,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',-1,-1,2616,NULL,0,0,NULL,NULL,2615),(1077,442,4,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',-1,-1,2618,NULL,0,1,NULL,NULL,2617),(1078,442,5,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',-1,-1,2620,NULL,1,1,NULL,NULL,2619),(1079,442,0,NULL,'2010-06-24 13:49:32','2010-06-24 13:49:32',-1,-1,NULL,NULL,0,0,NULL,NULL,NULL),(1080,443,1,NULL,'2010-06-25 15:49:26','2010-06-25 15:49:27',441,441,2622,NULL,0,0,NULL,NULL,2621),(1081,443,4,NULL,'2010-06-25 15:49:26','2010-06-25 15:49:27',441,441,2624,NULL,0,1,NULL,NULL,2623),(1082,443,5,NULL,'2010-06-25 15:49:26','2010-06-25 15:49:27',441,441,2626,NULL,1,1,NULL,NULL,2625),(1083,443,0,NULL,'2010-06-25 15:49:27','2010-06-25 15:49:27',441,441,NULL,NULL,0,0,NULL,NULL,NULL),(1084,444,5,NULL,'2010-07-13 17:21:07','2010-07-13 17:21:07',-1,-1,2628,NULL,1,1,NULL,NULL,2627);
/*!40000 ALTER TABLE `user_kroogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(30) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `crypted_password` varchar(60) NOT NULL,
  `salt` varchar(60) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '1',
  `updated_by_id` int(11) NOT NULL DEFAULT '1',
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `type` varchar(32) DEFAULT 'User',
  `on_behalf_id` int(11) NOT NULL DEFAULT '0',
  `state` varchar(255) DEFAULT 'active',
  `state_changed_at` datetime DEFAULT NULL,
  `display_name_ru` varchar(255) DEFAULT NULL,
  `display_name_fr` varchar(255) DEFAULT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `email_verified` varchar(255) DEFAULT NULL,
  `popularity` float DEFAULT '0',
  `sid` varchar(255) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `birthdate_visiblity` tinyint(1) DEFAULT '0',
  `upload_quota_mb` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`),
  KEY `index_users_on_popularity` (`popularity`),
  KEY `users_state_and_login` (`state`,`login`),
  KEY `users_state_and_display_name` (`state`,`display_name`),
  KEY `users_state_and_display_name_ru` (`state`,`display_name_ru`),
  KEY `index_users_on_sid` (`sid`),
  KEY `index_users_on_created_at` (`created_at`),
  KEY `index_users_on_activated_at` (`activated_at`),
  KEY `index_users_on_email` (`email`),
  KEY `index_users_on_on_behalf_id` (`on_behalf_id`)
) ENGINE=InnoDB AUTO_INCREMENT=445 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'guest','anonymous user','anon@kroogi.com','fe48d7a8a566cae95abdf75205d8f6647976f308','451e3808ca101d314a16d8435c47f05a69fdeb3b','2007-05-17 00:07:24','2008-11-25 17:31:02',1,1,NULL,NULL,NULL,'2007-05-17 00:07:24','BasicUser',0,'active',NULL,'anonymous',NULL,0,'anon@kroogi.com',0,'stub',NULL,NULL,'1674-01-01',0,1024),(2,'chief','The big cahuna','chief@your-net-works.com','cee87e5c076d00fe04b67112d982ac53d94ff95c','2448ace922f2c935e6a67779280f4b6d8bf2a9d6','2007-05-17 00:07:24','2010-08-25 14:54:59',1,2,NULL,NULL,NULL,'2007-05-17 00:07:24','AdvancedUser',0,'active',NULL,'chief',NULL,0,'chief@your-net-works.com',2.44945,NULL,NULL,'en','1674-01-01',0,1024),(441,'joe','joe magnificient','joe@kroogi.al','81c46bb69d1ecb267902810ec2149ef6a3f263b0','186934e51e14115321dbed8c7ff99aa8730ab8b0','2010-06-24 13:49:31','2010-08-25 14:55:05',1,441,NULL,NULL,NULL,'2010-06-24 13:49:53','AdvancedUser',0,'active',NULL,'',NULL,0,NULL,0,'stub','M','en','1980-06-01',1,1024),(442,'deleted_joes-band_1','joes-band','joe@kroogi.al','stub',NULL,'2010-06-24 13:49:32','2010-06-25 15:49:07',1,441,NULL,NULL,NULL,NULL,'Project',0,'deleted','2010-06-25 15:49:07',NULL,NULL,0,NULL,0,NULL,NULL,NULL,'1674-01-01',0,1024),(443,'avatar-band','avatar-band','joe@kroogi.al','stub',NULL,'2010-06-25 15:49:26','2010-06-28 18:38:16',1,441,NULL,NULL,NULL,NULL,'Project',0,'active',NULL,'',NULL,0,NULL,0,NULL,NULL,NULL,'1674-01-01',0,1024),(444,'basic','i\'m too basic','basic@kroogi.al','01153d7c204879cd0b32465a5803a32b5bf55eaa','a51c6252c930ea93b43ba444c6b15e2712461f3f','2010-07-13 17:21:07','2010-07-19 14:59:21',1,444,NULL,NULL,NULL,'2010-07-13 17:21:42','BasicUser',0,'active',NULL,'',NULL,0,NULL,0,NULL,'M','en','1980-06-01',0,1024);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venues`
--

DROP TABLE IF EXISTS `venues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `venues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `homepage` varchar(255) DEFAULT NULL,
  `house_party` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venues`
--

LOCK TABLES `venues` WRITE;
/*!40000 ALTER TABLE `venues` DISABLE KEYS */;
/*!40000 ALTER TABLE `venues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `points` int(11) DEFAULT '0',
  `about` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `voteable_type` varchar(255) DEFAULT NULL,
  `voteable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_votes_on_voteable_type_and_voteable_id` (`voteable_type`,`voteable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votes`
--

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `web_money_invoices`
--

DROP TABLE IF EXISTS `web_money_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `web_money_invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receiver_account_setting_id` int(11) DEFAULT NULL,
  `sender_account_setting_id` int(11) DEFAULT NULL,
  `source_wmid` varchar(255) DEFAULT NULL,
  `destination_wmid` varchar(255) DEFAULT NULL,
  `purse_type` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `success` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `invoice_number` varchar(255) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `log` text,
  `web_money_ticket_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_web_money_invoices_on_receiver_account_setting_id` (`receiver_account_setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `web_money_invoices`
--

LOCK TABLES `web_money_invoices` WRITE;
/*!40000 ALTER TABLE `web_money_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `web_money_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `web_money_tickets`
--

DROP TABLE IF EXISTS `web_money_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `web_money_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `web_money_tickets`
--

LOCK TABLES `web_money_tickets` WRITE;
/*!40000 ALTER TABLE `web_money_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `web_money_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `web_money_transfers`
--

DROP TABLE IF EXISTS `web_money_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `web_money_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receiver_account_setting_id` varchar(255) DEFAULT NULL,
  `sender_account_setting_id` varchar(255) DEFAULT NULL,
  `source_wmid` varchar(255) DEFAULT NULL,
  `destination_wmid` varchar(255) DEFAULT NULL,
  `purse_type` int(11) DEFAULT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `success` tinyint(1) DEFAULT NULL,
  `response` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `web_money_ticket_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `web_money_transfers`
--

LOCK TABLES `web_money_transfers` WRITE;
/*!40000 ALTER TABLE `web_money_transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `web_money_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `what_you_likes`
--

DROP TABLE IF EXISTS `what_you_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `what_you_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `related_user_id` int(11) DEFAULT NULL,
  `relationshiptype_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `what_you_likes`
--

LOCK TABLES `what_you_likes` WRITE;
/*!40000 ALTER TABLE `what_you_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `what_you_likes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-02-23 15:36:35
