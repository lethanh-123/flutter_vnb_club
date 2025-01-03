<?php
require 'config/db.php';

header("Content-Type: application/json");

$rawInput = file_get_contents("php://input");
$data = json_decode($rawInput, true);

if (!isset($data['email']) || !isset($data['password']) || !isset($data['name'])) {
    echo json_encode([
        "error" => "Missing name, email, or password"
    ]);
    exit();
}

try {
    $db = new DBConnection();
    $collection = $db->getCollection('users');

    $existingUser = $collection->findOne(['email' => $data['email']]);
    if ($existingUser) {
        echo json_encode(["error" => "User already exists"]);
        exit();
    }

    $newUser = [
        'name' => $data['name'],
        'email' => $data['email'],
        'password' => password_hash($data['password'], PASSWORD_BCRYPT),
        'created_at' => new MongoDB\BSON\UTCDateTime()
    ];

    $collection->insertOne($newUser);

    echo json_encode([ "success" => true, "message" => "User registered successfully"]);
} catch (Exception $e) {
    echo json_encode([
        "error" => "Database error",
        "details" => $e->getMessage()
    ]);
}
?>
