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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bag_snapshots`
--

LOCK TABLES `bag_snapshots` WRITE;
/*!40000 ALTER TABLE `bag_snapshots` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bag_snapshots` VALUES
(1,1,103.18,15,24,30.43,'[{\"width\": 36, \"height\": 32, \"length\": 55, \"volume\": 63360}, {\"width\": 53, \"height\": 40, \"length\": 56, \"volume\": 118720}, {\"width\": 49, \"height\": 34, \"length\": 79, \"volume\": 131614}, {\"width\": 34, \"height\": 40, \"length\": 46, \"volume\": 62560}, {\"width\": 56, \"height\": 40, \"length\": 46, \"volume\": 103040}, {\"width\": 52, \"height\": 15, \"length\": 49, \"volume\": 38220}, {\"width\": 31, \"height\": 40, \"length\": 75, \"volume\": 93000}, {\"width\": 51, \"height\": 26, \"length\": 28, \"volume\": 37128}, {\"width\": 34, \"height\": 23, \"length\": 50, \"volume\": 39100}, {\"width\": 20, \"height\": 33, \"length\": 30, \"volume\": 19800}, {\"width\": 57, \"height\": 34, \"length\": 60, \"volume\": 116280}, {\"width\": 29, \"height\": 24, \"length\": 29, \"volume\": 20184}, {\"width\": 30, \"height\": 17, \"length\": 54, \"volume\": 27540}, {\"width\": 57, \"height\": 15, \"length\": 89, \"volume\": 76095}, {\"width\": 18, \"height\": 21, \"length\": 70, \"volume\": 26460}]','[{\"code\": \"A\", \"name\": \"Mala A\", \"bag_id\": 1, \"yes_kg\": 15.19, \"total_kg\": 15.19, \"packed_kg\": 11.11, \"dimensions\": \"78 × 50 × 30 cm\", \"capacity_kg\": 23, \"remaining_kg\": 7.809999999999999, \"total_volume_cm3\": 446033, \"capacity_volume_cm3\": 117000}, {\"code\": \"B\", \"name\": \"Mala B\", \"bag_id\": 2, \"yes_kg\": 15.239999999999998, \"total_kg\": 15.239999999999998, \"packed_kg\": 10.46, \"dimensions\": \"75 × 48 × 28 cm\", \"capacity_kg\": 23, \"remaining_kg\": 7.760000000000002, \"total_volume_cm3\": 527068, \"capacity_volume_cm3\": 100800}]','2025-11-07 17:17:06'),
(2,2,75.38,9,7,12.82,'[{\"width\": 58, \"height\": 20, \"length\": 42, \"volume\": 48720}, {\"width\": 32, \"height\": 34, \"length\": 44, \"volume\": 47872}, {\"width\": 24, \"height\": 34, \"length\": 21, \"volume\": 17136}, {\"width\": 56, \"height\": 33, \"length\": 55, \"volume\": 101640}, {\"width\": 25, \"height\": 23, \"length\": 30, \"volume\": 17250}, {\"width\": 21, \"height\": 20, \"length\": 20, \"volume\": 8400}, {\"width\": 25, \"height\": 20, \"length\": 70, \"volume\": 35000}]','[{\"code\": \"A\", \"name\": \"Mala A\", \"bag_id\": 3, \"yes_kg\": 3.16, \"total_kg\": 3.16, \"packed_kg\": 0, \"dimensions\": \"78 × 50 × 30 cm\", \"capacity_kg\": 23, \"remaining_kg\": 19.84, \"total_volume_cm3\": 101640, \"capacity_volume_cm3\": 117000}, {\"code\": \"B\", \"name\": \"Mala B\", \"bag_id\": 4, \"yes_kg\": 0, \"total_kg\": 0, \"packed_kg\": 0, \"dimensions\": \"75 × 48 × 28 cm\", \"capacity_kg\": 23, \"remaining_kg\": 23, \"total_volume_cm3\": 0, \"capacity_volume_cm3\": 100800}]','2025-11-07 22:48:40'),
(3,3,95.59,13,36,37.45,'[{\"width\": 55, \"height\": 31, \"length\": 36, \"volume\": 61380}, {\"width\": 28, \"height\": 35, \"length\": 78, \"volume\": 76440}, {\"width\": 57, \"height\": 40, \"length\": 57, \"volume\": 129960}, {\"width\": 29, \"height\": 36, \"length\": 70, \"volume\": 73080}, {\"width\": 58, \"height\": 14, \"length\": 69, \"volume\": 56028}, {\"width\": 44, \"height\": 25, \"length\": 27, \"volume\": 29700}, {\"width\": 60, \"height\": 39, \"length\": 84, \"volume\": 196560}, {\"width\": 31, \"height\": 38, \"length\": 86, \"volume\": 101308}, {\"width\": 21, \"height\": 35, \"length\": 78, \"volume\": 57330}, {\"width\": 60, \"height\": 28, \"length\": 22, \"volume\": 36960}, {\"width\": 34, \"height\": 14, \"length\": 69, \"volume\": 32844}, {\"width\": 53, \"height\": 39, \"length\": 24, \"volume\": 49608}, {\"width\": 50, \"height\": 17, \"length\": 24, \"volume\": 20400}, {\"width\": 40, \"height\": 17, \"length\": 53, \"volume\": 36040}, {\"width\": 43, \"height\": 25, \"length\": 24, \"volume\": 25800}]','[{\"code\": \"A\", \"name\": \"Mala A\", \"bag_id\": 5, \"yes_kg\": 8.83, \"total_kg\": 8.83, \"packed_kg\": 8.83, \"dimensions\": \"78 × 50 × 30 cm\", \"capacity_kg\": 23, \"remaining_kg\": 14.17, \"total_volume_cm3\": 150730, \"capacity_volume_cm3\": 117000}, {\"code\": \"B\", \"name\": \"Mala B\", \"bag_id\": 6, \"yes_kg\": 3.9, \"total_kg\": 3.9, \"packed_kg\": 3.5, \"dimensions\": \"75 × 48 × 28 cm\", \"capacity_kg\": 23, \"remaining_kg\": 19.1, \"total_volume_cm3\": 134152, \"capacity_volume_cm3\": 100800}]','2025-11-07 23:16:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bags`
--

LOCK TABLES `bags` WRITE;
/*!40000 ALTER TABLE `bags` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `bags` VALUES
(1,1,'Mala A','A',23.00,'78 × 50 × 30 cm',0,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(2,1,'Mala B','B',23.00,'75 × 48 × 28 cm',1,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(3,2,'Mala A','A',23.00,'78 × 50 × 30 cm',0,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(4,2,'Mala B','B',23.00,'75 × 48 × 28 cm',1,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(5,3,'Mala A','A',23.00,'78 × 50 × 30 cm',0,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(6,3,'Mala B','B',23.00,'75 × 48 × 28 cm',1,'2025-11-07 22:52:15','2025-11-07 22:52:15');
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
) ENGINE=InnoDB AUTO_INCREMENT=498 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `decision_logs`
--

LOCK TABLES `decision_logs` WRITE;
/*!40000 ALTER TABLE `decision_logs` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `decision_logs` VALUES
(1,1,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:17:06'),
(2,1,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-11-05 17:22:06'),
(3,1,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 17:27:06'),
(4,2,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 17:17:06'),
(5,3,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:17:06'),
(6,3,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:22:06'),
(7,4,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-28 17:17:06'),
(8,5,'no','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 17:17:06'),
(9,5,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-11-05 17:22:06'),
(10,6,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:17:06'),
(11,6,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:22:06'),
(12,7,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:17:06'),
(13,7,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:22:06'),
(14,7,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-31 17:27:06'),
(15,8,'no','pending','{\"source\": \"deck\"}',NULL,'2025-11-05 17:17:06'),
(16,9,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:17:06'),
(17,10,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:17:06'),
(18,11,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-06 17:17:06'),
(19,11,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:22:06'),
(20,12,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-06 17:17:06'),
(21,12,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:22:06'),
(22,13,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:17:06'),
(23,13,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:22:06'),
(24,14,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-06 17:17:06'),
(25,14,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:22:06'),
(26,15,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-03 17:17:06'),
(27,16,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 17:17:06'),
(28,16,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:22:06'),
(29,16,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:27:06'),
(30,17,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(31,17,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 17:22:06'),
(32,18,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 17:17:06'),
(33,18,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:22:06'),
(34,18,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-10-28 17:27:06'),
(35,19,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-29 17:17:06'),
(36,19,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 17:22:06'),
(37,19,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 17:27:06'),
(38,20,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:17:06'),
(39,20,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:22:06'),
(40,20,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:27:06'),
(41,21,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(42,21,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:22:06'),
(43,22,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(44,22,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-29 17:22:06'),
(45,23,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:17:06'),
(46,24,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-04 17:17:06'),
(47,24,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-01 17:22:06'),
(48,25,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:17:06'),
(49,26,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:17:06'),
(50,26,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:22:06'),
(51,26,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-06 17:27:06'),
(52,27,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-28 17:17:06'),
(53,27,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:22:06'),
(54,27,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-02 17:27:06'),
(55,28,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:17:06'),
(56,28,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-04 17:22:06'),
(57,29,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 17:17:06'),
(58,30,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-29 17:17:06'),
(59,31,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:17:06'),
(60,32,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-06 17:17:06'),
(61,32,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-30 17:22:06'),
(62,33,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:17:06'),
(63,33,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:22:06'),
(64,33,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-28 17:27:06'),
(65,34,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:17:06'),
(66,35,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:17:06'),
(67,36,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-06 17:17:06'),
(68,37,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:17:06'),
(69,37,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:22:06'),
(70,38,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(71,39,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:17:06'),
(72,39,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-03 17:22:06'),
(73,39,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:27:06'),
(74,40,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:17:06'),
(75,41,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:17:06'),
(76,41,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:22:06'),
(77,42,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:17:06'),
(78,42,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:22:06'),
(79,42,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:27:06'),
(80,43,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(81,43,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:22:06'),
(82,44,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:17:06'),
(83,45,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:17:06'),
(84,45,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-02 17:22:06'),
(85,46,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-29 17:17:06'),
(86,46,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 17:22:06'),
(87,46,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:27:06'),
(88,47,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-01 17:17:06'),
(89,47,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:22:06'),
(90,48,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-06 17:17:06'),
(91,48,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-10-30 17:22:06'),
(92,49,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-03 17:17:06'),
(93,49,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:22:06'),
(94,50,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:17:06'),
(95,51,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:17:06'),
(96,51,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-04 17:22:06'),
(97,52,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 17:17:06'),
(98,52,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:22:06'),
(99,53,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(100,53,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-10-29 17:22:06'),
(101,53,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:27:06'),
(102,54,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 17:17:06'),
(103,54,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-05 17:22:06'),
(104,54,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:27:06'),
(105,55,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:17:06'),
(106,56,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-04 17:17:06'),
(107,56,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 17:22:06'),
(108,56,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-05 17:27:06'),
(109,57,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 17:17:06'),
(110,58,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-31 17:17:06'),
(111,59,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-01 17:17:06'),
(112,60,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-31 17:17:06'),
(113,60,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-10-31 17:22:06'),
(114,61,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:44:47'),
(115,61,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:49:47'),
(116,61,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:54:47'),
(117,62,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-11-03 17:44:47'),
(118,62,'pending','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:49:47'),
(119,62,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:54:47'),
(120,63,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-04 17:44:47'),
(121,63,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:49:47'),
(122,63,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:54:47'),
(123,64,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-28 17:44:47'),
(124,64,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-10-31 17:49:47'),
(125,64,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-04 17:54:47'),
(126,65,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:44:47'),
(127,65,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:49:47'),
(128,65,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:54:47'),
(129,66,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:44:47'),
(130,66,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:49:47'),
(131,67,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 17:44:47'),
(132,67,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:49:47'),
(133,67,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-31 17:54:47'),
(134,68,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:44:47'),
(135,69,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:44:47'),
(136,69,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:49:47'),
(137,70,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-06 17:44:47'),
(138,70,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-05 17:49:47'),
(139,70,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 17:54:47'),
(140,71,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:44:47'),
(141,72,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:44:47'),
(142,72,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:49:47'),
(143,73,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:44:47'),
(144,73,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 17:49:47'),
(145,73,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-29 17:54:47'),
(146,74,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:44:47'),
(147,74,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:49:47'),
(148,74,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-05 17:54:47'),
(149,75,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:44:47'),
(150,75,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-28 17:49:47'),
(151,75,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-03 17:54:47'),
(152,76,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-02 17:44:47'),
(153,76,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 17:49:47'),
(154,76,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:54:47'),
(155,77,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-28 17:44:47'),
(156,77,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-29 17:49:47'),
(157,78,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:44:47'),
(158,78,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:49:47'),
(159,79,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 17:44:47'),
(160,80,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-01 17:44:47'),
(161,81,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:44:47'),
(162,81,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:49:47'),
(163,82,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-01 17:44:47'),
(164,82,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 17:49:47'),
(165,83,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 17:44:47'),
(166,83,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:49:47'),
(167,84,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-28 17:44:47'),
(168,85,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-30 17:44:47'),
(169,86,'yes','pending','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:44:47'),
(170,86,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:49:47'),
(171,87,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-11-05 17:44:47'),
(172,87,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-11-03 17:49:47'),
(173,88,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:44:47'),
(174,89,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-02 17:44:47'),
(175,89,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 17:49:47'),
(176,89,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:54:47'),
(177,90,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-01 17:44:47'),
(178,90,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-29 17:49:47'),
(179,91,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 17:44:47'),
(180,92,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-01 17:44:47'),
(181,92,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-31 17:49:47'),
(182,92,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:54:47'),
(183,93,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:44:47'),
(184,93,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-03 17:49:47'),
(185,93,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-04 17:54:47'),
(186,94,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-04 17:44:47'),
(187,94,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:49:47'),
(188,94,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:54:47'),
(189,95,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:44:47'),
(190,95,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-28 17:49:47'),
(191,96,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-10-30 17:44:47'),
(192,96,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-01 17:49:47'),
(193,97,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-05 17:44:47'),
(194,97,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:49:47'),
(195,98,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-06 17:44:47'),
(196,99,'pending','no','{\"source\": \"deck\"}',NULL,'2025-11-05 17:44:47'),
(197,99,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-28 17:49:47'),
(198,100,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 17:44:47'),
(199,100,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:49:47'),
(200,101,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-10-31 17:44:47'),
(201,102,'pending','no','{\"source\": \"deck\"}',NULL,'2025-10-29 17:44:47'),
(202,102,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-03 17:49:47'),
(203,102,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 17:54:47'),
(204,103,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:44:47'),
(205,103,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-05 17:49:47'),
(206,104,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-10-29 17:44:47'),
(207,105,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-11-05 17:44:47'),
(208,105,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 17:49:47'),
(209,78,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:01:55'),
(210,102,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:01:58'),
(211,90,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:07'),
(212,74,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:09'),
(213,100,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:11'),
(214,69,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:20'),
(215,84,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:22'),
(216,72,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:25'),
(217,99,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:02:27'),
(218,70,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:08:17'),
(219,75,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:08:21'),
(220,79,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:08:26'),
(221,89,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:08:57'),
(222,105,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:09:58'),
(223,81,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:10:02'),
(224,85,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:10:10'),
(225,80,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:10:12'),
(226,73,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:27:34'),
(227,101,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:27:36'),
(228,65,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:27:39'),
(229,95,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:27:47'),
(230,77,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:27:49'),
(231,71,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:28:14'),
(232,76,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:28:22'),
(233,91,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:28:23'),
(234,97,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:28:35'),
(235,62,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:28:38'),
(236,102,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(237,74,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(238,84,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(239,99,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(240,70,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(241,97,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(242,81,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(243,95,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(244,67,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(245,68,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(246,88,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(247,73,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(248,71,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(249,63,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(250,96,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(251,92,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:29:36'),
(252,102,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:23'),
(253,74,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:25'),
(254,84,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:26'),
(255,99,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:27'),
(256,70,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:30'),
(257,81,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:32'),
(258,73,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:38'),
(259,95,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:41'),
(260,71,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:44'),
(261,97,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:45'),
(262,88,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:46'),
(263,67,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:50'),
(264,68,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:51'),
(265,63,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:53'),
(266,96,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:54'),
(267,92,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:32:55'),
(268,102,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:13'),
(269,74,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(270,84,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(271,99,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(272,70,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(273,81,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(274,71,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(275,73,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(276,88,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(277,68,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(278,63,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(279,97,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(280,95,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(281,67,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(282,96,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(283,92,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:24'),
(284,90,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:40'),
(285,89,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(286,79,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(287,105,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(288,80,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(289,65,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(290,104,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(291,66,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(292,76,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(293,87,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(294,98,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(295,64,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(296,86,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(297,82,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(298,93,'pending','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:44'),
(299,69,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(300,78,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(301,72,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(302,100,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(303,75,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(304,85,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(305,77,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(306,62,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(307,61,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(308,94,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(309,101,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(310,91,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(311,103,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(312,83,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:33:51'),
(313,103,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:32'),
(314,101,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:34'),
(315,100,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:35'),
(316,94,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:37'),
(317,91,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:38'),
(318,85,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:39'),
(319,83,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:41'),
(320,78,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:42'),
(321,77,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:43'),
(322,75,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:45'),
(323,72,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:46'),
(324,69,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:49'),
(325,62,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:51'),
(326,61,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:52'),
(327,105,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:54'),
(328,104,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:55'),
(329,98,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:56'),
(330,93,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:58'),
(331,89,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:41:59'),
(332,87,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:01'),
(333,86,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:02'),
(334,82,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:04'),
(335,80,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:05'),
(336,79,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:07'),
(337,76,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:08'),
(338,66,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:09'),
(339,65,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:11'),
(340,64,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:13'),
(341,90,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:14'),
(342,99,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:16'),
(343,97,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:17'),
(344,96,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:18'),
(345,95,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:19'),
(346,92,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:21'),
(347,88,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:22'),
(348,84,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:23'),
(349,81,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 21:42:26'),
(350,100,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(351,94,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(352,78,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(353,69,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(354,75,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(355,104,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(356,93,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(357,99,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(358,92,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(359,88,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(360,87,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(361,76,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(362,65,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(363,84,'no','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:00:39'),
(364,91,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(365,83,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(366,103,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(367,85,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(368,77,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(369,72,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(370,98,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(371,86,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(372,64,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(373,97,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(374,105,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(375,89,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(376,66,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(377,96,'yes','undecided','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:18'),
(378,105,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:33'),
(379,103,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:34'),
(380,98,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:36'),
(381,97,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:38'),
(382,96,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:39'),
(383,91,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:40'),
(384,89,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',2,'2025-11-07 22:30:42'),
(385,106,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-04 22:52:15'),
(386,107,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-28 22:52:15'),
(387,107,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-05 22:57:15'),
(388,107,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 23:02:15'),
(389,108,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 22:52:15'),
(390,108,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-01 22:57:15'),
(391,108,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-28 23:02:15'),
(392,109,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-02 22:52:15'),
(393,109,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 22:57:15'),
(394,109,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 23:02:15'),
(395,110,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-04 22:52:15'),
(396,110,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-10-29 22:57:15'),
(397,111,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 22:52:15'),
(398,112,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-02 22:52:15'),
(399,112,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 22:57:15'),
(400,112,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 23:02:15'),
(401,113,'no','yes','{\"source\": \"deck\"}',NULL,'2025-10-30 22:52:15'),
(402,114,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-02 22:52:15'),
(403,115,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-30 22:52:15'),
(404,115,'no','pending','{\"source\": \"deck\"}',NULL,'2025-10-29 22:57:15'),
(405,116,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-10-29 22:52:15'),
(406,116,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 22:57:15'),
(407,117,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-28 22:52:15'),
(408,118,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-11-01 22:52:15'),
(409,118,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-28 22:57:15'),
(410,119,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-06 22:52:15'),
(411,120,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-04 22:52:15'),
(412,120,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-28 22:57:15'),
(413,121,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 22:52:15'),
(414,122,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-29 22:52:15'),
(415,122,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-10-31 22:57:15'),
(416,122,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-11-05 23:02:15'),
(417,123,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-05 22:52:15'),
(418,123,'pending','no','{\"source\": \"bulk\"}',NULL,'2025-11-04 22:57:15'),
(419,123,'no','yes','{\"source\": \"requeue\"}',NULL,'2025-11-02 23:02:15'),
(420,124,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-11-03 22:52:15'),
(421,124,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-31 22:57:15'),
(422,124,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-11-03 23:02:15'),
(423,125,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-01 22:52:15'),
(424,125,'undecided','pending','{\"source\": \"requeue\"}',NULL,'2025-11-04 22:57:15'),
(425,126,'no','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 22:52:15'),
(426,127,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-31 22:52:15'),
(427,128,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 22:52:15'),
(428,128,'yes','no','{\"source\": \"deck\"}',NULL,'2025-11-04 22:57:15'),
(429,129,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-11-03 22:52:15'),
(430,129,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-06 22:57:15'),
(431,130,'pending','no','{\"source\": \"requeue\"}',NULL,'2025-11-05 22:52:15'),
(432,130,'no','yes','{\"source\": \"bulk\"}',NULL,'2025-10-31 22:57:15'),
(433,130,'yes','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 23:02:15'),
(434,131,'yes','pending','{\"source\": \"deck\"}',NULL,'2025-10-31 22:52:15'),
(435,131,'pending','undecided','{\"source\": \"bulk\"}',NULL,'2025-10-29 22:57:15'),
(436,132,'no','pending','{\"source\": \"deck\"}',NULL,'2025-11-05 22:52:15'),
(437,132,'pending','undecided','{\"source\": \"requeue\"}',NULL,'2025-10-28 22:57:15'),
(438,132,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-05 23:02:15'),
(439,133,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-11-02 22:52:15'),
(440,134,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-11-02 22:52:15'),
(441,134,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-04 22:57:15'),
(442,134,'undecided','pending','{\"source\": \"bulk\"}',NULL,'2025-10-31 23:02:15'),
(443,135,'no','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-04 22:52:15'),
(444,136,'no','undecided','{\"source\": \"bulk\"}',NULL,'2025-11-03 22:52:15'),
(445,137,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-10-29 22:52:15'),
(446,137,'yes','pending','{\"source\": \"bulk\"}',NULL,'2025-10-30 22:57:15'),
(447,138,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-10-31 22:52:15'),
(448,138,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 22:57:15'),
(449,138,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-01 23:02:15'),
(450,139,'no','yes','{\"source\": \"deck\"}',NULL,'2025-11-05 22:52:15'),
(451,139,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-02 22:57:15'),
(452,139,'undecided','pending','{\"source\": \"deck\"}',NULL,'2025-10-28 23:02:15'),
(453,140,'pending','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 22:52:15'),
(454,140,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-03 22:57:15'),
(455,141,'undecided','yes','{\"source\": \"bulk\"}',NULL,'2025-10-29 22:52:15'),
(456,141,'yes','no','{\"source\": \"deck\"}',NULL,'2025-10-30 22:57:15'),
(457,142,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-10-28 22:52:15'),
(458,142,'undecided','no','{\"source\": \"bulk\"}',NULL,'2025-11-06 22:57:15'),
(459,142,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-31 23:02:15'),
(460,143,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-01 22:52:15'),
(461,143,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-11-03 22:57:15'),
(462,144,'pending','yes','{\"source\": \"requeue\"}',NULL,'2025-10-28 22:52:15'),
(463,145,'undecided','yes','{\"source\": \"deck\"}',NULL,'2025-11-02 22:52:15'),
(464,145,'yes','no','{\"source\": \"bulk\"}',NULL,'2025-10-30 22:57:15'),
(465,145,'no','pending','{\"source\": \"bulk\"}',NULL,'2025-10-29 23:02:15'),
(466,146,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-11-01 22:52:15'),
(467,146,'pending','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 22:57:15'),
(468,146,'undecided','yes','{\"source\": \"requeue\"}',NULL,'2025-11-04 23:02:15'),
(469,147,'yes','undecided','{\"source\": \"requeue\"}',NULL,'2025-11-05 22:52:15'),
(470,147,'undecided','no','{\"source\": \"deck\"}',NULL,'2025-11-01 22:57:15'),
(471,148,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-11-04 22:52:15'),
(472,149,'yes','undecided','{\"source\": \"deck\"}',NULL,'2025-11-05 22:52:15'),
(473,149,'undecided','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 22:57:15'),
(474,149,'no','pending','{\"source\": \"requeue\"}',NULL,'2025-10-31 23:02:15'),
(475,150,'yes','no','{\"source\": \"requeue\"}',NULL,'2025-10-30 22:52:15'),
(476,115,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:25'),
(477,117,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:27'),
(478,149,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:28'),
(479,123,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:29'),
(480,141,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:31'),
(481,107,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:33'),
(482,120,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:34'),
(483,143,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:37'),
(484,108,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:39'),
(485,142,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:43'),
(486,109,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:46'),
(487,137,'undecided','no','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:47'),
(488,118,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:50'),
(489,116,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:52'),
(490,127,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:54'),
(491,124,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:56'),
(492,150,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:00:58'),
(493,134,'undecided','pending','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:01:01'),
(494,151,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:07:59'),
(495,152,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:08:03'),
(496,153,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:09:24'),
(497,154,'undecided','yes','{\"endpoint\": \"api.items.decidir\"}',3,'2025-11-07 23:16:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_media`
--

LOCK TABLES `item_media` WRITE;
/*!40000 ALTER TABLE `item_media` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `item_media` VALUES
(1,1,'local','items/b607ba29-72e9-4f29-be99-5d9ae87505c3.png','items/thumbs/b607ba29-72e9-4f29-be99-5d9ae87505c3.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(2,7,'local','items/a9221011-daa2-4db8-9f87-9a8ee73d8cdd.png','items/thumbs/a9221011-daa2-4db8-9f87-9a8ee73d8cdd.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(3,13,'local','items/d2e6ab09-e225-4972-b368-578b2881ec2f.png','items/thumbs/d2e6ab09-e225-4972-b368-578b2881ec2f.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(4,38,'local','items/e28785b2-1bb1-4760-937f-4df5c9a5e165.png','items/thumbs/e28785b2-1bb1-4760-937f-4df5c9a5e165.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(5,40,'local','items/97f821c9-bcf8-47a8-b363-e121cb0740af.png','items/thumbs/97f821c9-bcf8-47a8-b363-e121cb0740af.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(6,45,'local','items/5d543ee2-e00a-4de5-b6da-db1f03a13396.png','items/thumbs/5d543ee2-e00a-4de5-b6da-db1f03a13396.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(7,51,'local','items/3d0ae365-286b-49c8-a0eb-1e17fd0cf767.png','items/thumbs/3d0ae365-286b-49c8-a0eb-1e17fd0cf767.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(8,54,'local','items/0781ad95-a30b-4fd3-9fb4-52b0d6d00a4b.png','items/thumbs/0781ad95-a30b-4fd3-9fb4-52b0d6d00a4b.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(9,55,'local','items/c336836f-af0f-4792-a802-7f9d70345964.png','items/thumbs/c336836f-af0f-4792-a802-7f9d70345964.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(10,57,'local','items/ce9c1235-cc01-4ac8-be2c-44f9386bb077.png','items/thumbs/ce9c1235-cc01-4ac8-be2c-44f9386bb077.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06'),
(11,67,'local','items/73c4a5d3-f101-4c4d-915f-c8537a7c371d.png','items/thumbs/73c4a5d3-f101-4c4d-915f-c8537a7c371d.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(12,69,'local','items/e768557f-de6b-490d-8533-58e3738b3c3d.png','items/thumbs/e768557f-de6b-490d-8533-58e3738b3c3d.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(13,70,'local','items/df6d67dd-89c5-4f22-a300-5e66b0d5ad85.png','items/thumbs/df6d67dd-89c5-4f22-a300-5e66b0d5ad85.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(14,73,'local','items/63d35bad-bd5c-4522-9602-33f3b8355570.png','items/thumbs/63d35bad-bd5c-4522-9602-33f3b8355570.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(15,80,'local','items/5789410e-a697-47cb-aa54-aa3ed5509943.png','items/thumbs/5789410e-a697-47cb-aa54-aa3ed5509943.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(16,90,'local','items/15045b6a-d6ff-44e1-bdf4-148ca972d9f7.png','items/thumbs/15045b6a-d6ff-44e1-bdf4-148ca972d9f7.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(17,93,'local','items/c6ca6143-de35-4f9e-b6a2-743dca6ee0a3.png','items/thumbs/c6ca6143-de35-4f9e-b6a2-743dca6ee0a3.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(18,94,'local','items/e750e5eb-3b92-4206-805e-5f5713c100f7.png','items/thumbs/e750e5eb-3b92-4206-805e-5f5713c100f7.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(19,100,'local','items/2594f780-e734-4ae7-941f-0657178cf2d8.png','items/thumbs/2594f780-e734-4ae7-941f-0657178cf2d8.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(20,103,'local','items/56439c67-a4fc-4741-99f7-7c76fb0c935a.png','items/thumbs/56439c67-a4fc-4741-99f7-7c76fb0c935a.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(21,105,'local','items/41a5ff3c-f06e-4de2-81a0-53d471d4fd92.png','items/thumbs/41a5ff3c-f06e-4de2-81a0-53d471d4fd92.png','done',70,1,1,'image/png',NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47'),
(22,108,'local','items/49672366-c2a0-474c-b35c-2b679a121c77.png','items/thumbs/49672366-c2a0-474c-b35c-2b679a121c77.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(23,111,'local','items/a8dbd86a-5ddc-4ff6-bcd9-34332a5c43f9.png','items/thumbs/a8dbd86a-5ddc-4ff6-bcd9-34332a5c43f9.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(24,115,'local','items/724450aa-f30e-41c4-b093-476609c65ada.png','items/thumbs/724450aa-f30e-41c4-b093-476609c65ada.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(25,119,'local','items/99aefe46-3ced-4137-a777-2606a55de1c4.png','items/thumbs/99aefe46-3ced-4137-a777-2606a55de1c4.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(26,123,'local','items/3db8375c-3555-472e-a3a9-2565887182c5.png','items/thumbs/3db8375c-3555-472e-a3a9-2565887182c5.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(27,125,'local','items/9c471d6d-cb5a-45ae-9cde-c1447650f1db.png','items/thumbs/9c471d6d-cb5a-45ae-9cde-c1447650f1db.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(28,127,'local','items/394d9d41-b9dd-431c-84d5-d2901ae7a3af.png','items/thumbs/394d9d41-b9dd-431c-84d5-d2901ae7a3af.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(29,132,'local','items/64503b67-d330-471e-851c-65e65d84864f.png','items/thumbs/64503b67-d330-471e-851c-65e65d84864f.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(30,138,'local','items/0cfd6637-2572-47fb-832b-c912e2c50271.png','items/thumbs/0cfd6637-2572-47fb-832b-c912e2c50271.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(31,139,'local','items/ee3152e2-9fff-44f9-a0eb-b0aaa6c495a5.png','items/thumbs/ee3152e2-9fff-44f9-a0eb-b0aaa6c495a5.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(32,147,'local','items/248da433-34ff-4b5a-a2d2-e9dd0ec8ff25.png','items/thumbs/248da433-34ff-4b5a-a2d2-e9dd0ec8ff25.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(33,148,'local','items/eddd39a5-5c8c-4655-835e-d565a65e5b56.png','items/thumbs/eddd39a5-5c8c-4655-835e-d565a65e5b56.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(34,150,'local','items/644e2c59-7ea6-42c9-b1a0-e59cf50a1a0f.png','items/thumbs/644e2c59-7ea6-42c9-b1a0-e59cf50a1a0f.png','done',70,1,1,'image/png',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15'),
(35,151,'public','items/151/d2b9c85d-4768-418d-af2b-9e356301671e.jpeg','items/151/thumbs/d2b9c85d-4768-418d-af2b-9e356301671e.jpeg','done',108636,617,810,'image/jpeg',3,'2025-11-07 22:57:32','2025-11-07 22:57:32'),
(36,152,'public','items/152/d28d5eb1-337e-42dd-aeaa-cbdc1348ec18.png','items/152/thumbs/d28d5eb1-337e-42dd-aeaa-cbdc1348ec18.png','done',101640,606,586,'image/png',3,'2025-11-07 23:00:09','2025-11-07 23:00:09'),
(37,153,'public','items/153/ea7f77c3-60d4-4e27-86e7-05c15c3c9dd4.jpg','items/153/thumbs/ea7f77c3-60d4-4e27-86e7-05c15c3c9dd4.jpg','done',292816,540,960,'image/jpeg',3,'2025-11-07 23:09:12','2025-11-07 23:09:12'),
(38,154,'public','items/154/6960e2bd-312d-4826-89cf-f049c5bb6b10.jpg','items/154/thumbs/6960e2bd-312d-4826-89cf-f049c5bb6b10.jpg','done',129062,1200,750,'image/jpeg',3,'2025-11-07 23:15:49','2025-11-07 23:15:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `items` VALUES
(1,1,1,'Molestias in.','Nesciunt soluta esse modi excepturi ex dolorem quo cum.',3.02,63360.00,'55 × 36 × 32 cm','bedroom',NULL,0,'yes','2025-11-03 17:17:06',1155,NULL,'/storage/items/b607ba29-72e9-4f29-be99-5d9ae87505c3.png','/storage/items/thumbs/b607ba29-72e9-4f29-be99-5d9ae87505c3.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(2,1,2,'Sit illum nobis aperiam.',NULL,2.51,118720.00,'56 × 53 × 40 cm','bathroom',NULL,1,'yes',NULL,1037,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(3,1,NULL,'A eos ut fugit.','Doloremque omnis repellendus et aut ut id qui quo.',0.16,50320.00,'74 × 20 × 34 cm','kitchen','rerum',0,'undecided',NULL,28,'Reprehenderit molestiae nulla.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(4,1,1,'Modi dolorem autem.','Perspiciatis sit et temporibus voluptas tempora aut blanditiis sed qui.',1.56,131614.00,'79 × 49 × 34 cm','living_room','et',0,'yes','2025-11-06 17:17:06',1114,'Omnis consequatur eos quia.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(5,1,NULL,'Rem molestiae repellat quisquam.',NULL,1.40,36036.00,'84 × 39 × 11 cm','office',NULL,1,'pending',NULL,231,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(6,1,NULL,'Perspiciatis repellat praesentium.',NULL,1.51,8190.00,'35 × 18 × 13 cm','storage','dolor',0,'undecided',NULL,62,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(7,1,2,'Aliquam consequatur aspernatur quis.','Reiciendis omnis aperiam sint molestias et vel sit et fuga voluptas rerum.',0.90,156310.00,'77 × 58 × 35 cm','kitchen',NULL,0,'no',NULL,909,NULL,'/storage/items/a9221011-daa2-4db8-9f87-9a8ee73d8cdd.png','/storage/items/thumbs/a9221011-daa2-4db8-9f87-9a8ee73d8cdd.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(8,1,NULL,'Fugiat iusto assumenda.','Beatae est unde enim ipsa velit dignissimos deleniti.',0.22,48285.00,'45 × 29 × 37 cm','other','ratione',0,'undecided',NULL,-36,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(9,1,1,'Qui facere odit.',NULL,1.12,62560.00,'46 × 34 × 40 cm','living_room',NULL,0,'yes',NULL,619,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(10,1,2,'Laboriosam quisquam iste et.','Exercitationem aut tempora fugiat amet illo illum corrupti qui nisi ut et ad tempore.',1.25,103040.00,'46 × 56 × 40 cm','other',NULL,0,'yes','2025-11-05 17:17:06',771,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(11,1,NULL,'Pariatur quaerat voluptas.','Architecto minima voluptatem pariatur accusamus vitae harum facere sint totam maiores aspernatur qui recusandae.',0.45,28576.00,'47 × 16 × 38 cm','bathroom',NULL,0,'undecided',NULL,166,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(12,1,NULL,'Sed quod blanditiis id incidunt.','Nihil ea minus blanditiis ea quaerat nemo et soluta nisi qui sit.',0.99,73408.00,'62 × 37 × 32 cm','storage',NULL,0,'pending',NULL,385,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(13,1,NULL,'Autem aliquid repudiandae consequatur.','Rerum et aut aspernatur rerum voluptatem est ullam itaque.',1.71,108300.00,'76 × 57 × 25 cm','kitchen','aliquam',1,'pending',NULL,331,NULL,'/storage/items/d2e6ab09-e225-4972-b368-578b2881ec2f.png','/storage/items/thumbs/d2e6ab09-e225-4972-b368-578b2881ec2f.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(14,1,NULL,'Laudantium libero qui.',NULL,2.41,103530.00,'58 × 51 × 35 cm','other','facere',0,'pending',NULL,321,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(15,1,NULL,'Quia aperiam recusandae dolor.','Maxime animi sunt eos optio cum veritatis voluptatem.',1.37,56550.00,'78 × 29 × 25 cm','bathroom',NULL,1,'no',NULL,978,'Illo repudiandae magni qui.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(16,1,NULL,'Non exercitationem at libero amet.',NULL,0.61,58056.00,'41 × 59 × 24 cm','office','occaecati',0,'pending','2025-10-31 01:29:14',585,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(17,1,NULL,'Maiores quos voluptatem.',NULL,1.97,19980.00,'74 × 27 × 10 cm','kitchen',NULL,0,'undecided',NULL,-160,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(18,1,NULL,'Totam voluptas repellendus ut voluptatibus.',NULL,0.56,16744.00,'46 × 28 × 13 cm','storage','facere',1,'pending','2025-11-02 07:59:54',389,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(19,1,NULL,'Repellat accusamus et.','Iusto fugit ab voluptatem sit tempore exercitationem harum ut sit et.',1.48,59584.00,'38 × 56 × 28 cm','bedroom','ut',0,'pending',NULL,279,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(20,1,NULL,'Dolorum officia eum harum.','Voluptatum vel enim eaque molestiae fuga ullam dolores maiores beatae eveniet.',0.21,77616.00,'84 × 28 × 33 cm','office','ullam',0,'pending',NULL,298,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(21,1,NULL,'Dolorem nobis possimus.',NULL,3.05,48348.00,'79 × 36 × 17 cm','bedroom',NULL,1,'undecided',NULL,196,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(22,1,NULL,'Corporis ipsum unde.','Eos fugiat repellendus maxime porro rerum aut deserunt aut autem.',1.60,40194.00,'66 × 29 × 21 cm','office',NULL,0,'pending','2025-11-01 10:54:36',397,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(23,1,NULL,'Saepe voluptatum exercitationem quod.','Quia nam laborum ut numquam et sed voluptas harum.',1.76,49770.00,'79 × 18 × 35 cm','bathroom',NULL,0,'pending',NULL,212,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(24,1,NULL,'Consequatur ab quasi alias voluptatem.','Est esse placeat unde aliquam voluptatem nulla ullam incidunt culpa voluptates quisquam aut a.',0.74,63800.00,'55 × 29 × 40 cm','office','ut',0,'pending',NULL,516,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(25,1,NULL,'Facilis dicta ducimus.',NULL,2.51,19980.00,'36 × 15 × 37 cm','storage',NULL,1,'undecided',NULL,-78,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(26,1,2,'Enim quibusdam non cupiditate.',NULL,1.16,36960.00,'56 × 60 × 11 cm','bathroom',NULL,0,'no','2025-11-01 07:18:19',844,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(27,1,1,'Modi nam nesciunt.',NULL,3.07,38220.00,'49 × 52 × 15 cm','living_room','autem',1,'yes',NULL,915,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(28,1,NULL,'Dolor animi sequi qui.',NULL,2.48,25272.00,'36 × 39 × 18 cm','storage',NULL,0,'pending',NULL,579,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(29,1,NULL,'Velit numquam.','Eveniet porro expedita atque atque dignissimos repellat quis repellat.',2.42,31648.00,'43 × 46 × 16 cm','storage',NULL,0,'undecided',NULL,50,'Et hic quasi reiciendis.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(30,1,2,'Sit tempora ut omnis.',NULL,3.33,93000.00,'75 × 31 × 40 cm','kitchen',NULL,0,'yes','2025-11-06 17:17:06',868,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(31,1,NULL,'Et aut ducimus.',NULL,1.85,15444.00,'66 × 18 × 13 cm','bathroom','nihil',0,'no',NULL,768,'Quas nobis aut dolores.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(32,1,2,'Dolores corrupti architecto rem.','Voluptas rerum ratione amet sit dolorum quia assumenda beatae in fuga.',2.19,37128.00,'28 × 51 × 26 cm','other',NULL,0,'yes','2025-11-06 17:17:06',1022,'Et earum tempore.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(33,1,NULL,'Dolore reprehenderit quis iure.',NULL,2.44,63936.00,'74 × 24 × 36 cm','kitchen','tempora',1,'undecided',NULL,-40,'Facilis nostrum non.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(34,1,NULL,'Quam hic totam reiciendis.','Magni necessitatibus quo rerum quas voluptatibus eum voluptate.',1.26,116480.00,'80 × 56 × 26 cm','bedroom','et',0,'undecided',NULL,-186,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(35,1,2,'Blanditiis rem dolor quam.','Eum eum sit veniam id iste voluptatem rerum.',0.49,7722.00,'22 × 27 × 13 cm','storage',NULL,0,'no',NULL,925,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(36,1,2,'Dolor nihil accusantium odio.','Quidem sit sunt eius nam ab assumenda dolores quisquam.',2.74,29946.00,'42 × 23 × 31 cm','kitchen','eos',1,'no',NULL,1128,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(37,1,NULL,'Tenetur qui commodi non.','Deserunt amet temporibus iusto saepe est tenetur eius magnam vitae recusandae ratione laudantium.',1.71,48048.00,'52 × 28 × 33 cm','office',NULL,0,'undecided','2025-10-29 21:14:02',102,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(38,1,NULL,'Corporis quis.',NULL,3.50,48180.00,'73 × 33 × 20 cm','bedroom',NULL,1,'no',NULL,788,NULL,'/storage/items/e28785b2-1bb1-4760-937f-4df5c9a5e165.png','/storage/items/thumbs/e28785b2-1bb1-4760-937f-4df5c9a5e165.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(39,1,2,'Praesentium aperiam veritatis.','Aut aut culpa recusandae quisquam eaque odio nisi impedit in voluptas et ipsum dolor.',2.53,39100.00,'50 × 34 × 23 cm','kitchen',NULL,0,'yes','2025-11-04 17:17:06',907,'Adipisci amet.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(40,1,NULL,'Perferendis molestias cupiditate id.','Officia ipsum voluptate ut rem et odio exercitationem.',0.41,34848.00,'66 × 16 × 33 cm','office',NULL,0,'undecided',NULL,-110,NULL,'/storage/items/97f821c9-bcf8-47a8-b363-e121cb0740af.png','/storage/items/thumbs/97f821c9-bcf8-47a8-b363-e121cb0740af.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(41,1,NULL,'Maiores sunt et necessitatibus.','Tempora tenetur aut harum sit quia sed minus deleniti perspiciatis possimus ut.',0.92,76590.00,'46 × 45 × 37 cm','living_room',NULL,0,'undecided',NULL,45,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(42,1,2,'Impedit et corrupti.',NULL,2.42,19800.00,'30 × 20 × 33 cm','other',NULL,0,'yes',NULL,1012,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(43,1,1,'Atque consequatur nisi.',NULL,0.87,18432.00,'72 × 16 × 16 cm','other',NULL,1,'no','2025-11-01 21:20:41',653,'Dolor sit aut reprehenderit.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(44,1,NULL,'In voluptas ratione.',NULL,0.47,21216.00,'34 × 16 × 39 cm','living_room',NULL,0,'undecided',NULL,65,'Animi ut reiciendis voluptatem.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(45,1,NULL,'Autem excepturi velit.','Facere ex quis qui inventore itaque reprehenderit voluptas.',0.98,32144.00,'41 × 28 × 28 cm','kitchen',NULL,1,'undecided',NULL,188,'Consequatur et vel fuga.','/storage/items/5d543ee2-e00a-4de5-b6da-db1f03a13396.png','/storage/items/thumbs/5d543ee2-e00a-4de5-b6da-db1f03a13396.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(46,1,NULL,'Et qui molestias.',NULL,0.76,121800.00,'58 × 60 × 35 cm','living_room',NULL,1,'undecided','2025-11-01 22:40:20',-170,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(47,1,NULL,'Culpa consequatur.','Nesciunt vero quo eum deserunt tempora laboriosam nam asperiores iure.',2.43,11594.00,'31 × 22 × 17 cm','kitchen','vitae',1,'undecided',NULL,-25,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(48,1,NULL,'Dolorem in voluptate.','Molestiae maxime tenetur delectus molestiae pariatur exercitationem nobis explicabo enim harum voluptas dicta qui.',2.78,12312.00,'24 × 27 × 19 cm','bathroom','similique',1,'pending','2025-10-28 18:33:47',501,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(49,1,NULL,'Omnis sint impedit.','Sit eius accusantium rerum quia quae hic rem quibusdam ut libero et.',2.20,51200.00,'64 × 20 × 40 cm','storage',NULL,0,'undecided',NULL,116,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(50,1,2,'Labore dolor ipsa magni.',NULL,1.01,116280.00,'60 × 57 × 34 cm','storage','facilis',0,'yes',NULL,1079,'Iusto enim occaecati quia.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(51,1,NULL,'Dolorem cum aut et.',NULL,3.26,41472.00,'36 × 32 × 36 cm','bathroom','qui',0,'undecided',NULL,160,NULL,'/storage/items/3d0ae365-286b-49c8-a0eb-1e17fd0cf767.png','/storage/items/thumbs/3d0ae365-286b-49c8-a0eb-1e17fd0cf767.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(52,1,NULL,'Facilis et quia saepe.','Voluptas quis magnam blanditiis harum voluptatem fugit consequatur aut.',2.85,47212.00,'44 × 37 × 29 cm','storage','laborum',0,'pending',NULL,513,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(53,1,1,'Reiciendis laudantium reiciendis explicabo.',NULL,0.76,20184.00,'29 × 29 × 24 cm','storage',NULL,0,'yes',NULL,793,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(54,1,NULL,'Fugit expedita ducimus.','Voluptatem voluptates placeat in sint quia aut aspernatur et et aut quisquam.',3.09,25600.00,'25 × 32 × 32 cm','bathroom',NULL,0,'pending',NULL,201,NULL,'/storage/items/0781ad95-a30b-4fd3-9fb4-52b0d6d00a4b.png','/storage/items/thumbs/0781ad95-a30b-4fd3-9fb4-52b0d6d00a4b.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(55,1,1,'Et deleniti mollitia.','Mollitia et velit est quo distinctio laudantium rerum vitae non facere modi cum.',2.41,27540.00,'54 × 30 × 17 cm','storage',NULL,0,'yes','2025-11-07 17:17:06',1153,NULL,'/storage/items/c336836f-af0f-4792-a802-7f9d70345964.png','/storage/items/thumbs/c336836f-af0f-4792-a802-7f9d70345964.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(56,1,1,'Maxime iste.',NULL,1.13,76095.00,'89 × 57 × 15 cm','storage',NULL,0,'yes','2025-11-07 17:17:06',928,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(57,1,NULL,'Omnis nisi doloremque pariatur.',NULL,2.59,20736.00,'27 × 48 × 16 cm','office',NULL,0,'undecided',NULL,-158,NULL,'/storage/items/ce9c1235-cc01-4ac8-be2c-44f9386bb077.png','/storage/items/thumbs/ce9c1235-cc01-4ac8-be2c-44f9386bb077.png','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(58,1,NULL,'Nobis ea qui hic.','Cum labore mollitia blanditiis consequatur nulla consequatur quisquam quia ducimus voluptatem labore minus.',1.29,23287.00,'73 × 29 × 11 cm','kitchen','ut',0,'undecided','2025-10-31 18:22:29',88,'Iusto vitae minus officia.',NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(59,1,NULL,'Voluptas perferendis excepturi quam.',NULL,2.19,74382.00,'49 × 46 × 33 cm','kitchen','nihil',1,'no',NULL,643,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(60,1,1,'Et et adipisci quas.','Voluptatem sed est beatae omnis labore asperiores totam maxime est cumque itaque et excepturi.',2.12,26460.00,'70 × 18 × 21 cm','kitchen',NULL,0,'yes','2025-11-02 17:17:06',615,NULL,NULL,NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(61,2,NULL,'Omnis magni qui molestias.','Eveniet dignissimos aut aut qui aliquid id ea qui excepturi voluptates assumenda.',0.28,21252.00,'21 × 46 × 22 cm','living_room','alias',1,'pending',NULL,-201,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:41:52',NULL),
(62,2,NULL,'Quia dolorem aut nostrum.','Doloribus quisquam possimus vitae illo corporis pariatur nobis.',0.87,25116.00,'69 × 26 × 14 cm','bedroom','deleniti',0,'pending',NULL,-202,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:41:51',NULL),
(63,2,NULL,'Culpa non.','Doloremque molestiae aut animi rerum fugiat minus excepturi vel maiores perferendis neque eius voluptatem.',1.26,74340.00,'35 × 59 × 36 cm','bedroom',NULL,0,'undecided',NULL,-158,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(64,2,NULL,'Vel dolorem culpa eaque.','Autem inventore asperiores nesciunt voluptate et placeat perferendis harum commodi non dolorem.',1.28,12800.00,'32 × 16 × 25 cm','storage',NULL,0,'undecided',NULL,-227,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(65,2,NULL,'Molestiae non quis et.','Velit vero impedit dignissimos eum optio occaecati aut aut.',0.95,52272.00,'66 × 44 × 18 cm','bedroom',NULL,1,'undecided',NULL,-213,'Libero minus fuga.',NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(66,2,NULL,'Consequatur in qui voluptas.','Molestiae est sapiente reiciendis ipsa totam vel qui quasi voluptatem.',3.06,77112.00,'84 × 27 × 34 cm','office',NULL,0,'undecided',NULL,-228,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(67,2,NULL,'Impedit nam dicta repellat.',NULL,2.79,130872.00,'84 × 41 × 38 cm','bathroom',NULL,0,'undecided',NULL,-159,'Sit sit ab.','/storage/items/73c4a5d3-f101-4c4d-915f-c8537a7c371d.png','/storage/items/thumbs/73c4a5d3-f101-4c4d-915f-c8537a7c371d.png','2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(68,2,NULL,'Aut qui doloremque debitis.',NULL,0.89,58824.00,'43 × 36 × 38 cm','bathroom','nihil',0,'undecided',NULL,-160,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(69,2,NULL,'Perferendis omnis.','Beatae maiores libero et velit labore sed ad.',0.76,26112.00,'68 × 32 × 12 cm','bedroom',NULL,1,'undecided',NULL,-214,NULL,'/storage/items/e768557f-de6b-490d-8533-58e3738b3c3d.png','/storage/items/thumbs/e768557f-de6b-490d-8533-58e3738b3c3d.png','2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(70,2,NULL,'Harum voluptatibus commodi.','Consequuntur voluptatem natus officia aperiam labore est magni autem blanditiis ex.',2.18,52800.00,'88 × 60 × 10 cm','living_room','inventore',0,'undecided',NULL,-161,'Tenetur dolorum qui sunt.','/storage/items/df6d67dd-89c5-4f22-a300-5e66b0d5ad85.png','/storage/items/thumbs/df6d67dd-89c5-4f22-a300-5e66b0d5ad85.png','2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(71,2,NULL,'Iste officia consequatur nihil ipsa.','Laudantium porro harum quasi dolore velit expedita nostrum veniam tempore omnis quos.',1.76,55440.00,'33 × 56 × 30 cm','other',NULL,0,'undecided',NULL,-162,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(72,2,NULL,'Esse cupiditate beatae.','Voluptatem consectetur eveniet qui commodi ipsa ratione dolorem doloribus ut ratione ad.',2.88,15750.00,'35 × 25 × 18 cm','storage','aut',0,'undecided',NULL,-229,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(73,2,NULL,'Ut repellat quo.',NULL,2.98,40320.00,'80 × 28 × 18 cm','bedroom',NULL,0,'undecided',NULL,-163,NULL,'/storage/items/63d35bad-bd5c-4522-9602-33f3b8355570.png','/storage/items/thumbs/63d35bad-bd5c-4522-9602-33f3b8355570.png','2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(74,2,NULL,'Autem provident harum non.',NULL,3.16,40392.00,'54 × 44 × 17 cm','living_room',NULL,0,'undecided',NULL,-164,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:33:24',NULL),
(75,2,NULL,'Ipsa illo numquam consequatur.',NULL,2.12,14400.00,'20 × 48 × 15 cm','office','officiis',0,'undecided',NULL,-215,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(76,2,NULL,'Inventore et perspiciatis.',NULL,0.44,27600.00,'30 × 46 × 20 cm','kitchen',NULL,0,'undecided',NULL,-216,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(77,2,NULL,'Dolor maxime.','Quia cumque ipsam aut velit blanditiis et consequatur consectetur.',1.54,51520.00,'40 × 56 × 23 cm','office',NULL,0,'undecided',NULL,-230,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(78,2,NULL,'Libero ut fugit.','Aut ut dicta optio est quia ipsum laudantium.',1.66,10582.00,'22 × 37 × 13 cm','other','reprehenderit',0,'undecided',NULL,-217,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(79,2,NULL,'Rerum culpa sunt ipsa.',NULL,0.99,29240.00,'43 × 20 × 34 cm','other','quisquam',0,'pending',NULL,-178,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:42:07',NULL),
(80,2,NULL,'Maxime omnis veniam quisquam.','Dolor quasi veritatis non perferendis sed recusandae nobis rerum error error voluptas quis.',0.99,29040.00,'22 × 55 × 24 cm','living_room',NULL,0,'pending',NULL,-179,NULL,'/storage/items/5789410e-a697-47cb-aa54-aa3ed5509943.png','/storage/items/thumbs/5789410e-a697-47cb-aa54-aa3ed5509943.png','2025-11-07 17:44:47','2025-11-07 21:42:05',NULL),
(81,2,NULL,'Autem ipsa deserunt sed.','Molestias neque et iste ea illo neque nisi quidem deserunt inventore.',2.16,93624.00,'83 × 47 × 24 cm','bedroom',NULL,1,'pending',NULL,-165,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:42:26',NULL),
(82,2,NULL,'Illum dolor laudantium ex.','Dolorem qui et eum alias est sit et deserunt deleniti minima rerum.',0.86,20868.00,'37 × 47 × 12 cm','other',NULL,0,'pending',NULL,-180,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:42:04',NULL),
(83,2,NULL,'Eveniet praesentium nulla asperiores.',NULL,1.82,89440.00,'86 × 40 × 26 cm','bedroom','quam',1,'undecided',NULL,-231,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(84,2,NULL,'Libero iusto expedita dolor.',NULL,2.88,100170.00,'70 × 53 × 27 cm','storage','ratione',1,'undecided',NULL,-218,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(85,2,NULL,'Modi corporis doloribus sint autem.','Omnis cumque illum et consectetur voluptas earum.',2.02,28512.00,'81 × 32 × 11 cm','bathroom','consequatur',0,'undecided',NULL,-232,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(86,2,NULL,'Rerum ipsam placeat incidunt.',NULL,2.73,18870.00,'37 × 30 × 17 cm','office',NULL,0,'undecided',NULL,-233,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:30:18',NULL),
(87,2,NULL,'Minus possimus dolorem cumque consectetur.','Voluptatum iste molestias itaque alias temporibus perspiciatis et aut qui sint nihil voluptatibus commodi.',2.05,31725.00,'47 × 27 × 25 cm','bedroom','aut',1,'undecided',NULL,-219,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(88,2,NULL,'Id sed unde.','Delectus cum error consequatur quae et excepturi nobis dolorum temporibus suscipit dolores.',0.88,78678.00,'54 × 47 × 31 cm','other',NULL,0,'undecided',NULL,-220,'Beatae aut enim perferendis ad.',NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(89,2,NULL,'Labore omnis incidunt nam.',NULL,1.98,48720.00,'42 × 58 × 20 cm','living_room',NULL,0,'yes',NULL,-234,'Molestiae expedita et molestiae.',NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:43:56',NULL),
(90,2,NULL,'Facilis aliquam tempora eligendi.','Amet quia doloremque velit quibusdam et quidem voluptas ut fugiat dolore libero et repellat.',0.90,21150.00,'47 × 15 × 30 cm','storage',NULL,1,'pending',NULL,-173,NULL,'/storage/items/15045b6a-d6ff-44e1-bdf4-148ca972d9f7.png','/storage/items/thumbs/15045b6a-d6ff-44e1-bdf4-148ca972d9f7.png','2025-11-07 17:44:47','2025-11-07 21:42:14',NULL),
(91,2,NULL,'Aut nobis quis.','Amet aliquid architecto voluptas molestias vel maxime voluptatem et perferendis eum aut.',1.76,47872.00,'44 × 32 × 34 cm','kitchen',NULL,1,'yes',NULL,-235,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:46:54',NULL),
(92,2,NULL,'Cupiditate placeat in.','Quisquam accusantium assumenda eaque maxime dolor quia vel sed temporibus dolor quia non.',1.15,15444.00,'39 × 18 × 22 cm','office','quis',0,'undecided',NULL,-221,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(93,2,NULL,'Non magni neque quisquam aut.',NULL,2.05,54756.00,'54 × 26 × 39 cm','living_room',NULL,1,'undecided',NULL,-222,NULL,'/storage/items/c6ca6143-de35-4f9e-b6a2-743dca6ee0a3.png','/storage/items/thumbs/c6ca6143-de35-4f9e-b6a2-743dca6ee0a3.png','2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(94,2,NULL,'Facilis quis laborum provident.','Incidunt eveniet id voluptatem dolorem veritatis sed eos.',3.39,46080.00,'40 × 48 × 24 cm','kitchen','itaque',0,'undecided',NULL,-223,NULL,'/storage/items/e750e5eb-3b92-4206-805e-5f5713c100f7.png','/storage/items/thumbs/e750e5eb-3b92-4206-805e-5f5713c100f7.png','2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(95,2,NULL,'Et et voluptas ipsa.','In aspernatur qui praesentium eum aliquid ipsum eos pariatur.',0.97,37555.00,'35 × 37 × 29 cm','kitchen',NULL,0,'pending',NULL,-169,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:42:19',NULL),
(96,2,NULL,'Dolorem necessitatibus aliquid qui.','Consequatur beatae dolor quia officiis quia facere est qui rem.',1.47,17136.00,'21 × 24 × 34 cm','other',NULL,0,'yes',NULL,-236,'In totam.',NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:46:42',NULL),
(97,2,3,'Cumque maiores quaerat atque.','Minus id molestiae debitis voluptatibus culpa enim optio occaecati qui distinctio soluta maxime non.',3.16,101640.00,'55 × 56 × 33 cm','storage',NULL,1,'yes','2025-11-07 22:48:40',-237,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:48:40',NULL),
(98,2,NULL,'Quos eligendi.','Voluptas quidem ex delectus tempore magni sed deserunt consequatur facilis non consequuntur vel aut.',3.04,17250.00,'30 × 25 × 23 cm','bedroom','in',0,'yes',NULL,-238,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:43:56',NULL),
(99,2,NULL,'Numquam esse mollitia.',NULL,1.90,123504.00,'83 × 48 × 31 cm','other',NULL,0,'undecided',NULL,-224,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(100,2,NULL,'Sunt nihil.','Ut ut officiis a maiores veniam fugiat.',0.63,40320.00,'36 × 40 × 28 cm','bathroom',NULL,0,'undecided',NULL,-225,NULL,'/storage/items/2594f780-e734-4ae7-941f-0657178cf2d8.png','/storage/items/thumbs/2594f780-e734-4ae7-941f-0657178cf2d8.png','2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(101,2,NULL,'Est asperiores est.','Incidunt labore ut nihil nihil non reprehenderit dolorem quisquam est aliquam.',1.64,43452.00,'71 × 17 × 36 cm','other',NULL,0,'pending',NULL,-213,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:41:34',NULL),
(102,2,NULL,'Dolorum qui esse.','Voluptas quaerat quia possimus asperiores minus dolorem sapiente asperiores reiciendis animi.',1.09,71299.00,'41 × 47 × 37 cm','kitchen',NULL,0,'undecided',NULL,-157,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 21:33:13',NULL),
(103,2,NULL,'Aut neque delectus.',NULL,0.86,8400.00,'20 × 21 × 20 cm','bathroom',NULL,0,'yes',NULL,-239,'Ut est numquam non.','/storage/items/56439c67-a4fc-4741-99f7-7c76fb0c935a.png','/storage/items/thumbs/56439c67-a4fc-4741-99f7-7c76fb0c935a.png','2025-11-07 17:44:47','2025-11-07 22:43:56',NULL),
(104,2,NULL,'Reiciendis hic eos.','Asperiores sunt et vitae illo ipsum suscipit ad veniam et sunt repellat repellendus.',0.60,13260.00,'26 × 34 × 15 cm','bedroom','sint',0,'undecided',NULL,-226,NULL,NULL,NULL,'2025-11-07 17:44:47','2025-11-07 22:00:39',NULL),
(105,2,NULL,'Cumque atque eveniet.',NULL,0.55,35000.00,'70 × 25 × 20 cm','office',NULL,0,'yes',NULL,-240,'Fuga quos.','/storage/items/41a5ff3c-f06e-4de2-81a0-53d471d4fd92.png','/storage/items/thumbs/41a5ff3c-f06e-4de2-81a0-53d471d4fd92.png','2025-11-07 17:44:47','2025-11-07 22:43:56',NULL),
(106,3,NULL,'Nostrum sed nihil quae.','Ullam aut aliquam eveniet quod qui atque eos voluptatum rem.',1.08,25168.00,'52 × 44 × 11 cm','other','est',0,'pending',NULL,251,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(107,3,NULL,'Quae et corporis.',NULL,0.43,28704.00,'48 × 26 × 23 cm','bedroom','ad',0,'pending',NULL,-66,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:33',NULL),
(108,3,NULL,'Amet ipsum enim.','Rerum unde voluptatem ratione id ut dicta.',1.44,112890.00,'71 × 53 × 30 cm','living_room',NULL,1,'pending',NULL,-11,'Quisquam molestiae iusto et.','/storage/items/49672366-c2a0-474c-b35c-2b679a121c77.png','/storage/items/thumbs/49672366-c2a0-474c-b35c-2b679a121c77.png','2025-11-07 22:52:15','2025-11-07 23:00:39',NULL),
(109,3,NULL,'Ut est quo.','Nihil hic nobis exercitationem dolor velit architecto qui.',2.56,61380.00,'36 × 55 × 31 cm','bathroom','tempora',0,'yes',NULL,-9,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:46',NULL),
(110,3,NULL,'Et id est provident.',NULL,2.99,43290.00,'65 × 18 × 37 cm','kitchen',NULL,0,'pending',NULL,558,'Doloribus sed aliquid optio.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(111,3,NULL,'Architecto rerum itaque rerum iste.','Excepturi sed impedit unde qui eius ut iste.',1.72,63756.00,'69 × 28 × 33 cm','bathroom','aliquid',0,'no',NULL,830,NULL,'/storage/items/a8dbd86a-5ddc-4ff6-bcd9-34332a5c43f9.png','/storage/items/thumbs/a8dbd86a-5ddc-4ff6-bcd9-34332a5c43f9.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(112,3,NULL,'Et quaerat non.',NULL,2.90,65975.00,'65 × 29 × 35 cm','bedroom','natus',0,'no','2025-11-06 14:37:01',670,'Delectus vitae voluptas.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(113,3,NULL,'Dolor ipsum laborum et.','Voluptatum tenetur nihil necessitatibus laudantium voluptate enim fuga sint ex pariatur eos velit.',2.12,104040.00,'68 × 51 × 30 cm','living_room',NULL,1,'no',NULL,719,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(114,3,5,'Ex corporis aliquam reiciendis.','Doloremque quia qui ab doloremque suscipit minus ea facere voluptas quaerat.',1.86,23001.00,'41 × 33 × 17 cm','bedroom',NULL,0,'no',NULL,802,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(115,3,NULL,'Laudantium delectus delectus.','Sed velit quisquam commodi nulla suscipit cupiditate doloribus quas tempore natus nihil amet.',0.93,76440.00,'78 × 28 × 35 cm','living_room','modi',1,'yes',NULL,-172,'Fuga iste id dolorum.','/storage/items/724450aa-f30e-41c4-b093-476609c65ada.png','/storage/items/thumbs/724450aa-f30e-41c4-b093-476609c65ada.png','2025-11-07 22:52:15','2025-11-07 23:00:25',NULL),
(116,3,NULL,'Quis qui iste cum.','Temporibus fugit maxime corporis voluptatem qui ut et.',3.26,129960.00,'57 × 57 × 40 cm','bathroom','est',1,'yes','2025-10-29 09:14:37',124,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:52',NULL),
(117,3,NULL,'Sunt voluptatem facere quam illum.','Molestiae cumque nam provident velit ducimus laborum possimus rem porro praesentium enim et.',0.40,52635.00,'55 × 33 × 29 cm','bathroom','ipsam',0,'no',NULL,-126,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:27',NULL),
(118,3,NULL,'Recusandae dolores ut enim.',NULL,2.98,73080.00,'70 × 29 × 36 cm','bathroom','quas',1,'yes',NULL,20,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:50',NULL),
(119,3,NULL,'Iusto perferendis fuga.','Non vitae cupiditate dignissimos velit est delectus culpa cumque corporis dolor magni non.',2.61,17316.00,'26 × 18 × 37 cm','kitchen',NULL,0,'no',NULL,613,NULL,'/storage/items/99aefe46-3ced-4137-a777-2606a55de1c4.png','/storage/items/thumbs/99aefe46-3ced-4137-a777-2606a55de1c4.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(120,3,NULL,'Possimus aspernatur recusandae.',NULL,1.38,56028.00,'69 × 58 × 14 cm','bathroom',NULL,0,'yes',NULL,-16,'Minima repudiandae repellendus.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:34',NULL),
(121,3,NULL,'Aut aut assumenda.',NULL,3.40,90880.00,'71 × 40 × 32 cm','office',NULL,0,'pending',NULL,263,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(122,3,NULL,'Nihil ab aut incidunt.','Nam magnam velit tempore animi doloremque est saepe.',1.28,26100.00,'58 × 18 × 25 cm','office','similique',0,'no',NULL,815,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(123,3,NULL,'Et eius dolorem consectetur.',NULL,1.74,29700.00,'27 × 44 × 25 cm','kitchen','expedita',0,'yes',NULL,-114,'Culpa explicabo occaecati.','/storage/items/3db8375c-3555-472e-a3a9-2565887182c5.png','/storage/items/thumbs/3db8375c-3555-472e-a3a9-2565887182c5.png','2025-11-07 22:52:15','2025-11-07 23:00:29',NULL),
(124,3,NULL,'Repellat expedita.',NULL,1.78,196560.00,'84 × 60 × 39 cm','storage',NULL,0,'yes','2025-11-05 02:03:06',170,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:56',NULL),
(125,3,NULL,'Eos et debitis.','Soluta quisquam ipsam sunt aliquid beatae consequatur delectus atque dolores.',1.12,12495.00,'35 × 17 × 21 cm','bathroom',NULL,0,'no',NULL,784,NULL,'/storage/items/9c471d6d-cb5a-45ae-9cde-c1447650f1db.png','/storage/items/thumbs/9c471d6d-cb5a-45ae-9cde-c1447650f1db.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(126,3,NULL,'Voluptatem sit cumque.','Iste animi laboriosam voluptatibus quis non id quod suscipit iste quis officiis quia nisi.',2.94,70528.00,'76 × 32 × 29 cm','living_room','quaerat',0,'pending',NULL,326,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(127,3,NULL,'Reiciendis fuga dicta molestiae.',NULL,0.87,32643.00,'31 × 39 × 27 cm','other','voluptatum',0,'pending',NULL,168,NULL,'/storage/items/394d9d41-b9dd-431c-84d5-d2901ae7a3af.png','/storage/items/thumbs/394d9d41-b9dd-431c-84d5-d2901ae7a3af.png','2025-11-07 22:52:15','2025-11-07 23:00:54',NULL),
(128,3,NULL,'Consectetur maiores est inventore.',NULL,2.36,128325.00,'75 × 59 × 29 cm','kitchen',NULL,0,'no',NULL,737,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(129,3,6,'Et commodi vitae molestiae.',NULL,2.61,121472.00,'73 × 52 × 32 cm','living_room','commodi',1,'no','2025-11-03 00:04:35',1085,'Vitae porro suscipit odit.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(130,3,NULL,'Necessitatibus officia cupiditate recusandae.',NULL,2.06,47652.00,'38 × 38 × 33 cm','kitchen',NULL,0,'no',NULL,826,'Ipsa dicta fuga quis.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(131,3,NULL,'Eligendi dolor recusandae.','Neque rerum molestias vel et qui sunt.',3.38,62866.00,'86 × 43 × 17 cm','living_room','nemo',1,'no',NULL,1103,'Optio exercitationem.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(132,3,6,'Quaerat aut deleniti architecto.','Eius aliquam ratione et ratione numquam porro cupiditate.',3.01,101308.00,'86 × 31 × 38 cm','storage','autem',0,'yes',NULL,841,NULL,'/storage/items/64503b67-d330-471e-851c-65e65d84864f.png','/storage/items/thumbs/64503b67-d330-471e-851c-65e65d84864f.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(133,3,NULL,'Molestiae ad dolores unde veritatis.','Sed harum laboriosam tenetur aut et quisquam deleniti totam autem pariatur maxime accusamus et.',1.16,29120.00,'35 × 52 × 16 cm','office','aspernatur',0,'pending',NULL,503,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(134,3,NULL,'Modi ducimus at omnis libero.',NULL,0.28,61344.00,'71 × 27 × 32 cm','office','est',0,'pending',NULL,191,'Consequatur omnis dolor eveniet odio.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:01:01',NULL),
(135,3,5,'Et beatae velit.','Quas et dolore id ex voluptatem ut.',1.82,57330.00,'78 × 21 × 35 cm','office','iure',0,'yes','2025-11-02 22:52:15',1155,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(136,3,5,'Atque at.','Est incidunt commodi vero quis vitae officiis qui magnam omnis eveniet exercitationem a delectus.',3.04,57017.00,'67 × 37 × 23 cm','bathroom',NULL,1,'no',NULL,710,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(137,3,NULL,'Expedita dolorem dolores sunt.',NULL,3.14,22950.00,'45 × 34 × 15 cm','bedroom','laudantium',1,'no',NULL,-9,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:47',NULL),
(138,3,5,'Ad sint.','Cupiditate maxime reprehenderit et tenetur voluptate sit ipsam praesentium sint modi pariatur quia.',2.46,36960.00,'22 × 60 × 28 cm','office','culpa',0,'yes','2025-11-04 09:53:42',1200,NULL,'/storage/items/0cfd6637-2572-47fb-832b-c912e2c50271.png','/storage/items/thumbs/0cfd6637-2572-47fb-832b-c912e2c50271.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(139,3,NULL,'Dolores quod iusto repellat.',NULL,2.22,58368.00,'38 × 48 × 32 cm','bedroom','quidem',0,'pending','2025-11-01 22:08:20',491,NULL,'/storage/items/ee3152e2-9fff-44f9-a0eb-b0aaa6c495a5.png','/storage/items/thumbs/ee3152e2-9fff-44f9-a0eb-b0aaa6c495a5.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(140,3,6,'Sequi repellat est eaque.','Sint cumque ullam omnis et omnis fugiat numquam nisi eos fuga suscipit id.',0.89,32844.00,'69 × 34 × 14 cm','kitchen',NULL,0,'yes','2025-11-05 22:52:15',816,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(141,3,NULL,'Excepturi et enim ab.','Similique voluptas quia explicabo eum ullam quia laborum iure.',2.02,22032.00,'36 × 18 × 34 cm','office','nemo',0,'no',NULL,-96,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:31',NULL),
(142,3,NULL,'Ullam laudantium magnam.','Ipsum laudantium in exercitationem voluptatem illum fugiat sed aperiam dolores ea autem praesentium voluptatem.',1.19,59976.00,'84 × 21 × 34 cm','bedroom',NULL,1,'pending',NULL,-10,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:43',NULL),
(143,3,NULL,'Officia fugit vero.','Nihil corporis itaque fuga deleniti voluptatibus dolorem excepturi alias.',3.46,49608.00,'24 × 53 × 39 cm','other','aut',0,'yes',NULL,-13,'Animi suscipit officiis.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:37',NULL),
(144,3,NULL,'Veritatis dolores fugit veniam veritatis.','Voluptas provident numquam molestias excepturi sequi temporibus qui soluta illo at exercitationem.',1.30,34017.00,'51 × 23 × 29 cm','kitchen','atque',1,'no',NULL,745,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(145,3,5,'Omnis asperiores quo.','Eligendi neque facere omnis sint autem consequatur et deleniti voluptatem et.',2.30,20400.00,'24 × 50 × 17 cm','bedroom','omnis',0,'yes','2025-11-03 22:52:15',879,NULL,NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(146,3,5,'Possimus in ut.',NULL,2.25,36040.00,'53 × 40 × 17 cm','bathroom','sit',1,'yes','2025-11-05 22:52:15',1077,'Sunt nihil atque eius nulla.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(147,3,NULL,'Vel laudantium.',NULL,2.80,10080.00,'48 × 21 × 10 cm','other',NULL,0,'no',NULL,913,NULL,'/storage/items/248da433-34ff-4b5a-a2d2-e9dd0ec8ff25.png','/storage/items/thumbs/248da433-34ff-4b5a-a2d2-e9dd0ec8ff25.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(148,3,NULL,'Nihil quo sed.','Aliquam iure autem sit laboriosam perferendis laboriosam sunt voluptas qui.',1.71,37004.00,'22 × 58 × 29 cm','bathroom','odit',1,'pending',NULL,591,NULL,'/storage/items/eddd39a5-5c8c-4655-835e-d565a65e5b56.png','/storage/items/thumbs/eddd39a5-5c8c-4655-835e-d565a65e5b56.png','2025-11-07 22:52:15','2025-11-07 22:52:15',NULL),
(149,3,NULL,'Pariatur eveniet repellat.','Repudiandae asperiores ducimus laboriosam debitis perferendis mollitia repellendus sit et sit laudantium autem dicta.',1.71,20800.00,'25 × 26 × 32 cm','bedroom',NULL,0,'pending',NULL,-124,'Quia est.',NULL,NULL,'2025-11-07 22:52:15','2025-11-07 23:00:28',NULL),
(150,3,NULL,'Nulla odio explicabo in.',NULL,1.63,25800.00,'24 × 43 × 25 cm','kitchen',NULL,1,'yes',NULL,187,'Voluptatem ab sit qui.','/storage/items/644e2c59-7ea6-42c9-b1a0-e59cf50a1a0f.png','/storage/items/thumbs/644e2c59-7ea6-42c9-b1a0-e59cf50a1a0f.png','2025-11-07 22:52:15','2025-11-07 23:00:58',NULL),
(151,3,NULL,'noiva',NULL,1.00,1000.00,NULL,'other','quarto',0,'yes',NULL,1210,NULL,'http://localhost:8080/storage/items/151/d2b9c85d-4768-418d-af2b-9e356301671e.jpeg','http://localhost:8080/storage/items/151/thumbs/d2b9c85d-4768-418d-af2b-9e356301671e.jpeg','2025-11-07 22:57:32','2025-11-07 23:07:59',NULL),
(152,3,NULL,'viva a vida',NULL,1.00,1000.00,NULL,'other','escritorio',1,'yes',NULL,1220,NULL,'http://localhost:8080/storage/items/152/d28d5eb1-337e-42dd-aeaa-cbdc1348ec18.png','http://localhost:8080/storage/items/152/thumbs/d28d5eb1-337e-42dd-aeaa-cbdc1348ec18.png','2025-11-07 23:00:09','2025-11-07 23:08:03',NULL),
(153,3,NULL,'another card',NULL,1.00,2000.00,NULL,'other','escritorio',0,'yes',NULL,1230,NULL,'http://localhost:8080/storage/items/153/ea7f77c3-60d4-4e27-86e7-05c15c3c9dd4.jpg','http://localhost:8080/storage/items/153/thumbs/ea7f77c3-60d4-4e27-86e7-05c15c3c9dd4.jpg','2025-11-07 23:09:12','2025-11-07 23:09:24',NULL),
(154,3,NULL,'3','Aqui tens mais uma peca de roupa',2.00,3000.00,NULL,'other','banheiro',1,'yes',NULL,1240,NULL,'http://localhost:8080/storage/items/154/6960e2bd-312d-4826-89cf-f049c5bb6b10.jpg','http://localhost:8080/storage/items/154/thumbs/6960e2bd-312d-4826-89cf-f049c5bb6b10.jpg','2025-11-07 23:15:49','2025-11-07 23:16:04',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(10,'2025_10_29_000001_drop_password_columns_from_users_table',1),
(11,'2025_10_29_000002_convert_pending_to_undecided_on_items',1),
(12,'2025_10_29_212557_add_yes_metrics_to_bag_snapshots',1),
(13,'2025_10_29_212705_add_yes_metrics_to_bag_snapshots',1),
(14,'2025_10_29_214822_add_reserved_volume_to_moves_table',1),
(15,'2025_10_30_000100_add_dimensions_to_bags_table',1),
(16,'2025_10_30_010000_add_volume_cm3_to_items_table',1),
(17,'2025_11_02_000000_add_onboarding_flags_to_users_table',1),
(18,'2025_11_05_000000_add_role_and_credentials_to_users_table',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moves`
--

LOCK TABLES `moves` WRITE;
/*!40000 ALTER TABLE `moves` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `moves` VALUES
(1,1,'GB','BR',4.00,60000.00,'{\"deck_hints\": true}','2025-11-07 17:17:06','2025-11-07 17:17:06',NULL),
(2,2,'GB','BR',4.00,60000.00,NULL,'2025-11-07 17:44:47','2025-11-07 17:44:47',NULL),
(3,3,'GB','BR',4.00,60000.00,NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',NULL);
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
('2zcV4psVMrONkmPRxhAqCXZXvwhURUJYDw4yxTWE',3,'172.24.0.1','Mozilla/5.0 (X11; Linux x86_64; rv:144.0) Gecko/20100101 Firefox/144.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZkg5S25naVdjUzMwQXlwSThXdVBtSmVvT0xwMHdURFRra3FxODRzZCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Mzt9',1762558237),
('MoazqblLB3op39lQ7U0eSMLBjPD8Zi4EO6DfO5UM',3,'172.24.0.1','Mozilla/5.0 (X11; Linux x86_64; rv:144.0) Gecko/20100101 Firefox/144.0','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiVjAyZWxBOTJDSUsza0h5RWVQc1lwcTJsOUNHUnZyWWRaOVVza2p4MyI7czozOiJ1cmwiO2E6MDp7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjM7fQ==',1762586922);
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
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `onboarding_history_seen` tinyint(1) NOT NULL DEFAULT '0',
  `onboarding_tour_seen` tinyint(1) NOT NULL DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'Demo Admin','demo@example.com','admin','$2y$12$401WtDuq/QIdSJPF1pnNg.mwSJspNUvyYbIW5gNqAehzX49BArLUG',NULL,'2025-11-07 17:17:06','2025-11-07 17:17:06',0,0,NULL),
(2,'solange','test@test.com','user','$2y$12$2G1rBG8Bknn0ZnovfHq8v.y9GFb842iLayjrPGLHKrsgG.moI4Api',NULL,'2025-11-07 17:44:47','2025-11-07 18:08:55',1,1,NULL),
(3,'helio','admin@test.com','admin','$2y$12$ESxSWQzC3G0xEc2XfdfIn.t46.S.YgFW1vgbhkt6YTHqCnleH2EEO',NULL,'2025-11-07 22:52:15','2025-11-07 22:52:15',0,0,NULL);
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

-- Dump completed on 2025-11-08  7:35:33
