-- Joins

-- Select the names and job start dates of all employees who work for the department number 5. 
use hr;
select* from employees; # emp_id
select* from job_history; # empl_id
SELECT E.F_NAME, E.L_NAME, E.DEP_ID, JH.START_DATE
FROM EMPLOYEES AS E
INNER JOIN JOB_HISTORY AS JH ON E.EMP_ID = JH.EMPL_ID
WHERE E.DEP_ID = 5;

-- Select the names, job start dates, and job titles of all employees who work for the department number 5
select* from employees; # emp_id, JOB_ID
select* from job_history; # empl_id, JOBS_ID
SELECT* FROM JOBS; # JOB_IDENT

SELECT E.F_NAME, E.L_NAME, JH.START_DATE, J.JOB_TITLE
FROM EMPLOYEES AS E 
JOIN JOB_HISTORY AS JH ON E.EMP_ID = JH.EMPL_ID
JOIN JOBS AS J ON JH.JOBS_ID = J.JOB_IDENT
WHERE E.DEP_ID = 5;

-- Perform a Left Outer Join on the EMPLOYEES and DEPARTMENT tables and 
-- select employee id, last name, department id and department name for 
-- all employees. 
SELECT* FROM EMPLOYEES;  # DEP_ID, 10, 5, 7, 2
SELECT* FROM DEPARTMENTS; # DEP_ID_DEP, 11, 2,5,7
SELECT E.EMP_ID, E.L_NAME, E.DEP_ID, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT JOIN DEPARTMENTS AS D ON E.DEP_ID = D.DEPT_ID_DEP
WHERE D.DEP_NAME IS NULL ;

 -- Re-write the previous query but limit the result set to include only the rows 
-- for employees born before 1980
SELECT E.EMP_ID, E.L_NAME, E.DEP_ID, YEAR(E.b_DATE) AS b_YEAR, D.DEP_NAME
FROM EMPLOYEES AS E
LEFT JOIN DEPARTMENTS AS D ON E.DEP_ID = D.DEPT_ID_DEP
WHERE YEAR(E.b_DATE) < 1980;

select e.emp_id,e.l_name,e.dep_id,d.dep_name, year(e.b_date) as year from employees as e
left join departments as d on e.dep_id=d.dept_id_dep
where year(e.b_date) < 1980;
-- Perform a Full Join on the EMPLOYEES and DEPARTMENT tables and select 
-- the First name, Last name and Department name of all employees. 

SELECT E.F_NAME, E.L_NAME, D.DEP_NAME, E.SEX, D.DEPT_ID_DEP
FROM EMPLOYEES AS E
LEFT JOIN DEPARTMENTS AS D ON E.DEP_ID = D.DEPT_ID_DEP WHERE E.SEX ='F'

UNION

SELECT E.F_NAME, E.L_NAME, D.DEP_NAME, E.SEX, E.DEP_ID
FROM EMPLOYEES AS E
RIGHT JOIN DEPARTMENTS AS D ON E.DEP_ID = D.DEPT_ID_DEP WHERE E.SEX = 'F'
;