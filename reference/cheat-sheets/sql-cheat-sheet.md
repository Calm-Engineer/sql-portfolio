# SQL Cheat Sheet

## Basic Query Structure
```sql
SELECT column1, column2
FROM table_name
WHERE condition
GROUP BY column1
HAVING group_condition
ORDER BY column1 [ASC|DESC]
LIMIT number;
```

## SELECT Statements
```sql
-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name FROM employees;

-- Select with alias
SELECT first_name AS name FROM employees;

-- Distinct values
SELECT DISTINCT department FROM employees;

-- Calculated columns
SELECT product_name, unit_price * units_in_stock AS total_value
FROM products;
```

## WHERE Clause Conditions
```sql
-- Basic comparison
SELECT * FROM products WHERE price > 100;

-- Multiple conditions
SELECT * FROM orders 
WHERE status = 'pending' 
AND total_amount > 1000;

-- IN operator
SELECT * FROM employees 
WHERE department IN ('Sales', 'Marketing');

-- BETWEEN operator
SELECT * FROM products 
WHERE price BETWEEN 10 AND 20;

-- LIKE operator
SELECT * FROM customers 
WHERE email LIKE '%@gmail.com';

-- NULL values
SELECT * FROM contacts 
WHERE phone_number IS NULL;
```

## JOIN Operations
```sql
-- Inner Join
SELECT orders.order_id, customers.customer_name
FROM orders
INNER JOIN customers 
ON orders.customer_id = customers.customer_id;

-- Left Join
SELECT employees.name, departments.dept_name
FROM employees
LEFT JOIN departments 
ON employees.dept_id = departments.dept_id;

-- Right Join
SELECT products.product_name, categories.category_name
FROM products
RIGHT JOIN categories 
ON products.category_id = categories.category_id;

-- Full Outer Join
SELECT *
FROM table1
FULL OUTER JOIN table2 
ON table1.id = table2.id;
```

## Aggregate Functions
```sql
-- COUNT
SELECT COUNT(*) FROM orders;

-- SUM
SELECT SUM(amount) FROM transactions;

-- AVG
SELECT AVG(salary) FROM employees;

-- MAX/MIN
SELECT 
    MAX(price) as highest_price,
    MIN(price) as lowest_price
FROM products;
```

## GROUP BY and HAVING
```sql
-- Basic grouping
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- Multiple grouping
SELECT department, job_title, AVG(salary) as avg_salary
FROM employees
GROUP BY department, job_title;

-- Having clause
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 10;
```

## ORDER BY and LIMIT
```sql
-- Basic sorting
SELECT * FROM products
ORDER BY price DESC;

-- Multiple column sorting
SELECT * FROM employees
ORDER BY department ASC, salary DESC;

-- Limit results
SELECT * FROM products
ORDER BY price DESC
LIMIT 5;
```

## Subqueries
```sql
-- Subquery in SELECT
SELECT employee_name,
       (SELECT AVG(salary) FROM employees) as avg_company_salary
FROM employees;

-- Subquery in WHERE
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Subquery in FROM
SELECT dept_name, avg_salary
FROM (
    SELECT department as dept_name, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) as dept_stats;
```

## INSERT Statements
```sql
-- Basic insert
INSERT INTO employees (first_name, last_name, department)
VALUES ('John', 'Doe', 'Sales');

-- Multiple row insert
INSERT INTO products (name, price)
VALUES 
    ('Product 1', 10.99),
    ('Product 2', 15.99);
```

## UPDATE Statements
```sql
-- Basic update
UPDATE employees
SET salary = 50000
WHERE department = 'Sales';

-- Multiple column update
UPDATE products
SET 
    price = price * 1.1,
    last_updated = CURRENT_TIMESTAMP
WHERE category = 'Electronics';
```

## DELETE Statements
```sql
-- Delete specific records
DELETE FROM orders
WHERE status = 'cancelled';

-- Delete all records
DELETE FROM temp_table;
```

## Common Table Expressions (CTE)
```sql
WITH employee_stats AS (
    SELECT 
        department,
        COUNT(*) as emp_count,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM employee_stats
WHERE emp_count > 10;
```

## Window Functions
```sql
-- ROW_NUMBER
SELECT 
    product_name,
    category,
    price,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as price_rank
FROM products;

-- Running total
SELECT 
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) as running_total
FROM orders;
```

## Useful Tips
- Always use appropriate indexing for better query performance
- Use EXPLAIN to analyze query execution plans
- Consider using prepared statements for parametrized queries
- Be cautious with wildcards in LIKE clauses
- Use appropriate data types for columns
- Remember to handle NULL values appropriately
