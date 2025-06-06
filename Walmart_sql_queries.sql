use walmart_sales;
show tables ;
select * from walmart;

## DATA CLEANING ##
-- Add the time_of_day column

select time ,
(case when 'time' between "00:00:00" and "12:00:00" then 'Morning'
	 when 'time' between "12:01:00" and  "16:00:00" then 'Afternoon'
            else 'Evening'
            end)  as time_of_day
from walmart;

Alter table walmart add column time_of_day varchar(20);

select * from walmart;

update walmart set time_of_day =(
case when 'time' between "00:00:00" and "12:00:00" then 'Morning'
	 when 'time' between "12:01:00" and  "16:00:00" then 'Afternoon'
            else 'Evening'
            end);
            
select * from walmart;

-- Add day_name column

select date ,DAYNAME(DATE) from walmart;

Alter table walmart add column day_name varchar(20);

select * from walmart;
 update walmart set day_name = dayname(date);



-- Add month_name column

Alter table walmart add column month_name varchar(10);

update walmart set month_name =monthname(date);

select * from walmart;

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?

select distinct city from walmart ;

-- In which city is each branch?

select distinct city , branch from walmart;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------
 -- How many unique product lines does the data have?
 select * from walmart;
 desc walmart;

ALTER TABLE walmart CHANGE `Product line` `product_line` VARCHAR(22);
Alter table walmart change `Invoice ID` `Invoiceid` text;
Alter table walmart change `Customer type` `Customer_type` text;
Alter table walmart change `Unit price` `Unit_price` double;
Alter table walmart change `Tax 5%` `Tax_5%` double;
Alter table walmart change `gross margin percentage` `gross_margin_percentage` double;
Alter table walmart change `gross income` `gross_income` double;
Alter table walmart change `Date` `Dates` DATE;

desc walmart;

select distinct product_line from walmart;

-- What is the most selling product line
 select * from walmart;
 
 select product_line , sum(Quantity) as most_selling from walmart group by product_line order by most_selling desc;
 
 -- What is the total revenue by month
 select month(date) as monthly , sum(Total) as total_revenue from walmart group by month(date) order by total_revenue desc;
 
-- What month had the largest COGS?
select * from walmart;
 
select month_name as months , sum(cogs) as largest from walmart group by month_name order by largest desc limit 1;

-- What product line had the largest revenue?

select product_line, sum(total) as revenue from walmart group by product_line order by revenue desc;

-- What is the city with the largest revenue?

select city ,branch , sum(total) as revenue from walmart group by city , branch order by revenue desc limit 1;

-- What product line had the largest VAT?

select * from walmart;
desc walmart;
select product_line , sum(`Tax_5%`)  as VAT from walmart group by product_line  order by VAT desc limit 1;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

alter table walmart add column sale_type varchar(10);
select * from walmart;

SELECT AVG(total) INTO @avg_total FROM walmart;
update walmart set sale_type =(case when total > @avg_total then 'Good'
else 'Bad'
end);

-- Which branch sold more products than average product sold?

select branch , sum(Quantity) as qty from walmart 
group by branch 
having sum(Quantity) > (select avg(Quantity) as walmart);

-- What is the most common product line by gender

select product_line , gender , count(gender) as coun from walmart group by product_line , gender 
order by coun desc;

-- What is the average rating of each product line

select * from walmart;

select product_line , round(avg(Rating),2) as average_rating from walmart 
group by product_line 
order by average_rating desc ;  

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------
-- How many unique customer types does the data have?

select distinct customer_type from walmart;
select * from walmart;

-- How many unique payment methods does the data have?

select distinct payment from walmart;

-- What is the most common customer type?
SELECT
	customer_type,count(*) as count
FROM walmart
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    round(sum(total),0) as totalsales
FROM walmart
GROUP BY customer_type
order by totalsales desc;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,branch ,COUNT(*) as gender_cnt
FROM walmart
GROUP BY gender,branch
ORDER BY gender,gender_cnt DESC;


-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	avg(rating) AS avg_rating
FROM walmart
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,branch,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,branch,
	COUNT(day_name) total_sales
FROM walmart

GROUP BY day_name,branch
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,day_name,
	COUNT(*) AS total_sales
FROM walmart

GROUP BY time_of_day , day_name
ORDER BY total_sales DESC;


-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	round(SUM(total),0) AS total_revenue
FROM walmart 
GROUP BY customer_type
ORDER BY total_revenue desc;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(max(`Tax_5%`), 2) AS avg_tax_pct
FROM walmart
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(`Tax_5%`) AS avg_total_tax
FROM walmart
GROUP BY customer_type
ORDER BY avg_total_tax;








