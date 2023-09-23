/*
	Author: Lee Khacc Thienn
*/

CREATE DATABASE Exam_MSSQL_2020_05
GO

USE Exam_MSSQL_2020_05
GO

CREATE TABLE Department (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name nvarchar(100) NOT NULL UNIQUE CHECK(
		LEN(Name) >= 6
	)
)
GO

CREATE TABLE Levels (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name nvarchar(100) NOT NULL UNIQUE,
	BasicSalary FLOAT NOT NULL CHECK (
		BasicSalary >=3500000
	),
	AllowanceSalary FLOAT DEFAULT 500000
)
GO

CREATE TABLE Employee (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name NVARCHAR(150) NOT NULL,
	Email VARCHAR(150) NOT NULL UNIQUE CHECK(
		Email LIKE '%@gmail.com'
	),
	Phone VARCHAR(50) NOT NULL UNIQUE,
	Address Nvarchar(255),
	Gender Tinyint NOT NULL CHECK(
		Gender = 0 OR
		Gender = 1 OR
		Gender = 2
	),
	BirthDay DATE NOT NULL,
	LevelId INT NOT NULL FOREIGN KEY REFERENCES Levels(Id),
	DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Department(Id),
)
GO

CREATE TABLE Timesheets (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	AttendanceDate DATE NOT NULL DEFAULT GETDATE(),
	EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employee(Id),
	Value FLOAT NOT NULL DEFAULT 1 CHECK (
		Value = 0 OR
		Value = 0.5 OR
		Value = 1
	),
	UNIQUE(AttendanceDate, EmployeeId, Value)
)	
GO

CREATE TABLE Salary (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employee(Id),
	BonusSalary FLOAT DEFAULT 0,
	Insurrance Float NOT NULL
)
GO


INSERT INTO Department ([Name]) VALUES 
(N'Human Resource'),
(N'Developers'),
(N'Security')
GO

INSERT INTO Levels ([Name], [BasicSalary], [AllowanceSalary])
VALUES 
(N'Thực tập sinh', 4000000, 0),
(N'Nhân viên chính thức', 5000000, 500000),
(N'Manager', 15000000, 1000000)
GO

INSERT INTO Employee ([Name], [Email], [Phone], [Address], [Gender], [BirthDay], [LevelId], [DepartmentId]) VALUES 
(N'Taka A', 'TakaA@gmail.com', '0974459015', N'Hoàng Quốc Việt - Cầu Giấy - HN', 1, '2004-12-21', 1, 3),
(N'Taka B', 'TakaB@gmail.com', '0974459035', N'Phạm Văn Đồng - Cầu Giấy - HN', 0, '2003-10-31', 1, 2),
(N'Taka C', 'TakaC@gmail.com', '1122312312', N'Nguyễn Khả Trác - Hà Đông- HN', 1, '2002-01-01', 2, 1),
(N'Taka D', 'TakaD@gmail.com', '5453534535', N'Thanh Xuân - Hà Đông - HN', 1, '1998-10-31', 2, 2),
(N'Taka E', 'TakaE@gmail.com', '5334535353', N'Chương Mỹ - HN', 0, '2002-10-14', 3, 3),
(N'Taka F', 'TakaF@gmail.com', '5435353534', N'Ba Đình - HN', 1, '2003-06-19', 1, 3),
(N'Taka G', 'TakaG@gmail.com', '2563353634', N'Phủ Lý - Hà Nam', 2, '2003-08-09', 2, 3),
(N'Taka H', 'TakaH@gmail.com', '6542137687', N'Moscow - Russia', 1, '1999-12-22', 1, 2),
(N'Taka K', 'TakaK@gmail.com', '431654234', N'Wasington - USA', 1, '2001-10-20', 1, 3),
(N'Taka L', 'TakaL@gmail.com', '4667523542', N'California - USA', 2, '1988-10-31', 2, 3),
(N'Taka M', 'TakaM@gmail.com', '6542345677', N'Tokyo - Japan', 1, '2003-10-31', 2, 3),
(N'Taka N', 'TakaN@gmail.com', '2345453234', N'Osaka - Japan', 0, '2003-10-31', 3, 2),
(N'Taka X', 'TakaX@gmail.com', '4325476589', N'Hiroshima - Japan', 1, '2003-10-31', 1, 3),
(N'Taka Y', 'TakaY@gmail.com', '3223423454', N'HongKong', 1, '2003-10-31', 3, 1),
(N'Taka Z', 'TakaZ@gmail.com', '4556767879', N'Beijing - China', 0, '2003-10-31', 3, 3)
GO

INSERT INTO Timesheets ([EmployeeId], [AttendanceDate], [Value]) VALUES 
(1, GETDATE() - 5, 1), (1, GETDATE() -4, 1), (1, GETDATE() - 3, 0),
(1, GETDATE() - 2, 1), (1, GETDATE() - 1, 1), (1, GETDATE(), 0.5),

(2, GETDATE() - 5, 1), (2, GETDATE() - 4, 1), (2, GETDATE() - 3, 0),
(2, GETDATE() - 2, 1), (2, GETDATE() - 1, 1), (2, GETDATE(), 0.5),

(3, GETDATE() - 5, 1), (3, GETDATE() - 4, 1), (3, GETDATE() - 3, 0),
(3, GETDATE() - 2, 0), (3, GETDATE() - 1, 0), (3, GETDATE(), 0.5),

(4, GETDATE() - 2, 1), (4, GETDATE() - 1, 1), (4, GETDATE(), 0.5),

(5, GETDATE() - 2, 1), (5, GETDATE() - 1, 0.5), (5, GETDATE(), 0),

(6, GETDATE() - 5, 1), (6, GETDATE() - 4, 1), (6, GETDATE() - 3, 0),
(6, GETDATE() - 2, 1), (6, GETDATE() - 1, 1), (6, GETDATE(), 1)
GO

INSERT INTO Salary ([EmployeeId], [BonusSalary], [Insurrance])
VALUES 
(1, 10000, 4000000 * 0.1),
(2, 300000, 4000000 * 0.1),
(3, 2000000, 5000000 * 0.1)
GO

/*
	1.	Lấy ra danh sách Employee có sắp xếp tăng dần theo Name gồm các cột sau: Id, Name, Email, Phone, Address, Gender, BirthDay, Age, DepartmentName, LevelName
*/
SELECT emp.Id, emp.Name, emp.Email, emp.Phone, emp.Address, emp.Gender, emp.BirthDay, (YEAR(GETDATE()) - YEAR(emp.BirthDay)) AS Age,
dp.Name as DepartmentName, lvls.Name as LevelName
FROM Employee emp 
INNER JOIN Department dp ON emp.DepartmentId = dp.Id
INNER JOIN Levels lvls ON emp.LevelId = lvls.Id
ORDER BY emp.Name ASC

/*
	2.	Lấy ra danh sách Salary gồm: Id, EmployeeName, Phone, Email, BaseSalary,  BasicSalary, AllowanceSalary, BonusSalary, Insurrance, TotalSalary
*/
SELECT emp.Id, emp.Name, emp.Phone, emp.Email, lvls.BasicSalary, lvls.AllowanceSalary, slr.BonusSalary, slr.Insurrance,
(lvls.BasicSalary + lvls.AllowanceSalary + slr.BonusSalary + slr.Insurrance) AS TotalSalary
FROM Employee emp 
LEFT JOIN Levels lvls ON emp.LevelId = lvls.Id
LEFT JOIN Salary slr ON slr.EmployeeId = emp.Id

/*
	3.	Truy vấn danh sách Department gồm: Id, Name, TotalEmployee
*/
SELECT dp.id, dp.Name, COUNT(emp.DepartmentId) AS TotalEmployee
FROM Department dp
LEFT JOIN Employee emp ON emp.DepartmentId = dp.Id
GROUP BY dp.id, dp.Name

/*
	4.	Cập nhật cột BonusSalary lên 10% cho tất cả các Nhân viên có số ngày công >= 20 ngày trong tháng 10 năm 2020 
*/
UPDATE Salary
SET BonusSalary = BonusSalary + (BonusSalary * 0.1)
WHERE EmployeeId IN (
    SELECT EmployeeId
    FROM Timesheets
    WHERE AttendanceDate BETWEEN '2020-10-01' AND '2020-10-31'
    GROUP BY EmployeeId
    HAVING COUNT(*) >= 20
)

/*
	5.	Truy vấn xóa Phòng ban chưa có nhân viên nào
*/
DELETE FROM Department WHERE Id NOT IN (SELECT DepartmentId FROM Employee)
GO


/*
	1.	View v_getEmployeeInfo thực hiện lấy ra danh sách Employee  gồm: Id, Name, Email, Phone, Address, Gender, BirthDay, DepartmentNamr, LevelName, Trong đó cột Gender hiển thị như sau:
		a.	0 là nữ
		b.	1 là nam 
*/
CREATE VIEW v_getEmployeeInfo 
AS
	SELECT emp.Id, emp.Name, emp.Email, emp.Phone, emp.Address, 
	CASE emp.Gender 
		WHEN 0 THEN N'Nữ'
		WHEN 1 THEN N'Nam'
		ELSE N'Khác'
	END AS gender
	, emp.BirthDay, (YEAR(GETDATE()) - YEAR(emp.BirthDay)) AS Age,
	dp.Name as DepartmentName, lvls.Name as LevelName
	FROM Employee emp 
	INNER JOIN Department dp ON emp.DepartmentId = dp.Id
	INNER JOIN Levels lvls ON emp.LevelId = lvls.Id
GO

SELECT * FROM v_getEmployeeInfo
GO

/*
	2.	View v_getEmployeeSalaryMax hiển thị danh sách nhân viên có số ngày công trong một tháng bất kỳ > 18 gòm: Id, Name, Email, Phone, Birthday, TotalDay (TotalDay là tổng số ngày công trong tháng đó)
*/
CREATE VIEW v_getEmployeeSalaryMax 
AS
SELECT  emp.Id, emp.Name, emp.Email, emp.Phone, emp.BirthDay, COUNT(tsh.EmployeeId) AS TotalDay
FROM Employee emp
LEFT JOIN Timesheets tsh ON tsh.EmployeeId = emp.Id
GROUP BY emp.Id, emp.Name, emp.Email, emp.Phone, emp.BirthDay
HAVING COUNT(tsh.EmployeeId) > 18
GO

SELECT * FROM v_getEmployeeSalaryMax
GO

/*
	1.	Thủ tục addEmployeetInfo thực hiện thêm mới nhân viên, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Employee ( Trừ cột tự động tăng )
*/
CREATE PROC addEmployeetInfo
	@name Nvarchar(150),
	@email Varchar(150),
	@phone Varchar(50),
	@address Nvarchar(255),
	@gender Tinyint,
	@birthday DATE,
	@levelId INT,
	@departmentID INT
AS
BEGIN
	INSERT INTO Employee ([Name], [Email], [Phone], [Address], [Gender], [BirthDay], [LevelId], [DepartmentId]) VALUES 
	(@name, @email, @phone, @address, @gender, @birthday, @levelId, @departmentID)
END
GO


/*
	2.	Thủ tục getSalaryByEmployeeId hiển thị danh sách các bảng lương từng nhân viên theo id của nhân viên gồm: Id, EmployeeName, Phone, Email, BaseSalary,  BasicSalary, AllowanceSalary, BonusSalary, Insurrance, TotalDay, TotalSalary (trong đó TotalDay là tổng số ngày công, TotalSalary là tổng số lương thực lãnh) Khi gọi thủ tục truyền vào id của nhân viên
*/
CREATE PROCEDURE getSalaryByEmployeeId
	@EmployeeId INT
AS
BEGIN
	DECLARE @Id INT,
		@EmployeeName NVARCHAR(150),
		@Phone VARCHAR(50),
		@Email VARCHAR(150),
		@BasicSalary FLOAT,
		@AllowanceSalary FLOAT,
		@BonusSalary FLOAT,
		@Insurance FLOAT,
		@TotalDay INT,
		@TotalSalary FLOAT;

	-- Lấy dữ liệu của nhân viên
	SELECT
		@Id = Employee.Id,
		@EmployeeName = Employee.Name,
		@Phone = Employee.Phone,
		@Email = Employee.Email,
		@BasicSalary = Levels.BasicSalary,
		@AllowanceSalary = Levels.AllowanceSalary,
		@BonusSalary = Salary.BonusSalary,
		@Insurance = Salary.Insurrance,
		@TotalDay = SUM(Timesheets.Value),
		@TotalSalary = @BasicSalary + @AllowanceSalary + @BonusSalary - @Insurance
	FROM Employee
	INNER JOIN Salary ON Employee.Id = Salary.EmployeeId
	INNER JOIN Timesheets ON Employee.Id = Timesheets.EmployeeId
	INNER JOIN Levels ON Levels.Id = Employee.LevelId
	WHERE Employee.Id = @EmployeeId
	GROUP BY Employee.Id, Employee.Name, Employee.Phone, Employee.Email, Levels.BasicSalary, Levels.AllowanceSalary, Salary.BonusSalary, Salary.Insurrance

	-- Hiển thị dữ liệu
	SELECT
		@Id AS ID,
		@EmployeeName AS EmployeeName,
		@Phone AS Phone,
		@Email AS Email,
		@BasicSalary AS BasicSalary,
		@AllowanceSalary AS AllowanceSalary,
		@BonusSalary AS BonusSalary,
		@Insurance AS Insurance,
		@TotalDay AS TotalDay,
		@TotalSalary AS TotalSalary
END
GO

EXEC getSalaryByEmployeeId 1
GO

/*
	3.	Thủ tục getEmployeePaginate lấy ra danh sách nhân viên có phân trang gồm: Id, Name, Email, Phone, Address, Gender, BirthDay, 
	Khi gọi thủ tuc truyền vào limit và page
*/
CREATE PROC getEmployeePaginate
	 @limit INT,
	 @page INT
AS
BEGIN
	SELECT emp.Id, emp.Name, emp.Email, emp.Phone, emp.Address, 
	CASE emp.Gender 
		WHEN 0 THEN N'Nữ'
		WHEN 1 THEN N'Nam'
		ELSE N'Khác'
	END AS gender, 
	emp.BirthDay, (YEAR(GETDATE()) - YEAR(emp.BirthDay)) AS Age,
	dp.Name as DepartmentName, lvls.Name as LevelName
	FROM Employee emp 
	INNER JOIN Department dp ON emp.DepartmentId = dp.Id
	INNER JOIN Levels lvls ON emp.LevelId = lvls.Id
	ORDER BY emp.id
	OFFSET @limit * (@page - 1)
	ROWS FETCH NEXT @limit ROWS ONLY
END
GO

EXEC getEmployeePaginate 5, 2
GO


/*
	1.	Tạo trigger tr_Check_Insurrance_value sao cho khi thêm hoặc sửa trên bảng Salary nếu cột Insurrance có giá trị != 10% của BasicSalary thì không cho thêm mới hoặc chỉnh sửa và in thông báo ‘Giá trị cảu Insurrance phải = 10% của BasicSalary’
*/
CREATE TRIGGER tr_Check_Insurrance_Value 
ON Salary
FOR INSERT, UPDATE 
AS
BEGIN
	DECLARE @insurrance FLOAT = (
		SELECT Insurrance FROM inserted
	)
	DECLARE @basicSalary FLOAT = (
		SELECT BasicSalary
		FROM Levels
		WHERE Id = (
			SELECT emp.LevelId
			FROM Employee emp, inserted ins
			WHERE emp.Id = ins.EmployeeId
		)
	)
    IF (@insurrance != (@basicSalary * 0.1))
    BEGIN
        RAISERROR('Giá trị của Insurrance phải = 10%% của BasicSalary', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO
-- Test Trigger
INSERT INTO Salary([EmployeeId], [BonusSalary], [Insurrance])
VALUES 
(1, 2023012312, 4000000222 * 0.1)
GO

/*
	2.	Tạo trigger tr_check_basic_salary khi thêm mới hoặc chỉnh sửa bảng Levels nếu giá trị cột BasicSalary > 10000000 thì tự động dưa về giá trị 10000000 và thông báo ‘Lương cơ bản không vượt quá 10 triệu’
*/
CREATE TRIGGER tr_check_basic_salary
ON Levels
FOR INSERT, UPDATE
AS
BEGIN
	
	IF (SELECT BasicSalary FROM inserted) > 10000000
	BEGIN
		RAISERROR(N'Lương cơ bản không vượt quá 10 triệu', 16, 1)
		UPDATE Levels SET BasicSalary = 10000000 WHERE Id = (SELECT id FROM inserted)
	END
END
GO

-- Test trigger
INSERT INTO Levels ([Name], [BasicSalary], [AllowanceSalary]) VALUES 
(N'Test Trigger', 2312312312331, 10000000)
GO
