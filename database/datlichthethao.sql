-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 12, 2026 lúc 03:44 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `datlichthethao`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `auto_update_booking_status` ()   BEGIN
    -- Đơn chờ xác nhận quá giờ -> hủy
    UPDATE dat_san ds
    JOIN khung_gio kg 
        ON ds.khung_gio_id = kg.khung_gio_id
    SET ds.trang_thai = 'da_huy'
    WHERE ds.trang_thai = 'cho_xac_nhan'
      AND TIMESTAMP(ds.ngay_dat, kg.gio_ket_thuc) < NOW();

    -- Đơn đã xác nhận quá giờ -> hoàn thành
    UPDATE dat_san ds
    JOIN khung_gio kg 
        ON ds.khung_gio_id = kg.khung_gio_id
    SET ds.trang_thai = 'hoan_thanh'
    WHERE ds.trang_thai = 'da_xac_nhan'
      AND TIMESTAMP(ds.ngay_dat, kg.gio_ket_thuc) < NOW();
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chi_tiet_dich_vu`
--

CREATE TABLE `chi_tiet_dich_vu` (
  `chi_tiet_id` int(11) NOT NULL,
  `dat_san_id` int(11) NOT NULL,
  `dich_vu_id` int(11) NOT NULL,
  `so_luong` int(11) NOT NULL DEFAULT 1,
  `thanh_tien` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chi_tiet_dich_vu`
--

INSERT INTO `chi_tiet_dich_vu` (`chi_tiet_id`, `dat_san_id`, `dich_vu_id`, `so_luong`, `thanh_tien`) VALUES
(1, 1, 1, 1, 30000.00),
(3, 1, 2, 1, 15000.00),
(4, 2, 1, 1, 30000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `co_so`
--

CREATE TABLE `co_so` (
  `co_so_id` int(11) NOT NULL,
  `ten_co_so` varchar(100) NOT NULL,
  `dia_chi` text NOT NULL,
  `anh_bia` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `co_so`
--

INSERT INTO `co_so` (`co_so_id`, `ten_co_so`, `dia_chi`, `anh_bia`) VALUES
(1, 'Sân Cầu Lông UTT', '54 P. Triều Khúc, Thanh Xuân Nam, Thanh Liệt, Hà Nội', 'assets/img/cs_1775995746.jpg'),
(2, 'Sân Cầu UTT - Phú Thọ', 'Số 278 Lam Sơn, phường Vĩnh Yên, Phú Thọ', 'assets/img/cs_1775996171.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dat_san`
--

CREATE TABLE `dat_san` (
  `dat_san_id` int(11) NOT NULL,
  `khach_hang_id` int(11) NOT NULL,
  `san_id` int(11) NOT NULL,
  `khung_gio_id` int(11) NOT NULL,
  `ngay_dat` date NOT NULL,
  `tien_san` decimal(10,2) NOT NULL,
  `tien_dich_vu` decimal(10,2) DEFAULT 0.00,
  `tong_hoa_don` decimal(10,2) NOT NULL,
  `trang_thai` enum('cho_xac_nhan','da_xac_nhan','hoan_thanh','da_huy') DEFAULT 'cho_xac_nhan',
  `ngay_tao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `dat_san`
--

INSERT INTO `dat_san` (`dat_san_id`, `khach_hang_id`, `san_id`, `khung_gio_id`, `ngay_dat`, `tien_san`, `tien_dich_vu`, `tong_hoa_don`, `trang_thai`, `ngay_tao`) VALUES
(1, 1, 1, 4, '2026-04-10', 150000.00, 45000.00, 195000.00, 'hoan_thanh', '2026-04-08 11:12:28'),
(2, 1, 2, 6, '2026-04-11', 150000.00, 30000.00, 180000.00, 'hoan_thanh', '2026-04-08 11:12:28'),
(3, 1, 1, 3, '2026-04-10', 120000.00, 0.00, 120000.00, 'da_huy', '2026-04-10 13:37:38'),
(6, 1, 1, 3, '2026-04-10', 120000.00, 0.00, 120000.00, 'hoan_thanh', '2026-04-10 13:44:59'),
(7, 4, 3, 7, '2026-04-12', 130000.00, 0.00, 130000.00, 'da_xac_nhan', '2026-04-10 14:33:11'),
(8, 1, 1, 12, '2026-04-14', 60000.00, 0.00, 60000.00, 'cho_xac_nhan', '2026-04-12 11:56:27'),
(9, 1, 2, 5, '2026-04-13', 120000.00, 0.00, 120000.00, 'da_huy', '2026-04-12 11:58:03'),
(10, 8, 9, 23, '2026-04-12', 140000.00, 0.00, 140000.00, 'cho_xac_nhan', '2026-04-12 13:20:16'),
(11, 8, 20, 652, '2026-04-15', 100000.00, 0.00, 100000.00, 'da_xac_nhan', '2026-04-12 13:20:30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dich_vu`
--

CREATE TABLE `dich_vu` (
  `dich_vu_id` int(11) NOT NULL,
  `ten_dich_vu` varchar(100) NOT NULL,
  `loai_dich_vu` enum('thue_vot','mua_cau','khac') NOT NULL,
  `don_gia` decimal(10,2) NOT NULL,
  `don_vi` varchar(50) DEFAULT NULL,
  `mo_ta` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `dich_vu`
--

INSERT INTO `dich_vu` (`dich_vu_id`, `ten_dich_vu`, `loai_dich_vu`, `don_gia`, `don_vi`, `mo_ta`) VALUES
(1, 'Astrox 77 Pro', 'thue_vot', 30000.00, 'Cái', ''),
(2, 'Cầu Hải Yến', 'mua_cau', 150000.00, 'Ống', 'Ống 12 quả'),
(4, 'Cuốn Cán Yonex', 'khac', 15000.00, 'Cái', ''),
(5, 'Cầu Thành Công', 'mua_cau', 320000.00, 'Ống', 'Ống 12 quả'),
(6, 'Cuốn Cán VS', 'khac', 10000.00, 'Cái', ''),
(7, 'Cầu XSmash', 'mua_cau', 275000.00, 'Ống', '12 quả'),
(8, 'Astrox 100ZZ', 'thue_vot', 30000.00, 'Cái', ''),
(9, 'Arcsaber 11 Pro', 'thue_vot', 40000.00, 'Cái', ''),
(10, 'Axforce Cannon Pro', 'thue_vot', 50000.00, 'Cái', '');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hinh_anh_co_so`
--

CREATE TABLE `hinh_anh_co_so` (
  `hinh_id` int(11) NOT NULL,
  `co_so_id` int(11) NOT NULL,
  `duong_dan` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `hinh_anh_co_so`
--

INSERT INTO `hinh_anh_co_so` (`hinh_id`, `co_so_id`, `duong_dan`) VALUES
(9, 2, 'assets/img/cs2_1775996192_894.jpg'),
(10, 2, 'assets/img/cs2_1775996192_814.jpg'),
(11, 2, 'assets/img/cs2_1775996192_171.jpg'),
(12, 1, 'assets/img/cs1_1775996211_307.jpg'),
(13, 1, 'assets/img/cs1_1775996212_325.webp'),
(14, 1, 'assets/img/cs1_1775996212_328.jpg'),
(15, 1, 'assets/img/cs1_1775996212_878.jpg'),
(16, 2, 'assets/img/cs2_1775996225_881.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khung_gio`
--

CREATE TABLE `khung_gio` (
  `khung_gio_id` int(11) NOT NULL,
  `san_id` int(11) NOT NULL,
  `gio_bat_dau` time NOT NULL,
  `gio_ket_thuc` time NOT NULL,
  `gia` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `khung_gio`
--

INSERT INTO `khung_gio` (`khung_gio_id`, `san_id`, `gio_bat_dau`, `gio_ket_thuc`, `gia`) VALUES
(1, 1, '06:00:00', '08:00:00', 80000.00),
(2, 1, '08:00:00', '10:00:00', 80000.00),
(3, 1, '18:00:00', '20:00:00', 120000.00),
(4, 1, '20:00:00', '22:00:00', 150000.00),
(5, 2, '18:00:00', '20:00:00', 120000.00),
(6, 2, '20:00:00', '22:00:00', 150000.00),
(7, 3, '19:00:00', '21:00:00', 130000.00),
(8, 4, '20:00:00', '22:00:00', 240000.00),
(9, 1, '10:00:00', '12:00:00', 100000.00),
(11, 1, '12:00:00', '14:00:00', 100000.00),
(12, 1, '22:00:00', '23:00:00', 60000.00),
(13, 9, '00:00:00', '02:00:00', 100000.00),
(14, 9, '02:00:00', '04:00:00', 100000.00),
(15, 9, '04:00:00', '06:00:00', 100000.00),
(16, 9, '06:00:00', '08:00:00', 120000.00),
(17, 9, '08:00:00', '10:00:00', 120000.00),
(18, 9, '10:00:00', '11:30:00', 90000.00),
(19, 9, '13:00:00', '15:00:00', 120000.00),
(20, 9, '15:00:00', '17:00:00', 120000.00),
(21, 9, '17:00:00', '19:00:00', 160000.00),
(22, 9, '19:00:00', '21:00:00', 160000.00),
(23, 9, '21:00:00', '23:00:00', 140000.00),
(508, 5, '00:00:00', '02:00:00', 100000.00),
(509, 5, '02:00:00', '04:00:00', 100000.00),
(510, 5, '04:00:00', '06:00:00', 100000.00),
(511, 5, '06:00:00', '08:00:00', 120000.00),
(512, 5, '08:00:00', '10:00:00', 120000.00),
(513, 5, '10:00:00', '11:30:00', 90000.00),
(514, 5, '13:00:00', '15:00:00', 120000.00),
(515, 5, '15:00:00', '17:00:00', 120000.00),
(516, 5, '17:00:00', '19:00:00', 160000.00),
(517, 5, '19:00:00', '21:00:00', 160000.00),
(518, 5, '21:00:00', '23:00:00', 140000.00),
(519, 6, '00:00:00', '02:00:00', 100000.00),
(520, 6, '02:00:00', '04:00:00', 100000.00),
(521, 6, '04:00:00', '06:00:00', 100000.00),
(522, 6, '06:00:00', '08:00:00', 120000.00),
(523, 6, '08:00:00', '10:00:00', 120000.00),
(524, 6, '10:00:00', '11:30:00', 90000.00),
(525, 6, '13:00:00', '15:00:00', 120000.00),
(526, 6, '15:00:00', '17:00:00', 120000.00),
(527, 6, '17:00:00', '19:00:00', 160000.00),
(528, 6, '19:00:00', '21:00:00', 160000.00),
(529, 6, '21:00:00', '23:00:00', 140000.00),
(530, 8, '00:00:00', '02:00:00', 100000.00),
(531, 8, '02:00:00', '04:00:00', 100000.00),
(532, 8, '04:00:00', '06:00:00', 100000.00),
(533, 8, '06:00:00', '08:00:00', 120000.00),
(534, 8, '08:00:00', '10:00:00', 120000.00),
(535, 8, '10:00:00', '11:30:00', 90000.00),
(536, 8, '13:00:00', '15:00:00', 120000.00),
(537, 8, '15:00:00', '17:00:00', 120000.00),
(538, 8, '17:00:00', '19:00:00', 160000.00),
(539, 8, '19:00:00', '21:00:00', 160000.00),
(540, 8, '21:00:00', '23:00:00', 140000.00),
(541, 10, '00:00:00', '02:00:00', 100000.00),
(542, 10, '02:00:00', '04:00:00', 100000.00),
(543, 10, '04:00:00', '06:00:00', 100000.00),
(544, 10, '06:00:00', '08:00:00', 120000.00),
(545, 10, '08:00:00', '10:00:00', 120000.00),
(546, 10, '10:00:00', '11:30:00', 90000.00),
(547, 10, '13:00:00', '15:00:00', 120000.00),
(548, 10, '15:00:00', '17:00:00', 120000.00),
(549, 10, '17:00:00', '19:00:00', 160000.00),
(550, 10, '19:00:00', '21:00:00', 160000.00),
(551, 10, '21:00:00', '23:00:00', 140000.00),
(552, 11, '00:00:00', '02:00:00', 100000.00),
(553, 11, '02:00:00', '04:00:00', 100000.00),
(554, 11, '04:00:00', '06:00:00', 100000.00),
(555, 11, '06:00:00', '08:00:00', 120000.00),
(556, 11, '08:00:00', '10:00:00', 120000.00),
(557, 11, '10:00:00', '11:30:00', 90000.00),
(558, 11, '13:00:00', '15:00:00', 120000.00),
(559, 11, '15:00:00', '17:00:00', 120000.00),
(560, 11, '17:00:00', '19:00:00', 160000.00),
(561, 11, '19:00:00', '21:00:00', 160000.00),
(562, 11, '21:00:00', '23:00:00', 140000.00),
(563, 12, '00:00:00', '02:00:00', 100000.00),
(564, 12, '02:00:00', '04:00:00', 100000.00),
(565, 12, '04:00:00', '06:00:00', 100000.00),
(566, 12, '06:00:00', '08:00:00', 120000.00),
(567, 12, '08:00:00', '10:00:00', 120000.00),
(568, 12, '10:00:00', '11:30:00', 90000.00),
(569, 12, '13:00:00', '15:00:00', 120000.00),
(570, 12, '15:00:00', '17:00:00', 120000.00),
(571, 12, '17:00:00', '19:00:00', 160000.00),
(572, 12, '19:00:00', '21:00:00', 160000.00),
(573, 12, '21:00:00', '23:00:00', 140000.00),
(585, 14, '00:00:00', '02:00:00', 100000.00),
(586, 14, '02:00:00', '04:00:00', 100000.00),
(587, 14, '04:00:00', '06:00:00', 100000.00),
(588, 14, '06:00:00', '08:00:00', 120000.00),
(589, 14, '08:00:00', '10:00:00', 120000.00),
(590, 14, '10:00:00', '11:30:00', 90000.00),
(591, 14, '13:00:00', '15:00:00', 120000.00),
(592, 14, '15:00:00', '17:00:00', 120000.00),
(593, 14, '17:00:00', '19:00:00', 160000.00),
(594, 14, '19:00:00', '21:00:00', 160000.00),
(595, 14, '21:00:00', '23:00:00', 140000.00),
(596, 15, '00:00:00', '02:00:00', 100000.00),
(597, 15, '02:00:00', '04:00:00', 100000.00),
(598, 15, '04:00:00', '06:00:00', 100000.00),
(599, 15, '06:00:00', '08:00:00', 120000.00),
(600, 15, '08:00:00', '10:00:00', 120000.00),
(601, 15, '10:00:00', '11:30:00', 90000.00),
(602, 15, '13:00:00', '15:00:00', 120000.00),
(603, 15, '15:00:00', '17:00:00', 120000.00),
(604, 15, '17:00:00', '19:00:00', 160000.00),
(605, 15, '19:00:00', '21:00:00', 160000.00),
(606, 15, '21:00:00', '23:00:00', 140000.00),
(607, 16, '00:00:00', '02:00:00', 100000.00),
(608, 16, '02:00:00', '04:00:00', 100000.00),
(609, 16, '04:00:00', '06:00:00', 100000.00),
(610, 16, '06:00:00', '08:00:00', 120000.00),
(611, 16, '08:00:00', '10:00:00', 120000.00),
(612, 16, '10:00:00', '11:30:00', 90000.00),
(613, 16, '13:00:00', '15:00:00', 120000.00),
(614, 16, '15:00:00', '17:00:00', 120000.00),
(615, 16, '17:00:00', '19:00:00', 160000.00),
(616, 16, '19:00:00', '21:00:00', 160000.00),
(617, 16, '21:00:00', '23:00:00', 140000.00),
(618, 17, '00:00:00', '02:00:00', 100000.00),
(619, 17, '02:00:00', '04:00:00', 100000.00),
(620, 17, '04:00:00', '06:00:00', 100000.00),
(621, 17, '06:00:00', '08:00:00', 120000.00),
(622, 17, '08:00:00', '10:00:00', 120000.00),
(623, 17, '10:00:00', '11:30:00', 90000.00),
(624, 17, '13:00:00', '15:00:00', 120000.00),
(625, 17, '15:00:00', '17:00:00', 120000.00),
(626, 17, '17:00:00', '19:00:00', 160000.00),
(627, 17, '19:00:00', '21:00:00', 160000.00),
(628, 17, '21:00:00', '23:00:00', 140000.00),
(629, 18, '00:00:00', '02:00:00', 100000.00),
(630, 18, '02:00:00', '04:00:00', 100000.00),
(631, 18, '04:00:00', '06:00:00', 100000.00),
(632, 18, '06:00:00', '08:00:00', 120000.00),
(633, 18, '08:00:00', '10:00:00', 120000.00),
(634, 18, '10:00:00', '11:30:00', 90000.00),
(635, 18, '13:00:00', '15:00:00', 120000.00),
(636, 18, '15:00:00', '17:00:00', 120000.00),
(637, 18, '17:00:00', '19:00:00', 160000.00),
(638, 18, '19:00:00', '21:00:00', 160000.00),
(639, 18, '21:00:00', '23:00:00', 140000.00),
(640, 19, '00:00:00', '02:00:00', 100000.00),
(641, 19, '02:00:00', '04:00:00', 100000.00),
(642, 19, '04:00:00', '06:00:00', 100000.00),
(643, 19, '06:00:00', '08:00:00', 120000.00),
(644, 19, '08:00:00', '10:00:00', 120000.00),
(645, 19, '10:00:00', '11:30:00', 90000.00),
(646, 19, '13:00:00', '15:00:00', 120000.00),
(647, 19, '15:00:00', '17:00:00', 120000.00),
(648, 19, '17:00:00', '19:00:00', 160000.00),
(649, 19, '19:00:00', '21:00:00', 160000.00),
(650, 19, '21:00:00', '23:00:00', 140000.00),
(651, 20, '00:00:00', '02:00:00', 100000.00),
(652, 20, '02:00:00', '04:00:00', 100000.00),
(653, 20, '04:00:00', '06:00:00', 100000.00),
(654, 20, '06:00:00', '08:00:00', 120000.00),
(655, 20, '08:00:00', '10:00:00', 120000.00),
(656, 20, '10:00:00', '11:30:00', 90000.00),
(657, 20, '13:00:00', '15:00:00', 120000.00),
(658, 20, '15:00:00', '17:00:00', 120000.00),
(659, 20, '17:00:00', '19:00:00', 160000.00),
(660, 20, '19:00:00', '21:00:00', 160000.00),
(661, 20, '21:00:00', '23:00:00', 140000.00),
(662, 4, '18:00:00', '20:00:00', 240000.00),
(663, 13, '19:00:00', '20:00:00', 100000.00),
(664, 13, '20:00:00', '21:00:00', 100000.00),
(665, 13, '21:00:00', '22:00:00', 100000.00),
(666, 13, '22:00:00', '23:00:00', 100000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khu_vuc`
--

CREATE TABLE `khu_vuc` (
  `khu_vuc_id` int(11) NOT NULL,
  `co_so_id` int(11) NOT NULL,
  `ten_kv` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `khu_vuc`
--

INSERT INTO `khu_vuc` (`khu_vuc_id`, `co_so_id`, `ten_kv`) VALUES
(1, 1, 'Ngoài Trời'),
(2, 1, 'Trong Nhà'),
(3, 2, 'Khu VIP'),
(4, 1, 'Mái Che'),
(5, 2, 'Trong Nhà'),
(6, 2, 'Ngoài Trời');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `san`
--

CREATE TABLE `san` (
  `san_id` int(11) NOT NULL,
  `khu_vuc_id` int(11) NOT NULL,
  `ten_san` varchar(50) NOT NULL,
  `trang_thai` enum('hoat_dong','bao_tri') DEFAULT 'hoat_dong'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `san`
--

INSERT INTO `san` (`san_id`, `khu_vuc_id`, `ten_san`, `trang_thai`) VALUES
(1, 1, 'Sân T1', 'hoat_dong'),
(2, 1, 'Sân T2', 'hoat_dong'),
(3, 2, 'Sân N1', 'hoat_dong'),
(4, 3, 'Sân VIP 1', 'hoat_dong'),
(5, 6, 'Sân T1', 'hoat_dong'),
(6, 5, 'Sân N1', 'hoat_dong'),
(8, 1, 'Test', 'bao_tri'),
(9, 4, 'Sân C1', 'hoat_dong'),
(10, 5, 'Sân N2', 'hoat_dong'),
(11, 6, 'Sân T2', 'hoat_dong'),
(12, 6, 'Sân T3', 'hoat_dong'),
(13, 3, 'Sân VIP 2', 'hoat_dong'),
(14, 6, 'Sân T', 'bao_tri'),
(15, 4, 'Sân C2', 'hoat_dong'),
(16, 4, 'Sân C3', 'hoat_dong'),
(17, 2, 'Sân N2', 'hoat_dong'),
(18, 2, 'Sân N3', 'hoat_dong'),
(19, 2, 'Sân N4', 'hoat_dong'),
(20, 2, 'Sân N5', 'hoat_dong');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `ho_ten` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mat_khau` varchar(255) NOT NULL,
  `sdt` varchar(15) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT 'assets/img/default-avatar.png',
  `vai_tro` enum('chu_san','khach_hang') NOT NULL,
  `ngay_tao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`user_id`, `ho_ten`, `email`, `mat_khau`, `sdt`, `avatar`, `vai_tro`, `ngay_tao`) VALUES
(1, 'Nguyễn Mạnh Quỳnh', 'hnyuq15032005@gmail.com', '$2y$10$.04UXOpgRMae31tlVtyOk.K8nexAF39UsV.9sGVXXfqDU1nUq1vc.', '0365614536', 'assets/img/avatar_1_1775929800.jpg', 'khach_hang', '2026-03-15 11:12:28'),
(4, 'Kiều Minh Ánh', 'anh7@gmail.com', '$2y$10$fZ1DJEQ1tXPzXvZJp.7I2OBgufeZsnI8Nj0UOYL7m2SkGSA3//0ii', '0392920513', 'assets/img/avatar_4_1775995309.jpg', 'khach_hang', '2026-04-01 13:49:43'),
(7, 'Chủ Văn Sân', 'admin@gmail.com', '$2y$10$33YXF37D9qt0jGH.Ps/Svet4JfquNG/6dNr6xcKyRmrJYizsbVMCC', '0123456789', 'assets/img/avatar_7_1775974729.png', 'chu_san', '2026-03-16 14:35:30'),
(8, 'Nguyễn Quang Anh', 'qavahoai19@gmail.com', '$2y$10$0y5.OloV0vLgLKoVDCfhiuhHJbuW6XBTFpNQ5wH5CGC/okbvrYcuy', '0858446102', 'assets/img/avatar_8_1775930917.jpg', 'khach_hang', '2026-04-11 18:04:06'),
(9, 'Vũ Nguyễn Song Khanh', 'khanhbeo@gmail.com', '$2y$10$eHmixt4.eEj5ALHF3gNtGuVknykX40gLft1ZiDgR2qgVScSo6aW1u', '0987654321', 'assets/img/avatar_9_1776001439.jpg', 'khach_hang', '2026-04-12 13:28:27');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `chi_tiet_dich_vu`
--
ALTER TABLE `chi_tiet_dich_vu`
  ADD PRIMARY KEY (`chi_tiet_id`),
  ADD KEY `dat_san_id` (`dat_san_id`),
  ADD KEY `dich_vu_id` (`dich_vu_id`);

--
-- Chỉ mục cho bảng `co_so`
--
ALTER TABLE `co_so`
  ADD PRIMARY KEY (`co_so_id`);

--
-- Chỉ mục cho bảng `dat_san`
--
ALTER TABLE `dat_san`
  ADD PRIMARY KEY (`dat_san_id`),
  ADD KEY `khach_hang_id` (`khach_hang_id`),
  ADD KEY `khung_gio_id` (`khung_gio_id`);

--
-- Chỉ mục cho bảng `dich_vu`
--
ALTER TABLE `dich_vu`
  ADD PRIMARY KEY (`dich_vu_id`);

--
-- Chỉ mục cho bảng `hinh_anh_co_so`
--
ALTER TABLE `hinh_anh_co_so`
  ADD PRIMARY KEY (`hinh_id`),
  ADD KEY `co_so_id` (`co_so_id`);

--
-- Chỉ mục cho bảng `khung_gio`
--
ALTER TABLE `khung_gio`
  ADD PRIMARY KEY (`khung_gio_id`),
  ADD KEY `san_id` (`san_id`);

--
-- Chỉ mục cho bảng `khu_vuc`
--
ALTER TABLE `khu_vuc`
  ADD PRIMARY KEY (`khu_vuc_id`),
  ADD KEY `co_so_id` (`co_so_id`);

--
-- Chỉ mục cho bảng `san`
--
ALTER TABLE `san`
  ADD PRIMARY KEY (`san_id`),
  ADD KEY `khu_vuc_id` (`khu_vuc_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `sdt` (`sdt`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `chi_tiet_dich_vu`
--
ALTER TABLE `chi_tiet_dich_vu`
  MODIFY `chi_tiet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `co_so`
--
ALTER TABLE `co_so`
  MODIFY `co_so_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `dat_san`
--
ALTER TABLE `dat_san`
  MODIFY `dat_san_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `dich_vu`
--
ALTER TABLE `dich_vu`
  MODIFY `dich_vu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `hinh_anh_co_so`
--
ALTER TABLE `hinh_anh_co_so`
  MODIFY `hinh_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `khung_gio`
--
ALTER TABLE `khung_gio`
  MODIFY `khung_gio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=667;

--
-- AUTO_INCREMENT cho bảng `khu_vuc`
--
ALTER TABLE `khu_vuc`
  MODIFY `khu_vuc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `san`
--
ALTER TABLE `san`
  MODIFY `san_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `chi_tiet_dich_vu`
--
ALTER TABLE `chi_tiet_dich_vu`
  ADD CONSTRAINT `chi_tiet_dich_vu_ibfk_1` FOREIGN KEY (`dat_san_id`) REFERENCES `dat_san` (`dat_san_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chi_tiet_dich_vu_ibfk_2` FOREIGN KEY (`dich_vu_id`) REFERENCES `dich_vu` (`dich_vu_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `dat_san`
--
ALTER TABLE `dat_san`
  ADD CONSTRAINT `dat_san_ibfk_1` FOREIGN KEY (`khach_hang_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `hinh_anh_co_so`
--
ALTER TABLE `hinh_anh_co_so`
  ADD CONSTRAINT `hinh_anh_co_so_ibfk_1` FOREIGN KEY (`co_so_id`) REFERENCES `co_so` (`co_so_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `khung_gio`
--
ALTER TABLE `khung_gio`
  ADD CONSTRAINT `khung_gio_ibfk_1` FOREIGN KEY (`san_id`) REFERENCES `san` (`san_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `khu_vuc`
--
ALTER TABLE `khu_vuc`
  ADD CONSTRAINT `khu_vuc_ibfk_1` FOREIGN KEY (`co_so_id`) REFERENCES `co_so` (`co_so_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `san`
--
ALTER TABLE `san`
  ADD CONSTRAINT `san_ibfk_1` FOREIGN KEY (`khu_vuc_id`) REFERENCES `khu_vuc` (`khu_vuc_id`) ON DELETE CASCADE;

DELIMITER $$
--
-- Sự kiện
--
CREATE DEFINER=`root`@`localhost` EVENT `ev_auto_update_booking_status` ON SCHEDULE EVERY 1 MINUTE STARTS '2026-04-12 17:02:39' ON COMPLETION NOT PRESERVE ENABLE DO CALL auto_update_booking_status()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
