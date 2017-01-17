CREATE DATABASE  IF NOT EXISTS `onlinetest` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `onlinetest`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: cqspc001    Database: onlinetest
-- ------------------------------------------------------
-- Server version	5.6.17

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
-- Table structure for table `amount_balance`
--

DROP TABLE IF EXISTS `amount_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amount_balance` (
  `amount_balance_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) DEFAULT NULL,
  `balance` decimal(12,4) DEFAULT NULL,
  PRIMARY KEY (`amount_balance_id`),
  KEY `amount_balance_fk_idx` (`employee_id`),
  CONSTRAINT `amount_balance_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amount_balance`
--

LOCK TABLES `amount_balance` WRITE;
/*!40000 ALTER TABLE `amount_balance` DISABLE KEYS */;
INSERT INTO `amount_balance` VALUES (1,1,68345.0000),(2,2,189303.0000),(3,3,44003.0000),(4,4,110000.0000),(5,5,115000.0000),(6,6,112000.0000),(7,7,110000.0000);
/*!40000 ALTER TABLE `amount_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answer`
--

DROP TABLE IF EXISTS `answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer` (
  `answer_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL,
  `selected_option` varchar(20) NOT NULL,
  `online_test_user_id` bigint(20) NOT NULL,
  `created_datetime` date NOT NULL,
  PRIMARY KEY (`answer_id`),
  KEY `answer_question_id` (`question_id`),
  KEY `ot_online_test_user_answer_fk_idx` (`online_test_user_id`),
  CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer`
--

LOCK TABLES `answer` WRITE;
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `answer` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `onlinetest`.`answer_AFTER_INSERT` AFTER INSERT ON `answer` FOR EACH ROW
	BEGIN
        CREATE TEMPORARY TABLE IF NOT EXISTS table1 AS (
			SELECT a.option_id, a.question_id, a.is_correct, a.answer_id, a.user_correct, q.is_multiple_option FROM 
            ( 
				select qo.option_id, qo.question_id, qo.is_correct, IFNULL(op.answer_id,0) answer_id,
                CASE WHEN op.answer_id IS NULL THEN 0 ELSE 1 END user_correct
				from questionoption qo
				left join 
					(select answer.answer_id,answer.question_id,
						SUBSTRING_INDEX(SUBSTRING_INDEX(answer.selected_option, ',', numbers.n), ',', -1) option_id
						from numbers inner join answer
						on CHAR_LENGTH(answer.selected_option)
							-CHAR_LENGTH(REPLACE(answer.selected_option, ',', ''))>=numbers.n-1
						order by answer.answer_id,answer.question_id,n
					) op 
						on qo.option_id = op.option_id and op.answer_id = new.answer_id
						where qo.question_id = new.question_id
			) a
              join question q ON a.question_id = q.question_id);
                
		SET @correctAns:= (select COUNT(question_id) from table1 where is_correct = 1);
		SET @userSelectedAns:= (select COUNT(question_id) from table1 where user_correct = 1);
		SET @userCorrectAns:= (select COUNT(question_id) from table1 where user_correct = 1 AND is_correct = 1);
		SET @userInCorrectAns:= (select COUNT(question_id) from table1 where user_correct = 1 AND is_correct = 0);

		SET @score:= (SELECT DISTINCT
			(CASE WHEN is_multiple_option = 1 THEN
				(CASE WHEN @correctAns < @userSelectedAns THEN -((1/@correctAns)*@userInCorrectAns)
				ELSE ((1/@correctAns)*@userCorrectAns)-((1/@correctAns)*@userInCorrectAns) END)
			ELSE 
				@userCorrectAns END) score
			FROM table1);
		
        SET @isCorrectAns = (SELECT CASE WHEN @score = 1 THEN 1 ELSE 0 end);
        
        DROP TEMPORARY TABLE table1;
            
		INSERT INTO userscore (answer_id, score, is_correct_answer) values (new.answer_id, @score, @isCorrectAns);
        
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `businesspartnermaster`
--

DROP TABLE IF EXISTS `businesspartnermaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `businesspartnermaster` (
  `businesspartnermaster_id` int(11) NOT NULL AUTO_INCREMENT,
  `businesspartnermastertype` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `foreign_name` varchar(100) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `currency` int(11) DEFAULT NULL,
  `federal_tax_id` varchar(100) DEFAULT NULL,
  `currency_type` int(11) DEFAULT NULL,
  `account_balance` decimal(18,2) DEFAULT NULL,
  `deliveries` varchar(100) DEFAULT NULL,
  `orders` varchar(100) DEFAULT NULL,
  `opportunities` int(11) DEFAULT NULL,
  PRIMARY KEY (`businesspartnermaster_id`),
  KEY `businesspartnermaster_group_fk_idx` (`group_id`),
  CONSTRAINT `businesspartnermaster_group_fk` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businesspartnermaster`
--

LOCK TABLES `businesspartnermaster` WRITE;
/*!40000 ALTER TABLE `businesspartnermaster` DISABLE KEYS */;
INSERT INTO `businesspartnermaster` VALUES (2,2,'abc','abcdef',2,2,'wq1212132',2,212.12,'2222323','22333',5),(4,1,'Partner Technology','Not Define',2,1,'as1212a',1,100000.00,'12312312','33422',2),(11,2,'xxxxxxxxxx','xxxxxxxxx',1,2,'223qs',1,2222333.00,'2332','232313',3),(12,2,'option','option',2,2,'sdsasdsa',2,334324.00,'212434','21321',1232143),(13,2,'option','option',2,2,'sdsasdsa',2,334324.00,'212434','21321',1232143),(14,2,'option','option',2,2,'sdsasdsa',2,334324.00,'212434','21321',1232143),(15,2,'option','option',2,2,'sdsasdsa',2,334324.00,'212434','21321',1232143),(17,1,'ashish','ashish',2,2,'asd',1,2.00,'213','123',2),(19,2,'option','option',2,2,'sdsasdsa',2,334324.00,'212434','21321',1232143),(20,2,'option','option',2,2,'sdsasdsa',2,334324.00,'212434','21321',1232143);
/*!40000 ALTER TABLE `businesspartnermaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city` (
  `city_id` int(11) NOT NULL AUTO_INCREMENT,
  `state_id` int(11) DEFAULT NULL,
  `city_name` varchar(100) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`city_id`),
  KEY `city_state_fk_idx` (`state_id`),
  CONSTRAINT `city_state_fk` FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES (1,2,'Noida',1),(2,2,'Saharanpur',1),(3,2,'Hapur',1),(4,3,'Haridwar',1),(5,3,'Dehradun',1),(6,4,'Colombo',1),(7,4,'aaaaaaaaaaaaaaa',0),(14,3,'Good',1);
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `company_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_title` varchar(100) NOT NULL,
  `company_url` varchar(50) NOT NULL,
  `company_address` varchar(200) DEFAULT NULL,
  `company_phone` varchar(40) DEFAULT NULL,
  `company_email` varchar(100) NOT NULL,
  `company_hr_phone` varchar(40) NOT NULL,
  `company_hr_emailid` varchar(100) NOT NULL,
  `smtp_host` varchar(45) NOT NULL DEFAULT '',
  `smtp_port` int(11) NOT NULL DEFAULT '0',
  `smtp_username` varchar(45) NOT NULL DEFAULT '',
  `smtp_password` varchar(45) NOT NULL DEFAULT '',
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'ConQsys Test','conqsystest.onlinetest.com','Noida','1234567899','asd@asd.com','3216549876','asd@asd.com','smtp.gmail.com',465,'amit.kumar@conqsys.com','Amit@654','rkm','4','2016-01-19 03:14:07','2016-10-28 09:11:35'),(2,'sample1rkm','','noida','14253985','','74589652','d@d.com','',0,'','','rkm1','MITTAL','2016-01-19 03:14:07','2016-08-12 20:41:55'),(3,'sample1wewe','xyz@.com','noida','14253985','','74589652','d@d.com','',0,'','','MITTAL','4','2016-08-12 20:31:21','2016-10-25 13:26:16'),(4,'sample','','ds','ad','','sad','sad','',0,'','','rkm','rkm','2016-08-17 03:34:29','2016-08-17 03:34:29'),(5,'sample','','ds','ad','','sad','sad','',0,'','','rkm','rkm','2016-08-17 03:35:41','2016-08-17 03:35:41'),(6,'company1','conqsys.com','dsad','sad','asd','sad','sadf','',0,'','','rkm','rkm','2016-08-17 05:53:09','2016-09-20 11:25:33'),(13,'company123','','dwd','sad','','sad','sadf','',0,'','','rkm','rkm','2016-08-17 06:17:59','2016-08-17 06:17:59'),(14,'condfs','sdfsf','dfs','1231','undefined','121231','hare@gmail.com','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-13 16:18:52','2016-09-13 16:18:52'),(15,'dsf','dfsgs','sdf','45654','undefined','dfgdfg','445','',0,'','','undefined','undefined','2016-09-13 16:22:22','2016-09-13 16:22:22'),(16,'sdfsdfsdsff','sdf','sf','sdf','undefined','sdf','sdf','',0,'','','undefined','undefined','2016-09-13 16:22:55','2016-09-19 13:33:25'),(17,'ertret','ererterwt','ert','ererter','undefined','ertrew','erterwt','',0,'','','undefined','undefined','2016-09-13 16:25:04','2016-09-13 16:25:04'),(18,'sdf','sdf','sdf','sdf','undefined','sdf','sdf','',0,'','','undefined','undefined','2016-09-13 16:26:19','2016-09-13 16:26:19'),(19,'fdsf','dsf','sdf','dsfsd','dfs','df','undefindfsed','',0,'','','undefined','undefined','2016-09-13 16:41:39','2016-09-13 21:22:58'),(20,'Conqsys','www.conqsys.com','A 161','2123','contact@conqsys.com','123321','hr@conqsys.com','',0,'','','undefined','undefined','2016-09-13 16:42:42','2016-09-13 16:42:42'),(21,'sdf','sdf','sdf','sdf','dsf','sdf','sdfdsf','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-13 16:46:14','2016-09-13 16:46:14'),(22,'harry','haryy.com','32123','011','harry@gmail.com','12231','1231','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-13 21:14:15','2016-09-13 21:18:16'),(23,'asdasdas','vip',' asdasdasda','dasddasdas','vipinchauhan','adassadasdsd','asdadasda','',0,'','','Harendra Maurya','Harendra Maurya','2016-09-16 18:08:20','2016-09-19 13:35:06'),(24,'abc','asdsad','abc','2122121212','sads','sdda','dsad','ssas',221121,'sdasda','sasad','Harendra Maurya','Harendra Maurya','2016-09-20 22:46:00','2016-09-20 22:46:00');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companyuser`
--

DROP TABLE IF EXISTS `companyuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companyuser` (
  `company_user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`company_user_id`),
  KEY `company_id` (`company_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `companyuser_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`),
  CONSTRAINT `companyuser_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companyuser`
--

LOCK TABLES `companyuser` WRITE;
/*!40000 ALTER TABLE `companyuser` DISABLE KEYS */;
INSERT INTO `companyuser` VALUES (3,13,1),(7,1,2),(9,1,4),(10,1,5),(11,1,6),(12,1,7),(13,1,8),(14,1,9),(15,1,10),(16,1,11),(17,1,12),(18,1,13);
/*!40000 ALTER TABLE `companyuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact` (
  `contactid` int(11) NOT NULL AUTO_INCREMENT,
  `contact_name` varchar(45) NOT NULL,
  `mobile_no` varchar(45) NOT NULL,
  `customer_id` int(11) NOT NULL,
  PRIMARY KEY (`contactid`),
  KEY `contact_customer_fk_idx` (`customer_id`),
  CONSTRAINT `contact_customer_fk` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES (1,'sd','788787',1),(2,'ds','786656',1);
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract` (
  `contractid` int(11) NOT NULL AUTO_INCREMENT,
  `contactid` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `contractno` varchar(45) DEFAULT NULL,
  `startdate` date DEFAULT NULL,
  `enddate` date DEFAULT NULL,
  `terminationdate` date DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`contractid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract`
--

LOCK TABLES `contract` WRITE;
/*!40000 ALTER TABLE `contract` DISABLE KEYS */;
INSERT INTO `contract` VALUES (1,2,3,'qes','2016-11-23','2016-11-02','2016-11-28','asdasd'),(2,2,1,'21','2016-11-09','2016-11-17','2016-11-18','asdasd'),(3,2,1,'12','2016-11-02','2016-11-02','2016-11-25','asd'),(4,1,1,'12132','2016-11-02','2016-11-03','2016-11-23','dsdsdf'),(5,2,2,'23','2016-11-24','2016-11-03','2016-11-23','asd'),(6,2,2,'23','2016-11-24','2016-11-03','2016-11-23','asd'),(7,2,2,'23','2016-11-24','2016-11-03','2016-11-23','asd'),(8,2,2,'23','2016-11-24','2016-11-03','2016-11-23','asd'),(9,2,2,'23','2016-11-24','2016-11-03','2016-11-23','asd');
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `country_id` int(11) NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) NOT NULL,
  `country_code` varchar(45) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'India','+91',1),(2,'Australia','+61',1),(3,'New Zealand','+64',0),(4,'Sri Lanka','+94',0),(8,'Russia','+65',1);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_code` varchar(45) DEFAULT NULL,
  `customer_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'cqs01','shashi'),(2,'cqs02','hemant'),(3,'cqs03','shashank'),(4,'cqs04','ankit');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `mobile` varchar(100) DEFAULT NULL,
  `gender` tinyint(4) DEFAULT NULL,
  `pancard_no` varchar(100) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Vipin','vip.chauhan@gmail.com','7210362050',1,'CMZPK8150L',1,3,4),(2,'Shashi','thetiwari.tiwari@gmail.com','9876543210',1,'asdsad078h',1,1,1),(3,'Ashish','a@a.com','7890654432',1,'qeqwe123',1,3,4),(4,'Hemant','hemant@2.com','1234567890',1,'AJZZ2344L',1,1,1),(5,'Deepa','deepak@12.com','9876543210',0,'sddsdsdsa',4,4,6),(6,'Suchita','sachin@11.com','9877655456',0,'xzccczccz',1,2,2),(7,'Amrita','amit@a.com','8629842113',0,'zczxczcxc',1,2,2);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employeerecord`
--

DROP TABLE IF EXISTS `employeerecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employeerecord` (
  `employee_id` int(11) NOT NULL,
  `qualification_id` int(11) NOT NULL,
  `employeerecord_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`employeerecord_id`),
  KEY `employeerecord_qualification_fk_idx` (`qualification_id`),
  KEY `employeerecord_employee_fk_idx` (`employee_id`),
  CONSTRAINT `employeerecord_employee_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `employeerecord_qualification_fk` FOREIGN KEY (`qualification_id`) REFERENCES `qualification` (`qualification_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employeerecord`
--

LOCK TABLES `employeerecord` WRITE;
/*!40000 ALTER TABLE `employeerecord` DISABLE KEYS */;
INSERT INTO `employeerecord` VALUES (1,1,117),(1,5,118),(1,7,119),(1,8,120),(2,3,121),(2,7,122),(2,8,123);
/*!40000 ALTER TABLE `employeerecord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employeetransaction`
--

DROP TABLE IF EXISTS `employeetransaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employeetransaction` (
  `employee_transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `amount` decimal(12,4) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`employee_transaction_id`),
  KEY `employee_transaction_fk_idx` (`employee_id`),
  CONSTRAINT `employee_transaction_fk` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employeetransaction`
--

LOCK TABLES `employeetransaction` WRITE;
/*!40000 ALTER TABLE `employeetransaction` DISABLE KEYS */;
INSERT INTO `employeetransaction` VALUES (4,2,1,50000.0000,'2016-10-24'),(5,1,5,35000.0000,'2016-11-24'),(8,1,5,5000.0000,'2016-10-24'),(9,1,5,5000.0000,'2016-11-24'),(12,1,2,2.0000,'2016-10-26'),(13,2,2,24001.0000,'2016-07-23'),(14,2,3,60000.0000,'2016-11-26'),(15,2,3,6000.0000,'2016-11-24'),(17,2,1,65656.0000,'2016-11-24'),(19,1,2,1.0000,'2016-11-01'),(21,1,1,1.0000,'2016-11-02');
/*!40000 ALTER TABLE `employeetransaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `general`
--

DROP TABLE IF EXISTS `general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `general` (
  `general_id` int(11) NOT NULL AUTO_INCREMENT,
  `telephone` varchar(100) DEFAULT NULL,
  `connect_person` varchar(100) DEFAULT NULL,
  `mobile_phone` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `web_site` varchar(100) DEFAULT NULL,
  `shipping_id` int(11) DEFAULT NULL,
  `sales_employee_id` int(11) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `bp_project` varchar(100) DEFAULT NULL,
  `bp_channel_code` varchar(100) DEFAULT NULL,
  `industry_id` int(11) DEFAULT NULL,
  `technician` varchar(100) DEFAULT NULL,
  `alias_name` varchar(100) DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `user_remark` varchar(100) DEFAULT NULL,
  `send_marketing_content` tinyint(4) DEFAULT NULL,
  `active` tinyint(4) DEFAULT NULL,
  `inactive` tinyint(4) DEFAULT NULL,
  `advance` tinyint(4) DEFAULT NULL,
  `to` varchar(100) DEFAULT NULL,
  `from` varchar(100) DEFAULT NULL,
  `businesspartnermaster_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`general_id`),
  KEY `businesspartnermaster_general_fk_idx` (`businesspartnermaster_id`),
  CONSTRAINT `businesspartnermaster_general_fk` FOREIGN KEY (`businesspartnermaster_id`) REFERENCES `businesspartnermaster` (`businesspartnermaster_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general`
--

LOCK TABLES `general` WRITE;
/*!40000 ALTER TABLE `general` DISABLE KEYS */;
INSERT INTO `general` VALUES (4,'0231321','abc','02312231','xxsd@a.com','sdasss','xa@as.com',2,1,'','sadas','dsds',1,'zxxxz','xxxx',1,'',1,1,0,1,'','',11),(5,'+9199999999','dsfffdsdfsd','0980899051','sdsad@s.com','sdasdaa','as@as.com',3,3,'dsaaaaad','dadss','dasdas',3,'option','option',3,'',1,0,1,0,'','',15),(7,'021331231','21321213','0wewq','21@s.com','qdssa','sds@a.com',3,1,'sadsad','sdsa','ddsa',1,'sad','sadas',0,'',1,1,0,0,'','',17);
/*!40000 ALTER TABLE `general` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES (1,'High Tech'),(2,'Low Tech');
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventry`
--

DROP TABLE IF EXISTS `inventry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventry` (
  `inventry_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `mobile_no` varchar(100) DEFAULT NULL,
  `tin_no` varchar(100) DEFAULT NULL,
  `total` decimal(9,3) DEFAULT NULL,
  PRIMARY KEY (`inventry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventry`
--

LOCK TABLES `inventry` WRITE;
/*!40000 ALTER TABLE `inventry` DISABLE KEYS */;
INSERT INTO `inventry` VALUES (12,1,'Rohit','Hapur','+91-9654370936','78787',550.000),(19,2,'vipin','haridwar','+91-7210362050','vip1212',22000.000),(20,2,'sdas','dsad','sadas','dssad',3750.000),(21,1,'hemant','kanpur','3432424234','sadas',3900.000),(22,2,'dsadas','dsad','dasdadsadd','dsadas',6225.000);
/*!40000 ALTER TABLE `inventry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventry_details`
--

DROP TABLE IF EXISTS `inventry_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventry_details` (
  `inventry_detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `inventry_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_rate` decimal(9,3) DEFAULT NULL,
  `quantity` decimal(9,3) DEFAULT NULL,
  `sub_total` decimal(9,3) DEFAULT NULL,
  PRIMARY KEY (`inventry_detail_id`),
  KEY `inventry_details_inventry_fk_idx` (`inventry_id`),
  CONSTRAINT `inventry_details_inventry_fk` FOREIGN KEY (`inventry_id`) REFERENCES `inventry` (`inventry_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventry_details`
--

LOCK TABLES `inventry_details` WRITE;
/*!40000 ALTER TABLE `inventry_details` DISABLE KEYS */;
INSERT INTO `inventry_details` VALUES (15,12,1,275.000,2.000,550.000),(16,19,3,700.000,10.000,7000.000),(17,19,2,1250.000,12.000,15000.000),(18,21,2,1250.000,2.000,2500.000),(19,21,3,700.000,2.000,1400.000),(20,22,1,275.000,3.000,825.000),(21,22,3,700.000,3.000,2100.000),(22,22,2,1250.000,12.000,3300.000);
/*!40000 ALTER TABLE `inventry_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_stock`
--

DROP TABLE IF EXISTS `item_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_stock` (
  `item_stock_id` int(11) NOT NULL AUTO_INCREMENT,
  `items_id` int(11) DEFAULT NULL,
  `stock` decimal(9,3) DEFAULT NULL,
  PRIMARY KEY (`item_stock_id`),
  KEY `items_itemstock_fk_idx` (`items_id`),
  CONSTRAINT `items_itemstock_fk` FOREIGN KEY (`items_id`) REFERENCES `items` (`items_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_stock`
--

LOCK TABLES `item_stock` WRITE;
/*!40000 ALTER TABLE `item_stock` DISABLE KEYS */;
INSERT INTO `item_stock` VALUES (1,1,203.000),(2,2,310.000),(3,3,411.000),(4,4,200.000);
/*!40000 ALTER TABLE `item_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `items` (
  `items_id` int(11) NOT NULL AUTO_INCREMENT,
  `item` varchar(45) DEFAULT NULL,
  `item_rate` decimal(9,4) DEFAULT NULL,
  PRIMARY KEY (`items_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,'platinum',275.0000),(2,'gold',1250.0000),(3,'silver',700.0000),(4,'dimond',1500.0000);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numbers`
--

DROP TABLE IF EXISTS `numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `numbers` (
  `n` int(11) NOT NULL,
  PRIMARY KEY (`n`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `numbers`
--

LOCK TABLES `numbers` WRITE;
/*!40000 ALTER TABLE `numbers` DISABLE KEYS */;
INSERT INTO `numbers` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9);
/*!40000 ALTER TABLE `numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlinetest`
--

DROP TABLE IF EXISTS `onlinetest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `onlinetest` (
  `online_test_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) NOT NULL,
  `online_test_title` varchar(200) NOT NULL,
  `test_start_date` datetime NOT NULL,
  `test_end_date` datetime NOT NULL,
  `question_set_id` bigint(20) NOT NULL,
  `test_support_text` text NOT NULL,
  `test_experience_years` int(11) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`online_test_id`),
  KEY `company_id` (`company_id`),
  KEY `question_set_id` (`question_set_id`),
  CONSTRAINT `onlinetest_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`),
  CONSTRAINT `onlinetest_ibfk_2` FOREIGN KEY (`question_set_id`) REFERENCES `questionset` (`question_set_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlinetest`
--

LOCK TABLES `onlinetest` WRITE;
/*!40000 ALTER TABLE `onlinetest` DISABLE KEYS */;
INSERT INTO `onlinetest` VALUES (2,1,'fresher ','2016-10-15 10:00:00','2016-10-28 20:00:00',1,'abc',3,'Vipin ','4','2016-09-19 17:44:13','2016-10-25 10:48:05'),(4,1,'exprience','2016-10-10 00:00:00','2016-10-10 00:00:00',1,'it is hard test',2,'Vipin','Vipin','2016-09-19 19:33:25','2016-09-19 19:33:25'),(5,1,'exprience','2016-10-01 00:00:00','2016-10-01 00:00:00',2,'superab',3,'Vipin','Vipin','2016-09-19 20:48:45','2016-09-19 20:48:45'),(6,1,'fresher','2016-08-16 00:00:00','2016-08-17 00:00:00',3,'cccccccccccc',0,'Vipin','4','2016-09-20 15:13:30','2016-11-02 09:29:34');
/*!40000 ALTER TABLE `onlinetest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlinetestuser`
--

DROP TABLE IF EXISTS `onlinetestuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `onlinetestuser` (
  `online_test_user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `online_test_id` bigint(20) NOT NULL,
  `test_completed_date` datetime DEFAULT NULL,
  `test_start_date_time` datetime DEFAULT NULL,
  `test_end_date_time` datetime DEFAULT NULL,
  `is_abandoned` tinyint(1) NOT NULL,
  `is_completed` tinyint(1) NOT NULL,
  PRIMARY KEY (`online_test_user_id`),
  KEY `user_id` (`user_id`),
  KEY `online_test_id` (`online_test_id`),
  CONSTRAINT `onlinetestuser_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `onlinetestuser_ibfk_2` FOREIGN KEY (`online_test_id`) REFERENCES `onlinetest` (`online_test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlinetestuser`
--

LOCK TABLES `onlinetestuser` WRITE;
/*!40000 ALTER TABLE `onlinetestuser` DISABLE KEYS */;
INSERT INTO `onlinetestuser` VALUES (1,10,2,NULL,NULL,NULL,0,0),(2,10,4,NULL,NULL,NULL,0,0);
/*!40000 ALTER TABLE `onlinetestuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `optionseries`
--

DROP TABLE IF EXISTS `optionseries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optionseries` (
  `option_series_id` bigint(20) NOT NULL,
  `option_series_name` varchar(45) NOT NULL,
  PRIMARY KEY (`option_series_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optionseries`
--

LOCK TABLES `optionseries` WRITE;
/*!40000 ALTER TABLE `optionseries` DISABLE KEYS */;
INSERT INTO `optionseries` VALUES (1,'Alphabetical Order'),(2,'Numerical Order');
/*!40000 ALTER TABLE `optionseries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) DEFAULT NULL,
  `product_code` varchar(100) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_rate` decimal(9,4) DEFAULT NULL,
  `quantity` decimal(9,3) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product_itme_fk_idx` (`item_id`),
  CONSTRAINT `product_itme_fk` FOREIGN KEY (`item_id`) REFERENCES `items` (`items_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'product gold','001a',2,12500.0000,2.000),(2,'product silver','022ab',3,70000.0000,2.000);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase`
--

DROP TABLE IF EXISTS `purchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchase` (
  `purchase_id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` decimal(9,6) DEFAULT NULL,
  `unit_price` decimal(9,6) DEFAULT NULL,
  `total` decimal(9,6) DEFAULT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `item` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`purchase_id`),
  KEY `vendor_id_idx` (`vendor_id`),
  CONSTRAINT `vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`vendor_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase`
--

LOCK TABLES `purchase` WRITE;
/*!40000 ALTER TABLE `purchase` DISABLE KEYS */;
INSERT INTO `purchase` VALUES (5,333.000000,32.000000,67.000000,14,'dfgdf'),(6,22.000000,33.000000,54.000000,14,'sdfsdf'),(7,3.000000,3.000000,9.000000,19,'asd'),(8,4.000000,4.000000,16.000000,19,'asd'),(11,4.000000,4.000000,16.000000,21,'asd'),(12,34.000000,34.000000,9.000000,21,'asd');
/*!40000 ALTER TABLE `purchase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qualification`
--

DROP TABLE IF EXISTS `qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qualification` (
  `qualification_id` int(11) NOT NULL AUTO_INCREMENT,
  `qualification_name` varchar(100) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`qualification_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qualification`
--

LOCK TABLES `qualification` WRITE;
/*!40000 ALTER TABLE `qualification` DISABLE KEYS */;
INSERT INTO `qualification` VALUES (1,'MCA',1),(2,'MBA',0),(3,'BTECH',1),(4,'BBA',0),(5,'BCA',1),(6,'BSc',1),(7,'10th',1),(8,'12th',1);
/*!40000 ALTER TABLE `qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question` (
  `question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_description` longtext NOT NULL,
  `topic_id` bigint(20) NOT NULL,
  `is_multiple_option` tinyint(1) NOT NULL,
  `answer_explanation` longtext,
  `company_id` bigint(20) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `question_topic_id` (`topic_id`),
  KEY `question_company_fk_idx` (`company_id`),
  CONSTRAINT `question_company_fk` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (1,'<p><br></p><p>Meera is older than Eric. Cliff is older than Tanya. Eric is older than Cliff. If the first two statements are true, the third statement is</p>',11,1,'Because the first two statements are true, Eric is the youngest of the three, so the third statement must be false.',1,'admin','4','2016-09-07 20:14:07','2016-11-16 14:30:33'),(2,'<p><img class=\"fr-dib fr-draggable fr-fil\" src=\"https://i.ytimg.com/vi/AnnsFB_iY-A/maxresdefault.jpg\" style=\"width: 300px;\">question line 1</p><p><br></p><p>asdjasjdlkjasd</p><p><br></p>',8,0,'no explanation required for this',1,'admin','admin','2016-09-13 20:08:36','2016-09-22 17:55:31'),(3,'<p>amit dkjahkjhkjhk</p>',3,1,'sdjkahksdasldkhlksaldkhalskd ',1,'admin','admin','2016-09-15 12:35:46','2016-09-19 22:00:33'),(6,'<p><span class=\"fr-emoticon fr-deletable fr-emoticon-img\" style=\"background: url(https://cdnjs.cloudflare.com/ajax/libs/emojione/2.0.1/assets/svg/1f611.svg);\">&nbsp;</span> new question admin<a href=\"http://google.com\">google</a></p>',2,1,'dasdas',1,'admin','admin','2016-09-16 20:30:26','2016-09-22 16:04:18'),(7,'<p>asdas</p>',2,1,'dasdas',1,'admin','admin','2016-09-16 21:04:09','2016-09-19 22:02:19'),(9,'<p>aaa</p>',3,0,'aaa',1,'admin','admin','2016-09-20 13:54:08','2016-09-22 17:56:57'),(10,'<p>xyz</p>',3,1,'xyz',1,'admin','admin','2016-09-20 13:55:45','2016-09-22 17:56:47');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionoption`
--

DROP TABLE IF EXISTS `questionoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionoption` (
  `option_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`option_id`),
  KEY `ot_question_option_fk_idx` (`question_id`),
  CONSTRAINT `ot_question_option_fk` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionoption`
--

LOCK TABLES `questionoption` WRITE;
/*!40000 ALTER TABLE `questionoption` DISABLE KEYS */;
INSERT INTO `questionoption` VALUES (1,'true',0,1),(2,'false',0,1),(3,'uncertain',1,1),(4,'no option',1,1),(5,'true',1,2),(6,'false',0,2),(7,'uncertain',0,2),(8,'option 1',1,3),(9,'optioin 2',0,3),(16,'asdasd',1,6),(17,'asdasd',1,7),(18,'asdasd',0,7),(22,'a',1,9),(23,'b',0,9),(24,'New Option',0,1);
/*!40000 ALTER TABLE `questionoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionset`
--

DROP TABLE IF EXISTS `questionset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionset` (
  `question_set_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_set_title` varchar(200) NOT NULL,
  `total_time` int(11) NOT NULL,
  `company_id` bigint(20) NOT NULL,
  `total_questions` int(11) NOT NULL,
  `is_randomize` tinyint(1) NOT NULL,
  `option_series_id` bigint(20) NOT NULL DEFAULT '1',
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`question_set_id`),
  KEY `company_id` (`company_id`),
  KEY `questionset_optionseries_fk_idx` (`option_series_id`),
  CONSTRAINT `questionset_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`),
  CONSTRAINT `questionset_optionseries_fk` FOREIGN KEY (`option_series_id`) REFERENCES `optionseries` (`option_series_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionset`
--

LOCK TABLES `questionset` WRITE;
/*!40000 ALTER TABLE `questionset` DISABLE KEYS */;
INSERT INTO `questionset` VALUES (1,'Set 1',50,1,100,1,1,'admin','4','2016-01-19 03:14:07','2016-10-21 06:57:41'),(2,'Set 2',2200,1,50,0,2,'admin','4','2016-09-13 22:51:03','2016-10-06 14:52:46'),(3,'Set 3',1000,1,20,1,1,'admin','4','2016-09-20 13:35:53','2016-10-06 14:53:09'),(4,'Permutation and combinatios',1200,1,12,1,1,'4','4','2016-09-26 16:53:03','2016-09-26 17:52:50'),(5,'',0,1,0,0,1,'4','4','2016-09-28 19:55:44','2016-09-28 19:55:44'),(6,'test_rkm',132300,1,3,0,1,'4','4','2016-10-14 12:01:42','2016-10-14 12:01:42'),(7,'Set 4',101200,1,20,1,1,'4','4','2016-10-14 16:29:23','2016-10-14 16:29:23'),(12,'Set 5',210900,1,10,1,2,'4','4','2016-10-14 16:41:21','2016-10-14 16:41:21'),(13,'set 6',100100,1,32,1,1,'4','4','2016-10-14 16:44:11','2016-10-14 16:44:11');
/*!40000 ALTER TABLE `questionset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionsetquestion`
--

DROP TABLE IF EXISTS `questionsetquestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionsetquestion` (
  `question_set_question_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_set_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`question_set_question_id`),
  KEY `question_set_id` (`question_set_id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `questionsetquestion_ibfk_1` FOREIGN KEY (`question_set_id`) REFERENCES `questionset` (`question_set_id`),
  CONSTRAINT `questionsetquestion_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionsetquestion`
--

LOCK TABLES `questionsetquestion` WRITE;
/*!40000 ALTER TABLE `questionsetquestion` DISABLE KEYS */;
INSERT INTO `questionsetquestion` VALUES (6,2,1),(8,1,6),(9,1,3),(12,1,2),(13,7,1),(14,7,3),(23,12,3),(24,13,2);
/*!40000 ALTER TABLE `questionsetquestion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quote`
--

DROP TABLE IF EXISTS `quote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quote` (
  `quoteid` int(11) NOT NULL AUTO_INCREMENT,
  `quote_no` varchar(45) DEFAULT NULL,
  `quote_description` varchar(45) DEFAULT NULL,
  `project_value` decimal(6,2) DEFAULT NULL,
  `budget_value` decimal(6,2) DEFAULT NULL,
  `material` decimal(6,2) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`quoteid`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote`
--

LOCK TABLES `quote` WRITE;
/*!40000 ALTER TABLE `quote` DISABLE KEYS */;
INSERT INTO `quote` VALUES (8,'47','sadf',343.00,345.00,345.00,1);
/*!40000 ALTER TABLE `quote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `role_id` bigint(20) NOT NULL,
  `role_name` varchar(45) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'SuperAdmin'),(2,'CompanyAdmin'),(3,'User');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `serviceid` int(11) NOT NULL AUTO_INCREMENT,
  `contractsaveid` int(11) DEFAULT NULL,
  `service_type` varchar(45) DEFAULT NULL,
  `contract_type` varchar(45) DEFAULT NULL,
  `template` varchar(45) DEFAULT NULL,
  `response_time` varchar(45) DEFAULT NULL,
  `resulation_time` varchar(45) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `owner` varchar(45) DEFAULT NULL,
  `renewal` tinyint(4) DEFAULT NULL,
  `reminder` varchar(45) DEFAULT NULL,
  `active_items` varchar(45) DEFAULT NULL,
  `remarks` varchar(45) DEFAULT NULL,
  `template_remarks` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serviceid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (2,2,'Gurranty','Serial Number','asd','asd','asdasdd','Pending','Shashi',0,'assd','12','not bad','good'),(3,2,'Replace','Warranty No.','asd','q','q','Approved','Shashi',0,'q','q2','not bad','good'),(5,2,'Gurranty','Warranty No.','asd','asd','asd','In Progress','Shashi',0,'asd','asd','not bad','good'),(6,4,'','','','','','','',1,'','','',''),(7,7,'Gurranty','Warranty No.','asd','asd','asd','Pending','Shashi',0,'asd','asd','not bad','good'),(8,8,'Gurranty','Warranty No.','asd','asd','asd','Pending','Shashi',0,'asd','asd','not bad','good'),(9,9,'Gurranty','Warranty No.','asd','asd','asd','Pending','Shashi',0,'asd','asd','not bad','good');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `state_id` int(11) NOT NULL AUTO_INCREMENT,
  `country_id` int(11) NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  PRIMARY KEY (`state_id`),
  KEY `state_country_fk_idx` (`country_id`),
  CONSTRAINT `state_country_fk` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES (1,1,'Delhi',0),(2,1,'Utter Pardesh',1),(3,1,'Uttarakhand',1),(4,4,' Kandy',1),(8,4,'sadsdsa',1),(12,3,'asdsadsa',1),(13,4,'Hapur',0);
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `topic_id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_title` varchar(45) DEFAULT NULL,
  `topic_date` varchar(45) DEFAULT NULL,
  `topic_description` varchar(45) DEFAULT NULL,
  `topic_name` varchar(45) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,'asasf','fasfasfas','asfaffsssssssss','fasfasfassfas',1),(2,'asda','ddasd','sddas','assdasd',NULL),(3,'','','','',NULL),(4,'a','dfsdf','sdfa','sdf',NULL),(5,'asd','asd','asd','assd',NULL),(6,'asd','asd','asd','assd',NULL),(7,'asd','asd','asd','assd',NULL),(8,'sad','asd','asd','asd',NULL),(9,'asd','asdas','asd','asd',NULL);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `topic_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `topic_title` varchar(200) NOT NULL,
  `company_id` bigint(20) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `topic_company_fk_idx` (`company_id`),
  CONSTRAINT `topic_company_fk` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'Logical Questions',1,'admin','4','2016-09-07 20:31:21','2016-10-28 07:19:22'),(2,'java',1,'vipin','vipin','2016-09-08 16:08:16','2016-09-13 17:26:19'),(3,'c++',1,'vipin','vipin','2016-09-08 19:48:56','2016-09-19 13:39:57'),(6,'objective',1,'vipin','vipin','2016-09-13 20:52:13','2016-09-13 20:52:13'),(8,'Apptitude',1,'vipin','vipin','2016-09-21 16:58:27','2016-09-21 19:20:07'),(10,'angular',1,'vipin','4','2016-09-21 19:20:54','2016-10-27 05:50:42'),(11,'reactjs',1,'4','4','2016-09-27 13:58:15','2016-10-26 09:22:39'),(12,'sas',1,'4','4','2016-11-02 09:28:30','2016-11-02 09:28:30'),(13,'s',1,'4','4','2016-11-02 10:03:51','2016-11-02 10:03:51'),(14,'shashi',1,'4','4','2016-11-02 10:12:08','2016-11-02 10:12:08'),(15,'adasd',1,'4','4','2016-11-02 10:28:22','2016-11-02 10:28:22');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel`
--

DROP TABLE IF EXISTS `travel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `travel` (
  `traval_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_name` varchar(100) DEFAULT NULL,
  `advance` varchar(100) DEFAULT NULL,
  `travel_date` date DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`traval_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel`
--

LOCK TABLES `travel` WRITE;
/*!40000 ALTER TABLE `travel` DISABLE KEYS */;
INSERT INTO `travel` VALUES (13,'aaaa','aaaaaa','2016-09-10',1),(14,'bbb','bbbb','2016-05-10',1);
/*!40000 ALTER TABLE `travel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `traveldetails`
--

DROP TABLE IF EXISTS `traveldetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `traveldetails` (
  `traveldetails_id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(100) DEFAULT NULL,
  `to` varchar(100) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `traval_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`traveldetails_id`),
  KEY `travel_traveldetails_fk_idx` (`traval_id`),
  CONSTRAINT `travel_traveldetails_fk` FOREIGN KEY (`traval_id`) REFERENCES `travel` (`traval_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `traveldetails`
--

LOCK TABLES `traveldetails` WRITE;
/*!40000 ALTER TABLE `traveldetails` DISABLE KEYS */;
INSERT INTO `traveldetails` VALUES (5,'a','b','2016-11-15','2016-11-16',13),(6,'b','c','2016-11-17','2016-11-26',13),(7,'aaaa','bbbb','2016-10-29','2016-10-30',14),(8,'sadas','sasa','2016-11-14','2016-11-18',14),(10,'11','11','2016-11-29','2016-11-30',13);
/*!40000 ALTER TABLE `traveldetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_mobile_no` varchar(15) NOT NULL,
  `user_address` varchar(500) DEFAULT NULL,
  `user_pwd` varchar(500) CHARACTER SET utf8 NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_fresher` tinyint(1) NOT NULL,
  `user_exp_month` int(11) NOT NULL,
  `user_exp_year` int(11) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `updated_by` varchar(50) NOT NULL,
  `created_datetime` datetime NOT NULL,
  `updated_datetime` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `ot_role_user_fk_idx` (`role_id`),
  CONSTRAINT `ot_user_role_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'rkm','a@a','22','22','$2a$10$IXzmhTiprgxC9WTsSLaxj.o3rWbvWITAALYM.9k9R66dP08laTjDi',1,1,2,2,3,'rkm','tkm','2016-01-19 03:14:07','2016-01-19 03:14:07'),(2,'Amit','b@b.com','8470864154','asd','vuedlHlS',1,0,2,3,3,'admin','admin','2016-09-19 21:19:26','2016-09-20 13:26:02'),(4,'Amit ','amit8774@gmail.com','8470864154','fsdfs skdf','$2a$10$Kup24wp3tJjW/Gr13Z1io./uoYO8WkkfWgjPSxVaOp3B0eQBU9P0q',1,0,2,3,1,'admin','admin','2016-09-22 15:37:29','2016-09-22 15:37:29'),(5,'shashi','acb@abc.com','7597286877','a-163','$2a$10$YiHKUA./O/1pe47.5Y9jYObdIG6H0kQmarfrwJmdt1OBdSDyg04Pm',1,0,14,1,3,'4','4','2016-09-27 18:18:04','2016-09-27 18:18:13'),(6,'','abc@abc.com','','','$2a$10$slBlscLNoOxRxu8cr9u9sOMVkKcGqvD6j9Kjzk7L339d.5MurIqaK',1,0,0,0,3,'4','4','2016-09-27 18:18:26','2016-09-27 18:18:26'),(7,'','acb@abc.comas','','','$2a$10$vj2gmufp2ldyYlzslNzQj.p2U5Ez3xH/vYssB1dO3at33tNLneVoO',1,0,0,0,3,'4','4','2016-09-27 18:18:45','2016-09-27 18:18:45'),(8,'','acb@abc.comasasda','','','$2a$10$e.zNUtK5EJ5M/hxMueTSCOh4tRZTKeh7oM/DM7YHSK/S91SybPj8q',1,0,0,0,3,'4','4','2016-09-27 18:19:03','2016-09-27 18:19:03'),(9,'a','a@b.com','','a','$2a$10$A0g20OwCVm5wq2Pq2VRi5.D4xQjtLszbuXh2XtvgUbqZV0DCuEFjK',1,1,0,0,3,'4','4','2016-09-29 15:27:48','2016-09-29 15:27:48'),(10,'v','v@v','','','$2a$10$2P/rBnbVFgtiW7OtLb9DnOStPtFhwMmkUEiJSQyLYYIRkkI2.EwM6',1,1,0,0,3,'4','4','2016-09-29 15:30:50','2016-09-29 15:30:50'),(11,'','acb@abc.comlkmokm kmikk,pl','','','$2a$10$IXzmhTiprgxC9WTsSLaxj.o3rWbvWITAALYM.9k9R66dP08laTjDi',1,0,0,0,3,'10','10','2016-09-29 15:32:18','2016-09-29 15:32:18'),(12,'Amit Kumar','amit.kumar@conqsys.com','8470864154','F-1644, 12th Avanue, Gaur City 2, Noida Extension (201309)','$2a$10$2gn/ppPLMLoiDx0P.b.ag.lCQXkxnz9hWn.ENNj3vZI5diBQr2ese',1,0,8,8,3,'4','4','2016-10-28 08:40:32','2016-10-28 08:40:32'),(13,'as','as','','sa','$2a$10$AZt51p.eKUdb89Uta0pqVuK3648W.7SRY83B5cZnLPQpH1/NoiZve',1,0,1,1,3,'4','4','2016-11-02 09:28:49','2016-11-22 00:00:00');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userscore`
--

DROP TABLE IF EXISTS `userscore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userscore` (
  `score_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `answer_id` bigint(20) NOT NULL,
  `score` decimal(18,2) NOT NULL,
  `is_correct_answer` varchar(45) NOT NULL,
  PRIMARY KEY (`score_id`),
  KEY `answer_score_fk_idx` (`answer_id`),
  CONSTRAINT `answer_score_fk` FOREIGN KEY (`answer_id`) REFERENCES `answer` (`answer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userscore`
--

LOCK TABLES `userscore` WRITE;
/*!40000 ALTER TABLE `userscore` DISABLE KEYS */;
/*!40000 ALTER TABLE `userscore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendors`
--

DROP TABLE IF EXISTS `vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendors` (
  `vendor_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(45) DEFAULT NULL,
  `company_name` varchar(45) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `zip_code` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `ship_name` varchar(45) DEFAULT NULL,
  `ship_company` varchar(45) DEFAULT NULL,
  `ship_address` varchar(45) DEFAULT NULL,
  `ship_code` varchar(45) DEFAULT NULL,
  `ship_phone` varchar(45) DEFAULT NULL,
  `sub_total` decimal(9,6) DEFAULT NULL,
  PRIMARY KEY (`vendor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendors`
--

LOCK TABLES `vendors` WRITE;
/*!40000 ALTER TABLE `vendors` DISABLE KEYS */;
INSERT INTO `vendors` VALUES (14,'vipin','droisys','noida','201301','9555677398','shashi','conqsys','A-161','201301','9785879846',546.000000),(19,'hemant','facebook','punjab','201301','7887878787','badra','conqsys','noida','201301','9632587412',25.000000),(21,'hemanta','facebooka','punjaba','201301','7887878787','badraa','conqsysa','noidaa','201301','9632587412',89.000000),(23,'','','','','','','','','','',0.000000),(24,'','','','','','','','','','',0.000000),(25,'','','','','','','','','','',0.000000);
/*!40000 ALTER TABLE `vendors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'onlinetest'
--

--
-- Dumping routines for database 'onlinetest'
--
/*!50003 DROP PROCEDURE IF EXISTS `spdDeleteBusinessPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spdDeleteBusinessPartner`(
IN id INT(11)
)
BEGIN

DELETE FROM  `general` WHERE businesspartnermaster_id = id;
DELETE FROM  businesspartnermaster WHERE businesspartnermaster_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteBusinessPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spDeleteBusinessPartner`(
IN id INT(11)
)
BEGIN

DELETE FROM  `general` WHERE businesspartnermaster_id = id;
DELETE FROM  businesspartnermaster WHERE businesspartnermaster_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteInventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spDeleteInventory`(
IN id INT(11)
)
BEGIN

DELETE FROM  inventry_details WHERE inventry_id = id;
DELETE FROM  inventry WHERE inventry_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteQuestionSetQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spDeleteQuestionSetQuestion`(
IN questionSetQuestionId BIGINT
)
BEGIN

DELETE FROM questionsetquestion where question_set_question_id = questionSetQuestionId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteTravel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spDeleteTravel`(
IN id INT(11)
)
BEGIN

DELETE FROM  `traveldetails` WHERE Travel_id = id;
DELETE FROM  travel WHERE Travel_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteVender` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spDeleteVender`(
IN id INT(11)
)
BEGIN

DELETE FROM  purchase WHERE vendor_id = id;
DELETE FROM  vendors WHERE vendor_id = id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBusinessPartnerById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetBusinessPartnerById`(
IN id INT(11)
)
BEGIN
 SELECT bp.*,
		g.group_name
		FROM  `group` AS g  
		INNER JOIN businesspartnermaster AS bp
		ON g.group_id = bp.group_id
        WHERE bp.businesspartnermaster_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBusinessPartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetBusinessPartners`(
)
BEGIN
SELECT bp.*,
       g.group_name,
       (CASE
    WHEN businesspartnermastertype = 1 THEN 'Customer'
     ELSE 'Vender' END)as businessPartnertype_name
	FROM  `group` AS g  
    INNER JOIN businesspartnermaster AS bp
		ON g.group_id = bp.group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetCities`(
)
BEGIN
SELECT c.*,
       s.state_name
FROM  state AS s  
    INNER JOIN city AS c
		ON s.state_id = c.state_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCityById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetCityById`(
IN id bigint
)
BEGIN
SELECT c.*,
        s.state_name
FROM  state AS s  
    INNER JOIN  city AS c
		ON s.state_id = c.state_id
        WHERE c.city_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetEmployeeRecords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetEmployeeRecords`(
)
BEGIN
SELECT distinct e.employee_id,e.employee_name,e.email
FROM  employee AS e  
     JOIN employeerecord AS er
		ON e.employee_id = er.employee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetEmployees` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetEmployees`()
BEGIN
select emp.*,ab.balance from employee as emp
inner join amount_balance as ab
on ab.employee_id = emp.employee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetEmployeeTransactions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetEmployeeTransactions`()
BEGIN
SELECT distinct et.*,e.employee_name,ab.balance,
       (CASE
    WHEN type = 1 THEN 'Deposite'
     ELSE 'Withdrawal' END)as transaction_type
	FROM  employeetransaction AS et  
    INNER JOIN employee AS e
		ON e.employee_id = et.employee_id
    INNER JOIN amount_balance AS ab
	ON ab.employee_id = e.employee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetInventrys` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetInventrys`()
BEGIN
SELECT distinct inv.*,
       (CASE
    WHEN type = 1 THEN 'Sale'
     ELSE 'Purchase' END)as inventry_type
	FROM  inventry AS inv  
    INNER JOIN inventry_details AS id
		ON id.inventry_id = inv.inventry_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetItems` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetItems`()
BEGIN
	select distinct i.*,ist.stock,ist.item_stock_id from items as i
	inner join item_stock as ist 
	on ist.items_id = i.items_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetLoginDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetLoginDetail`(
IN userId BIGINT
)
BEGIN

SELECT 	u.user_id,
		u.user_name,
        u.user_email,
        u.user_mobile_no,
        u.role_id,
        role.role_name,
        cu.company_id,
        c.company_title,
        c.company_url,
        c.smtp_host,
        c.smtp_port,
        c.smtp_username,
        c.smtp_password
        
FROM	user u
		INNER JOIN companyuser cu ON cu.user_id = u.user_id
        INNER JOIN company c ON c.company_id = cu.company_id
        INNER JOIN role ON role.role_id = u.role_id
WHERE	u.user_id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOnlineTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetOnlineTest`(
IN onlineTestId BIGINT,
IN companyId BIGINT
)
BEGIN

SELECT 	online_test_id,
		company_id,
        online_test_title,
        DATE_FORMAT(test_start_date,'%d/%m/%Y') test_start_date,
        DATE_FORMAT(test_start_date,'%T') test_start_time,
        DATE_FORMAT(test_end_date,'%d/%m/%Y') test_end_date,
        DATE_FORMAT(test_end_date,'%T') test_end_time,
        question_set_id,
        test_support_text,
        test_experience_years,
        created_by,
        updated_by,
        created_datetime,
        updated_datetime
        
FROM	OnlineTest
WHERE	online_test_id = onlineTestId
		AND company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOnlineTestUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetOnlineTestUser`(
	IN onlineTestId BIGINT,
    IN companyId BIGINT
)
BEGIN

SELECT 	u.user_id, u.user_name, u.user_email, u.user_mobile_no, u.is_fresher, 
        CONCAT(CONCAT(u.user_exp_year, '.'), u.user_exp_month) user_exp_year,
		IFNULL(otu.online_test_user_id, 0) online_test_user_id, 
        IFNULL(otu.online_test_id, 0) online_test_id,
        0 is_deleted,
        CASE WHEN IFNULL(otu.online_test_user_id, 0) = 0 THEN 0 ELSE 1 END is_selected
FROM 	user u
INNER JOIN companyuser cu 
			ON u.user_id = cu.user_id AND u.role_id = 3
LEFT JOIN onlinetestuser otu 
			ON otu.user_id = u.user_id AND otu.online_test_id = onlineTestId
WHERE cu.company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOptionSeries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetOptionSeries`()
BEGIN

SELECT * FROM optionseries;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetProduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetProduct`()
BEGIN
SELECT p.*,
        i.item
FROM   items AS i 
    INNER JOIN product AS p
		ON p.item_id = i.items_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionOption` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionOption`(
IN questionId BIGINT
)
BEGIN
select qo.description,qo.option_id
from question as q 
inner join questionoption as qo ON qo.question_id = q.question_id
where qo.question_id = questionId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionsByCompany` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionsByCompany`(
IN companyId BIGINT
)
BEGIN

SELECT 	DISTINCT A.*,
		COUNT(DISTINCT D.User_Id) as UserCount,
        COUNT(DISTINCT B.question_set_id) as QuestionSetCount,
		COUNT(DISTINCT C.online_test_id) as OnlineTestCount,
        COUNT(DISTINCT option_id) as OptionCount,
		COUNT(DISTINCT pass.answer_id) as PappuPass,
        COUNT(DISTINCT fail.answer_id) as PappuFail
FROM 	question A 
		left JOIN questionsetquestion B ON A.question_id=B.question_id
		left JOIN onlinetest C ON B.question_set_id=C.question_set_id
		LEFT JOIN onlinetestuser D ON D.online_test_id=C.online_test_id
		left JOIN questionoption E ON E.question_id=A.question_id 
		LEFT JOIN answer pass ON A.question_id=pass.question_id AND pass.is_correct_answer=1
		LEFT JOIN answer fail ON A.question_id=fail.question_id AND fail.is_correct_answer=0
where A.company_id=companyId
GROUP BY 	A.question_id,
			A.question_description,
            A.topic_id,
			A.is_multiple_option,
            A.answer_explanation,
            A.company_id,
			A.created_by,
            A.updated_by,
            A.created_datetime,
            A.updated_datetime;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionsByTopic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionsByTopic`(
IN topicId BIGINT
)
BEGIN

SELECT 	question_id,
		question_description,
        topic_id,
        is_multiple_option,
        answer_explanation,
        company_id,
        0 AS is_selected
FROM	question
WHERE	topic_id = topicId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionSetQuestions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionSetQuestions`(
IN questionSetId BIGINT,
IN companyId BIGINT
)
BEGIN
SELECT 	qsq.question_set_question_id,
		qsq.question_set_id,
		qsq.question_id,
        q.question_description,
        false AS is_deleted
        
FROM 	questionset qs
		LEFT JOIN questionsetquestion qsq
		ON qs.question_set_id = qsq.question_set_id 
		LEFT JOIN question q
		ON q.question_id = qsq.question_id
WHERE	qs.question_set_id = questionSetId
		AND qs.company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionSets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionSets`(
IN userId BIGINT
)
BEGIN
SELECT otu.online_test_user_id,
	   otu.user_id,
	   ot.online_test_id,
       ot.company_id,
       ot.online_test_title,
	   ot.test_start_date,
       ot.test_end_date,
       ot.test_start_time,
       ot.test_end_time,
       ot.question_set_id,
       qs.question_set_title,
       qs.total_time
FROM   onlinetestuser AS otu 
    INNER JOIN onlinetest AS ot 
		ON otu.online_test_id = ot.online_test_id
	 INNER JOIN questionset AS qs 
		ON ot.question_set_id = qs.question_set_id
        
WHERE otu.user_id=userId 
		AND otu.is_completed = 0
		AND (UTC_TIMESTAMP() BETWEEN ot.test_start_date
        AND ot.test_end_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetQuestionStateInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetQuestionStateInfo`(IN companyId BIGINT)
BEGIN

SELECT 	DISTINCT A.*,
		COUNT(DISTINCT D.User_Id) as UserCount,
        COUNT(DISTINCT B.question_set_id) as QuestionSetCount,
		COUNT(DISTINCT C.online_test_id) as OnlineTestCount,
        COUNT(DISTINCT option_id) as OptionCount,
		COUNT(DISTINCT pass.answer_id) as CandidatePass,
        COUNT(DISTINCT fail.answer_id) as CandidateFail
FROM 	question A 
		LEFT JOIN questionsetquestion B ON A.question_id=B.question_id
		LEFT JOIN onlinetest C ON B.question_set_id=C.question_set_id
		LEFT JOIN onlinetestuser D ON D.online_test_id=C.online_test_id
		LEFT JOIN questionoption E ON E.question_id=A.question_id 
		LEFT JOIN answer ans ON A.question_id=ans.question_id 
		LEFT JOIN userscore pass ON ans.answer_id=pass.answer_id AND pass.is_correct_answer=1
        LEFT JOIN userscore fail ON ans.answer_id=fail.answer_id AND fail.is_correct_answer=0
WHERE 	A.company_id = companyId
GROUP BY 	A.question_id,
			A.question_description,
            A.topic_id,
			A.is_multiple_option,
            A.answer_explanation,
            A.company_id,
			A.created_by,
            A.updated_by,
            A.created_datetime,
            A.updated_datetime;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetScore` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetScore`(
IN id BIGINT
)
BEGIN
select sum(us.score) AS score, count(score_id) AS totalscore,a.online_test_user_id 
		from userscore AS us INNER JOIN answer AS a 
		ON us.answer_id = a.answer_id
		WHERE online_test_user_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetState`(
)
BEGIN
SELECT s.*,
        c.country_name
FROM   country AS c 
    INNER JOIN state AS s 
		ON c.country_id = s.country_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetStateById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetStateById`(
IN id bigint
)
BEGIN
SELECT s.*,
        c.country_name
FROM   country AS c 
    INNER JOIN state AS s 
		ON c.country_id = s.country_id
        WHERE s.state_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetStates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetStates`(
)
BEGIN
SELECT s.*,
       c.country_name
FROM   country AS c 
    INNER JOIN state AS s 
		ON c.country_id = s.country_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetTestQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetTestQuestion`(
IN testUserId BIGINT,
IN userId BIGINT,
IN questionSetId BIGINT
)
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS table1 AS (
		SELECT 	otu.online_test_user_id, 
		otu.user_id, 
        otu.online_test_id, 
        ot.company_id, 
        ot.online_test_title, 
        ot.question_set_id,
		sq.question_id, 
        q.question_description, 
        q.topic_id, 
        q.is_multiple_option,
		a.answer_id 

FROM 	onlinetestuser otu
		INNER JOIN onlinetest ot 
			ON otu.online_test_id = ot.online_test_id
		INNER JOIN questionsetquestion sq 
			ON sq.question_set_id = ot.question_set_id AND sq.question_set_id = questionSetId
		INNER JOIN question q 
			ON q.question_id = sq.question_id
		LEFT JOIN answer a 
			ON a.question_id = q.question_id AND a.online_test_user_id = otu.online_test_user_id

WHERE 	otu.user_id=userId 
		AND otu.is_completed = 0
        AND otu.online_test_user_id = testUserId
		AND (UTC_TIMESTAMP() BETWEEN ot.test_start_date AND ot.test_end_date) 
        );

SET @totalQuestion:= (SELECT COUNT(online_test_user_id) FROM table1);
SET @totalAnsweredQuestion:= (SELECT COUNT(online_test_user_id) FROM table1 where answer_id IS NOT NULL);

SELECT 	table1.*, 
		@totalQuestion totalQuestions, 
        (@totalAnsweredQuestion + 1) selectedQuestion,
        (@totalQuestion - (@totalAnsweredQuestion + 1)) remainingQuestion
		
FROM table1 WHERE answer_id IS NULL
ORDER BY rand() LIMIT 1;  

 DROP TEMPORARY TABLE table1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetTestResult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetTestResult`(
IN id BIGINT
)
BEGIN
select sum(us.score) AS score, count(score_id) AS totalscore,a.online_test_user_id 
		from userscore AS us INNER JOIN answer AS a 
		ON us.answer_id = a.answer_id
		WHERE online_test_user_id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUserById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetUserById`(
IN userId BIGINT,
IN companyId BIGINT
)
BEGIN

select 	*
FROM	user u
		INNER JOIN companyuser cu 
        ON cu.user_id = u.user_id
WHERE	u.role_id = 3 
		AND cu.company_id = companyId
        AND u.user_id = userId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetUsers`(
IN companyId BIGINT
)
BEGIN

SELECT 	u.user_id,
		u.user_name,
        u.user_email,
        u.user_mobile_no,
        u.is_active,
        u.is_fresher,
        u.user_exp_month,
        u.user_exp_year,
        cu.company_id,
        0 isSelected
FROM	user u
		INNER JOIN companyuser cu 
        ON cu.user_id = u.user_id
WHERE	cu.company_id = companyId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetVendorById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spGetVendorById`(
IN id INT(11)
)
BEGIN
select * from vendors where vendor_id=id;
select * from purchase where vendor_id=id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveAnswer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveAnswer`(
IN questionId bigint(20), 
IN selectedOption varchar(500),
IN onlineTestUserId bigint(20),
IN userId BIGINT,
IN questionSetId BIGINT
)
BEGIN
INSERT INTO answer
	(
		question_id, 
		selected_option,
		online_test_user_id,
		created_datetime
	)
	VALUES 
	(
		questionId, 
		selectedOption,
		onlineTestUserId,
		UTC_TIMESTAMP()
	);
            
call spGetTestQuestion(onlineTestUserId, userId, questionSetId);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveBusinessPartnerMaster` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveBusinessPartnerMaster`(
IN id int(11), 
in businesspartnermastertype int(11) ,
IN name VARCHAR(100), 
IN foreign_name varchar(100), 
IN group_id int(11), 
IN currency int(11) ,
IN federal_tax_id varchar(100) ,
IN currency_type int(11) ,
IN account_balance decimal(18,2) ,
IN deliveries varchar(100) ,
IN orders varchar(100),
IN opportunities int(11),
IN generalXMl varchar(21524)
)
BEGIN
	IF (id = 0)
	THEN
		INSERT INTO businesspartnermaster 
		(	
			businesspartnermastertype ,
			name, 
			foreign_name, 
			group_id, 
			currency, 
			federal_tax_id,
			currency_type,
			account_balance,
			deliveries, 
			orders,
			opportunities 
		) 
		VALUES 
		(
			businesspartnermastertype,
			name, 
			foreign_name, 
			group_id, 
			currency, 
			federal_tax_id,
			currency_type,
			account_balance,
			deliveries, 
			orders,
			opportunities  
		);
		SET @id:= LAST_INSERT_ID();

		INSERT INTO general 
		(	
			telephone,
			connect_person, 
			mobile_phone , 
			email ,
			remark ,
			web_site ,
			shipping_id ,
			sales_employee_id ,
			`password` ,
			bp_project ,
			bp_channel_code ,
			industry_id , 
			technician , 
			alias_name ,
			language_id ,
			send_marketing_content , 
			active , 
			inactive ,
			advance,
			`to` , 
			`from` ,
			user_remark ,
			businesspartnermaster_id 
		) 
		VALUES 
		(
			extractValue(generalXMl,'/general/telephone'),
			extractValue(generalXMl,'/general/connect_person'),
			extractValue(generalXMl,'/general/mobile_phone'),
			extractValue(generalXMl,'/general/email'),
			extractValue(generalXMl,'/general/remark'),
			extractValue(generalXMl,'/general/web_site'),
			extractValue(generalXMl,'/general/shipping_id'),
			extractValue(generalXMl,'/general/sales_employee_id'),
			extractValue(generalXMl,'/general/password'),
			extractValue(generalXMl,'/general/bp_project'),
			extractValue(generalXMl,'/general/bp_channel_code'),
			extractValue(generalXMl,'/general/industry_id'),
			extractValue(generalXMl,'/general/technician'),
			extractValue(generalXMl,'/general/alias_name'),
			extractValue(generalXMl,'/general/language_id'),
			extractValue(generalXMl,'/general/send_marketing_content'),
			extractValue(generalXMl,'/general/active'),
			extractValue(generalXMl,'/general/inactive'),
			extractValue(generalXMl,'/general/advance'),
			extractValue(generalXMl,'/general/to'),
			extractValue(generalXMl,'/general/from'),
			extractValue(generalXMl,'/general/user_remark'),
			@id
		); 
	ELSE 
		UPDATE businesspartnermaster SET
			businesspartnermastertype = businesspartnermastertype ,
			name = name, 
			foreign_name = foreign_name, 
			group_id =group_id, 
			currency =currency, 
			federal_tax_id =federal_tax_id,
			currency_type =currency_type,
			account_balance =account_balance,
			deliveries =deliveries, 
			orders = orders,
			opportunities =opportunities 
		WHERE businesspartnermaster_id = id;

		UPDATE general 
SET 
    telephone = EXTRACTVALUE(generalXMl, '/general/telephone'),
    connect_person = EXTRACTVALUE(generalXMl, '/general/connect_person'),
    mobile_phone = EXTRACTVALUE(generalXMl, '/general/mobile_phone'),
    email = EXTRACTVALUE(generalXMl, '/general/email'),
    remark = EXTRACTVALUE(generalXMl, '/general/remark'),
    web_site = EXTRACTVALUE(generalXMl, '/general/web_site'),
    shipping_id = EXTRACTVALUE(generalXMl, '/general/shipping_id'),
    sales_employee_id = EXTRACTVALUE(generalXMl, '/general/sales_employee_id'),
    `password` = EXTRACTVALUE(generalXMl, '/general/password'),
    bp_project = EXTRACTVALUE(generalXMl, '/general/bp_project'),
    bp_channel_code = EXTRACTVALUE(generalXMl, '/general/bp_channel_code'),
    industry_id = EXTRACTVALUE(generalXMl, '/general/industry_id'),
    technician = EXTRACTVALUE(generalXMl, '/general/technician'),
    alias_name = EXTRACTVALUE(generalXMl, '/general/alias_name'),
    language_id = EXTRACTVALUE(generalXMl, '/general/language_id'),
    send_marketing_content = EXTRACTVALUE(generalXMl,
            '/general/send_marketing_content'),
    active = EXTRACTVALUE(generalXMl, '/general/active'),
    inactive = EXTRACTVALUE(generalXMl, '/general/inactive'),
    advance = EXTRACTVALUE(generalXMl, '/general/advance'),
    `to` = EXTRACTVALUE(generalXMl, '/general/to'),
    `from` = EXTRACTVALUE(generalXMl, '/general/from'),
    user_remark = EXTRACTVALUE(generalXMl, '/general/user_remark')
WHERE
    businesspartnermaster_id = id;
		
	END IF;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveCity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveCity`(
IN id int(11), 
IN state_id VARCHAR(100), 
IN city_name VARCHAR(45), 
IN is_active TINYINT(4)
)
BEGIN
IF (id = 0)
THEN
INSERT INTO city 
		(	
			state_id,
			city_name,
            is_active
		) 
	VALUES 
		(
            state_id,
            city_name,
            is_active            
		);
SELECT LAST_INSERT_ID() AS id;
ELSE 
UPDATE city SET
			state_id = state_id,
			city_name = city_name,
            is_active = is_active
		WHERE city_id = id;
    SELECT id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveCompany` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveCompany`(
IN id INT, 
IN company_title varchar(100),
IN company_url varchar(50), 
IN company_address varchar(200), 
IN company_phone varchar(40), 
IN company_email varchar(100), 
IN company_hr_phone varchar(40), 
IN company_hr_emailid varchar(100),
IN smtp_host varchar(45), 
IN smtp_port int(11) ,
IN smtp_username varchar(45), 
IN smtp_password varchar(45),
IN created_by varchar(50),
IN updated_by varchar(50)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO company
		(
            company_title,
			company_url, 
			company_address, 
			company_phone, 
			company_email, 
			company_hr_phone, 
			company_hr_emailid ,
            smtp_host,
            smtp_port,
            smtp_username,
            smtp_password,
			created_by ,
			updated_by ,
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
			company_title,
			company_url, 
			company_address, 
			company_phone, 
			company_email, 
			company_hr_phone, 
			company_hr_emailid ,
            smtp_host,
            smtp_port,
            smtp_username,
            smtp_password,
			created_by ,
			updated_by ,
            UTC_TIMESTAMP(), 
           UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE company SET
		company_title = company_title,
        company_url = company_url,
        company_address = company_address,
        company_phone = company_phone,
        company_email = company_email,
        company_hr_phone = company_hr_phone,
        company_hr_emailid = company_hr_emailid,
		smtp_host=smtp_host,
        smtp_port=smtp_port,
        smtp_username=smtp_username,
		smtp_password=smtp_password,
		updated_by = updated_by,
        updated_datetime =UTC_TIMESTAMP()
	WHERE company_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveCompanyUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveCompanyUser`(
IN companyId bigint(20), 
IN userId bigint(20)
)
BEGIN

SET @existCount := (SELECT COUNT(*) from companyuser where company_id = companyId AND user_id = userId);

IF (@existCount = 0)
THEN
		INSERT INTO companyuser
		(
            company_id,
			user_id
			
		)
		VALUES 
		(
			companyId,
			userId
			
		);
            
SELECT LAST_INSERT_ID() as id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveContractdata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveContractdata`(
IN id INT, 
IN contactid int(11), 
IN customer_id int(11),
IN contractno varchar(45), 
IN startdate DATE,
IN enddate DATE,
IN terminationdate DATE,
IN description varchar(45),
IN serviceid INT, 
IN service_type varchar(45),
IN contract_type varchar(45),
IN template varchar(45),
IN response_time varchar(45),
IN resulation_time varchar(45),
IN status varchar(45),
IN owner varchar(45),
IN renewal tinyint(4),
IN reminder varchar(45),
IN active_items varchar(45),
IN remarks varchar(45),
IN template_remarks varchar(45)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO contract
		(
            contactid, 
            customer_id,
            contractno, 
            startdate, 
            enddate, 
            terminationdate,            
            description
            
            
		)
		VALUES 
		(
            contactid, 
            customer_id,
            contractno, 
            startdate, 
            enddate, 
            terminationdate,            
            description
            
		);
            SET @Id:=LAST_INSERT_ID();

ELSE
   UPDATE contract SET
		contactid  = contactid ,
        customer_id  = customer_id ,
		contractno  = contractno ,
        startdate  = startdate ,
        enddate  = enddate ,
        is_active = is_active,        
        terminationdate  = terminationdate,
        description  = description
		
	WHERE contractid = id;
SET @Id:=id;
END IF;
BEGIN
call spSaveServicesdata(
serviceid, 
@Id, 
service_type ,
contract_type,
template,
response_time ,
resulation_time,
status,
owner,
renewal,
reminder,
active_items,
remarks,
template_remarks
);
END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveCountry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveCountry`(
IN id int(11), 
IN country_name VARCHAR(100), 
IN country_code VARCHAR(45), 
IN is_active TINYINT(4)
)
BEGIN
IF (id = 0)
THEN
INSERT INTO country 
		(	
			country_name,
			country_code,
            is_active
		) 
	VALUES 
		(
            country_name,
            country_code,
            is_active            
		);
SELECT LAST_INSERT_ID() AS id;
ELSE 
UPDATE country SET
			country_name = country_name,
			country_code = country_code,
            is_active = is_active
		WHERE country_id = id;
    SELECT id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveEmployeeDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveEmployeeDetails`(
IN id int(11), 
IN employee_id int(11),  
IN qualification_id int(11)
)
BEGIN
IF (id = 0)
	THEN
	INSERT INTO employeerecord 
			(	
			employee_id,
			qualification_id
			) 
		VALUES 
			(
			employee_id,
			qualification_id
			);
	SELECT LAST_INSERT_ID() AS id;
ELSE 
	UPDATE employeerecord SET
			employee_id = employee_id,
			qualification_id = qualification_id
			WHERE employee_id = employee_id and employeerecord_id=id;
		SELECT employeerecord_id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveEmployeeTransaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveEmployeeTransaction`(
IN id int(11), 
IN `type` int(11),  
IN empId int(11),
IN amount decimal(12,4),  
IN `date` date 
)
BEGIN
 if(id = 0)
	then 
		insert into employeetransaction 
			  (
				type,
				employee_id,
				amount,
				date 
			  )
          values 
			  (
				`type`,
				empId,
				amount,
				`date` 
			  );
			select last_insert_id() as id;
        else
			 update employeetransaction set
				type = `type`,
				employee_id = empId,
				amount = amount,
				date = `date` 
			 where employee_transaction_id = id;
            select id;
	end if;
		IF(type = 1) then
					UPDATE amount_balance SET balance=(balance + amount) WHERE employee_id = empId;
                ELSE
					UPDATE amount_balance SET balance=(balance - amount) WHERE employee_id = empId;
        end if ; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveGeneral` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveGeneral`(
IN id int(11), 
in telephone varchar(100) ,
IN connect_person varchar(100), 
IN mobile_phone varchar(100) , 
IN email varchar(100), 
IN remark varchar(100) ,
IN web_site varchar(100) ,
IN shipping_id int(11) ,
IN sales_employee_id int(11) ,
IN `password` varchar(100) ,
IN bp_project varchar(100),
IN bp_channel_code varchar(100),
IN industry_id int(11) , 
IN technician varchar(100), 
IN alias_name varchar(100) ,
IN language_id int(11) ,
IN send_marketing_content int(11) , 
IN active int(11), 
IN inactive int(11) ,
IN advance int(11) ,
IN `to` varchar(100) , 
IN `from` varchar(100) ,
IN user_remark varchar(100) ,
IN businesspartnermaster_id int(11)
)
BEGIN
IF (id = 0)
THEN
INSERT INTO general 
		(	
        telephone,
		connect_person, 
		mobile_phone , 
		email ,
		remark ,
		web_site ,
		shipping_id ,
		sales_employee_id ,
		`password` ,
		bp_project ,
		bp_channel_code ,
		industry_id , 
		technician , 
		alias_name ,
		language_id ,
		send_marketing_content , 
		active , 
		inactive ,
		advance,
		`to` , 
		`from` ,
		user_remark ,
		businesspartnermaster_id 
		) 
	VALUES 
		(
		telephone,
		connect_person, 
		mobile_phone , 
		email ,
		remark ,
		web_site ,
		shipping_id ,
		sales_employee_id ,
		`password` ,
		bp_project ,
		bp_channel_code ,
		industry_id , 
		technician , 
		alias_name ,
		language_id ,
		send_marketing_content , 
		active , 
		inactive ,
		advance,
		`to` , 
		`from` ,
		user_remark ,
		businesspartnermaster_id
		);
SELECT LAST_INSERT_ID() AS id;
ELSE 
UPDATE general SET
		telephone =telephone,
		connect_person=connect_person, 
		mobile_phone=mobile_phone , 
		email=email ,
		remark =remark ,
		web_site =web_site ,
		shipping_id =shipping_id ,
		sales_employee_id = sales_employee_id,
		`password`=`password` ,
		bp_project = bp_project ,
		bp_channel_code = bp_channel_code ,
		industry_id = industry_id , 
		technician = technician , 
		alias_name =alias_name ,
		language_id =language_id ,
		send_marketing_content =send_marketing_content , 
		active =active , 
		inactive=inactive ,
		advance=advance,
		`to` =`to` , 
		`from`=`from` ,
		user_remark=user_remark ,
		businesspartnermaster_id =businesspartnermaster_id
		WHERE general_id = id;
    SELECT id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveInventry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveInventry`(
IN id INT(11), 
IN `type` INT(11),  
IN `name` VARCHAR(100),
IN address VARCHAR(100),  
IN mobile_no VARCHAR(100),
IN tin_no VARCHAR(100),  
IN total DECIMAL(9,3) 
)
BEGIN
IF(id =0)
THEN
INSERT INTO inventry(
			 `type`,
			 `name`, 
			 address,
			 mobile_no, 
			 tin_no, 
			 total
			) 
		values (
			`type`, 
			`name`, 
			address, 
			mobile_no, 
			tin_no, 
			total
			);
            SELECT LAST_INSERT_ID() AS id;
	ELSE 
		UPDATE inventry SET
			`type` = `type`,
			 `name` = `name`, 
			 address = address,
			 mobile_no = mobile_no, 
			 tin_no = tin_no , 
			 total = total
             WHERE inventry_id = id;
         SELECT id;
	END IF;		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveInventryDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveInventryDetails`(
IN id int(11), 
IN inventry_id int(11),  
IN item_id int(11),
IN item_rate decimal(9,3),  
IN quantity decimal(9,3),
IN sub_total decimal(9,3),
IN inventry_type INT(11)
)
BEGIN
	if(id =0)
		then
			INSERT INTO inventry_details 
					(	
					inventry_id,
					item_id,
					item_rate,
					quantity,
                    sub_total
					) 
				VALUES 
					(
					inventry_id,
					item_id,
					item_rate,
					quantity,
                    sub_total
					);
                   select quantity;
				IF(inventry_type = 1) then
					UPDATE item_stock SET stock=(stock - quantity) WHERE items_id=item_id;
                ELSE
					UPDATE item_stock SET stock=(stock + quantity) WHERE items_id=item_id;
                end if ;             
                    
	END if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveOnlineTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveOnlineTest`(
IN id INT, 
IN company_id bigint(20) ,
IN online_test_title varchar(200), 
IN test_start_date datetime,
IN test_end_date datetime,
IN question_set_id bigint(20),
IN test_support_text text,
IN test_experience_years int(11),
IN created_by varchar(50),
IN updated_by varchar(50) 
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO onlinetest
		(
            company_id, 
			online_test_title ,
			test_start_date ,
			test_end_date ,
			question_set_id,
			test_support_text,
			test_experience_years,
			created_by , 
			updated_by ,
			created_datetime,
			updated_datetime
		)
		VALUES 
		(
			company_id, 
			online_test_title ,
			test_start_date ,
			test_end_date ,
			question_set_id,
			test_support_text,
			test_experience_years,
			created_by , 
			updated_by ,
			UTC_TIMESTAMP(), 
            UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE onlinetest SET
		company_id = company_id,
        online_test_title = online_test_title,
        test_start_date = test_start_date,
        test_end_date = test_end_date,
        question_set_id = question_set_id,
        test_support_text = test_support_text,
        test_experience_years =test_experience_years,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE online_test_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveOnlinetestuser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveOnlinetestuser`(
IN id INT, 
IN user_id bigint(20), 
IN online_test_id bigint(20), 
IN test_completed_date datetime ,
IN test_start_date_time datetime ,
IN test_end_date_time datetime ,
IN is_abonded bit(1) ,
IN is_completed bit(1)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO onlinetestuser
		(
            user_id , 
			online_test_id,
			test_completed_date,
			test_start_date_time,
			test_end_date_time , 
			is_abonded, 
			is_completed
		)
		VALUES 
		(
			user_id , 
			online_test_id,
			test_completed_date,
			test_start_date_time,
			test_end_date_time , 
			is_abonded, 
			is_completed
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE onlinetestuser SET
		test_completed_date = test_completed_date,
        test_start_date_time = test_start_date_time,
        test_end_date_time = test_end_date_time,
        test_end_time = test_end_time,
        is_abonded = is_abonded,
        is_completed = is_completed
	WHERE online_test_user_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveProduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveProduct`(
IN id INT(11), 
IN product_name VARCHAR(100),
IN product_code VARCHAR(100), 
IN item_id INT(11), 
IN item_rate DECIMAL(9,3),
IN quantity DECIMAL(9,3)
)
BEGIN
IF (id = 0)
THEN
INSERT INTO product 
		(	
			product_name,
			product_code,
			item_id,
            item_rate,
            quantity
		) 
	VALUES 
		(
			product_name,
            product_code,
            item_id,
            item_rate,
            quantity
		);
SELECT LAST_INSERT_ID() AS id;
ELSE 
UPDATE product SET
			product_name=product_name,
			product_code = product_code,
			item_id = item_id,
            item_rate = item_rate,
            quantity = quantity
		WHERE product_id = id;
    SELECT id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSavePurchase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSavePurchase`(
IN id int(11),
IN quantity decimal(9,6), 
IN unit_price decimal(9,6),
IN total decimal(9,6),
IN vendor_id int(11),
IN details varchar(45)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO purchase
		(
            quantity, 
            unit_price,
            total, 
            vendor_id, 
            item
            
		)
		VALUES 
		(
            quantity, 
            unit_price,
            total, 
            vendor_id, 
            item
		);
            

ELSE
   UPDATE purchase SET
		quantity  = quantity ,
		unit_price  = unit_price,
        total  = total,
        item  = item
	WHERE vendor_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQualification` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQualification`(
IN id integer,
IN qualification_name VARCHAR(100),
IN is_active TINYINT(4)
)
BEGIN
	IF(id = 0)
		THEN
INSERT INTO qualification (
		qualification_name,
		is_active
		)
 VALUES (
		 qualification_name,
		 is_active
		 );
         SELECT LAST_INSERT_ID() AS id;
	ELSE 
UPDATE  qualification SET
		qualification_name = qualification_name,
		is_active = is_active
        WHERE qualification_id = id;
        SELECT id;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestion`(
IN id INT, 
IN question_description longtext, 
IN topic_id INT,
IN is_multiple_option bit,
IN answer_explanation longtext,
IN company_id bigint(20),
IN created_by varchar(50), 
IN updated_by varchar(50)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO question
		(
            question_description, 
            topic_id,
            is_multiple_option,
            answer_explanation,
            company_id,
            created_by, 
            updated_by, 
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
			question_description, 
			topic_id,
            is_multiple_option,
            answer_explanation,
            company_id,
			created_by, 
            updated_by,
            UTC_TIMESTAMP(), 
            UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE question SET
		question_description = question_description,
        topic_id = topic_id,
        is_multiple_option = is_multiple_option,
        answer_explanation = answer_explanation,
        company_id = company_id,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE question_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestionOption` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestionOption`(
IN id BIGINT, 
IN description text, 
IN is_correct Bit,
IN question_id BIGINT

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO questionoption
		(
            description, 
            is_correct,
            question_id
            
		)
		VALUES 
		(
			description, 
			is_correct,
            question_id
            
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE questionoption SET
		description = description,
        is_correct = is_correct,
        question_id = question_id
       	WHERE option_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestionSet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestionSet`(
IN id INT, 
IN question_set_title VARCHAR(200), 
IN total_time INT,
IN company_id BIGINT(20),
IN total_questions INT(11),
IN is_randomize TINYINT,
IN option_series_id BIGINT,
IN created_by varchar(50), 
IN updated_by varchar(50)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO questionset
		(
            question_set_title, 
            total_time,
            company_id,
            total_questions,
            is_randomize,
            option_series_id,
            created_by, 
            updated_by, 
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
			question_set_title, 
            total_time,
            company_id,
            total_questions,
            is_randomize,
            option_series_id,
            created_by, 
            updated_by, 
            UTC_TIMESTAMP(), 
			UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE questionset SET
		question_set_title = question_set_title,
        total_time = total_time,
        company_id = company_id,
        total_questions = total_questions,
        is_randomize = is_randomize,
        option_series_id = option_series_id,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE question_set_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuestionSetQuestion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuestionSetQuestion`(
IN id INT, 
IN question_set_id bigint(20),
IN question_id bigint(20)
)
BEGIN
	IF (id = 0)
		THEN
			INSERT INTO questionsetquestion
			(
				question_set_id, 
				question_id 
			)
			VALUES 
			(
				question_set_id, 
				question_id 
			);
				
		SELECT LAST_INSERT_ID() as id;
		ELSE
			UPDATE questionsetquestion SET
				question_set_id = question_set_id,
				question_id = question_id
			WHERE question_set_question_id  = id;
		SELECT id;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQulification` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQulification`(
IN qulification_id INT(11), 
IN qulification_name VARCHAR(100), 
IN passingYear INT(11), 
IN percentage INT(11),
IN employee_id INT(11)
)
BEGIN
IF (qulification_id = 0)
THEN
INSERT INTO country 
		(	
			qulification_name,
			passingYear,
            percentage,
            employee_id
		) 
	VALUES 
		(
           qulification_name,
			passingYear,
            percentage,
            employee_id           
		);
SELECT LAST_INSERT_ID() AS qulification_id;
ELSE 
UPDATE country SET
			qulification_name = qulification_name,
			passingYear = passingYear,
            percentage = percentage,
            employee_id=employee_id
		WHERE qulification_id = qulification_id;
    SELECT qulification_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveQuote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveQuote`(
IN id INT, 
IN quote_no varchar(45), 
IN quote_description varchar(45),
IN project_value decimal(6,2), 
IN budget_value decimal(6,2),
IN material decimal(6,2),
IN is_active tinyint(4)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO quote
		(
            quote_no, 
            quote_description,
            project_value, 
            budget_value, 
            material, 
            is_active
		)
		VALUES 
		(
            quote_no,
            quote_description,
			project_value, 
            budget_value,
			material, 
            is_active
		);
            

ELSE
   UPDATE quote SET
		quote_no = quote_no,
        quote_description = quote_description,
		project_value = project_value,
        budget_value = budget_value,
        material = material,
        is_active = is_active
	WHERE quoteid = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveServicesdata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveServicesdata`(
IN id INT, 
IN contractsaveid int(11), 
IN service_type varchar(45),
IN contract_type varchar(45),
IN template varchar(45),
IN response_time varchar(45),
IN resulation_time varchar(45),
IN status varchar(45),
IN owner varchar(45),
IN renewal tinyint(4),
IN reminder varchar(45),
IN active_items varchar(45),
IN remarks varchar(45),
IN template_remarks varchar(45)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO service
		(
            contractsaveid, 
            service_type,
            contract_type, 
            template, 
            response_time, 
            resulation_time,
			status, 
            owner,
            renewal, 
            reminder, 
            active_items, 
            remarks,
            template_remarks
            
		)
		VALUES 
		(
            contractsaveid, 
            service_type,
            contract_type, 
            template, 
            response_time, 
            resulation_time,
			status, 
            owner,
            renewal, 
            reminder, 
            active_items, 
            remarks,
            template_remarks
		);
            

ELSE
   UPDATE service SET
		contractsaveid  = contractsaveid ,
		service_type  = service_type ,
        contract_type  = contract_type ,
        template  = template ,
        response_time  = response_time ,        
        resulation_time  = resulation_time ,
        status  = status ,
		owner  = owner ,
        renewal  = renewal ,
        reminder  = reminder ,
        active_items  = active_items ,
         remarks   = remarks ,
        template_remarks   = template_remarks 
	WHERE serviceid = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveState`(
IN id int(11), 
IN country_id VARCHAR(100), 
IN state_name VARCHAR(45), 
IN is_active TINYINT(4)
)
BEGIN
IF (id = 0)
THEN
INSERT INTO state 
		(	
			country_id,
			state_name,
            is_active
		) 
	VALUES 
		(
            country_id,
            state_name,
            is_active            
		);
SELECT LAST_INSERT_ID() AS id;
ELSE 
UPDATE state SET
			country_id = country_id,
			state_name = state_name,
            is_active = is_active
		WHERE state_id = id;
    SELECT id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveTopic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveTopic`(
IN id INT, 
IN topic_title varchar(100), 
IN company_id bigint(20),
IN created_by varchar(100), 
IN updated_by varchar(100)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO topic
		(
            topic_title, 
            company_id,
            created_by, 
            updated_by, 
            created_datetime, 
            updated_datetime
		)
		VALUES 
		(
            topic_title,
            company_id,
			created_by, 
            updated_by,
			UTC_TIMESTAMP(), 
            UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE topic SET
		topic_title = topic_title,
        company_id = company_id,
		updated_by = updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE topic_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveTravel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveTravel`(
IN id int(11), 
IN employee_name VARCHAR(100), 
IN advance varchar(100), 
IN travel_date date, 
IN is_active tinyint(4)
)
BEGIN
	IF (id = 0)
	THEN
		INSERT INTO travel 
		(	
			employee_name ,
			advance, 
			travel_date, 
			is_active
		) 
		VALUES 
		(
			employee_name ,
			advance, 
			travel_date, 
			is_active 
		);
		SELECT LAST_INSERT_ID() AS id;

	ELSE 
		UPDATE travel SET
			employee_name = employee_name,
			advance = advance, 
			travel_date = travel_date, 
			is_active = is_active
		WHERE traval_id = id;
	SELECT id;
    END IF; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveTravelDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveTravelDetails`(
IN id int(11), 
IN `source` varchar(100),
IN destination varchar(100),
IN source_date date, 
IN destination_date date, 
IN traval_id int(11)
)
BEGIN
IF (id = 0)
	THEN
	INSERT INTO traveldetails 
			(	
			`from` ,
			`to`,
			from_date,
			to_date ,
			traval_id
			) 
		VALUES 
			(
			`source` ,
			destination,
			source_date,
			destination_date,
			traval_id
			);
	SELECT LAST_INSERT_ID() AS id;
ELSE 
	UPDATE traveldetails SET
			`from` =`source`,
			`to`= destination, 
			from_date = source_date , 
			to_date = destination_date 		
			WHERE traval_id = traval_id and traveldetails_id=id;
		SELECT traval_id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveUser`(
IN id INT, 
IN user_name varchar(100) ,
IN user_email varchar(100), 
IN user_mobile_no varchar(15) ,
IN user_address varchar(500), 
IN user_pwd varchar(100) ,
IN is_active bit(1) ,
IN is_fresher bit(1) ,
IN user_exp_month int(11) ,
IN user_exp_year int(11), 
IN role_id bigint(20), 
IN created_by varchar(50) ,
IN updated_by varchar(50)

)
BEGIN
IF (id = 0)
THEN
		INSERT INTO user
		(
            user_name ,
			user_email, 
			user_mobile_no ,
			user_address , 
			user_pwd ,
			is_active ,
			is_fresher ,
			user_exp_month  ,
			user_exp_year , 
			role_id , 
			created_by  ,
			updated_by, 
			created_datetime ,
			updated_datetime 
		)
		VALUES 
		(
			user_name ,
			user_email, 
			user_mobile_no ,
			user_address , 
			user_pwd ,
			is_active ,
			is_fresher ,
			user_exp_month  ,
			user_exp_year , 
			role_id , 
			created_by  ,
			updated_by, 
			UTC_TIMESTAMP() ,
			UTC_TIMESTAMP()
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE user SET
		user_name = user_name,
        user_email = user_email,
        user_mobile_no = user_mobile_no,
        user_address = user_address,
        user_pwd = user_pwd,
        is_active = is_active,
        is_fresher = is_fresher,
        user_exp_month = user_exp_month,
        user_exp_year=user_exp_year,
        role_id=role_id,
        updated_by=updated_by,
        updated_datetime = UTC_TIMESTAMP()
	WHERE user_id  = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSaveVendorPurchase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spSaveVendorPurchase`(
IN id int(11),
IN vendor_name varchar(45), 
IN company_name varchar(45),
IN address varchar(45), 
IN zip_code varchar(45),
IN phone varchar(45), 
IN ship_name varchar(45),
IN ship_company varchar(45), 
IN ship_address varchar(45),
IN ship_code varchar(45), 
IN ship_phone varchar(45),
IN sub_total decimal(9,6)
)
BEGIN
IF (id = 0)
THEN
		INSERT INTO vendors
		(
            vendor_name, 
            company_name,
            address, 
            zip_code, 
            phone,
			ship_name, 
            ship_company,
            ship_address, 
            ship_code, 
            ship_phone,
            sub_total
		)
		VALUES 
		(
			vendor_name, 
            company_name,
            address, 
            zip_code, 
            phone,
			ship_name, 
            ship_company,
            ship_address, 
            ship_code, 
            ship_phone,
            sub_total
		);
            
SELECT LAST_INSERT_ID() as id;
ELSE
   UPDATE vendors SET
		vendor_name  = vendor_name ,
		company_name  = company_name,
        address  = address,
        zip_code  = zip_code,
        phone  = phone,
		ship_name  = ship_name,
        ship_company  = ship_company,
        ship_address  = ship_address,
		ship_code  = ship_code,
        ship_phone  = ship_phone,
        sub_total  = sub_total
	WHERE vendor_id = id;
SELECT id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateEmployeeDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spUpdateEmployeeDetails`(
IN id int(11), 
IN employee_name varchar(100), 
IN email varchar(100), 
IN mobile varchar(100), 
IN gender tinyint(4), 
IN pancard_no varchar(100), 
IN country_id int(11), 
IN state_id int(11) ,
IN city_id int(11)
)
BEGIN
	UPDATE employee SET
			employee_name = employee_name,
			email = email,
            mobile = mobile,
            gender = gender,
            pancard_no = pancard_no,
            country_id = country_id,
            state_id = state_id,
            city_id = city_id
			WHERE employee_id = id;
		SELECT id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateOnlineTestUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `spUpdateOnlineTestUser`(
IN id BIGINT, 
IN isTestBegin tinyint
)
BEGIN
IF(isTestBegin = 1)
THEN
	UPDATE 	onlinetestuser 
	SET		test_start_date_time = UTC_TIMESTAMP(),
			is_abandoned = 1,
			is_completed = 0
	WHERE online_test_user_id = id;
    SELECT id;
ELSE
 UPDATE onlinetestuser SET
		test_completed_date = UTC_TIMESTAMP(),
        test_end_date_time = UTC_TIMESTAMP(),
        is_abandoned = 0,
        is_completed = 1
	WHERE online_test_user_id = id;
    SELECT id;
END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `test`(
in listString varchar(255)
)
BEGIN

set @query = concat('select * from testTable where id in (',listString,');');
prepare sql_query from @query;
execute sql_query;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `test12` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `test12`(
IN fromDate DATE,
IN isActive bit,
IN toDate DATE
)
BEGIN

select * from user
where (isActive IS NULL OR is_active = isActive)
		AND (updated_datetime BETWEEN fromDate AND toDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-17 19:51:37
