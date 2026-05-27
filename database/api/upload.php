<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once __DIR__ . '/../conexion.php';

$userId = isset($_POST['user_id']) ? (int)$_POST['user_id'] : 0;

if (!$userId) {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Acceso denegado']);
    exit;
}

$stmt = $conexion->prepare("SELECT rol FROM usuarios WHERE id_usuario = ? AND activo = 1");
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();
$stmt->close();

if (!$user || $user['rol'] !== 'admin') {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Acceso denegado']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_FILES['imagen'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'No se envió ninguna imagen']);
    exit;
}

$file = $_FILES['imagen'];
$allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
$maxSize = 5 * 1024 * 1024; // 5MB

if ($file['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Error al subir el archivo']);
    exit;
}

if (!in_array($file['type'], $allowedTypes)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Tipo de archivo no permitido. Usa JPG, PNG, GIF o WebP']);
    exit;
}

if ($file['size'] > $maxSize) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'La imagen supera los 5MB']);
    exit;
}

$ext = pathinfo($file['name'], PATHINFO_EXTENSION);
$filename = uniqid('prod_') . '.' . $ext;
$uploadDir = __DIR__ . '/../uploads/';
$destPath = $uploadDir . $filename;

if (!move_uploaded_file($file['tmp_name'], $destPath)) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error al guardar la imagen']);
    exit;
}

$url = 'uploads/' . $filename;

echo json_encode(['success' => true, 'url' => $url, 'message' => 'Imagen subida correctamente']);