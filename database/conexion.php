<?php
/**
 * Conexión a la base de datos proyecto_muebles
 * Proyecto: Calidad el Paisa
 */

define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'proyecto_muebles');
define('DB_CHARSET', 'utf8mb4');

$conexion = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if ($conexion->connect_error) {
    die("Error de conexión: " . $conexion->connect_error);
}

$conexion->set_charset(DB_CHARSET);
