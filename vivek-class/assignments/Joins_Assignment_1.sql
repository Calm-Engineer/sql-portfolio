use mavenmovies;

-- 1. Provide the count of unique categories of films provided.
SELECT* FROM CATEGORY; # category_id, name
SELECT* FROM FILM; # film_id, title
select* from film_category; # film_id, category_id

select c.category_id, c.name, count(f.title) as NO_of_FILMS
from category AS c
join film_category AS fc ON c.category_id = fc.category_id
join film AS f ON fc.film_id = f.film_id
group by c.category_id;

-- 2. Display all the cities in India.
select* from city; # city_id, country_id
select* from country; # country_id 
select city_id, city from city where country_id
IN (select country_id from country where country="india");

-- 3. Display the names of actors and the names of the films they have acted in.
select* from actor; # actor_id, first_name, last_name
select* from film_actor; # actor_id, film_id
select* from film; # film_id, title
select a.first_name, a.last_name, f.title
from actor AS a
join film_actor AS fa ON a.actor_id = fa.actor_id
join film AS f ON fa.film_id = f.film_id;

-- OR 

-- To list all films grouped per actor—so that you see each actor's name only once, 
-- with a list of films they've acted in—you can use the GROUP_CONCAT function (supported in MySQL and some other databases) 
-- to combine each actor's films into a single row.
SELECT 
    a.first_name, 
    a.last_name,
    GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ') AS films
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY a.last_name, a.first_name;

-- 4. Display the film names and the category of the films they fall into.
select* from film; # film_id, title
select* from category; # category_id, name
select* from film_category; # film_id, category_id

select c.name, GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ') AS films
from film AS f
join film_category AS fc ON f.film_id = fc.film_id
join category AS c ON fc.category_id = c.category_id
group by c.category_id, c.name
order by c.name;

-- 5. Display the number of films in the category 'Action'.
select* from film; # film_id, title
select* from category; # category_id, name
select* from film_category; # film_id, category_id

select count(title) as no_of_action_films from film where film_id
IN (select film_id from film_category where category_id
IN (select category_id from category where name="action"));

-- 6. Display the list of films and their actors where the length of the film is greater than 100 mins.
select* from film; # film_id, title, length > 100
select* from actor; # actor_id, first_name, last_name
select* from film_actor; # actor_id, film_id

select f.title, a.first_name, a.last_name
from film AS f
join film_actor AS fa ON f.film_id = fa.film_id
join actor AS a ON fa.actor_id = a.actor_id
where f.length > 100;
                    
-- or

select f.title, GROUP_CONCAT(CONCAT(a.first_name, '  ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS names
from film AS f
join film_actor AS fa ON f.film_id = fa.film_id
join actor AS a ON fa.actor_id = a.actor_id
where f.length > 100
group by f.title
order by f.title;

-- 7. Give the names of actors who won an award.
select* from actor; # actor_id, first_name, last_name
select* from actor_award; # actor_award_id, actor_id, first_name, last_name, awards

select a.first_name, a.last_name
from actor AS a
join actor_award AS aa ON a.actor_id = aa.actor_id
where aa.awards IS NOT NULL AND aa.awards != '';

-- 8. List all the actors along with their awards.
select* from actor; # actor_id, first_name, last_name
select* from actor_award; # actor_award_id, actor_id, first_name, last_name, awards

select a.first_name, a.last_name, aa.awards
from actor AS a
join actor_award AS aa ON a.actor_id = aa.actor_id;

-- 9. Provide all the awards and the actors to whom they were given.
select* from actor; # actor_id, first_name, last_name
select* from actor_award; # actor_award_id, actor_id, first_name, last_name, awards

select aa.awards, GROUP_CONCAT(CONCAT(a.first_name, '  ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS Names
from actor AS a
join actor_award AS aa ON a.actor_id = aa.actor_id
group by aa.awards
order by aa.awards;

-- or

-- Emmy Winners
SELECT 'Emmy Awards' AS Award_Category, 
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS Winners
FROM actor AS a
JOIN actor_award AS aa ON a.actor_id = aa.actor_id
WHERE aa.awards = 'Emmy'

UNION ALL

-- Oscar Winners
SELECT 'Oscar Awards' AS Award_Category,
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS Winners
FROM actor AS a
JOIN actor_award AS aa ON a.actor_id = aa.actor_id
WHERE aa.awards = 'Oscar'

UNION ALL

-- Tony Winners
SELECT 'Tony Awards' AS Award_Category,
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS Winners
FROM actor AS a
JOIN actor_award AS aa ON a.actor_id = aa.actor_id
WHERE aa.awards = 'Tony'

UNION ALL

-- Other Awards
SELECT 'Other Awards' AS Award_Category,
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name, ' (', aa.awards, ')') ORDER BY a.last_name SEPARATOR ', ') AS Winners
FROM actor AS a
JOIN actor_award AS aa ON a.actor_id = aa.actor_id
WHERE aa.awards NOT IN ('Emmy', 'Oscar', 'Tony') AND aa.awards IS NOT NULL;

-- 10. Display all the actor’s names who worked in either Animation or Children movies.
select* from actor; # actor_id, first_name, last_name
select* from category; # category_id, name
select* from film_category; # film_id, category_id
select* from film_actor; # actor_id, film_id

select first_name, last_name from actor where actor_id
IN (select actor_id from film_actor where film_id
IN (select film_id from film_category where category_id
IN (select category_id from category where name = 'Animation' or name = 'Children')));

-- 11. Display the cities from India whose names start with 'B'.
select* from city; # city_id, country_id, city
select* from country; # country_id, country

select city from city where city like 'B%' and country_id
IN (select country_id from country where country = 'India' );

-- 12. Display all the customers whose names start with 'A' and live in India.
select* from customer; # customer_id, first_name, last_name, address_id
select* from country; # country_id, country
select* from city; # country_id, city_id
select* from address; # address_id, city_id

select first_name, last_name from customer where first_name like 'A%' and address_id
IN (select address_id from address where city_id
IN (select city_id from city where country_id
IN (select country_id from country where country = 'India')));

-- 13. Display the count of customers who worked in either Canada or France.
select* from customer; # customer_id, first_name, last_name, address_id
select* from country; # country_id, country
select* from city; # country_id, city_id
select* from address; # address_id, city_id

select count(customer_id) as Customer_Count from customer where address_id
IN (select address_id from address where city_id
IN (select city_id from city where country_id
IN (select country_id from country where country IN ('Canada', 'France'))));

-- OR 

select first_name, last_name as Customer_Count from customer where address_id
IN (select address_id from address where city_id
IN (select city_id from city where country_id
IN (select country_id from country where country IN ('Canada', 'France'))));

-- 14. Display the total number of inventories maintained by staff with ID equal to 1.
select* from inventory; # inventory_id, film_id, store_id
select* from staff; # staff_id, address_id, store_id

select count(inventory_id) from inventory where store_id
IN (select store_id from staff where staff_id=1);

-- 15. Display the details of all the customers who paid more than $10 as rental amount.
select* from customer; # customer_id, first_name, last_name, address_id
select* from rental; # rental_id, inventory_id, customer_id, staff_id
select* from payment; # payment_id, customer_id, staff_id, rental_id, amount

select  first_name, last_name, email from customer where customer_id
IN (select customer_id from payment where amount > 10);

-- 16. Retrieve the first name and last name of customers who have rented films that belong to the category 'Action'.
select* from customer; # customer_id, store_id, first_name, last_name, address_id
select* from inventory; # inventory_id, film_id, store_id
select* from film_category; # film_id, category_id
select* from category; # category_id, name

select first_name, last_name from customer where store_id
IN (select store_id from inventory where film_id
IN (select film_id from film_category where category_id
IN (select category_id from category where name = 'Action')));

-- 17. Find the titles of films that have a rental rate higher than the average rental rate of all films.
select* from film; # film_id, title, rental_rate

select title from film where rental_rate > (select avg(rental_rate) from film);

-- 18. List the actors who have acted in more than 18 movies.
select* from actor; # actor_id, first_name, last_name
select* from film_actor; # actor_id, film_id
select* from film; # film_id, title

SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 18;

-- OR 

SELECT first_name, last_name FROM actor WHERE actor_id 
IN (SELECT actor_id FROM film_actor GROUP BY actor_id HAVING COUNT(film_id) > 18);

-- 19. List the film titles that have a replacement cost higher than the highest replacement cost of films in the 'Children' category.
select* from film; # film_id, title, replacement_cost
select* from category; # category_id, name='Children'
select* from film_category; # film_id, category_id

select max(replacement_cost) from film where film_id
IN (select film_id from film_category where category_id
IN (select category_id from category where name = 'Children'));

select title from film where replacement_cost > (select max(replacement_cost) from film where film_id
IN (select film_id from film_category where category_id
IN (select category_id from category where name = 'Children')));

-- 20. List customers who have made more than five payments. Display their first name and last name.
select* from customer; # customer_id, store_id, first_name, last_name, address_id
select* from payment; # payment_id, customer_id, staff_id, rental_id, amount

select first_name, last_name from customer where customer_id
IN (select customer_id from payment group by customer_id having count(payment_id) > 5);

-- 21. Write a query to count the number of film rentals for each customer and retrieve the names of those customers who have rented exactly 30 films.
select* from customer; # customer_id, store_id, first_name, last_name, address_id
select* from rental; # rental_id, inventory_id, customer_id, staff_id

select c.first_name, c.last_name, count(r.rental_id) AS rental_count
from customer AS c
join rental AS r ON c.customer_id = r.customer_id
group by c.first_name, c.last_name
having count(r.rental_id) = 30;

-- 22. Write a query to find all customers whose total payments for all film rentals are between 100 and 150 dollars.
select* from customer; # customer_id, store_id, first_name, last_name, address_id
select* from rental; # rental_id, inventory_id, customer_id, staff_id
select* from film; # film_id, title, rental_rate, replacement_cost, total_payment=rental_rate+replacement_cost
select* from inventory; # inventory_id, film_id, store_id

select c.first_name, c.last_name, sum(f.rental_rate) AS Total_Payment
from customer AS c
join rental AS r ON c.customer_id = r.customer_id
join inventory AS i ON r.inventory_id = i.inventory_id
join film AS f ON i.film_id = f.film_id
group by c.first_name, c.last_name
having Total_Payment between 100 and 150;

-- OR

SELECT c.first_name, c.last_name, SUM(p.amount) AS Total_Payment
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
HAVING SUM(p.amount) BETWEEN 100 AND 150;

-- 23. Write a query to generate a list of customer IDs along with the number of film rentals and the total payments.
select* from customer; # customer_id, store_id, first_name, last_name, address_id
select* from rental; # rental_id, inventory_id, customer_id, staff_id
select* from film; # film_id, title, rental_rate, replacement_cost, total_payment=rental_rate+replacement_cost
select* from inventory; # inventory_id, film_id, store_id

select  c.customer_id, 
		count(r.rental_id) AS rental_count, 
        sum(f.rental_rate) AS total_payment
from customer AS c
join rental AS r ON c.customer_id = r.customer_id
join inventory AS i ON r.inventory_id = i.inventory_id
join film AS f ON i.film_id = f.film_id
group by c.customer_id
order by Total_Payment DESC;
