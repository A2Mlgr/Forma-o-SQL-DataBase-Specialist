-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `idCategoria` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(80) NOT NULL,
  `idCategoriaPai` int(11) DEFAULT NULL,
  PRIMARY KEY (`idCategoria`),
  KEY `fk_cat_pai` (`idCategoriaPai`),
  CONSTRAINT `fk_cat_pai` FOREIGN KEY (`idCategoriaPai`) REFERENCES `categoria` (`idCategoria`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Eletronicos',NULL),(2,'Smartphones',1),(3,'Notebooks',1),(4,'Perifericos',1),(5,'Casa e Jardim',NULL),(6,'Ferramentas',5);
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientepf`
--

DROP TABLE IF EXISTS `clientepf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientepf` (
  `idConta` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `dataNascimento` date DEFAULT NULL,
  PRIMARY KEY (`idConta`),
  UNIQUE KEY `cpf` (`cpf`),
  CONSTRAINT `fk_pf_conta` FOREIGN KEY (`idConta`) REFERENCES `conta` (`idConta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientepf`
--

LOCK TABLES `clientepf` WRITE;
/*!40000 ALTER TABLE `clientepf` DISABLE KEYS */;
INSERT INTO `clientepf` VALUES (1,'Ana Silva','11122233344','1990-05-14'),(2,'Carlos Souza','55566677788','1985-11-30'),(5,'João Lima','99900011122','1995-03-08'),(6,'Maria Dias','33344455566','2000-07-19');
/*!40000 ALTER TABLE `clientepf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientepj`
--

DROP TABLE IF EXISTS `clientepj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientepj` (
  `idConta` int(11) NOT NULL,
  `razaoSocial` varchar(150) NOT NULL,
  `cnpj` char(14) NOT NULL,
  `nomeFantasia` varchar(150) DEFAULT NULL,
  `inscricaoEstadual` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`idConta`),
  UNIQUE KEY `cnpj` (`cnpj`),
  CONSTRAINT `fk_pj_conta` FOREIGN KEY (`idConta`) REFERENCES `conta` (`idConta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientepj`
--

LOCK TABLES `clientepj` WRITE;
/*!40000 ALTER TABLE `clientepj` DISABLE KEYS */;
INSERT INTO `clientepj` VALUES (3,'TechPrime Soluções LTDA','12345678000190','TechPrime',NULL),(4,'Mega Store Comercio LTDA','98765432000155','MegaStore',NULL);
/*!40000 ALTER TABLE `clientepj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conta`
--

DROP TABLE IF EXISTS `conta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conta` (
  `idConta` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `dataCadastro` date NOT NULL DEFAULT curdate(),
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `tipo` enum('PF','PJ') NOT NULL,
  PRIMARY KEY (`idConta`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conta`
--

LOCK TABLES `conta` WRITE;
/*!40000 ALTER TABLE `conta` DISABLE KEYS */;
INSERT INTO `conta` VALUES (1,'ana.silva@email.com','11999990001','2023-01-10',1,'PF'),(2,'carlos.souza@email.com','21988880002','2023-03-15',1,'PF'),(3,'empresa@techprime.com','11333330003','2022-06-20',1,'PJ'),(4,'contato@megastore.com','11444440004','2022-09-05',1,'PJ'),(5,'joao.lima@email.com','31977770005','2023-07-22',1,'PF'),(6,'maria.dias@email.com','85966660006','2024-01-03',1,'PF');
/*!40000 ALTER TABLE `conta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_backup_user_before_delete
BEFORE DELETE ON Conta
FOR EACH ROW
BEGIN
    INSERT INTO Log_Contas_Excluidas (idConta, email)
    VALUES (OLD.idConta, OLD.email);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `endereco`
--

DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `endereco` (
  `idEndereco` int(11) NOT NULL AUTO_INCREMENT,
  `idConta` int(11) NOT NULL,
  `logradouro` varchar(150) NOT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `complemento` varchar(80) DEFAULT NULL,
  `bairro` varchar(80) NOT NULL,
  `cidade` varchar(80) NOT NULL,
  `estado` char(2) NOT NULL,
  `cep` char(8) NOT NULL,
  `tipo` enum('Residencial','Comercial','Entrega','Cobrança') NOT NULL DEFAULT 'Entrega',
  `principal` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idEndereco`),
  KEY `fk_end_conta` (`idConta`),
  CONSTRAINT `fk_end_conta` FOREIGN KEY (`idConta`) REFERENCES `conta` (`idConta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco`
--

LOCK TABLES `endereco` WRITE;
/*!40000 ALTER TABLE `endereco` DISABLE KEYS */;
INSERT INTO `endereco` VALUES (1,1,'Rua das Flores','100',NULL,'Centro','São Paulo','SP','01310000','Residencial',1),(2,2,'Av. Brasil','200',NULL,'Copacabana','Rio de Janeiro','RJ','22020001','Residencial',1),(3,3,'Rua das Industrias','500',NULL,'Bairro Ind','São Paulo','SP','04000000','Comercial',1),(4,4,'Av. Paulista','900',NULL,'Bela Vista','São Paulo','SP','01310100','Comercial',1),(5,5,'Rua Minas Gerais','300',NULL,'Savassi','Belo Horizonte','MG','30130000','Residencial',1),(6,6,'Rua da Paz','50',NULL,'Aldeota','Fortaleza','CE','60140000','Residencial',1);
/*!40000 ALTER TABLE `endereco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrega`
--

DROP TABLE IF EXISTS `entrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrega` (
  `idEntrega` int(11) NOT NULL AUTO_INCREMENT,
  `idPedido` int(11) NOT NULL,
  `codigoRastreio` varchar(50) NOT NULL,
  `transportadora` varchar(100) DEFAULT NULL,
  `status` enum('Aguardando Coleta','Coletado','Em Trânsito','Saiu para Entrega','Entregue','Tentativa de Entrega','Devolvido ao Remetente') NOT NULL DEFAULT 'Aguardando Coleta',
  `dataEnvio` datetime DEFAULT NULL,
  `dataPrevisao` date DEFAULT NULL,
  `dataEntrega` datetime DEFAULT NULL,
  PRIMARY KEY (`idEntrega`),
  UNIQUE KEY `idPedido` (`idPedido`),
  UNIQUE KEY `codigoRastreio` (`codigoRastreio`),
  CONSTRAINT `fk_ent_pedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrega`
--

LOCK TABLES `entrega` WRITE;
/*!40000 ALTER TABLE `entrega` DISABLE KEYS */;
INSERT INTO `entrega` VALUES (1,1,'BR001234560BR','Correios','Entregue','2024-02-11 00:00:00','2024-02-15','2024-02-14 00:00:00'),(2,2,'BR002345670BR','Correios','Entregue','2024-03-06 00:00:00','2024-03-10','2024-03-09 00:00:00'),(3,3,'JD334455667BR','Jadlog','Em Trânsito','2024-03-13 00:00:00','2024-03-18',NULL),(4,4,'FX445566778BR','FedEx','Aguardando Coleta',NULL,'2024-04-10',NULL),(5,5,'BR556677889BR','Correios','Saiu para Entrega','2024-04-11 00:00:00','2024-04-15',NULL);
/*!40000 ALTER TABLE `entrega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque`
--

DROP TABLE IF EXISTS `estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque` (
  `idEstoque` int(11) NOT NULL AUTO_INCREMENT,
  `idProduto` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT 0,
  `localizacao` varchar(80) DEFAULT NULL,
  `ultimaAtualizacao` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`idEstoque`),
  UNIQUE KEY `idProduto` (`idProduto`),
  CONSTRAINT `fk_est_prod` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque`
--

LOCK TABLES `estoque` WRITE;
/*!40000 ALTER TABLE `estoque` DISABLE KEYS */;
INSERT INTO `estoque` VALUES (1,1,50,'Galpao A - Prateleira 1','2026-04-25 00:21:58'),(2,2,120,'Galpao A - Prateleira 2','2026-04-25 00:21:58'),(3,3,30,'Galpao B - Prateleira 1','2026-04-25 00:21:58'),(4,4,80,'Galpao B - Prateleira 2','2026-04-25 00:21:58'),(5,5,200,'Galpao C - Prateleira 1','2026-04-25 00:21:58'),(6,6,150,'Galpao C - Prateleira 2','2026-04-25 00:21:58'),(7,7,40,'Galpao D - Prateleira 1','2026-04-25 00:21:58'),(8,8,90,'Galpao D - Prateleira 2','2026-04-25 00:21:58');
/*!40000 ALTER TABLE `estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formapagamento`
--

DROP TABLE IF EXISTS `formapagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formapagamento` (
  `idFormaPagamento` int(11) NOT NULL AUTO_INCREMENT,
  `idConta` int(11) NOT NULL,
  `tipo` enum('Cartão de Crédito','Cartão de Débito','PIX','Boleto','Transferência') NOT NULL,
  `apelido` varchar(50) DEFAULT NULL,
  `numeroMascarado` varchar(19) DEFAULT NULL,
  `bandeira` varchar(30) DEFAULT NULL,
  `nomeTitular` varchar(100) DEFAULT NULL,
  `validade` char(7) DEFAULT NULL,
  `chavePix` varchar(150) DEFAULT NULL,
  `tipoChavePix` enum('CPF','CNPJ','Email','Telefone','Aleatória') DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idFormaPagamento`),
  KEY `fk_fp_conta` (`idConta`),
  CONSTRAINT `fk_fp_conta` FOREIGN KEY (`idConta`) REFERENCES `conta` (`idConta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formapagamento`
--

LOCK TABLES `formapagamento` WRITE;
/*!40000 ALTER TABLE `formapagamento` DISABLE KEYS */;
INSERT INTO `formapagamento` VALUES (1,1,'Cartão de Crédito','Visa Ana','**** **** **** 1234','Visa','Ana Silva','12/2026',NULL,NULL,1),(2,1,'PIX','PIX Ana',NULL,NULL,NULL,NULL,NULL,NULL,1),(3,2,'Cartão de Débito','Débito Carlos','**** **** **** 5678','Mastercard','Carlos Souza','08/2025',NULL,NULL,1),(4,3,'Boleto','Boleto Empresa',NULL,NULL,NULL,NULL,NULL,NULL,1),(5,4,'Cartão de Crédito','Amex MegaStore','**** **** **** 9012','Amex','MegaStore','03/2027',NULL,NULL,1),(6,5,'PIX','PIX João',NULL,NULL,NULL,NULL,NULL,NULL,1),(7,6,'Cartão de Crédito','Visa Maria','**** **** **** 3456','Visa','Maria Dias','09/2026',NULL,NULL,1),(8,1,'Cartão de Crédito','Master Ana','**** **** **** 7890','Mastercard','Ana Silva','06/2028',NULL,NULL,1);
/*!40000 ALTER TABLE `formapagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedor`
--

DROP TABLE IF EXISTS `fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor` (
  `idFornecedor` int(11) NOT NULL AUTO_INCREMENT,
  `razaoSocial` varchar(150) NOT NULL,
  `cnpj` char(14) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE KEY `cnpj` (`cnpj`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedor`
--

LOCK TABLES `fornecedor` WRITE;
/*!40000 ALTER TABLE `fornecedor` DISABLE KEYS */;
INSERT INTO `fornecedor` VALUES (1,'Apple Brasil LTDA','11111111000101','fornecedor@apple.com.br','11900000001'),(2,'Samsung Brasil LTDA','22222222000102','fornecedor@samsung.com.br','11900000002'),(3,'Dell Computadores LTDA','33333333000103','fornecedor@dell.com.br','11900000003'),(4,'Logitech Brasil LTDA','44444444000104','fornecedor@logitech.com','11900000004'),(5,'Bosch Brasil LTDA','55555555000105','fornecedor@bosch.com.br','11900000005');
/*!40000 ALTER TABLE `fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_pedido`
--

DROP TABLE IF EXISTS `item_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_pedido` (
  `idItemPedido` int(11) NOT NULL AUTO_INCREMENT,
  `idPedido` int(11) NOT NULL,
  `idProduto` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT 1,
  `valorUnitario` decimal(10,2) NOT NULL,
  `desconto` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`idItemPedido`),
  KEY `fk_ip_pedido` (`idPedido`),
  KEY `fk_ip_prod` (`idProduto`),
  CONSTRAINT `fk_ip_pedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ip_prod` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_pedido`
--

LOCK TABLES `item_pedido` WRITE;
/*!40000 ALTER TABLE `item_pedido` DISABLE KEYS */;
INSERT INTO `item_pedido` VALUES (1,1,1,1,8999.00,0.00),(2,1,5,1,599.00,0.00),(3,2,5,1,599.00,0.00),(4,3,2,1,4599.00,0.00),(5,4,3,1,9499.00,0.00),(6,4,4,1,4299.00,0.00),(7,5,6,1,349.00,0.00),(8,6,8,1,189.00,0.00),(9,7,4,1,4299.00,0.00),(10,8,1,1,8999.00,0.00);
/*!40000 ALTER TABLE `item_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_contas_excluidas`
--

DROP TABLE IF EXISTS `log_contas_excluidas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_contas_excluidas` (
  `idLog` int(11) NOT NULL AUTO_INCREMENT,
  `idConta` int(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `data_exclusao` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`idLog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_contas_excluidas`
--

LOCK TABLES `log_contas_excluidas` WRITE;
/*!40000 ALTER TABLE `log_contas_excluidas` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_contas_excluidas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `idPedido` int(11) NOT NULL AUTO_INCREMENT,
  `idConta` int(11) NOT NULL,
  `idEnderecoEntrega` int(11) NOT NULL,
  `dataPedido` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('Aguardando Pagamento','Pago','Em Separação','Enviado','Entregue','Cancelado','Devolvido') NOT NULL DEFAULT 'Aguardando Pagamento',
  `valorTotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `observacao` text DEFAULT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `fk_ped_conta` (`idConta`),
  KEY `fk_ped_end` (`idEnderecoEntrega`),
  CONSTRAINT `fk_ped_conta` FOREIGN KEY (`idConta`) REFERENCES `conta` (`idConta`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ped_end` FOREIGN KEY (`idEnderecoEntrega`) REFERENCES `endereco` (`idEndereco`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,1,'2024-02-10 10:30:00','Entregue',9598.00,NULL),(2,1,1,'2024-03-05 14:00:00','Entregue',599.00,NULL),(3,2,2,'2024-03-12 09:15:00','Enviado',4599.00,NULL),(4,3,3,'2024-04-01 11:00:00','Em Separação',13798.00,NULL),(5,5,5,'2024-04-10 16:45:00','Pago',349.00,NULL),(6,6,6,'2024-04-15 08:00:00','Aguardando Pagamento',189.00,NULL),(7,2,2,'2024-04-20 13:30:00','Cancelado',4299.00,NULL),(8,4,4,'2024-04-22 10:00:00','Pago',8999.00,NULL);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_pagamento`
--

DROP TABLE IF EXISTS `pedido_pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_pagamento` (
  `idPedido` int(11) NOT NULL,
  `idFormaPagamento` int(11) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `status` enum('Pendente','Aprovado','Recusado','Estornado') NOT NULL DEFAULT 'Pendente',
  `dataTransacao` datetime NOT NULL DEFAULT current_timestamp(),
  `codigoTransacao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idPedido`,`idFormaPagamento`),
  KEY `fk_pp_fp` (`idFormaPagamento`),
  CONSTRAINT `fk_pp_fp` FOREIGN KEY (`idFormaPagamento`) REFERENCES `formapagamento` (`idFormaPagamento`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pp_pedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_pagamento`
--

LOCK TABLES `pedido_pagamento` WRITE;
/*!40000 ALTER TABLE `pedido_pagamento` DISABLE KEYS */;
INSERT INTO `pedido_pagamento` VALUES (1,1,9598.00,'Aprovado','2026-04-25 00:21:58','TXN001'),(2,2,599.00,'Aprovado','2026-04-25 00:21:58','TXN002'),(3,3,4599.00,'Aprovado','2026-04-25 00:21:58','TXN003'),(4,4,8000.00,'Aprovado','2026-04-25 00:21:58','TXN004'),(4,5,5798.00,'Aprovado','2026-04-25 00:21:58','TXN005'),(5,6,349.00,'Aprovado','2026-04-25 00:21:58','TXN006'),(6,7,189.00,'Pendente','2026-04-25 00:21:58',NULL),(8,5,8999.00,'Aprovado','2026-04-25 00:21:58','TXN008');
/*!40000 ALTER TABLE `pedido_pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `idProduto` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `descricao` text DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `idCategoria` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProduto`),
  KEY `fk_prod_cat` (`idCategoria`),
  CONSTRAINT `fk_prod_cat` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`idCategoria`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,'iPhone 15 Pro','Apple iPhone 15 Pro 256GB',9898.90,2),(2,'Samsung Galaxy S24','Samsung Galaxy S24 128GB',5058.90,2),(3,'MacBook Air M2','Apple MacBook Air chip M2 8GB 256GB',9499.00,3),(4,'Dell Inspiron 15','Dell Inspiron 15 i5 16GB 512GB',4299.00,3),(5,'Mouse Logitech MX','Mouse sem fio Logitech MX Master 3',599.00,4),(6,'Teclado Mecanico','Teclado mecanico RGB Redragon',349.00,4),(7,'Furadeira Bosch','Furadeira de Impacto Bosch 650W',459.00,6),(8,'Kit Jardim','Kit ferramentas para jardim 10 pecas',189.00,5);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_validar_preco_produto
BEFORE UPDATE ON Produto
FOR EACH ROW
BEGIN
    -- Se o novo preço for 0 ou negativo, impede a atualização
    IF NEW.preco <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: O preço do produto deve ser maior que zero.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `produto_fornecedor`
--

DROP TABLE IF EXISTS `produto_fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_fornecedor` (
  `idProduto` int(11) NOT NULL,
  `idFornecedor` int(11) NOT NULL,
  `precoFornecedor` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idProduto`,`idFornecedor`),
  KEY `fk_pf_forn` (`idFornecedor`),
  CONSTRAINT `fk_pf_forn` FOREIGN KEY (`idFornecedor`) REFERENCES `fornecedor` (`idFornecedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pf_prod` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_fornecedor`
--

LOCK TABLES `produto_fornecedor` WRITE;
/*!40000 ALTER TABLE `produto_fornecedor` DISABLE KEYS */;
INSERT INTO `produto_fornecedor` VALUES (1,1,7200.00),(2,2,3500.00),(3,1,7800.00),(4,3,3200.00),(5,4,380.00),(6,4,200.00),(7,5,300.00);
/*!40000 ALTER TABLE `produto_fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto_vendedor`
--

DROP TABLE IF EXISTS `produto_vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_vendedor` (
  `idProduto` int(11) NOT NULL,
  `idVendedor` int(11) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idProduto`,`idVendedor`),
  KEY `fk_pv_vend` (`idVendedor`),
  CONSTRAINT `fk_pv_prod` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pv_vend` FOREIGN KEY (`idVendedor`) REFERENCES `vendedor` (`idVendedor`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_vendedor`
--

LOCK TABLES `produto_vendedor` WRITE;
/*!40000 ALTER TABLE `produto_vendedor` DISABLE KEYS */;
INSERT INTO `produto_vendedor` VALUES (1,1,9199.00),(2,1,4799.00),(5,3,649.00),(6,3,399.00),(7,2,479.00);
/*!40000 ALTER TABLE `produto_vendedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rastreio_historico`
--

DROP TABLE IF EXISTS `rastreio_historico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rastreio_historico` (
  `idHistorico` int(11) NOT NULL AUTO_INCREMENT,
  `idEntrega` int(11) NOT NULL,
  `dataEvento` datetime NOT NULL DEFAULT current_timestamp(),
  `local` varchar(150) DEFAULT NULL,
  `descricao` varchar(255) NOT NULL,
  PRIMARY KEY (`idHistorico`),
  KEY `fk_rh_entrega` (`idEntrega`),
  CONSTRAINT `fk_rh_entrega` FOREIGN KEY (`idEntrega`) REFERENCES `entrega` (`idEntrega`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rastreio_historico`
--

LOCK TABLES `rastreio_historico` WRITE;
/*!40000 ALTER TABLE `rastreio_historico` DISABLE KEYS */;
INSERT INTO `rastreio_historico` VALUES (1,1,'2024-02-11 08:00:00','Sao Paulo, SP','Objeto postado'),(2,1,'2024-02-12 14:00:00','Campinas, SP','Em transito para unidade de distribuicao'),(3,1,'2024-02-14 10:00:00','Sao Paulo, SP','Objeto entregue ao destinatario'),(4,3,'2024-03-13 09:30:00','Rio de Janeiro, RJ','Objeto postado'),(5,3,'2024-03-14 16:00:00','Juiz de Fora, MG','Em transito'),(6,5,'2024-04-11 07:00:00','Belo Horizonte, MG','Objeto postado'),(7,5,'2024-04-14 08:30:00','Belo Horizonte, MG','Saiu para entrega');
/*!40000 ALTER TABLE `rastreio_historico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendedor`
--

DROP TABLE IF EXISTS `vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedor` (
  `idVendedor` int(11) NOT NULL AUTO_INCREMENT,
  `razaoSocial` varchar(150) NOT NULL,
  `cnpj` char(14) NOT NULL,
  `nomeFantasia` varchar(150) DEFAULT NULL,
  `avaliacao` decimal(2,1) DEFAULT 0.0,
  PRIMARY KEY (`idVendedor`),
  UNIQUE KEY `cnpj` (`cnpj`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendedor`
--

LOCK TABLES `vendedor` WRITE;
/*!40000 ALTER TABLE `vendedor` DISABLE KEYS */;
INSERT INTO `vendedor` VALUES (1,'TechVendas LTDA','66666666000106','TechVendas',4.8),(2,'Bosch Brasil LTDA','55555555000105','Bosch Oficial',4.9),(3,'Multi Eletronicos ME','77777777000107','MultiEletro',4.2);
/*!40000 ALTER TABLE `vendedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ecommerce'
--

--
-- Dumping routines for database 'ecommerce'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_inserir_pedido_seguro` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inserir_pedido_seguro`(
    IN p_idConta INT,
    IN p_idEndereco INT,
    IN p_idProduto INT,
    IN p_quantidade INT,
    IN p_valorUnitario DECIMAL(10,2)
)
BEGIN
    -- Declaração de variável para controle de erro
    DECLARE erro_sql TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

    -- 1. Insere o cabeçalho do pedido
    INSERT INTO Pedido (idConta, idEnderecoEntrega, status, valorTotal) 
    VALUES (p_idConta, p_idEndereco, 'Aguardando Pagamento', (p_quantidade * p_valorUnitario));

    -- 2. Recupera o ID do pedido inserido
    SET @novo_pedido_id = LAST_INSERT_ID();

    -- 3. Insere o item do pedido
    INSERT INTO Item_Pedido (idPedido, idProduto, quantidade, valorUnitario)
    VALUES (@novo_pedido_id, p_idProduto, p_quantidade, p_valorUnitario);

    -- Verificação de erro
    IF erro_sql THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na transação: Pedido cancelado e dados revertidos.';
    ELSE
        COMMIT;
    END IF;
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

-- Dump completed on 2026-04-25  1:05:50
