-- 1.	Write a query to find month-wise registrations count in the current year.

SELECT MONTH(RegistrationDateTime) AS Month, COUNT(CustomerID) AS RegCount FROM customer_table
WHERE YEAR(RegistrationDateTime)=YEAR(CURRENT_DATE)
GROUP BY Month;

-- OR

SELECT EXTRACT(MONTH FROM RegistrationDateTime) AS Month, COUNT(*) AS RegCount FROM customer_table
WHERE EXTRACT(YEAR FROM RegistrationDateTime)=EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY Month
ORDER BY Month;

-- OR

SELECT MONTH(RegistrationDateTime) AS Month, COUNT(*) AS RegistrationCount
FROM customer_table
WHERE YEAR(RegistrationDateTime) = YEAR(CURDATE())
GROUP BY Month;

-- 2.	Write a query to find year-wise registrations count.

SELECT YEAR(RegistrationDateTime) AS Year, COUNT(CustomerID) AS RegCount FROM customer_table
GROUP BY Year;

-- OR

SELECT EXTRACT(YEAR FROM RegistrationDateTime) AS Year, COUNT(*) AS RegCount FROM customer_table
GROUP BY Year
ORDER BY Year;

-- OR 

SELECT YEAR(RegistrationDateTime) AS Year, COUNT(*) AS RegistrationCount
FROM customer_table
GROUP BY Year;

-- 3.	Write a query to find week-wise registrations count.

SELECT WEEK(RegistrationDateTime) AS Week, COUNT(CustomerID) AS RegCount FROM customer_table
GROUP BY Week;

-- OR

SELECT EXTRACT(WEEK FROM RegistrationDateTime) AS Week, COUNT(*) AS RegCount FROM customer_table
GROUP BY Week
ORDER BY Week;

-- OR

SELECT YEAR(RegistrationDateTime) AS Year, WEEK(RegistrationDateTime) AS Week, COUNT(*) AS RegistrationCount
FROM customer_table
GROUP BY Year, Week;

-- 4.	Write a query to find week-wise registrations count in the current year.

SELECT WEEK(RegistrationDateTime) AS Week, COUNT(CustomerID) AS RegCount FROM customer_table
WHERE YEAR(RegistrationDateTime)=YEAR(CURRENT_DATE)
GROUP BY Week
ORDER BY Week;

-- OR

SELECT EXTRACT(WEEK FROM RegistrationDateTime) AS Week, COUNT(*) AS RegCount FROM customer_table
WHERE EXTRACT(YEAR FROM RegistrationDateTime)=EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY Week
ORDER BY Week;

-- 5.	Write a query to find current month and year registration.

SELECT COUNT(CustomerID) AS CurrentMonthRegCount FROM customer_table
WHERE MONTH(RegistrationDateTime)=MONTH(CURRENT_DATE) AND YEAR(RegistrationDateTime)=YEAR(CURRENT_DATE);

-- OR

SELECT COUNT(*) AS CurrentMonthRegCount FROM customer_table
WHERE EXTRACT(MONTH FROM RegistrationDateTime)=EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM RegistrationDateTime)=EXTRACT(YEAR FROM CURRENT_DATE);

-- OR

SELECT COUNT(*) AS RegistrationCount
FROM customer_table
WHERE YEAR(RegistrationDateTime) = YEAR(CURDATE())
  AND MONTH(RegistrationDateTime) = MONTH(CURDATE());

-- 6.  Write a query to find the number of registrations in the last 20 days.

SELECT COUNT(CustomerID) AS RegCount FROM customer_table
WHERE DATE(RegistrationDateTime) >=CURRENT_DATE-INTERVAL 20 DAY;

-- OR

SELECT COUNT(*) AS RegistrationCount
FROM customer_table
WHERE RegistrationDateTime >= CURDATE() - INTERVAL 20 DAY;

-- 7.	Write a query to find the number of customers who made payment within 28 days of their registrations.

SELECT COUNT(*) AS CustomerPayment FROM customer_table
WHERE DATEDIFF(DATE(FirstPaymentDateTime),DATE(RegistrationDateTime))<=28;

-- OR

SELECT COUNT(*) AS CustomersWithin28Days
FROM customer_table
WHERE TIMESTAMPDIFF(DAY, RegistrationDateTime, FirstPaymentDateTime) <= 28;

-- 8.	Find the average number of days taken by customers to make a payment after registration.

SELECT AVG(DATEDIFF(DATE(FirstPaymentDateTime),DATE(RegistrationDateTime))) AS NumberOfDays FROM customer_table;

-- OR

SELECT AVG(TIMESTAMPDIFF(DAY, RegistrationDateTime, FirstPaymentDateTime)) AS AvgDaysToPayment
FROM customer_table;

-- 9.	Write a query to only fetch the year from the registration datetime column.

SELECT CustomerID, YEAR(RegistrationDateTime) FROM customer_table;

-- OR

SELECT YEAR(RegistrationDateTime) AS RegistrationYear
FROM customer_table;

-- OR

SELECT EXTRACT(YEAR FROM RegistrationDateTime) AS RegistrationYear
FROM customer_table;

-- 10.	Write a query to find registrations count between '2024-01-15' and '2024-05-15'.

SELECT COUNT(*) FROM customer_table
WHERE DATE(RegistrationDateTime) BETWEEN '2024-01-15' AND '2024-05-15';

-- OR

SELECT COUNT(*) FROM customer_table
WHERE DATE(RegistrationDateTime) >= '2024-01-15' AND DATE(RegistrationDateTime) <= '2024-05-15';

-- OR

SELECT COUNT(*) AS RegistrationCount
FROM customer_table
WHERE RegistrationDateTime BETWEEN '2024-01-15' AND '2024-05-15';

-- 11.	Write a query to find today's registration count.

SELECT COUNT(*) AS TodayRegisCount FROM customer_table
WHERE DATE(RegistrationDateTime)=CURDATE();

-- 12.	Write a query to find the month with the highest registration in 2023 and what is the registration count.

SELECT MONTH(RegistrationDateTime) AS Month, COUNT(*) AS RegistrationCount FROM customer_table
WHERE YEAR(RegistrationDateTime)=2023
GROUP BY Month
ORDER BY RegistrationCount DESC
LIMIT 1;

-- 13.	Write a query to find MTD (Month-to-Date) registration count and LMTD (Last Month-to-Date) registration count.

-- MTD
SELECT COUNT(*) AS MTD_RegistrationCount FROM customer_table
WHERE MONTH(RegistrationDateTime)=MONTH(CURRENT_DATE) AND 
YEAR(RegistrationDateTime)=YEAR(CURRENT_DATE) AND 
DATE(RegistrationDateTime)<=CURRENT_DATE;

-- LMTD
SELECT COUNT(*) AS LMTD_RegistrationCount FROM customer_table
WHERE MONTH(RegistrationDateTime)=MONTH(CURRENT_DATE-INTERVAL 1 MONTH) AND 
YEAR(RegistrationDateTime)=YEAR(CURRENT_DATE-INTERVAL 1 MONTH) AND 
DATE(RegistrationDateTime)<=CURRENT_DATE-INTERVAL 1 MONTH;

-- 14.	Write a query to find the number of registrations on weekends versus weekdays.

SELECT 
    CASE 
        WHEN DAYOFWEEK(RegistrationDateTime) IN (1, 7) THEN 'Weekend'  -- Assuming Sunday=1 and Saturday=7
        ELSE 'Weekday'
    END AS DayType,
    COUNT(*) AS RegistrationCount
FROM 
    customer_table
GROUP BY 
  DayType;

-- 15.	Write a query to find the average registration count per week in the current year.

SELECT AVG(weekly_count) AS AvgWeeklyRegistration
FROM (
  SELECT COUNT(*) AS weekly_count
  FROM customer_table
  WHERE YEAR(RegistrationDateTime) = YEAR(CURDATE())
  GROUP BY WEEK(RegistrationDateTime)
) AS weekly_counts;

-- 16.	Write a query to find the percentage change in registrations compared to the previous year.(lead,lag) skip



-- 17.	Write a query to find the registration count for each day of the week.

SELECT DAYNAME(RegistrationDateTime) AS DayOfWeek, COUNT(*) AS RegistrationCount
FROM customer_table
GROUP BY DayOfWeek;

-- 18.	Write a query to identify the top 5 months with the highest number of registrations in the last 5 years.

SELECT YEAR(RegistrationDateTime) AS Year, MONTH(RegistrationDateTime) AS Month, COUNT(*) AS RegistrationCount
FROM customer_table
WHERE DATE(RegistrationDateTime) >= DATE(CURRENT_DATE) - INTERVAL 5*365 DAY
GROUP BY Year, Month
ORDER BY RegistrationCount DESC
LIMIT 5;

-- 19.	Write a query to calculate the total number of registrations in each quarter of the current year.

SELECT QUARTER(RegistrationDateTime) AS Quarter, COUNT(*) AS RegistrationCount
FROM customer_table
WHERE YEAR(RegistrationDateTime) = YEAR(CURRENT_DATE)
GROUP BY Quarter;

-- OR

SELECT 
	CASE
		WHEN MONTH(RegistrationDateTime) IN (1,2,3) THEN "Q1"
        WHEN MONTH(RegistrationDateTime) IN (4,5,6) THEN "Q2"
        WHEN MONTH(RegistrationDateTime) IN (7,8,9) THEN "Q3"
		ELSE "Q4"
	END AS Quarter, COUNT(CustomerID)
FROM customer_table
WHERE YEAR(RegistrationDateTime)=YEAR(CURRENT_DATE)
GROUP BY Quarter;

-- 20.	Write a query to find the registration count for each day of the current month.

SELECT DAYOFMONTH(RegistrationDateTime) AS DayCount, COUNT(*) AS DayRegistrationCount FROM customer_table
WHERE DATE(RegistrationDateTime)<=DATE(CURRENT_DATE) AND MONTH(RegistrationDateTime)=MONTH(CURRENT_DATE)
GROUP BY DayCount;

-- OR

SELECT DATE(RegistrationDateTime) AS DayCount, COUNT(*) AS RegistrationCount
FROM customer_table
WHERE MONTH(RegistrationDateTime) = MONTH(CURRENT_DATE)
GROUP BY DayCount;

-- 21.	Write a query to find the earliest and latest registration dates in the database.

SELECT MIN(RegistrationDateTime) AS EarliestRegistration, MAX(RegistrationDateTime) AS LatestRegistration
FROM customer_table;

