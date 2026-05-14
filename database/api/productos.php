<?php
/**
 * API de Productos - Calidad el Paisa
 * GET: Obtener todos los productos
 * GET ?id=X: Obtener un producto específico
 * GET ?search=termino: Buscar productos
 */
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once __DIR__ . '/../conexion.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    if (isset($_GET['id'])) {
        $id = (int) $_GET['id'];
        $stmt = $conexion->prepare("SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock, destacado FROM productos WHERE id_producto = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $producto = $result->fetch_assoc();

        if ($producto) {
            $producto['precio'] = (int) $producto['precio'];
            echo json_encode(['success' => true, 'producto' => $producto]);
        } else {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'Producto no encontrado']);
        }
        $stmt->close();
    } elseif (isset($_GET['search'])) {
        $search = '%' . $conexion->real_escape_string($_GET['search']) . '%';
        $stmt = $conexion->prepare("SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock, destacado FROM productos WHERE nombre LIKE ? OR descripcion LIKE ?");
        $stmt->bind_param("ss", $search, $search);
        $stmt->execute();
        $result = $stmt->get_result();
        $productos = [];
        while ($row = $result->fetch_assoc()) {
            $row['precio'] = (int) $row['precio'];
            $productos[] = $row;
        }
        echo json_encode(['success' => true, 'productos' => $productos]);
        $stmt->close();
    } else {
        $result = $conexion->query("SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock, destacado FROM productos ORDER BY id_producto");
        $productos = [];
        while ($row = $result->fetch_assoc()) {
            $row['precio'] = (int) $row['precio'];
            $productos[] = $row;
        }
        echo json_encode(['success' => true, 'productos' => $productos]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}

$conexion->close();
