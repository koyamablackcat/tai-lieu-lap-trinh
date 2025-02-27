USE QLDIEM
select * from student
GO
SELECT * INTO MYSTUDENT FROM STUDENT
GO
SELECT * FROM MYSTUDENT

--TAO CHI MUC DANG NONCLUSTERED TREN COT FULLNAM
--BANG MYSTUDENT
--KIEM TRA XEM CHI MUC INDEX01 DA TON TAI CHUA?

IF EXISTS(SELECT * FROM SYSINDEXES WHERE NAME='INDEX01')
	DROP INDEX MYSTUDENT.INDEX01
GO

CREATE INDEX INDEX01 ON MYSTUDENT(FULLNAME DESC)

SELECT *
FROM MYSTUDENT WITH(INDEX = INDEX01)
WHERE FULLNAME LIKE '%N%'

SP_HELP MYSTUDENT
--TAO CHI MUC DANG CLUSTERED TREN COT ROLLNO
--BANG MYSTUDENT
CREATE CLUSTERED INDEX INDEX02 ON MYSTUDENT(ROLLNO DESC)


SELECT * FROM MYSTUDENT

--TAO CHI MUC DANG UNIQUE TREN COT FULLNAME
--BANG MYSTUDENT

CREATE UNIQUE INDEX INDEX03 ON MYSTUDENT
(FULLNAME,CLASSCODE) INCLUDE (ROLLNO)
WITH
(
	FILLFACTOR = 60,
	PAD_INDEX = ON,
	DROP_EXISTING = ON,
	IGNORE_DUP_KEY = ON,
	ALLOW_PAGE_LOCKS = ON
)

DELETE FROM MYSTUDENT WHERE FULLNAME = 'THANH TRONG'

SELECT *
FROM MYSTUDENT

INSERT INTO MYSTUDENT(ROLLNO,CLASSCODE,FULLNAME)
VALUES('C07','C0609M','XUAN TU')
--SUA DOI CHI MUC 
--SU DUNG REBUILD 
ALTER INDEX INDEX03 ON MYSTUDENT REBUILD
--xem tt CUA CHI MUC
SP_HELPINDEX MYSTUDENT

