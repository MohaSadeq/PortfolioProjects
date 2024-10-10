SELECT * FROM sakila.film;
-- # 1) All films with PG-13 films with rental rate of 2.99 or lower
select*
from film F 
WHERE F.rating = 'PG-13'AND F.rental_rate<= 2.99;

# 2) All films that have deleted scenes
select f.title, f.special_features, f.release_year
	from film f 
where f.special_features like '%Deleted scenes%'
	and title like 'c%'
;

# 3) All active customers
select* from customer
where active = 1;

# 4) Names of customers who rented a movie on 26th July 2005
select r.rental_id,r.rental_date, r.customer_id, concat(C.first_name,' ', C.last_name) 'Full Name'
from rental r
join customer c on c.customer_id=r.customer_id 
where date(r.rental_date) = '2005-07-26';

# 5) Distinct names of customers who rented a movie on 26th July 2005

select distinct r.customer_id, concat(C.first_name,' ', C.last_name) 'Full Name'
from rental r
join customer c on c.customer_id=r.customer_id 
where date(r.rental_date) = '2005-07-26';

# H1) How many distinct last names we have in the data?
select distinct  c.last_name
from rental r 
join customer c on c.customer_id = r.customer_id
join staff s on s.staff_id = r.staff_id
;
-- distinct last names
Select count(distinct c.last_name) as Distinct_Last_Name 
from customer c;



# 6) How many rentals we do on each day?
 select  date(rental_date) Date  ,count(*) 'Total rentals'
 from rental
 group by date(rental_date);
 
 -- Busiest day
 Select date(rental_date), count(*)  rental_count
from rental
group by date(rental_date)
order by rental_count desc
limit 1;
 
 
 # 7) All Sci-fi films in our catalogue
select fc.film_id, fc.category_id, c.name, f.title, f.release_year
	from film_category fc
		join category c on c.category_id= fc.category_id
		join film f on f.film_id= fc.film_id
			where c.name = 'SCI-fi';
 
 # 8) Customers and how many movies they rented from us so far?

select r.customer_id ,count(*) Total_buy, concat( c.first_name,' ', c.last_name) FullName
	from rental r
    join customer c on c.customer_id=r.customer_id
    
    group by r.customer_id
    order by count(*) desc;
 
 # 9) Which movies should we discontinue from our catalogue (less than 5 lifetime rentals)

-- using CTE's

with low_rentals as
	(select inventory_id, count(*) Total
from rental r 
group by inventory_id
having count(*)<=1)

select i.inventory_id, f.film_id, title, description
	from low_rentals
    join inventory i on i.inventory_id=low_rentals.inventory_id
    join film f on f.film_id= i.film_id;



 
 
 
 
 























































































