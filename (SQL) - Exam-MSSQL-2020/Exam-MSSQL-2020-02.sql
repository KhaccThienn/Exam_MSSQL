/*
	Author: Lee Khacc Thienn
*/

CREATE DATABASE Exam_MSSQL_2020_02
GO

USE Exam_MSSQL_2020_02
GO

CREATE TABLE Category (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(100) NOT NULL,
	Status Tinyint DEFAULT 1 CHECK (Status = 0 OR Status = 1)
)
GO

CREATE TABLE Author (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(100) NOT NULL UNIQUE,
	TotalBook INT DEFAULT 0
)
GO

CREATE TABLE Book (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(150) NOT NULL,
	INDEX idx_book_name (Name),
	Status Tinyint DEFAULT 1 CHECK (Status = 0 OR Status = 1),
	Price FLOAT NOT NULL CHECK (Price >= 100000),
	INDEX idx_book_price (Price),
	CreatedDate DATE DEFAULT GETDATE(),
	INDEX idx_book_createdDate (CreatedDate),
	CategoryId INT NOT NULL FOREIGN KEY REFERENCES Category(Id),
	AuthorId INT NOT NULL FOREIGN KEY REFERENCES Author(Id),
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

CREATE TABLE Ticket (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customer(Id),
	Status Tinyint DEFAULT 1 CHECK (
		Status = 0 OR
		Status = 1 OR
		Status = 2 OR
		Status = 3
	),
	TicketDate DATETIME DEFAULT GETDATE()
)
GO

CREATE TABLE TicketDetail (
	TicketId INT NOT NULL FOREIGN KEY REFERENCES Ticket(Id),
	BookId INT NOT NULL FOREIGN KEY REFERENCES Book(Id),
	Quantity INT NOT NULL CHECK(Quantity > 0),
	DepositPrice FLOAT NOT NULL,
	RentCost FLOAT NOT NULL,
	PRIMARY KEY (TicketId, BookId)
)
GO

-------------------------------------
INSERT INTO Category([Name], [Status]) VALUES 
(N'Truyện Trinh Thám', 1),
(N'Tiểu Thuyết', 1),
(N'Light Novel', 0),
(N'Manga', 1),
(N'Truyện Ngôn Tình', 0)
GO

INSERT INTO Author([Name]) VALUES 
(N'Aoyama Gosho'),
(N'Makoto Shinkai'),
(N'Fujiko Fujio'),
(N'Eiichiro Oda'),
(N'Masashi Kishimoto')
GO

INSERT INTO Book ([Name], [CategoryId], [AuthorId], [Price])
VALUES
(N'Thám tử Conan', 1, 1, 300000),
(N'Your Name.', 2, 2, 500000),
(N'Doraemon', 3, 3, 200000),
(N'One Piece', 4, 4, 400000),
(N'Naruto', 5, 5, 350000),
(N'Điều kỳ diệu của ánh trăng', 2, 2, 450000),
(N'Bảy viên ngọc rồng', 4, 4, 250000),
(N'Nana', 2, 2, 550000),
(N'Tokyo Ghoul', 5, 5, 300000),
(N'Attack on Titan', 4, 4, 400000),
(N'Kimetsu no Yaiba', 4, 4, 350000),
(N'Vagabond', 5, 5, 250000),
(N'Fullmetal Alchemist', 2, 2, 550000),
(N'Death Note', 1, 1, 300000),
(N'Berserk', 5, 5, 400000),
(N'The Promised Neverland', 2, 2, 350000)
GO

INSERT INTO Customer ([Name], [Email], [Phone], [Address], [Gender], [BirthDay])
VALUES
(N'Lê Văn A', 'email1@gmail.com', '0912345678', N'Địa chỉ A', 1, '1990-01-01'),
(N'Trần Thị B', 'email2@facebook.com', '0912345679', N'Địa chỉ B', 2, '1991-02-02'),
(N'Nguyễn Văn C', 'email3@@bachkhoa-aptech.edu.vn', '0912345680', N'Địa chỉ C', 1, '1992-03-03'),
(N'Đào Thị D', 'email4@gmail.com', '0912345681', N'Địa chỉ D', 2, '1993-04-04'),
(N'Hồ Văn E', 'email5@facebook.com', '0912345682', N'Địa chỉ E', 1, '1994-05-05')
GO

INSERT INTO Ticket ([CustomerId], [Status], [TicketDate]) VALUES 
(1, 1, GETDATE()),
(2, 0, GETDATE()),
(3, 3, GETDATE())
GO

INSERT INTO TicketDetail([TicketId], [BookId], [Quantity], [DepositPrice], [RentCost]) VALUES 
(1, 3, 3, 200000, 200000 * 0.1),
(1, 1, 10, 300000, 300000 * 0.1),
(1, 4, 2, 400000, 400000 * 0.1),
(2, 6, 12, 450000, 450000 * 0.1),
(2, 3, 3, 200000, 200000 * 0.1),
(3, 3, 43, 200000, 200000 * 0.1),
(3, 2, 11, 500000, 500000 * 0.1)
GO

------------------
/*
	Yêu cầu 1 ( Sử dụng lệnh SQL để truy vấn cơ bản ): 
*/

/*
	1.	Lấy ra danh sách Book có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price, Status, CategoryName, AuthorName, CreatedDate
*/
SELECT bk.Id, bk.Name, price, bk.Status, ct.Name as Categoryname, at.Name as Authorname, CreatedDate
FROM Book bk
INNER JOIN Category ct ON bk.CategoryId = ct.Id
INNER JOIN Author at ON bk.AuthorId = at.Id
GO

/*
	2.	Lấy ra danh sách Category gồm: Id, Name, TotalProduct, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )
*/
SELECT c.id, c.name, COUNT(*) as TotalProd,
CASE
	WHEN c.Status = 1 THEN 'Hien Thi'
	WHEN c.Status = 0 THEN 'An'
END AS Statuss
FROM Category c 
INNER JOIN Book b ON b.CategoryId = c.Id
GROUP BY c.id, c.name, c.Status
GO

/*
	3.	Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )
*/
SELECT id, name, email, phone, Address, CreatedDate, 
CASE Gender 
	WHEN 0 THEN 'Nam' 
	WHEN 1 THEN 'Nu' 
	WHEN 2 THEN 'Khac'
END AS Gender, 
BirthDay, (Year(GETDATE()) - YEAR(BirthDay)) AS age
FROM Customer 
GO

/*
	4.	Truy vấn xóa Author chưa có sách nào
*/
DELETE FROM Author WHERE Id NOT IN (SELECT AuthorId FROM Book)
GO

/*
	5.	Cập nhật Cột ToalBook trong bảng Author = Tổng số Book của mỗi Author theo Id của Author
*/
UPDATE Author SET TotalBook = (SELECT COUNT(*) FROM Book WHERE Book.AuthorId = Author.Id)
GO

/*
	Yêu cầu 2 ( Sử dụng lệnh SQL tạo View )
*/

/*
	1.	View v_getBookInfo thực hiện lấy ra danh sách các Book được mượn nhiều hơn 3 cuốn 
*/
CREATE VIEW v_getBookInfo 
AS
	SELECT
	  b.Id,
	  b.Name,
	  COUNT(td.BookId) AS BorrowedCount
	FROM Book b
	INNER JOIN TicketDetail td ON b.Id = td.BookId
	GROUP BY b.Id, b.Name
	HAVING COUNT(td.BookId) >= 3
GO

SELECT * FROM v_getBookInfo
GO

/*
	2.	View v_getTicketList hiển thị danh sách Ticket gồm: Id, TicketDate, Status, CusName, Email, Phone,TotalAmount (Trong đó TotalAmount là tổng giá trị tiện phải trả, cột Status nếu = 0 thì hiển thị Chưa trả, = 1 Đã trả, = 2 Quá hạn, 3 Đã hủy) 
*/
CREATE VIEW vw_getTicketList
AS
	SELECT tk.Id, tk.TicketDate,
	CASE tk.Status 
		WHEN 0 THEN N'Chưa trả'
		WHEN 1 THEN N'Đã trả'
		WHEN 2 THEN N'Quá hạn'
		WHEN 3 THEN N'Đã hủy'
	END AS Statuss,
	cs.Name as CustomerName, cs.Email, Phone, 
	SUM(td.Quantity * td.DepositPrice) AS TotalAmount 
	FROM Ticket tk 
	INNER JOIN Customer cs ON tk.CustomerId = cs.Id
	LEFT JOIN TicketDetail td ON td.TicketId = tk.Id
	GROUP BY tk.Id, tk.TicketDate, tk.Status, cs.Name, cs.Email, Phone
GO

SELECT * FROM vw_getTicketList
GO

/*
	Yêu cầu 3 ( Sử dụng lệnh SQL tạo thủ tục Stored Procedure )
*/

/*
	1.	Thủ tục addBookInfo thực hiện thêm mới Book, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Book ( Trừ cột tự động tăng )
*/
CREATE PROC addBookInfo 
	@Name NVARCHAR(150),
	@Status TINYINT,
	@Price FLOAT,
	@CategoryId INT,
	@AuthorId INT
AS
BEGIN
	INSERT INTO Book([Name], [Status], [Price], [CategoryId], [AuthorId])
	VALUES (@Name, @Status, @Price, @CategoryId, @AuthorId)
END
GO

EXEC addBookInfo N'Jujutsu Kaisen', 1, 250000, 4, 4
GO

/*
	2.	Thủ tục getTicketByCustomerId hiển thị danh sách đơn hàng của khách hàng theo Id khách hàng gồm: Id, TicketDate, Status, TotalAmount (Trong đó cột Status nếu =0 Chưa trả, = 1  Đã trả, = 2 Quá hạn, 3 đã hủy ), Khi gọi thủ tục truyền vào id cuả khách hàng
*/
CREATE PROC getTicketByCustomerId 
	@CustomerId INT 
AS
BEGIN
	SELECT tk.Id, tk.TicketDate,
	CASE tk.Status 
		WHEN 0 THEN N'Chưa trả'
		WHEN 1 THEN N'Đã trả'
		WHEN 2 THEN N'Quá hạn'
		WHEN 3 THEN N'Đã hủy'
	END AS Statuss,
	cs.Name as CustomerName, cs.Email, Phone, 
	SUM(td.Quantity * td.DepositPrice) AS TotalAmount  
	FROM Customer cs 
	INNER JOIN Ticket tk ON tk.CustomerId = cs.Id
	RIGHT JOIN TicketDetail td ON td.TicketId = tk.Id
	WHERE cs.Id = @CustomerId
	GROUP BY tk.Id, tk.TicketDate, tk.Status, cs.Name, cs.Email, cs.Phone
END
GO

EXEC getTicketByCustomerId 1
GO

/*
	3.	Thủ tục getBookPaginate lấy ra danh sách sản phẩm có phân trang gồm: Id, Name, Price, Sale_price, Khi gọi thủ tuc truyền vào limit và page
*/
CREATE PROC getBookPaginate
	@Limit INT,
	@Page INT
AS
BEGIN
	SELECT *
	FROM Book b
	ORDER BY b.Id DESC
	OFFSET (@Page - 1) * @Limit ROWS
	FETCH NEXT @Limit ROWS ONLY
END

EXEC GetBookPaginate 10, 2
GO

/*
	1.	Tạo trigger tr_Check_total_book_author sao cho khi thêm Book nếu Author đang tham chiếu có tổng số sách > 5 thì không cho thêm mưới và thông báo “Tác giả này có số lượng sách đạt tới giới hạn 5 cuốn, vui long chọn tác giả khác” 
*/
CREATE TRIGGER tr_Check_total_book_author
ON Book
AFTER INSERT
AS
BEGIN
	DECLARE @AuthorID INT;
    DECLARE @TotalBooks INT;

    -- Lấy thông tin tác giả và tổng số sách của tác giả trong bảng
    SELECT @AuthorID = i.AuthorID, @TotalBooks = COUNT(b.Id)
    FROM inserted i
    INNER JOIN Book b ON i.AuthorID = b.AuthorID
    GROUP BY i.AuthorID;

    -- Kiểm tra nếu tổng số sách vượt quá 5
    IF @TotalBooks > 5
    BEGIN
        RAISERROR('Tác giả này có số lượng sách đạt tới giới hạn 5 cuốn, vui lòng chọn tác giả khác', 16, 1);
        ROLLBACK TRANSACTION
    END
END

INSERT INTO Book ([Name], [CategoryId], [AuthorId], [Price])
VALUES
(N'Your Name 2.', 2, 2, 500000),
(N'Your Name 3.', 2, 2, 500000),
(N'Your Name 4.', 2, 2, 500000),
(N'Your Name 5.', 2, 2, 500000),
(N'Your Name 6.', 2, 2, 500000)
GO


/*
	2.	Tạo trigger tr_Update_TotalBook khi thêm mới Book thì cập nhật cột TotalBook rong bảng Author = tổng của Book theo AuthorId
*/
CREATE TRIGGER tr_Update_TotalBook
ON Book
AFTER INSERT
AS
BEGIN
    DECLARE @AuthorId INT;
    SELECT @AuthorId = AuthorId FROM inserted;

    UPDATE Author
    SET TotalBook = (
        SELECT COUNT(*)
        FROM Book
        WHERE AuthorId = @AuthorId
    )
    WHERE Id = @AuthorId;
END
GO

INSERT INTO Book ([Name], [CategoryId], [AuthorId], [Price])
VALUES
(N'One Piece 2', 4, 5, 400000)
GO