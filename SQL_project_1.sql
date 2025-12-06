select * from retail_sales;
select * from retail_sales
WHERE 
	quantiy IS NULL 
	OR
	age IS NULL
	OR 
	cogs IS NULL;
--UNIQUE CUSTOMERS LIST
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales;

--Data Analysis 

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022.

SELECT *  FROM retail_sales
WHERE 
		category = 'Clothing' 
		AND
		quantiy>3
		AND
		YEAR(sale_date)=2022
		AND
		MONTH(sale_date)=11;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,SUM(total_sale) as total 
FROM retail_sales
GROUP BY category


-- Q.4 Write a SQL query to find the average age of customers who purchased itemsfrom the 'Beauty' category.

SELECT category,AVG(age) AS Average_age
FROM retail_sales
where category='Beauty'
Group by category

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id)made by each gender in each category.

SELECT COUNT(transactions_id) as total_number_of_transactions ,gender,category from retail_sales
GROUP BY gender,category
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month.Find out the best selling month in each year.

WITH monthly_sales AS(
	SELECT  YEAR(sale_date) as sale_year,MONTH(sale_date) as sale_month,AVG(total_sale) as avg_monthly_sale
	FROM retail_sales
	GROUP BY YEAR(sale_date),MONTH(sale_date)
)
SELECT sale_year,sale_month,avg_monthly_sale
FROM (
	SELECT *,RANK() OVER (PARTITION BY sale_year ORDER BY avg_monthly_sale DESC) AS Rank
	FROM monthly_sales
)t
WHERE Rank = 1;


--OR


SELECT * FROM 
(
	SELECT
		YEAR(sale_date) as sale_year,
		MONTH(sale_date) as sale_month,
		AVG(total_sale) as avg_monthly_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC)AS rank
	FROM retail_sales
	GROUP BY YEAR(sale_date),MONTH(sale_date)
)AS t
WHERE rank=1
		

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.


SELECT TOP 5 customer_id ,SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC 


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT category, COUNT(DISTINCT customer_id) AS number_of_unique_customers 
FROM retail_sales
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders (Example: Morning <= 12, Afternoon between 12 & 17, Evening > 17).
WITH hourly_sales
AS
(
SELECT *,
	CASE 
		WHEN DATEPART(HOUR, sale_time) <= 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 13 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
)
SELECT shift,COUNT(*)AS total_orders FROM hourly_sales
GROUP BY shift

--END OF PROJECT