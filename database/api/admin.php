<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');

require_once __DIR__ . '/../conexion.php';

function verificarAdmin($conexion, $userId) {
    $stmt = $conexion->prepare("SELECT rol FROM usuarios WHERE id_usuario = ? AND activo = 1");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    $stmt->close();
    return $user && $user['rol'] === 'admin';
}

$action = $_GET['action'] ?? $_POST['action'] ?? '';
$userId = isset($_GET['user_id']) ? (int)$_GET['user_id'] : (isset($_POST['user_id']) ? (int)$_POST['user_id'] : 0);

if (!$userId || !verificarAdmin($conexion, $userId)) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Acceso denegado']);
    exit;
}

if ($action === 'get_productos') {
    $result = $conexion->query("SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock, destacado, created_at FROM productos ORDER BY id_producto DESC");
    $productos = [];
    while ($row = $result->fetch_assoc()) {
        $row['precio'] = (int) $row['precio'];
        $productos[] = $row;
    }
    echo json_encode(['success' => true, 'productos' => $productos]);

} elseif ($action === 'crear_producto') {
    $nombre = trim($_POST['nombre'] ?? '');
    $descripcion = trim($_POST['descripcion'] ?? '');
    $precio = (int) ($_POST['precio'] ?? 0);
    $imagen_url = trim($_POST['imagen_url'] ?? '');
    $categoria = trim($_POST['categoria'] ?? '');
    $stock = (int) ($_POST['stock'] ?? 0);

    if (empty($nombre) || $precio <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Nombre y precio son obligatorios']);
        exit;
    }

    $stmt = $conexion->prepare("INSERT INTO productos (nombre, descripcion, precio, imagen_url, categoria, stock) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssissi", $nombre, $descripcion, $precio, $imagen_url, $categoria, $stock);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Producto creado', 'id_producto' => $conexion->insert_id]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al crear producto']);
    }
    $stmt->close();

} elseif ($action === 'actualizar_producto') {
    $id = (int) ($_POST['id_producto'] ?? 0);
    $nombre = trim($_POST['nombre'] ?? '');
    $descripcion = trim($_POST['descripcion'] ?? '');
    $precio = (int) ($_POST['precio'] ?? 0);
    $imagen_url = trim($_POST['imagen_url'] ?? '');
    $categoria = trim($_POST['categoria'] ?? '');
    $stock = (int) ($_POST['stock'] ?? 0);

    if (!$id || empty($nombre) || $precio <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
        exit;
    }

    $stmt = $conexion->prepare("UPDATE productos SET nombre=?, descripcion=?, precio=?, imagen_url=?, categoria=?, stock=? WHERE id_producto=?");
    $stmt->bind_param("ssissii", $nombre, $descripcion, $precio, $imagen_url, $categoria, $stock, $id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Producto actualizado']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al actualizar producto']);
    }
    $stmt->close();

} elseif ($action === 'eliminar_producto') {
    $id = (int) ($_POST['id_producto'] ?? 0);

    if (!$id) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID inválido']);
        exit;
    }

    $stmt = $conexion->prepare("DELETE FROM productos WHERE id_producto = ?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Producto eliminado']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al eliminar producto']);
    }
    $stmt->close();

} elseif ($action === 'get_pedidos') {
    $result = $conexion->query("SELECT p.id_pedido, p.nombre_cliente, p.telefono, p.total, p.estado, p.fecha_pedido, mp.nombre AS metodo_pago FROM pedidos p LEFT JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo ORDER BY p.fecha_pedido DESC");
    $pedidos = [];
    while ($row = $result->fetch_assoc()) {
        $row['total'] = (int) $row['total'];
        $pedidos[] = $row;
    }
    echo json_encode(['success' => true, 'pedidos' => $pedidos]);

} elseif ($action === 'get_detalle_pedido') {
    $id = (int) ($_GET['id_pedido'] ?? 0);
    if (!$id) { http_response_code(400); echo json_encode(['success' => false, 'message' => 'ID inválido']); exit; }

    $stmt = $conexion->prepare("SELECT dp.id_detalle, dp.nombre_producto, dp.precio_unitario, dp.cantidad, dp.subtotal FROM detalle_pedido dp WHERE dp.id_pedido = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    $items = [];
    while ($row = $result->fetch_assoc()) {
        $row['precio_unitario'] = (int) $row['precio_unitario'];
        $row['subtotal'] = (int) $row['subtotal'];
        $items[] = $row;
    }
    $stmt->close();
    echo json_encode(['success' => true, 'items' => $items]);

} elseif ($action === 'actualizar_estado_pedido') {
    $id = (int) ($_POST['id_pedido'] ?? 0);
    $estado = $_POST['estado'] ?? '';
    $estadosValidos = ['pendiente', 'confirmado', 'enviado', 'entregado', 'cancelado'];

    if (!$id || !in_array($estado, $estadosValidos)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
        exit;
    }

    $stmt = $conexion->prepare("UPDATE pedidos SET estado = ? WHERE id_pedido = ?");
    $stmt->bind_param("si", $estado, $id);
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Estado actualizado']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al actualizar estado']);
    }
    $stmt->close();

} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Acción no válida']);
}

$conexion->close();