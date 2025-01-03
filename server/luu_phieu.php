<?php
require 'config/db.php';
header("Content-Type: application/json");

// Lấy dữ liệu JSON từ request body
$rawInput = file_get_contents("php://input");
$data = json_decode($rawInput, true);

// Kiểm tra xem JSON có lỗi không
if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode([
        "error" => "Invalid JSON",
        'loi'=>1,
        'txt_loi'=>'Invalid JSON',
        "details" => json_last_error_msg(),
        "raw_input" => $rawInput
    ]);
    exit();
}


try {
    // Kết nối MongoDB
    $db = new DBConnection();
    $collection = $db->getCollection('test_app');

  
    // Tạo người dùng mới
    $new_row = [
        'data' => $data,
        'created_at' => new MongoDB\BSON\UTCDateTime()
    ];

    $collection->insertOne($new_row);
    $res=["message" => "User registered successfully", 'loi'=>0,
    'txt_loi'=>'Invalid JSON','ma_phieu'=>"PX2366031"];
    //$res['loi']=1;
    //$res['txt_loi']="test";
    echo json_encode($res);
} catch (Exception $e) {
    // Hiển thị thông báo lỗi nếu có
    echo json_encode([
        "error" => "Database operation failed",
        "details" => $e->getMessage()
    ]);
    exit();
}
