-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: proyecto_muebles
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `blog_posts`
--

DROP TABLE IF EXISTS `blog_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blog_posts` (
  `id_post` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(300) NOT NULL,
  `contenido` longtext DEFAULT NULL,
  `resumen` varchar(500) DEFAULT NULL,
  `imagen_principal` varchar(500) DEFAULT NULL,
  `id_autor` int(11) DEFAULT NULL,
  `id_categoria_blog` int(11) DEFAULT NULL,
  `num_comentarios` int(11) DEFAULT 0,
  `slug` varchar(300) NOT NULL,
  `estado` enum('borrador','publicado') DEFAULT 'publicado',
  `fecha_publicacion` datetime DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_post`),
  UNIQUE KEY `slug` (`slug`),
  KEY `id_autor` (`id_autor`),
  KEY `id_categoria_blog` (`id_categoria_blog`),
  CONSTRAINT `blog_posts_ibfk_1` FOREIGN KEY (`id_autor`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL,
  CONSTRAINT `blog_posts_ibfk_2` FOREIGN KEY (`id_categoria_blog`) REFERENCES `categorias_blog` (`id_categoria`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_posts`
--

LOCK TABLES `blog_posts` WRITE;
/*!40000 ALTER TABLE `blog_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `blog_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carrito`
--

DROP TABLE IF EXISTS `carrito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carrito` (
  `id_carrito` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) DEFAULT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_carrito`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `carrito_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `carrito_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrito`
--

LOCK TABLES `carrito` WRITE;
/*!40000 ALTER TABLE `carrito` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_blog`
--

DROP TABLE IF EXISTS `categorias_blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias_blog` (
  `id_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_blog`
--

LOCK TABLES `categorias_blog` WRITE;
/*!40000 ALTER TABLE `categorias_blog` DISABLE KEYS */;
INSERT INTO `categorias_blog` VALUES (1,'Web Design','web-design','2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'Web Development','web-development','2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Online Marketing','online-marketing','2026-05-14 01:07:43','2026-05-14 01:07:43'),(4,'Keyword Research','keyword-research','2026-05-14 01:07:43','2026-05-14 01:07:43'),(5,'Email Marketing','email-marketing','2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `categorias_blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_proyecto`
--

DROP TABLE IF EXISTS `categorias_proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias_proyecto` (
  `id_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `css_filter` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_proyecto`
--

LOCK TABLES `categorias_proyecto` WRITE;
/*!40000 ALTER TABLE `categorias_proyecto` DISABLE KEYS */;
INSERT INTO `categorias_proyecto` VALUES (1,'Completados','completado','.first','2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'En curso','en_curso','.second','2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Pr??ximos','proximo','.third','2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `categorias_proyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comentarios`
--

DROP TABLE IF EXISTS `comentarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comentarios` (
  `id_comentario` int(11) NOT NULL AUTO_INCREMENT,
  `id_post` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `sitio_web` varchar(300) DEFAULT NULL,
  `contenido` text NOT NULL,
  `id_comentario_padre` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_comentario`),
  KEY `id_post` (`id_post`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_comentario_padre` (`id_comentario_padre`),
  CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`id_post`) REFERENCES `blog_posts` (`id_post`) ON DELETE CASCADE,
  CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL,
  CONSTRAINT `comentarios_ibfk_3` FOREIGN KEY (`id_comentario_padre`) REFERENCES `comentarios` (`id_comentario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comentarios`
--

LOCK TABLES `comentarios` WRITE;
/*!40000 ALTER TABLE `comentarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `comentarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion`
--

DROP TABLE IF EXISTS `configuracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuracion` (
  `id_config` int(11) NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) NOT NULL,
  `valor` text DEFAULT NULL,
  `descripcion` varchar(300) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_config`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion`
--

LOCK TABLES `configuracion` WRITE;
/*!40000 ALTER TABLE `configuracion` DISABLE KEYS */;
INSERT INTO `configuracion` VALUES (1,'nombre_empresa','Calidad el paisa','Nombre de la empresa','2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'direccion','Carrera 70 No. 2b-08, Cali, Colombia','Direcci??n f??sica','2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'telefono','322 695 3819','Tel??fono de contacto','2026-05-14 01:07:43','2026-05-14 01:07:43'),(4,'email','calidadpaisa@gmail.com','Correo de contacto','2026-05-14 01:07:43','2026-05-14 01:07:43'),(5,'facebook_url','https://www.facebook.com/people/Muebles-y-colchones-Calidad-el-Paisa/100066455125406/','URL de Facebook','2026-05-14 01:07:43','2026-05-14 01:07:43'),(6,'instagram_url','https://www.instagram.com/calidadelpaisa/','URL de Instagram','2026-05-14 01:07:43','2026-05-14 01:07:43'),(7,'cuenta_bancolombia','Cuenta de ahorros Bancolombia #123-456-789','N??mero de cuenta Bancolombia','2026-05-14 01:07:43','2026-05-14 01:07:43'),(8,'nequi','3226953819','N??mero Nequi','2026-05-14 01:07:43','2026-05-14 01:07:43'),(9,'email_pago','calidadpaisa@gmail.com','Correo para confirmaciones de pago','2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contactos`
--

DROP TABLE IF EXISTS `contactos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contactos` (
  `id_contacto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `email` varchar(200) NOT NULL,
  `asunto` varchar(300) NOT NULL,
  `mensaje` text NOT NULL,
  `leido` tinyint(1) DEFAULT 0,
  `fecha_envio` datetime DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_contacto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contactos`
--

LOCK TABLES `contactos` WRITE;
/*!40000 ALTER TABLE `contactos` DISABLE KEYS */;
/*!40000 ALTER TABLE `contactos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `nombre_producto` varchar(150) NOT NULL,
  `precio_unitario` decimal(12,0) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `subtotal` decimal(12,0) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_detalle`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipo`
--

DROP TABLE IF EXISTS `equipo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `equipo` (
  `id_miembro` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `cargo` varchar(150) NOT NULL,
  `foto_url` varchar(500) DEFAULT NULL,
  `twitter_url` varchar(300) DEFAULT NULL,
  `facebook_url` varchar(300) DEFAULT NULL,
  `linkedin_url` varchar(300) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `orden` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_miembro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipo`
--

LOCK TABLES `equipo` WRITE;
/*!40000 ALTER TABLE `equipo` DISABLE KEYS */;
INSERT INTO `equipo` VALUES (1,'Donald John','CEO & Founder','img/team-1.jpg',NULL,NULL,NULL,1,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'Adam Phillips','Interior Designer','img/team-2.jpg',NULL,NULL,NULL,1,2,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Olive Yew','Creative Director','img/team-3.jpg',NULL,NULL,NULL,1,3,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(4,'Thomas Clark','Project Manager','img/team-4.jpg',NULL,NULL,NULL,1,4,'2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `equipo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metodos_pago` (
  `id_metodo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `descripcion` varchar(300) DEFAULT NULL,
  `requiere_datos_adicionales` tinyint(1) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_metodo`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodos_pago`
--

LOCK TABLES `metodos_pago` WRITE;
/*!40000 ALTER TABLE `metodos_pago` DISABLE KEYS */;
INSERT INTO `metodos_pago` VALUES (1,'Tarjeta de cr??dito/d??bito','tarjeta','Visa, Mastercard, American Express',0,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'Pago contraentrega','contraentrega','Pagas en efectivo al recibir tu pedido',0,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Transferencia bancaria / Nequi','transferencia','Bancolombia, Daviplata, Nequi',0,1,'2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter`
--

DROP TABLE IF EXISTS `newsletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter` (
  `id_suscriptor` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) DEFAULT NULL,
  `email` varchar(200) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_suscripcion` datetime DEFAULT current_timestamp(),
  `fecha_baja` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_suscriptor`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter`
--

LOCK TABLES `newsletter` WRITE;
/*!40000 ALTER TABLE `newsletter` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagos` (
  `id_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `id_metodo_pago` int(11) NOT NULL,
  `monto` decimal(12,0) NOT NULL,
  `numero_tarjeta` varchar(20) DEFAULT NULL,
  `nombre_tarjeta` varchar(150) DEFAULT NULL,
  `numero_comprobante` varchar(100) DEFAULT NULL,
  `estado` enum('pendiente','completado','fallido') DEFAULT 'pendiente',
  `fecha_pago` datetime DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_pago`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_metodo_pago` (`id_metodo_pago`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodos_pago` (`id_metodo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) DEFAULT NULL,
  `nombre_cliente` varchar(150) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `direccion_entrega` varchar(300) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `departamento` varchar(100) NOT NULL,
  `codigo_postal` varchar(20) DEFAULT NULL,
  `subtotal` decimal(12,0) NOT NULL,
  `costo_envio` decimal(10,0) DEFAULT 0,
  `total` decimal(12,0) NOT NULL,
  `id_metodo_pago` int(11) NOT NULL,
  `estado` enum('pendiente','confirmado','enviado','entregado','cancelado') DEFAULT 'pendiente',
  `fecha_pedido` datetime DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_pedido`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_metodo_pago` (`id_metodo_pago`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL,
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodos_pago` (`id_metodo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(12,0) NOT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `destacado` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Silla Roble','Silla de madera maciza, acabado natural.',189900,'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80','sillas',15,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'Mesa Comedor Extensible','Mesa de comedor extensible para 6 personas.',459900,'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80','mesas',8,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Armario 3 Cuerpos','Armario amplio con 3 cuerpos y espejo.',789900,'https://images.unsplash.com/photo-1595428774223-ef52624120d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80','armarios',5,0,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(4,'C??moda 6 Cajones','C??moda espaciosa con 6 cajones.',329900,'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80','comodas',10,0,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(5,'Sill??n Relax','Sill??n ergon??mico con reposapi??s.',599900,'https://images.unsplash.com/photo-1616627547584-bf28cee262db?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80','sillas',6,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(6,'Estante R??stico','Estante de madera r??stica con 4 niveles.',149900,'https://images.unsplash.com/photo-1519643381401-22c77e60520e?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80','estantes',20,0,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(7,'Closet 2x2','Closet espacioso de 2 cuerpos con acabado premium.',1310000,'img/closet2x2-1310000.jpeg','armarios',10,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(8,'Sala Infinity','Sala Infinity con dise?o moderno y cojines ergon?micos.',1850000,'img/sala_infinity_1850000.jpeg','salas',8,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(9,'Multialacena','Multialacena funcional con m?ltiples compartimentos.',630000,'img/multialacena-630.jpeg','armarios',12,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(10,'Sala Tokio Escualizable','Sala Tokio escualizable, elegante y vers?til.',1850000,'img/sala-tokio_escualizable_1850000.jpeg','salas',5,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(11,'Sala Begonia','Sala Begonia con tapizado suave y estructura reforzada.',1850000,'img/salabegonia_1850000.jpeg','salas',6,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(12,'Solter?n Hollywood','Solter?n Hollywood con cabecero acojinado y dise?o cl?sico.',550000,'img/solteronhollywood_550000.jpeg','camas',15,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(13,'Mesa TV','Mesa para TV con amplio espacio para equipos y decoraci?n.',490000,'img/mesaTv_490000.jpeg','mesas',20,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(14,'Tocador Reyna','Tocador Reyna con espejo y m?ltiples cajones.',550000,'img/tocador-reyna_550000.jpeg','comodas',10,1,'2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyectos`
--

DROP TABLE IF EXISTS `proyectos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proyectos` (
  `id_proyecto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `id_categoria` int(11) NOT NULL,
  `estado` enum('completado','en_curso','proximo') DEFAULT 'completado',
  `fecha_completado` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_proyecto`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `proyectos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_proyecto` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyectos`
--

LOCK TABLES `proyectos` WRITE;
/*!40000 ALTER TABLE `proyectos` DISABLE KEYS */;
INSERT INTO `proyectos` VALUES (1,'Sala de estar',NULL,'img/portfolio-1.jpg',1,'completado',NULL,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'Comedor r??stico',NULL,'img/portfolio-2.jpg',2,'en_curso',NULL,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Oficina en casa',NULL,'img/portfolio-3.jpg',3,'proximo',NULL,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(4,'Dormitorio principal',NULL,'img/portfolio-4.jpg',1,'completado',NULL,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(5,'Sala infantil',NULL,'img/portfolio-5.jpg',2,'en_curso',NULL,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(6,'Terraza',NULL,'img/portfolio-6.jpg',3,'proximo',NULL,1,'2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `proyectos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servicios` (
  `id_servicio` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion_corta` varchar(300) DEFAULT NULL,
  `descripcion_larga` text DEFAULT NULL,
  `icono_css` varchar(100) DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `orden` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_servicio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicios`
--

LOCK TABLES `servicios` WRITE;
/*!40000 ALTER TABLE `servicios` DISABLE KEYS */;
INSERT INTO `servicios` VALUES (1,'Dise??o de dormitorios','Camas, armarios y cabeceros personalizados.',NULL,'flaticon-bedroom',NULL,1,1,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(2,'Dise??o de cocinas','Mobiliario funcional y est??tico.',NULL,'flaticon-kitchen',NULL,1,2,'2026-05-14 01:07:43','2026-05-14 01:07:43'),(3,'Dise??o de ba??os','Muebles de ba??o en madera tratada.',NULL,'flaticon-bathroom',NULL,1,3,'2026-05-14 01:07:43','2026-05-14 01:07:43');
/*!40000 ALTER TABLE `servicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testimonios`
--

DROP TABLE IF EXISTS `testimonios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `testimonios` (
  `id_testimonio` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_cliente` varchar(150) NOT NULL,
  `profesion` varchar(150) NOT NULL,
  `foto_url` varchar(500) DEFAULT NULL,
  `contenido` text NOT NULL,
  `calificacion` tinyint(4) DEFAULT 5,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_testimonio`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testimonios`
--

LOCK TABLES `testimonios` WRITE;
/*!40000 ALTER TABLE `testimonios` DISABLE KEYS */;
INSERT INTO `testimonios` VALUES (1,'Mar??a Garc??a','Ama de casa','img/testimonial-1.jpg','Excelente calidad en los muebles. Compr?? una sala completa y qued?? hermosa. Muy recomendados.',5,1,'2026-05-14 01:07:43'),(2,'Carlos L??pez','Empresario','img/testimonial-2.jpg','Los muebles de madera son de muy buena calidad. El servicio de entrega fue puntual y profesional.',5,1,'2026-05-14 01:07:43');
/*!40000 ALTER TABLE `testimonios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens_recuperacion`
--

DROP TABLE IF EXISTS `tokens_recuperacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokens_recuperacion` (
  `id_token` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `email` varchar(200) NOT NULL,
  `token` varchar(100) NOT NULL,
  `usado` tinyint(1) DEFAULT 0,
  `expiracion` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_token`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `tokens_recuperacion_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens_recuperacion`
--

LOCK TABLES `tokens_recuperacion` WRITE;
/*!40000 ALTER TABLE `tokens_recuperacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens_recuperacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `ultimo_acceso` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'santiago tamayo','stamayo493@gmail.com','$2y$10$ytgfva8pfqzuySM/DPYCkOArOdZ98Aiq.n09pzX/tNr7fpV8Iwnhq',1,'2026-05-13 20:41:53','2026-05-14 01:41:41','2026-05-14 01:41:53');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'proyecto_muebles'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-13 21:05:08
