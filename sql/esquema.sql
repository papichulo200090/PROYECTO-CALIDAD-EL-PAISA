-- ============================================================
-- ESQUEMA DE BASE DE DATOS: proyecto_muebles
-- Nombre del proyecto: Calidad el Paisa
-- Descripción: Base de datos para tienda de muebles en Cali, Colombia
-- Fecha: 2026-05-13
-- ============================================================

CREATE DATABASE IF NOT EXISTS proyecto_muebles
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE proyecto_muebles;

-- ============================================================
-- 1. CATEGORIAS DE PROYECTOS
-- ============================================================
CREATE TABLE IF NOT EXISTS categorias_proyecto (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    css_filter VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO categorias_proyecto (nombre, codigo, css_filter) VALUES
('Completados', 'completado', '.first'),
('En curso', 'en_curso', '.second'),
('Próximos', 'proximo', '.third');

-- ============================================================
-- 2. CATEGORIAS DE BLOG
-- ============================================================
CREATE TABLE IF NOT EXISTS categorias_blog (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO categorias_blog (nombre, slug) VALUES
('Web Design', 'web-design'),
('Web Development', 'web-development'),
('Online Marketing', 'online-marketing'),
('Keyword Research', 'keyword-research'),
('Email Marketing', 'email-marketing');

-- ============================================================
-- 3. METODOS DE PAGO
-- ============================================================
CREATE TABLE IF NOT EXISTS metodos_pago (
    id_metodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(300),
    requiere_datos_adicionales TINYINT(1) DEFAULT 0,
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO metodos_pago (nombre, codigo, descripcion) VALUES
('Tarjeta de crédito/débito', 'tarjeta', 'Visa, Mastercard, American Express'),
('Pago contraentrega', 'contraentrega', 'Pagas en efectivo al recibir tu pedido'),
('Transferencia bancaria / Nequi', 'transferencia', 'Bancolombia, Daviplata, Nequi');

-- ============================================================
-- 4. CONFIGURACION (Empresa / Ajustes)
-- ============================================================
CREATE TABLE IF NOT EXISTS configuracion (
    id_config INT AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT,
    descripcion VARCHAR(300),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO configuracion (clave, valor, descripcion) VALUES
('nombre_empresa', 'Calidad el paisa', 'Nombre de la empresa'),
('direccion', 'Carrera 70 No. 2b-08, Cali, Colombia', 'Dirección física'),
('telefono', '322 695 3819', 'Teléfono de contacto'),
('email', 'calidadpaisa@gmail.com', 'Correo de contacto'),
('facebook_url', 'https://www.facebook.com/people/Muebles-y-colchones-Calidad-el-Paisa/100066455125406/', 'URL de Facebook'),
('instagram_url', 'https://www.instagram.com/calidadelpaisa/', 'URL de Instagram'),
('cuenta_bancolombia', 'Cuenta de ahorros Bancolombia #123-456-789', 'Número de cuenta Bancolombia'),
('nequi', '3226953819', 'Número Nequi'),
('email_pago', 'calidadpaisa@gmail.com', 'Correo para confirmaciones de pago');

-- ============================================================
-- 5. USUARIOS
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    activo TINYINT(1) DEFAULT 1,
    ultimo_acceso DATETIME NULL,
    rol ENUM('admin','cliente') NOT NULL DEFAULT 'cliente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 6. TOKENS DE RECUPERACION DE CONTRASEÑA
-- ============================================================
CREATE TABLE IF NOT EXISTS tokens_recuperacion (
    id_token INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    email VARCHAR(200) NOT NULL,
    token VARCHAR(100) NOT NULL,
    usado TINYINT(1) DEFAULT 0,
    expiracion DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 7. PRODUCTOS
-- ============================================================
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(12,0) NOT NULL,
    imagen_url VARCHAR(500),
    categoria VARCHAR(100),
    stock INT DEFAULT 0,
    destacado TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO productos (nombre, descripcion, precio, imagen_url, categoria, stock, destacado) VALUES
('Silla Roble', 'Silla de madera maciza, acabado natural.', 189900, 'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80', 'sillas', 15, 1),
('Mesa Comedor Extensible', 'Mesa de comedor extensible para 6 personas.', 459900, 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80', 'mesas', 8, 1),
('Armario 3 Cuerpos', 'Armario amplio con 3 cuerpos y espejo.', 789900, 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80', 'armarios', 5, 0),
('Cómoda 6 Cajones', 'Cómoda espaciosa con 6 cajones.', 329900, 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80', 'comodas', 10, 0),
('Sillón Relax', 'Sillón ergonómico con reposapiés.', 599900, 'https://images.unsplash.com/photo-1616627547584-bf28cee262db?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80', 'sillas', 6, 1),
('Estante Rústico', 'Estante de madera rústica con 4 niveles.', 149900, 'https://images.unsplash.com/photo-1519643381401-22c77e60520e?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80', 'estantes', 20, 0),
('Closet 2x2', 'Closet espacioso de 2 cuerpos con acabado premium.', 1310000, 'img/closet2x2-1310000.jpeg', 'armarios', 10, 1),
('Sala Infinity', 'Sala Infinity con diseño moderno y cojines ergonómicos.', 1850000, 'img/sala_infinity_1850000.jpeg', 'salas', 8, 1),
('Multialacena', 'Multialacena funcional con múltiples compartimentos.', 630000, 'img/multialacena-630.jpeg', 'armarios', 12, 1),
('Sala Tokio Escualizable', 'Sala Tokio escualizable, elegante y versátil.', 1850000, 'img/sala-tokio_escualizable_1850000.jpeg', 'salas', 5, 1),
('Sala Begonia', 'Sala Begonia con tapizado suave y estructura reforzada.', 1850000, 'img/salabegonia_1850000.jpeg', 'salas', 6, 1),
('Solterón Hollywood', 'Solterón Hollywood con cabecero acojinado y diseño clásico.', 550000, 'img/solteronhollywood_550000.jpeg', 'camas', 15, 1),
('Mesa TV', 'Mesa para TV con amplio espacio para equipos y decoración.', 490000, 'img/mesaTv_490000.jpeg', 'mesas', 20, 1),
('Tocador Reyna', 'Tocador Reyna con espejo y múltiples cajones.', 550000, 'img/tocador-reyna_550000.jpeg', 'comodas', 10, 1);

-- ============================================================
-- 8. SERVICIOS
-- ============================================================
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion_corta VARCHAR(300),
    descripcion_larga TEXT,
    icono_css VARCHAR(100),
    imagen_url VARCHAR(500),
    activo TINYINT(1) DEFAULT 1,
    orden INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO servicios (nombre, descripcion_corta, icono_css, orden) VALUES
('Diseño de dormitorios', 'Camas, armarios y cabeceros personalizados.', 'flaticon-bedroom', 1),
('Diseño de cocinas', 'Mobiliario funcional y estético.', 'flaticon-kitchen', 2),
('Diseño de baños', 'Muebles de baño en madera tratada.', 'flaticon-bathroom', 3);

-- ============================================================
-- 9. PROYECTOS (Portafolio)
-- ============================================================
CREATE TABLE IF NOT EXISTS proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    imagen_url VARCHAR(500),
    id_categoria INT NOT NULL,
    estado ENUM('completado','en_curso','proximo') DEFAULT 'completado',
    fecha_completado DATE NULL,
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES categorias_proyecto(id_categoria) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO proyectos (nombre, id_categoria, estado, imagen_url) VALUES
('Sala de estar', 1, 'completado', 'img/portfolio-1.jpg'),
('Comedor rústico', 2, 'en_curso', 'img/portfolio-2.jpg'),
('Oficina en casa', 3, 'proximo', 'img/portfolio-3.jpg'),
('Dormitorio principal', 1, 'completado', 'img/portfolio-4.jpg'),
('Sala infantil', 2, 'en_curso', 'img/portfolio-5.jpg'),
('Terraza', 3, 'proximo', 'img/portfolio-6.jpg');

-- ============================================================
-- 10. BLOG POSTS
-- ============================================================
CREATE TABLE IF NOT EXISTS blog_posts (
    id_post INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(300) NOT NULL,
    contenido LONGTEXT,
    resumen VARCHAR(500),
    imagen_principal VARCHAR(500),
    id_autor INT NULL,
    id_categoria_blog INT NULL,
    num_comentarios INT DEFAULT 0,
    slug VARCHAR(300) NOT NULL UNIQUE,
    estado ENUM('borrador','publicado') DEFAULT 'publicado',
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_autor) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_categoria_blog) REFERENCES categorias_blog(id_categoria) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- 11. COMENTARIOS (Blog)
-- ============================================================
CREATE TABLE IF NOT EXISTS comentarios (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_post INT NOT NULL,
    id_usuario INT NULL,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(200),
    sitio_web VARCHAR(300),
    contenido TEXT NOT NULL,
    id_comentario_padre INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_post) REFERENCES blog_posts(id_post) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_comentario_padre) REFERENCES comentarios(id_comentario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 12. PEDIDOS
-- ============================================================
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,
    nombre_cliente VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion_entrega VARCHAR(300) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20),
    subtotal DECIMAL(12,0) NOT NULL,
    costo_envio DECIMAL(10,0) DEFAULT 0,
    total DECIMAL(12,0) NOT NULL,
    id_metodo_pago INT NOT NULL,
    estado ENUM('pendiente','confirmado','enviado','entregado','cancelado') DEFAULT 'pendiente',
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago(id_metodo) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 13. DETALLE DE PEDIDO
-- ============================================================
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    nombre_producto VARCHAR(150) NOT NULL,
    precio_unitario DECIMAL(12,0) NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(12,0) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 14. PAGOS
-- ============================================================
CREATE TABLE IF NOT EXISTS pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    monto DECIMAL(12,0) NOT NULL,
    numero_tarjeta VARCHAR(20),
    nombre_tarjeta VARCHAR(150),
    numero_comprobante VARCHAR(100),
    estado ENUM('pendiente','completado','fallido') DEFAULT 'pendiente',
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago(id_metodo) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 15. CARRITO (Carrito de compras persistido)
-- ============================================================
CREATE TABLE IF NOT EXISTS carrito (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 16. CONTACTOS (Formulario de contacto)
-- ============================================================
CREATE TABLE IF NOT EXISTS contactos (
    id_contacto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL,
    asunto VARCHAR(300) NOT NULL,
    mensaje TEXT NOT NULL,
    leido TINYINT(1) DEFAULT 0,
    fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 17. NEWSLETTER
-- ============================================================
CREATE TABLE IF NOT EXISTS newsletter (
    id_suscriptor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150),
    email VARCHAR(200) NOT NULL UNIQUE,
    activo TINYINT(1) DEFAULT 1,
    fecha_suscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_baja DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 18. EQUIPO (Miembros del equipo)
-- ============================================================
CREATE TABLE IF NOT EXISTS equipo (
    id_miembro INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    cargo VARCHAR(150) NOT NULL,
    foto_url VARCHAR(500),
    twitter_url VARCHAR(300),
    facebook_url VARCHAR(300),
    linkedin_url VARCHAR(300),
    activo TINYINT(1) DEFAULT 1,
    orden INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO equipo (nombre, cargo, foto_url, orden) VALUES
('Donald John', 'CEO & Founder', 'img/team-1.jpg', 1),
('Adam Phillips', 'Interior Designer', 'img/team-2.jpg', 2),
('Olive Yew', 'Creative Director', 'img/team-3.jpg', 3),
('Thomas Clark', 'Project Manager', 'img/team-4.jpg', 4);

-- ============================================================
-- 19. TESTIMONIOS
-- ============================================================
CREATE TABLE IF NOT EXISTS testimonios (
    id_testimonio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(150) NOT NULL,
    profesion VARCHAR(150) NOT NULL,
    foto_url VARCHAR(500),
    contenido TEXT NOT NULL,
    calificacion TINYINT DEFAULT 5,
    activo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO testimonios (nombre_cliente, profesion, foto_url, contenido, calificacion) VALUES
('María García', 'Ama de casa', 'img/testimonial-1.jpg', 'Excelente calidad en los muebles. Compré una sala completa y quedó hermosa. Muy recomendados.', 5),
('Carlos López', 'Empresario', 'img/testimonial-2.jpg', 'Los muebles de madera son de muy buena calidad. El servicio de entrega fue puntual y profesional.', 5);

-- ============================================================
-- OTORGAR PRIVILEGIOS AL USUARIO santi
-- ============================================================
GRANT ALL PRIVILEGES ON proyecto_muebles.* TO 'santi'@'localhost';
FLUSH PRIVILEGES;
