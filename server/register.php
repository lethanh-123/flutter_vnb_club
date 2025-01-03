<?php
require 'config/db.php';
if (isset($_REQUEST['debug']))
{
    ini_set('display_errors', '1');
    ini_set('display_startup_errors', '1');
    error_reporting(E_ALL); // Hiển thị mọi lỗi
}
header("Content-Type: application/json");

// Giả lập `$_SERVER['REQUEST_METHOD']` trong môi trường CLI
if (php_sapi_name() == "cli") {
    $_SERVER['REQUEST_METHOD'] = 'POST'; // Giả lập phương thức POST
    // Giả lập dữ liệu JSON đầu vào
    $data = [
        'name' => 'Le Thanh',
        'email' => 'lethanh@example.com',
        'password' => '123456'
    ];
} else {
    // Lấy dữ liệu JSON từ request body
    $rawInput = file_get_contents("php://input");
    $data = json_decode($rawInput, true);

    // Kiểm tra xem JSON có lỗi không
    if (json_last_error() !== JSON_ERROR_NONE) {
        echo json_encode([
            "error" => "Invalid JSON",
            "details" => json_last_error_msg(),
            "raw_input" => $rawInput
        ]);
        exit();
    }
}

// Kiểm tra dữ liệu đầu vào
if (!isset($data['email']) || !isset($data['password']) || !isset($data['name'])) {
    echo json_encode([
        "error" => "Invalid input",
        "received_data" => $data
    ]);
    exit();
}

try {
    // Kết nối MongoDB
    $db = new DBConnection();
    $collection = $db->getCollection('users');

    // Kiểm tra người dùng đã tồn tại
    $existingUser = $collection->findOne(['email' => $data['email']]);
    if ($existingUser) {
        echo json_encode(["error" => "User already exists"]);
        exit();
    }

    // Tạo người dùng mới
    $newUser = [
        'name' => $data['name'],
        'email' => $data['email'],
        'password' => password_hash($data['password'], PASSWORD_BCRYPT),
        'created_at' => new MongoDB\BSON\UTCDateTime()
    ];

    $collection->insertOne($newUser);

    echo json_encode(["message" => "User registered successfully"]);
} catch (Exception $e) {
    // Hiển thị thông báo lỗi nếu có
    echo json_encode([
        "error" => "Database operation failed",
        "details" => $e->getMessage()
    ]);
    exit();
}
