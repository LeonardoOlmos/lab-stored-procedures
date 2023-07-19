-- Leonardo Olmos Saucedo | Lab Stored Procedures

USE sakila;

/* 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
Convert the query into a simple stored procedure. 
Use the following query:
*/
DELIMITER $$

CREATE PROCEDURE GET_ACTION_RENTS()
BEGIN 
	select first_name, last_name, email
	from customer
	join rental on customer.customer_id = rental.customer_id
	join inventory on rental.inventory_id = inventory.inventory_id
	join film on film.film_id = inventory.film_id
	join film_category on film_category.film_id = film.film_id
	join category on category.category_id = film_category.category_id
	where category.name = "Action"
	group by first_name, last_name, email;
END $$ 

DELIMITER ;

CALL GET_ACTION_RENTS();


/* 2. Now keep working on the previous stored procedure to make it more dynamic. 
Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
For eg., it could be action, animation, children, classics, etc.
*/
DELIMITER $$

CREATE PROCEDURE GET_ACTION_RENTS_BY_CATEGORY(IN FILM_CATEGORY CHAR(30))
BEGIN 
	select first_name, last_name, email
	from customer
	join rental on customer.customer_id = rental.customer_id
	join inventory on rental.inventory_id = inventory.inventory_id
	join film on film.film_id = inventory.film_id
	join film_category on film_category.film_id = film.film_id
	join category on category.category_id = film_category.category_id
	where CAST(category.name AS BINARY) = CAST(FILM_CATEGORY AS BINARY)
	group by first_name, last_name, email;
END $$ 

DELIMITER ;

CALL GET_ACTION_RENTS_BY_CATEGORY("Animation");

DESCRIBE category;

SELECT DISTINCT(C.NAME) AS CATEGORY_NAME
FROM CATEGORY C;


/* 3. Write a query to check the number of movies released in each movie category. 
Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
Pass that number as an argument in the stored procedure.
*/

SELECT COUNT(F.FILM_ID) AS FILMS_RELEASED, C.NAME
FROM FILM F 
JOIN FILM_CATEGORY FC 
ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C 
ON C.CATEGORY_ID = FC.CATEGORY_ID
GROUP BY C.NAME;

DELIMITER $$ 

CREATE PROCEDURE GET_BY_TOTAL_FILMS(IN NUMBER_OF_FILMS INT)
BEGIN
	SELECT * 
    FROM (
		SELECT COUNT(F.FILM_ID) AS FILMS_RELEASED, C.NAME
		FROM FILM F 
		JOIN FILM_CATEGORY FC 
		ON F.FILM_ID = FC.FILM_ID
		JOIN CATEGORY C 
		ON C.CATEGORY_ID = FC.CATEGORY_ID
		GROUP BY C.NAME
	) AS S1
    WHERE S1.FILMS_RELEASED > NUMBER_OF_FILMS;
END $$

DELIMITER ;

CALL GET_BY_TOTAL_FILMS(60);