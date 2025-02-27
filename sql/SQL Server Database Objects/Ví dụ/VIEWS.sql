USE QLDIEM
GO
--VIEW HIEN THI DS LOP HOC KET THUC 
--CACH DAY IT NHAT 3 NAM
CREATE VIEW GETCLASSBYCLOSEDATE
AS
SELECT *
FROM CLASS
WHERE YEAR(GETDATE()) - YEAR(CLOSEDATE) >= 3
--XEM DL CUA VIEW
SELECT *
FROM GETCLASSBYCLOSEDATE
--VIEW HIEN THI DS HOC SINH CHUA DU THI MON NAO
IF EXISTS(SELECT * FROM SYSOBJECTS WHERE NAME='GETSTUDENTBYMARK' AND TYPE='V')
	DROP VIEW GETSTUDENTBYMARK
GO
CREATE VIEW GETSTUDENTBYMARK
AS
SELECT *
FROM STUDENT
WHERE ROLLNO NOT IN(
					SELECT ROLLNO
					FROM MARK)
GO
SELECT *
FROM MARKGETSTUDENTBYMARK
--VIEW HIEN THI FULLNAME CUA HS DA DU THI IT NHAT 2 MON
CREATE VIEW COUNTSTUDENTBYMARK
AS
SELECT S.FULLNAME, COUNT(S.FULLNAME) AS 'NUMBER OF SUBJECT'
FROM STUDENT S INNER JOIN MARK M
	 ON S.ROLLNO = M.ROLLNO
GROUP BY S.FULLNAME
HAVING  COUNT(S.FULLNAME) > = 2
--XEM DL TU VIEW
SELECT *
FROM COUNTSTUDENTBYMARK
--VI DU MD COMPUTE
--HIEN THI THONG TIN DIEM CUA CAC HS
--THONG KE THEO DIEM: MAX, MIN, AVG, SUM
SELECT * 
FROM MARK
COMPUTE MAX(MARK),MIN(MARK),AVG(MARK),SUM(MARK)
--VI DU MD COMPUTE BY
--HIEN THI THONG TIN DIEM CUA CAC HS
--THONG KE THEO DIEM VOI TUNG HS: MAX, MIN, AVG, SUM
SELECT * 
FROM MARK
ORDER BY ROLLNO
COMPUTE MAX(MARK),MIN(MARK),AVG(MARK),SUM(MARK) BY ROLLNO
--XEM DN VIEW GETSTUDENTBYMARK
SP_HELPTEXT GETSTUDENTBYMARK
--XEM CAC DOI TUONG DUOC THAM CHIEU BOI VIEW GETSTUDENTBYMARK
SP_DEPENDS GETSTUDENTBYMARK

--MA HOA VIEW GETSTUDENTBYMARK
ALTER VIEW GETSTUDENTBYMARK
WITH ENCRYPTION
AS
SELECT *
FROM STUDENT
WHERE ROLLNO NOT IN(
					SELECT ROLLNO
					FROM MARK)

--VIEW HIEN THI THONG TIN DIEM THI >= 10
CREATE VIEW SHOWRESULT
AS
SELECT *
FROM MARK
WHERE MARK >= 10
WITH CHECK OPTION
--XEM DL CUA VIEW
SELECT *
FROM SHOWRESULT
--THEM 1 BO DL VAO MARK THONG QUA SHOWRESULT
INSERT INTO SHOWRESULT VALUES('A003','HDJ',10,10,10)

--TAO BANG TAM MARKTEMP
SELECT * INTO MARKTEMP FROM MARK
--TAO VIEW HIEN THI THONG TIN DIEM THI CUA HS (TREN MARKTEMP)
DROP VIEW SHOWRESULT_MARKTEMP
ALTER VIEW SHOWRESULT_MARKTEMP
WITH SCHEMABINDING
AS
SELECT ROLLNO,WMARK,PMARK,MARK
FROM DBO.MARKTEMP
WHERE MARK >= 10
--XEM DL TU VIEW SHOWRESULT_MARKTEMP
SELECT *
FROM SHOWRESULT_MARKTEMP
--XOA BANG MARKTEMP
DROP TABLE MARKTEMP
--TAO CHI MUC TREN VIEW GETSTUDENTBYMARK
CREATE UNIQUE CLUSTERED INDEX INDEX01
ON GETSTUDENTBYMARK(ROLLNO)
--VIEW HIEN THI THONG TIN LOP HOC CUA HOC VIEN 
--CO MA SO A003
CREATE VIEW GETCLASSBYROLLNO
AS
SELECT C.*,S.ROLLNO,S.FULLNAME
FROM CLASS C INNER JOIN STUDENT S
	 ON C.CLASSCODE = S.CLASSCODE
WHERE S.ROLLNO = 'A003'
--XEM DL TU VIEW
SELECT * 
FROM GETCLASSBYROLLNO
--CHEN 1 BO DL VAO VIEW GETCLASSBYROLLNO
INSERT INTO GETCLASSBYROLLNO
(CLASSCODE,HEADTEACHER,ROOM,TIMESLOT,ROLLNO)
VALUES('C0808I','DUYDT','CLASS2, LAB2','13H30 - 17H30','A110')
SELECT * FROM CLASS
--XOA DL TU VIEW
DELETE FROM GETCLASSBYROLLNO WHERE CLASSCODE = 'C0808I'