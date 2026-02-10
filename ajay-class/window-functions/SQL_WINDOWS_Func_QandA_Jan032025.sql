
-- Create the sales table
CREATE TABLE sales (
    id INT PRIMARY KEY,
    salesperson VARCHAR(50),
    region VARCHAR(50),
    sales_amount DECIMAL(10, 2)
);

show databases;
show tables;

-- Insert sample data into the sales table
INSERT INTO sales (id, salesperson, region, sales_amount) VALUES
(1, 'Alice', 'North', 5000),
(2, 'Bob', 'South', 7000),
(3, 'Charlie', 'East', 7000),
(4, 'Dave', 'West', 6000),
(5, 'Eve', 'North', 8000),
(6, 'Frank', 'South', 5000),
(7, 'Grace', 'East', 7000),
(8, 'Heidi', 'West', 6000),
(9, 'Ivan', 'North', 8000),
(10, 'Judy', 'South', 9000);

select * from sales;

## 20 Questions Based on `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, and `PARTITION BY`

-- 1. What is the difference between `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()` functions?

-- RANK() : Assigns same rank to ties, Skips the next ranks equal to number of ties, Creates gaps in sequence when there are ties
-- DENSE_RANK() : Assigns same rank to ties, Does NOT skip ranks for ties, Always generates consecutive ranks
-- ROW_NUMBER() : Assigns unique sequential numbers to each row, Never produces ties/duplicates, Always generates consecutive numbers

-- 2. Write a query to assign row numbers to each row in the `sales` table.

SELECT *, 
ROW_NUMBER() OVER(ORDER BY id) AS row_num
FROM sales;

-- 3. Write a query to rank salespeople based on their sales amounts in descending order.

SELECT *, 
RANK() OVER(ORDER BY sales_amount DESC) AS sales_rank
FROM sales;

-- 4. Write a query to dense rank salespeople based on their sales amounts in descending order.

SELECT *, 
DENSE_RANK() OVER(ORDER BY sales_amount DESC) AS sales_rank
FROM sales;

-- 5. Write a query to find the salesperson(s) with the highest sales amount in each region.

SELECT salesperson, region, sales_amount FROM
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) AS region_highest_sales
FROM sales) AS t1
WHERE region_highest_sales=1;

-- OR

-- Using MAX() with a window function
SELECT *
FROM sales s1
WHERE sales_amount = (
    SELECT MAX(sales_amount)
    FROM sales s2
    WHERE s1.region = s2.region
);

-- Using RANK() instead of DENSE_RANK()
SELECT salesperson, region, sales_amount 
FROM (
    SELECT *, 
        RANK() OVER(
            PARTITION BY region 
            ORDER BY sales_amount DESC
        ) AS region_highest_sales
    FROM sales
) AS t1
WHERE region_highest_sales = 1;


-- 6. Write a query to rank salespeople based on their sales amounts within each region.

SELECT *, 
RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) AS regional_sales_rank
FROM sales;

-- 7. Write a query to dense rank salespeople based on their sales amounts within each region.

SELECT *, 
DENSE_RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) AS regional_sales_rank
FROM sales;

-- 8. Write a query to assign row numbers to salespeople within each region.

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY region ORDER BY id) AS row_num
FROM sales;

-- 9. What happens if two salespeople have the same sales amount when using the `RANK()` function?

-- Assigns same rank to ties

-- 10. What happens if two salespeople have the same sales amount when using the `DENSE_RANK()` function?

-- Assigns same rank to ties

-- 11. Write a query to find the top 3 salespeople with the highest sales amounts across all regions.

SELECT * FROM (
    SELECT salesperson, sales_amount,
    DENSE_RANK() OVER(ORDER BY sales_amount DESC) AS sales_rank  -- RANK() can be used instead
    FROM sales
) AS t1
WHERE sales_rank <= 3;

-- 12. Write a query to find the top 3 salespeople with the highest sales amounts within each region.

SELECT * FROM
(SELECT *,
DENSE_RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) AS regional_top_sales  -- RANK() can be used instead
FROM sales) AS t1
WHERE regional_top_sales < 4;

-- 13. Explain how the `PARTITION BY` clause works in the context of window functions.

-- The PARTITION BY clause divides the result set into partitions (groups) where the window function is applied separately. 
-- Think of it as creating smaller windows within your data where calculations are performed independently.

-- 14. Write a query to calculate the cumulative sales amount for each salesperson.

SELECT id, salesperson, region, sales_amount, 
SUM(sales_amount) OVER (PARTITION BY salesperson ORDER BY id) as cumulative_sales
FROM sales;

-- 15. Write a query to calculate the cumulative sales amount for each salesperson within each region.

SELECT id, salesperson, region, sales_amount, 
SUM(sales_amount) OVER (PARTITION BY region, salesperson ORDER BY id) as cumulative_sales
FROM sales;

-- 16. Write a query to rank salespeople based on their sales amounts, partitioned by region and ordered by sales amount.

SELECT id, salesperson, region, sales_amount, 
DENSE_RANK() OVER(PARTITION BY region ORDER BY sales_amount DESC) as salesperson_ranking
FROM sales;

-- 17. Write a query to find the salesperson with the lowest sales amount in each region.

SELECT * FROM 
(SELECT id, salesperson, region, sales_amount, 
DENSE_RANK() OVER(PARTITION BY region ORDER BY sales_amount ASC) as sales_rank_LTH
FROM sales) AS t1
WHERE sales_rank_LTH = 1;

-- 18. Write a query to rank salespeople based on their sales amounts, with ties being given the same rank.

SELECT *, 
RANK() OVER(ORDER BY sales_amount DESC) as sales_rank_HTL
FROM sales;

-- 19. Write a query to dense rank salespeople based on their sales amounts, with ties being given the same rank.

SELECT *, 
DENSE_RANK() OVER(ORDER BY sales_amount DESC) as sales_dRANK_HTL
FROM sales;

-- 20. Write a query to assign row numbers to salespeople within each region and order by sales amount in descending order.

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales_amount DESC) as salesperson_HTL
FROM sales;
