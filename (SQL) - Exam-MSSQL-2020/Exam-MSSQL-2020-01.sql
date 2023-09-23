/*
	Author: Lee Khacc Thienn
*/

CREATE DATABASE Exam_MSSQL_2020_01
GO

USE Exam_MSSQL_2020_01
GO

CREATE TABLE Category (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(100) NOT NULL UNIQUE,
	Status TINYINT DEFAULT 1 CHECK(
		Status = 0 OR
		Status = 1
	)
)
GO

CREATE TABLE Product (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(150) NOT NULL,
	INDEX idx_product_name (Name),
	Status TINYINT DEFAULT 1 CHECK(
		Status = 0 OR
		Status = 1
	),
	Price FLOAT NOT NULL CHECK(
		Price >= 100000
	),
	INDEX idx_product_price (Price),
	SalePrice FLOAT DEFAULT 0,
	CHECK(
		SalePrice <= Price
	),
	CreatedDate DATE DEFAULT GETDATE(),
	INDEX idx_product_created_date (CreatedDate),
	CategoryId INT NOT NULL FOREIGN KEY REFERENCES Category(Id)
)
GO

CREATE TABLE Customer (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(150) NOT NULL,
	Email VARCHAR(150) NOT NULL UNIQUE CHECK(
		Email LIKE '%@gmail.com'
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

CREATE TABLE Orders (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customer(Id),
	Status TINYINT DEFAULT 1 CHECK (
		Status = 0 OR 
		Status = 1 OR
		Status = 2 OR
		Status = 3
	),
	OrderDate DATETIME DEFAULT GETDATE()
)
GO

CREATE TABLE OrderDetail (
	OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(Id),
	ProductId INT NOT NULL FOREIGN KEY REFERENCES Product(Id),
	Quantity INT NOT NULL CHECK (
		Quantity > 0
	),
	Price FLOAT NOT NULL,
	PRIMARY KEY (OrderId, ProductId)
)
GO



INSERT INTO Category ([Name], [Status])
VALUES 
(N'Quần Áo', 1),
(N'Giày Dép', 0),
(N'Trang Sức', 1),
(N'Mỹ Phẩm', 1),
(N'Linh Tinh', 0)
GO

INSERT INTO Product ([Name], [Status], [Price], [SalePrice], [CategoryId]) VALUES
(N'Quần 1', 1, 130000, 100000, 1),
(N'Áo 1', 1, 300000, 200000, 1),
(N'Quần Áo 1', 0, 2100000, 200000, 1),

(N'Giày 1', 1, 200000, 24555, 2),
(N'Dép 1', 1, 230000, 220000, 2),
(N'Giày Dép 1', 1, 456000, 200000, 2),

(N'Vòng Cổ 1', 0, 1000000, 999000, 3),
(N'Nhẫn 1', 1, 1200000, 1200000 - 10, 3),
(N'Đồng Hồ 1', 0, 400000, 399000, 3),

(N'Phấn Trang Điểm 1', 1, 380000, 350000, 4),
(N'Son 1', 1, 4000000, 0, 4),
(N'Kem Dưỡng Da 1', 0, 423000, 0, 4),

(N'Chip Nâng Cấp 1', 0, 300000, 0, 5),
(N'Thẻ Hội Viên 1', 0, 120000, 0, 5),
(N'The World Of Card 1', 0, 770000, 0, 5)
GO

INSERT INTO Customer ([Name], [Email], [Phone], [Address], [Gender], [BirthDay])
VALUES
(N'Taka A', 'email1@gmail.com', '0912345678', N'Địa chỉ A', 1, '1990-01-01'),
(N'Taka B', 'email2@gmail.com', '0912345679', N'Địa chỉ B', 2, '1991-02-02'),
(N'Taka C', 'email3@gmail.com', '0912345680', N'Địa chỉ C', 1, '1992-03-03'),
(N'Taka D', 'email4@gmail.com', '0912345681', N'Địa chỉ D', 2, '1993-04-04'),
(N'Taka E', 'email5@gmail.com', '0912345682', N'Địa chỉ E', 1, '1994-05-05')
GO

INSERT INTO Orders ([CustomerId], [Status], [OrderDate]) VALUES
(1, 0, GETDATE()),
(3, 1, GETDATE() - 6),
(4, 3, GETDATE() - 10)
GO


INSERT INTO OrderDetail ([OrderId], [ProductId], [Quantity], [Price]) VALUES 
(1, 1, 10, 10 * 130000),
(1, 3, 4, 4 * 2100000),
(1, 5, 4, 4 * 230000),
(2, 1, 1, 130000),
(2, 6, 100, 100 * 456000),
(3, 3, 9, 9 * 2100000),
(3, 6, 7, 7 * 456000)
GO


/*
	1.	Lấy ra danh sách sản phẩm có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price, SalePrice, Status, CategoryName, CreatedDate
*/
SELECT p.id, p.name, price, SalePrice, p.Status, c.Name as CategoryName, p.CreatedDate
FROM Product p 
INNER JOIN Category c ON p.CategoryId = c.Id
GO

/*
	2.	Lấy ra danh sách Category gồm: Id, Name, TotalProduct, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )
*/
SELECT c.Id, c.Name, COUNT(p.CategoryId) AS TotalProduct,
CASE c.status
	WHEN 1 THEN N'Hiển thị'
	WHEN 0 THEN N'Ẩn'
END AS Status
FROM Category c
INNER JOIN Product p ON p.CategoryId = c.Id
GROUP BY c.Id, c.Name, c.status
GO

/*
	3.	Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )
*/
SELECT
	c.id, c.name, c.Email, c.Phone, c.Address, c.CreatedDate,
	CASE c.Gender 
		WHEN 0 THEN N'Nam'
		WHEN 1 THEN N'Nữ'
		WHEN 2 THEN N'Khác'
	END AS Gender,
	c.BirthDay, (YEAR(GETDATE()) - YEAR(c.BirthDay)) AS Age
FROM Customer c
GO

/*
	4.	Truy vấn xóa các sản phẩm chưa được bán
*/
DELETE FROM Product WHERE Id NOT IN (SELECT ProductId FROM OrderDetail)
GO

/*
	5.	Cập nhật Cột SalePrice tăng thêm 10% cho tất cả các sản phẩm có SalePrice <= 250000
*/
UPDATE Product SET SalePrice = SalePrice + (SalePrice * 0.1) WHERE SalePrice <= 250000
GO

/*
	1.	View v_getProductInfo Lấy ra danh sách của 10 sản phẩm có giá cao nhất 
*/
CREATE VIEW v_getProductInfo
AS
	SELECT TOP 10 *
	FROM Product 
	ORDER BY Price DESC
GO

SELECT * FROM v_getProductInfo
GO

/*
	2.	View v_getOrderList hiển thị danh sách đơn hàng gồm: Id, OrderDate, Status, CusName, Email, Phone,TotalAmount ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã0thanh toán, = 3 Đã hủy ) 
*/
CREATE VIEW v_getOrderList 
AS
	SELECT
		o.Id,
		o.OrderDate,
		CASE
			WHEN o.Status = 0 THEN N'Chưa duyệt'
			WHEN o.Status = 1 THEN N'Đã duyệt'
			WHEN o.Status = 2 THEN N'Đã thanh toán'
			WHEN o.Status = 3 THEN N'Đã hủy'
		END AS Status,
		c.Name as Cusname,
		c.Email,
		c.Phone,
		SUM(od.Quantity * od.Price) AS TotalAmount
	FROM orders o
	JOIN Customer c ON o.CustomerId = c.Id
	JOIN OrderDetail od ON o.Id = od.OrderId
	GROUP BY o.Id, o.OrderDate, o.Status, c.Name, c.Email, c.Phone
GO

SELECT * FROM v_getOrderList
GO

/*
	1.	Thủ tục addProductInfo thực hiện thêm mới Product, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Product ( Trừ cột tự động tăng )
*/
CREATE PROC addProductInfo
	@Name NVARCHAR(150),
	@Status TINYINT,
	@Price FLOAT,
	@SalePrice FLOAT,
	@CategoryId INT
AS
BEGIN
	INSERT INTO Product ([Name], [Status], [Price], [SalePrice], [CategoryId]) VALUES
	(@Name, @Status, @Price, @SalePrice, @CategoryId)
END
GO

/*
	2.	Thủ tục getOrderByCustomerId hiển thị danh sách đơn hàng của khách hàng theo Id khách hàng gồm: Id, OrderDate, Status, TotalAmount (Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id cảu khách hàng
*/
CREATE PROC getOrderByCustomerId
	@cusId INT
AS
	SELECT
		o.Id,
		o.OrderDate,
		CASE
			WHEN o.Status = 0 THEN N'Chưa duyệt'
			WHEN o.Status = 1 THEN N'Đã duyệt'
			WHEN o.Status = 2 THEN N'Đã thanh toán'
			WHEN o.Status = 3 THEN N'Đã hủy'
		END AS Status,
		c.Name as Cusname,
		SUM(od.Quantity * od.Price) AS TotalAmount
	FROM orders o
	JOIN Customer c ON o.CustomerId = c.Id
	JOIN OrderDetail od ON o.Id = od.OrderId
	WHERE c.Id = @cusId
	GROUP BY o.Id, o.OrderDate, o.Status, c.Name, c.Email, c.Phone
GO

EXEC getOrderByCustomerId 1
GO

/*
	3.	Thủ tục getProductPaginate lấy ra danh sách sản phẩm có phân trang gồm: Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page
*/
CREATE PROC getProductPaginate
	@Limit INT,
	@Page INT
AS
BEGIN
	SELECT 
		p.id, p.name, p.Price, p.SalePrice
	FROM Product p
	ORDER BY p.Id
	OFFSET ( @Limit * (@Page - 1) ) ROWS 
	FETCH NEXT @Limit ROWS ONLY
END
GO

EXEC getProductPaginate 4, 2
GO

/*
	1.	Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa sản phẩm Product nếu nếu giá trị của cột Price > 2000000 thì tự động chuyển về 2000000 và in ra thông báo ‘Giá sản phẩm lớn nhất 20 triệu’ 
*/
CREATE TRIGGER tr_Check_Price_Value 
ON Product
FOR INSERT, UPDATE
AS
BEGIN
	IF ((SELECT Price FROM inserted) > 2000000)
	BEGIN
		RAISERROR(N'Giá sản phẩm lớn nhất 20 triệu', 16, 1)
		UPDATE Product SET Price = 2000000 WHERE Id = (SELECT id FROM inserted)
	END
END
GO

EXEC addProductInfo N'TEST Trigger', 1, 200000000000, 200, 1
GO

/*
	2.	Tạo trigger tr_check_Customer_Age khi thêm mới Customer nếu tuổi của khách hàng đó < 13 tuổi thì không cho thêm vào bảng và thông báo “Khách hàng này chưa đủ tuổi, tuổi phải >= 13
*/
CREATE TRIGGER tr_check_Customer_Age 
ON Customer
FOR INSERT
AS
BEGIN
	IF ((YEAR(GETDATE()) - YEAR((SELECT BirthDay FROM inserted))) < 13)
	BEGIN
		RAISERROR(N'Khách hàng này chưa đủ tuổi, tuổi phải >= 13', 16, 1)
		ROLLBACK TRANSACTION
	END
END
GO

INSERT INTO Customer ([Name], [Email], [Phone], [Address], [Gender], [BirthDay])
VALUES
(N'Taka AZ', 'email6@gmail.com', '091234538', N'Địa chỉ F', 1, '2018-01-01')