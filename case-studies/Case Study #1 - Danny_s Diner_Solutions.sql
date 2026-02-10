-- Create Schema
CREATE DATABASE dannys_diner;

-- Use the newly created schema
USE dannys_diner;

-- Create sales table
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INT
);

-- Insert data into sales
INSERT INTO sales (customer_id, order_date, product_id) VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);

-- Create menu table
CREATE TABLE menu (
  product_id INT,
  product_name VARCHAR(50),
  price INT
);

-- Insert data into menu
INSERT INTO menu (product_id, product_name, price) VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);

-- Create members table
CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

-- Insert data into members
INSERT INTO members (customer_id, join_date) VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

show databases;
show tables;
select* from sales;

-- Case Study Questions
-- Each of the following case study questions can be answered using a single SQL statement:

-- 1. What is the total amount each customer spent at the restaurant?
SELECT* FROM members; # customer_id
SELECT* FROM sales; # customer_id, product_id
SELECT* FROM menu; # product_id, price

SELECT s.customer_id, SUM(mu.price) AS Total_Amount_Customer_Spent
FROM sales AS s
JOIN menu AS mu ON s.product_id = mu.product_id
GROUP BY s.customer_id
ORDER BY Total_Amount_Customer_Spent DESC;

-- 2. How many days has each customer visited the restaurant?
-- SELECT* FROM members; # customer_id
SELECT* FROM sales; # customer_id, order_date
-- SELECT* FROM menu; # product_id, price

SELECT customer_id, COUNT(DISTINCT order_date) AS No_of_Customer_Visits
FROM sales
GROUP BY customer_id
ORDER BY No_of_Customer_Visits DESC;

-- 3. What was the first item from the menu purchased by each customer?
-- SELECT* FROM members; # customer_id
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name

WITH First_Item_Purchased AS (
SELECT 
	s.customer_id AS Customer, 
	s.order_date AS Purchased_Date, 
    mu.product_name AS Item, 
    RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
FROM sales s
JOIN menu mu ON s.product_id = mu.product_id
)
SELECT Customer, Purchased_Date, Item
FROM First_Item_Purchased
WHERE rnk=1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- SELECT* FROM members; # customer_id
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name

SELECT mu.product_name AS Items, count(s.product_id) AS No_of_Times_Purchased
FROM sales AS s
JOIN menu AS mu ON s.product_id = mu.product_id
GROUP BY Items
ORDER BY No_of_Times_Purchased DESC;

-- 5. Which item was the most popular for each customer?
-- SELECT* FROM members; # customer_id
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name

WITH PopularItems AS (
	SELECT
		s.customer_id AS Customer, 
		mu.product_name AS Items, 
		COUNT(s.product_id) AS No_of_Times,
		ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) DESC   # use RANK() to get equally most popular items
        ) AS rn
	FROM sales AS s
	JOIN menu AS mu ON s.product_id = mu.product_id
GROUP BY Customer, Items
)
SELECT Customer, Items, No_of_Times
FROM PopularItems
WHERE rn=1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT* FROM members; # customer_id, join_date
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name

WITH PurchasedFirst AS (
SELECT
	m.customer_id AS Customer,
    s.order_date AS Purchased_Date,
    s.product_id AS Item,
    mu.product_name AS Item_Name,
    ROW_NUMBER() OVER(PARTITION BY m.customer_id ORDER BY s.order_date) AS rn
    
FROM members m
JOIN sales s ON m.customer_id = s.customer_id
JOIN menu mu ON s.product_id = mu.product_id
WHERE
	s.order_date > m.join_date
)
SELECT Customer, Purchased_Date, Item, Item_Name
FROM PurchasedFirst
WHERE rn=1;

-- 7. Which item was purchased just before the customer became a member?
SELECT* FROM members; # customer_id, join_date
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name

WITH PurchasedBeforeMember AS (
SELECT
	m.customer_id AS Customer,
    s.order_date AS Purchased_Date_Before,
    s.product_id AS Item,
    mu.product_name AS Item_Name,
    RANK() OVER(PARTITION BY m.customer_id ORDER BY s.order_date DESC) AS rnk
    
FROM members m
JOIN sales s ON m.customer_id = s.customer_id
JOIN menu mu ON s.product_id = mu.product_id
WHERE
	s.order_date < m.join_date
)
SELECT Customer, Purchased_Date_Before, Item, Item_Name
FROM PurchasedBeforeMember
WHERE rnk=1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT* FROM members; # customer_id, join_date
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name, price

-- using CTE (WITH clause)
WITH TotalsBeforeMember AS (
SELECT
	m.customer_id AS Customer,
    COUNT(s.product_id) AS Total_Items,
    SUM(mu.price) AS Total_Amount_Spent
FROM members m
JOIN sales s ON m.customer_id = s.customer_id
JOIN menu mu ON s.product_id = mu.product_id
WHERE
	s.order_date < m.join_date
GROUP BY 
	Customer
)
SELECT Customer, Total_Items, Total_Amount_Spent
FROM TotalsBeforeMember;

-- OR 
-- without CTE (WITH clause)
SELECT
	m.customer_id AS Customer,
    COUNT(s.product_id) AS Total_Items,
    SUM(mu.price) AS Total_Amount_Spent
FROM members m
JOIN sales s ON m.customer_id = s.customer_id
JOIN menu mu ON s.product_id = mu.product_id
WHERE
	s.order_date < m.join_date
GROUP BY 
	Customer;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT* FROM members; # customer_id, join_date
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name, price

WITH Points AS (	 
SELECT
	s.customer_id AS Customer,
	SUM(
		CASE
			WHEN mu.product_name = 'sushi' THEN mu.price * 20
			ELSE mu.price * 10
			END
		) AS Total_Points
FROM sales s
JOIN menu mu ON s.product_id = mu.product_id
GROUP BY s.customer_id
)
SELECT Customer, Total_Points
FROM Points
GROUP BY Customer;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?
SELECT* FROM members; # customer_id, join_date
SELECT* FROM sales; # customer_id, order_date, product_id
SELECT* FROM menu; # product_id, product_name, price

WITH PointsWithPeriod AS (
  SELECT
    s.customer_id AS Customer,
    CASE 
      WHEN s.order_date BETWEEN m.join_date AND DATE_ADD(m.join_date, INTERVAL 7 DAY) THEN mu.price * 20     -- 2x points (10 * 2) = 20 points per $ 
																											-- in first week for all items
	  WHEN mu.product_name = 'sushi' THEN mu.price * 20           -- 2x points sushi outside first week (10*2)
      ELSE mu.price * 10                                          -- 1x points other items outside first week
    END AS Points
  FROM sales s
  JOIN members m ON s.customer_id = m.customer_id
  JOIN menu mu ON s.product_id = mu.product_id
  WHERE s.order_date <= '2023-01-31'       -- Only consider sales till end of January
)
SELECT
  Customer,
  SUM(Points) AS Total_Points
FROM PointsWithPeriod
WHERE Customer IN ('A','B')                 -- Only customer A and B as requested
GROUP BY Customer
ORDER BY Customer;

