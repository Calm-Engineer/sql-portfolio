Create database cloudydata;
Use cloudydata;

CREATE TABLE Employees (
    EmpID INT,
    EmpName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10,2)
);

CREATE TABLE Departments (
    DepartmentID INT,
    DepartmentName VARCHAR(50)
);

INSERT INTO Employees (EmpID, EmpName, DepartmentID, Salary) VALUES
(1, 'John Doe', 1, 50000),
(2, 'Jane Smith', 2, 60000),
(3, 'Sara Johnson', 3, 70000),
(4, 'Mike Brown', NULL, 45000),
(5, 'Tom Clark', 2, 55000);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

show tables;
select * from departments;
select * from employees;

-- PART 1

-- https://datalemur.com/questions/sql-page-with-no-likes

SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
ON pages.page_id = page_likes.page_id
WHERE page_likes.page_id IS NULL
ORDER BY pages.page_id ASC;

-- https://datalemur.com/questions/completed-trades done

SELECT users.city, COUNT(trades.order_id) AS CompletedTradeOrders 
FROM trades
LEFT JOIN users
ON trades.user_id = users.user_id
WHERE status = 'Completed'
GROUP BY users.city
ORDER BY 2 DESC
LIMIT 3;

-- https://datalemur.com/questions/second-day-confirmation 

SELECT emails.user_id
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
WHERE EXTRACT(DAY FROM texts.action_date) - EXTRACT(DAY FROM emails.signup_date) = 1;

-- https://www.hackerrank.com/challenges/asian-population/problem?isFullScreen=true done

SELECT SUM(CITY.POPULATION) AS TotalPopulation
FROM CITY
JOIN COUNTRY
ON CITY.CountryCode = COUNTRY.Code
WHERE COUNTRY.CONTINENT= 'Asia';

-- https://www.hackerrank.com/challenges/african-cities/problem?isFullScreen=true done

SELECT CITY.NAME
FROM CITY
JOIN COUNTRY
ON CITY.CountryCode = COUNTRY.Code
WHERE COUNTRY.CONTINENT= 'Africa';

-- https://www.hackerrank.com/challenges/average-population-of-each-continent/problem?isFullScreen=true done

SELECT COUNTRY.CONTINENT, TRUNCATE(AVG(CITY.POPULATION),0)
FROM CITY
JOIN COUNTRY
ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.CONTINENT;

-- https://www.w3resource.com/sql-exercises/employee-database-exercise/sql-subqueries-exercise-employee-database-74.php#google_vignette

-- https://leetcode.com/problems/employees-earning-more-than-their-managers/ (self join )

-- PART 2
-- INNER JOIN Questions:
-- 1. Basic INNER JOIN: Write a query to retrieve the names of employees and their department names for employees who belong to a department.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;

-- 2. INNER JOIN with condition: Write a query to retrieve employees with salaries greater than 50,000 and their department names.

SELECT Employees.EmpName, Departments.DepartmentName, Employees.Salary
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID AND Employees.Salary > 50000;

-- 3. INNER JOIN with multiple conditions: Write a query to retrieve employees and their department names 
--    where the salary is greater than 55,000 and the department name starts with 'S'.

SELECT Employees.EmpName, Departments.DepartmentName, Employees.Salary
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID AND Employees.Salary > 55000 AND LEFT(Departments.DepartmentName, 1) = 'S';

-- 4. INNER JOIN on multiple tables: Write a query to retrieve all employees, their department names, 
--    and their salary, but only for employees who belong to a department HR.

SELECT Employees.EmpName, Departments.DepartmentName, Employees.Salary
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID AND Departments.DepartmentName = 'HR';

-- 5. INNER JOIN with aggregate functions: Write a query to retrieve the total salary for each department, 
--    considering only departments that have employees.

SELECT Departments.DepartmentName, SUM(Employees.Salary) AS TotalSalary
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID 
GROUP BY Departments.DepartmentName;

-- LEFT JOIN Questions:

-- 6. Basic LEFT JOIN: Write a query to list all employees and their corresponding department names, including employees who do not belong to any department.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;

-- 7. LEFT JOIN with condition: Write a query to list employees whose salaries are greater than 50,000 
--    along with their department names, including those employees who do not have a department.

SELECT Employees.EmpName, Departments.DepartmentName, Employees.Salary
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID 
AND Employees.Salary >=  50000;

-- 8. LEFT JOIN with aggregate functions: Write a query to list all employees, their department names, 
--     and the average salary of employees in each department. Include employees without departments.
-- (NOT COMPLETED)

SELECT Employees.EmpName, COUNT(Departments.DepartmentName)
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY Employees.EmpName;

-- 9. LEFT JOIN to filter null: Write a query to find all employees who do not belong to any department.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName IS NULL;

-- 10. LEFT JOIN with ordering: Write a query to list all employees and their department names, 
--     sorted by department name. Include employees with no department at the end.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
ORDER BY Departments.DepartmentName DESC;

-- RIGHT JOIN Questions:

-- 11. Basic RIGHT JOIN: Write a query to list all departments and the names of employees in those departments, including departments without any employees.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
ORDER BY Departments.DepartmentName;

-- 12. RIGHT JOIN with condition: Write a query to list all departments and employees in those departments whose 
--     salaries are less than 60,000, including departments with no employees.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID AND Employees.Salary < 60000
ORDER BY Departments.DepartmentName;

-- 13. RIGHT JOIN with aggregate functions: Write a query to list all departments and the total salary of 
--     employees in each department, including departments with no employees.

SELECT Departments.DepartmentName, SUM(Employees.Salary) AS TotalSalary
FROM Departments
RIGHT JOIN Employees
ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY Departments.DepartmentName
ORDER BY Departments.DepartmentName DESC;

-- 14. RIGHT JOIN to filter null: Write a query to find all departments that have no employees.

SELECT Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.EmpName IS NULL;

-- 15. RIGHT JOIN with ordering: Write a query to list all departments and employees, sorted by employee names. 
--     Include departments without employees at the end.

SELECT Departments.DepartmentName, Employees.EmpName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
ORDER BY Employees.EmpName DESC;

-- FULL OUTER JOIN Questions:

-- 16. Basic FULL OUTER JOIN: Write a query to list all employees and all departments, including 
--     employees without departments and departments without employees.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
FULL JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;

-- OR

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
UNION
SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
UNION
SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;


-- 17. FULL OUTER JOIN with condition: Write a query to list all employees and all departments, but 
--    only include employees with no departments and departments with no employees.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
FULL JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.DepartmentID IS NULL OR Departments.DepartmentID IS NULL;

-- OR

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.DepartmentID IS NULL OR Departments.DepartmentID IS NULL
UNION
SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.DepartmentID IS NULL OR Departments.DepartmentID IS NULL
UNION
SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.DepartmentID IS NULL OR Departments.DepartmentID IS NULL;

    
-- 18. FULL OUTER JOIN with aggregate functions: Write a query to list all employees and the 
--     total salary for each department, including departments without employees and employees without departments.

SELECT Employees.EmpName, Departments.DepartmentName
FROM Employees
FULL JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.DepartmentID IS NULL OR Departments.DepartmentID IS NULL;

-- OR

SELECT 
    Employees.EmpName, Departments.DepartmentName
FROM
    Employees
        INNER JOIN
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE
    Employees.DepartmentID IS NULL
        OR Departments.DepartmentID IS NULL 
UNION SELECT 
    Employees.EmpName, Departments.DepartmentName
FROM
    Employees
        LEFT JOIN
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE
    Employees.DepartmentID IS NULL
        OR Departments.DepartmentID IS NULL 
UNION SELECT 
    Employees.EmpName, Departments.DepartmentName
FROM
    Employees
        RIGHT JOIN
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE
    Employees.DepartmentID IS NULL
        OR Departments.DepartmentID IS NULL;

-- 19. FULL OUTER JOIN with ordering: Write a query to list all employees and departments, ordered 
--    by department name, including departments and employees without a match.

-- 20. FULL OUTER JOIN filtering null: Write a query to list all departments that do not have 
--     employees and all employees who do not belong to any department.

-- Part 3 ( Used W3Schools.com for data)

-- 1. write query to find top three cities from where highest revenue getting generated 

SELECT Customers.City, ROUND(SUM(price*quantity),2) AS total_sales
FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
JOIN OrderDetails
ON Orders.OrderID=OrderDetails.OrderID
JOIN Products
ON OrderDetails.ProductID=Products.ProductID
GROUP BY Customers.City
ORDER BY ROUND(SUM(price*quantity),2) DESC
LIMIT 3;

City	total_sales
Cunewalde	122199.74
Boise	120718.85
Graz	120390.09

-- 2. city wise orders count

SELECT Customers.City, COUNT(DISTINCT OrderID) AS total_orders
FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
GROUP BY Customers.City;

Number of Records: 69
City	total_orders
Aachen	6
Albuquerque	18
Anchorage	10
Århus	11
Barcelona	5

-- 3. customers with maximum orders

SELECT Customers.CustomerName, COUNT(DISTINCT Orders.OrderID) AS total_orders, SUM(quantity) AS total_items
FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
JOIN OrderDetails
ON Orders.OrderID=OrderDetails.OrderID
GROUP BY Customers.CustomerName
ORDER BY COUNT(DISTINCT Orders.OrderID) DESC, SUM(quantity) DESC
LIMIT 10;

Number of Records: 10
CustomerName	total_orders	total_items
Save-a-lot Markets	31	4958
Ernst Handel	30	4543
QUICK-Stop	28	3961
Hungry Owl All-Night Grocers	19	1684
Folk och fä HB	19	1234
Rattlesnake Canyon Grocery	18	1383
HILARIÓN-Abastos	18	1096
Berglunds snabbköp	18	1001
Bon app'	17	980
Frankenversand	15	1525

-- 4. customer wise aov

SELECT Customers.CustomerName, ROUND(SUM(price*quantity)/COUNT(DISTINCT Orders.OrderID AND OrderDetails.OrderID),2) AS AOV
FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
JOIN OrderDetails
ON Orders.OrderID=OrderDetails.OrderID
JOIN Products
ON OrderDetails.ProductID=Products.ProductID
GROUP BY Customers.CustomerName;

Number of Records: 89
CustomerName	AOV
Alfreds Futterkiste	4596.20
Ana Trujillo Emparedados y helados	1425.15
Antonio Moreno Taquería	7616.15
Around the Horn	14264.50
B's Beverages	6638.55

-- 5. pair of customers from same countries 

SELECT C1.CustomerName, C1.Country, C2.CustomerName
FROM Customers C1
INNER JOIN Customers C2
ON C1.Country = C2.Country
WHERE C1.CustomerID <> C2.CustomerID
AND C1.CustomerID > C2.CustomerID;

Number of Records: 287
CustomerName	Country	CustomerName
Antonio Moreno Taquería	Mexico	Ana Trujillo Emparedados y helados
Blauer See Delikatessen	Germany	Alfreds Futterkiste
Bon app'	France	Blondel père et fils
B's Beverages	UK	Around the Horn
Centro comercial Moctezuma	Mexico	Ana Trujillo Emparedados y helados
Centro comercial Moctezuma	Mexico	Antonio Moreno Taquería
Consolidated Holdings	UK	Around the Horn
Consolidated Holdings	UK	B's Beverages
Drachenblut Delikatessend	Germany	Alfreds Futterkiste