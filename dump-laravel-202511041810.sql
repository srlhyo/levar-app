/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: laravel
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `bag_snapshots`
--

DROP TABLE IF EXISTS `bag_snapshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bag_snapshots` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `move_id` bigint unsigned NOT NULL,
  `total_kg` decimal(6,2) NOT NULL DEFAULT '0.00',
  `pending_count` int NOT NULL DEFAULT '0',
  `decided_count` int NOT NULL DEFAULT '0',
  `yes_kg` decimal(8,2) NOT NULL DEFAULT '0.00',
  `yes_dimensions` json DEFAULT NULL,
  `meta` json DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bag_snapshots_move_id_unique` (`move_id`),
  CONSTRAINT `bag_snapshots_move_id_foreign` FOREIGN KEY (`move_id`) REFERENCES `moves` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bag_snapshots`
--

LOCK TABLES `bag_snapshots` WRITE;
/*!40000 ALTER TABLE `bag_snapshots` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bag_snapshots` VALUES
(1,1,107.19,11,28,34.00,'[{\"width\": 30, \"height\": 22, \"length\": 69, \"volume\": 45540}, {\"width\": 39, \"height\": 17, \"length\": 61, \"volume\": 40443}, {\"width\": 57, \"height\": 33, \"length\": 47, \"volume\": 88407}, {\"width\": 20, \"height\": 23, \"length\": 82, \"volume\": 37720}, {\"width\": 44, \"height\": 14, \"length\": 73, \"volume\": 44968}, {\"width\": 53, \"height\": 22, \"length\": 90, \"volume\": 104940}, {\"width\": 39, \"height\": 37, \"length\": 56, \"volume\": 80808}, {\"width\": 50, \"height\": 23, \"length\": 57, \"volume\": 65550}, {\"width\": 33, \"height\": 14, \"length\": 28, \"volume\": 12936}, {\"width\": 59, \"height\": 14, \"length\": 67, \"volume\": 55342}, {\"width\": 58, \"height\": 12, \"length\": 47, \"volume\": 32712}, {\"width\": 34, \"height\": 25, \"length\": 57, \"volume\": 48450}, {\"width\": 45, \"height\": 37, \"length\": 85, \"volume\": 141525}, {\"width\": 25, \"height\": 37, \"length\": 76, \"volume\": 70300}, {\"width\": 44, \"height\": 40, \"length\": 60, \"volume\": 105600}, {\"width\": 21, \"height\": 18, \"length\": 75, \"volume\": 28350}, {\"width\": 60, \"height\": 28, \"length\": 69, \"volume\": 115920}]','[{\"code\": \"A\", \"name\": \"Mala A\", \"bag_id\": 1, \"yes_kg\": 12.8, \"total_kg\": 12.8, \"packed_kg\": 9.86, \"dimensions\": \"78 × 50 × 30 cm\", \"capacity_kg\": 23, \"remaining_kg\": 10.2, \"total_volume_cm3\": 571391, \"capacity_volume_cm3\": 117000}, {\"code\": \"B\", \"name\": \"Mala B\", \"bag_id\": 2, \"yes_kg\": 21.2, \"total_kg\": 21.2, \"packed_kg\": 17.51, \"dimensions\": \"75 × 48 × 28 cm\", \"capacity_kg\": 23, \"remaining_kg\": 1.8000000000000007, \"total_volume_cm3\": 548120, \"capacity_volume_cm3\": 100800}]','2025-11-04 15:22:36');
/*!40000 ALTER TABLE `bag_snapshots` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `bags`
--

DROP TABLE IF EXISTS `bags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bags` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `move_id` bigint unsigned NOT NULL,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity_kg` decimal(5,2) NOT NULL DEFAULT '23.00',
  `dimensions` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bags_move_id_code_unique` (`move_id`,`code`),
  KEY `bags_move_id_sort_order_index` (`move_id`,`sort_order`),
  CONSTRAINT `bags_move_id_foreign` FOREIGN KEY (`move_id`) REFERENCES `moves` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bags`
--

LOCK TABLES `bags` WRITE;
/*!40000 ALTER TABLE `bags` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bags` VALUES
(1,1,'Mala A','A',23.00,'78 × 50 × 30 cm',0,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(2,1,'Mala B','B',23.00,'75 × 48 × 28 cm',1,'2025-11-04 15:19:57','2025-11-04 15:19:57');
/*!40000 ALTER TABLE `bags` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `decision_logs`
--

DROP TABLE IF EXISTS `decision_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `decision_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint unsigned NOT NULL,
  `from_decision` enum('undecided','pending','yes','no') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_decision` enum('undecided','pending','yes','no') COLLATE utf8mb4_unicode_ci NOT NULL,
  `context` json DEFAULT NULL,
  `decided_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `decision_logs_decided_by_foreign` (`decided_by`),
  KEY `decision_logs_item_id_created_at_index` (`item_id`,`created_at`),
  CONSTRAINT `decision_logs_decided_by_foreign` FOREIGN KEY (`decided_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `decision_logs_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decision_logs`
--

LOCK TABLES `decision_logs` WRITE;
/*!40000 ALTER TABLE `decision_logs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `decision_logs` VALUES
(1,1,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-25 15:19:57'),
(2,2,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:19:57'),
(3,2,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:24:57'),
(4,3,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-25 15:19:57'),
(5,4,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:19:57'),
(6,4,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:24:57'),
(7,4,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:29:57'),
(8,5,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:19:57'),
(9,5,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-03 15:24:57'),
(10,5,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-31 15:29:57'),
(11,6,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-27 15:19:57'),
(12,6,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:24:57'),
(13,7,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:19:57'),
(14,7,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:24:57'),
(15,7,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 15:29:57'),
(16,8,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:19:57'),
(17,8,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-03 15:24:57'),
(18,8,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:29:57'),
(19,9,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-01 15:19:57'),
(20,10,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-25 15:19:57'),
(21,10,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-03 15:24:57'),
(22,10,'no','pending','{\"source\": \"deck\"}',NULL,'2025-11-03 15:29:57'),
(23,11,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:19:57'),
(24,12,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-25 15:19:57'),
(25,12,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:24:57'),
(26,13,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:19:57'),
(27,14,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:19:57'),
(28,15,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:19:57'),
(29,15,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-28 15:24:57'),
(30,15,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:29:57'),
(31,16,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:19:57'),
(32,17,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-25 15:19:57'),
(33,18,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:19:57'),
(34,18,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:24:57'),
(35,18,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:29:57'),
(36,19,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-28 15:19:57'),
(37,20,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-30 15:19:57'),
(38,20,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-25 15:24:57'),
(39,20,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:29:57'),
(40,21,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:19:57'),
(41,21,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:24:57'),
(42,21,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-29 15:29:57'),
(43,22,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-27 15:19:57'),
(44,22,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:24:57'),
(45,23,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-28 15:19:57'),
(46,23,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:24:57'),
(47,23,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:29:57'),
(48,24,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-30 15:19:57'),
(49,24,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:24:57'),
(50,24,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-03 15:29:57'),
(51,25,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-01 15:19:57'),
(52,25,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:24:57'),
(53,25,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-03 15:29:57'),
(54,26,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-25 15:19:57'),
(55,26,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 15:24:57'),
(56,27,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 15:19:57'),
(57,28,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:19:57'),
(58,29,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:19:57'),
(59,29,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:24:57'),
(60,30,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:19:57'),
(61,31,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-03 15:19:57'),
(62,31,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:24:57'),
(63,32,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:19:57'),
(64,33,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:19:57'),
(65,34,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:19:57'),
(66,35,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-26 15:19:57'),
(67,36,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:19:57'),
(68,36,'no','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 15:24:57'),
(69,36,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:29:57'),
(70,37,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:19:57'),
(71,37,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 15:24:57'),
(72,38,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-30 15:19:57'),
(73,38,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-28 15:24:57'),
(74,38,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:29:57'),
(75,39,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-27 15:19:57'),
(76,39,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:24:57'),
(77,40,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:19:57'),
(78,40,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:24:57'),
(79,40,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:29:57'),
(80,41,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:19:57'),
(81,41,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:24:57'),
(82,41,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:29:57'),
(83,42,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:19:57'),
(84,43,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:19:57'),
(85,43,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:24:57'),
(86,44,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:19:57'),
(87,44,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:24:57'),
(88,44,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:29:57'),
(89,45,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:19:57'),
(90,46,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-30 15:19:57'),
(91,47,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:19:57'),
(92,48,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-25 15:19:57'),
(93,49,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:19:57'),
(94,49,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:24:57'),
(95,49,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:29:57'),
(96,50,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-31 15:19:57'),
(97,50,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-25 15:24:57'),
(98,50,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:29:57'),
(99,51,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:19:57'),
(100,52,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-26 15:19:57'),
(101,52,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-27 15:24:57'),
(102,52,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:29:57'),
(103,53,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:19:57'),
(104,53,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:24:57'),
(105,54,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:19:57'),
(106,54,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-30 15:24:57'),
(107,54,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 15:29:57'),
(108,55,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:19:57'),
(109,55,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-31 15:24:57'),
(110,56,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-25 15:19:57'),
(111,56,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-30 15:24:57'),
(112,56,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:29:57'),
(113,57,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:19:57'),
(114,57,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-28 15:24:57'),
(115,57,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-27 15:29:57'),
(116,58,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:19:57'),
(117,58,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:24:57'),
(118,58,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:29:57'),
(119,59,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:19:57'),
(120,60,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-10-28 15:19:57'),
(121,60,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-30 15:24:57'),
(122,60,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-25 15:29:57');
/*!40000 ALTER TABLE `decision_logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `item_media`
--

DROP TABLE IF EXISTS `item_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_media` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `item_id` bigint unsigned NOT NULL,
  `disk` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumb_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('queued','uploading','done','error') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'done',
  `bytes` bigint unsigned DEFAULT NULL,
  `width` int unsigned DEFAULT NULL,
  `height` int unsigned DEFAULT NULL,
  `mime` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uploaded_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_media_uploaded_by_foreign` (`uploaded_by`),
  KEY `item_media_item_id_index` (`item_id`),
  KEY `item_media_status_index` (`status`),
  CONSTRAINT `item_media_item_id_foreign` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_media_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_media`
--

LOCK TABLES `item_media` WRITE;
/*!40000 ALTER TABLE `item_media` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `item_media` VALUES
(1,4,'local','items/5526efc1-f198-446c-ac31-b0b95d961001.png','items/thumbs/5526efc1-f198-446c-ac31-b0b95d961001.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(2,12,'local','items/5f426618-dcf6-4cd2-bf70-db6ef80b89e7.png','items/thumbs/5f426618-dcf6-4cd2-bf70-db6ef80b89e7.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(3,13,'local','items/4f2fb24c-7a99-40ca-bde0-c751fad494b4.png','items/thumbs/4f2fb24c-7a99-40ca-bde0-c751fad494b4.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(4,17,'local','items/456b0e1b-07cc-4f2b-b987-ae26928333f9.png','items/thumbs/456b0e1b-07cc-4f2b-b987-ae26928333f9.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(5,20,'local','items/b342fc61-2cb8-487b-80be-5820863c70ca.png','items/thumbs/b342fc61-2cb8-487b-80be-5820863c70ca.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(6,21,'local','items/e5c0cc75-4370-41e4-8a1f-f804a384ef62.png','items/thumbs/e5c0cc75-4370-41e4-8a1f-f804a384ef62.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(7,22,'local','items/576df197-21c5-448e-b636-73324d559c90.png','items/thumbs/576df197-21c5-448e-b636-73324d559c90.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(8,24,'local','items/ef644da4-8972-404a-8f88-8fea0f0920d5.png','items/thumbs/ef644da4-8972-404a-8f88-8fea0f0920d5.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(9,29,'local','items/447d8303-7693-4ca9-8c38-6786738bf6b8.png','items/thumbs/447d8303-7693-4ca9-8c38-6786738bf6b8.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(10,36,'local','items/a71bc9ac-b4c6-42d6-bdbc-c445695d4200.png','items/thumbs/a71bc9ac-b4c6-42d6-bdbc-c445695d4200.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(11,39,'local','items/fbb42e94-d059-478a-a088-3bbc0caf3183.png','items/thumbs/fbb42e94-d059-478a-a088-3bbc0caf3183.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(12,43,'local','items/0a93564c-e9af-417b-acc5-143884d44c94.png','items/thumbs/0a93564c-e9af-417b-acc5-143884d44c94.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(13,44,'local','items/7d130b00-cb7f-45fa-8d07-9f846c3dde6e.png','items/thumbs/7d130b00-cb7f-45fa-8d07-9f846c3dde6e.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(14,54,'local','items/03e84209-ba37-4366-8f4e-84da336c9153.png','items/thumbs/03e84209-ba37-4366-8f4e-84da336c9153.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(15,55,'local','items/80cee7cf-3085-4fe5-9485-1cfa9baafb09.png','items/thumbs/80cee7cf-3085-4fe5-9485-1cfa9baafb09.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(16,56,'local','items/65b8656b-5ab1-46bf-9bea-ee087b5f2b7e.png','items/thumbs/65b8656b-5ab1-46bf-9bea-ee087b5f2b7e.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57'),
(17,60,'local','items/c39d8a50-9daa-4d56-af92-8a5c9ae3cd49.png','items/thumbs/c39d8a50-9daa-4d56-af92-8a5c9ae3cd49.png','done',70,1,1,'image/png',NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57');
/*!40000 ALTER TABLE `item_media` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `move_id` bigint unsigned NOT NULL,
  `bag_id` bigint unsigned DEFAULT NULL,
  `title` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `volume_cm3` decimal(12,2) DEFAULT NULL,
  `dimensions` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `section` enum('living_room','kitchen','bedroom','office','bathroom','storage','other') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `category` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fragile` tinyint(1) NOT NULL DEFAULT '0',
  `decision` enum('undecided','pending','yes','no') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'undecided',
  `packed_at` timestamp NULL DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `location_hint` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumbnail_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `items_move_id_index` (`move_id`),
  KEY `items_decision_index` (`decision`),
  KEY `items_bag_id_index` (`bag_id`),
  KEY `items_move_id_sort_order_index` (`move_id`,`sort_order`),
  CONSTRAINT `items_bag_id_foreign` FOREIGN KEY (`bag_id`) REFERENCES `bags` (`id`) ON DELETE SET NULL,
  CONSTRAINT `items_move_id_foreign` FOREIGN KEY (`move_id`) REFERENCES `moves` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `items` VALUES
(1,1,NULL,'Suscipit id perspiciatis.',NULL,2.45,12740.00,'35 × 26 × 14 cm','office',NULL,0,'no',NULL,1045,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(2,1,NULL,'Eos ut repellendus labore.',NULL,0.88,19760.00,'40 × 26 × 19 cm','kitchen',NULL,0,'undecided',NULL,67,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(3,1,NULL,'Totam nesciunt sunt.','Dicta itaque maxime cumque excepturi mollitia eum dolorem.',2.02,18224.00,'67 × 16 × 17 cm','storage','debitis',0,'pending',NULL,215,'Eius autem doloribus inventore.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(4,1,2,'Accusamus hic officiis accusamus.','Ullam animi in qui asperiores pariatur sint soluta ex natus architecto dolore possimus sit.',0.94,45540.00,'69 × 30 × 22 cm','bathroom',NULL,0,'yes','2025-11-03 15:19:57',918,NULL,'/storage/items/5526efc1-f198-446c-ac31-b0b95d961001.png','/storage/items/thumbs/5526efc1-f198-446c-ac31-b0b95d961001.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(5,1,NULL,'Qui veniam ullam.',NULL,0.19,36480.00,'80 × 38 × 12 cm','kitchen',NULL,0,'undecided',NULL,100,'Corporis facilis rerum delectus.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(6,1,NULL,'Culpa vero neque eos.','Et ut amet ab dolorum quisquam nobis distinctio odit a natus voluptas aliquam.',2.09,8096.00,'22 × 23 × 16 cm','bedroom','et',0,'pending',NULL,450,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(7,1,1,'Eveniet eius voluptatum reiciendis.',NULL,0.95,40443.00,'61 × 39 × 17 cm','kitchen',NULL,0,'yes','2025-10-30 11:26:30',1092,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(8,1,NULL,'Nesciunt non optio quibusdam.','Nulla natus quia aut deserunt quae maxime.',1.22,65856.00,'49 × 48 × 28 cm','storage',NULL,1,'undecided',NULL,-107,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(9,1,NULL,'Velit et.',NULL,2.30,81216.00,'48 × 47 × 36 cm','storage','blanditiis',1,'undecided',NULL,-161,'Maiores reiciendis.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(10,1,NULL,'Earum quisquam enim tenetur.',NULL,1.91,23100.00,'50 × 33 × 14 cm','kitchen','corrupti',0,'pending',NULL,497,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(11,1,1,'Veritatis sit tempora mollitia.',NULL,0.34,88407.00,'47 × 57 × 33 cm','other',NULL,0,'yes',NULL,910,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(12,1,NULL,'Assumenda distinctio.',NULL,3.49,14840.00,'28 × 53 × 10 cm','bathroom','cumque',1,'no',NULL,730,NULL,'/storage/items/5f426618-dcf6-4cd2-bf70-db6ef80b89e7.png','/storage/items/thumbs/5f426618-dcf6-4cd2-bf70-db6ef80b89e7.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(13,1,NULL,'Maxime sit.','Soluta non sit totam at doloremque et dolore ut et.',1.92,58968.00,'52 × 54 × 21 cm','bathroom',NULL,0,'undecided','2025-10-26 08:52:34',-15,NULL,'/storage/items/4f2fb24c-7a99-40ca-bde0-c751fad494b4.png','/storage/items/thumbs/4f2fb24c-7a99-40ca-bde0-c751fad494b4.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(14,1,NULL,'Ut est quod.','Sapiente quia odio ut temporibus saepe aperiam aspernatur cupiditate.',1.52,9900.00,'30 × 15 × 22 cm','kitchen',NULL,0,'undecided',NULL,133,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(15,1,NULL,'Maxime unde ut.','Alias nam tempore enim et non unde itaque.',1.28,57720.00,'37 × 40 × 39 cm','office','id',1,'pending',NULL,491,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(16,1,NULL,'Totam ipsam deleniti.',NULL,3.20,78840.00,'73 × 36 × 30 cm','bedroom',NULL,0,'undecided',NULL,-115,'Labore molestiae eos.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(17,1,2,'Non laudantium voluptas.','Odit iste placeat sint aliquam eius autem sunt quia.',2.33,37720.00,'82 × 20 × 23 cm','office','officiis',0,'yes',NULL,978,'Maiores ut voluptatem.','/storage/items/456b0e1b-07cc-4f2b-b987-ae26928333f9.png','/storage/items/thumbs/456b0e1b-07cc-4f2b-b987-ae26928333f9.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(18,1,1,'Rerum voluptate saepe.',NULL,2.17,44968.00,'73 × 44 × 14 cm','kitchen',NULL,1,'yes','2025-11-04 15:19:57',611,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(19,1,1,'Aut voluptas maxime in.',NULL,2.60,104940.00,'90 × 53 × 22 cm','other',NULL,1,'yes',NULL,629,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(20,1,NULL,'Recusandae veritatis illum.',NULL,2.08,29820.00,'71 × 30 × 14 cm','bedroom',NULL,1,'no','2025-10-30 16:16:48',1162,'Aut vel aut id.','/storage/items/b342fc61-2cb8-487b-80be-5820863c70ca.png','/storage/items/thumbs/b342fc61-2cb8-487b-80be-5820863c70ca.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(21,1,1,'Et iste dolorum voluptatem.','Blanditiis consectetur quibusdam est esse illo earum qui earum.',2.25,80808.00,'56 × 39 × 37 cm','bedroom',NULL,0,'yes','2025-10-29 19:32:44',608,'Sit perferendis doloribus.','/storage/items/e5c0cc75-4370-41e4-8a1f-f804a384ef62.png','/storage/items/thumbs/e5c0cc75-4370-41e4-8a1f-f804a384ef62.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(22,1,NULL,'Quaerat excepturi laboriosam harum.','Qui natus voluptatem voluptatem adipisci quo nihil voluptas rem.',1.24,46748.00,'29 × 52 × 31 cm','office','omnis',0,'no',NULL,1187,NULL,'/storage/items/576df197-21c5-448e-b636-73324d559c90.png','/storage/items/thumbs/576df197-21c5-448e-b636-73324d559c90.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(23,1,2,'Ex et.',NULL,2.25,65550.00,'57 × 50 × 23 cm','bedroom',NULL,0,'yes','2025-11-03 15:19:57',844,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(24,1,2,'Repudiandae non officia repellat.','Eveniet autem qui recusandae velit eum omnis quidem et laborum.',1.97,12936.00,'28 × 33 × 14 cm','bathroom','illum',1,'yes','2025-10-30 15:19:57',733,NULL,'/storage/items/ef644da4-8972-404a-8f88-8fea0f0920d5.png','/storage/items/thumbs/ef644da4-8972-404a-8f88-8fea0f0920d5.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(25,1,2,'Animi quia nulla pariatur inventore.','Repellat consequatur ipsa tenetur ullam aperiam id quis expedita pariatur nostrum mollitia optio iure.',2.81,55342.00,'67 × 59 × 14 cm','office','at',0,'yes','2025-11-04 15:19:57',647,'Eos fugiat ea.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(26,1,NULL,'Labore fugit.','Eius eligendi quasi vero quo pariatur eum accusamus.',2.00,24548.00,'34 × 38 × 19 cm','bathroom','et',0,'undecided',NULL,-49,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(27,1,NULL,'Eius delectus assumenda voluptate.',NULL,0.62,38760.00,'68 × 30 × 19 cm','bedroom','dolore',0,'undecided',NULL,73,'Quia consequatur officia.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(28,1,NULL,'Ratione officia modi dolores.',NULL,0.56,42550.00,'74 × 23 × 25 cm','kitchen','sint',0,'undecided',NULL,112,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(29,1,NULL,'Eligendi aut vitae aspernatur.','Et officia animi qui porro ea quasi dicta dolorum iste amet consequatur molestiae voluptate.',2.80,43400.00,'25 × 56 × 31 cm','bedroom',NULL,1,'pending','2025-10-28 20:13:56',566,'Ad nesciunt vel.','/storage/items/447d8303-7693-4ca9-8c38-6786738bf6b8.png','/storage/items/thumbs/447d8303-7693-4ca9-8c38-6786738bf6b8.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(30,1,NULL,'Magni ut ut.',NULL,2.57,21275.00,'23 × 37 × 25 cm','office','ullam',1,'no',NULL,990,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(31,1,NULL,'Cum aut non.',NULL,0.36,143325.00,'75 × 49 × 39 cm','kitchen',NULL,0,'pending',NULL,249,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(32,1,NULL,'Mollitia aut explicabo id.','Sed ut modi et impedit architecto quia voluptates illo qui.',2.16,61275.00,'43 × 57 × 25 cm','office',NULL,1,'no',NULL,649,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(33,1,NULL,'Numquam numquam sapiente.',NULL,2.14,65518.00,'82 × 47 × 17 cm','other',NULL,0,'undecided',NULL,-104,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(34,1,NULL,'Est dolores hic.',NULL,2.80,19296.00,'67 × 16 × 18 cm','kitchen','ut',1,'undecided',NULL,177,'Ut est aut eos.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(35,1,NULL,'Sed harum fuga.','Id quisquam earum accusamus voluptas et vitae quis nesciunt et.',2.07,22950.00,'75 × 18 × 17 cm','bedroom',NULL,1,'undecided',NULL,178,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(36,1,NULL,'Voluptas illo recusandae aliquid.',NULL,1.76,83700.00,'45 × 60 × 31 cm','other',NULL,1,'no',NULL,707,NULL,'/storage/items/a71bc9ac-b4c6-42d6-bdbc-c445695d4200.png','/storage/items/thumbs/a71bc9ac-b4c6-42d6-bdbc-c445695d4200.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(37,1,NULL,'Provident non earum.',NULL,0.32,72576.00,'54 × 42 × 32 cm','living_room','laudantium',0,'undecided',NULL,110,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(38,1,NULL,'Laudantium nam iusto.',NULL,1.17,78975.00,'75 × 39 × 27 cm','living_room',NULL,1,'pending',NULL,478,'Impedit minima consectetur fuga et.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(39,1,2,'Ea consectetur doloremque est.','Architecto eligendi occaecati autem nihil neque ut in deleniti non corporis.',1.36,32712.00,'47 × 58 × 12 cm','living_room',NULL,0,'yes',NULL,919,'Vel libero consequuntur exercitationem.','/storage/items/fbb42e94-d059-478a-a088-3bbc0caf3183.png','/storage/items/thumbs/fbb42e94-d059-478a-a088-3bbc0caf3183.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(40,1,NULL,'Quidem necessitatibus iusto sit.',NULL,0.94,54000.00,'27 × 50 × 40 cm','storage',NULL,0,'pending',NULL,316,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(41,1,2,'Aut quasi ullam consequuntur.',NULL,2.21,48450.00,'57 × 34 × 25 cm','bathroom','perspiciatis',0,'yes','2025-10-27 10:49:54',1137,'Debitis mollitia iusto.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(42,1,NULL,'Aspernatur est omnis.','Rem velit et in labore ut repellendus dicta aut et optio et vel.',3.27,16872.00,'24 × 19 × 37 cm','bedroom',NULL,1,'no',NULL,1200,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(43,1,NULL,'Illo quibusdam ut officiis.','Magnam amet ut non voluptates rerum at.',1.35,19720.00,'40 × 17 × 29 cm','bathroom',NULL,1,'no',NULL,775,NULL,'/storage/items/0a93564c-e9af-417b-acc5-143884d44c94.png','/storage/items/thumbs/0a93564c-e9af-417b-acc5-143884d44c94.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(44,1,NULL,'Rem sunt est.','Aut non tempore at reiciendis dolores modi autem et sed.',0.65,101400.00,'65 × 60 × 26 cm','office',NULL,0,'undecided',NULL,148,NULL,'/storage/items/7d130b00-cb7f-45fa-8d07-9f846c3dde6e.png','/storage/items/thumbs/7d130b00-cb7f-45fa-8d07-9f846c3dde6e.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(45,1,NULL,'Aut ut repellat officiis.',NULL,2.48,19250.00,'25 × 35 × 22 cm','bathroom','similique',0,'no',NULL,659,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(46,1,1,'Pariatur rerum quia voluptas.','Pariatur velit atque perferendis fugit dolore omnis ex illum eligendi expedita.',2.76,141525.00,'85 × 45 × 37 cm','bedroom','praesentium',1,'yes','2025-10-29 06:12:47',960,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(47,1,NULL,'Laborum dolor perspiciatis eum.',NULL,2.31,43758.00,'34 × 33 × 39 cm','other',NULL,1,'pending','2025-10-27 03:23:37',364,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(48,1,1,'Quis voluptatem quae qui eaque.','Nostrum explicabo tenetur atque perferendis et placeat atque eaque in culpa commodi quam.',1.73,70300.00,'76 × 25 × 37 cm','kitchen',NULL,0,'yes','2025-10-30 15:19:57',980,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(49,1,NULL,'Repudiandae non suscipit.',NULL,2.76,36432.00,'66 × 24 × 23 cm','kitchen',NULL,0,'pending',NULL,230,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(50,1,2,'Ex minima error.','Repudiandae sint et blanditiis ea soluta iste non eum deserunt impedit.',3.39,105600.00,'60 × 44 × 40 cm','storage',NULL,0,'yes','2025-11-01 15:19:57',800,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(51,1,NULL,'Cumque impedit incidunt ipsum.','Dolorem ea aliquid nostrum officia soluta neque sunt doloribus.',1.28,29610.00,'47 × 35 × 18 cm','kitchen',NULL,0,'no',NULL,991,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(52,1,NULL,'Delectus laboriosam aut veritatis.','Consequuntur est quo provident id delectus tempora.',0.86,47424.00,'38 × 39 × 32 cm','office',NULL,1,'undecided',NULL,52,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(53,1,NULL,'Harum dolorem tempora.',NULL,0.73,11830.00,'26 × 35 × 13 cm','kitchen','cum',0,'undecided',NULL,149,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(54,1,NULL,'Placeat eligendi ducimus.','Tenetur labore aliquid iusto adipisci sunt nemo praesentium omnis minus consequatur libero.',0.85,39556.00,'22 × 58 × 31 cm','other',NULL,0,'undecided','2025-10-29 20:56:11',-129,NULL,'/storage/items/03e84209-ba37-4366-8f4e-84da336c9153.png','/storage/items/thumbs/03e84209-ba37-4366-8f4e-84da336c9153.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(55,1,NULL,'Maiores sit aliquam.',NULL,1.28,29040.00,'33 × 44 × 20 cm','other',NULL,0,'pending',NULL,566,NULL,'/storage/items/80cee7cf-3085-4fe5-9485-1cfa9baafb09.png','/storage/items/thumbs/80cee7cf-3085-4fe5-9485-1cfa9baafb09.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(56,1,2,'Aut saepe.',NULL,2.59,28350.00,'75 × 21 × 18 cm','bedroom','aperiam',1,'yes','2025-10-30 23:16:34',977,NULL,'/storage/items/65b8656b-5ab1-46bf-9bea-ee087b5f2b7e.png','/storage/items/thumbs/65b8656b-5ab1-46bf-9bea-ee087b5f2b7e.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(57,1,NULL,'Dolor quo alias repudiandae.',NULL,0.32,76880.00,'80 × 31 × 31 cm','bedroom',NULL,0,'undecided',NULL,145,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(58,1,NULL,'Architecto sunt qui.',NULL,2.67,71456.00,'44 × 58 × 28 cm','storage',NULL,0,'undecided',NULL,-113,NULL,NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(59,1,NULL,'Repellendus accusamus aut necessitatibus.',NULL,2.32,102960.00,'52 × 55 × 36 cm','kitchen',NULL,1,'undecided',NULL,154,'Unde omnis voluptatem laudantium.',NULL,NULL,'2025-11-04 15:19:57','2025-11-04 15:19:57',NULL),
(60,1,2,'Ut est adipisci ut.',NULL,1.35,115920.00,'69 × 60 × 28 cm','kitchen','nam',0,'yes','2025-10-26 08:00:30',615,NULL,'/storage/items/c39d8a50-9daa-4d56-af92-8a5c9ae3cd49.png','/storage/items/thumbs/c39d8a50-9daa-4d56-af92-8a5c9ae3cd49.png','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `magic_links`
--

DROP TABLE IF EXISTS `magic_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `magic_links` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `magic_links_token_unique` (`token`),
  KEY `magic_links_user_id_foreign` (`user_id`),
  KEY `magic_links_expires_at_index` (`expires_at`),
  CONSTRAINT `magic_links_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `magic_links`
--

LOCK TABLES `magic_links` WRITE;
/*!40000 ALTER TABLE `magic_links` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `magic_links` VALUES
(1,1,'a64b7047-988f-445e-a3e9-c66e54fad9de','2025-11-04 15:37:07','2025-11-04 15:22:36','2025-11-04 15:22:07','2025-11-04 15:22:36');
/*!40000 ALTER TABLE `magic_links` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2025_10_28_203325_create_moves_table',1),
(5,'2025_10_28_203334_create_bags_table',1),
(6,'2025_10_28_203343_create_items_table',1),
(7,'2025_10_28_203351_create_item_media_table',1),
(8,'2025_10_28_203358_create_decision_logs_table',1),
(9,'2025_10_28_203406_create_bag_snapshots_table',1),
(10,'2025_10_29_000000_create_magic_links_table',1),
(11,'2025_10_29_000001_drop_password_columns_from_users_table',1),
(12,'2025_10_29_000002_convert_pending_to_undecided_on_items',1),
(13,'2025_10_29_212557_add_yes_metrics_to_bag_snapshots',1),
(14,'2025_10_29_212705_add_yes_metrics_to_bag_snapshots',1),
(15,'2025_10_29_214822_add_reserved_volume_to_moves_table',1),
(16,'2025_10_30_000100_add_dimensions_to_bags_table',1),
(17,'2025_10_30_010000_add_volume_cm3_to_items_table',1),
(18,'2025_11_02_000000_add_onboarding_flags_to_users_table',1),
(19,'2025_11_03_194416_create_push_subscriptions_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `moves`
--

DROP TABLE IF EXISTS `moves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `moves` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `origin_country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destination_country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reserved_weight_kg` decimal(5,2) NOT NULL DEFAULT '4.00',
  `reserved_volume_cm3` decimal(12,2) NOT NULL DEFAULT '0.00',
  `settings` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `moves_user_id_index` (`user_id`),
  CONSTRAINT `moves_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moves`
--

LOCK TABLES `moves` WRITE;
/*!40000 ALTER TABLE `moves` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `moves` VALUES
(1,1,'GB','BR',4.00,60000.00,'{\"deck_hints\": true}','2025-11-04 15:19:57','2025-11-04 15:19:57',NULL);
/*!40000 ALTER TABLE `moves` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `push_subscriptions`
--

DROP TABLE IF EXISTS `push_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `push_subscriptions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subscribable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subscribable_id` bigint unsigned NOT NULL,
  `endpoint` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `public_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auth_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_encoding` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `push_subscriptions_endpoint_unique` (`endpoint`),
  KEY `push_subscriptions_subscribable_type_subscribable_id_index` (`subscribable_type`,`subscribable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `push_subscriptions`
--

LOCK TABLES `push_subscriptions` WRITE;
/*!40000 ALTER TABLE `push_subscriptions` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `push_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `sessions` VALUES
('dq7xJ8ll6wQUEhRTWS2WbpuCYWVTLcfgimYm5DrW',NULL,'172.24.0.1','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiS0VidWxXOG1LdUpkdnROUjhaaERsMzdjeEo3NHZhT2xvR2RTWjZ6OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6MzoidXJsIjthOjE6e3M6ODoiaW50ZW5kZWQiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCI7fX0=',1762278065),
('VnD8M2d0vLHVt7rkQZvbwcBcMniKAJb4IAtn8V63',NULL,'172.24.0.1','Mozilla/5.0 (X11; Linux x86_64; rv:144.0) Gecko/20100101 Firefox/144.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWnpjb00xZkllVWxISUhPZENnUktnZHZ5YTh3cFV6UFJkakR4SnRjbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1762278081);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `onboarding_history_seen` tinyint(1) NOT NULL DEFAULT '0',
  `onboarding_tour_seen` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'Demo User','demo@example.com',NULL,'2025-11-04 15:19:57','2025-11-04 15:22:46',1,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Dumping routines for database 'laravel'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-11-04 18:10:55
