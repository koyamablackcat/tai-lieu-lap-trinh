USE QLDIEM
GO
--TAO BANG MYCLASS TU CLASS
--SELECT * INTO MYCLASS FROM CLASS
SELECT * 
FROM MYCLASS
--TAO TRIGGER INSERT TREN BANG MYCLASS
--DAM BAO RANG TRUONG HEADTEACHER KO TRONG HOAC NULL
IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='CHKHEADTEACHERONINSERT' AND TYPE='TR')
	DROP TRIGGER CHKHEADTEACHERONINSERT
GO
CREATE TRIGGER CHKHEADTEACHERONINSERT
ON MYCLASS
FOR INSERT
AS
	DECLARE @HEADTEACHER VARCHAR(10)
	--LAY GIA TRI CUA HEADTEACHER 
	SELECT @HEADTEACHER = (SELECT HEADTEACHER FROM INSERTED)
	IF @HEADTEACHER = '' OR @HEADTEACHER IS NULL
	BEGIN
		--HIEN THONG BAO LOI
		PRINT 'TRUONG HEADTEACHER KO DE RONG HOAC NULL'
		--HUY GIAO DICH
		ROLLBACK TRAN
	END


--KIEM THU TRIGGER
INSERT INTO MYCLASS(CLASSCODE,HEADTEACHER) VALUES('C0804L',NULL)
--SP_HELP MYCLASS
--TAO TRIGGER INSERT DAM BAO RANG KO DUOC CHEN DONG THOI QUA 2 DONG
--VAO BANG MYCLASS
DROP TRIGGER CHKROWCOUNTONINSERT
CREATE TRIGGER CHKROWCOUNTONINSERT
ON MYCLASS
FOR INSERT
AS
	--DEM SO DONG CHEN TRONG BANG INSERTED
	IF (SELECT COUNT(*) FROM INSERTED) >= 2
	BEGIN
		PRINT 'KHONG THE CHEN DONG THOI QUA 2 DONG'
		ROLLBACK TRANSACTION
	END
--KIEM THU TRIGGER
INSERT INTO MYCLASS(CLASSCODE,HEADTEACHER) 
(SELECT CLASSCODE, HEADTEACHER FROM CLASS)

SELECT * INTO MYSTUDENT FROM STUDENT

SELECT *
FROM MYSTUDENT
--TAO TRIGGER UPDATE TREN BANG MYSTUDENT, DAM BAO RANG
--GIA TRI CAP NHAT CUA TRUONG BIRTHDATE KHONG LON HON NGAY HIN HIEN TAI
--TRIGGER MUC DONG
CREATE TRIGGER CHKBIRTHDATEONUPDATE
ON MYSTUDENT
FOR UPDATE
AS
	IF (SELECT BIRTHDATE FROM INSERTED) > GETDATE()
	BEGIN
		PRINT 'KHONG THE CAP NHAT TRUONG BIRTHDATE'
		ROLLBACK TRAN
	END
--KIEM THU TRIGGER

UPDATE MYSTUDENT
SET BIRTHDATE = '04-04-2009'
WHERE ROLLNO = 'A001'

--TAO TRIGGER UPDATE TREN BANG MYSTUDENT, DAM BAO RANG
--TRUONG ROLLNO KO DUOC CAP NHAT
--TRIGGER MUC COT
DROP TRIGGER CHKROLLNOONUPDATE
CREATE TRIGGER CHKROLLNOONUPDATE
ON MYSTUDENT
FOR UPDATE
AS
 --IF UPDATE(ROLLNO)
 IF (SELECT ROLLNO FROM INSERTED) NOT IN (SELECT ROLLNO FROM DELETED)
 BEGIN
	PRINT 'TRUONG ROLLNO KO DUOC CAP NHAT'
	ROLLBACK TRAN
 END
GO
--KIEM THU TRIGGER
UPDATE MYSTUDENT
SET ROLLNO = 'A0001'
WHERE ROLLNO = 'A001'
--TAO TRIGGER DELETE TREN BANG MYSTUDENT, DAM BAO RANG
--SINH VIEN A001 KO DUOC XOA 
CREATE TRIGGER CHKROLLNOONDELETE
ON MYSTUDENT
FOR DELETE
AS
 IF 'A001' IN (SELECT ROLLNO FROM DELETED)
 BEGIN
	PRINT 'KHONG THE XOA SINH VIEN A001'
	ROLLBACK TRAN
 END
DELETE FROM MYSTUDENT
WHERE ROLLNO = 'A002'

--
ALTER TABLE MYSTUDENT ADD CONSTRAINT FK_MYSTUDENT
FOREIGN KEY (CLASSCODE) REFERENCES MYCLASS(CLASSCODE)

SELECT * FROM MYCLASS
DELETE FROM MYCLASS 
WHERE CLASSCODE = 'C0609M'
--TAO TRIGGER XOA DAY CHUYEN TREN BANG MYCLASS
CREATE TRIGGER DELETEONMYCLASS
ON MYCLASS
INSTEAD OF DELETE
AS
 --XOA CAC BANG CON
 DELETE FROM MYSTUDENT WHERE CLASSCODE IN (SELECT CLASSCODE FROM DELETED)
 --XOA BANG CHA
 DELETE FROM MYCLASS WHERE CLASSCODE IN (SELECT CLASSCODE FROM DELETED)

CREATE TRIGGER CHKCREATETABLE
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
	PRINT 'BAN KO CO QUYEN TAO BANG'
	ROLLBACK TRAN
END
GO
CREATE TABLE T(COL1 INT, COL2 CHAR(1))

SELECT * FROM SYS.SQL_MODULES 
WHERE OBJECT_ID = OBJECT_ID('CHKCREATETABLE')