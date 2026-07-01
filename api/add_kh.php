<?php
header('Content-Type: application/json');
date_default_timezone_set('Asia/Ho_Chi_Minh');
require_once '../config/db.php'; 

$input = json_decode(file_get_contents("php://input"), true);

if (!empty($input['ho_ten']) && !empty($input['sdt']) && !empty($input['mat_khau'])) {
    $ho_ten = $conn->real_escape_string($input['ho_ten']);
    $email = $conn->real_escape_string($input['email']);
    $sdt = $conn->real_escape_string($input['sdt']);
    
    // Mã hóa mật khẩu để bảo mật (dùng password_hash)
    $mat_khau = password_hash($input['mat_khau'], PASSWORD_DEFAULT);
    
    $vai_tro = 'khach_hang';
    $ngay_tao = date('Y-m-d H:i:s');

    if (!preg_match('/^0\d{9}$/', $sdt)) {
        echo json_encode([
            'success' => false,
            'error' => 'Số điện thoại không hợp lệ'
        ]);
        exit;
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            'success' => false,
            'error' => 'Email không hợp lệ'
        ]);
        exit;
    }
    // Kiểm tra trùng SĐT
    $check = $conn->query("SELECT user_id FROM users WHERE sdt = '$sdt'");
    if ($check->num_rows > 0) {
        echo json_encode([
            "success" => false,
            "error" => "Số điện thoại này đã tồn tại!"
        ]);
        exit;
    }

    // Câu lệnh SQL thêm mật khẩu
    $sql = "INSERT INTO users (ho_ten, email, sdt, mat_khau, vai_tro, ngay_tao) 
            VALUES ('$ho_ten', '$email', '$sdt', '$mat_khau', '$vai_tro', '$ngay_tao')";

    if ($conn->query($sql)) {
        echo json_encode([
            "success" => true
            ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Lỗi SQL: " . $conn->error
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Vui lòng nhập đầy đủ Họ tên, SĐT và Mật khẩu"
    ]);
}

$conn->close();
?>