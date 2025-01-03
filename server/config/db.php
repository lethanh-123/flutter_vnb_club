<?php
require 'vendor/autoload.php';

class DBConnection {
    private $client;
    private $db;

    public function __construct() {
        try {
            // Kiểm tra kết nối MongoDB
            $this->client = new MongoDB\Client("mongodb://localhost:27017");
            $this->db = $this->client->selectDatabase('vnb_club');
        } catch (Exception $e) {
            // In thông báo lỗi nếu kết nối thất bại
            echo "Error: " . $e->getMessage();
            exit();
        }
    }

    public function getCollection($collectionName) {
        return $this->db->selectCollection($collectionName);
    }
}
