<?php
/**
 * API de Newsletter - Calidad el Paisa
 * POST: Suscribir email al newsletter
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

$nombre = trim($_POST['nombre'] ?? '');
$email = trim($_POST['email'] ?? '');

if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Correo electrónico válido requerido']);
    exit;
}

$stmt = $conexion->prepare("SELECT id_suscriptor FROM newsletter WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(['success' => true, 'message' => 'Ya estás suscrito a nuestro newsletter']);
    $stmt->close();
    $conexion->close();
    exit;
}
$stmt->close();

$stmt = $conexion->prepare("INSERT INTO newsletter (nombre, email) VALUES (?, ?)");
$stmt->bind_param("ss", $nombre, $email);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Suscripción exitosa']);
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error al suscribir']);
}

$stmt->close();
$conexion->close();
