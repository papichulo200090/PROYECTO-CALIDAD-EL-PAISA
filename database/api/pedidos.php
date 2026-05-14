<?php
/**
 * API de Pedidos - Calidad el Paisa
 * POST: Crear un nuevo pedido con sus detalles
 * GET ?user_id=X: Obtener pedidos de un usuario
 */
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');

require_once __DIR__ . '/../conexion.php';

$method = $_SERVER['REQUEST_METHOD'];

// ---------- CREAR PEDIDO ----------
if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    if (!$input) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
        exit;
    }

    $id_usuario = isset($input['id_usuario']) ? (int) $input['id_usuario'] : null;
    $nombre_cliente = trim($input['nombre_cliente'] ?? '');
    $telefono = trim($input['telefono'] ?? '');
    $direccion_entrega = trim($input['direccion_entrega'] ?? '');
    $ciudad = trim($input['ciudad'] ?? '');
    $departamento = trim($input['departamento'] ?? '');
    $codigo_postal = trim($input['codigo_postal'] ?? '');
    $subtotal = (float) ($input['subtotal'] ?? 0);
    $costo_envio = (float) ($input['costo_envio'] ?? 0);
    $total = (float) ($input['total'] ?? 0);
    $id_metodo_pago = (int) ($input['id_metodo_pago'] ?? 1);
    $items = $input['items'] ?? [];

    if (empty($nombre_cliente) || empty($telefono) || empty($direccion_entrega) || empty($ciudad) || empty($departamento)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Completa todos los datos de envío']);
        exit;
    }

    if (empty($items)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'El carrito está vacío']);
        exit;
    }

    $conexion->begin_transaction();

    try {
        $stmt = $conexion->prepare(
            "INSERT INTO pedidos (id_usuario, nombre_cliente, telefono, direccion_entrega, ciudad, departamento, codigo_postal, subtotal, costo_envio, total, id_metodo_pago, estado)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')"
        );

        $id_usuario_null = $id_usuario ? $id_usuario : null;
        $stmt->bind_param(
            "issssssddii",
            $id_usuario_null,
            $nombre_cliente,
            $telefono,
            $direccion_entrega,
            $ciudad,
            $departamento,
            $codigo_postal,
            $subtotal,
            $costo_envio,
            $total,
            $id_metodo_pago
        );
        $stmt->execute();
        $id_pedido = $conexion->insert_id;
        $stmt->close();

        $stmt_detalle = $conexion->prepare(
            "INSERT INTO detalle_pedido (id_pedido, id_producto, nombre_producto, precio_unitario, cantidad, subtotal)
             VALUES (?, ?, ?, ?, ?, ?)"
        );

        foreach ($items as $item) {
            $id_producto = (int) ($item['id'] ?? 0);
            $nombre_producto = $item['name'] ?? '';
            $precio_unitario = (float) ($item['price'] ?? 0);
            $cantidad = (int) ($item['quantity'] ?? 1);
            $item_subtotal = $precio_unitario * $cantidad;

            $stmt_detalle->bind_param(
                "iisdid",
                $id_pedido,
                $id_producto,
                $nombre_producto,
                $precio_unitario,
                $cantidad,
                $item_subtotal
            );
            $stmt_detalle->execute();
        }
        $stmt_detalle->close();

        $stmt_pago = $conexion->prepare(
            "INSERT INTO pagos (id_pedido, id_metodo_pago, monto, estado) VALUES (?, ?, ?, 'pendiente')"
        );
        $stmt_pago->bind_param("iid", $id_pedido, $id_metodo_pago, $total);
        $stmt_pago->execute();
        $stmt_pago->close();

        $conexion->commit();

        echo json_encode([
            'success' => true,
            'message' => 'Pedido creado exitosamente',
            'pedido' => ['id_pedido' => $id_pedido, 'total' => $total, 'estado' => 'pendiente']
        ]);
    } catch (Exception $e) {
        $conexion->rollback();
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al crear el pedido: ' . $e->getMessage()]);
    }
}

// ---------- OBTENER PEDIDOS DE USUARIO ----------
elseif ($method === 'GET') {
    $id_usuario = isset($_GET['user_id']) ? (int) $_GET['user_id'] : 0;

    if ($id_usuario <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID de usuario requerido']);
        exit;
    }

    $stmt = $conexion->prepare(
        "SELECT p.id_pedido, p.nombre_cliente, p.total, p.estado, p.fecha_pedido, mp.nombre as metodo_pago
         FROM pedidos p
         JOIN metodos_pago mp ON p.id_metodo_pago = mp.id_metodo
         WHERE p.id_usuario = ?
         ORDER BY p.fecha_pedido DESC"
    );
    $stmt->bind_param("i", $id_usuario);
    $stmt->execute();
    $result = $stmt->get_result();

    $pedidos = [];
    while ($row = $result->fetch_assoc()) {
        $row['total'] = (int) $row['total'];
        $pedidos[] = $row;
    }
    $stmt->close();

    echo json_encode(['success' => true, 'pedidos' => $pedidos]);
}

else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}

$conexion->close();
