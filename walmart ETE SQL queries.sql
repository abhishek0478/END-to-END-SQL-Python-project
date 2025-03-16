select * from walmart1


SELECT
payment_method,
COUNT(*)
FROM walmart1
GROUP BY payment_method

Business Problems
--Q.1 Find different payment method and number of transactions, number of qty sold
SELECT
payment_method,
COUNT(*) as no_payments,
SUM(quantity) as no_qty_sold
FROM walmart1
GROUP BY payment_method

--Question #2
--Identify the highest-rated category in each branch, displaying the branch, category,AVG RATING

Select *
from (
	SELECT
branch,
category,
AVG(rating) as avg_rating,
RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
FROM walmart1
GROUP BY 1, 2
) as sub
where rank = 1

--Question 3 Identify the busiest day for each branch based on the number of transactions

Select *
from (
	Select branch,
	TO_CHAR(date, 'Day') AS day_name,
	count(*) as no_transactions,
	Rank() over(partition by branch order by count(*) desc) as rank
	from walmart1
	group by 1,2
) as subq
where rank = 1


--Calculate the total quantity of items sold per payment method, list payment_method.

SELECT
payment_method,
SUM(quantity) as no_qty_sold
FROM walmart1
GROUP BY payment_method

--Q.5
--Determine the average, minimum, and maximum rating of category for each city.
--List the city, average_rating, min_rating, and max_rating.
SELECT
city,
category,
MIN(rating) as min_rating,
MAX(rating) as max_rating,
Avg(rating) as avg_rating
from walmart1
group by 1,2

--Q.6
--Calculate the total profit for each category by considering total_profit as
--(unit_price* quantity * profit_margin).
--List category and total_profit, ordered from highest to lowest profit.

Select category,
sum(total) as revenue,
sum(total* profit_margin) as profit
from walmart1
group by 1

--Question 7
--Determine the most common payment method for each Branch.
--Display Branch and the preferred_payment_method.

with cte as (
SELECT
branch,
payment_method,
COUNT(*) as total_trans,
RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart1
GROUP BY 1, 2
)

select * from cte
where rank = 1

-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT
	branch,
CASE 
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart1
GROUP BY 1, 2
ORDER BY 1, 3 DESC



-- #9 Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

-- rdr == last_rev-cr_rev/ls_rev*100



SELECT *,
       EXTRACT(YEAR FROM date) AS formatted_year
FROM walmart1;

-- 2022 sales
WITH revenue_2022
AS
(
	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart1
	WHERE EXTRACT(YEAR FROM date) = 2022 -- psql
	-- WHERE YEAR(TO_DATE(date, 'DD/MM/YY')) = 2022 -- mysql
	GROUP BY 1
),

revenue_2023
AS
(

	SELECT 
		branch,
		SUM(total) as revenue
	FROM walmart1
	WHERE EXTRACT(YEAR from date) = 2023
	GROUP BY 1
)

SELECT 
	ls.branch,
	ls.revenue as last_year_revenue,
	cs.revenue as cr_year_revenue,
	ROUND(
		(ls.revenue - cs.revenue)::numeric/
		ls.revenue::numeric * 100, 
		2) as rev_dec_ratio
FROM revenue_2022 as ls
JOIN
revenue_2023 as cs
ON ls.branch = cs.branch
WHERE 
	ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5




























































































