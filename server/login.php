<?php
require 'config/db.php';

header("Content-Type: application/json");

$rawInput = file_get_contents("php://input");
$data = json_decode($rawInput, true);

if (!isset($data['email']) || !isset($data['password'])) {
    echo json_encode([
        "error" => "Missing email or password"
    ]);
    exit();
}

try {
    $db = new DBConnection();
    $collection = $db->getCollection('users');

    $user = $collection->findOne(['email' => $data['email']]);

    if (!$user || !password_verify($data['password'], $user['password'])) {
        echo json_encode(["error" => "Invalid email or password"]);
        exit();
    }

    echo json_encode([
        "success" => true,
        "message" => "Login successful",
        "user" => [
            "id" => (string)$user['_id'],
            "name" => $user['name'],
            "email" => $user['email']
        ]
    ]);
} catch (Exception $e) {
    echo json_encode([
        "error" => "Database error",
        "details" => $e->getMessage()
    ]);
}
?>
