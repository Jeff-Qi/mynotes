-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: localhost    Database: db_design
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `db_design`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db_design` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `db_design`;

--
-- Temporary view structure for view `first_view`
--

DROP TABLE IF EXISTS `first_view`;
/*!50001 DROP VIEW IF EXISTS `first_view`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `first_view` AS SELECT 
 1 AS `JNO`,
 1 AS `CITY`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `j`
--

DROP TABLE IF EXISTS `j`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `j` (
  `JNO` varchar(10) NOT NULL,
  `JNAME` varchar(20) DEFAULT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`JNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `j`
--

LOCK TABLES `j` WRITE;
/*!40000 ALTER TABLE `j` DISABLE KEYS */;
INSERT INTO `j` VALUES ('J1','三建','北京'),('J2','一汽','长春'),('J3','弹簧厂','天津'),('J4','造船厂','天津'),('J5','机车厂','唐山'),('J6','无线电厂','常州'),('J7','半导体厂','南京'),('J8','发动机','重庆');
/*!40000 ALTER TABLE `j` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `p`
--

DROP TABLE IF EXISTS `p`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `p` (
  `PNO` varchar(10) NOT NULL,
  `PNAME` varchar(20) DEFAULT NULL,
  `COLOR` varchar(10) DEFAULT NULL,
  `WEIGHT` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`PNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `p`
--

LOCK TABLES `p` WRITE;
/*!40000 ALTER TABLE `p` DISABLE KEYS */;
INSERT INTO `p` VALUES ('p1','螺母','红',12),('P2','螺栓','绿',17),('P3','螺丝刀','蓝',14),('P4','螺丝刀','红',14),('P5','凸轮','蓝',40),('P6','齿轮','红',30);
/*!40000 ALTER TABLE `p` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `s`
--

DROP TABLE IF EXISTS `s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `s` (
  `SNO` varchar(10) NOT NULL,
  `SNAME` varchar(20) DEFAULT NULL,
  `STATUS` tinyint(3) DEFAULT NULL,
  `CITY` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`SNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `s`
--

LOCK TABLES `s` WRITE;
/*!40000 ALTER TABLE `s` DISABLE KEYS */;
INSERT INTO `s` VALUES ('S1','精益',20,'天津'),('S2','盛锡',10,'北京'),('S3','东方红',30,'北京'),('S4','丰泰盛',20,'天津'),('S5','为国',30,'上海');
/*!40000 ALTER TABLE `s` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spj`
--

DROP TABLE IF EXISTS `spj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `spj` (
  `SNO` varchar(10) NOT NULL,
  `PNO` varchar(10) NOT NULL,
  `JNO` varchar(10) NOT NULL,
  `QTY` smallint(4) DEFAULT NULL,
  KEY `spj_ibfk_2` (`PNO`),
  KEY `spj_ibfk_3` (`JNO`),
  KEY `haha` (`SNO`,`JNO`,`QTY`),
  KEY `yohuo` ((upper(`SNO`))),
  CONSTRAINT `spj_ibfk_1` FOREIGN KEY (`SNO`) REFERENCES `s` (`sno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `spj_ibfk_2` FOREIGN KEY (`PNO`) REFERENCES `p` (`pno`),
  CONSTRAINT `spj_ibfk_3` FOREIGN KEY (`JNO`) REFERENCES `j` (`jno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spj`
--

LOCK TABLES `spj` WRITE;
/*!40000 ALTER TABLE `spj` DISABLE KEYS */;
INSERT INTO `spj` VALUES ('S1','P1','J3',100),('S1','P1','J4',700),('S1','P2','J2',100),('S2','P3','J1',400),('S2','P3','J2',200),('S2','P3','J4',500),('S2','P3','J5',400),('S2','P5','J1',400),('S2','P5','J2',100),('S3','P1','J1',200),('S3','P3','J1',200),('S4','P5','J1',100),('S4','P6','J3',300),('S4','P6','J4',200),('S5','P2','J4',100),('S5','P3','J1',200),('S5','P6','J2',200),('S5','P6','J4',500);
/*!40000 ALTER TABLE `spj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `ss`
--

DROP TABLE IF EXISTS `ss`;
/*!50001 DROP VIEW IF EXISTS `ss`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `ss` AS SELECT 
 1 AS `SNO`,
 1 AS `SNAME`,
 1 AS `STATUS`,
 1 AS `CITY`*/;
SET character_set_client = @saved_cs_client;

--
-- Current Database: `db_design`
--

USE `db_design`;

--
-- Final view structure for view `first_view`
--

/*!50001 DROP VIEW IF EXISTS `first_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `first_view` AS select `j`.`JNO` AS `JNO`,`j`.`CITY` AS `CITY` from `j` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ss`
--

/*!50001 DROP VIEW IF EXISTS `ss`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `ss` AS select `s`.`SNO` AS `SNO`,`s`.`SNAME` AS `SNAME`,`s`.`STATUS` AS `STATUS`,`s`.`CITY` AS `CITY` from `s` where (`s`.`CITY` = '上海') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-01 14:33:12
