/*
	Author: Lee Khacc Thienn
*/

CREATE DATABASE Exam_MSSQL_2020_04
GO

USE Exam_MSSQL_2020_04
GO

CREATE TABLE Category (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(100) NOT NULL UNIQUE,
	Status TINYINT DEFAULT 1,
	CHECK(
		Status = 0 OR 
		Status = 1
 	)
)
GO

CREATE TABLE Room (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(100) NOT NULL,
	INDEX idx_room_name (Name),
	Status TINYINT DEFAULT 1,
	CHECK(
		Status = 0 OR 
		Status = 1
 	),
	Price FLOAT NOT NULL CHECK(Price >= 100000),
	INDEX idx_room_price (Price),
	SalePrice FLOAT DEFAULT 0,
	CHECK(SalePrice <= Price),
	CreatedDate DATE DEFAULT GETDATE(),
	INDEX idx_room_created_date (CreatedDate),
	CategoryId INT NOT NULL FOREIGN KEY REFERENCES Category(Id)
)
GO


CREATE TABLE Customer (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(150) NOT NULL,
	Email VARCHAR(150) NOT NULL UNIQUE CHECK(
		Email LIKE '%@gmail.com' OR
		Email LIKE '%@facebook.com' OR
		Email LIKE '%@bachkhoa-aptech.edu.vn'
	),
	Phone VARCHAR(50) NOT NULL UNIQUE,
	Address NVARCHAR(255),
	CreatedDate DATE DEFAULT GETDATE() CHECK (
		YEAR(CreatedDate) >= YEAR(GETDATE()) AND
		MONTH(CreatedDate) >= MONTH(GETDATE()) AND
		DAY(CreatedDate) >= DAY(GETDATE())
	),
	Gender TINYINT NOT NULL CHECK(
		Gender = 1 OR 
		Gender = 2 OR
		Gender = 3
	),
	BirthDay DATE NOT NULL
)
GO

CREATE TABLE Booking (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	CustomerId INT NOT NULL FOREIGN KEY REFERENCES Category(Id),
	Status Tinyint DEFAULT 1 CHECK (
		Status = 0 OR
		Status = 1 OR
		Status = 2 OR
		Status = 3
	),
	BookingDate DATETIME DEFAULT GETDATE()
)
GO

CREATE TABLE BookingDetail (
	BookingId INT NOT NULL FOREIGN KEY REFERENCES Booking(Id),
	RoomId INT NOT NULL FOREIGN KEY REFERENCES Room(Id),
	Price FLOAT NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	CHECK(
		YEAR(EndDate) > YEAR(StartDate) OR
		MONTH(EndDate) > MONTH(StartDate) OR
		DAY(EndDate) > DAY(StartDate)
	),
	PRIMARY KEY (BookingId, RoomId)
)
GO


INSERT INTO Category ([Name], [Status]) VALUES 
(N'Phong Don', 1),
(N'Phong Doi', 1),
(N'Phong Resort', 1),
(N'Phong XYZ', 1),
(N'Phong Hmmm', 1)
GO

INSERT INTO Room ([Name], [Status], [Price], [SalePrice], [CategoryId])
VALUES 
(N'Room 1', 1, 100000, 2000, 1),
(N'Room 2', 0, 200000, 3000, 2),
(N'Room 3', 1, 300000, 4000, 3),
(N'Room 4', 0, 400000, 5000, 4),
(N'Room 5', 0, 500000, 6000, 5),
(N'Room 6', 1, 600000, 7000, 1),
(N'Room 7', 1, 700000, 8000, 2),
(N'Room 8', 1, 800000, 9000, 1),
(N'Room 9', 0, 900000, 10000, 1),
(N'Room 10', 1, 1000000, 11000, 2),
(N'Room 11', 1, 1100000, 12000, 5),
(N'Room 12', 1, 1200000, 13000, 2),
(N'Room 13', 0, 1300000, 14000, 3),
(N'Room 14', 1, 1400000, 15000, 4),
(N'Room 15', 1, 1500000, 16000, 5)
GO

INSERT INTO Customer ([Name], [Email], [Phone], [Address], [Gender], [BirthDay])
VALUES
(N'Lê Văn A', 'email1@gmail.com', '0912345678', N'Địa chỉ A', 1, '1990-01-01'),
(N'Trần Thị B', 'email2@facebook.com', '0912345679', N'Địa chỉ B', 2, '1991-02-02'),
(N'Nguyễn Văn C', 'email3@@bachkhoa-aptech.edu.vn', '0912345680', N'Địa chỉ C', 1, '1992-03-03'),
(N'Đào Thị D', 'email4@gmail.com', '0912345681', N'Địa chỉ D', 2, '1993-04-04'),
(N'Hồ Văn E', 'email5@facebook.com', '0912345682', N'Địa chỉ E', 1, '1994-05-05')
GO

INSERT INTO Booking ([CustomerId], [Status], [BookingDate]) VALUES
(1, 1, '2023-08-22'),
(2, 0, '2023-09-12'),
(3, 1, '2023-05-21')
GO

INSERT INTO BookingDetail([BookingId], [RoomId], [Price], [StartDate], [EndDate])
VALUES 
(1, 1, 900000, '2023-09-08', GETDATE()),
(1, 2, 100000, '2023-08-09', GETDATE()),
(2, 3, 200000, '2023-05-07', GETDATE()),
(2, 4, 300000, '2023-07-22', GETDATE()),
(3, 5, 400000, '2023-05-16', GETDATE()),
(3, 1, 500000, '2023-01-12', GETDATE())
GO

/*
	1.	Lấy ra danh phòng có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price, SalePrice, Status, CategoryName, CreatedDate
*/
SELECT rm.Id, rm.Name, Price, SalePrice, rm.Status, ct.Name as CategoryName, rm.CreatedDate
FROM Room rm 
INNER JOIN Category ct ON rm.CategoryId = ct.Id

/*
	2.	Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )
*/

SELECT ct.Id, ct.Name, COUNT(*) AS TotalRoom,
CASE ct.status 
	WHEN 0 THEN N'Ẩn'
	WHEN 1 THEN N'Hiên Thị'
END AS Txt_Status
FROM Category ct
INNER JOIN Room rm ON rm.CategoryId = ct.Id
GROUP BY ct.Id, ct.Name, ct.status

/*
	3.	Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )
*/
SELECT ct.id, ct.name, ct.Email, ct.Phone, ct.Address, ct.CreatedDate, 
case ct.gender
	WHEN 0 THEN N'Nam'
	WHEN 1 THEN N'Nữ'
	WHEN 2 THEN N'Khác'
END AS TxtGender,
ct.BirthDay, (YEAR(GETDATE()) - YEAR(ct.BirthDay)) AS Age	
FROM Customer ct 
GO


/*
	4.	Truy vấn xóa các sản phẩm chưa được bán
*/
DELETE FROM Room WHERE Id NOT IN (SELECT RoomId FROM BookingDetail)
GO

/*
	5.	Cập nhật Cột SalePrice tăng thêm 10% cho tất cả các phòng có Price >= 250000
*/
UPDATE Room SET SalePrice = (SalePrice * 0.1) WHERE Price >= 250000
GO

/*
	1.	View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất 
*/
CREATE VIEW v_getRoomInfo AS
	SELECT TOP 10 * FROM Room ORDER BY Price DESC
GO

SELECT * FROM v_getRoomInfo
GO


/*
	2.	View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm: Id, BookingDate, Status, CusName, Email, Phone,TotalAmount ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt, = 2 Đã thanh toán, = 3 Đã hủy )
*/
CREATE VIEW v_getBookingList
AS
	SELECT  bk.Id, bk.BookingDate, 
	CASE bk.Status
		WHEN 0 THEN N'Chưa duyệt'
		WHEN 1 THEN N'Đã duyệt'
		WHEN 2 THEN N'Đã thanh toán'
		WHEN 3 THEN N'Đã hủy'
	END AS Status, ct.Name as Cusname, ct.Email, ct.Phone,
	COUNT(bkdt.BookingId) AS TotalAmount
	FROM Booking bk
	INNER JOIN Customer ct ON bk.CustomerId = ct.Id
	LEFT JOIN BookingDetail bkdt ON bkdt.BookingId = bk.Id
	GROUP BY bk.Id, bk.BookingDate, bk.Status, ct.Name, ct.Email, ct.Phone
GO

SELECT * FROM v_getBookingList
GO

/*
	1.	Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room ( Trừ cột tự động tăng )
*/
CREATE PROC addRoomInfo
	@name Nvarchar(150),
	@status Tinyint,
	@price Float,
	@sale_price Float,
	@categoryId INT
AS
	INSERT INTO Room ([Name], [Status], [Price], [SalePrice], [CategoryId])
	VALUES (@name, @status, @price, @sale_price, @categoryId)
GO

EXEC addRoomInfo N'Room 16', 0, 1600000, 17000, 1
GO

/*
	2.	Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng theo Id khách hàng gồm: Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id của khách hàng
*/
CREATE PROC getBookingByCustomerId 
	@customerId INT
AS
BEGIN
	SELECT bk.Id, bk.BookingDate, 
	CASE bk.Status
		WHEN 0 THEN N'Chưa duyệt'
		WHEN 1 THEN N'Đã duyệt'
		WHEN 2 THEN N'Đã thanh toán'
		WHEN 3 THEN N'Đã hủy'
	END AS Status,
	COUNT(bkdt.BookingId) AS TotalAmount
	FROM Booking bk
	RIGHT JOIN Customer ct ON bk.CustomerId = ct.Id
	LEFT JOIN BookingDetail bkdt ON bkdt.BookingId = bk.Id
	WHERE ct.id = 1
	GROUP BY bk.Id, bk.BookingDate, bk.Status, ct.Name, ct.Email, ct.Phone
END
GO

EXEC getBookingByCustomerId 1
GO

/*
	1.	Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa phòng Room nếu nếu giá trị của cột Price > 5000000 thì tự động chuyển về 5000000 và in ra thông báo ‘Giá phòng lớn nhất 5 triệu’
*/
CREATE TRIGGER tr_Check_Price_Value
ON Room
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT Price FROM inserted) > 5000000
    BEGIN
        RAISERROR(N'Giá phòng lớn nhất 5 triệu', 10, 1) 
		UPDATE Room SET Price = 5000000 WHERE Id = (SELECT Id FROM inserted)
    END
END
GO

EXEC addRoomInfo N'Room 16', 0, 500000000, 17000, 1
GO

/*
2.	Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt phòng, nếu ngày đến (StartDate) và ngày đi (EndDate) của đơn hiện tại mà phòng đã có người đặt rồi thì báo lỗi “Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác”
*/

CREATE TRIGGER tr_check_Room_NotAllow
ON BookingDetail
FOR INSERT 
AS
BEGIN
	DECLARE @BookingId INT
    DECLARE @StartDate DATETIME
    DECLARE @EndDate DATETIME
    DECLARE @RoomId INT
    
    -- Lấy thông tin về đặt phòng mới được thêm vào
    SELECT @BookingId = BookingId, @StartDate = StartDate, @EndDate = EndDate, @RoomId = RoomId
    FROM inserted
    
    -- Kiểm tra xem phòng đã có người đặt trong khoảng thời gian này hay chưa
    IF EXISTS (
        SELECT 1
        FROM BookingDetail
        WHERE RoomId = @RoomId
        AND BookingId <> @BookingId -- Loại trừ đặt phòng hiện tại
        AND (
            (@StartDate BETWEEN StartDate AND EndDate) OR
            (@EndDate BETWEEN StartDate AND EndDate) OR
            (StartDate BETWEEN @StartDate AND @EndDate)
        )
    )
    BEGIN
        -- Nếu có người đặt rồi, báo lỗi và hủy thêm đặt phòng
        RAISERROR('Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO