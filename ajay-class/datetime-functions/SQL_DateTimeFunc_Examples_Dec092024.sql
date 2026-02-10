-- 1. Basic Date and Time Functions
SELECT *, 
       YEAR(RegistrationDateTime) AS Year, 
       MONTH(RegistrationDateTime) AS Month, 
       DAY(RegistrationDateTime) AS Day,
       DATE(RegistrationDateTime) AS Date,
       WEEK(RegistrationDateTime) AS Week,
       TIME(RegistrationDateTime) AS Time,
       HOUR(RegistrationDateTime) AS Hour,
       MINUTE(RegistrationDateTime) AS Minute,
       SECOND(RegistrationDateTime) AS Second
FROM customer_table;

-- 2. Extract Year from RegistrationDateTime
SELECT EXTRACT(YEAR FROM RegistrationDateTime) AS Year
FROM customer_table;

-- 3. Select Customers from the Year 2024
SELECT * 
FROM customer_table 
WHERE YEAR(RegistrationDateTime) = 2024;

-- 4. Select Customers from the Current Year
SELECT * 
FROM customer_table
WHERE YEAR(RegistrationDateTime) = YEAR(CURRENT_DATE);

-- 5. Get the Current Year
SELECT YEAR(CURRENT_DATE);

-- 6. Select Customers with Registration Date Equal to Today
SELECT * 
FROM customer_table 
WHERE DATE(RegistrationDateTime) = CURRENT_DATE;

-- 7. Select Customers from Two Days Ago
SELECT * 
FROM customer_table
WHERE DATE(RegistrationDateTime) = CURRENT_DATE - INTERVAL 2 DAY;

-- 8. Select Customers from Last Month
SELECT * 
FROM customer_table 
WHERE MONTH(RegistrationDateTime) = (MONTH(CURRENT_DATE) - 1) 
  AND YEAR(RegistrationDateTime) = YEAR(CURRENT_DATE);

-- 9. Get Last Month's Number
SELECT MONTH(CURRENT_DATE) - 1;

-- 10. Select Customers from the Previous Month
SELECT * 
FROM customer_table
WHERE MONTH(RegistrationDateTime) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) 
  AND YEAR(RegistrationDateTime) = YEAR(CURRENT_DATE);

-- 11. Get Current Date and Time
SELECT current_timestamp();

-- 12. Add Time to a Date
SELECT ADDTIME("2017-06-15 09:34:21", "02:05:02");

-- 13. Calculate the Difference in Days Between Two Dates
SELECT DATEDIFF("2017-06-25", "2017-06-15");

-- 14. Format Date to Year
SELECT DATE_FORMAT("2017-06-15", "%Y");

-- 15. Format Date to Month
SELECT DATE_FORMAT("2017-06-15", "%m");

-- 16. Format Date to Short Year
SELECT DATE_FORMAT("2017-06-15", "%y");

-- 17. Format Date to Day/Month/Year
SELECT DATE_FORMAT("2017-06-15", "%d/%m/%Y");

-- 18. Format Date to Day/Full Month/Year
SELECT DATE_FORMAT("2017-06-15", "%d/%M/%Y");

-- 19. Format Date to Day/Abbreviated Month/Year
SELECT DATE_FORMAT("2017-06-15", "%d/%b/%Y");

-- 20. Select Customers from the Year 2024 Using DATE_FORMAT
SELECT * 
FROM customer_table 
WHERE DATE_FORMAT(RegistrationDateTime, "%Y") = 2024;


create table tweets(customerID int, customername varchar(100), tweet_date datetime);
show tables;

select * from tweets;

-- 21. Select Tweets Within a Specific Date Range
SELECT * 
FROM tweets 
WHERE tweet_date >= '2022-01-01' 
  AND tweet_date <= '2022-12-31';

-- 22. Select Tweets Between Two Dates
SELECT * 
FROM tweets 
WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31';

-- 23. Extract Year and Month from Tweet Date
SELECT *, 
       EXTRACT(YEAR FROM tweet_date) AS Year, 
       EXTRACT(MONTH FROM tweet_date) AS Month
FROM tweets 
WHERE EXTRACT(YEAR FROM tweet_date) = 2022;

-- 24. Get the Day of the Week from a Date
SELECT DAYOFWEEK("2023-07-23");

-- 25. Get the Day of the Year from a Date
SELECT DAYOFYEAR("2023-07-23");

-- 26. Get the Last Day of the Month
SELECT LAST_DAY("2024-07-01");

-- 27. Calculate Age from Birth Date
SELECT TIMESTAMPDIFF(YEAR, '1990-07-23', CURDATE()) AS Age;

-- 28. Get the Weekday Name of a Date
SELECT WEEKDAY("2024-07-23");

-- 29. Convert a Unix Timestamp to Date
SELECT FROM_UNIXTIME(1690041600);

-- 30. Convert a Date to Unix Timestamp
SELECT UNIX_TIMESTAMP("2024-07-23");


show databases;
select * from customer_table;
SELECT COUNT(*) AS registration_count
FROM registrations
WHERE registration_datetime >= CURRENT_DATE - INTERVAL '20 days';

SELECT COUNT(*) AS customerID
FROM customer_table
WHERE registrationdatetime BETWEEN '2024-01-15' AND '2024-05-15';

