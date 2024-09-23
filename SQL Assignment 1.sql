-- Question No 1
--Answer
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(256),
    salary INT,
    managerId INT
);

INSERT INTO Employee (id, name, salary, managerId) 
VALUES
(1, 'Alice', 70000, NULL), 
(2, 'Bob', 60000, 1), 
(3, 'Charlie', 60000, 1), 
(4, 'David', 50000, 2),
(5, 'Eve', 55000, 2);

-- Query Examples
-- a. List all Employees
SELECT * FROM Employee;

--  List all Employees with their Manager's Name
SELECT e1.id, e1.name, e1.salary, e2.name AS managerName
FROM Employee e1
LEFT JOIN Employee e2 ON e1.managerId = e2.id;

--  Find Employees with Salaries Greater than 60,000
SELECT * FROM Employee
WHERE salary > 60000;

SELECT AVG(salary) AS average_salary FROM Employee;

SELECT * FROM Employee
WHERE managerId = 1;

SELECT e2.name AS managerName, e1.name AS employeeName
FROM Employee e1
JOIN Employee e2 ON e1.managerId = e2.id
ORDER BY e2.name;

--Answer No 2

CREATE TABLE PERSON(
	id INT PRIMARY KEY IDENTITY(1,1),
	email VARCHAR (256));

INSERT INTO PERSON (email)
VALUES 
	('huzaifa@1.com'),
	('huzaifa@2.com'),
	('huzaifa@1.com'),
	('any12@.com'),
	('xyz@1.com'),
	('any12@.com');

select * from PERSON;

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;

--Answer No 3

WITH DuplicateEmails AS (
    SELECT
        email,
        MIN(id) AS min_id
    FROM
        Person
    GROUP BY
        email
)
DELETE p
FROM
    Person p
JOIN
    DuplicateEmails de
ON
    p.email = de.email
    AND p.id > de.min_id;


SELECT * FROM PERSON;


--Answer No 4

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Employees (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

CREATE TABLE EmployeeUNI (
    id INT,
    uniqueid INT,
    PRIMARY KEY (id, uniqueid)
);

INSERT INTO EmployeeUNI (id, uniqueid) VALUES
(1, 101),
(3, 103);

SELECT
    e.id AS id,
    e.name AS name,
    eu.uniqueid AS uniqueid
FROM
    Employees e
LEFT JOIN
    EmployeeUNI eu
ON
    e.id = eu.id;


--Answer No 5

CREATE TABLE employe(
	employee_id INT, 
	name VARCHAR (256),
	DepartmentId INT,
	salary int);

INSERT INTO employe (employee_id, name, departmentid, salary)
values
		(123, 'Adil shahzad', 2, 50000),
		(134, 'Huzaifa Mehmood', 4, 60000),
		(120, 'Adnan', 5, 100000),
		(129, 'Ameen', 6, 20000),
		(134, 'Moin', 7, 75000),
		(130, 'Shamim',3, 80000),
		(138, 'Saleem', 9, 95000);

SELECT * FROM employe;

WITH MinSalaries AS (
    SELECT
        departmentid,
        MIN(salary) AS MinSalary
    FROM
        employe
    GROUP BY
        departmentiD
)
SELECT
    e.employee_id,
    e.Name,
    e.departmentiD,
    e.salary
FROM
    employe e
JOIN
    MinSalaries ms
ON
    e.DepartmentID = ms.DepartmentID
    AND e.Salary = ms.MinSalary;

select salary
from employe
where salary = 20000;

--Answer No 6

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderItems (
    OrderID INT,
    ItemID INT,
    Quantity INT
);

-- Sample data for Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1001, '2024-08-01'),
(2, 1002, '2024-08-02'),
(3, 1001, '2024-08-03');

-- Sample data for OrderItems
INSERT INTO OrderItems (OrderID, ItemID, Quantity) VALUES
(1, 2001, 5),
(1, 2002, 3),
(2, 2003, 7),
(3, 2004, 2);

-- Calculate total order quantity for each customer
WITH CustomerTotalQuantities AS (
    SELECT
        o.CustomerID,
        SUM(oi.Quantity) AS TotalQuantity
    FROM
        Orders o
    JOIN
        OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY
        o.CustomerID
)

-- Find the customer with the highest total quantity
SELECT TOP 1
    CustomerID,
    TotalQuantity
FROM
    CustomerTotalQuantities
ORDER BY
    TotalQuantity DESC;


--Answer No 7 

CREATE TABLE Customers (
    CustomerID INT,
    Name VARCHAR(255),
    JoinDate DATE
);


-- Sample data for Customers
INSERT INTO Customers (CustomerID, Name, JoinDate) VALUES
(1, 'Alice', '2024-07-01'),
(2, 'Bob', '2024-06-15'),
(3, 'Charlie', '2024-07-20');

-- Sample data for Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2024-07-05'),
(2, 2, '2024-06-25'),
(3, 3, '2024-07-30'),
(4, 1, '2024-08-01');


-- Find the first order date for each customer
WITH FirstOrderDates AS (
    SELECT
        o.CustomerID,
        MIN(o.OrderDate) AS FirstOrderDate
    FROM
        Orders o
    GROUP BY
        o.CustomerID
)

-- Select customers who placed their first order within the last 30 days
SELECT
    c.CustomerID,
    c.Name,
    c.JoinDate,
    fod.FirstOrderDate
FROM
    Customers c
JOIN
    FirstOrderDates fod ON c.CustomerID = fod.CustomerID
WHERE
    fod.FirstOrderDate >= DATEADD(DAY, -30, GETDATE());

	--Answer No 8

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT
);

-- Sample data
INSERT INTO Employee (id, salary) VALUES
(1, 5000),
(2, 6000),
(3, 6000),
(4, 7000);

WITH RankedSalaries AS (
    SELECT
        salary,
        ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
    FROM
        Employee
)
SELECT
    salary
FROM
    RankedSalaries
WHERE
    rank = 2;


	--Answer No 9

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT,
    name VARCHAR(255),
    departmentId INT
);

-- Sample data
INSERT INTO Employee (id, salary, name, departmentId) VALUES
(1, 5000, 'Alice', 1),
(2, 7000, 'Bob', 1),
(3, 6000, 'Charlie', 2),
(4, 8000, 'David', 2),
(5, 6500, 'Eve', 2);


WITH RankedEmployees AS (
    SELECT
        id,
        name,
        departmentId,
        salary,
        ROW_NUMBER() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rn
    FROM
        Employee
)
SELECT
    id,
    name,
    departmentId,
    salary
FROM
    RankedEmployees
WHERE
    rn = 1;


CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);


-- Sample data for Department
INSERT INTO Department (id, name) VALUES
(1, 'Sales'),
(2, 'Engineering');

-- Find the highest salary in each department
WITH HighestSalaries AS (
    SELECT
        departmentId,
        MAX(salary) AS HighestSalary
    FROM
        Employee
    GROUP BY
        departmentId
)

-- Get employees with the highest salary in each department and their department names
SELECT
    e.id,
    e.name,
    e.salary,
    d.name AS departmentName
FROM
    Employee e
JOIN
    HighestSalaries hs ON e.departmentId = hs.departmentId AND e.salary = hs.HighestSalary
JOIN
    Department d ON e.departmentId = d.id;


-- Answer No 10

CREATE TABLE Product (
    Product_key INT PRIMARY KEY
);

CREATE TABLE Customer (
    Customer_id INT,
    Product_key INT
);

-- Sample data for Product
INSERT INTO Product (Product_key) VALUES
(1),
(2),
(3);

-- Sample data for Customer
INSERT INTO Customer (Customer_id, Product_key) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(3, 1),
(3, 2);

-- Step 1: Find the total number of distinct products
WITH TotalProducts AS (
    SELECT COUNT(DISTINCT Product_key) AS TotalProductCount
    FROM Product
),

-- Step 2: Find the number of distinct products purchased by each customer
CustomerProductCounts AS (
    SELECT
        Customer_id,
        COUNT(DISTINCT Product_key) AS PurchasedProductCount
    FROM
        Customer
    GROUP BY
        Customer_id
)

-- Step 3: Find customers who bought all products
SELECT
    c.Customer_id
FROM
    CustomerProductCounts c
JOIN
    TotalProducts t ON c.PurchasedProductCount = t.TotalProductCount;
