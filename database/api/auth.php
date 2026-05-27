<?php
/**
 * API de Autenticación - Calidad el Paisa
 * POST action=register: Registrar nuevo usuario
 * POST action=login: Iniciar sesión
 * POST action=recovery: Solicitar recuperación de contraseña
 */
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once __DIR__ . '/../conexion.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

$action = $_POST['action'] ?? '';

// ---------- REGISTRO ----------
if ($action === 'register') {
    $nombre = trim($_POST['nombre'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($nombre) || empty($email) || empty($password)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Todos los campos son obligatorios']);
        exit;
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Correo electrónico inválido']);
        exit;
    }

    if (strlen($password) < 6) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'La contraseña debe tener al menos 6 caracteres']);
        exit;
    }

    $stmt = $conexion->prepare("SELECT id_usuario FROM usuarios WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        http_response_code(409);
        echo json_encode(['success' => false, 'message' => 'El correo electrónico ya está registrado']);
        $stmt->close();
        exit;
    }
    $stmt->close();

    $password_hash = password_hash($password, PASSWORD_BCRYPT);

    $stmt = $conexion->prepare("INSERT INTO usuarios (nombre, email, password_hash) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $nombre, $email, $password_hash);

    if ($stmt->execute()) {
        $id_usuario = $conexion->insert_id;
        echo json_encode([
            'success' => true,
            'message' => 'Registro exitoso',
            'user' => ['id' => $id_usuario, 'nombre' => $nombre, 'email' => $email, 'rol' => 'cliente']
        ]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error al registrar usuario']);
    }
    $stmt->close();
}

// ---------- LOGIN ----------
elseif ($action === 'login') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    if (empty($email) || empty($password)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Completa todos los campos']);
        exit;
    }

    $stmt = $conexion->prepare("SELECT id_usuario, nombre, email, password_hash, rol FROM usuarios WHERE email = ? AND activo = 1");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if (!$user) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Usuario no encontrado']);
        $stmt->close();
        exit;
    }

    if (!password_verify($password, $user['password_hash'])) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Contraseña incorrecta']);
        $stmt->close();
        exit;
    }

    $stmt->close();

    $updateStmt = $conexion->prepare("UPDATE usuarios SET ultimo_acceso = NOW() WHERE id_usuario = ?");
    $updateStmt->bind_param("i", $user['id_usuario']);
    $updateStmt->execute();
    $updateStmt->close();

    echo json_encode([
        'success' => true,
        'message' => 'Inicio de sesión exitoso',
        'user' => [
            'id' => $user['id_usuario'],
            'nombre' => $user['nombre'],
            'email' => $user['email'],
            'rol' => $user['rol']
        ]
    ]);
}

// ---------- RECUPERACION ----------
elseif ($action === 'recovery') {
    $email = trim($_POST['email'] ?? '');

    if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Ingresa un correo válido']);
        exit;
    }

    $stmt = $conexion->prepare("SELECT id_usuario, email FROM usuarios WHERE email = ? AND activo = 1");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if (!$user) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'No encontramos una cuenta con ese correo']);
        $stmt->close();
        exit;
    }
    $stmt->close();

    $token = bin2hex(random_bytes(32));
    $expiracion = date('Y-m-d H:i:s', strtotime('+1 hour'));

    $stmt = $conexion->prepare("INSERT INTO tokens_recuperacion (id_usuario, email, token, expiracion) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("isss", $user['id_usuario'], $user['email'], $token, $expiracion);
    $stmt->execute();
    $stmt->close();

    echo json_encode([
        'success' => true,
        'message' => "Instrucciones enviadas a {$email}. Revisa tu bandeja.",
        'token' => $token // En producción se enviaría por email
    ]);
}

else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Acción no válida']);
}

$conexion->close();
