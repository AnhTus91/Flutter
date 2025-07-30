create database FoodAppDbv3
use FoodAppDbv3
go

-- 1. Người Dùng
CREATE TABLE NguoiDung (
    Id INT PRIMARY KEY IDENTITY,
    HoTen NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    MatKhau NVARCHAR(256),
    SoDienThoai NVARCHAR(20),
    VaiTro NVARCHAR(20) DEFAULT 'user',
    NgayTao DATETIME DEFAULT GETDATE()
);

-- 2. Danh Mục Sản Phẩm
CREATE TABLE DanhMuc (
    Id INT PRIMARY KEY IDENTITY,
    TenDanhMuc NVARCHAR(100)
);

-- 3. Giảm Giá
CREATE TABLE GiamGia (
    Id INT PRIMARY KEY IDENTITY,
    PhanTramGiam INT NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL
);

-- 4. Sản Phẩm
CREATE TABLE SanPham (
    Id INT PRIMARY KEY IDENTITY,
    TenSanPham NVARCHAR(100),
    MoTa NVARCHAR(MAX),
    HinhAnh NVARCHAR(MAX),
    DanhMucId INT FOREIGN KEY REFERENCES DanhMuc(Id),
    GiamGiaId INT NULL
);

-- 5. Size
CREATE TABLE Size (
    Id INT PRIMARY KEY IDENTITY,
    TenSize NVARCHAR(50)
);

-- 6. Sản phẩm theo Size
CREATE TABLE SanPhamSize (
    Id INT PRIMARY KEY IDENTITY,
    SanPhamId INT FOREIGN KEY REFERENCES SanPham(Id),
    SizeId INT FOREIGN KEY REFERENCES Size(Id),
    Gia DECIMAL(10,2)
);

-- 7. Giỏ Hàng
CREATE TABLE GioHang (
    Id INT PRIMARY KEY IDENTITY,
    NguoiDungId INT FOREIGN KEY REFERENCES NguoiDung(Id),
    SanPhamId INT FOREIGN KEY REFERENCES SanPham(Id),
    SizeId INT FOREIGN KEY REFERENCES Size(Id),
    SoLuong INT
);

-- 8. Chi Nhánh
CREATE TABLE ChiNhanh (
    Id INT PRIMARY KEY IDENTITY,
    TenChiNhanh NVARCHAR(100),
    DiaChi NVARCHAR(255),
    ViDo FLOAT,
    KinhDo FLOAT
);

-- 9. Voucher
CREATE TABLE Voucher (
    Id INT PRIMARY KEY IDENTITY,
    MaVoucher NVARCHAR(50) UNIQUE NOT NULL,
    GiaTri DECIMAL(10,2) NOT NULL,
    KieuGiamGia NVARCHAR(10) CHECK (KieuGiamGia IN ('%', 'VND')) NOT NULL,
    DieuKienApDung DECIMAL(10,2) DEFAULT 0,
    SoLuong INT DEFAULT 1,
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'Còn hiệu lực'
);


CREATE TABLE NguoiDungVoucher (
    Id INT PRIMARY KEY IDENTITY,
    IdVoucher INT FOREIGN KEY REFERENCES Voucher(Id),
    IdNguoiDung INT FOREIGN KEY REFERENCES NguoiDung(Id),
    TrangThai BIT,
    UNIQUE(IdVoucher, IdNguoiDung)
);

-- 10. Đơn Hàng
CREATE TABLE DonHang (
    Id INT PRIMARY KEY IDENTITY,
    NguoiDungId INT FOREIGN KEY REFERENCES NguoiDung(Id),
    ChiNhanhId INT FOREIGN KEY REFERENCES ChiNhanh(Id),
    KieuDonHang INT, -- 1 = Giao hàng, 2 = Tự đến lấy
    PhiGiaoHang DECIMAL(10,2),
    TongTien DECIMAL(10,2),
    DiaChiGiao NVARCHAR(255),
    TrangThai NVARCHAR(50),
    NgayTao DATETIME DEFAULT GETDATE(),
    VoucherId INT NULL FOREIGN KEY REFERENCES Voucher(Id)
);

-- 11. Chi Tiết Đơn Hàng
CREATE TABLE ChiTietDonHang (
    Id INT PRIMARY KEY IDENTITY,
    DonHangId INT FOREIGN KEY REFERENCES DonHang(Id),
    SanPhamId INT FOREIGN KEY REFERENCES SanPham(Id),
    SizeId INT FOREIGN KEY REFERENCES Size(Id),
    SoLuong INT,
    Gia DECIMAL(10,2),
    GhiChu NVARCHAR(255)
);

-- 12. Bảng Tin
CREATE TABLE BangTin (
    Id INT PRIMARY KEY IDENTITY,
    TieuDe NVARCHAR(200),
    HinhAnh NVARCHAR(255),
    NoiDung NVARCHAR(MAX),
    NgayTao DATETIME DEFAULT GETDATE()
);

-- 13. Yêu Cầu Hủy / Hoàn Trả
CREATE TABLE YeuCauHuyDonHang (
    Id INT PRIMARY KEY IDENTITY,
    DonHangId INT NOT NULL FOREIGN KEY REFERENCES DonHang(Id) ON DELETE CASCADE,
    LyDo NVARCHAR(255) NOT NULL,
    TrangThai NVARCHAR(50) DEFAULT N'Chờ xử lý',
    NgayGui DATETIME DEFAULT GETDATE()
);

-- 14. Bình Luận
CREATE TABLE BinhLuan (
    Id INT PRIMARY KEY IDENTITY,
    NguoiDungId INT FOREIGN KEY REFERENCES NguoiDung(Id),
    SanPhamId INT FOREIGN KEY REFERENCES SanPham(Id),
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayBinhLuan DATETIME DEFAULT GETDATE()
);

-- 15. Đánh Giá
CREATE TABLE DanhGia (
    Id INT PRIMARY KEY IDENTITY,
    NguoiDungId INT FOREIGN KEY REFERENCES NguoiDung(Id),
    SanPhamId INT FOREIGN KEY REFERENCES SanPham(Id),
    SoSao INT CHECK (SoSao >= 1 AND SoSao <= 5),
    NgayDanhGia DATETIME DEFAULT GETDATE()
);



-- 16. Ràng buộc khóa ngoại cho GiamGia
ALTER TABLE SanPham
ADD CONSTRAINT FK_SanPham_GiamGia FOREIGN KEY (GiamGiaId) REFERENCES GiamGia(Id);

INSERT INTO DanhMuc (TenDanhMuc)
VALUES 
('Gà'),
('Mì'),
('Cơm');

INSERT INTO Size (TenSize)
VALUES 
('S'),
('M'),
('L');


INSERT INTO SanPham (TenSanPham, MoTa, HinhAnh, DanhMucId)
VALUES 
('Cơm gà xối mỡ', 'Cơm gà xối mỡ thơm ngon, đậm đà, ăn kèm với rau và nước mắm tỏi ớt.', 'https://tse4.mm.bing.net/th/id/OIP.gIWE50AWWbXB_4BypZgB2AHaGG?pid=Api&P=0&h=180', 1),
('Chè ba màu', 'Chè ba màu ngọt mát, thơm ngon, rất thích hợp cho ngày hè.', 'https://tse4.mm.bing.net/th/id/OIP.gIWE50AWWbXB_4BypZgB2AHaGG?pid=Api&P=0&h=180', 2),
('Nước mía', 'Nước mía tươi nguyên chất, mát lạnh.', 'https://tse4.mm.bing.net/th/id/OIP.gIWE50AWWbXB_4BypZgB2AHaGG?pid=Api&P=0&h=180', 3);


INSERT INTO SanPhamSize (SanPhamId, SizeId, Gia)
VALUES 
(1, 1, 50000), -- Cơm gà xối mỡ - Nhỏ
(1, 2, 80000), -- Cơm gà xối mỡ - Vừa
(1, 3, 100000), -- Cơm gà xối mỡ - Lớn
(2, 1, 30000), -- Chè ba màu - Nhỏ
(2, 2, 45000), -- Chè ba màu - Vừa
(2, 3, 60000); -- Chè ba màu - Lớn


INSERT INTO ChiNhanh (TenChiNhanh, DiaChi, ViDo, KinhDo)
VALUES 
('Nhà hàng Hà Nội', 'Số 123, Phố X, Hà Nội', 21.0285, 105.8542),
('Nhà hàng Hồ Chí Minh', 'Số 456, Phố Y, TP.HCM', 10.762622, 106.660172);

INSERT INTO GiamGia (PhanTramGiam, NgayBatDau, NgayKetThuc)
VALUES 
(20, '2025-07-03', '2025-08-31'),
(10, '2025-07-01', '2025-07-31');