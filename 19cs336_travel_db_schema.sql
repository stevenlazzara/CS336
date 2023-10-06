-- MySQL dump 10.13  Distrib 8.0.18, for macos10.14 (x86_64)
--
-- Host: cs336-travel-db.cz26infzmgg4.us-east-2.rds.amazonaws.com    Database: cs336_travel_db
-- ------------------------------------------------------
-- Server version	5.7.22-log

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
-- Table structure for table `Aircraft`
--

DROP TABLE IF EXISTS `Aircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Aircraft` (
  `aircraft_id` int(11) NOT NULL,
  PRIMARY KEY (`aircraft_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Aircraft`
--

LOCK TABLES `Aircraft` WRITE;
/*!40000 ALTER TABLE `Aircraft` DISABLE KEYS */;
INSERT INTO `Aircraft` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21);
/*!40000 ALTER TABLE `Aircraft` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Airline`
--

DROP TABLE IF EXISTS `Airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Airline` (
  `airline_id` varchar(2) NOT NULL,
  PRIMARY KEY (`airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Airline`
--

LOCK TABLES `Airline` WRITE;
/*!40000 ALTER TABLE `Airline` DISABLE KEYS */;
INSERT INTO `Airline` VALUES ('AA'),('AC'),('AS'),('BA'),('DL'),('DT'),('DY'),('EY'),('GF'),('JL'),('UA'),('UN'),('VS');
/*!40000 ALTER TABLE `Airline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Airport`
--

DROP TABLE IF EXISTS `Airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Airport` (
  `airport_id` varchar(3) NOT NULL,
  PRIMARY KEY (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Airport`
--

LOCK TABLES `Airport` WRITE;
/*!40000 ALTER TABLE `Airport` DISABLE KEYS */;
INSERT INTO `Airport` VALUES (''),('ABI'),('ABR'),('ABY'),('ALB'),('ARB'),('BTV'),('CAK'),('CMI'),('CSN'),('EWR'),('GCN'),('JFK'),('LAX'),('LGA'),('MCO'),('NCR'),('ORD');
/*!40000 ALTER TABLE `Airport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DayOfTheWeek`
--

DROP TABLE IF EXISTS `DayOfTheWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DayOfTheWeek` (
  `day_number` int(11) NOT NULL,
  `day_of_week` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`day_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DayOfTheWeek`
--

LOCK TABLES `DayOfTheWeek` WRITE;
/*!40000 ALTER TABLE `DayOfTheWeek` DISABLE KEYS */;
/*!40000 ALTER TABLE `DayOfTheWeek` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Flight_Operates`
--

DROP TABLE IF EXISTS `Flight_Operates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Flight_Operates` (
  `aircraft_id` int(11) NOT NULL,
  `airline_id` varchar(2) NOT NULL,
  `airport_id` varchar(3) NOT NULL,
  `flight_number` int(11) NOT NULL,
  `flight_type` varchar(1) DEFAULT NULL,
  `depart_time` time DEFAULT NULL,
  `arrival_time` time DEFAULT NULL,
  `fare_first` float DEFAULT NULL,
  `fare_economy` float DEFAULT NULL,
  `departure_airport` varchar(3) DEFAULT NULL,
  `destination_airport` varchar(3) DEFAULT NULL,
  `fare_business` float DEFAULT NULL,
  `num_stops` int(11) DEFAULT '0',
  `depart_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  PRIMARY KEY (`airline_id`,`airport_id`,`aircraft_id`,`flight_number`),
  KEY `aircraft_id` (`aircraft_id`),
  KEY `airport_id` (`airport_id`),
  CONSTRAINT `Flight_Operates_ibfk_1` FOREIGN KEY (`aircraft_id`) REFERENCES `Aircraft` (`aircraft_id`),
  CONSTRAINT `Flight_Operates_ibfk_2` FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`airline_id`),
  CONSTRAINT `Flight_Operates_ibfk_3` FOREIGN KEY (`airport_id`) REFERENCES `Airport` (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flight_Operates`
--

LOCK TABLES `Flight_Operates` WRITE;
/*!40000 ALTER TABLE `Flight_Operates` DISABLE KEYS */;
INSERT INTO `Flight_Operates` VALUES (1,'AA','ABI',11,'o','08:00:00','09:00:00',100,25,'ABI','ABR',50,2,'2019-12-11','9999-12-31'),(3,'AA','ABI',13,'o','08:00:00','09:00:00',100,25,'ABI','ABR',50,2,'2019-12-14','9999-12-31'),(2,'AA','ABY',12,'r','09:00:00','10:00:00',100,25,'ABY','ALB',75,0,'2019-12-14','2019-12-17'),(4,'AA','ABY',14,'r','09:00:00','10:00:00',100,25,'ABY','ALB',75,0,'2019-12-17','2019-12-20'),(16,'BA','JFK',6,'o','13:30:00','17:50:00',100,30,'JFK','LAX',55,0,'2020-01-07','9999-12-31'),(15,'DL','EWR',18,'o','09:30:00','11:45:00',95,35,'EWR','NCR',55,0,'2019-12-22','9999-12-31'),(13,'EY','CMI',21,'o','00:00:22','02:00:00',120,40,'CMI','CSN',60,1,'2020-01-03','9999-12-31'),(17,'EY','CMI',18,'o','12:00:00','13:45:00',250,75,'CMI','CSN',150,0,'2020-01-05','9999-12-31'),(19,'EY','ORD',199,'r','04:10:00','07:17:00',90.99,55,'ORD','LGA',75,4,'2019-12-23','2019-12-25'),(7,'UA','ALB',21,'r','10:00:00','11:00:00',150,75,'ALB','ARB',100,3,'2019-01-10','2019-01-15'),(19,'UA','ALB',37,'r','10:00:00','11:00:00',150,75,'ALB','ARB',100,3,'2019-01-07','2019-01-12'),(8,'UA','EWR',41,'o','12:00:00','01:00:00',200,100,'EWR','LAX',150,2,'2019-01-20','9999-12-31'),(9,'UA','EWR',42,'o','01:00:00','02:00:00',200,100,'EWR','LAX',150,2,'2019-01-22','9999-12-31'),(10,'UA','EWR',43,'r','02:00:00','03:00:00',250,75,'EWR','LAX',150,0,'2019-01-25','2019-01-28');
/*!40000 ALTER TABLE `Flight_Operates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Owns`
--

DROP TABLE IF EXISTS `Owns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Owns` (
  `aircraft_id` int(11) NOT NULL,
  `airline_id` varchar(2) NOT NULL,
  PRIMARY KEY (`aircraft_id`),
  KEY `airline_id` (`airline_id`),
  CONSTRAINT `Owns_ibfk_1` FOREIGN KEY (`aircraft_id`) REFERENCES `Aircraft` (`aircraft_id`),
  CONSTRAINT `Owns_ibfk_2` FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Owns`
--

LOCK TABLES `Owns` WRITE;
/*!40000 ALTER TABLE `Owns` DISABLE KEYS */;
INSERT INTO `Owns` VALUES (1,'AA'),(2,'AA'),(3,'AA'),(4,'AA'),(16,'BA'),(15,'DL'),(13,'EY'),(17,'EY'),(7,'UA'),(8,'UA'),(9,'UA'),(10,'UA'),(19,'UA'),(6,'UN');
/*!40000 ALTER TABLE `Owns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `account_num` int(11) NOT NULL,
  `logged_in` int(11) DEFAULT '-1',
  `account_type` enum('0','1','2') DEFAULT '0',
  PRIMARY KEY (`account_num`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES ('admin','admin','Admin Account',3,-1,'2'),('cr','cr','customer rep',4,1176009,'1'),('c','c','customer',5,-1,'0'),('ZS','ZS','ZS',6,1521446,'0');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reserves`
--

DROP TABLE IF EXISTS `Reserves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reserves` (
  `ticket_number` int(11) NOT NULL,
  `account_num` int(11) DEFAULT NULL,
  PRIMARY KEY (`ticket_number`),
  KEY `account_num` (`account_num`),
  CONSTRAINT `Reserves_ibfk_1` FOREIGN KEY (`account_num`) REFERENCES `Person` (`account_num`),
  CONSTRAINT `Reserves_ibfk_2` FOREIGN KEY (`ticket_number`) REFERENCES `Tickets` (`ticket_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reserves`
--

LOCK TABLES `Reserves` WRITE;
/*!40000 ALTER TABLE `Reserves` DISABLE KEYS */;
INSERT INTO `Reserves` VALUES (43,6);
/*!40000 ALTER TABLE `Reserves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS `Tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tickets` (
  `ticket_number` int(11) NOT NULL,
  `seat_number` int(11) NOT NULL,
  `account_num` int(11) NOT NULL DEFAULT '-1',
  `aircraft_id` int(11) NOT NULL,
  `airline_id` varchar(2) NOT NULL,
  `airport_id` varchar(3) NOT NULL,
  `flight_number` int(11) NOT NULL,
  `seat_class` varchar(1) NOT NULL,
  `booking_fee` float DEFAULT NULL,
  `issue_date` datetime DEFAULT NULL,
  `ticket_price` float DEFAULT NULL,
  PRIMARY KEY (`ticket_number`,`seat_number`,`account_num`),
  KEY `airline_id` (`airline_id`,`airport_id`,`aircraft_id`,`flight_number`),
  CONSTRAINT `Tickets_ibfk_1` FOREIGN KEY (`airline_id`, `airport_id`, `aircraft_id`, `flight_number`) REFERENCES `Flight_Operates` (`airline_id`, `airport_id`, `aircraft_id`, `flight_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tickets`
--

LOCK TABLES `Tickets` WRITE;
/*!40000 ALTER TABLE `Tickets` DISABLE KEYS */;
INSERT INTO `Tickets` VALUES (1,1,-1,1,'AA','ABI',11,'e',20,'2019-12-11 00:00:00',45),(2,2,-1,1,'AA','ABI',11,'e',20,'9999-12-31 00:00:00',45),(3,3,-1,1,'AA','ABI',11,'e',20,'9999-12-31 00:00:00',45),(4,4,-1,1,'AA','ABI',11,'b',20,'9999-12-31 00:00:00',75),(5,5,-1,1,'AA','ABI',11,'b',20,'9999-12-31 00:00:00',75),(6,6,-1,1,'AA','ABI',11,'b',20,'9999-12-31 00:00:00',75),(7,7,-1,1,'AA','ABI',11,'f',20,'9999-12-31 00:00:00',120),(8,8,-1,1,'AA','ABI',11,'f',20,'9999-12-31 00:00:00',120),(9,9,-1,1,'AA','ABI',11,'f',20,'9999-12-31 00:00:00',120),(10,10,-1,3,'AA','ABI',13,'e',20,'9999-12-31 00:00:00',45),(11,11,-1,3,'AA','ABI',13,'e',20,'9999-12-31 00:00:00',45),(12,12,-1,3,'AA','ABI',13,'e',20,'9999-12-31 00:00:00',45),(13,13,-1,3,'AA','ABI',13,'b',20,'9999-12-31 00:00:00',95),(14,14,-1,3,'AA','ABI',13,'b',20,'9999-12-31 00:00:00',95),(15,15,-1,3,'AA','ABI',13,'b',20,'9999-12-31 00:00:00',95),(16,16,-1,3,'AA','ABI',13,'f',20,'9999-12-31 00:00:00',120),(17,17,-1,3,'AA','ABI',13,'f',20,'9999-12-31 00:00:00',120),(18,18,-1,3,'AA','ABI',13,'f',20,'9999-12-31 00:00:00',120),(19,19,-1,2,'AA','ABY',12,'e',20,'9999-12-31 00:00:00',45),(20,20,-1,2,'AA','ABY',12,'e',20,'9999-12-31 00:00:00',45),(21,21,-1,2,'AA','ABY',12,'e',20,'9999-12-31 00:00:00',45),(22,22,-1,2,'AA','ABY',12,'b',20,'9999-12-31 00:00:00',95),(23,23,-1,2,'AA','ABY',12,'b',20,'9999-12-31 00:00:00',95),(24,24,-1,2,'AA','ABY',12,'b',20,'9999-12-31 00:00:00',95),(25,25,-1,2,'AA','ABY',12,'f',20,'9999-12-31 00:00:00',120),(26,26,-1,2,'AA','ABY',12,'f',20,'9999-12-31 00:00:00',120),(27,27,-1,2,'AA','ABY',12,'f',20,'9999-12-31 00:00:00',120),(28,28,-1,4,'AA','ABY',14,'e',20,'9999-12-31 00:00:00',45),(29,29,-1,4,'AA','ABY',14,'e',20,'9999-12-31 00:00:00',45),(30,30,-1,4,'AA','ABY',14,'b',20,'9999-12-31 00:00:00',95),(31,31,-1,4,'AA','ABY',14,'b',20,'9999-12-31 00:00:00',95),(32,32,-1,4,'AA','ABY',14,'f',20,'9999-12-31 00:00:00',120),(33,33,-1,4,'AA','ABY',14,'f',20,'9999-12-31 00:00:00',120),(34,34,-1,16,'BA','JFK',6,'e',20,'9999-12-31 00:00:00',50),(35,35,-1,16,'BA','JFK',6,'e',20,'9999-12-31 00:00:00',50),(36,36,-1,16,'BA','JFK',6,'b',20,'9999-12-31 00:00:00',75),(37,37,-1,16,'BA','JFK',6,'b',20,'9999-12-31 00:00:00',75),(38,38,-1,16,'BA','JFK',6,'f',20,'9999-12-31 00:00:00',120),(39,39,-1,16,'BA','JFK',6,'f',20,'9999-12-31 00:00:00',120),(40,40,-1,15,'DL','EWR',18,'e',20,'9999-12-31 00:00:00',55),(41,41,-1,15,'DL','EWR',18,'b',20,'9999-12-31 00:00:00',75),(42,42,-1,15,'DL','EWR',18,'f',20,'9999-12-31 00:00:00',115),(43,43,6,13,'EY','CMI',21,'e',20,'2019-12-11 00:00:00',60),(44,44,-1,13,'EY','CMI',21,'b',20,'9999-12-31 00:00:00',80),(45,45,-1,13,'EY','CMI',21,'f',20,'9999-12-31 00:00:00',140),(46,46,-1,17,'EY','CMI',18,'e',20,'9999-12-31 00:00:00',95),(47,47,-1,17,'EY','CMI',18,'b',20,'9999-12-31 00:00:00',170),(48,48,-1,17,'EY','CMI',18,'f',20,'9999-12-31 00:00:00',270),(49,49,-1,7,'UA','ALB',21,'e',20,'9999-12-31 00:00:00',95),(50,50,-1,7,'UA','ALB',21,'b',20,'9999-12-31 00:00:00',120),(51,51,-1,7,'UA','ALB',21,'f',20,'9999-12-31 00:00:00',170),(52,52,-1,19,'UA','ALB',37,'e',20,'9999-12-31 00:00:00',95),(53,53,-1,19,'UA','ALB',37,'b',20,'9999-12-31 00:00:00',120),(54,54,-1,19,'UA','ALB',37,'f',20,'9999-12-31 00:00:00',170),(55,55,-1,8,'UA','EWR',41,'e',20,'9999-12-31 00:00:00',120),(56,56,-1,8,'UA','EWR',41,'b',20,'9999-12-31 00:00:00',170),(57,57,-1,8,'UA','EWR',41,'f',20,'9999-12-31 00:00:00',220),(58,58,-1,9,'UA','EWR',42,'e',20,'9999-12-31 00:00:00',120),(59,59,-1,9,'UA','EWR',42,'b',20,'9999-12-31 00:00:00',170),(60,60,-1,9,'UA','EWR',42,'f',20,'9999-12-31 00:00:00',220),(61,61,-1,10,'UA','EWR',43,'e',20,'9999-12-31 00:00:00',95),(62,62,-1,10,'UA','EWR',43,'b',20,'9999-12-31 00:00:00',170),(63,63,-1,10,'UA','EWR',43,'f',20,'9999-12-31 00:00:00',270);
/*!40000 ALTER TABLE `Tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Waitlist`
--

DROP TABLE IF EXISTS `Waitlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Waitlist` (
  `aircraft_id` int(11) DEFAULT NULL,
  `airline_id` varchar(2) NOT NULL,
  `airport_id` varchar(3) DEFAULT NULL,
  `flight_number` int(11) NOT NULL,
  `account_num` int(11) NOT NULL,
  PRIMARY KEY (`flight_number`,`airline_id`,`account_num`),
  KEY `account_num` (`account_num`),
  KEY `airline_id` (`airline_id`,`airport_id`,`aircraft_id`,`flight_number`),
  CONSTRAINT `Waitlist_ibfk_1` FOREIGN KEY (`account_num`) REFERENCES `Person` (`account_num`),
  CONSTRAINT `Waitlist_ibfk_2` FOREIGN KEY (`airline_id`, `airport_id`, `aircraft_id`, `flight_number`) REFERENCES `Flight_Operates` (`airline_id`, `airport_id`, `aircraft_id`, `flight_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Waitlist`
--

LOCK TABLES `Waitlist` WRITE;
/*!40000 ALTER TABLE `Waitlist` DISABLE KEYS */;
INSERT INTO `Waitlist` VALUES (NULL,'EY',NULL,21,6);
/*!40000 ALTER TABLE `Waitlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-11 20:20:20
