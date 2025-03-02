use sakila;
select * from customer;

-- task 1 customers who are inactive
select * from customer where active = 0;

-- task2 identify first name, last name and email for above
select first_name, last_name, email from customer where active = 0;

-- task 3 store id having high inactive customers
select store_id, count(active) as 'inactive_customers' from customer  where active = 0 group by store_id limit 1;

-- task 4 movies that are rated pg13
select * from film;
select title as 'Movies PG13' from film where rating = 'PG-13';

-- task 5 Pg13 movie with longest running time
select title as 'Movies PG13', length as 'Duration' from film where rating = 'PG-13' order by Duration desc limit 1;

-- task 6 most poular pg13 movie based on rental duration
select title, rental_duration, rental_rate from film where rating = 'PG-13' and rental_duration <= 5 and rental_rate = 0.99 order by rental_duration desc limit 1;

-- task 7 average rental cost = 2.98
select avg(rental_rate) as 'Average of rental rate' from film;

-- task 8 total replacement cost = 19984
select sum(replacement_cost)  'Total replacement cost' from film;

-- task 9 count of animation and children movies
select category_id, name from category where name in ('Animation', 'Children'); -- > Ani 2 & chil 3 are the output
select count(film_id) as 'No of animation and children movies' from film_category where category_id in (2, 3); -- total 126
select count(film_id) as 'No of children movies' from film_category where category_id = 3; -- total 60
select count(film_id) as 'No of animation movies' from film_category where category_id = 2; -- total 66
