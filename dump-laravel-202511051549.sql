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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bag_snapshots`
--

LOCK TABLES `bag_snapshots` WRITE;
/*!40000 ALTER TABLE `bag_snapshots` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bag_snapshots` VALUES
(1,1,107.59,6,27,32.04,'[{\"width\": 59, \"height\": 18, \"length\": 56, \"volume\": 59472}, {\"width\": 36, \"height\": 16, \"length\": 69, \"volume\": 39744}, {\"width\": 49, \"height\": 14, \"length\": 86, \"volume\": 58996}, {\"width\": 29, \"height\": 39, \"length\": 53, \"volume\": 59943}, {\"width\": 41, \"height\": 28, \"length\": 54, \"volume\": 61992}, {\"width\": 37, \"height\": 40, \"length\": 86, \"volume\": 127280}, {\"width\": 37, \"height\": 37, \"length\": 88, \"volume\": 120472}, {\"width\": 30, \"height\": 17, \"length\": 60, \"volume\": 30600}, {\"width\": 26, \"height\": 11, \"length\": 83, \"volume\": 23738}, {\"width\": 26, \"height\": 23, \"length\": 34, \"volume\": 20332}, {\"width\": 41, \"height\": 17, \"length\": 26, \"volume\": 18122}, {\"width\": 37, \"height\": 30, \"length\": 20, \"volume\": 22200}, {\"width\": 50, \"height\": 30, \"length\": 58, \"volume\": 87000}, {\"width\": 53, \"height\": 37, \"length\": 44, \"volume\": 86284}, {\"width\": 20, \"height\": 31, \"length\": 52, \"volume\": 32240}, {\"width\": 56, \"height\": 34, \"length\": 56, \"volume\": 106624}]','[{\"code\": \"A\", \"name\": \"Mala A\", \"bag_id\": 1, \"yes_kg\": 19.09, \"total_kg\": 19.09, \"packed_kg\": 15.78, \"dimensions\": \"78 × 50 × 30 cm\", \"capacity_kg\": 23, \"remaining_kg\": 3.91, \"total_volume_cm3\": 397399, \"capacity_volume_cm3\": 117000}, {\"code\": \"B\", \"name\": \"Mala B\", \"bag_id\": 2, \"yes_kg\": 12.95, \"total_kg\": 12.95, \"packed_kg\": 11.36, \"dimensions\": \"75 × 48 × 28 cm\", \"capacity_kg\": 23, \"remaining_kg\": 10.05, \"total_volume_cm3\": 557640, \"capacity_volume_cm3\": 100800}]','2025-11-05 15:45:53'),
(2,2,93.15,11,16,20.17,'[{\"width\": 47, \"height\": 28, \"length\": 20, \"volume\": 26320}, {\"width\": 22, \"height\": 13, \"length\": 84, \"volume\": 24024}, {\"width\": 16, \"height\": 24, \"length\": 38, \"volume\": 14592}, {\"width\": 44, \"height\": 17, \"length\": 85, \"volume\": 63580}, {\"width\": 26, \"height\": 23, \"length\": 64, \"volume\": 38272}, {\"width\": 27, \"height\": 10, \"length\": 33, \"volume\": 8910}, {\"width\": 31, \"height\": 37, \"length\": 71, \"volume\": 81437}, {\"width\": 26, \"height\": 15, \"length\": 70, \"volume\": 27300}, {\"width\": 32, \"height\": 36, \"length\": 66, \"volume\": 76032}]','[{\"code\": \"A\", \"name\": \"Mala A\", \"bag_id\": 3, \"yes_kg\": 8.38, \"total_kg\": 8.38, \"packed_kg\": 3.22, \"dimensions\": \"78 × 50 × 30 cm\", \"capacity_kg\": 23, \"remaining_kg\": 14.62, \"total_volume_cm3\": 166379, \"capacity_volume_cm3\": 117000}, {\"code\": \"B\", \"name\": \"Mala B\", \"bag_id\": 4, \"yes_kg\": 11.79, \"total_kg\": 11.79, \"packed_kg\": 10.45, \"dimensions\": \"75 × 48 × 28 cm\", \"capacity_kg\": 23, \"remaining_kg\": 11.21, \"total_volume_cm3\": 194088, \"capacity_volume_cm3\": 100800}]','2025-11-05 15:46:10');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bags`
--

LOCK TABLES `bags` WRITE;
/*!40000 ALTER TABLE `bags` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bags` VALUES
(1,1,'Mala A','A',23.00,'78 × 50 × 30 cm',0,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(2,1,'Mala B','B',23.00,'75 × 48 × 28 cm',1,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(3,2,'Mala A','A',23.00,'78 × 50 × 30 cm',0,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(4,2,'Mala B','B',23.00,'75 × 48 × 28 cm',1,'2025-11-05 15:46:10','2025-11-05 15:46:10');
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
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decision_logs`
--

LOCK TABLES `decision_logs` WRITE;
/*!40000 ALTER TABLE `decision_logs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `decision_logs` VALUES
(1,1,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:45:53'),
(2,1,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:50:53'),
(3,2,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-27 15:45:53'),
(4,2,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:50:53'),
(5,3,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:45:53'),
(6,4,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:45:53'),
(7,5,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:45:53'),
(8,5,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-03 15:50:53'),
(9,5,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-27 15:55:53'),
(10,6,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:45:53'),
(11,7,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:45:53'),
(12,8,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:45:53'),
(13,8,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-29 15:50:53'),
(14,8,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:55:53'),
(15,9,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:45:53'),
(16,9,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:50:53'),
(17,9,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:55:53'),
(18,10,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-28 15:45:53'),
(19,11,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:45:53'),
(20,12,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:45:53'),
(21,13,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-30 15:45:53'),
(22,13,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:50:53'),
(23,14,'no','pending','{\"source\": \"deck\"}',NULL,'2025-11-02 15:45:53'),
(24,14,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:50:53'),
(25,14,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:55:53'),
(26,15,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:45:53'),
(27,16,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 15:45:53'),
(28,16,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:50:53'),
(29,16,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:55:53'),
(30,17,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-29 15:45:53'),
(31,18,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 15:45:53'),
(32,18,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-28 15:50:53'),
(33,18,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-29 15:55:53'),
(34,19,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:45:53'),
(35,19,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:50:53'),
(36,19,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:55:53'),
(37,20,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-28 15:45:53'),
(38,20,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:50:53'),
(39,21,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:45:53'),
(40,21,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:50:53'),
(41,21,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:55:53'),
(42,22,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:45:53'),
(43,23,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:45:53'),
(44,23,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:50:53'),
(45,23,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-31 15:55:53'),
(46,24,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:45:53'),
(47,25,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:45:53'),
(48,25,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:50:53'),
(49,26,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:45:53'),
(50,26,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:50:53'),
(51,27,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-01 15:45:53'),
(52,27,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-01 15:50:53'),
(53,28,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-30 15:45:53'),
(54,29,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:45:53'),
(55,30,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-26 15:45:53'),
(56,30,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:50:53'),
(57,30,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:55:53'),
(58,31,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-30 15:45:53'),
(59,31,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:50:53'),
(60,32,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:45:53'),
(61,32,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:50:53'),
(62,33,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-03 15:45:53'),
(63,33,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:50:53'),
(64,33,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:55:53'),
(65,34,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 15:45:53'),
(66,35,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:45:53'),
(67,36,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:45:53'),
(68,36,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-30 15:50:53'),
(69,36,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 15:55:53'),
(70,37,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:45:53'),
(71,37,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-01 15:50:53'),
(72,38,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:45:53'),
(73,38,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:50:53'),
(74,38,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:55:53'),
(75,39,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:45:53'),
(76,39,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:50:53'),
(77,40,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:45:53'),
(78,41,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:45:53'),
(79,42,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-29 15:45:53'),
(80,43,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:45:53'),
(81,44,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:45:53'),
(82,45,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:45:53'),
(83,45,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:50:53'),
(84,45,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:55:53'),
(85,46,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:45:53'),
(86,46,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:50:53'),
(87,46,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:55:53'),
(88,47,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-29 15:45:53'),
(89,47,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:50:53'),
(90,48,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:45:53'),
(91,48,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:50:53'),
(92,48,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:55:53'),
(93,49,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-26 15:45:53'),
(94,49,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:50:53'),
(95,49,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:55:53'),
(96,50,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:45:53'),
(97,50,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-01 15:50:53'),
(98,50,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-27 15:55:53'),
(99,51,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-01 15:45:53'),
(100,51,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-10-27 15:50:53'),
(101,51,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:55:53'),
(102,52,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-30 15:45:53'),
(103,53,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-01 15:45:53'),
(104,53,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:50:53'),
(105,53,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-26 15:55:53'),
(106,54,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:45:53'),
(107,54,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-29 15:50:53'),
(108,55,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:45:53'),
(109,55,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:50:53'),
(110,56,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-28 15:45:53'),
(111,56,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 15:50:53'),
(112,57,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-30 15:45:53'),
(113,58,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:45:53'),
(114,58,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:50:53'),
(115,58,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:55:53'),
(116,59,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:45:53'),
(117,60,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 15:45:53'),
(118,61,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:46:10'),
(119,61,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-04 15:51:10'),
(120,61,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:56:10'),
(121,62,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-30 15:46:10'),
(122,62,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:51:10'),
(123,63,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:46:10'),
(124,63,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 15:51:10'),
(125,63,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:56:10'),
(126,64,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:46:10'),
(127,64,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:51:10'),
(128,64,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:56:10'),
(129,65,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-28 15:46:10'),
(130,66,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:46:10'),
(131,66,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:51:10'),
(132,66,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-04 15:56:10'),
(133,67,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:46:10'),
(134,68,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:46:10'),
(135,68,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-03 15:51:10'),
(136,69,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-27 15:46:10'),
(137,69,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:51:10'),
(138,70,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-28 15:46:10'),
(139,71,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-30 15:46:10'),
(140,71,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:51:10'),
(141,71,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:56:10'),
(142,72,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-10-27 15:46:10'),
(143,73,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:46:10'),
(144,73,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-26 15:51:10'),
(145,74,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 15:46:10'),
(146,74,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-28 15:51:10'),
(147,74,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-04 15:56:10'),
(148,75,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:46:10'),
(149,75,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 15:51:10'),
(150,75,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:56:10'),
(151,76,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:46:10'),
(152,77,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:46:10'),
(153,78,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:46:10'),
(154,78,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:51:10'),
(155,79,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-04 15:46:10'),
(156,79,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:51:10'),
(157,80,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:46:10'),
(158,80,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:51:10'),
(159,81,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:46:10'),
(160,81,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-28 15:51:10'),
(161,82,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:46:10'),
(162,82,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-29 15:51:10'),
(163,82,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-10-26 15:56:10'),
(164,83,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-29 15:46:10'),
(165,83,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:51:10'),
(166,84,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:46:10'),
(167,84,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-03 15:51:10'),
(168,85,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 15:46:10'),
(169,85,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:51:10'),
(170,86,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:46:10'),
(171,87,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-29 15:46:10'),
(172,87,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-30 15:51:10'),
(173,87,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-01 15:56:10'),
(174,88,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-26 15:46:10'),
(175,88,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:51:10'),
(176,89,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-28 15:46:10'),
(177,89,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:51:10'),
(178,90,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-03 15:46:10'),
(179,90,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:51:10'),
(180,90,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-10-29 15:56:10'),
(181,91,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-10-27 15:46:10'),
(182,91,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-26 15:51:10'),
(183,92,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:46:10'),
(184,93,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-28 15:46:10'),
(185,93,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:51:10'),
(186,93,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-01 15:56:10'),
(187,94,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:46:10'),
(188,94,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-31 15:51:10'),
(189,95,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-02 15:46:10'),
(190,96,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 15:46:10'),
(191,96,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:51:10'),
(192,96,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:56:10'),
(193,97,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-03 15:46:10'),
(194,97,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 15:51:10'),
(195,98,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-31 15:46:10'),
(196,98,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-30 15:51:10'),
(197,99,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:46:10'),
(198,99,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:51:10'),
(199,100,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-02 15:46:10'),
(200,100,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-04 15:51:10'),
(201,101,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-26 15:46:10'),
(202,101,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-31 15:51:10'),
(203,102,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-04 15:46:10'),
(204,102,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:51:10'),
(205,102,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-11-04 15:56:10'),
(206,103,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-26 15:46:10'),
(207,104,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-02 15:46:10'),
(208,105,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-11-03 15:46:10'),
(209,105,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-10-27 15:51:10');
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_media`
--

LOCK TABLES `item_media` WRITE;
/*!40000 ALTER TABLE `item_media` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `item_media` VALUES
(1,4,'local','items/63017654-f290-45b5-aceb-5e69634ef98c.png','items/thumbs/63017654-f290-45b5-aceb-5e69634ef98c.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(2,6,'local','items/8cbb4f23-38bc-460a-bd9c-d99c546fe8e9.png','items/thumbs/8cbb4f23-38bc-460a-bd9c-d99c546fe8e9.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(3,9,'local','items/d7987c6c-ff04-4ba8-ac33-716dd3906cb6.png','items/thumbs/d7987c6c-ff04-4ba8-ac33-716dd3906cb6.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(4,10,'local','items/81e16e4c-a455-4096-b89d-1462137b363b.png','items/thumbs/81e16e4c-a455-4096-b89d-1462137b363b.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(5,18,'local','items/2b43a11e-8ae2-421d-8d0f-b740fbc0eace.png','items/thumbs/2b43a11e-8ae2-421d-8d0f-b740fbc0eace.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(6,19,'local','items/961b5496-c1c5-4427-bb4b-22b9d8dfe2ae.png','items/thumbs/961b5496-c1c5-4427-bb4b-22b9d8dfe2ae.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(7,20,'local','items/9ab99450-d706-4690-8907-29ba14c2a433.png','items/thumbs/9ab99450-d706-4690-8907-29ba14c2a433.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(8,21,'local','items/ca0b4eff-ef68-437d-8c69-603de25128ad.png','items/thumbs/ca0b4eff-ef68-437d-8c69-603de25128ad.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(9,22,'local','items/53096849-2552-4b91-9f82-ef7eac773045.png','items/thumbs/53096849-2552-4b91-9f82-ef7eac773045.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(10,23,'local','items/9f6842e2-1ff4-4304-bdc7-207566c1d62e.png','items/thumbs/9f6842e2-1ff4-4304-bdc7-207566c1d62e.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(11,26,'local','items/460cfefa-a2f6-495b-8e0e-17012ec5cd72.png','items/thumbs/460cfefa-a2f6-495b-8e0e-17012ec5cd72.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(12,28,'local','items/b75887d7-4f2e-483c-b665-fbffd324dff7.png','items/thumbs/b75887d7-4f2e-483c-b665-fbffd324dff7.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(13,35,'local','items/8633d715-284d-42cc-9ace-e953bed0e20e.png','items/thumbs/8633d715-284d-42cc-9ace-e953bed0e20e.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(14,43,'local','items/dde207a3-7a7a-46c1-8de4-5ff87d28de1f.png','items/thumbs/dde207a3-7a7a-46c1-8de4-5ff87d28de1f.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(15,44,'local','items/7d00a668-a778-43a1-bd6d-96ab6e8b9553.png','items/thumbs/7d00a668-a778-43a1-bd6d-96ab6e8b9553.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(16,46,'local','items/7a7ac7d2-aa93-41f5-8f33-3d85f37fc306.png','items/thumbs/7a7ac7d2-aa93-41f5-8f33-3d85f37fc306.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(17,50,'local','items/d43b9642-67e3-451e-b184-2897e555374d.png','items/thumbs/d43b9642-67e3-451e-b184-2897e555374d.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53'),
(18,61,'local','items/8a1f72c8-2d22-4e63-9ca7-13caf2b1c988.png','items/thumbs/8a1f72c8-2d22-4e63-9ca7-13caf2b1c988.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(19,66,'local','items/5ac0a7af-4e5b-49d9-b42d-a0ace746e486.png','items/thumbs/5ac0a7af-4e5b-49d9-b42d-a0ace746e486.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(20,71,'local','items/767662f9-7143-4fc1-8a5b-594c8b508e63.png','items/thumbs/767662f9-7143-4fc1-8a5b-594c8b508e63.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(21,72,'local','items/a5bfa5f6-e836-4288-a2e8-22782d21a418.png','items/thumbs/a5bfa5f6-e836-4288-a2e8-22782d21a418.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(22,76,'local','items/a9e51a27-f35c-4658-99c0-1084d1a8354a.png','items/thumbs/a9e51a27-f35c-4658-99c0-1084d1a8354a.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(23,78,'local','items/028db6ec-0314-47cc-86e7-e2fee3bc8d0b.png','items/thumbs/028db6ec-0314-47cc-86e7-e2fee3bc8d0b.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(24,80,'local','items/e5b95beb-3b7c-4105-a0c1-f8f8c0381d8b.png','items/thumbs/e5b95beb-3b7c-4105-a0c1-f8f8c0381d8b.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(25,84,'local','items/6f3f891f-35a1-459c-9f4b-1210729c100e.png','items/thumbs/6f3f891f-35a1-459c-9f4b-1210729c100e.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(26,85,'local','items/8d8683c7-e7c5-4350-be68-faf7ce532589.png','items/thumbs/8d8683c7-e7c5-4350-be68-faf7ce532589.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(27,87,'local','items/1c648d9c-b5c9-4bec-b49b-f0d9c3156606.png','items/thumbs/1c648d9c-b5c9-4bec-b49b-f0d9c3156606.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(28,88,'local','items/28ddafe3-df34-4eff-9e10-4e1c17407ea7.png','items/thumbs/28ddafe3-df34-4eff-9e10-4e1c17407ea7.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(29,92,'local','items/dfc9943f-087c-45c6-bf67-d767108dba8f.png','items/thumbs/dfc9943f-087c-45c6-bf67-d767108dba8f.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(30,94,'local','items/3d014c3b-7d66-4277-a2be-34f19cd9d314.png','items/thumbs/3d014c3b-7d66-4277-a2be-34f19cd9d314.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(31,100,'local','items/453e6da8-01a5-4e75-8db2-16df76f980e5.png','items/thumbs/453e6da8-01a5-4e75-8db2-16df76f980e5.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(32,102,'local','items/525381b7-c575-4793-aa7b-3cdc4bbd02dc.png','items/thumbs/525381b7-c575-4793-aa7b-3cdc4bbd02dc.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10'),
(33,105,'local','items/8f52473d-130c-4bfc-a87b-04b2003f5206.png','items/thumbs/8f52473d-130c-4bfc-a87b-04b2003f5206.png','done',70,1,1,'image/png',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10');
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
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `items` VALUES
(1,1,NULL,'Id nesciunt impedit.','Ut est quod adipisci aut quia delectus exercitationem dicta a.',0.38,24864.00,'42 × 37 × 16 cm','bedroom',NULL,0,'undecided',NULL,-72,'Et ducimus voluptatem.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(2,1,NULL,'Et velit vitae.','Explicabo aperiam esse omnis sunt ut ad nostrum mollitia porro est eveniet voluptate qui.',0.30,65190.00,'53 × 41 × 30 cm','office',NULL,0,'no','2025-11-03 19:59:24',907,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(3,1,1,'Aspernatur sapiente architecto nihil.','Est dolores magni dolorem ut a non optio.',1.81,59472.00,'56 × 59 × 18 cm','office',NULL,0,'yes',NULL,1156,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(4,1,2,'Qui aperiam non.','Quia eligendi minus sed impedit minima assumenda voluptatum quia.',0.43,39744.00,'69 × 36 × 16 cm','bathroom','labore',0,'yes','2025-11-03 15:45:53',822,NULL,'/storage/items/63017654-f290-45b5-aceb-5e69634ef98c.png','/storage/items/thumbs/63017654-f290-45b5-aceb-5e69634ef98c.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(5,1,NULL,'In velit repudiandae.','Doloremque optio unde quibusdam expedita porro debitis doloremque maxime repellendus at placeat.',2.87,42532.00,'62 × 49 × 14 cm','living_room',NULL,1,'undecided',NULL,-30,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(6,1,2,'Necessitatibus optio placeat.',NULL,3.21,58996.00,'86 × 49 × 14 cm','other',NULL,0,'yes','2025-11-03 15:45:53',1111,'Necessitatibus incidunt velit aut.','/storage/items/8cbb4f23-38bc-460a-bd9c-d99c546fe8e9.png','/storage/items/thumbs/8cbb4f23-38bc-460a-bd9c-d99c546fe8e9.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(7,1,NULL,'Esse quisquam iure voluptatibus commodi.',NULL,3.11,27000.00,'50 × 15 × 36 cm','other',NULL,0,'undecided',NULL,-149,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(8,1,1,'Aut doloremque sunt.','Porro et et ratione ullam omnis mollitia.',2.39,59943.00,'53 × 29 × 39 cm','bathroom',NULL,0,'yes','2025-11-05 15:45:53',857,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(9,1,2,'Quo molestiae sequi sapiente.','Repudiandae quibusdam repellat dignissimos libero quis et perferendis vel.',0.15,61992.00,'54 × 41 × 28 cm','other',NULL,1,'yes',NULL,909,NULL,'/storage/items/d7987c6c-ff04-4ba8-ac33-716dd3906cb6.png','/storage/items/thumbs/d7987c6c-ff04-4ba8-ac33-716dd3906cb6.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(10,1,NULL,'Blanditiis ut sint.',NULL,0.54,87516.00,'52 × 51 × 33 cm','living_room','similique',0,'undecided',NULL,-131,NULL,'/storage/items/81e16e4c-a455-4096-b89d-1462137b363b.png','/storage/items/thumbs/81e16e4c-a455-4096-b89d-1462137b363b.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(11,1,2,'Eum sequi expedita aut.',NULL,3.42,127280.00,'86 × 37 × 40 cm','other',NULL,0,'yes','2025-11-02 15:45:53',751,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(12,1,NULL,'Recusandae neque voluptas.','Aspernatur possimus aut expedita ut in quibusdam libero aut mollitia.',3.28,129456.00,'72 × 58 × 31 cm','other','labore',0,'undecided',NULL,75,'Rerum alias ut.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(13,1,2,'Nam qui dolor fugit.','Voluptas id assumenda et fuga dolorem doloribus.',1.63,120472.00,'88 × 37 × 37 cm','bedroom','fugit',0,'yes','2025-11-02 15:45:53',1033,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(14,1,1,'Cumque et.',NULL,3.46,30600.00,'60 × 30 × 17 cm','living_room','magni',0,'yes','2025-10-31 15:45:53',731,'Delectus voluptatibus et.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(15,1,1,'Earum odit error numquam.','Placeat sint est a repellendus quaerat nihil necessitatibus.',2.66,23738.00,'83 × 26 × 11 cm','bedroom',NULL,1,'yes','2025-11-01 15:45:53',964,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(16,1,NULL,'Veniam molestiae et.',NULL,2.12,21060.00,'36 × 39 × 15 cm','bathroom',NULL,0,'pending',NULL,282,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(17,1,NULL,'Harum cupiditate aspernatur.',NULL,2.09,48400.00,'22 × 55 × 40 cm','storage',NULL,0,'no',NULL,630,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(18,1,2,'Qui dolores et quos dolor.','In qui vero voluptatem voluptatem temporibus beatae non.',2.19,20332.00,'34 × 26 × 23 cm','bedroom','minus',0,'yes','2025-11-03 15:45:53',932,NULL,'/storage/items/2b43a11e-8ae2-421d-8d0f-b740fbc0eace.png','/storage/items/thumbs/2b43a11e-8ae2-421d-8d0f-b740fbc0eace.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(19,1,1,'Modi distinctio id.','Beatae debitis quis omnis delectus nemo id harum sed tenetur.',3.29,18122.00,'26 × 41 × 17 cm','living_room',NULL,0,'yes','2025-11-05 15:45:53',991,'Quia aspernatur omnis.','/storage/items/961b5496-c1c5-4427-bb4b-22b9d8dfe2ae.png','/storage/items/thumbs/961b5496-c1c5-4427-bb4b-22b9d8dfe2ae.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(20,1,NULL,'Aut est nisi saepe quia.','Maxime fugiat ducimus sit ex esse ea eaque quisquam consectetur.',3.18,21870.00,'45 × 18 × 27 cm','office',NULL,0,'undecided',NULL,100,NULL,'/storage/items/9ab99450-d706-4690-8907-29ba14c2a433.png','/storage/items/thumbs/9ab99450-d706-4690-8907-29ba14c2a433.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(21,1,NULL,'Explicabo qui ea.',NULL,2.62,42300.00,'75 × 47 × 12 cm','other',NULL,0,'pending',NULL,243,'Illum sit hic provident.','/storage/items/ca0b4eff-ef68-437d-8c69-603de25128ad.png','/storage/items/thumbs/ca0b4eff-ef68-437d-8c69-603de25128ad.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(22,1,NULL,'Aut totam et sint.','Est illo quae dolorem eum qui eos est itaque nostrum facilis.',1.96,92820.00,'70 × 51 × 26 cm','storage','ut',0,'undecided',NULL,149,NULL,'/storage/items/53096849-2552-4b91-9f82-ef7eac773045.png','/storage/items/thumbs/53096849-2552-4b91-9f82-ef7eac773045.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(23,1,NULL,'Quia et necessitatibus.',NULL,0.76,19980.00,'37 × 36 × 15 cm','office','ad',0,'undecided',NULL,-197,NULL,'/storage/items/9f6842e2-1ff4-4304-bdc7-207566c1d62e.png','/storage/items/thumbs/9f6842e2-1ff4-4304-bdc7-207566c1d62e.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(24,1,NULL,'Id hic quidem et.','Dolorem voluptates omnis qui quo voluptas ex sequi et ut.',0.28,21560.00,'35 × 28 × 22 cm','other','natus',1,'pending',NULL,530,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(25,1,NULL,'Eius ea.','Laborum natus quaerat vel aut quaerat quia deserunt earum.',1.11,18240.00,'32 × 30 × 19 cm','bathroom',NULL,1,'undecided',NULL,52,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(26,1,NULL,'Sunt similique sit.','Dolor doloremque hic repellat maxime perspiciatis aliquid veritatis.',1.79,34656.00,'57 × 19 × 32 cm','bathroom',NULL,1,'pending',NULL,519,'Dolore consequuntur quis amet.','/storage/items/460cfefa-a2f6-495b-8e0e-17012ec5cd72.png','/storage/items/thumbs/460cfefa-a2f6-495b-8e0e-17012ec5cd72.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(27,1,NULL,'Iusto inventore aperiam quis.',NULL,0.19,73926.00,'37 × 54 × 37 cm','storage',NULL,0,'undecided','2025-10-29 12:47:37',-88,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(28,1,NULL,'Quam qui.',NULL,1.12,12320.00,'28 × 40 × 11 cm','living_room','at',0,'undecided',NULL,-171,'Natus molestiae rem veniam.','/storage/items/b75887d7-4f2e-483c-b665-fbffd324dff7.png','/storage/items/thumbs/b75887d7-4f2e-483c-b665-fbffd324dff7.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(29,1,2,'Consequatur explicabo sunt cumque.',NULL,0.85,145248.00,'89 × 48 × 34 cm','other','sed',1,'no',NULL,657,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(30,1,NULL,'Debitis autem voluptatem ex.','Enim perspiciatis eius rerum rem magni nulla debitis vero harum.',1.11,51680.00,'76 × 20 × 34 cm','other','labore',0,'no','2025-10-31 06:26:19',1080,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(31,1,2,'Dolores vel nemo.','Distinctio officiis magni et nam vitae numquam qui debitis reiciendis expedita qui quia est.',0.48,22200.00,'20 × 37 × 30 cm','storage','vel',1,'yes','2025-11-03 15:45:53',845,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(32,1,NULL,'Sit est incidunt debitis.','Quod molestias voluptatem iusto architecto eius fugit commodi atque sed fuga soluta quo.',1.88,22680.00,'27 × 40 × 21 cm','storage','non',0,'undecided',NULL,-111,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(33,1,NULL,'Ipsa dolorem.','Nulla soluta asperiores repellat animi ut odio qui.',2.07,68306.00,'41 × 49 × 34 cm','other','eos',1,'undecided',NULL,77,'Velit odit et.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(34,1,NULL,'Eius illum et eveniet atque.','Ducimus numquam nesciunt ut facilis similique provident et itaque ab.',0.27,57285.00,'67 × 45 × 19 cm','office','molestiae',1,'no',NULL,1074,'Dolor adipisci neque.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(35,1,NULL,'Laudantium aut est.',NULL,0.95,23161.00,'53 × 23 × 19 cm','kitchen','tenetur',1,'undecided',NULL,-31,'Molestiae vero dolorem sunt.','/storage/items/8633d715-284d-42cc-9ace-e953bed0e20e.png','/storage/items/thumbs/8633d715-284d-42cc-9ace-e953bed0e20e.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(36,1,NULL,'Incidunt eum provident officiis.','Et quibusdam dolorem hic nesciunt occaecati officiis odit omnis possimus quia eveniet maiores.',2.50,80784.00,'68 × 33 × 36 cm','storage',NULL,1,'undecided',NULL,-122,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(37,1,NULL,'Nihil aut veritatis.',NULL,2.13,59850.00,'70 × 57 × 15 cm','bathroom',NULL,0,'undecided',NULL,194,'Repellat voluptatem omnis.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(38,1,1,'Fugiat ut consequuntur perspiciatis.','Laudantium possimus error iste commodi quia nisi sit dolores.',0.37,40950.00,'35 × 30 × 39 cm','other',NULL,0,'no',NULL,990,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(39,1,1,'Qui rerum hic velit.','Debitis assumenda alias consectetur magni voluptatem modi accusantium sit.',1.89,87000.00,'58 × 50 × 30 cm','bathroom','et',0,'yes','2025-11-01 04:56:01',1009,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(40,1,NULL,'Et debitis at aliquam.','Harum earum delectus deserunt error soluta et.',1.03,23808.00,'32 × 31 × 24 cm','living_room','nam',0,'undecided',NULL,-76,'Sit consequuntur aspernatur.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(41,1,NULL,'Sit sunt sit iste.','Et eos repellendus rerum voluptate ab provident qui reiciendis consequatur non sit enim.',1.10,9633.00,'39 × 19 × 13 cm','bathroom','qui',0,'undecided',NULL,6,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(42,1,NULL,'Illum et consequatur fugiat nam.',NULL,3.24,42240.00,'22 × 60 × 32 cm','kitchen',NULL,0,'undecided',NULL,185,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(43,1,NULL,'Fugit consequuntur vel.',NULL,2.54,82044.00,'86 × 53 × 18 cm','office','temporibus',0,'undecided',NULL,-24,NULL,'/storage/items/dde207a3-7a7a-46c1-8de4-5ff87d28de1f.png','/storage/items/thumbs/dde207a3-7a7a-46c1-8de4-5ff87d28de1f.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(44,1,NULL,'Quo nulla impedit.','Ea neque magni vero commodi modi enim voluptatem voluptates.',1.93,59985.00,'45 × 43 × 31 cm','living_room','labore',0,'undecided',NULL,19,'Qui omnis sunt.','/storage/items/7d00a668-a778-43a1-bd6d-96ab6e8b9553.png','/storage/items/thumbs/7d00a668-a778-43a1-bd6d-96ab6e8b9553.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(45,1,NULL,'Rem expedita dolorem.','Non rerum dolores ut et quia officiis.',0.58,78864.00,'48 × 53 × 31 cm','kitchen','dolorem',1,'undecided',NULL,-167,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(46,1,NULL,'Placeat aut ut.',NULL,2.07,15275.00,'25 × 47 × 13 cm','other',NULL,1,'undecided',NULL,-42,'Corporis rerum voluptatem in.','/storage/items/7a7ac7d2-aa93-41f5-8f33-3d85f37fc306.png','/storage/items/thumbs/7a7ac7d2-aa93-41f5-8f33-3d85f37fc306.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(47,1,1,'Beatae quis ipsa nobis.',NULL,2.67,39825.00,'25 × 59 × 27 cm','office','voluptates',0,'no',NULL,822,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(48,1,NULL,'Dolor maxime id.','Et dolorum aut consequatur vel et eos nisi autem.',1.15,87210.00,'45 × 51 × 38 cm','office',NULL,0,'undecided',NULL,46,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(49,1,1,'Dolor fuga aspernatur.','Recusandae magni sint ab neque et aut est occaecati numquam eos.',2.09,86284.00,'44 × 53 × 37 cm','bedroom',NULL,0,'yes','2025-10-30 14:30:07',1040,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(50,1,NULL,'Perspiciatis dolorum architecto.','Quia enim qui in tenetur nemo qui omnis est quisquam distinctio rem et.',0.59,28548.00,'61 × 26 × 18 cm','storage',NULL,1,'pending',NULL,493,'Id vel voluptatem autem aliquam.','/storage/items/d43b9642-67e3-451e-b184-2897e555374d.png','/storage/items/thumbs/d43b9642-67e3-451e-b184-2897e555374d.png','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(51,1,NULL,'Omnis amet sint.','Quos blanditiis minima id eos aut in minima rerum id autem est quam voluptas.',1.61,29754.00,'38 × 29 × 27 cm','office',NULL,0,'pending',NULL,559,'Et omnis ut.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(52,1,NULL,'Saepe quis distinctio odit sit.','Quae sunt voluptas nulla voluptatem temporibus incidunt delectus omnis aliquam.',1.61,68820.00,'74 × 30 × 31 cm','office','temporibus',0,'no',NULL,690,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(53,1,NULL,'Tempore tempore et quaerat et.',NULL,1.36,14976.00,'64 × 18 × 13 cm','office',NULL,0,'undecided',NULL,149,'Et ut velit tempore.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(54,1,1,'Aliquam dolorem at dolores.',NULL,1.50,32240.00,'52 × 20 × 31 cm','bedroom',NULL,0,'yes',NULL,1185,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(55,1,NULL,'Magnam non illo.','Iusto ullam quidem ipsam sint ipsam et.',2.32,25056.00,'29 × 48 × 18 cm','bathroom','aliquid',0,'no',NULL,789,'Qui est facere maxime.',NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(56,1,2,'Aspernatur et vero.',NULL,3.33,33792.00,'48 × 32 × 22 cm','office',NULL,0,'no',NULL,1095,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(57,1,NULL,'Quia ducimus vel quam.','Dolor ipsam rerum et veritatis numquam repellendus laudantium possimus quo praesentium nihil deserunt.',3.24,21252.00,'42 × 46 × 11 cm','living_room',NULL,1,'undecided','2025-10-30 03:27:14',149,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(58,1,2,'Sit ut explicabo.','Et exercitationem ad sed ea non et distinctio ratione eum saepe nemo autem reiciendis.',1.44,106624.00,'56 × 56 × 34 cm','kitchen',NULL,0,'yes',NULL,1128,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(59,1,NULL,'Nam expedita sequi consequatur.',NULL,3.46,55332.00,'53 × 36 × 29 cm','office',NULL,0,'no',NULL,1181,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(60,1,NULL,'Aut quibusdam optio quis.',NULL,1.89,41412.00,'58 × 21 × 34 cm','storage',NULL,1,'undecided',NULL,-137,NULL,NULL,NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(61,2,NULL,'Sunt iste saepe.','Distinctio dolorem maiores sed sit asperiores aut et sunt inventore rerum autem harum aut.',2.45,26180.00,'70 × 34 × 11 cm','bedroom',NULL,1,'pending',NULL,483,NULL,'/storage/items/8a1f72c8-2d22-4e63-9ca7-13caf2b1c988.png','/storage/items/thumbs/8a1f72c8-2d22-4e63-9ca7-13caf2b1c988.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(62,2,NULL,'Ratione odio dolorem magnam.',NULL,1.01,34960.00,'40 × 23 × 38 cm','living_room','amet',1,'undecided',NULL,-72,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(63,2,NULL,'Molestias ut fuga.',NULL,0.65,32224.00,'53 × 19 × 32 cm','living_room',NULL,0,'undecided',NULL,193,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(64,2,4,'Reprehenderit sed.','Iusto architecto vitae beatae assumenda adipisci minima dolore.',0.91,26320.00,'20 × 47 × 28 cm','bedroom',NULL,1,'yes','2025-11-04 15:46:10',1049,'Et sed placeat aliquid.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(65,2,NULL,'Temporibus repellendus blanditiis.',NULL,3.23,45760.00,'40 × 52 × 22 cm','living_room',NULL,1,'undecided',NULL,131,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(66,2,NULL,'Est a neque.','Adipisci quod suscipit qui pariatur perferendis aut accusantium accusamus.',2.19,11040.00,'20 × 24 × 23 cm','bedroom',NULL,0,'pending',NULL,317,NULL,'/storage/items/5ac0a7af-4e5b-49d9-b42d-a0ace746e486.png','/storage/items/thumbs/5ac0a7af-4e5b-49d9-b42d-a0ace746e486.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(67,2,NULL,'Perspiciatis laudantium dicta eaque.','Maiores vitae quaerat ut iure harum et delectus corporis dolor molestiae consequatur.',0.39,42640.00,'82 × 26 × 20 cm','bathroom','sed',0,'undecided',NULL,47,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(68,2,4,'Tempora est itaque.','Sunt eum qui aperiam dolorem nulla repellendus quia deserunt fugit sapiente sed libero qui.',3.34,24024.00,'84 × 22 × 13 cm','other',NULL,0,'yes','2025-11-04 15:46:10',798,'Aut aut.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(69,2,NULL,'Reiciendis eveniet.','Cum vero pariatur qui dolorum aliquid vero sit harum ea et.',2.16,63798.00,'49 × 42 × 31 cm','bathroom',NULL,0,'undecided',NULL,-8,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(70,2,NULL,'Asperiores aut voluptatem.',NULL,3.29,113886.00,'57 × 54 × 37 cm','kitchen',NULL,1,'undecided',NULL,-4,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(71,2,NULL,'Sed et inventore minus.','Id fugit rem alias aliquam aut rerum porro.',2.89,19129.00,'47 × 37 × 11 cm','office',NULL,0,'no',NULL,715,'Id eos rerum commodi.','/storage/items/767662f9-7143-4fc1-8a5b-594c8b508e63.png','/storage/items/thumbs/767662f9-7143-4fc1-8a5b-594c8b508e63.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(72,2,NULL,'Mollitia quidem dolor.',NULL,0.75,12376.00,'56 × 17 × 13 cm','storage',NULL,1,'no','2025-11-04 18:00:00',669,NULL,'/storage/items/a5bfa5f6-e836-4288-a2e8-22782d21a418.png','/storage/items/thumbs/a5bfa5f6-e836-4288-a2e8-22782d21a418.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(73,2,NULL,'Commodi et amet qui debitis.',NULL,3.03,55120.00,'40 × 53 × 26 cm','living_room',NULL,0,'undecided',NULL,200,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(74,2,NULL,'Reiciendis odit aliquam ut.',NULL,3.46,14553.00,'21 × 33 × 21 cm','living_room',NULL,0,'undecided',NULL,107,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(75,2,NULL,'Sint laudantium sed natus.','Ipsum atque tempore quae animi et assumenda sed voluptatum et eius quasi et.',0.51,108900.00,'55 × 55 × 36 cm','office','est',0,'pending',NULL,574,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(76,2,NULL,'Numquam ratione ut repellendus.','Pariatur molestias possimus aut sunt quis error porro voluptas in quasi quas fugiat illo.',3.13,80388.00,'66 × 42 × 29 cm','storage',NULL,0,'pending',NULL,385,NULL,'/storage/items/a9e51a27-f35c-4658-99c0-1084d1a8354a.png','/storage/items/thumbs/a9e51a27-f35c-4658-99c0-1084d1a8354a.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(77,2,NULL,'Officia et fuga.','Quae laboriosam officiis ipsum voluptatem officiis aut ut numquam eos.',0.65,26496.00,'72 × 23 × 16 cm','living_room','aliquam',0,'undecided',NULL,142,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(78,2,NULL,'Temporibus enim illum.',NULL,2.51,94424.00,'88 × 29 × 37 cm','other',NULL,0,'undecided',NULL,170,NULL,'/storage/items/028db6ec-0314-47cc-86e7-e2fee3bc8d0b.png','/storage/items/thumbs/028db6ec-0314-47cc-86e7-e2fee3bc8d0b.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(79,2,NULL,'Dignissimos et non excepturi.',NULL,3.03,114480.00,'60 × 53 × 36 cm','storage',NULL,1,'undecided',NULL,-107,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(80,2,NULL,'Provident maiores enim amet.','Nihil in tempora rem officiis iste ut distinctio excepturi ut impedit qui eum beatae.',1.51,59850.00,'90 × 35 × 19 cm','living_room','qui',0,'pending',NULL,354,'Id nihil.','/storage/items/e5b95beb-3b7c-4105-a0c1-f8f8c0381d8b.png','/storage/items/thumbs/e5b95beb-3b7c-4105-a0c1-f8f8c0381d8b.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(81,2,NULL,'Sit molestiae natus.',NULL,2.24,63882.00,'39 × 42 × 39 cm','office',NULL,0,'undecided',NULL,57,'Dolor explicabo accusantium ut.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(82,2,4,'Ut quos et quaerat.',NULL,0.21,14592.00,'38 × 16 × 24 cm','storage',NULL,0,'yes','2025-10-29 15:22:43',734,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(83,2,NULL,'Fuga delectus iure.','Repellat eos eligendi labore et repudiandae veniam quos quos placeat blanditiis nesciunt eum.',1.72,83259.00,'87 × 29 × 33 cm','living_room',NULL,1,'pending',NULL,509,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(84,2,NULL,'Modi quia voluptas deleniti.','Eos est voluptates recusandae et sunt non odit officiis et qui.',2.61,32800.00,'82 × 25 × 16 cm','other',NULL,0,'undecided',NULL,44,NULL,'/storage/items/6f3f891f-35a1-459c-9f4b-1210729c100e.png','/storage/items/thumbs/6f3f891f-35a1-459c-9f4b-1210729c100e.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(85,2,4,'Voluptates deserunt nam.',NULL,3.23,63580.00,'85 × 44 × 17 cm','kitchen',NULL,0,'yes','2025-11-04 15:46:10',1130,'Consequatur repellat et deserunt.','/storage/items/8d8683c7-e7c5-4350-be68-faf7ce532589.png','/storage/items/thumbs/8d8683c7-e7c5-4350-be68-faf7ce532589.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(86,2,NULL,'Ut sunt placeat.',NULL,0.76,43758.00,'33 × 51 × 26 cm','other',NULL,0,'pending',NULL,439,'Est illum et commodi.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(87,2,NULL,'Tenetur et aliquam.','Eaque quisquam omnis voluptatum aspernatur et nobis eos.',2.54,27216.00,'28 × 54 × 18 cm','storage',NULL,0,'undecided',NULL,-62,NULL,'/storage/items/1c648d9c-b5c9-4bec-b49b-f0d9c3156606.png','/storage/items/thumbs/1c648d9c-b5c9-4bec-b49b-f0d9c3156606.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(88,2,4,'In sequi nam corrupti.','Dolorem ratione maiores modi distinctio at tenetur quia voluptatem aspernatur rem nihil dignissimos dolorem.',1.34,38272.00,'64 × 26 × 23 cm','office','quas',0,'yes',NULL,734,NULL,'/storage/items/28ddafe3-df34-4eff-9e10-4e1c17407ea7.png','/storage/items/thumbs/28ddafe3-df34-4eff-9e10-4e1c17407ea7.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(89,2,NULL,'Sit at delectus aspernatur.',NULL,3.44,55104.00,'82 × 48 × 14 cm','office',NULL,0,'no',NULL,1069,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(90,2,NULL,'Et blanditiis aut ut.',NULL,0.97,64790.00,'55 × 38 × 31 cm','storage','quisquam',1,'undecided',NULL,42,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(91,2,NULL,'Neque et et quasi.','Esse doloremque aliquam repellat molestiae aut eos illo eum aut modi omnis dolorum.',2.53,17280.00,'40 × 27 × 16 cm','bedroom','cum',0,'undecided',NULL,149,'Ea perferendis voluptatem et.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(92,2,4,'Sunt ex fugit.','Nemo rerum nobis et eaque ab accusamus consequatur dicta.',1.93,25752.00,'37 × 58 × 12 cm','office','eveniet',0,'no',NULL,1178,'Reprehenderit deserunt vel.','/storage/items/dfc9943f-087c-45c6-bf67-d767108dba8f.png','/storage/items/thumbs/dfc9943f-087c-45c6-bf67-d767108dba8f.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(93,2,NULL,'Illo sunt dicta temporibus.',NULL,1.91,43200.00,'30 × 48 × 30 cm','office',NULL,0,'undecided',NULL,-160,'Atque est alias dolor.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(94,2,NULL,'Consectetur aut voluptas magni.','Impedit necessitatibus aliquam non tempore et quia molestias molestias.',2.63,9000.00,'24 × 25 × 15 cm','living_room',NULL,0,'pending',NULL,223,NULL,'/storage/items/3d014c3b-7d66-4277-a2be-34f19cd9d314.png','/storage/items/thumbs/3d014c3b-7d66-4277-a2be-34f19cd9d314.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(95,2,3,'Sint dolorum fugiat ab consectetur.',NULL,3.16,8910.00,'33 × 27 × 10 cm','kitchen',NULL,0,'yes',NULL,635,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(96,2,NULL,'Porro optio harum est.','Sit consequatur placeat odit illum non sunt pariatur ab voluptatem.',1.66,34238.00,'34 × 53 × 19 cm','office',NULL,0,'undecided',NULL,154,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(97,2,3,'Ut at aut.','Accusantium rem facere harum sit doloribus a et similique unde voluptas.',3.22,81437.00,'71 × 31 × 37 cm','bathroom','et',0,'yes','2025-10-31 13:24:47',1027,'Vel necessitatibus eaque est.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(98,2,4,'Quos consequuntur culpa earum.','Rerum aut quia assumenda assumenda esse libero et dolores dolor.',0.29,32062.00,'46 × 41 × 17 cm','bathroom','voluptatem',0,'no',NULL,994,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(99,2,4,'Qui sit.',NULL,2.76,27300.00,'70 × 26 × 15 cm','office','fugit',0,'yes','2025-11-02 19:11:45',808,'Modi magni saepe qui.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(100,2,NULL,'Ducimus quia voluptatem omnis.',NULL,1.85,33264.00,'22 × 54 × 28 cm','office','quod',0,'pending',NULL,464,NULL,'/storage/items/453e6da8-01a5-4e75-8db2-16df76f980e5.png','/storage/items/thumbs/453e6da8-01a5-4e75-8db2-16df76f980e5.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(101,2,3,'Temporibus consequuntur corrupti.',NULL,2.00,76032.00,'66 × 32 × 36 cm','bedroom',NULL,0,'yes',NULL,661,'Amet dicta cupiditate maxime.',NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(102,2,NULL,'Ratione consectetur deserunt et.','Doloribus dignissimos quis repudiandae et magnam voluptatem quos soluta facere et impedit omnis.',3.28,23100.00,'30 × 22 × 35 cm','kitchen',NULL,0,'no',NULL,1085,'Aspernatur quod et.','/storage/items/525381b7-c575-4793-aa7b-3cdc4bbd02dc.png','/storage/items/thumbs/525381b7-c575-4793-aa7b-3cdc4bbd02dc.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(103,2,NULL,'Eveniet et hic necessitatibus.','Sit quibusdam et sit et illo dolorem.',0.57,36848.00,'56 × 47 × 14 cm','office',NULL,1,'pending',NULL,404,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(104,2,NULL,'Dolorem et quam.','Aut ipsa non omnis ut aliquam dolorem et.',1.86,27968.00,'46 × 38 × 16 cm','other','fuga',0,'pending',NULL,329,NULL,NULL,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL),
(105,2,NULL,'Eaque aut quis temporibus nesciunt.','Similique omnis praesentium debitis sunt veniam consequatur sint doloremque inventore placeat ut ad quis.',3.35,63240.00,'51 × 31 × 40 cm','kitchen',NULL,0,'no','2025-10-30 11:16:41',813,NULL,'/storage/items/8f52473d-130c-4bfc-a87b-04b2003f5206.png','/storage/items/thumbs/8f52473d-130c-4bfc-a87b-04b2003f5206.png','2025-11-05 15:46:10','2025-11-05 15:46:10',NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `magic_links`
--

LOCK TABLES `magic_links` WRITE;
/*!40000 ALTER TABLE `magic_links` DISABLE KEYS */;
set autocommit=0;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moves`
--

LOCK TABLES `moves` WRITE;
/*!40000 ALTER TABLE `moves` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `moves` VALUES
(1,1,'GB','BR',4.00,60000.00,'{\"deck_hints\": false}','2025-11-05 15:45:53','2025-11-05 15:45:53',NULL),
(2,2,'GB','BR',4.00,60000.00,NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',NULL);
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
('Nu8jopFCbQXMYY7Y0evS8ZVw36AEdYEuEym1tUmj',2,'172.24.0.1','Mozilla/5.0 (X11; Linux x86_64; rv:144.0) Gecko/20100101 Firefox/144.0','YTo1OntzOjY6Il90b2tlbiI7czo0MDoiTk9WT0J2ejhpUFI2RmlCMk05NnZVUGtGMkMwckNKalpKM3g0WDB6OSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyNjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3BpY2siO31zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czoyNzoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2xvZ2luIjtzOjU6InJvdXRlIjtzOjU6ImxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mjt9',1762357575);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'Demo User','demo@example.com',NULL,'2025-11-05 15:45:53','2025-11-05 15:45:53',0,0),
(2,'Love','love@islove.com',NULL,'2025-11-05 15:46:10','2025-11-05 15:46:10',0,0);
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

-- Dump completed on 2025-11-05 15:49:25
