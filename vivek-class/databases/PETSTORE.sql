CREATE DATABASE PetSTORE;
USE PetSTORE;
create table PETRESCUE (
	ID INTEGER NOT NULL,
	ANIMAL VARCHAR(20),
	QUANTITY INTEGER,
	COST DECIMAL(6,2),
	RESCUEDATE DATE,
	PRIMARY KEY (ID)
	);

insert into PETRESCUE values 
	(1,'Cat',9,450.09,'2018-05-29'),
	(2,'Dog',3,666.66,'2018-06-01'),
	(3,'Dog',1,100.00,'2018-06-04'),
	(4,'Parrot',2,50.00,'2018-06-04'),
	(5,'Dog',1,75.75,'2018-06-10'),
	(6,'Hamster',6,60.60,'2018-06-11'),
	(7,'Cat',1,44.44,'2018-06-11'),
	(8,'Goldfish',24,48.48,'2018-06-14'),
	(9,'Dog',2,222.22,'2018-06-15')	
;
SHOW TABLES;
SELECT* FROM PETRESCUE;

-- Questions Aggregate Functions: 
-- Query A1: Enter a function that calculates the total cost of all animal rescues in the PETRESCUE table.
 SELECT SUM(COST) FROM PETRESCUE;
 
-- Query A2: Enter a function that displays the total cost of all animal rescues in the PETRESCUE table in a column called SUM_OF_COST. 
SELECT SUM(COST) AS SUM_OF_COST FROM PETRESCUE;

-- Query A3: Enter a function that displays the maximum quantity of animals rescued.
select* FROM PETRESCUE;
select MAX(QUANTITY) AS MAX_QUANTITY_ANIMAL_RESCUED  FROM PETRESCUE;

-- Query A4: Enter a function that displays the average cost of animals rescued.
select ROUND(sum(COST)/sum(QUANTITY),2) AS AVG_COST_ANIMAL_RESCUED FROM PETRESCUE;
 
-- Query A5: Enter a function that displays the average cost of rescuing a dog.
SELECT ROUND(SUM(COST)/SUM(QUANTITY),2) AS AVG_COST_RESCUING_DOG FROM PETRESCUE WHERE ANIMAL="DOG";

-- Questions Scalar and String Functions: 
-- Query B1: Enter a function that displays the rounded cost of each rescue. 
SELECT ANIMAL, ROUND(SUM(COST)/SUM(QUANTITY)) AS COST_OF_RESCUE FROM PETRESCUE GROUP BY ANIMAL;

-- Query B2: Enter a function that displays the length of each animal name.
SELECT ANIMAL, length(ANIMAL) AS NAME_LENGTH FROM PETRESCUE; 

-- Query B3: Enter a function that displays the animal name in each rescue in uppercase. 
SELECT ANIMAL, UPPER(ANIMAL) AS UPPERCASE_NAME FROM PETRESCUE;

-- Query B4: Enter a function that displays the animal name in each rescue in uppercase without duplications. 
SELECT DISTINCT ANIMAL, UPPER(ANIMAL) AS UPPERCASE_NAME FROM PETRESCUE;

-- Query B5: Enter a query that displays all the columns from the PETRESCUE table, 
-- where the animal(s) rescued are cats. Use cat in lower case in the query.
SELECT* FROM PETRESCUE;
SELECT ID, LOWER(ANIMAL), QUANTITY, COST, RESCUEDATE FROM PETRESCUE WHERE ANIMAL="CAT";

-- Questions Date and Time Functions: 
-- Query C1: Enter a function that displays the day of the month when cats have been rescued.
SELECT ANIMAL, DAY(RESCUEDATE) FROM PETRESCUE WHERE ANIMAL="CAT";
 
-- Query C2: Enter a function that displays the number of rescues on the 5th month.
SELECT SUM(QUANTITY) AS NO_OF_RESCUES_MAY  FROM PETRESCUE WHERE MONTH(RESCUEDATE)=5;
 
-- Query C3: Enter a function that displays the number of rescues on the 14th day of the month.
 SELECT SUM(QUANTITY) AS NO_OF_RESCUES_14TH  FROM PETRESCUE WHERE DAY(RESCUEDATE)=14;

-- Query C4: Animals rescued should see the vet within three days of arrivals. Enter a function that displays the third day from each rescue.
SELECT* FROM PETRESCUE;
SELECT*, DATE_ADD(RESCUEDATE, INTERVAL 3 DAY) AS VET_CHECKUP FROM PETRESCUE;
-- EX:
SELECT*, DATE_SUB(RESCUEDATE, INTERVAL 3 DAY) AS VET_CHECKUP FROM PETRESCUE;
-- ALSO
-- CAN BE USED FOR DIFFERENT TIMEFRAMES > INTERVAL 3 DAY, WEEK, MONTH, QUARTER, YEAR, 
 
-- Query C5: Enter a function that displays the length of time the animals have been rescued; 
-- the difference between todays date and the rescue date.
SELECT*, DATEDIFF(CURRENT_DATE, RESCUEDATE) AS ANIMAL_RESCUED_LENGTH FROM PETRESCUE;
-- OR 
SELECT*, from_days(datediff(CURRENT_DATE, RESCUEDATE)) AS ANIMAL_RESCUED_LENGTH FROM PETRESCUE;
-- OR
SELECT*, timestampdiff(DAY, RESCUEDATE, CURRENT_DATE) AS ANIMAL_RESCUED_LENGTH FROM PETRESCUE;