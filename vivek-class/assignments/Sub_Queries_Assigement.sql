-- Sub-queries
USE HR;
-- 1.	Execute a working query using a sub-select to retrieve all employees records whose salary is lower than the average salary.
SELECT* FROM EMPLOYEES WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEES);
SELECT AVG(SALARY) FROM EMPLOYEES;

-- 2.	Execute a Column Expression that retrieves all employees’ records with EMP_ID, SALARY and maximum salary as MAX_SALARY in every row.
SELECT EMP_ID, SALARY, (SELECT MAX(SALARY) FROM EMPLOYEES) AS MAX_SALARY FROM EMPLOYEES;
SELECT MAX(SALARY) FROM EMPLOYEES;

-- examples
select emp_id,
(select sum(salary) from employees) as total_salary,
(select min(salary) from employees) as min_salary,
(select max(salary) from employees) as max_salary,
(select count(emp_id) from employees) as total_employees,
(select avg(salary) from employees) as average_salary
from employees;

select emp_id, max(salary) from employees group by emp_id; # In the emp_id column employee id's are different. That's why max(salary) differs. This is meaningless
select sex, max(salary) from employees group by sex; # In this scenario the grouping is done on column sex and calculated the max(salary) under that category. 

-- 3.	Write a query to find the average salary of the five least-earning employees.
SELECT* FROM EMPLOYEES;
SELECT SALARY FROM EMPLOYEES ORDER BY SALARY LIMIT 5; 
SELECT AVG(SALARY) AS AVG_SALARY_OF_LEAST_5 FROM (SELECT SALARY FROM EMPLOYEES ORDER BY SALARY LIMIT 5) AS AVG_SALARY;

-- 4.	Write a query to find the records of employees older than the average age of all employees.
SELECT* FROM EMPLOYEES;
SELECT YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE))) AS AGE FROM EMPLOYEES ;
SELECT avg(YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE)))) AS AVG_AGE FROM EMPLOYEES;
SELECT* FROM EMPLOYEES WHERE (YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE)))) > (SELECT AVG(YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE)))) FROM EMPLOYEES);
SELECT*, YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE))) AS AGE FROM EMPLOYEES 
	WHERE (YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE)))) > (SELECT AVG(YEAR(from_days(DATEDIFF(CURRENT_DATE, B_DATE)))) FROM EMPLOYEES);
    
-- also we can use 
select timestampdiff(year, b_date, current_date)  as AGE from employees;

-- 5.	From the Job History table, display the list of Employee IDs, years of service, and average years of service for all entries.
SELECT* FROM JOB_HISTORY;
SELECT YEAR(from_days(DATEDIFF(CURRENT_DATE, START_DATE))) FROM JOB_HISTORY;
SELECT AVG(YEAR(from_days(DATEDIFF(CURRENT_DATE, START_DATE)))) FROM JOB_HISTORY;
SELECT EMP_ID, (YEAR(from_days(DATEDIFF(CURRENT_DATE, START_DATE)))) AS YEARS_OF_SERVICE, 
	(SELECT AVG(YEAR(from_days(DATEDIFF(CURRENT_DATE, START_DATE)))) FROM JOB_HISTORY) AS AVG_YEARS_OF_SERVICE FROM JOB_HISTORY;

-- 6.	Retrieve only the EMPLOYEES records that correspond to jobs in the JOBS table.
SELECT* FROM EMPLOYEES; # JOB_ID
SELECT* FROM JOBS; # JOB_IDENT
select* from employees where job_id
IN (select job_ident from jobs);

-- 7.	Retrieve only the list of employees whose JOB_TITLE is Jr. Designer.
select* from employees where job_id
IN (select job_ident from jobs where job_title="Jr. Designer");

-- 8.	Retrieve JOB information and who earn more than $70,000.
select* from job_history where job_id
IN (select job_ident from jobs where max_salary > 70000);

select* from jobs;
select* from locations;
select* from employees;

-- 9.	Retrieve JOB information and whose birth year is after 1976.
select* from employees;
select* from job_history;
select* from job_history  where emp_id
IN (select emp_id from employees where year(b_date) > 1976);

-- 10.	Retrieve JOB information for female employees whose birth year is after 1976.
select* from employees;
select* from job_history;
select* from job_history  where emp_id
IN (select emp_id from employees where year(b_date) > 1976 and sex='F');


-- Q1: Retrieve the first name and last name of customers who have rented films that belong to the category "Action".
USE MAVENMOVIES;
-- in this case we need to connection between customer_id and category_id
select* from customer; # customer_id
select* from rental; # customer_id, inventory_id
select* from inventory; # inventory_id, film_id
select* from film_category; # film_id, category_id
select* from category; # category_id=1 is name='Action'
select first_name, last_name from customer where customer_id
IN (select customer_id from rental where inventory_id
IN (select inventory_id from inventory where film_id
IN (select film_id from film_category where category_id
IN (select category_id from category where name='Action'))));


-- Select the names and job start dates of all employees who work for the department number 5.
select* from employees;
select* from job_history;
-- you can't do sub-query to solve this problem since both required columns are in two different tables. We need to use JOINS to solve these type of problems.

