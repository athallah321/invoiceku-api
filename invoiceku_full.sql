-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: invoiceku
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clients_user_id_foreign` (`user_id`),
  CONSTRAINT `clients_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (14,3,'deden','deden@gmail.com','083140147170','jl pangeran mentri','pt deden','2026-05-27 05:54:34','2026-05-27 05:54:34');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
INSERT INTO `invoice_items` VALUES (26,19,'1 kamar hotel',1,750000.00,750000.00,'2026-05-27 05:55:34','2026-05-27 05:55:34'),(27,20,'Travel',1,500000.00,500000.00,'2026-05-27 06:25:20','2026-05-27 06:25:20'),(28,21,'Cat',1,200000.00,200000.00,'2026-06-04 06:55:03','2026-06-04 06:55:03'),(30,23,'Kipas',1,300000.00,300000.00,'2026-06-04 07:07:47','2026-06-04 07:07:47'),(31,24,'Stik',1,65000.00,65000.00,'2026-06-04 08:50:13','2026-06-04 08:50:13'),(33,25,'Laptop',1,15000000.00,15000000.00,'2026-06-05 21:38:30','2026-06-05 21:38:30'),(34,26,'asdasd',1,454545.00,454545.00,'2026-06-05 22:01:43','2026-06-05 22:01:43'),(35,27,'computer',1,1200000.00,1200000.00,'2026-06-05 22:25:10','2026-06-05 22:25:10');
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `client_id` bigint unsigned NOT NULL,
  `invoice_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('draft','sent','paid','overdue') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tax` decimal(12,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoice_number_unique` (`invoice_number`),
  KEY `invoices_user_id_foreign` (`user_id`),
  KEY `invoices_client_id_foreign` (`client_id`),
  CONSTRAINT `invoices_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoices_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (19,3,14,'INV0001','overdue','2026-05-04','2026-05-15',750000.00,0.00,0.00,750000.00,NULL,'2026-05-27 05:55:09','2026-05-27 06:13:02'),(20,3,14,'INV0002','paid','2026-05-01','2026-05-26',500000.00,0.00,0.00,500000.00,NULL,'2026-05-27 06:25:20','2026-06-02 04:05:25'),(21,3,14,'INV0003','sent','2026-06-05','2026-06-08',200000.00,0.00,0.00,200000.00,NULL,'2026-06-04 06:55:03','2026-06-04 06:55:20'),(23,3,14,'INV0004','draft','2026-06-05','2026-06-07',300000.00,0.00,0.00,300000.00,NULL,'2026-06-04 07:07:47','2026-06-04 07:07:47'),(24,3,14,'INV0005','draft','2026-06-05','2026-06-07',65000.00,0.00,0.00,65000.00,NULL,'2026-06-04 08:50:13','2026-06-04 08:50:13'),(25,3,14,'INV0006','draft','2026-06-05','2026-06-08',15000000.00,20000.00,0.00,15020000.00,NULL,'2026-06-05 01:57:26','2026-06-05 21:38:30'),(26,3,14,'INV0007','draft','2026-06-06','2026-06-30',454545.00,0.00,0.00,454545.00,NULL,'2026-06-05 22:01:43','2026-06-05 22:01:43'),(27,3,14,'INV0008','draft','2026-06-06','2026-06-30',1200000.00,132000.00,0.00,1332000.00,NULL,'2026-06-05 22:25:10','2026-06-05 22:25:10');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_000000_create_users_table',1),(2,'2014_10_12_100000_create_password_reset_tokens_table',1),(3,'2019_08_19_000000_create_failed_jobs_table',1),(4,'2019_12_14_000001_create_personal_access_tokens_table',1),(5,'2026_05_20_113540_create_clients_table',1),(6,'2026_05_20_113550_create_invoices_table',1),(7,'2026_05_20_113557_create_invoice_items_table',1),(8,'2026_05_23_000000_create_settings_table',2),(9,'2026_05_27_add_role_to_users_table',3),(10,'2026_05_30_131303_add_google_id_to_users_table',4);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (1,'App\\Models\\User',1,'auth_token','50997d517c0f0dc2835eacd3900021735384c4418166d4c260def47cdb613647','[\"*\"]',NULL,NULL,'2026-05-20 03:53:47','2026-05-20 03:53:47'),(2,'App\\Models\\User',1,'auth_token','343a0b09bfb1a714c4b3c37857b888fc6a2f5338adf135d9e25e52c28379591d','[\"*\"]',NULL,NULL,'2026-05-20 03:55:48','2026-05-20 03:55:48'),(3,'App\\Models\\User',1,'auth_token','d70d943e3c7d32e2ae90447e3cac3b00b41370f65ae844ab8e7b54138100e571','[\"*\"]',NULL,NULL,'2026-05-22 02:19:42','2026-05-22 02:19:42'),(4,'App\\Models\\User',1,'auth_token','2c816ff8b5b3b00657bee8082f1bf4e844521dd228dd51e161d04169226d504d','[\"*\"]','2026-05-27 04:05:00',NULL,'2026-05-22 02:39:05','2026-05-27 04:05:00'),(5,'App\\Models\\User',1,'auth_token','7ffab7dbb3444186282980152d6dffb119ca89ae498afa6e473a3685762b8bec','[\"*\"]',NULL,NULL,'2026-05-22 02:49:40','2026-05-22 02:49:40'),(6,'App\\Models\\User',1,'auth_token','2dbac91db71415fb5f6e123449b9ba00457b83e8135f797970d38842e93c3581','[\"*\"]',NULL,NULL,'2026-05-22 04:34:32','2026-05-22 04:34:32'),(7,'App\\Models\\User',2,'auth_token','77b215a675d9424d7f1f245838a7420c3f5e208f1a217ed6015a8348adf95a89','[\"*\"]','2026-05-22 10:22:52',NULL,'2026-05-22 04:37:32','2026-05-22 10:22:52'),(8,'App\\Models\\User',1,'auth_token','13bc66862a60088117be6c0699ada39b26cb4028e6d204429804fa6438c7ff48','[\"*\"]',NULL,NULL,'2026-05-22 10:23:05','2026-05-22 10:23:05'),(9,'App\\Models\\User',1,'auth_token','d61a1d9cdad3be0dee22052ade3abed515808f3c611265489d6bd9fa99f52abb','[\"*\"]',NULL,NULL,'2026-05-22 10:41:08','2026-05-22 10:41:08'),(10,'App\\Models\\User',1,'auth_token','024ecc692cd118d0094e2c1e8d0bbe74e9778c1751db50058a884df57ffb3047','[\"*\"]',NULL,NULL,'2026-05-22 22:55:10','2026-05-22 22:55:10'),(11,'App\\Models\\User',1,'auth_token','d93155d2269ed0e0061d1e89d76e026623a0afc73a02844390e18d36120f4883','[\"*\"]',NULL,NULL,'2026-05-22 23:01:02','2026-05-22 23:01:02'),(12,'App\\Models\\User',1,'auth_token','35c32697d00d065618ccdde1ec1dfae0162971e1d223f13b88d816efb05dd20f','[\"*\"]',NULL,NULL,'2026-05-22 23:57:50','2026-05-22 23:57:50'),(13,'App\\Models\\User',1,'auth_token','ccfea3c247bd52007d1de935ce5baa9aa0139e7ae2cac95bca50d1f7001dd392','[\"*\"]','2026-05-23 08:54:00',NULL,'2026-05-23 00:09:33','2026-05-23 08:54:00'),(14,'App\\Models\\User',1,'auth_token','913663a39b9e286abdf0120d5543dd4b738bba7158b6442603296dac3191ec9f','[\"*\"]',NULL,NULL,'2026-05-24 04:00:01','2026-05-24 04:00:01'),(15,'App\\Models\\User',1,'auth_token','7d0e99f7bced2f421adab068ecb6a2983b2984713d746a67c9d3d4b9c8860d03','[\"*\"]',NULL,NULL,'2026-05-24 08:05:14','2026-05-24 08:05:14'),(16,'App\\Models\\User',1,'auth_token','8bc758b69087db1cc2c24ddd97290203939c4847d6c868948c9cf41eb32223c8','[\"*\"]',NULL,NULL,'2026-05-24 08:12:13','2026-05-24 08:12:13'),(17,'App\\Models\\User',1,'auth_token','666c5bf849ef833f7cf59ae844399a6c85c7762068da28b7cff21912201f9a0f','[\"*\"]','2026-05-27 02:09:15',NULL,'2026-05-26 18:45:18','2026-05-27 02:09:15'),(18,'App\\Models\\User',1,'auth_token','082eee0835677f346fde56dbfae5b6f64e3e5af9cf3baca933eec3cd79d6471f','[\"*\"]',NULL,NULL,'2026-05-27 02:17:42','2026-05-27 02:17:42'),(19,'App\\Models\\User',1,'auth_token','b4511e1e8b5451bfee826f807106d6eafde7db5fe1b795cfd574a55fdb9b88ee','[\"*\"]',NULL,NULL,'2026-05-27 02:18:20','2026-05-27 02:18:20'),(20,'App\\Models\\User',1,'auth_token','3b3a6c3af2e984aeea89588ddcbecd6324ff210a5e92f6d712a94a3755da658d','[\"*\"]',NULL,NULL,'2026-05-27 04:12:05','2026-05-27 04:12:05'),(21,'App\\Models\\User',1,'auth_token','040ffa9e1de939c838c47be3051d773f277c1ac1a270f015a8559434c6d0737d','[\"*\"]',NULL,NULL,'2026-05-27 04:12:57','2026-05-27 04:12:57'),(22,'App\\Models\\User',1,'auth_token','5742258733f62fd47ad18faf3d068394c2d4eca8101b224eab4b087a2830c408','[\"*\"]',NULL,NULL,'2026-05-27 04:27:45','2026-05-27 04:27:45'),(23,'App\\Models\\User',3,'auth_token','5dda7f9b2c3ed44806b059bbfe18a0f121aa664dd9066b32a5be9455eaa98322','[\"*\"]',NULL,NULL,'2026-05-27 04:33:14','2026-05-27 04:33:14'),(24,'App\\Models\\User',3,'auth_token','b35629b142ad2b5ede98cc20068ae083c1ff534491ca20e9d9d8e4351cd41476','[\"*\"]','2026-05-27 10:13:38',NULL,'2026-05-27 05:20:09','2026-05-27 10:13:38'),(25,'App\\Models\\User',1,'auth_token','a179f576aa4c8f7b5c0e032246e38419602175b406ce127b3ce8a2ff80bc8acb','[\"*\"]',NULL,NULL,'2026-05-27 10:13:55','2026-05-27 10:13:55'),(26,'App\\Models\\User',1,'auth_token','3abb63748fdcf8bfed6b0512bdbe8083ac693b2e8e748198dd12885dcc09f2f0','[\"*\"]','2026-05-30 02:42:02',NULL,'2026-05-27 10:35:40','2026-05-30 02:42:02'),(27,'App\\Models\\User',1,'auth_token','974d411f63b4d55c316640b15cdd6bf04990fa7b497289c35ff8ccd120a9add6','[\"*\"]',NULL,NULL,'2026-05-30 02:42:59','2026-05-30 02:42:59'),(28,'App\\Models\\User',1,'auth_token','4ccc90495130f11114f4e2114e1dfb045d747530c8551a481a58aede7e1591ca','[\"*\"]',NULL,NULL,'2026-05-30 02:56:13','2026-05-30 02:56:13'),(29,'App\\Models\\User',3,'auth_token','9903edbf347766f3cc421b158aeafe9b5f7cb56db072a933eb953610eb98216c','[\"*\"]',NULL,NULL,'2026-05-30 02:56:55','2026-05-30 02:56:55'),(30,'App\\Models\\User',1,'auth_token','bfe0bb5e51d53911e7f0b938acfb6ff2f8b2f162528713df59ab7488e20bce59','[\"*\"]',NULL,NULL,'2026-05-30 02:57:19','2026-05-30 02:57:19'),(31,'App\\Models\\User',1,'auth_token','725681c37967d587fa0995a983249691e7cee53249e31e2ebf65eef8a60fd707','[\"*\"]',NULL,NULL,'2026-05-30 03:11:22','2026-05-30 03:11:22'),(32,'App\\Models\\User',3,'auth_token','8ee56308fdfdd22a87e0e922ffd12ef4bcc1228be6d6ef19119177777697497a','[\"*\"]',NULL,NULL,'2026-05-30 03:20:29','2026-05-30 03:20:29'),(33,'App\\Models\\User',1,'auth_token','2a0d0bfbf6b8a89e719d27eb523d67f57a630a5e34fecf90d5e7cb0ef44d8897','[\"*\"]',NULL,NULL,'2026-05-30 03:28:17','2026-05-30 03:28:17'),(34,'App\\Models\\User',3,'google-auth','87b8d1d09b920f9cc67fc4f0147578e21867d58ab8556c2d55dc8b2e7d399396','[\"*\"]',NULL,NULL,'2026-05-30 19:54:42','2026-05-30 19:54:42'),(35,'App\\Models\\User',3,'google-auth','10dfd1b80c308ce3ab6e3b7d3baf67cf5c1241a028436cfc49c569065962fbef','[\"*\"]','2026-05-30 20:01:57',NULL,'2026-05-30 19:58:15','2026-05-30 20:01:57'),(36,'App\\Models\\User',1,'auth_token','2bed3c32ac82097f322fa00cc2159a919a6c66a3b2a04d39bb975dafbeabc835','[\"*\"]',NULL,NULL,'2026-05-30 20:02:12','2026-05-30 20:02:12'),(37,'App\\Models\\User',1,'auth_token','5246e42b58700ff330dd0ad611d59c2306d17c21816b77b92621a5662bc4e670','[\"*\"]',NULL,NULL,'2026-05-30 20:18:15','2026-05-30 20:18:15'),(38,'App\\Models\\User',4,'auth_token','dda82f35ec68857f3da973b3e5defbc0caae8ef132c58b1e70766474660a17ad','[\"*\"]',NULL,NULL,'2026-05-30 20:18:49','2026-05-30 20:18:49'),(39,'App\\Models\\User',1,'auth_token','b3697186c8cc3457fd890bd608c0faf0be9a983941e58f3a2f8202f2547f4636','[\"*\"]',NULL,NULL,'2026-05-30 20:19:44','2026-05-30 20:19:44'),(40,'App\\Models\\User',2,'google-auth','d37ea00f6b92f0631ae72dbf406d21606c8ff2355b4532f520f31779e2bc33b1','[\"*\"]',NULL,NULL,'2026-05-30 20:25:07','2026-05-30 20:25:07'),(41,'App\\Models\\User',2,'google-auth','41fb8ede17297b639e0910cdaa76406531e965cccaf771c841601f984e114a0b','[\"*\"]',NULL,NULL,'2026-05-30 20:25:21','2026-05-30 20:25:21'),(42,'App\\Models\\User',3,'google-auth','999b2b3201e2937dc211046feb6a794e55bc4cd9ad6f484994da4df780cdefd1','[\"*\"]',NULL,NULL,'2026-05-30 20:25:38','2026-05-30 20:25:38'),(43,'App\\Models\\User',2,'google-auth','f549f391de24a87a2ea9a32f4280988998721c5e6d3d2bdeaee680407dd9e81a','[\"*\"]',NULL,NULL,'2026-05-30 20:25:54','2026-05-30 20:25:54'),(44,'App\\Models\\User',2,'google-auth','5490c92422b7e3dfc4717c9056d28e9dd0138d0926ece584fd781f9b2e1ba6e4','[\"*\"]',NULL,NULL,'2026-05-30 20:28:06','2026-05-30 20:28:06'),(45,'App\\Models\\User',3,'google-auth','3095890717dbfb5753581654bebbf333fde733250d2e1d646331836bd125e5be','[\"*\"]','2026-05-30 20:28:48',NULL,'2026-05-30 20:28:15','2026-05-30 20:28:48'),(46,'App\\Models\\User',3,'google-auth','e5fe288928488408bbdcde6c5ec06f68a6f39234d6972cc4b195edd13d4b06fd','[\"*\"]','2026-05-30 20:29:04',NULL,'2026-05-30 20:29:01','2026-05-30 20:29:04'),(47,'App\\Models\\User',2,'google-auth','a455297f128491d4f04d04da01a4a8aeeb3949bc0276d776c2184ecfaba7b7ed','[\"*\"]','2026-05-30 20:29:17',NULL,'2026-05-30 20:29:15','2026-05-30 20:29:17'),(48,'App\\Models\\User',3,'google-auth','ea57299efd45e0366ac85387d23c2728e07cff97807ce3b87f76703d80e93d7a','[\"*\"]','2026-05-30 20:29:28',NULL,'2026-05-30 20:29:25','2026-05-30 20:29:28'),(49,'App\\Models\\User',2,'google-auth','15da0aacdae2db0b62a3192179e31c6e8c9cfe4dfe4e9e0ff186c17a3e0505e6','[\"*\"]','2026-05-30 20:42:55',NULL,'2026-05-30 20:42:52','2026-05-30 20:42:55'),(50,'App\\Models\\User',2,'google-auth','d5c6118c618a6c260877da7a02fb37816db83a57ae910f01f9cfa3d0c0381255','[\"*\"]','2026-05-30 20:46:06',NULL,'2026-05-30 20:43:50','2026-05-30 20:46:06'),(51,'App\\Models\\User',5,'auth_token','23f195f779d8f59231ae4f7fa83a83cd23716fa4110174bb42795208ac483366','[\"*\"]','2026-05-30 21:03:18',NULL,'2026-05-30 21:03:16','2026-05-30 21:03:18'),(52,'App\\Models\\User',5,'auth_token','769bf20240c12ecdf51c073ad8ee2650b7e9f2f4c23310ec9ee8330dafa43446','[\"*\"]',NULL,NULL,'2026-05-30 21:03:28','2026-05-30 21:03:28'),(53,'App\\Models\\User',5,'auth_token','d2c07e1649b6bf34b96d6612945f45f9d842f5ef034576e123b93a577ca83875','[\"*\"]',NULL,NULL,'2026-05-30 21:06:20','2026-05-30 21:06:20'),(54,'App\\Models\\User',2,'google-auth','4eaba90c5d70ba3e616a4a9d24552eaadecd9bb39007fa880deb7ea549764ca4','[\"*\"]',NULL,NULL,'2026-05-30 21:20:28','2026-05-30 21:20:28'),(55,'App\\Models\\User',2,'google-auth','9394e82441e3f9efe17cf251ff219f51614916b83915d4f00a59646398330143','[\"*\"]',NULL,NULL,'2026-05-30 21:26:18','2026-05-30 21:26:18'),(56,'App\\Models\\User',2,'google-auth','644ff32866ec94f6f9d8e4919c7349c6cce02e2eb2bd5fb97506216d8fe05d91','[\"*\"]',NULL,NULL,'2026-05-31 01:19:14','2026-05-31 01:19:14'),(57,'App\\Models\\User',3,'google-auth','f1ac9f73f3081b656e7d50e2963c5cadf043fc203304753dd2c32429bda3346d','[\"*\"]',NULL,NULL,'2026-05-31 01:20:04','2026-05-31 01:20:04'),(58,'App\\Models\\User',3,'google-auth','5fb8aec5d7b0744b7acd5572568db3f74c587e47dfe7399144bd39fae0e50503','[\"*\"]',NULL,NULL,'2026-05-31 01:27:40','2026-05-31 01:27:40'),(59,'App\\Models\\User',2,'google-auth','d77d8442dee5c09ba057a5804b26c492afef57ac217f2848c284c88d9bca0f07','[\"*\"]',NULL,NULL,'2026-05-31 01:28:09','2026-05-31 01:28:09'),(60,'App\\Models\\User',2,'google-auth','129891e11b53dc1ccaae286140ea5d81ea0274de2bbd316fd44230486b263fc1','[\"*\"]',NULL,NULL,'2026-05-31 01:37:44','2026-05-31 01:37:44'),(61,'App\\Models\\User',3,'google-auth','0682510005c6ab7861251320cdbf375c88e1a6f8b4826bcd9bd16a453e7f98d1','[\"*\"]',NULL,NULL,'2026-05-31 01:38:36','2026-05-31 01:38:36'),(62,'App\\Models\\User',2,'google-auth','4168ec2125dacb569480220e27b0805caae1d5432385dfc1e25c84231a5dd1f4','[\"*\"]',NULL,NULL,'2026-05-31 01:38:58','2026-05-31 01:38:58'),(63,'App\\Models\\User',2,'google-auth','63282d0c91caeca385854f1be9d1a1685e6eea73a8e6ed6c8ba1010be154bd43','[\"*\"]',NULL,NULL,'2026-05-31 01:40:36','2026-05-31 01:40:36'),(64,'App\\Models\\User',2,'google-auth','21b7e942c45c26f76c0860fa7c0a5522f56e99c8584c55e257b6d0e6d17eba09','[\"*\"]',NULL,NULL,'2026-05-31 01:47:26','2026-05-31 01:47:26'),(65,'App\\Models\\User',5,'auth_token','b771cc75cccb5798faa5cb52167ea1adb6781e062208021223cb97de65d9767e','[\"*\"]',NULL,NULL,'2026-05-31 01:56:33','2026-05-31 01:56:33'),(66,'App\\Models\\User',2,'google-auth','07a486cfd0f983b98404f498b5becfa20558e2b6e9c28fdc141fc68fad691636','[\"*\"]',NULL,NULL,'2026-05-31 01:57:06','2026-05-31 01:57:06'),(67,'App\\Models\\User',7,'google-auth','904bf2f2d55dc05d7173066f5231a9d6f97f616c46af4849522a7340e2922640','[\"*\"]','2026-05-31 01:59:20',NULL,'2026-05-31 01:58:49','2026-05-31 01:59:20'),(68,'App\\Models\\User',2,'google-auth','2f8f7f030774d282fd1d8f7c386e9300fc4666d695fedffa1144cf3d1aca14a4','[\"*\"]','2026-05-31 01:59:36',NULL,'2026-05-31 01:59:34','2026-05-31 01:59:36'),(69,'App\\Models\\User',2,'google-auth','7f5ec1ae2aedd526c5d7c6a266b9fc30ff43748ef6f5b0be1ace9cd268f1fc4d','[\"*\"]','2026-05-31 06:12:07',NULL,'2026-05-31 02:38:06','2026-05-31 06:12:07'),(70,'App\\Models\\User',3,'google-auth','5523736a02881e40f14837caa4a256ba8ad18b546c35bd9adc64c61bd7fc856f','[\"*\"]','2026-06-02 02:45:39',NULL,'2026-05-31 06:12:28','2026-06-02 02:45:39'),(71,'App\\Models\\User',3,'google-auth','a34c18e8b21974158e3801795d45c80131f769de7f7ddd6b92a06e7f9cacfd22','[\"*\"]','2026-06-02 05:04:06',NULL,'2026-06-02 02:46:12','2026-06-02 05:04:06'),(72,'App\\Models\\User',3,'google-auth','9bb85a98b93148cc597108fcb5f9ef8887ec019717af2aa55bfe5b5bbad180d3','[\"*\"]','2026-06-05 20:57:53',NULL,'2026-06-04 06:31:50','2026-06-05 20:57:53'),(73,'App\\Models\\User',2,'google-auth','7191e3e6e30fddf657e916123062af5b3a024d5bd135a58e7d5a7adc7905e5e2','[\"*\"]','2026-06-05 20:59:34',NULL,'2026-06-05 20:58:06','2026-06-05 20:59:34'),(74,'App\\Models\\User',3,'google-auth','f6786770d39dc3966fec008c9820083f4f7114842f5cbbf05337328d18280548','[\"*\"]','2026-06-06 07:43:34',NULL,'2026-06-05 20:59:42','2026-06-06 07:43:34'),(75,'App\\Models\\User',3,'google-auth','bd256917449cdd49773a9b443b016df235b0c9dce901032f16f9c30a65714f76','[\"*\"]','2026-06-06 07:49:12',NULL,'2026-06-06 07:44:33','2026-06-06 07:49:12'),(76,'App\\Models\\User',3,'google-auth','f09c966567baea8904ba14e8a03ebff07723bf57e08094e867a4adb93d132765','[\"*\"]','2026-06-06 09:16:09',NULL,'2026-06-06 08:47:16','2026-06-06 09:16:09'),(77,'App\\Models\\User',3,'google-auth','a26a7b87125997092ecefe395584a64e6da4d255f8b10e84629e8c0017401501','[\"*\"]',NULL,NULL,'2026-06-06 11:22:19','2026-06-06 11:22:19'),(78,'App\\Models\\User',2,'google-auth','a55b064accb763a272cdb7338579060b8e516fec9835b28521e22f9c8974a280','[\"*\"]',NULL,NULL,'2026-06-06 11:22:59','2026-06-06 11:22:59'),(79,'App\\Models\\User',3,'google-auth','6042e10b2a4c9b7b7bc0716b7a07298ff50c2877c1acd2e0f7ace6c805406ad3','[\"*\"]',NULL,NULL,'2026-06-06 11:34:58','2026-06-06 11:34:58'),(80,'App\\Models\\User',3,'google-auth','a1659be3ae7b7deaad22380df6e23b3986f696696b47c97fe80592dd01b5344b','[\"*\"]',NULL,NULL,'2026-06-06 11:39:03','2026-06-06 11:39:03'),(81,'App\\Models\\User',3,'google-auth','72edb3f7cc99c40ec0edfd69598d0a06cda33a38f79c6f0c2d279664ada76913','[\"*\"]',NULL,NULL,'2026-06-06 11:42:50','2026-06-06 11:42:50'),(82,'App\\Models\\User',3,'google-auth','6929a7604ff1efe02ba3e1c8229bd0c47ded2d1a751e4b1107232d6f479a6af9','[\"*\"]',NULL,NULL,'2026-06-06 11:44:22','2026-06-06 11:44:22'),(83,'App\\Models\\User',2,'google-auth','2518fc3aedfec71adaa251697b73f8cc5f2a5b4cdc5ed8479776f4a6c8ba01e1','[\"*\"]',NULL,NULL,'2026-06-06 11:45:09','2026-06-06 11:45:09'),(84,'App\\Models\\User',2,'google-auth','69f0c36cf0ddad9f914eef84d101eadf494d935c00f2cfe7cf91aa46b2185ee9','[\"*\"]',NULL,NULL,'2026-06-06 11:45:56','2026-06-06 11:45:56'),(85,'App\\Models\\User',3,'google-auth','d7e73766359785231d6a74c7423d4842425a0cd78d1b7cde2f30acda3ab995b5','[\"*\"]',NULL,NULL,'2026-06-06 11:47:40','2026-06-06 11:47:40'),(86,'App\\Models\\User',3,'google-auth','be8797d21afe554cf7019bf8ddc519b0055b84c1420772715040fc2eb974dde6','[\"*\"]',NULL,NULL,'2026-06-06 11:48:18','2026-06-06 11:48:18'),(87,'App\\Models\\User',2,'google-auth','3c539541b5c8adf55c09ea076d4f6479f01d6a0c37bf39d9fcd8b95c8965e843','[\"*\"]',NULL,NULL,'2026-06-06 11:48:32','2026-06-06 11:48:32'),(88,'App\\Models\\User',3,'google-auth','7624286fb3a56e921b54da56f40723edd5d70e537adfe8acaa1b103950f66a9b','[\"*\"]',NULL,NULL,'2026-06-06 11:49:24','2026-06-06 11:49:24'),(89,'App\\Models\\User',3,'google-auth','cfe9d89b494cb30ef5e24b9c9c3f73036badc4b0dd450d0421035bafbcc66f80','[\"*\"]',NULL,NULL,'2026-06-06 11:52:45','2026-06-06 11:52:45'),(90,'App\\Models\\User',3,'google-auth','dd71ea7c8280c71a746189accd8eefd591e058b2b6b8ad47b7ec0b11181210eb','[\"*\"]',NULL,NULL,'2026-06-06 11:55:35','2026-06-06 11:55:35'),(91,'App\\Models\\User',3,'google-auth','5930e10aaf0b2170d527af76fadf08dd5401a7920c1c73c09fd6e647ebec9ae0','[\"*\"]',NULL,NULL,'2026-06-06 11:57:35','2026-06-06 11:57:35'),(92,'App\\Models\\User',3,'google-auth','39b85d292a245194fc42b76eb632ab842bda87c6f0fdddc15c9e1ee59a276560','[\"*\"]',NULL,NULL,'2026-06-06 11:59:11','2026-06-06 11:59:11'),(93,'App\\Models\\User',3,'google-auth','22d4be096c289bf7ac2da0c890caf290b41b631d235d62261189d6d044075677','[\"*\"]',NULL,NULL,'2026-06-06 19:55:45','2026-06-06 19:55:45'),(94,'App\\Models\\User',2,'google-auth','4d084abad6d57c4cc4578565e74524c3e920249322c19e098195e176dc2361b4','[\"*\"]',NULL,NULL,'2026-06-06 19:56:08','2026-06-06 19:56:08'),(95,'App\\Models\\User',3,'google-auth','2d1f4ab587565030326cb0ab0e76996eaf7331676c829581380213cb7a18d037','[\"*\"]',NULL,NULL,'2026-06-06 19:57:31','2026-06-06 19:57:31'),(96,'App\\Models\\User',2,'google-auth','fe62cbfa1d7576bd9098d16e09174a44a325deacc62cc360ca1fdf0c831965ed','[\"*\"]',NULL,NULL,'2026-06-06 19:57:44','2026-06-06 19:57:44'),(97,'App\\Models\\User',3,'google-auth','86c22beb92670f4448c81b5e2d8380fd813a4e4ae9fa0ab38a08ae02aa9030af','[\"*\"]',NULL,NULL,'2026-06-06 20:14:16','2026-06-06 20:14:16'),(98,'App\\Models\\User',2,'google-auth','5390d9d4e37551150a648ff5b184031b191bf151462b6fcdd8e7a74cb72dae13','[\"*\"]',NULL,NULL,'2026-06-06 20:14:56','2026-06-06 20:14:56'),(99,'App\\Models\\User',3,'google-auth','bac1fdc3d78202cb49c62f5847ba42b6df09d0c87d146b2ea7d8efa7445c3860','[\"*\"]',NULL,NULL,'2026-06-06 20:18:13','2026-06-06 20:18:13'),(100,'App\\Models\\User',3,'google-auth','4a0d1af1941a9027394c094b92202772e72643e0abf7a3faa06090a1089c42fc','[\"*\"]',NULL,NULL,'2026-06-06 20:23:43','2026-06-06 20:23:43'),(101,'App\\Models\\User',2,'google-auth','6ed7a0c516e2ab70a150650a7d155eb4b53c85b3369a43089b5f10b3762eda83','[\"*\"]',NULL,NULL,'2026-06-06 20:26:14','2026-06-06 20:26:14'),(102,'App\\Models\\User',3,'google-auth','5cfba3c0a47c3d3f4b92b3262cc13bbb133b44a049649b7cf4ec7a4b73a680f9','[\"*\"]',NULL,NULL,'2026-06-06 20:56:16','2026-06-06 20:56:16'),(103,'App\\Models\\User',3,'google-auth','70f0e735f138f5d9063621ae0d5887359e74f10dc53a92bbf3dcbc16b3b8f8ab','[\"*\"]',NULL,NULL,'2026-06-06 21:05:34','2026-06-06 21:05:34'),(104,'App\\Models\\User',3,'google-auth','c465bfc802630dd652dbde8ffcf1e7faa0c0d03075318ba32e17d2aedeb349a7','[\"*\"]','2026-06-06 21:11:24',NULL,'2026-06-06 21:11:06','2026-06-06 21:11:24'),(105,'App\\Models\\User',3,'google-auth','690118f22062477783218b5e3a72962e3bf66c0ec6f4f17928174ffc9cfaba8d','[\"*\"]','2026-06-06 21:13:17',NULL,'2026-06-06 21:13:13','2026-06-06 21:13:17'),(106,'App\\Models\\User',3,'google-auth','f29a22ac0aaa0e6917c0bca3a27730110be3545f4fac4d3418b64bec88d27004','[\"*\"]','2026-06-07 00:41:30',NULL,'2026-06-06 21:20:39','2026-06-07 00:41:30'),(107,'App\\Models\\User',3,'google-auth','7b46e8551442d7a0bc942b8d85c39663d3b7c39f28ad65f48bb4094e312b560a','[\"*\"]',NULL,NULL,'2026-06-07 00:43:16','2026-06-07 00:43:16'),(108,'App\\Models\\User',3,'google-auth','e6b277b6e7fd8b77415e28e5abea93fd2862846512f7bce165c3cc429f16e2c0','[\"*\"]','2026-06-07 00:49:00',NULL,'2026-06-07 00:46:06','2026-06-07 00:49:00'),(109,'App\\Models\\User',3,'google-auth','0e07bc18f7200353cd9a89bf95b22c1ddd5aad44acbd4d7c1da8cca7e663dec6','[\"*\"]','2026-06-07 00:54:17',NULL,'2026-06-07 00:54:13','2026-06-07 00:54:17'),(110,'App\\Models\\User',3,'google-auth','f42d9ece943bfd6999b9fda67aacb97dccbd54c9b66b7da65d9fcc45cbec117b','[\"*\"]',NULL,NULL,'2026-06-07 01:03:12','2026-06-07 01:03:12'),(111,'App\\Models\\User',3,'google-auth','d8cf2c6a915c6a8a15d6bd0a1c64ad3d81ae584cadc5e63aeb05ccb286ed5efc','[\"*\"]',NULL,NULL,'2026-06-07 01:06:56','2026-06-07 01:06:56'),(112,'App\\Models\\User',3,'google-auth','8502ec7066c96dc7ad48e2d03048285fbc0e3f8a7c791f8de0dc1c8f02191080','[\"*\"]','2026-06-07 01:42:36',NULL,'2026-06-07 01:40:31','2026-06-07 01:42:36'),(113,'App\\Models\\User',3,'google-auth','4b639a05a8484e063ef254ba038964cd58950b6d8059d3005a9d130d1731b2f0','[\"*\"]','2026-06-07 01:44:11',NULL,'2026-06-07 01:44:06','2026-06-07 01:44:11'),(114,'App\\Models\\User',3,'google-auth','338012ad49d1e3f5b54668a44ed872fa770026d9ee601277c652d13862d23998','[\"*\"]','2026-06-07 02:46:39',NULL,'2026-06-07 02:46:33','2026-06-07 02:46:39'),(115,'App\\Models\\User',3,'google-auth','ddcb53532234bad01a80ea5fbf96d3e040650a5815e84e41d3f7f1c918721cb9','[\"*\"]','2026-06-07 02:58:50',NULL,'2026-06-07 02:47:14','2026-06-07 02:58:50'),(116,'App\\Models\\User',3,'google-auth','18e51acec6f418505095c080d83ececba822abd4f2df00a900771d2616c9d9d2','[\"*\"]','2026-06-07 03:00:55',NULL,'2026-06-07 03:00:51','2026-06-07 03:00:55'),(117,'App\\Models\\User',3,'google-auth','25613b2680ad1a6b1ad23f844c14154b56d0d396a521e2caecb8ff5d533a276f','[\"*\"]','2026-06-07 04:33:17',NULL,'2026-06-07 04:33:09','2026-06-07 04:33:17'),(118,'App\\Models\\User',3,'google-auth','a7755125340c12167bb30e19ae98ebf1d967fc05f7468eb9ceab79da65ed675e','[\"*\"]','2026-06-07 04:52:03',NULL,'2026-06-07 04:38:31','2026-06-07 04:52:03'),(119,'App\\Models\\User',3,'google-auth','b17fa1711d80a896f887a944d5e601dcc14ddb0f3903e5f568ff35eed69f4979','[\"*\"]','2026-06-07 07:21:00',NULL,'2026-06-07 05:19:13','2026-06-07 07:21:00');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_user_id_key_unique` (`user_id`,`key`),
  CONSTRAINT `settings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (10,3,'business_name','Pt Maju Mundur','2026-05-27 05:59:52','2026-06-07 04:39:45'),(11,3,'business_address',NULL,'2026-05-27 05:59:52','2026-05-27 05:59:52'),(12,3,'business_phone',NULL,'2026-05-27 05:59:52','2026-05-27 05:59:52'),(13,3,'business_email',NULL,'2026-05-27 05:59:52','2026-05-27 05:59:52'),(14,3,'business_logo_url',NULL,'2026-05-27 05:59:52','2026-05-27 05:59:52'),(15,3,'invoice_prefix','INV','2026-05-27 05:59:52','2026-05-27 05:59:52'),(16,3,'invoice_starting_number','1','2026-05-27 05:59:52','2026-05-27 05:59:52'),(17,3,'invoice_currency','USD','2026-05-27 05:59:52','2026-06-05 22:24:40'),(18,3,'invoice_invoice_logo_url','http://localhost:8000/storage/logos/5Qwg7vxAwOWAlT5RckzkbdeyojXAdj2aJ8cbNXay.png','2026-05-27 05:59:52','2026-06-04 06:57:40'),(19,2,'business_name',NULL,'2026-05-31 05:33:15','2026-05-31 05:33:15'),(20,2,'business_address',NULL,'2026-05-31 05:33:15','2026-05-31 05:33:15'),(21,2,'business_phone',NULL,'2026-05-31 05:33:15','2026-05-31 05:33:15'),(22,2,'business_email',NULL,'2026-05-31 05:33:15','2026-05-31 05:33:15'),(23,2,'business_logo_url',NULL,'2026-05-31 05:33:15','2026-05-31 05:33:15'),(24,2,'invoice_prefix','INV','2026-05-31 05:33:15','2026-05-31 05:33:15'),(25,2,'invoice_starting_number','1','2026-05-31 05:33:15','2026-05-31 05:33:15'),(26,2,'invoice_currency','IDR','2026-05-31 05:33:15','2026-05-31 05:33:15'),(27,2,'invoice_invoice_logo_url','http://localhost:8000/storage/logos/oyJ5nPVcYF93nHdfnoOTu73TuXL4KH3jh74mZ3fR.png','2026-05-31 05:33:15','2026-05-31 05:33:15'),(28,3,'invoice_template','modern','2026-06-04 08:49:55','2026-06-05 23:52:38'),(29,3,'invoice_logo_position','left','2026-06-04 08:49:55','2026-06-05 23:28:55'),(30,3,'invoice_invoice_language','id','2026-06-04 09:23:48','2026-06-05 23:51:52'),(31,2,'invoice_template','classic','2026-06-05 20:59:28','2026-06-05 20:59:28'),(32,2,'invoice_logo_position','left','2026-06-05 20:59:28','2026-06-05 20:59:28'),(33,2,'invoice_invoice_language','id','2026-06-05 20:59:28','2026-06-05 20:59:28');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','user') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_google_id_unique` (`google_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'Athallah ahdita amyunas','athallah32197@gmail.com','user','104311269853095467777',NULL,'$2y$12$SVyMXuEDAjk7aCgoA6hFjOfN5GFs6RrUKMDvEbDScqzpd9P9oNXae',NULL,'2026-05-22 04:37:32','2026-05-30 20:25:07'),(3,'Athallah ahdita amyunas','athallahahdita@gmail.com','user','112295022396136353395',NULL,'$2y$12$O/TAaIsoNMnIeZd9v0.00Ocxy5rYoHWS9DP17D.Sn/UTGko8U3R9O',NULL,'2026-05-27 04:33:14','2026-05-30 19:54:42'),(5,'Owner','owner@invoiceku.com','admin',NULL,'2026-05-30 21:02:09','$2y$12$Zyh19XhWxEUHwlSo5O98/OpOpRQ8abjqz1uKxPgn/tX2nds3rwqji',NULL,'2026-05-30 20:44:18','2026-05-30 21:02:09'),(7,'umum bappedalitbang','umumbappedalitbang@gmail.com','user','110660301243892914521',NULL,'$2y$12$Xk43C5Ue3DFhEinKn/ndv.bNU66zofO5WUnQb/PunmCugqKnQuFMi',NULL,'2026-05-31 01:58:49','2026-05-31 01:58:49'),(8,'athallah ahdita','athallahahditaamyunas@gmail.com','user',NULL,NULL,'$2y$12$OeDQF8F81Y/Hcyieg9Nyfeu.Q96/h8Ht9CTNFSr3.l7ci7DStRFNm',NULL,'2026-06-06 11:56:55','2026-06-06 11:56:55'),(9,'adasda','adasdas@gmail.com','user',NULL,NULL,'$2y$12$mZ7ADcLHrlOMVkx8cs2j3.1K3N9dk3P8a.bTy5SE1/Ux84xussZva',NULL,'2026-06-07 00:49:50','2026-06-07 00:49:50'),(10,'asdasd','asdasd@gmail.com','user',NULL,NULL,'$2y$12$YKNoTsP8gubXUMBHCf1YteOgeKieJKh43tM9QLDJl0cKu6AXeQLgy',NULL,'2026-06-07 00:54:00','2026-06-07 00:54:00'),(11,'asdwddq','sadqwer@gmail.com','user',NULL,NULL,'$2y$12$UxJP9agx5S0aGrNBuw.77.nev7P/8Mkr4UsaOGulKMfYqk6RaufnS',NULL,'2026-06-07 02:47:02','2026-06-07 02:47:02');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-07 23:31:54
