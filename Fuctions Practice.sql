****************************************************************
			FUCNTIONS IN PLSQL
****************************************************************
CREATE OR REPLACE FUNCTION check_cal(name VARCHAR2) 
RETURN BOOLEAN IS
surname bk_author.lname%TYPE;
v_cost bk_costs.cost%TYPE;
v_title bk_books.title%TYPE;
mycost bk_costs.cost%TYPE;

BEGIN
SELECT MAX(a.lname), MAX(c.cost), MAX(b.title) 
INTO surname, v_cost, v_title
FROM bk_author a, bk_costs c, bk_books b 
WHERE a.fname = name
AND b.authorid = a.authorid
AND b.isbn = c.isbn;

SELECT AVG(cost) INTO mycost
FROM bk_costs;

--- This is where the function starts.---
IF v_cost < mycost THEN 
	RETURN TRUE;
ELSE 
	RETURN FALSE;
END IF;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('There is no such here.');
		RETURN FALSE;
	WHEN TOO_MANY_ROWS THEN 
		DBMS_OUTPUT.PUT_LINE('Returns too many rows, mama.');
		RETURN FALSE;
END;
/

---CHECKING ERRORS IN A FUNCTION -----
SHOW ERRORS FUNCTION check_cal;

---EXECUTING THE FUCNTION ---
DECLARE 
	myresult BOOLEAN;
BEGIN
	myresult := check_cal('SAM');
	
	IF myresult THEN
		DBMS_OUTPUT.PUT_LINE('The thing is below average, babe.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('The thing is above average, girl');
	END IF;
END;
/
=====================FUNCTION WORKS BHEB!!===============
****************************************************************
			PROCEDURES IN PLSQL
****************************************************************
CREATE TABLE owntable AS SELECT * FROM BK_AUTHOR;
CREATE OR REPLACE PROCEDURE ownpro IS 
	id bk_author.authorid%TYPE;
	name bk_author.fname%TYPE;
	surname bk_author.lname%TYPE;
BEGIN
	id :='2003';
	name := 'Yolanda';
	surname := 'Mbande';
	
	INSERT INTO owntable(authorid, fname, lname)
	VALUES(id, name, surname);
DBMS_OUTPUT.PUT_LINE('Inserted '||SQL%ROWCOUNT||' rows.');
END;
/
---- CHECKING ERRORS WITHIN THE PROCEDURE ------
SHOW ERRORS PROCEDURE ownpro;
---- EXECUTING A PROCEDURE ----
BEGIN
	ownpro;
END;
/
--- CHECK IF VALUES ARE IN THE NEW TABLE ---
SELECT * FROM owntable;
===========PROCEDURE WORKS BHEB ===============
---- PRCOCEDIRES WITH PARAMETERS ------
---------- FIND AUTHOR NAME USING THEIR AUTHOR ID ----
CREATE OR REPLACE PROCEDURE get_author
(
	id IN bk_author.authorid%TYPE,
	name OUT bk_author.fname%TYPE,
	surname OUT bk_author.lname%TYPE
) IS
BEGIN
	SELECT fname, lname 
	INTO name, surname
	FROM bk_author
	WHERE authorid = id;
END;
/
------ EXECUTING THIS PROCEDURE ----
DECLARE
    v_name bk_author.fname%TYPE;
    v_surname bk_author.lname%TYPE;
BEGIN
    get_author('S100', v_name, v_surname);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name || ', Surname: ' || v_surname);
END;
/
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
$$$$$$$$$$$$$$$$$$$$$$$$$$$$ WORK WITH EXCEPTION $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--- TRAPPING USER DEFINED EXCEPTIONS ----
DECLARE 
	id VARCHAR2(4) :='S101';
	catr VARCHAR2(12) := 'ISKOLO';
	e_invalid_category EXCEPTION;
BEGIN
	UPDATE bk_books
	SET category = catr 
	WHERE id = authorid;
	
	IF SQL%NOTFOUND THEN 
		RAISE e_invalid_category;
	END IF;
	COMMIT;
EXCEPTION 
	WHEN e_invalid_category THEN 
		DBMS_OUTPUT.PUT_LINE('My exception works if this appears.');
END;
/
--- RAISE APPLICATION ERROR PROCEDURE/EXCEPTION ---
DECLARE 
	id VARCHAR2(4) :='S101';
	catr VARCHAR2(12) := 'ISKOLO';
BEGIN
	UPDATE bk_books
	SET category = catr 
	WHERE id = authorid;
	
	IF SQL%NOTFOUND THEN 
		RAISE_APPLICATION_ERROR(-20202,'My exception works if this appears.');
	END IF;
END;
/
---- NB : this error appears like an sql error, be ware. READ, YOLANDA. ----

**********************************************************************************
**********************************************************************************
				WORKING WITH CURSORS
**********************************************************************************
**********************************************************************************