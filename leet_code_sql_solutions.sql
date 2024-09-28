create database leetcode;
use leetcode;

-- ********************** 175. Combine Two Tables *****************************************************************
/*Table: Person
+-------------+---------+
| Column Name | Type |
+-------------+---------+
| PersonId | int |
| FirstName | varchar |
| LastName | varchar |
+-------------+---------+
PersonId is the primary key column for this table.

Table: Address
+-------------+---------+
| Column Name | Type |
+-------------+---------+
| AddressId | int |
| PersonId | int |
| City | varchar |
| State | varchar |
+-------------+---------+
AddressId is the primary key column for this table.
Write a SQL query for a report that provides the following information for each
person in the Person table, regardless if there is an address for each of those
people:
FirstName, LastName, City, State 
*/


create table person(
PersonId int primary key,
FirstName varchar(100),
LastName varchar(100)
);

create table address(
AddressId int primary key,
PersonID int,
City varchar(100),
State varchar(100),
foreign key(PersonId) references Person(PersonId)
);

INSERT INTO Person (PersonId, FirstName, LastName)
VALUES 
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Mike', 'Johnson');

INSERT INTO Address (AddressId, PersonId, City, State)
VALUES 
(1, 1, 'New York', 'NY'),
(2, 2, 'Los Angeles', 'CA'),
(3, 3, 'Chicago', 'IL');

select * from person;

select * from address;

/*Write a SQL query for a report that provides the following information for each
person in the Person table, regardless if there is an address for each of those
people:
FirstName, LastName, City, State */

select 
      FirstName, 
	  LastName, 
      City,
      State
from 
     person p1
left join 
     address a1
on 
    p1.PersonId = a1. PersonId;
     
-- A LEFT JOIN ensures that all rows from the Person table are included, 
-- even if there is no matching row in the Address table.

/*
Result 

# FirstName, LastName, City, State
'Jane', 'Smith', 'Los Angeles', 'CA'
'John', 'Doe', 'New York', 'NY'
'Mike', 'Johnson', 'Chicago', 'IL'

*/

--- ***************************************************************************************
-- 176 Second Highest Salary

/* Write a SQL query to get the second highest salary from the Employee table.
+----+--------+
| Id | Salary |
+----+--------+
| 1 | 100 |
| 2 | 200 |
| 3 | 300 |
+----+--------+
*/

Create Table employee(
ID int primary key,
Salary int);


INSERT INTO Employee (Id, Salary)
VALUES 
(1, 100),
(2, 200),
(3, 300);

-- Normal Approach using max,sub query,simple sql with distinct and limit,with cte and rank function 
select max(salary) from employee
where salary < (select max(salary) from employee);

-- or
select salary from
(select salary from employee order by salary desc limit 2) result
order by salary 
limit 1;

-- or
 with cte as
(select *,
       dense_rank()over(order by salary desc) as rankk
from 
      employee)
select salary 
from cte 
where rankk = 2;

-- or 
SELECT DISTINCT Salary
FROM Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1;

-- or 

-- For example, given the above Employee table, the query should return 200 as the second highest salary.
--  If there is no second highest salary, then the query should return null.
-- Here point is If there is no second highest salary, then the query should return null.
select ifnull((
select distinct Salary
from Employee
order by Salary desc
limit 1 offset 1),
null)
as SecondHighestSalary;

-- or 

with cte as
(select 
       *,
       dense_rank()over(order by salary desc) as rankk
from 
     employee)
     
select ifnull(salary ,null) as highestsalary
from cte
where rankk = 2;


/* Result
# Salary
'200'

*/



-- ***********************************************************************************************************
-- 177. Nth Highest Salary
/*
Write a SQL query to get the nth highest salary from the Employee table.
+----+--------+
| Id | Salary |
+----+--------+
| 1 | 100 |
| 2 | 200 |
| 3 | 300 |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2
is 200. If there is no nth highest salary, then the query should return null.
*/

WITH mycte AS (
    SELECT 
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS rankk
    FROM 
        Employee
)
SELECT 
    IFNULL(Salary, NULL) AS nth_highest_salary
FROM 
    mycte
WHERE 
    rankk = 2;  -- Replace 2 with the desired 'n' value
    
/* Result
# nth_highest_salary
'200'
*/

-- ****************************************************************************************************************

-- 178. Rank Scores
/*
Write a SQL query to rank scores. If there is a tie between two scores, both
should have the same ranking. Note that after a tie, the next ranking number
should be the next consecutive integer value. In other words, there should be no
"holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1 | 3.50 |
| 2 | 3.65 |
| 3 | 4.00 |
| 4 | 3.85 |
| 5 | 4.00 |
| 6 | 3.65 |
+----+-------+
For example, given the above Scores table, your query should generate the
following report (order by highest score):
+-------+------+
| Score | Rank |
+-------+------+
| 4.00 | 1 |
| 4.00 | 1 |
| 3.85 | 2 |
| 3.65 | 3 |
| 3.65 | 3 |
| 3.50 | 4 |
+-------+------+   
*/

CREATE TABLE Scores (
    Id INT PRIMARY KEY,
    Score FLOAT
);


INSERT INTO Scores (Id, Score) VALUES
(1, 3.50),
(2, 3.65),
(3, 4.00),
(4, 3.85),
(5, 4.00),
(6, 3.65);


select  
     score,
     dense_rank()over(order by score desc) as rankk
from Scores;

/*
 Result
# score, rankk
'4', '1'
'4', '1'
'3.85', '2'
'3.65', '3'
'3.65', '3'
'3.5', '4'
*/



-- ***************************************************************************************************

-- 180. Consecutive Numbers
/*
Write a SQL query to find all numbers that appear at least three times
consecutively.
+----+-----+
| Id | Num |
+----+-----+
| 1 | 1 |
| 2 | 1 |
| 3 | 1 |
| 4 | 2 |
| 5 | 1 |
| 6 | 2 |
| 7 | 2 |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears
consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1 |
+-----------------+
*/

CREATE TABLE Logs (
    Id INT PRIMARY KEY,
    Num INT
);

INSERT INTO Logs (Id, Num) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

select * from logs;

SELECT DISTINCT Num
FROM (
    SELECT Num,
           LAG(Num, 1) OVER (ORDER BY Id) AS prev1,  -- Value from 1 row before
           LAG(Num, 2) OVER (ORDER BY Id) AS prev2   -- Value from 2 rows before
    FROM Logs
) AS consecutiveNums
WHERE Num = prev1 AND Num = prev2;


/* Result
# Num
'1'
*/

-- In filter condition 
-- If Num = prev1, it means the current number is the same as the previous number.
-- If Num = prev2, it means the current number is also the same as the number from two rows back.
-- Thus, if both conditions are true, it confirms that the number has appeared three times in a row.



-- A number appears twice in a row
SELECT DISTINCT Num
FROM (
    SELECT Num,
           LAG(Num, 1) OVER (ORDER BY Id) AS prev1,  -- Value from the previous row
           LEAD(Num, 1) OVER (ORDER BY Id) AS next1  -- Value from the next row
    FROM Logs
) AS consecutiveNums
WHERE Num = prev1    -- Current number is the same as the previous one (2 consecutive appearances)
  AND (Num <> next1 OR next1 IS NULL);  -- It should not continue into the next row
-- AND (Num <> next1 OR next1 IS NULL):
-- This condition ensures that the current number is not the same as the next number (next1), or that there is no next number (next1 IS NULL).
-- This effectively means that if the current number is 2 and it appears at least twice, the sequence will stop there, and it won't count further occurrences of 2.
-- Together, these conditions ensure that you are only capturing a situation where a number appears exactly twice in succession.


-- *****************************************************************************************************************

-- 181. Employees Earning More Than Their Managers
/*
The Employee table holds all employees including their managers. Every employee
has an Id, and there is also a column for the manager Id.
+----+-------+--------+-----------+
| Id | Name | Salary | ManagerId |
+----+-------+--------+-----------+
| 1 | Joe | 70000 | 3 |
| 2 | Henry | 80000 | 4 |
| 3 | Sam | 60000 | NULL |
| 4 | Max | 90000 | NULL |
+----+-------+--------+-----------+

Given the Employee table, write a SQL query that finds out employees who earn
more than their managers. For the above table, Joe is the only employee who
earns more than his manager.
+----------+
| Employee |
+----------+
| Joe |
+----------+
*/

CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary int,
    ManagerId INT
   );

INSERT INTO Employees (Id, Name, Salary, ManagerId) VALUES
(1, 'Joe', 70000.00, 3),
(2, 'Henry', 80000.00, 4),
(3, 'Sam', 60000.00, NULL),
(4, 'Max', 90000.00, NULL);

select 
	  e1.Name as EmpName
from 
     employees e1
inner join 
employees m1
on 
    e1.managerid = m1.id
where 
   e1.salary > m1.salary;
   
 /*Result  
  # EmpName
'Joe'
*/
   
 --- *******************************************************************************************************************************
 
 -- 182. Duplicate Emails
/*
Write a SQL query to find all duplicate emails in a table named Person.
+----+---------+
| Id | Email |
+----+---------+
| 1 | a@b.com |
| 2 | c@d.com |
| 3 | a@b.com |
+----+---------+
For example, your query should return the following for the above table:
+---------+
| Email |
+---------+
| a@b.com |
+---------+
Note: All emails are in lowercase.
*/

CREATE TABLE Users (
    Id INT PRIMARY KEY,
    Email VARCHAR(100)
);

INSERT INTO Users (Id, Email) VALUES
(1, 'a@b.com'),
(2, 'c@d.com'),
(3, 'a@b.com');

select 
      Email
from 
     users
group by 
      Email
having count(Email) > 1;


/* Result 

# Email
'a@b.com'


*/


-- **********************************************************************************

-- 183. Customers Who Never Order
/*
Suppose that a website contains two tables, the Customers table and the Orders
table. Write a SQL query to find all customers who never order anything.
Table: Customers.
+----+-------+
| Id | Name |
+----+-------+
| 1 | Joe |
| 2 | Henry |
| 3 | Sam |
| 4 | Max |
+----+-------+
Table: Orders.
+----+------------+
| Id | CustomerId |
+----+------------+
| 1 | 3 |
| 2 | 1 |
+----+------------+
Using the above tables as example, return the following:
+-----------+
| Customers |
+-----------+
| Henry |
| Max |
+-----------+
*/

CREATE TABLE Customer(
    Id INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Orders (
    Id INT PRIMARY KEY,
    CustomerId INT,
    FOREIGN KEY (CustomerId) REFERENCES Customer(Id) ON DELETE CASCADE
);
INSERT INTO Customer(Id, Name) VALUES
(1, 'Joe'),
(2, 'Henry'),
(3, 'Sam'),
(4, 'Max');

INSERT INTO Orders (Id, CustomerId) VALUES
(1, 3),  -- Order 1 belongs to Sam
(2, 1);  -- Order 2 belongs to Joe

select * from Orders;

select * from Customer;

-- Customers who not ordered there id will be not present in orders table
-- Using Sub Query
Select 
       Name as Customer
from 
       Customer
where 
     Id not in (
select CustomerId
from Orders
);

-- Using Left Join

select 
      name as customername
from 
     customer c1 
left join 
     orders o1
on 
   c1. id = o1.customerid  -- The CustomerId in the Orders table indicates which customer placed a particular order. Therefore, when joining the two tables, you want to link each order back to the correct customer.
where 
     o1.customerid is null;




/*
Result 
# Customer
'Henry'
'Max'
*/

-- ******************************************************************************************************************************************

-- 196. Delete Duplicate Emails
/*
Write a SQL query to delete all duplicate email entries in a table named Persons,
keeping only unique emails based on its smallest Id.

a table named Persons
+----+------------------+
| Id | Email |
+----+------------------+
| 1 | john@example.com |
| 2 | bob@example.com |
| 3 | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the
following rows:
+----+------------------+
| Id | Email |
+----+------------------+
| 1 | john@example.com |
| 2 | bob@example.com |
+----+------------------+

Your output is the whole Person table after executing your sql. Use delete
statement.
*/

-- Create the Person table
drop table if exists Persons;

CREATE TABLE Persons (
    Id INT PRIMARY KEY,
    Email VARCHAR(255) NOT NULL
);

-- Insert data into the Person table
INSERT INTO Persons (Id, Email) VALUES (1, 'john@example.com');
INSERT INTO Persons (Id, Email) VALUES (2, 'bob@example.com');
INSERT INTO Persons (Id, Email) VALUES (3, 'john@example.com');

select * from persons;

-- Using Join
DELETE p.*
FROM Persons AS p
JOIN (
    SELECT Email, MIN(Id) AS minId
    FROM Persons
    GROUP BY Email
    HAVING COUNT(*) > 1
) AS q
ON p.Email = q.Email
WHERE p.Id > q.minId;


DELETE FROM Persons
WHERE Id NOT IN (
    SELECT MIN(Id)
    FROM Persons
    GROUP BY Email
);

-- Result
/*
# Id, Email
'1', 'john@example.com'
'2', 'bob@example.com'
*/























































 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
   


















































































































































