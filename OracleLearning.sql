/* CREATE queries*/
/*To create table*/
create table CUSTOMERS (cust_id NUMBER(5)NOT NULL, cust_name VARCHAR(30) NOT NULL, cust_city VARCHAR(20) NULL);

CREATE TABLE  "regularcustomers" ( "RCUSTOMER_ID" NUMBER(10,0) NOT NULL ENABLE,  "RCUSTOMER_NAME" VARCHAR2(50) NOT NULL ENABLE,  "RC_CITY" VARCHAR2(50)) ;
      
CREATE TABLE  "irregularcustomers" ( "IRCUSTOMER_ID" NUMBER(10,0) NOT NULL ENABLE, "IRCUSTOMER_NAME" VARCHAR2(50) NOT NULL ENABLE,"IRC_CITY" VARCHAR2(50)); 

CREATE TABLE  SALESDEPARTMENT (ITEM VARCHAR2(4000), SALE NUMBER,  BILLING_ADDRESS VARCHAR2(4000));

CREATE TABLE EMPLOYEES(EMP_ID NUMBER,  NAME VARCHAR2(4000), AGE NUMBER,  DEPARTMENT VARCHAR2(4000), SALARY NUMBER);

/* To copy all columns from exisitng table */ 
create table CUSTOMERS_COPY AS (select * from customers);

/* To copy selected columns from existing table*/
create table CUSTOMERS_BKP AS (select cust_name, cust_city from CUSTOMERS WHERE cust_id > 500);

/* To copy selected columns from multiple tables*/
create table MULTI_CUSTOMER AS (select "regularcustomers".RCUSTOMER_ID, "regularcustomers".RC_CITY, "irregularcustomers".IRCUSTOMER_NAME
        FROM "regularcustomers", "irregularcustomers" WHERE "regularcustomers".RCUSTOMER_ID = "irregularcustomers".IRCUSTOMER_ID);
       
/* ALTER queries */
/* TO ADD columns*/
ALTER table CUSTOMERS ADD cust_age VARCHAR2(20);

ALTER table ORDERS ADD supplier_id number;

ALTER table CUSTOMERS_COPY ADD (cust_age VARCHAR2(20), cust_phone VARCHAR(50) NOT NULL);

/* TO MODIFY columns*/
ALTER table customers_bkp MODIFY cust_name VARCHAR(50);
ALTER table orders MODIFY  quantity VARCHAR(50);

/* TO DROP column */
ALTER table customers_copy DROP column cust_phone;

/* To RENAME column */
ALTER table "irregularcustomers" RENAME COLUMN IRC_CITY to IRCUSTOMER_CITY;

/* TO RENAME table*/
ALTER table MULTI_CUSTOMER RENAME TO MULTI_CUSTOMERS;

/* DROP queries*/
/* To DROP table */
DROP table MULTI_customers;

/* To DROP table with PURGE - this will delete table from recycle bin also(similar to SHIFT+DEL. Cannot be recovered later)*/
DROP table CUSTOMERS_BKP PURGE;


/* GLOBAL Temporary tables  - these are similar to normal tables, except that TEMPORARY tables can't contain foreign keys of other tables*/
create GLOBAL TEMPORARY TABLE global_students (student_id VARCHAR2(30), subject VARCHAR2(30), weight NUMBER, grade NUMBER);

/* LOCAL TEMPORARY table - these are distinct with moduels. They are defined and scoped to the session in which they are created*/
--DECLARE LOCAL TEMPORARY TABLE local_emp (emp_id varchar2(30) NOT NULL , emp_name varchar2(50), emp_address varchar(50);


/*ORACLE VIEWS */
--VIEW is a virtual table that does not physically exist. It is stored in Oracle data dictionary and do not store any data. It can be executed when called.
--A view is created by a query joining one or more tables.

CREATE TABLE SUPPLIERS ( SUPPLIER_ID NUMBER, SUPPLIER_NAME VARCHAR2(4000), SUPPLIER_ADDRESS VARCHAR2(4000)); 
CREATE TABLE ORDERS ( ORDER_NO NUMBER, QUANTITY NUMBER, PRICE NUMBER);

-- TO create or Update view
CREATE OR REPLACE VIEW supplier_orders AS select suppliers.supplier_id, orders.quantity, orders.price 
FROM suppliers INNER JOIN
ORDERS ON suppliers.supplier_id = orders.order_no WHERE suppliers.supplier_address = 'Blore';
commit;

select * from supplier_orders;

-- TO DROP view
DROP VIEW supplier_orders;


/*QUERIES */
--SELECT

select * from customers;
select cust_name, cust_city, cust_age from CUSTOMERS where cust_age < 33 and cust_city='Blore' order BY cust_age desc;

--INSERT
--TO insert single record
insert into customers VALUES (55, 'Rahul', 'Mlore', 20);

--To insert multiple rows
INSERT ALL 
    into  customers VALUES (66, 'Kotra', 'Hospet', 20)
    into  customers VALUES (77, 'Malli', 'Koppal', 18)
    into  customers VALUES (55, 'Jay', 'Bellary', 45)
select * from customers;

--UPDATE
UPDATE customers set cust_name = 'Jay' where cust_id = 88;

--Update by selecting records from another table
UPDATE customers set cust_name = (select supplier_name from suppliers where supplier_address= 'Hospet') where cust_id=88;

--DELETE
--To delete single row
DELETE from customers where cust_id=88;
DELETE from customers where cust_city='Hospet' and cust_age=20;

--To delete all rows in a table
--If we use truncate, we cannot rollback the changes
TRUNCATE table skoti.orders;
ROLLBACK;

--By using 'DELETE' command, we CAN rollback the changes
DELETE From skoti.suppliers;
ROLLBACK;


/*CLAUSES*/
--DISTINCT clause
select DISTINCT cust_city, cust_name, cust_age from customers where cust_age >= 20;


--FROM clause
select suppliers.supplier_id, suppliers.supplier_name, orders.order_no FROM 
suppliers INNER JOIN orders ON suppliers.supplier_id = orders.supplier_id;

--GROUP BY clause
select item, SUM(sale) AS "Total Sales" from Salesdepartment GROUP BY item; 
select cust_city, COUNT(*) AS "Num of customers" from CUSTOMERS GROUP BY cust_city ORDER BY cust_city desc;
select department, MIN(salary) AS "Min salary" from employees GROUP BY department;

--To find SECOND HIGHEST salary
select MIN(salary) from (select * from employees order by employees.salary desc) employees where ROWNUM<=2 ;

--HAVING clause (It is used along with GROUp BY)
select item, SUM(sale) AS "Total Sales" from Salesdepartment GROUP BY item HAVING SUM(sale)< 5000;

/*OPERATORS*/
--UNION operator
select supplier_id from orders UNION select supplier_id from suppliers;

--UNION ALL operator
select supplier_id from orders UNION ALL select supplier_id from suppliers;

select suppliers.supplier_id, suppliers.supplier_name from suppliers UNION select orders.order_no, orders.quantity from orders;

--INTERSECT operator
select supplier_id from orders INTERSECT select supplier_id from suppliers;

--MINUS operator(used to return all rows in the first SELECT statement that are not returned by the second SELECT statement.)
--In below ex, it returns rows from suppliers table which is not present in orders table.
select supplier_id from suppliers MINUS select supplier_id from orders;

/*JOINS*/
--INNER JOIN (also known as simple join. It returns all rows from multiple tables where the join condition is met.)
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity from suppliers INNER JOIN orders ON suppliers.supplier_id = orders.supplier_id;

--LEFT OUTER JOIN (returns all rows from the left (first) table specified in the ON condition and only those rows from the right (second) table where the join condition is met)
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity from suppliers LEFT JOIN orders ON suppliers.supplier_id = orders.supplier_id;

--RIGHT OUTER JOIN (returns all rows from the right-hand table specified in the ON condition and only those rows from the other table where the join condition is met)
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity from suppliers RIGHT OUTER JOIN orders ON suppliers.supplier_id = orders.supplier_id;

--FULL OUTER JOIN(returns all rows from the left hand table and right hand table. It places NULL where the join condition is not met)
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity from suppliers FULL OUTER JOIN orders ON suppliers.supplier_id = orders.supplier_id;

--EQUI JOIN (returns the matching column values of the associated tables. It uses a comparison operator in the WHERE clause to refer equality)
select suppliers.supplier_id, suppliers.supplier_name, orders.quantity from suppliers, orders WHERE suppliers.supplier_id = orders.supplier_id;

--SELF JOIN
select emp1.name, emp2.age, emp1.salary from employees emp1, employees emp2 WHERE emp1.salary < emp2.salary;

--CROSS JOIN (all rows from first table join with all of the rows of second table. If there are "x" rows in table1 and "y" rows in table2 then the cross join result set have x*y rows. It normally happens when no matching join columns are specified. In simple words you can say that if two tables in a join query have no join condition, then the Oracle returns their Cartesian product.)
select * from suppliers CROSS JOIN orders;
select * from suppliers, orders;




