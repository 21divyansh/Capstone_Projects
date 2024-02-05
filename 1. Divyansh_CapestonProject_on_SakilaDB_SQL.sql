/* Task 1: Display the full names of actors available in the database */
SHOW TABLES;
DESC actor;
SELECT CONCAT(first_name,' ',last_name) 'full_name' FROM actor;

-------------------------------------------------------------------------------------------------------------------------
/* Task 2: Management wants to know if there are any names of the actors appearing frequently.
i. Display the number of times each first name appears in the database.
ii. What is the count of actors that have unique first names in the database? Display the first names of all these actors. */

SELECT first_name, COUNT(first_name) 'Count of first_name'
FROM actor
GROUP BY first_name HAVING COUNT(first_name) > 1; -- Displays the first names and the count of repetition

SELECT COUNT(DISTINCT first_name) 'Count of unique first_names' FROM actor; -- Displays the total count of unique first names

SELECT first_name, COUNT(first_name) 'Count of first_names'
FROM actor
GROUP BY first_name HAVING COUNT(first_name) = 1; -- Displays the unique first names

-----------------------------------------------------------------------------------------------------------------------------------------------
/* Task 3: The managment is interested to analyze the similarity in the last names of the actors.
i. Display the number of times each last name appears in the database.
ii. Display all unique last names in the database. */

SELECT last_name, COUNT(last_name) 'Count Of last_name'
FROM actor
GROUP BY last_name HAVING COUNT(last_name) >= 1; -- Display the count of times last_name repeated

SELECT last_name, COUNT(last_name) 'Unique last_names'
FROM actor
GROUP BY last_name HAVING COUNT(last_name) = 1; -- Displays the unique last names

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Task 4: The management wants to analyze the movies based on their ratings to determine if they are suitable for kids or some parental assistance is required.
Perform the following tasks to perform the required analysis.
i. Display the list of records for the movies with the rating "R".(The movies with the rating "R" are not suitable for 
audience under 17 years age.
ii. Display the list of records for movies that are not rated "R".
iii. Display the list of records for movies that are suitable for audience below 13 years of age. */

SELECT * FROM film
WHERE rating = 'R'; -- Displays the details of the movies with rating 'R'
SELECT * FROM film 
WHERE rating NOT IN ('R'); -- Displays the details of the movies where rating is not 'R'
SELECT * FROM film
WHERE rating = 'G'; -- Displays the details  of movies where rating is 'G' which is suitable for all general age 

----------------------------------------------------------------------------------------------------------------------------
/* Task 5 : The board members wants to understand the replacement cost of a movie copy(disc- DVD/Blue Ray).
The replacementt cost refers to the amount chargerd to the customers if the movie disc is not refunded or 
is returned in a damage state.
i. Display the list of records for the movies where the replacement cost is up to $11.
ii. Display the list of records for the movies where the replacemnt cost is between $11 and $20.
iii. Display the list of records for all the movies in descending order of their replacement costs. */

SELECT * FROM film;
SELECT * FROM film
WHERE replacement_cost <= 11; -- Displays the details of movies where the replacement cost is upto $11
SELECT * FROM film 
WHERE replacement_cost BETWEEN 11 AND 20; -- Displays the details of movies where the replacement cost is between $11 and $20
SELECT * FROM film
ORDER BY replacement_cost DESC;

--------------------------------------------------------------------------------------------------------------------------------
/* Task 6 Display the names of top 3 movies with greatest number of actors. */

SELECT f.title, COUNT(fa.actor_id) AS actor_count
FROM film AS f JOIN film_actor AS fa ON ( f.film_id=fa.film_id)
GROUP BY f.title ORDER BY COUNT(fa.actor_id) DESC LIMIT 3; -- Displays top 3 film title and count of actors worked in it

----------------------------------------------------------------------------------------------------------------------------------

/* Task 7: 'Music of Queen and Kris Kristofferson' have seen an unlikely resurgence. As an unintended consequence, films starting with the letters 'K' and 'Q' have also
soared in popularity. Display the titles of the movies starting with letters 'K' and 'Q'. */

SELECT * FROM film
WHERE title LIKE 'Q%' OR title LIKE 'K%';

---------------------------------------------------------------------------------------------------------------------------------

/* Task 8 : The film 'Agent Truman' has been a great success. Display the names of all actors who appeared in this film. */

SELECT first_name, last_name FROM actor
 WHERE actor_id IN(SELECT actor_id FROM film_actor WHERE film_id 
 IN(SELECT film_id FROM FILM 
 WHERE title = 'Agent Truman')); -- Displays the names of actors appearedd in the movie 'Agent Truman'
 
-----------------------------------------------------------------------------------------------------------------------------------
/* Task 9: Sales have been lagging amoung young families, so the management wants to promote family movies. Identify all movies categorized as family films. */
SELECT * FROM category;
SELECT title FROM film WHERE film_id 
IN (SELECT film_id FROM film_category WHERE category_id 
IN(SELECT category_id FROM category WHERE name = 'Family')); -- Displays the list of movies which are categorized as 'family'.
---------------------------------------------------------------------------------------------------------------------------------------
/* Task 10: The managment wants to observ the rental rates and rental frequencies(Number of time the movie disc is rented).
i. Display the maximum, minimum and average rental rates of movies based on their ratings.
 The output must be sorted in descending order of the average rental rates.
 ii. Display the movies in descending order of their rental frequencies, so the management can maintain more copies of these movies. */
 
 
 SELECT MAX(rental_rate), MIN(rental_rate), AVG(rental_rate), rating FROM film
 GROUP BY rating;
 SELECT title, rental_rate FROM film
 ORDER BY rental_rate DESC;
 
 --------------------------------------------------------------------------------------------------------------------------------------------
 
 /* Task 11: In how many film categories, the difference between the average film replacement cost ((disc - DVD/Blue Ray) and the average film rental rate greater than $15?
 Display the list of all film categories identified above, along with the corresponding average film replacement cost and average film rental rate. */
 
SELECT c.name,AVG(f.replacement_cost) 'avg_replacement_cost',AVG(f.rental_rate) 'avg_rental_rate'
FROM category c JOIN film_category fc ON c.category_id = fc.category_id JOIN  film f ON fc.film_id = f.film_id
WHERE f.film_id IN (SELECT film_id FROM film WHERE (SELECT AVG(replacement_cost) FROM film) - (SELECT AVG(rental_rate) FROM film) > 15)
GROUP BY c.name;

 -------------------------------------------------------------------------------------------------------------------------------------------------
 
/* Task 12: Display the film categories in which the number of movies is greater than 70. */


SELECT c.name,COUNT(f.film_id) 'count' 
FROM category c JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id GROUP BY c.name HAVING COUNT(f.film_id) > 70; -- Displays the categories with more that 70 movies in each.



