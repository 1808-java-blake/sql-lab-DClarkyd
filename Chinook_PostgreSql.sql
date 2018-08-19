-- Part I – Working with an existing database
Daniel Clark
-- Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM Employee 
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM Employee 
WHERE lastname = 'King'
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM Employee 
WHERE firstname = 'King'
AND reportsto = null;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT title FROM album
SORT ORDER by title desc;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM customer
ORDER BY CITY asc
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre
VALUES(16000, 'funky');
INSERT INTO genre
VALUES(17000, 'monkey');

-- Task – Insert two new records into Employee table
INSERT INTO employee
VALUES(336000, 'clark', 'daniel', 'associate', null, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Tampa', 'Florida', 34562,7279492908, 3434252515, 'djclarrk@gmail.com');
INSERT INTO employee
VALUES(34000, 'BOSS', 'CODE', 'BOSS', null, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'ANTARCTICA', 'ASIA', 34562,7279492908, 3434252515, 'CODEBOSS@gmail.com');

-- Task – Insert two new records into Customer table
INSERT INTO CUSTOMER
VALUES(32323, 'BOB', 'SMITH', 'GOOGLE', '3424 GOOGLE DRIVE', 'SILICON GOOGLE', 'CALI', 'U.S.', 12414, 7271092888, 1408182408, 'OOGLE@GMAIL.COM', 2);
INSERT INTO customer
VALUES(32314, 'BILLY', 'BOB', 'TOILET INDUSTRIES', '3424 TOILET DRIVE', 'SILICON TOILET', 'CALI', 'U.S.', 12414, 7271092888, 1408182408, 'TOILET@GMAIL.COM', 3);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer
SET firstname = 'Aaron'
WHERE lastname = 'Robert';

UPDATE customer
SET lastname = 'Mitchell'
WHERE lastname = 'Walter';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist
SET name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * 
FROM invoice
WHERE billingaddress LIKE 'T%'
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * 
FROM invoice
WHERE total BETWEEN  15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * 
FROM employee
WHERE hiredate BETWEEN  '06/01/2003' AND '03/01/2004';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM customer
WHERE firstname ='Robert' AND
lastname = 'Walter';
-- SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION find_time()
RETURNS refcursor as $$
BEGIN
RETURN current_time;
END
$$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION find_length(name VARCHAR)
RETURNS INTEGER AS $$
BEGIN
RETURN LENGTH(name);
END;
$$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION find_average_of_invoice()
RETURNS INTEGER AS $$
BEGIN
RETURN AVG(total) FROM invoice;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION find_big_track()
RETURNS INTEGER AS $$
BEGIN
RETURN MAX(unitprice) FROM track;
END;
$$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION find_average_invoiceline_price()
RETURNS INTEGER AS $$
BEGIN
RETURN AVG(unitprice) FROM invoiceline;
END;
$$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
 CREATE OR REPLACE FUNCTION find_employees_after_1968()
RETURNS refcursor as $$
DECLARE 
	curs refcursor;
BEGIN
	OPEN curs for SELECT * FROM employee WHERE birthdate > '1960-12-31 00:00:00'  ;
	RETURN curs;
END;
$$ LANGUAGE plpgsql;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION find_employee_names()
RETURNS TABLE(firstname VARCHAR(20), lastname VARCHAR(20)) AS $$
BEGIN
RETURN QUERY SELECT employee.firstname, employee.lastname FROM employee ;
END;
$$ LANGUAGE plpgsql;

-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION update_info_employee()
RETURNS void AS $$
BEGIN
UPDATE employee
SET postalcode = 'AAA AAA' 
WHERE postalcode = 'T2P 2T3' ;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE FUNCTION find_employee_boss(fname VARCHAR)
RETURNS INTEGER as $$
DECLARE 
	curs refcursor;
BEGIN
	OPEN curs for SELECT * FROM employee WHERE fname = firstname;
	RETURN curs;
END;
$$ LANGUAGE plpgsql;

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION find_name_company_custome(firstnam VARCHAR)
RETURNS refcursor as $$
DECLARE 
	curs refcursor;
BEGIN
	OPEN curs for SELECT customer.firstname, company FROM customer WHERE customer.firstname = firstnam;
	RETURN curs;
END;
$$ LANGUAGE plpgsql;

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION delete_invoice(invoice_identification INTEGER)
RETURNS VOID as $$
BEGIN
DELETE FROM customers WHERE Employeeid IN (SELECT SupportRepid FROM Customers);
DELETE FROM customers WHERE Customerid IN (SELECT invoice_identification FROM invoices);
DELETE FROM invoice WHERE invoiceid = invoice_identification;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE OR REPLACE FUNCTION insert_new_customer(custid INTEGER, fname VARCHAR, lname VARCHAR, compan VARCHAR, addr VARCHAR, city VARCHAR, stat VARCHAR, countr VARCHAR, postalc VARCHAR, phone VARCHAR, faxn VARCHAR, emai VARCHAR, suppid INTEGER)
RETURNS VOID as $$
BEGIN
INSERT into customer VALUES(custid, fname, lname, compan, addr, city, stat, countr, postalc, phone, faxn, emai, suppid);
END;
$$ LANGUAGE plpgsql;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE TRIGGER no_employee_update_trig
AFTER UPDATE ON employee
FOR EACH ROW
EXECUTE PROCEDURE no_employee_update();

CREATE OR REPLACE FUNCTION no_employee_update()
RETURNS trigger AS $$
BEGIN
	IF(TG_OP = 'UPDATE') THEN
		
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE TRIGGER no_album_update_trig
AFTER UPDATE ON album
FOR EACH ROW
EXECUTE PROCEDURE no_album_update();


CREATE OR REPLACE FUNCTION no_album_update()
RETURNS trigger AS $$
BEGIN
	IF(TG_OP = 'UPDATE') THEN
		
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
- CREATE TRIGGER no_customer_delete_trig
AFTER DELETE ON customer
FOR EACH ROW
EXECUTE PROCEDURE no_customer_delete();


CREATE OR REPLACE FUNCTION no_customer_delete()
RETURNS trigger AS $$
BEGIN
	IF(TG_OP = 'DELETE') THEN
		RETURN NEW;
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;
-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE TRIGGER invoice_over_50_trig
	ON customer
    INSTEAD OF DELETE AS ROLLBACK;
    
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname, invoiceid
FROM invoice
INNER JOIN customer	on customer.customerid = invoice.customerid;
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.firstname, customer.CustomerId, lastname, invoiceId, total
FROM invoice
FULL OUTER JOIN customer	on customer.customerid = invoice.customerid;
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT title, name
FROM album
RIGHT JOIN artist ON artist.artistid = album.artistid;
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT  *
FROM album
CROSS JOIN artist 
ORDER BY name asc;
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT reportsto AS repo
FROM employee;

SELECT reportsto AS repo2
FROM employee;

SELECT *
FROM employee repo2, employee repo
WHERE repo2 = repo;




