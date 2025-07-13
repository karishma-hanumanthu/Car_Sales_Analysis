create table car_sales(
	[car_id] int primary key,
	[brand] varchar(150),
	[model_name] varchar(150),
	[model_variant] varchar(150),
	[car_type] varchar(150),
	[transmission] varchar(150),
	[fuel_type] varchar(150),
	[year] int,
	[kilometers] float,
	[owner] varchar(150),
	[state] varchar(150),
	[accidental] varchar(150),
	[price_inr] float
)

SELECT* FROM car_sales;

--1.Which car brands generate the most sales and revenue overall?
select 
	brand,
	count(*) as no_of_cars_sold,
	sum(price_inr) as total_revenue,
	avg(price_inr) as avg_revenue,
	round((sum(price_inr)*100.0)/(select sum(price_inr) from car_sales),2) as percentage_revenue
from car_sales
group by brand
order by no_of_cars_sold desc;

--2.Which specific car models and variants perform best in terms of sales and revenue?
select
	brand,
	model_name,
	model_variant,
	car_type,
	count(*) as no_of_cars_sold,
	sum(price_inr) as total_revenue,
	avg(price_inr) as avg_revenue,
	sum(price_inr)*100.0/(select sum(price_inr) from car_sales) as percentage_revenue
from car_sales
group by brand,model_name,model_variant,car_type
order by no_of_cars_sold desc;

--3.What is the most popular car transmission type among buyers?
select
	transmission,
	count(*) as preferred_count
from car_sales
group by transmission;

--4.Average Kilometers per brand
select
	brand,
	round(avg(kilometers),2) as avg_kilometers
from car_sales
group by brand
order by avg_kilometers desc;

--5.In which year were the most cars sold, and when was the highest revenue generated?
select
	year,
	count(*) as no_of_cars_sold,
	sum(price_inr) as revenue_generated,
	avg(price_inr) as avg_revenue,
	sum(price_inr)*100.0/(select sum(price_inr) from car_sales) as percentage_revenue
from car_sales
group by year
order by no_of_cars_sold desc;

--6.How does car age affect the average selling price by brand and model?
select
	brand,model_name,model_variant,car_type,
	(2025-year) as car_age,
	avg(price_inr) as avg_price,
	dense_rank() over(partition by brand order by avg(price_inr) desc) as rank
from car_sales
group by year,brand,model_name,model_variant,car_type
order by brand,rank;

--7.Which states have the highest number and rate of accidental cars?
select
	state,
	count(case when accidental='Yes' then 1 end) as no_of_accidents,
	count(case when accidental='Yes' then 1 end)*1.0/count(*) as accident_rate
from car_sales
group by state
order by accident_rate desc;

--8.What are the most common combinations of transmission and fuel type?
select
	transmission,
	fuel_type,
	count(*) as count
from car_sales
group by transmission,fuel_type
order by count desc;

--9.Which brands have the highest average selling prices in each state?
with cte as(
select
	state,
	brand,
	round(avg(price_inr),2) as avg_revenue,
	row_number() over(partition by state order by avg(price_inr) desc) as rn
from car_sales
group by state,brand)

select
	state,
	brand,
	avg_revenue
from cte
where rn<=3;

--10.What are the top 3 most popular car brands in each state?
select state,brand,cars_sold from(
select
	state,
	brand,
	count(*) as cars_sold,
	row_number() over(partition by state order by count(*) desc) as rn
from car_sales
group by state,brand)t
where rn<=3;

--11.Which cars have the highest and lowest prices within each ownership category?
select* from(
select*,
row_number() over(partition by owner order by price_inr desc) rn1,
row_number() over(partition by owner order by price_inr) rn2
from car_sales)t  where rn1=1 or rn2=1;

--12.How are cars distributed across low, medium, and high price categories?
with cte as(
select*,
	case when price_inr<950000 then 'Low'
		 when price_inr>=950000 and price_inr<=1900000 then 'Medium'
	     else 'High' end as price_category
from car_sales)

select price_category,count(*) as count,sum(price_inr) as total_revenue,
avg(price_inr) as avg_revenue,sum(price_inr)*100.0/(select sum(price_inr) from cte) as percentage_revenue
from cte
group by price_category;

--13.How does car ownership vary across different price categories?
with cte as(
select*,
	case when price_inr<950000 then 'Low'
		 when price_inr>=950000 and price_inr<=1900000 then 'Medium'
	     else 'High' end as price_category
from car_sales)

select price_category,owner,count(*) as count
from cte
group by price_category,owner
order by price_category,owner;

--14.how does kilometers vary across different price categories
with cte as(
select*,
	case when price_inr<950000 then 'Low'
		 when price_inr>=950000 and price_inr<=1900000 then 'Medium'
	     else 'High' end as price_category
from car_sales)

select 
	price_category,
	round(avg(kilometers),2) as avg_kilometers
from cte
group by price_category;

--15.How have sales numbers changed year-over-year for each brand?
with brand_sales as (
    select
        brand,
        year,
        count(*) as cars_sold
    from car_sales
    group by brand, year
)
select
    brand,
    year,
    cars_sold,
    cars_sold - lag(cars_sold) over (partition by brand order by year) as yoy_change,
    round(
        100.0 * (cars_sold - lag(cars_sold) over (partition by brand order by year)) /
        nullif(lag(cars_sold) over (partition by brand order by year), 0), 2
    ) as yoy_percentage_change
from brand_sales
order by brand, year;

--16.Which model gave the highest sales for each brand in a given year?
with cte as(
select
	brand,
	model_name,
	model_variant,
	car_type,
	year,
	count(*) as no_of_cars_sold,
	dense_rank() over(partition by brand order by count(*) desc) as rn
from car_sales
group by brand,model_name,model_variant,year,car_type)

select brand,model_name,model_variant,
car_type,year,no_of_cars_sold
from cte
where rn=1;

--17.Which car listings are statistical outliers in terms of price?
select * from (
    select *,
        (price_inr - avg(price_inr) over ()) / nullif(stdev(price_inr) over (), 0) as z_score
    from car_sales
) t
where abs(z_score) > 2
order by z_score desc;

--18.How does the average price of cars vary over time for different fuel types?
select
    fuel_type,
    year,
    round(avg(price_inr), 0) as avg_price
from car_sales
group by fuel_type, year
order by fuel_type, year;

--19.What is the yearly market share (by units sold) of each car brand?
with cte as(
select distinct
	brand,
	year,
	count(1) over(partition by brand,year) as cars_sold,
	count(1) over(partition by brand) as total_cars_sold
from car_sales)

select *,
round(cars_sold*100.0/total_cars_sold,2) as market_share_percentage
from cte
order by brand,year,market_share_percentage;

--20.How are the cars categorized based on kilometers driven, and which usage category has the highest number of cars and revenue?
select 
    case when kilometers <= 20000 then 'almost new'
         when kilometers <= 50000 then 'lightly used'
         when kilometers <= 100000 then 'moderately used'
         else 'heavily used' end as usage_category,
    count(*) as total_cars,
	round(avg(price_inr),2) as avg_revenue
from car_sales
group by case when kilometers <= 20000 then 'almost new'
         when kilometers <= 50000 then 'lightly used'
         when kilometers <= 100000 then 'moderately used'
         else 'heavily used' end
order by total_cars desc;




