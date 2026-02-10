CREATE DATABASE new_8;
USE NEW_8;
CREATE TABLE PetSale(
ID int, 
PetName varchar(20), 
SalePrice decimal(20,2), 
Profit decimal(6,2), 
SaleDate date
);
show tables;
describe petsale;
select* from petsale;
insert into petsale(ID, PetName, SalePrice, Profit, SaleDate) values
(1, "Cat", 450.09, 100.47, "2018-05-29"),
(2, "Dog", 666.66, 150.76, "2018-06-01"),
(3, "Parrot", 50.00, 8.9, "2018-06-04"),
(4, "Hamster", 60.60, 12, "2018-06-11"),
(5, "Goldfish", 48.48, 3.5, "2018-06-14");
-- DQL
select* from PETSALE;
select id, petname from petsale;

-- ALTER Command
-- Purpose: To change the structure of the tables in the database

-- Adding a column
ALTER TABLE Petsale
add column Quantity int;

-- Addding multiple columns
ALTER TABLE Petsale
ADD COLUMN Unit int,
ADD COLUMN Address varchar(20);

-- Deleting a column
ALTER TABLE Petsale
DROP COLUMN Unit,
DROP COLUMN Address;

DESCRIBE PETSALE;

-- Modify a column
ALTER TABLE Petsale
MODIFY COLUMN Quantity decimal(6,2);

-- Change a column name
ALTER TABLE Petsale
CHANGE PetName Pet varchar(40);

-- Rename a table
ALTER TABLE Petsale
RENAME TO Animal;

SELECT* FROM ANIMAL;

SHOW TABLES;
ALTER TABLE Animal
MODIFY COLUMN Profit decimal(6,2);

-- UPDATE Command 
-- Purpose: To modify or update data contained within a table in the database. 

