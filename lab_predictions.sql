-- Lab | Making predictions with logistic regression --

-- In this lab, you will be using the Sakila database of movie rentals.
use sakila;

-- In order to optimize our inventory, we would like to know which films will be rented next month and we are asked to create a model to predict it.

-- 1 Create a query or queries to extract the information you think may be relevant for building the prediction model. 
-- It should include some film features and some rental features.

-- 2 Read the data into a Pandas dataframe.

-- 3 Analyze extracted features and transform them. You may need to encode some categorical variables, or scale numerical variables.

-- 4 Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable.


drop view if exists film_prediction;

create view film_prediction as 
select 
	distinct f.film_id,
    count(r.rental_id) as nr_of_rentals, 
    fc.category_id, 
    f.rental_duration,
    f.rental_rate, 
    f.rating, 
    f.release_year, 
    f.length,  
    case
	when f.film_id in (
		select film_id 
        from rental as r
		join inventory as i
		using(inventory_id)
		join film as f
		using(film_id)
		where date_format(convert(r.rental_date,date), '%Y-%m') ='2006-02') then 1
	else 0
	end as rented_last_month
from rental r
right join inventory i on r.inventory_id = i.inventory_id
right join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
group by f.film_id
order by f.film_id;

select * from film_prediction;
