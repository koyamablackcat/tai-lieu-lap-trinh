use qldiem
GO
SP_HELP MYSTUDENT
--VIEW ALL STUDENT
SELECT * 
FROM MYSTUDENT
--VIET THU TUC LUU TRU: LIET KE TAT CA SINH VIEN CUA BANG MYSTUDENT
--TAO THUC TUC
CREATE PROCEDURE VIEWALLSTUDENT1
AS
SELECT * 
FROM MYSTUDENT1
--THUC THI THU TUC
EXEC VIEWALLSTUDENT
VIEWALLSTUDENT

SELECT * FROM SYS.SQL_MODULES WHERE OBJECT_ID = OBJECT_ID('VIEWALLSTUDENT')
--THU TUC PHIEN - CUC BO
--LIET KE CAC SINH VIEN CO GIOI TINH LA NAM
CREATE PROC ##VIEWALLFEMALE
AS
SELECT *
FROM MYSTUDENT WHERE MALE = 0

EXEC ##VIEWALLFEMALE


--TAO THUC TUC LIET KE SINH VIEN CO GIOI TINH BANG M
--M: THAM SO VAO
--NEU TON TAO VIEWBYGENDER
IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME = 'VIEWBYGENDER' AND TYPE='P')
	DROP PROC VIEWBYGENDER
GO
CREATE PROC VIEWBYGENDER
@M BIT 
AS
	SELECT * 
	FROM MYSTUDENT WHERE MALE = @M
--XEM CAC NAM SINH VIEN, M = 1
GO
EXEC VIEWBYGENDER 0
--VIET THU TUC DEM SO LUONG SINHVIEN CO GIOI TINH = M
--M: THAM SO VAO
--SLUONG SINHVIEN: THAM SO RA
ALTER PROC COUNTBYGENDER
@M BIT,@COUNT INT OUTPUT
WITH ENCRYPTION
AS
SELECT @COUNT = COUNT(*)
FROM MYSTUDENT
WHERE MALE = @M
--THUC THI THU TUC
DECLARE @M BIT,
		@COUNT INT
SET @M = 0--VIEW MALE
EXEC COUNTBYGENDER @M, @COUNT OUTPUT
PRINT 'TONG SO SINH VIEN LA: ' + CAST(@COUNT AS VARCHAR(2))
--XEM DINH NGHIA THU TUC
SP_HELPTEXT COUNTBYGENDER

SELECT OBJECT_DEFINITION(OBJECT_ID('COUNTBYGENDER'))
--XEM CAC DOI TUONG PHU THUOC SP
SP_DEPENDS COUNTBYGENDER
--VIET THU TUC THEM VAO BANG MYSTUDENT 1 BAN GHI
SP_HELP MYSTUDENT
CREATE PROC ADDTOMYSTUDENT
@ROLLNO VARCHAR(6),
@CLASSCODE VARCHAR(6),
@FULLNAME VARCHAR(30),
@MALE BIT
AS
INSERT INTO MYSTUDENT VALUES(@ROLLNO,@CLASSCODE,@FULLNAME,@MALE)
--THU TUC GOI ADDTOMYSTUDENT
CREATE PROC MYADDING
AS
EXEC ADDTOMYSTUDENT 'B00100','C0809G','ANHNT',1
--THUC THI MYADDING
EXEC MYADDING
--KIEM TRA
SELECT * FROM MYSTUDENT
--THU TUC TINH TONG CAC SO TU M DEN N
--M, N: CAC THAM SO VAO
CREATE PROC MYSUM
@M INT, @N INT
AS
	DECLARE @I INT,
			@S INT
	SET @I = @M
	SET @S = 0
	IF @M > @N 
		RETURN -1
	WHILE @I <= @N
	BEGIN
		SET @S = @S + @I
		SET @I = @I + 1
	END
	PRINT 'SUM = ' + CAST(@S AS CHAR(3))
	RETURN 0
--thuc thi thu tuc
DECLARE @M INT,
		@N INT,
		@STATUS INT
SET @M = 15
SET @N = 10
EXEC @STATUS = MYSUM @M, @N
IF @STATUS <> 0
	PRINT 'MYSUM FAIL'



