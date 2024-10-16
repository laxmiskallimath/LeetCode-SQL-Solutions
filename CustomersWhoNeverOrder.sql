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

use leetcode;

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

select * from customer;

select * from orders;

-- Customers who not ordered there id will be not present in orders table (id's are 2,4)
-- Using Sub Query
select 
      name as customer
from 
    customer
where id not in
  ( select customerid 
  from orders);

-- Using Left Join

select 
      name as cutomername
from 
    customers c1
left join 
	 orders o1
on 
   c1.id = o1.customerid -- The CustomerId in the Orders table indicates which customer placed a particular order. 
						-- Therefore, when joining the two tables, you want to link each order back to the correct customer.	
where 
o1.customerid is null;

/*
# customername
'Henry'
'Max'
*/


