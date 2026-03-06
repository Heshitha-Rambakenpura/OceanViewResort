-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: oceanview_resort
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `admin_level` int DEFAULT '1',
  PRIMARY KEY (`admin_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `admins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,1,1);
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` varchar(100) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'LOGIN_SUCCESS','2026-03-06 00:04:09','0:0:0:0:0:0:0:1'),(2,1,'LOGOUT','2026-03-06 00:04:51','0:0:0:0:0:0:0:1'),(3,2,'LOGIN_SUCCESS','2026-03-06 00:05:01','0:0:0:0:0:0:0:1'),(4,2,'LOGOUT','2026-03-06 00:05:51','0:0:0:0:0:0:0:1'),(5,3,'LOGIN_SUCCESS','2026-03-06 00:06:01','0:0:0:0:0:0:0:1'),(6,3,'LOGOUT','2026-03-06 00:08:47','0:0:0:0:0:0:0:1'),(8,2,'LOGIN_SUCCESS','2026-03-06 00:09:08','0:0:0:0:0:0:0:1'),(9,2,'LOGOUT','2026-03-06 00:12:16','0:0:0:0:0:0:0:1'),(10,1,'LOGIN_SUCCESS','2026-03-06 00:12:51','0:0:0:0:0:0:0:1'),(11,1,'AUDIT_LOGS_VIEWED','2026-03-06 00:14:14','0:0:0:0:0:0:0:1'),(12,1,'ROOM_TYPE_ADDED - Standard Single Room','2026-03-06 00:20:28','0:0:0:0:0:0:0:1'),(13,1,'ROOM_TYPE_ADDED - Standard Double Room','2026-03-06 00:21:33','0:0:0:0:0:0:0:1'),(14,1,'ROOM_ADDED - 101','2026-03-06 00:22:41','0:0:0:0:0:0:0:1'),(15,1,'ROOM_ADDED - 201','2026-03-06 00:23:27','0:0:0:0:0:0:0:1'),(16,1,'LOGOUT','2026-03-06 00:26:39','0:0:0:0:0:0:0:1'),(17,2,'LOGIN_SUCCESS','2026-03-06 00:27:29','0:0:0:0:0:0:0:1'),(18,2,'GUEST_REGISTERED','2026-03-06 00:30:54','0:0:0:0:0:0:0:1'),(19,2,'RESERVATION_ADDED','2026-03-06 00:32:01','0:0:0:0:0:0:0:1'),(20,2,'PAYMENT_MADE','2026-03-06 00:35:11','0:0:0:0:0:0:0:1'),(21,2,'LOGOUT','2026-03-06 00:37:27','0:0:0:0:0:0:0:1'),(22,3,'LOGIN_SUCCESS','2026-03-06 00:38:43','0:0:0:0:0:0:0:1'),(23,3,'REPORT_VIEWED','2026-03-06 00:39:57','0:0:0:0:0:0:0:1'),(24,3,'LOGOUT','2026-03-06 00:42:52','0:0:0:0:0:0:0:1'),(25,2,'LOGIN_SUCCESS','2026-03-06 00:43:01','0:0:0:0:0:0:0:1'),(26,2,'LOGOUT','2026-03-06 00:43:51','0:0:0:0:0:0:0:1'),(27,1,'LOGIN_SUCCESS','2026-03-06 00:43:57','0:0:0:0:0:0:0:1'),(28,1,'LOGIN_SUCCESS','2026-03-06 11:16:25','0:0:0:0:0:0:0:1'),(29,1,'LOGOUT','2026-03-06 11:18:52','0:0:0:0:0:0:0:1'),(33,2,'LOGIN_SUCCESS','2026-03-06 11:40:24','0:0:0:0:0:0:0:1'),(34,2,'GUEST_REGISTERED','2026-03-06 11:43:03','0:0:0:0:0:0:0:1'),(35,2,'GUEST_REGISTERED','2026-03-06 11:47:20','0:0:0:0:0:0:0:1'),(36,2,'GUEST_REGISTERED','2026-03-06 12:01:16','0:0:0:0:0:0:0:1'),(37,2,'RESERVATION_ADDED','2026-03-06 12:17:10','0:0:0:0:0:0:0:1'),(38,2,'RESERVATION_CANCELLED','2026-03-06 12:21:55','0:0:0:0:0:0:0:1'),(39,2,'RESERVATION_CANCELLED','2026-03-06 12:23:03','0:0:0:0:0:0:0:1'),(40,2,'LOGOUT','2026-03-06 12:24:54','0:0:0:0:0:0:0:1'),(41,1,'LOGIN_SUCCESS','2026-03-06 12:25:01','0:0:0:0:0:0:0:1'),(42,1,'ROOM_TYPE_ADDED - Twin Room','2026-03-06 12:28:36','0:0:0:0:0:0:0:1'),(43,1,'ROOM_ADDED - 301','2026-03-06 12:31:36','0:0:0:0:0:0:0:1'),(44,1,'ROOM_TYPE_UPDATED - ID:3','2026-03-06 12:36:08','0:0:0:0:0:0:0:1'),(45,1,'ROOM_DELETED - ID:4','2026-03-06 12:38:21','0:0:0:0:0:0:0:1'),(46,1,'ROOM_TYPE_DELETED - ID:3','2026-03-06 12:38:27','0:0:0:0:0:0:0:1'),(47,1,'LOGOUT','2026-03-06 12:46:34','0:0:0:0:0:0:0:1'),(48,2,'LOGIN_SUCCESS','2026-03-06 12:46:44','0:0:0:0:0:0:0:1'),(49,2,'RESERVATION_ADDED','2026-03-06 12:47:26','0:0:0:0:0:0:0:1'),(50,2,'PAYMENT_MADE','2026-03-06 12:50:23','0:0:0:0:0:0:0:1'),(51,2,'LOGOUT','2026-03-06 12:54:56','0:0:0:0:0:0:0:1'),(52,1,'LOGIN_SUCCESS','2026-03-06 12:55:03','0:0:0:0:0:0:0:1'),(53,1,'ROOM_ADDED - 102','2026-03-06 12:55:21','0:0:0:0:0:0:0:1'),(54,1,'ROOM_ADDED - 103','2026-03-06 12:55:34','0:0:0:0:0:0:0:1'),(55,1,'ROOM_ADDED - 104','2026-03-06 12:55:45','0:0:0:0:0:0:0:1'),(56,1,'ROOM_ADDED - 105','2026-03-06 12:56:00','0:0:0:0:0:0:0:1'),(57,1,'ROOM_ADDED - 106','2026-03-06 12:56:18','0:0:0:0:0:0:0:1'),(58,1,'ROOM_ADDED - 107','2026-03-06 12:56:30','0:0:0:0:0:0:0:1'),(59,1,'ROOM_ADDED - 108','2026-03-06 12:56:49','0:0:0:0:0:0:0:1'),(60,1,'ROOM_ADDED - 109','2026-03-06 12:57:05','0:0:0:0:0:0:0:1'),(61,1,'ROOM_ADDED - 110','2026-03-06 12:57:16','0:0:0:0:0:0:0:1'),(62,1,'ROOM_ADDED - 202','2026-03-06 12:57:32','0:0:0:0:0:0:0:1'),(63,1,'ROOM_ADDED - 203','2026-03-06 12:57:43','0:0:0:0:0:0:0:1'),(64,1,'ROOM_ADDED - 204','2026-03-06 12:57:55','0:0:0:0:0:0:0:1'),(65,1,'ROOM_DELETED - ID:9','2026-03-06 12:58:29','0:0:0:0:0:0:0:1'),(66,1,'ROOM_DELETED - ID:10','2026-03-06 12:58:33','0:0:0:0:0:0:0:1'),(67,1,'ROOM_DELETED - ID:11','2026-03-06 12:58:37','0:0:0:0:0:0:0:1'),(68,1,'ROOM_DELETED - ID:12','2026-03-06 12:58:41','0:0:0:0:0:0:0:1'),(69,1,'ROOM_DELETED - ID:13','2026-03-06 12:58:45','0:0:0:0:0:0:0:1'),(70,1,'ROOM_ADDED - 205','2026-03-06 12:59:01','0:0:0:0:0:0:0:1'),(71,1,'ROOM_TYPE_ADDED - Twin Room','2026-03-06 13:00:23','0:0:0:0:0:0:0:1'),(72,1,'ROOM_TYPE_ADDED - Triple Room','2026-03-06 13:01:30','0:0:0:0:0:0:0:1'),(73,1,'ROOM_TYPE_ADDED - Deluxe Room','2026-03-06 13:02:52','0:0:0:0:0:0:0:1'),(74,1,'ROOM_TYPE_ADDED - Executive Room','2026-03-06 13:04:09','0:0:0:0:0:0:0:1'),(75,1,'ROOM_TYPE_ADDED - Family Room','2026-03-06 13:05:30','0:0:0:0:0:0:0:1'),(76,1,'ROOM_TYPE_ADDED - Junior Suite','2026-03-06 13:06:24','0:0:0:0:0:0:0:1'),(77,1,'ROOM_TYPE_ADDED - Suite','2026-03-06 13:08:54','0:0:0:0:0:0:0:1'),(78,1,'ROOM_TYPE_ADDED - Presidential / Luxury Suite','2026-03-06 13:10:00','0:0:0:0:0:0:0:1'),(79,1,'ROOM_ADDED - 301','2026-03-06 13:11:13','0:0:0:0:0:0:0:1'),(80,1,'ROOM_ADDED - 302','2026-03-06 13:11:38','0:0:0:0:0:0:0:1'),(81,1,'ROOM_ADDED - 303','2026-03-06 13:11:59','0:0:0:0:0:0:0:1'),(82,1,'ROOM_ADDED - 304','2026-03-06 13:12:09','0:0:0:0:0:0:0:1'),(83,1,'ROOM_ADDED - 305','2026-03-06 13:12:20','0:0:0:0:0:0:0:1'),(84,1,'ROOM_ADDED - 401','2026-03-06 13:12:43','0:0:0:0:0:0:0:1'),(85,1,'ROOM_ADDED - 402','2026-03-06 13:12:54','0:0:0:0:0:0:0:1'),(86,1,'ROOM_ADDED - 403','2026-03-06 13:13:09','0:0:0:0:0:0:0:1'),(87,1,'ROOM_ADDED - 404','2026-03-06 13:13:22','0:0:0:0:0:0:0:1'),(88,1,'ROOM_ADDED - 405','2026-03-06 13:13:34','0:0:0:0:0:0:0:1'),(89,1,'ROOM_ADDED - 501','2026-03-06 13:14:43','0:0:0:0:0:0:0:1'),(90,1,'ROOM_ADDED - 601','2026-03-06 13:15:08','0:0:0:0:0:0:0:1'),(91,1,'ROOM_ADDED - 701','2026-03-06 13:15:31','0:0:0:0:0:0:0:1'),(92,1,'ROOM_ADDED - 801','2026-03-06 13:15:56','0:0:0:0:0:0:0:1'),(93,1,'ROOM_ADDED - 901','2026-03-06 13:16:28','0:0:0:0:0:0:0:1'),(94,1,'AUDIT_LOGS_VIEWED','2026-03-06 13:16:45','0:0:0:0:0:0:0:1'),(95,1,'LOGOUT','2026-03-06 13:16:53','0:0:0:0:0:0:0:1'),(96,2,'LOGIN_SUCCESS','2026-03-06 13:17:03','0:0:0:0:0:0:0:1'),(97,2,'RESERVATION_ADDED','2026-03-06 13:17:44','0:0:0:0:0:0:0:1'),(98,2,'PAYMENT_MADE','2026-03-06 13:21:41','0:0:0:0:0:0:0:1'),(99,2,'RESERVATION_ADDED','2026-03-06 13:26:18','0:0:0:0:0:0:0:1'),(100,2,'PAYMENT_MADE','2026-03-06 13:28:51','0:0:0:0:0:0:0:1'),(101,2,'LOGOUT','2026-03-06 13:33:03','0:0:0:0:0:0:0:1'),(102,3,'LOGIN_SUCCESS','2026-03-06 13:33:15','0:0:0:0:0:0:0:1'),(103,3,'REPORT_VIEWED','2026-03-06 13:33:19','0:0:0:0:0:0:0:1'),(104,3,'REPORT_VIEWED','2026-03-06 13:33:33','0:0:0:0:0:0:0:1'),(105,3,'LOGOUT','2026-03-06 13:34:29','0:0:0:0:0:0:0:1'),(106,1,'LOGIN_SUCCESS','2026-03-06 13:34:35','0:0:0:0:0:0:0:1'),(107,1,'USER_CREATED - tom1','2026-03-06 13:36:34','0:0:0:0:0:0:0:1'),(108,2,'LOGIN_SUCCESS','2026-03-06 14:38:05','0:0:0:0:0:0:0:1'),(109,2,'LOGOUT','2026-03-06 14:41:58','0:0:0:0:0:0:0:1'),(110,1,'LOGIN_SUCCESS','2026-03-06 14:42:05','0:0:0:0:0:0:0:1'),(111,1,'LOGOUT','2026-03-06 14:42:32','0:0:0:0:0:0:0:1'),(113,2,'LOGIN_SUCCESS','2026-03-06 14:42:48','0:0:0:0:0:0:0:1'),(114,2,'LOGOUT','2026-03-06 14:53:52','0:0:0:0:0:0:0:1'),(115,3,'LOGIN_SUCCESS','2026-03-06 14:54:02','0:0:0:0:0:0:0:1'),(116,3,'REPORT_VIEWED','2026-03-06 14:54:05','0:0:0:0:0:0:0:1'),(117,3,'REPORT_EXPORTED','2026-03-06 14:55:11','0:0:0:0:0:0:0:1');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills` (
  `bill_id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `net_amount` decimal(10,2) NOT NULL,
  `generated_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_paid` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`bill_id`),
  UNIQUE KEY `reservation_id` (`reservation_id`),
  CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` VALUES (1,1,30000.00,3000.00,0.00,33000.00,'2026-03-06 00:32:01',1),(2,2,40000.00,4000.00,0.00,44000.00,'2026-03-06 12:17:10',0),(3,3,15000.00,1500.00,0.00,16500.00,'2026-03-06 12:47:26',1),(4,4,80000.00,8000.00,0.00,88000.00,'2026-03-06 13:17:44',1),(5,5,110000.00,11000.00,0.00,121000.00,'2026-03-06 13:26:18',1);
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `card_payments`
--

DROP TABLE IF EXISTS `card_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `card_payments` (
  `card_payment_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `card_number` varchar(20) NOT NULL,
  `card_holder_name` varchar(100) NOT NULL,
  `expiry_date` varchar(10) NOT NULL,
  PRIMARY KEY (`card_payment_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `card_payments_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `card_payments`
--

LOCK TABLES `card_payments` WRITE;
/*!40000 ALTER TABLE `card_payments` DISABLE KEYS */;
INSERT INTO `card_payments` VALUES (1,2,'1111 1111 5549 9797','thejan','02/30');
/*!40000 ALTER TABLE `card_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cash_payments`
--

DROP TABLE IF EXISTS `cash_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cash_payments` (
  `cash_payment_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `amount_tendered` decimal(10,2) NOT NULL,
  `change_amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`cash_payment_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `cash_payments_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cash_payments`
--

LOCK TABLES `cash_payments` WRITE;
/*!40000 ALTER TABLE `cash_payments` DISABLE KEYS */;
INSERT INTO `cash_payments` VALUES (1,1,38500.00,0.00);
/*!40000 ALTER TABLE `cash_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finance_department`
--

DROP TABLE IF EXISTS `finance_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finance_department` (
  `finance_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `department_id` varchar(20) NOT NULL,
  PRIMARY KEY (`finance_id`),
  UNIQUE KEY `department_id` (`department_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `finance_department_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finance_department`
--

LOCK TABLES `finance_department` WRITE;
/*!40000 ALTER TABLE `finance_department` DISABLE KEYS */;
INSERT INTO `finance_department` VALUES (1,3,'FIN001');
/*!40000 ALTER TABLE `finance_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guests`
--

DROP TABLE IF EXISTS `guests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guests` (
  `guest_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `nic` varchar(20) NOT NULL,
  `nationality` varchar(50) NOT NULL,
  `address` text NOT NULL,
  `contact_number` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`guest_id`),
  UNIQUE KEY `nic` (`nic`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guests`
--

LOCK TABLES `guests` WRITE;
/*!40000 ALTER TABLE `guests` DISABLE KEYS */;
INSERT INTO `guests` VALUES (1,'Heshitha Thejan','200645987451','Sri Lankan','No.12, Kandy','0771548792','heshitha@gmail.com','2026-03-06 00:30:54'),(2,'JUnit Test Guest','987654321V','Sri Lankan','Test Address','0771111111','junit@test.com','2026-03-06 11:10:53'),(3,'Saman Kumara','123456789V','Sri Lankan','No.08, Galle','0771587421','samank@gmail.com','2026-03-06 11:43:03'),(4,'Nihal Samarakoon','200012345678','Sri Lankan','No.10, Anuradhapura','0714569874','nihal@gmail.com','2026-03-06 11:47:20'),(5,'Mick Daniel','N1234567','British','No.22B, London','0712547895','mick@gmail.com','2026-03-06 12:01:16');
/*!40000 ALTER TABLE `guests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `message` text NOT NULL,
  `sent_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `type` enum('EMAIL','SMS') NOT NULL,
  `status` enum('SENT','FAILED','PENDING') DEFAULT 'PENDING',
  `recipient_email` varchar(100) DEFAULT NULL,
  `recipient_phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `reservation_id` (`reservation_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online_transfer_payments`
--

DROP TABLE IF EXISTS `online_transfer_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `online_transfer_payments` (
  `online_payment_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `reference_number` varchar(50) NOT NULL,
  `transfer_date` date NOT NULL,
  `sender_name` varchar(100) NOT NULL,
  PRIMARY KEY (`online_payment_id`),
  UNIQUE KEY `reference_number` (`reference_number`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `online_transfer_payments_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online_transfer_payments`
--

LOCK TABLES `online_transfer_payments` WRITE;
/*!40000 ALTER TABLE `online_transfer_payments` DISABLE KEYS */;
INSERT INTO `online_transfer_payments` VALUES (1,3,'NSB','222222222IM','2026-03-05','thejan');
/*!40000 ALTER TABLE `online_transfer_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('CASH','CARD','ONLINE_TRANSFER') NOT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `payment_status` enum('SUCCESS','FAILED','PENDING') DEFAULT 'PENDING',
  `receipt_number` varchar(50) NOT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `receipt_number` (`receipt_number`),
  KEY `bill_id` (`bill_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,33000.00,'CASH','2026-03-06 00:35:11','SUCCESS','RCP1772737511048'),(2,3,16500.00,'CASH','2026-03-06 12:50:23','SUCCESS','RCP1772781623305'),(3,4,88000.00,'CARD','2026-03-06 13:21:41','SUCCESS','RCP1772783501174'),(4,5,121000.00,'ONLINE_TRANSFER','2026-03-06 13:28:51','SUCCESS','RCP1772783931102');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receptionists`
--

DROP TABLE IF EXISTS `receptionists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receptionists` (
  `receptionist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `employee_id` varchar(20) NOT NULL,
  `shift` enum('MORNING','EVENING','NIGHT') NOT NULL,
  PRIMARY KEY (`receptionist_id`),
  UNIQUE KEY `employee_id` (`employee_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `receptionists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receptionists`
--

LOCK TABLES `receptionists` WRITE;
/*!40000 ALTER TABLE `receptionists` DISABLE KEYS */;
INSERT INTO `receptionists` VALUES (1,2,'EMP001','MORNING');
/*!40000 ALTER TABLE `receptionists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `report_type` varchar(50) NOT NULL,
  `generated_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `generated_by` int NOT NULL,
  PRIMARY KEY (`report_id`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `status` enum('CONFIRMED','CHECKED_IN','CHECKED_OUT','CANCELLED') DEFAULT 'CONFIRMED',
  `number_of_nights` int NOT NULL,
  `number_of_guests` int NOT NULL DEFAULT '1',
  `special_requests` text,
  `created_by` int NOT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`),
  KEY `guest_id` (`guest_id`),
  KEY `room_id` (`room_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,1,2,'2026-03-06','2026-03-08','CANCELLED',2,1,NULL,2,'2026-03-06 00:32:01'),(2,1,3,'2026-03-08','2026-03-10','CANCELLED',2,2,NULL,2,'2026-03-06 12:17:10'),(3,3,2,'2026-03-06','2026-03-07','CONFIRMED',1,1,NULL,2,'2026-03-06 12:47:26'),(4,4,3,'2026-03-10','2026-03-14','CONFIRMED',4,2,NULL,2,'2026-03-06 13:17:44'),(5,1,30,'2026-03-22','2026-03-24','CONFIRMED',2,6,NULL,2,'2026-03-06 13:26:18');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `room_type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `description` text,
  `base_price` decimal(10,2) NOT NULL,
  `amenities` text,
  PRIMARY KEY (`room_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
INSERT INTO `room_types` VALUES (1,'Standard Single Room','Basic single-occupancy room for solo travelers.',15000.00,'Single bed, Free Wi-Fi, TV, Air conditioning, Private bathroom'),(2,'Standard Double Room','Standard room with one double/queen bed for two guests.',20000.00,'Double bed, Free Wi-Fi, TV, Air conditioning, Mini-fridge'),(4,'Twin Room','Room with two single beds — ideal for friends sharing.',22000.00,'Two single beds, Wi-Fi, TV, Air conditioning, Ensuite bathroom'),(5,'Triple Room','Room for 3 guests — three singles or a mix of double + single.',28000.00,'Multiple beds, Wi-Fi, TV, Air conditioning, Extra space'),(6,'Deluxe Room','Spacious upgraded room with better décor and comfort.',35000.00,'Queen/king bed, Free Wi-Fi, TV with premium channels, Mini-bar or fridge, Tea/coffee maker    '),(7,'Executive Room','Business-oriented room with work-friendly space and perks.',45000.00,'King/queen bed, Work desk & chair, Upgraded Wi-Fi, Lounge access, Premium toiletries       '),(8,'Family Room','Larger room for families — with extra beds.',55000.00,'Multiple beds or sofa bed, Spacious layout, Wi-Fi, TV, Mini-fridge'),(9,'Junior Suite','Partially separated seating area — more spacious.',70000.00,'King bed, Living/sitting area, Free Wi-Fi, Nespresso/coffee station, Premium bathroom                '),(10,'Suite','Luxury suite with separate bedroom & living space.',100000.00,'Bedroom + living room, High-end furnishings, Lounge access, Complimentary minibar, Concierge service                '),(11,'Presidential / Luxury Suite','Most premium offering with highest comfort & services.',200000.00,'Multiple rooms (living, dining), VIP services, Top-tier toiletries, Butler service, Best views                   ');
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `room_number` varchar(10) NOT NULL,
  `room_type_id` int NOT NULL,
  `floor_number` int NOT NULL,
  `max_occupancy` int NOT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `description` text,
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `room_number` (`room_number`),
  KEY `room_type_id` (`room_type_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (2,'101',1,1,1,0,''),(3,'201',2,2,2,0,''),(5,'102',1,1,1,1,''),(6,'103',1,1,1,1,''),(7,'104',1,1,1,1,''),(8,'105',1,1,1,1,''),(14,'202',2,2,2,1,''),(15,'203',2,2,2,1,''),(16,'204',2,2,2,1,''),(17,'205',2,2,2,1,''),(18,'301',4,3,2,1,''),(19,'302',4,3,2,1,''),(20,'303',4,3,2,1,''),(21,'304',4,3,2,1,''),(22,'305',4,3,2,1,''),(23,'401',5,4,3,1,''),(24,'402',5,4,3,1,''),(25,'403',5,4,3,1,''),(26,'404',5,4,3,1,''),(27,'405',5,4,3,1,''),(28,'501',6,5,2,1,''),(29,'601',7,6,2,1,''),(30,'701',8,7,6,0,''),(31,'801',9,8,2,1,''),(32,'901',10,9,4,1,'');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` enum('RECEPTIONIST','ADMIN','FINANCE') NOT NULL,
  `login_status` tinyint(1) DEFAULT '0',
  `register_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin123','Administrator','ADMIN',0,'2026-03-05 21:21:02'),(2,'receptionist1','recep123','John Reception','RECEPTIONIST',0,'2026-03-05 21:21:02'),(3,'finance1','finance123','Jane Finance','FINANCE',1,'2026-03-05 21:21:02'),(4,'tom1','tom123','Tom','RECEPTIONIST',0,'2026-03-06 13:36:34');
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

-- Dump completed on 2026-03-06 16:04:05
