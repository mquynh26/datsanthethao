<?php 
header('Content-Type: application/json; charset=utf-8');
require_once '../config/db.php';

try {
    if (!isset($_GET['khu_vuc_id'])) {
        echo json_encode([
            'success' => false,
            'error' => 'Thiếu tham số khu_vuc_id'
        ]);
        exit;
    }

    $khu_vuc_id = intval($_GET['khu_vuc_id']);

    $sql = "SELECT san_id, khu_vuc_id, ten_san, trang_thai
            FROM san
            WHERE san.khu_vuc_id = $khu_vuc_id AND san.trang_thai != 'bao_tri'
            ORDER BY ten_san";

    $result = $conn->query($sql);

    if (!$result) {
        echo json_encode([
            'success' => false,
            'error' => $conn->error
        ]);
        exit;
    }

    $data = [];

    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode([
        'success' => true,
        'data' => $data
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
