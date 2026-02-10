-- Create Schema
CREATE DATABASE IF NOT EXISTS pizza_runner;
USE pizza_runner;

-- Drop and Create runners table
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INT,
  registration_date DATE
);

INSERT INTO runners (runner_id, registration_date) VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

-- Drop and Create customer_orders table
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INT,
  customer_id INT,
  pizza_id INT,
  exclusions VARCHAR(4),
  extras VARCHAR(10),
  order_time DATETIME
);

INSERT INTO customer_orders (order_id, customer_id, pizza_id, exclusions, extras, order_time) VALUES
  (1, 101, 1, '', '', '2020-01-01 18:05:02'),
  (2, 101, 1, '', '', '2020-01-01 19:00:52'),
  (3, 102, 1, '', '', '2020-01-02 23:51:23'),
  (3, 102, 2, '', NULL, '2020-01-02 23:51:23'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 2, '4', '', '2020-01-04 13:23:46'),
  (5, 104, 1, 'null', '1', '2020-01-08 21:00:29'),
  (6, 101, 2, 'null', 'null', '2020-01-08 21:03:13'),
  (7, 105, 2, 'null', '1', '2020-01-08 21:20:29'),
  (8, 102, 1, 'null', 'null', '2020-01-09 23:54:33'),
  (9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59'),
  (10, 104, 1, 'null', 'null', '2020-01-11 18:34:49'),
  (10, 104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');

-- Drop and Create runner_orders table
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INT,
  runner_id INT,
  pickup_time VARCHAR(19),
  distance VARCHAR(10),
  duration VARCHAR(20),
  cancellation VARCHAR(50)
);

INSERT INTO runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation) VALUES
  (1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  (2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  (3, 1, '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  (4, 2, '2020-01-04 13:53:03', '23.4', '40', NULL),
  (5, 3, '2020-01-08 21:10:57', '10', '15', NULL),
  (6, 3, 'null', 'null', 'null', 'Restaurant Cancellation'),
  (7, 2, '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  (8, 2, '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  (9, 2, 'null', 'null', 'null', 'Customer Cancellation'),
  (10, 1, '2020-01-11 18:50:20', '10km', '10minutes', 'null');

-- Drop and Create pizza_names table
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INT,
  pizza_name TEXT
);

INSERT INTO pizza_names (pizza_id, pizza_name) VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

-- Drop and Create pizza_recipes table
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INT,
  toppings TEXT
);

INSERT INTO pizza_recipes (pizza_id, toppings) VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

-- Drop and Create pizza_toppings table
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INT,
  topping_name TEXT
);

INSERT INTO pizza_toppings (topping_id, topping_name) VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');



-- Case Study Questions
-- This case study has LOTS of questions - they are broken up by area of focus including:
-- • Pizza Metrics
-- • Runner and Customer Experience
-- • Ingredient Optimisation
-- • Pricing and Ratings
-- • Bonus DML Challenges (DML = Data Manipulation Language)
-- Each of the following case study questions can be answered using a single SQL statement.
-- Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!
-- Before you start writing your SQL queries however - you might want to investigate the data, 
-- you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

SHOW TABLES;
SELECT* FROM customer_orders; # order_id (int), customer_id (int), pizza_id (int), order_time (datetime)
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM pizza_recipes; # pizza_id (int), toppings (1,2,3,4,5,6,7,8,9,10,11,12) (text)
SELECT* FROM pizza_toppings; # topping_id (1,2,3,4,5,6,7,8,9,10,11,12) (int), topping_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int )
SELECT* FROM runners; # runner_id (int), registration_date (date)

ALTER TABLE customer_orders DROP COLUMN exclusions;
ALTER TABLE customer_orders DROP COLUMN extras;
DESCRIBE runner_orders;
ALTER TABLE runner_orders MODIFY pickup_time DATETIME;

-- FIX runner_orders column 
-- 1. Check the format of your varchar data 
-- First, verify which rows do not match the expected DATETIME format.
SELECT pickup_time FROM runner_orders
WHERE STR_TO_DATE(pickup_time, '%Y-%m-%d %H:%i:%s') IS NULL
  OR pickup_time IS NULL OR pickup_time = '' OR pickup_time = 'N/A';

-- 2. Clean or fix invalid data
-- Update values that are not convertible:
-- This will set any non-convertible values to NULL so that conversion won’t fail.
UPDATE runner_orders SET pickup_time = NULL
WHERE pickup_time IS NULL OR pickup_time = '' OR LOWER(pickup_time) = 'null' OR STR_TO_DATE(pickup_time, '%Y-%m-%d %H:%i:%s') IS NULL OR pickup_time = 'N/A';

-- 3. Change the column type
-- After cleaning the bad rows, you can alter the column type safely:
ALTER TABLE runner_orders MODIFY pickup_time DATETIME;

-- FIX distance column
-- 1. Clean the data by removing non-numeric characters
-- You need to strip out the 'km' and any spaces, so only numbers remain.
UPDATE runner_orders
SET distance = TRIM(REPLACE(LOWER(distance), 'km', ''))
WHERE distance IS NOT NULL;

-- 2. Check for other non-numeric or bad entries
-- You can find any distance values that are still non-numeric:

SELECT distance FROM runner_orders
WHERE distance IS NOT NULL
  AND distance != ''
  AND distance REGEXP '[^0-9\\.]';
  
-- This will list any values that still contain non-numeric characters.
-- If you see more junk values (e.g., 'null', 'unknown', '-', 'n/a', ''), set those to NULL:

UPDATE runner_orders
SET distance = NULL
WHERE distance IN ('null', 'unknown', '-', 'n/a', '') OR distance IS NULL;

-- 3. Try the ALTER TABLE again
-- Now you can safely convert the column:

ALTER TABLE runner_orders MODIFY distance DECIMAL(4,1);

-- FIX duration column
-- 1. Clean the data by removing non-numeric characters
-- You need to strip out the 'minutes', 'mins', 'minute' and any spaces, so only numbers remain.
UPDATE runner_orders
SET duration = TRIM(REPLACE(LOWER(duration), 'minutes', ''))
WHERE duration IS NOT NULL;

UPDATE runner_orders
SET duration = TRIM(REPLACE(LOWER(duration), 'mins', ''))
WHERE duration IS NOT NULL;

UPDATE runner_orders
SET duration = TRIM(REPLACE(LOWER(duration), 'minute', ''))
WHERE duration IS NOT NULL;

-- 2. Check for other non-numeric or bad entries
-- You can find any duration values that are still non-numeric:

SELECT duration FROM runner_orders
WHERE duration IS NOT NULL
  AND duration != ''
  AND duration REGEXP '[^0-9\\.]';
  
-- This will list any values that still contain non-numeric characters.
-- If you see more junk values (e.g., 'null', 'unknown', '-', 'n/a', ''), set those to NULL:

UPDATE runner_orders
SET duration = NULL
WHERE duration IN ('null', 'unknown', '-', 'n/a', '') OR duration IS NULL;

-- 3. Try the ALTER TABLE again
-- Now you can safely convert the column:

ALTER TABLE runner_orders MODIFY duration INT;

-- FIX cancellation column
-- Check for bad entries
-- If you see more junk values (e.g., 'null', 'unknown', '-', 'n/a', ''), set those to NULL:

UPDATE runner_orders
SET cancellation= NULL
WHERE cancellation IN ('null', 'unknown', '-', 'n/a', '') OR cancellation IS NULL;

-- A. Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT COUNT(order_id) AS Pizza_Count FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT customer_id) AS Order_Count FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT* FROM runner_orders; # order_id, runner_id, pickup_time, distance, duration
DESCRIBE runner_orders;
SELECT runner_id, COUNT(order_id) AS Orders_Delivered 
FROM runner_orders 
WHERE distance IS NOT NULL 
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT* FROM customer_orders; # order_id (int), customer_id (int), pizza_id (int), order_time (datetime)
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int )

SELECT pn.pizza_name, COUNT(co.order_id) AS Pizzas_Delivered
FROM customer_orders AS co
JOIN runner_orders AS ro ON co.order_id = ro.order_id
JOIN pizza_names AS pn ON co.pizza_id = pn.pizza_id
WHERE ro.distance IS NOT NULL
GROUP BY pn.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT* FROM customer_orders; # order_id (int), customer_id (int), pizza_id (int), order_time (datetime)
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int )

SELECT co.customer_id, pn.pizza_name, COUNT(co.order_id) AS Pizzas_Ordered
FROM customer_orders AS co
JOIN runner_orders AS ro ON co.order_id = ro.order_id
JOIN pizza_names AS pn ON co.pizza_id = pn.pizza_id
WHERE pn.pizza_name IN ('Vegetarian', 'Meatlovers')
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id, pn.pizza_name;

-- OR
-- using CTE
WITH meatlovers AS (
  SELECT customer_id, COUNT(*) AS meatlovers_count
  FROM customer_orders
  WHERE pizza_id = 1
  GROUP BY customer_id
),
vegetarian AS (
  SELECT customer_id, COUNT(*) AS vegetarian_count
  FROM customer_orders
  WHERE pizza_id = 2
  GROUP BY customer_id
)
(SELECT 
  COALESCE(m.customer_id, v.customer_id) AS customer_id,
  COALESCE(m.meatlovers_count, 0) AS total_meatlovers,
  COALESCE(v.vegetarian_count, 0) AS total_vegetarian
FROM meatlovers m
LEFT JOIN vegetarian v ON m.customer_id = v.customer_id
ORDER BY customer_id)

UNION
 
(SELECT 
  COALESCE(m.customer_id, v.customer_id) AS customer_id,
  COALESCE(m.meatlovers_count, 0) AS total_meatlovers,
  COALESCE(v.vegetarian_count, 0) AS total_vegetarian
FROM meatlovers m
RIGHT JOIN vegetarian v ON m.customer_id = v.customer_id
ORDER BY customer_id);

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT* FROM customer_orders; # order_id (int), customer_id (int), pizza_id (int), order_time (datetime)
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int )

SELECT ro.order_id, COUNT(co.pizza_id) AS Max_Pizzas_Delivered
FROM customer_orders AS co
JOIN runner_orders AS ro ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL
GROUP BY ro.order_id
ORDER BY Max_Pizzas_Delivered DESC
LIMIT 1; 

-- OR 

SELECT MAX(pizza_count) AS Max_Pizzas_Delivered
FROM (
  SELECT ro.order_id, COUNT(co.pizza_id) AS pizza_count
  FROM customer_orders co
  JOIN runner_orders ro ON co.order_id = ro.order_id
  WHERE ro.distance IS NOT NULL
  GROUP BY ro.order_id
) AS order_pizza_counts;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT* FROM customer_orders; # order_id (int), customer_id (int), pizza_id (int), order_time (datetime)
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int )

DROP TABLE customer_orders;
SHOW TABLES;
CREATE TABLE customer_orders (
  order_id INT,
  customer_id INT,
  pizza_id INT,
  exclusions VARCHAR(4),
  extras VARCHAR(10),
  order_time DATETIME
);

INSERT INTO customer_orders (order_id, customer_id, pizza_id, exclusions, extras, order_time) VALUES
  (1, 101, 1, '', '', '2020-01-01 18:05:02'),
  (2, 101, 1, '', '', '2020-01-01 19:00:52'),
  (3, 102, 1, '', '', '2020-01-02 23:51:23'),
  (3, 102, 2, '', NULL, '2020-01-02 23:51:23'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 2, '4', '', '2020-01-04 13:23:46'),
  (5, 104, 1, 'null', '1', '2020-01-08 21:00:29'),
  (6, 101, 2, 'null', 'null', '2020-01-08 21:03:13'),
  (7, 105, 2, 'null', '1', '2020-01-08 21:20:29'),
  (8, 102, 1, 'null', 'null', '2020-01-09 23:54:33'),
  (9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59'),
  (10, 104, 1, 'null', 'null', '2020-01-11 18:34:49'),
  (10, 104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');

SELECT* FROM customer_orders; # order_id(int), customer_id(int), pizza_id(int), exclusions(varchar), extras(varchar), order_time(datetime)
DESCRIBE customer_orders;

UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions IN ('null', 'unknown', '-', 'n/a', '', 'NaN') OR exclusions IS NULL;

UPDATE customer_orders
SET extras = NULL
WHERE extras IN ('null', 'unknown', '-', 'n/a', '', 'NaN') OR extras IS NULL;

WITH pizza_changes AS (
  SELECT
    co.customer_id,
    CASE
      WHEN co.exclusions IS NOT NULL OR co.extras IS NOT NULL
      THEN 1 ELSE 0
    END AS has_change
  FROM customer_orders AS co
  JOIN runner_orders AS ro ON co.order_id = ro.order_id
  WHERE ro.distance IS NOT NULL
)
SELECT
  customer_id,
  SUM(has_change) AS pizzas_with_changes,
  COUNT(*) - SUM(has_change) AS pizzas_without_changes
FROM pizza_changes
GROUP BY customer_id
ORDER BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT* FROM customer_orders; # order_id(int), customer_id(int), pizza_id(int), exclusions(varchar), extras(varchar), order_time(datetime)
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int )

SELECT co.customer_id, COUNT(co.pizza_id) AS Pizzas_Delivereed_both_Exclusions_and_Extras
FROM customer_orders AS co
JOIN runner_orders AS ro ON co.order_id = ro.order_id
WHERE co.exclusions IS NOT NULL AND co.extras IS NOT NULL AND ro.cancellation IS NOT NULL
GROUP BY co.customer_id;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT* FROM customer_orders; # order_id(int), customer_id(int), pizza_id(int), exclusions(varchar), extras(varchar), order_time(datetime)

SELECT HOUR(TIME(order_time)) AS Hour_of_the_Day, COUNT(pizza_id) AS Number_of_Pizzas
FROM customer_orders
GROUP BY Hour_of_the_Day
ORDER BY Hour_of_the_Day;

-- 10. What was the volume of orders for each day of the week?
SELECT* FROM customer_orders; # order_id(int), customer_id(int), pizza_id(int), exclusions(varchar), extras(varchar), order_time(datetime), 
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int ), cancellation (varchar)

SELECT
	CASE day_num
	WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
    END AS Day_of_Week, COUNT(pizza_id) AS Volume_of_Pizzas
FROM (
SELECT pizza_id, DAYOFWEEK(DATE(order_time)) AS day_num
FROM customer_orders) AS sub
GROUP BY day_num
ORDER BY day_num;

-- OR 

SELECT DAYNAME(order_time) AS day_num, COUNT(pizza_id) AS Volume_of_Pizzas
FROM customer_orders
GROUP BY day_num
ORDER BY day_num;

-- B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT* FROM runners; # runner_id (int), registration_date (date)

SELECT YEAR(registration_date) AS Year, WEEK(registration_date) AS Week, COUNT(runner_id) AS No_of_Runners_SignedUp
FROM runners
WHERE registration_date >= '2021-01-01'
GROUP BY Year, Week
ORDER BY Year, Week;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT* FROM customer_orders; # order_id(int), customer_id(int), pizza_id(int), exclusions(varchar), extras(varchar), order_time(datetime), 
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int ), cancellation (varchar)

-- Grouping by runner_id gives the average arrival time per runner.
SELECT runner_id, AVG(Time_to_Arrive) AS Avg_Time_in_Minutes_to_Arrive
FROM (
	SELECT ro.runner_id, TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time) AS Time_to_Arrive
	FROM runner_orders AS ro
	JOIN customer_orders AS co ON ro.order_id = co.order_id) AS t1
GROUP BY runner_id;

    -- OR 

-- If you want the overall average time (across all runners):
  SELECT AVG(Time_to_Arrive) AS Avg_Time_in_Minutes_to_Arrive
FROM (
  SELECT TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time) AS Time_to_Arrive
  FROM runner_orders ro
  JOIN customer_orders co ON ro.order_id = co.order_id
) AS sub;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT* FROM customer_orders; # order_id(int), customer_id(int), pizza_id(int), exclusions(varchar), extras(varchar), order_time(datetime), 
SELECT* FROM pizza_names; # pizza_id (int), pizza_name (text)
SELECT* FROM runner_orders; # order_id (int), runner_id (int), pickup_time (varchar > datetime), distance (varchar > decimal), duration (varchar > int ), cancellation (varchar)

SELECT AVG(Time_to_Prepare) AS Avg_Time_to_Prepare, COUNT(Pizzas) AS No_of_Pizzas, 
FROM (
	SELECT co.pizza_id AS Pizzas, TIMESTAMPDIFF(MINUTE, co.order_time, ro.pickup_time) AS Time_to_Prepare
	FROM runner_orders ro
	JOIN customer_orders co ON ro.order_id = co.order_id
    WHERE ro.distance IS NOT NULL
) AS t1;
-- We could assume it takes on average 18.25 minutes to prepare one pizza. This aveage time also represents the length of the time
-- each runner reaches the store to pick up the pizza


-- 4. What was the average distance travelled for each customer?



-- 5. What was the difference between the longest and shortest delivery times for all orders?
-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- 7. What is the successful delivery percentage for each runner?

-- C. Ingredient Optimisation
-- 1. What are the standard ingredients for each pizza?
-- 2. What was the most commonly added extra?
-- 3. What was the most common exclusion?
-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
--    o Meat Lovers
--    o Meat Lovers - Exclude Beef
--    o Meat Lovers - Extra Bacon
--    o Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--    o For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

-- D. Pricing and Ratings
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
-- 2. What if there was an additional $1 charge for any pizza extras?
--    o Add cheese is $1 extra
-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--    o customer_id
--    o order_id
--    o runner_id
--    o rating
--    o order_time
--    o pickup_time
--    o Time between order and pickup
--    o Delivery duration
--    o Average speed
--    o Total number of pizzas
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and 
--   each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?