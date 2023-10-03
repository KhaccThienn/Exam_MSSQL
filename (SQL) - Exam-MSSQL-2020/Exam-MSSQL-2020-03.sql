/*
	Author: Lee Khacc Thienn
*/

CREATE DATABASE Exam_MSSQL_2020_03
GO

USE Exam_MSSQL_2020_03
GO

CREATE TABLE Teacher (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name Nvarchar(100) NOT NULL UNIQUE,
	Phone Varchar(50) NOT NULL UNIQUE, 
	Email Varchar(100) NOT NULL UNIQUE CHECK
	(
		Email LIKE '%@gmail.com'
	),
	Birthday Date CHECK (YEAR(GETDATE()) - YEAR(Birthday) >= 20)
)
GO

CREATE TABLE ClassRoom (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name Nvarchar(100) NOT NULL UNIQUE CHECK 
	(
		LEN(Name) > 6
	),
	TotalStudent INT DEFAULT 0,
	StartDate DATE NOT NULL CHECK
	(
		YEAR(StartDate) <= YEAR(GETDATE()) AND
		MONTH(StartDate) <= MONTH(GETDATE()) AND
		DAY(StartDate) <= DAY(GETDATE())
	),
	EndDate DATE,
	CHECK (EndDate > StartDate)
)
GO

CREATE TABLE TeacherClass (
	TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teacher(Id),
	ClassId INT NOT NULL FOREIGN KEY REFERENCES ClassRoom(Id),
	StartDate DATE NOT NULL DEFAULT GETDATE(),
	EndDate DATE,
	CHECK (EndDate > StartDate),
	TimeSlotStart INT NOT NULL DEFAULT 8,
	TimeSlotEnd INT NOT NULL,
	CHECK (TimeSlotEnd >= TimeSlotStart + 2),
	PRIMARY KEY (TeacherId, ClassId)
)
GO

CREATE TABLE Student (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name Nvarchar(150),
	Email Varchar(100) NOT NULL UNIQUE CHECK
	(
		Email LIKE '%@gmail.com'
	),
	Phone Varchar(50) NOT NULL UNIQUE, 
	Address Nvarchar(255),
	Gender Tinyint NOT NULL CHECK (
		Gender = 1 OR
		Gender = 2 OR
		Gender = 0
	),
	BirthDay Date NOT NULL,
	ClassId INT NOT NULL FOREIGN KEY REFERENCES ClassRoom(Id),
)
GO

CREATE TABLE Subject (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	Name Nvarchar(100) NOT NULL UNIQUE
)
GO

CREATE TABLE Marks (
	StudentId INT NOT NULL FOREIGN KEY REFERENCES Student(Id),
	SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subject(Id),
	Score INT NOT NULL CHECK
	(
		Score BETWEEN 0 AND 10
	),
	PRIMARY KEY (StudentId, SubjectId)
)
GO
------------------------------------------------

INSERT INTO Teacher (Name, Phone, Email, Birthday)
VALUES
('John Doe', '123-456-7890', 'johndoe@gmail.com', '1980-01-01'),
('Jane Doe', '987-654-3210', 'janedoe@gmail.com', '1981-02-02'),
('Peter Smith', '555-444-3333', 'petersmith@gmail.com', '1982-03-03'),
('Susan Jones', '777-666-5555', 'susanjones@gmail.com', '1983-04-04'),
('David Brown', '333-222-1111', 'davidbrown@gmail.com', '1984-05-05')
GO

INSERT INTO ClassRoom (Name, TotalStudent, StartDate, EndDate)
VALUES
('Mathsss', 10, '2023-09-01', '2023-12-31'),
('Sciences', 15, '2023-09-01', '2023-12-31'),
('Englishs', 20, '2023-09-01', '2023-12-31'),
('Historical', 25, '2023-09-01', '2023-12-31'),
('Literature', 30, '2023-09-01', '2023-12-31')
GO

INSERT INTO TeacherClass ([TeacherId], [ClassId], [EndDate], [TimeSlotEnd])
VALUES 
(1, 1, GETDATE() + 1, 8 + 2),
(1, 2, GETDATE() + 1, 8 + 3),
(1, 3, GETDATE() + 1, 8 + 4),
(2, 1, GETDATE() + 1, 8 + 6),
(2, 2, GETDATE() + 1, 8 + 2),
(3, 1, GETDATE() + 1, 8 + 3),
(3, 2, GETDATE() + 1, 8 + 4),
(3, 3, GETDATE() + 1, 8 + 5),
(4, 1, GETDATE() + 1, 8 + 7),
(4, 4, GETDATE() + 1, 8 + 8)
GO

INSERT INTO Student (Name, Email, Phone, Address, Gender, BirthDay, ClassId)
VALUES
('Scarlett Johansson', 'scarlettjohansson@gmail.com', '999-888-771277', '12345 Main Street', 2, '1997-08-08', 3),
('Ryan Reynolds', 'ryanreynolds@gmail.com', '888-777-6266', '67890 Elm Street', 1, '1998-09-09', 4),
('Emma Watson', 'emmawatson@gmail.com', '777-6663-5555', '10123 Pine Street', 0, '1999-10-10', 5),
('Robert Downey Jr.', 'robertdowneyjr@gmail.com', '333-222-112111', '123456 Maple Street', 1, '2000-11-11', 1),
('Ben Affleck', 'benaffleck@gmail.com', '999-888-7577', '567890 Elm Street', 2, '2001-12-12', 2),
('Jennifer Aniston', 'jenniferaniston@gmail.com', '888-777-6666', '910101 Oak Street', 0, '2002-01-01', 3),
('Dwayne Johnson', 'dwaynejohnson@gmail.com', '777-61366-5555', '101234 Pine Street', 1, '2003-02-02', 4),
('Gal Gadot', 'galgadot@gmail.com', '333-222-1111', '123456 Maple Street', 2, '2004-03-03', 5),
('Chris Hemsworth', 'chrishemsworth@gmail.com', '999-888-7777', '567890 Elm Street', 0, '2005-04-04', 1),
('Chris Evans', 'chrisevans@gmail.com', '888-777-126666', '910101 Oak Street', 1, '2006-05-05', 2),
('Mark Ruffalo', 'markruffalo@gmail.com', '777-6166-5555', '101234 Pine Street', 2, '2007-06-06', 3),
('Chris Pratt', 'chrispratt@gmail.com', '333-21222-1111', '123456 Maple Street', 0, '2008-07-07', 4),
('Robert Pattinson', 'robertpattinson@gmail.com', '999-878-7777', '567890 Elm Street', 1, '2009-08-08', 5),
('Kristen Stewart', 'kristenstewart@gmail.com', '888-777-6656', '910101 Oak Street', 2, '2010-09-09', 1)
GO

INSERT INTO Subject (Name)
VALUES
(	'Math'),
('Science'),
('English')
GO

INSERT INTO Marks (StudentId, SubjectId, Score)
VALUES
(1, 1, 9),
(1, 2, 8),
(1, 3, 7),
(2, 1, 8),
(2, 2, 7),
(2, 3, 6),
(3, 1, 9),
(3, 2, 8),
(3, 3, 7),
(4, 1, 7),
(4, 2, 6),
(4, 3, 8),
(5, 1, 8),
(5, 2, 7),
(5, 3, 9),
(6, 1, 5),
(6, 2, 8),
(6, 3, 5),
(7, 1, 7),
(7, 2, 5),
(7, 3, 8),
(8, 1, 0),
(8, 2, 5),
(8, 3, 9)
GO

/*
	1.	Lấy ra danh sách Student có sắp xếp tăng dần theo Name gồm các cột sau: 
	Id, Name, Email, Phone, Address, Gender, BirthDay, Age
*/
SELECT st.id, st.name, st.Phone, st.Address, st.Gender, st.BirthDay, (YEAR(GETDATE()) - YEAR(BirthDay)) AS Age
FROM Student st
ORDER BY Name ASC
GO

/*
	2.	Lấy ra danh sách Teacher gồm: Id, Name, Phone, Email, BirthDay, Age, TotalCLass
*/
SELECT tc.Id, tc.Name, tc.Phone, tc.Birthday, tc.Email, (YEAR(GETDATE()) - YEAR(tc.Birthday)) AS Age,
COUNT(*) AS TotalClass
FROM Teacher tc
INNER JOIN TeacherClass tcl ON tcl.TeacherId = tc.Id
GROUP BY tc.Id, tc.Name, tc.Phone, tc.Birthday, tc.Email

/*
	3.	Truy vấn danh sách ClassRoom gồm: Id, Name, TotalStudent, StartDate, EndDate khai giảng năm 2020
*/
SELECT cr.Id, cr.Name, COUNT(*) AS TotalStudent, cr.StartDate, cr.EndDate
FROM ClassRoom cr 
INNER JOIN Student st ON st.ClassId = cr.Id
WHERE YEAR(cr.StartDate) = 2023
GROUP BY cr.Id, cr.Name,cr.StartDate, cr.EndDate
GO

/*
	4.	Cập nhật cột ToalStudent trong bảng CLassRoom = Tổng số Student của mỗi CLassRoom theo Id của CLassRoom
*/
UPDATE ClassRoom SET TotalStudent = (SELECT COUNT(*) FROM Student ST WHERE ClassRoom.Id = ST.ClassId)

/*
	5.	Truy vấn xóa ClassRoom khai giảng trước năm 2020 mà có TotalStudent = 0
*/

DELETE FROM ClassRoom WHERE YEAR(StartDate) < 2020 AND (
	SELECT COUNT(*) as TotalStudent FROM Student ST WHERE ClassRoom.Id = ST.ClassId
) = 0
GO

/*
	1.	View v_getStudentInfo thực hiện lấy ra danh sách Student gồm: Id, Name, Email, Phone, Address, Gender, BirthDay, ClassName, MarksAvg, Trong đó cột MarksAvg hiển thị như sau:
		a.	0 < MarksAvg <=5 Loại Yếu
		b.	5 < MarksAvg < 7.5 Loại Trung bình
		c.	7.5 <= MarksAvg <= 8 Loại GIỏi
		d.	8 < MarksAvg Loại xuất sắc 
		e.	
*/
CREATE VIEW v_getStudentInfo 
AS
	SELECT st.id, st.name, st.Email, st.Phone, st.Address, st.Gender, st.BirthDay, cr.Name as ClassName, AVG(mk.Score) AS MarksAVG,
	CASE
		WHEN AVG(mk.Score) BETWEEN 0 AND 5 THEN N'Loại Yếu'
		WHEN AVG(mk.Score) BETWEEN 6 AND 7.5 THEN N'Loại Trung bình' 
		WHEN AVG(mk.Score) BETWEEN 7.5 AND 8 THEN N'Loại GIỏi' 
		WHEN AVG(mk.Score) > 8 THEN N'Loại xuất sắc'
	END AS Levels
	FROM Student st 
	INNER JOIN Marks mk ON mk.StudentId = st.Id
	INNER JOIN ClassRoom cr ON st.ClassId = cr.Id
	GROUP BY st.id, st.name, st.Email, st.Phone, st.Address, st.Gender, st.BirthDay, cr.Name
GO

SELECT * FROM v_getStudentInfo
GO

/*
	2.	View v_getStudentMax hiển thị danh sách Sinh viên có điểm trung bình >= 7.5 
*/
CREATE VIEW v_getStudentMax 
AS
	SELECT st.id, st.name, st.Email, st.Phone, st.Address, st.Gender, st.BirthDay, cr.Name as ClassName, AVG(mk.Score) AS MarksAVG,
	CASE
		WHEN AVG(mk.Score) BETWEEN 0 AND 5 THEN N'Loại Yếu'
		WHEN AVG(mk.Score) BETWEEN 6 AND 7.5 THEN N'Loại Trung bình' 
		WHEN AVG(mk.Score) BETWEEN 7.5 AND 8 THEN N'Loại GIỏi' 
		WHEN AVG(mk.Score) > 8 THEN N'Loại xuất sắc'
	END AS Levels
	FROM Student st 
	INNER JOIN Marks mk ON mk.StudentId = st.Id
	INNER JOIN ClassRoom cr ON st.ClassId = cr.Id
	GROUP BY st.id, st.name, st.Email, st.Phone, st.Address, st.Gender, st.BirthDay, cr.Name
	HAVING AVG(mk.Score) >= 7.5
GO

SELECT * FROM v_getStudentMax
GO

/*
	Thủ tục addStudentInfo thực hiện thêm mới Student, khi gọi thủ tục truyền đầy đủ các giá trị của bảng Sudent ( Trừ cột tự động tăng )
*/
CREATE PROC addStudentInfo
	@name NVARCHAR(150),
	@email VARCHAR(150),
	@phone VARCHAR(50),
	@address NVARCHAR(255),
	@gender TINYINT,
	@birthday DATE,
	@classId INT
AS
BEGIN
	INSERT INTO Student ([Name], [Email], [Phone], [Address], [Gender], [BirthDay], [ClassId]) VALUES
	(@name, @email, @phone, @address, @gender, @birthday, @classId)
END
GO

EXEC addStudentInfo N'Rtatata', 'Rtataa@gmail.com', '0392689213', N'Kim Mã - Ba Đình - Hà Nội', 1, '2003-10-31', 1
GO

/*
	Thủ tục getTeacherByTimeSlot hiển thị danh sách giảng viên đang dạy vào khung giờ bất kỳ trong ngày bất kỳ gồm: Id, Name, Phone, Email, TimeSlotStart, TImeSlotStart, Khi gọi thủ tục truyền vào TImeSlotStart và TImeSlotEnd, InDate
*/
CREATE PROC getTeacherByTimeSlot
	@TimeSlotStart INT,
	@TimeSlotEnd INT,
	@InDate DATE
AS
BEGIN
	SELECT tc.Id, tc.name, tc.Phone, tc.Email, tcl.TimeSlotStart, tcl.TimeSlotEnd
	FROM Teacher tc 
	INNER JOIN TeacherClass tcl ON tcl.TeacherId = tc.Id
	WHERE tcl.TimeSlotStart <= @TimeSlotStart AND tcl.TimeSlotEnd >= @TimeSlotEnd
	AND tcl.StartDate <= @InDate AND (tcl.EndDate IS NULL OR tcl.EndDate >= @InDate)
END
GO

EXEC getTeacherByTimeSlot 9, 11, '2023-09-19'
GO

/*
	Thủ tục getStudentPaginate lấy ra danh sách sinh viên có phân trang gồm: Id, Name, Email, Phone, Address, Gender, BirthDay, ClassName, Khi gọi thủ tuc truyền vào limit và page
*/

CREATE PROC getStudentPaginate
	@limit INT,
	@page INT
AS
BEGIN
	SELECT st.id, st.name, st.Email, st.Phone, st.Address, st.Gender, st.BirthDay, cr.Name as ClassName
	FROM Student st 
	INNER JOIN ClassRoom cr ON st.ClassId = cr.Id
	ORDER BY st.Id
	OFFSET @limit * (@page - 1) ROWS
    FETCH NEXT @limit ROWS ONLY
END
GO

EXEC getStudentPaginate 3, 1
GO


/*
	Tạo trigger tr_Check_Student_age sao cho khi thêm Sudent nếu tuổi của Student < 13 tuổi thì không cho thêm mới và thông báo lỗi ‘Sinh viên này chưa đủ tuổi học nghề này, vui lòng nhập sinh viên khác’
*/

CREATE TRIGGER tr_Check_Student_age
ON Student
AFTER INSERT 
AS
BEGIN
	IF (YEAR(GETDATE()) - (SELECT YEAR(Birthday) FROM inserted) < 13)
	BEGIN
		PRINT N'Sinh viên này chưa đủ tuổi học nghề này, vui lòng nhập sinh viên khác'
		ROLLBACK TRAN
	END
END
GO

-- Test trigger
INSERT INTO Student (Name, Email, Phone, Address, Gender, BirthDay, ClassId)
VALUES
('Scarletts Johansson', 'scarlettsjohansson@gmail.com', '999-888-277', '12345 Main Street', 2, '2020-08-08', 3)
GO

/*
	Tạo trigger tr_Update_TotalStudent khi thêm mới Student thì cập nhật cột TotalStudent rong bảng CLassRoom = tổng của Student theo CLassId
*/
CREATE TRIGGER tr_Update_TotalStudent
ON Student
AFTER INSERT
AS
BEGIN
	UPDATE ClassRoom
	SET TotalStudent = (SELECT COUNT(*) FROM Student WHERE ClassId = ClassRoom.Id)
	WHERE Id IN (SELECT ClassId FROM inserted)
END
GO

INSERT INTO Student (Name, Email, Phone, Address, Gender, BirthDay, ClassId)
VALUES
('Scarletts Johansson', 'scarlettsjohansson@gmail.com', '999-888-277', '12345 Main Street', 2, '2000-08-08', 3)
GO