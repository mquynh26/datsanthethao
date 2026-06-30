<?php
header('Content-Type: application/json; charset=utf-8');
require_once '../config/db.php';

try {
    if (!isset($_GET['san_id']) || !isset($_GET['ngay'])) {
        echo json_encode([
            'success' => false,
            'error' => 'Thiếu tham số san_id hoặc ngày'
        ]);
        exit;
    }

    $san_id = intval($_GET['san_id']);
    $ngay = $conn->real_escape_string($_GET['ngay']);

    $sql = "SELECT kg.khung_gio_id, kg.gio_bat_dau, kg.gio_ket_thuc, gia,
                    CASE 
                       WHEN EXISTS (SELECT 1 FROM dat_san ds WHERE ds.khung_gio_id = kg.khung_gio_id AND ds.ngay_dat = '$ngay' AND ds.trang_thai IN ('cho_xac_nhan', 'da_xac_nhan')
                       ) THEN 'da_dat'
                       ELSE 'trong' 
                    END AS trang_thai
            FROM khung_gio kg
            WHERE kg.san_id = $san_id
            ORDER BY kg.gio_bat_dau";

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
