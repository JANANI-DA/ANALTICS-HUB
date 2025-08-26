-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;
use sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;


    

SELECT 
    COUNT(*) 
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    SET SQL_SAFE_UPDATES = 1;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;



SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select *FROM retail_sales
where category = 'Clothing'
  AND quantity > 10 AND sale_date >= '2022-11-01'AND sale_date < '2022-12-01';
select*from retail_sales;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, SUM(total_sale) AS total_sales
FROM retail_sales GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select AVG(age) AS average_age
from retail_sales where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
use sql_project_p2;
select gender, category, COUNT(transaction_id) AS total_transactions
from retail_sales
group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date);
WITH monthly_avg AS (
  SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_sale
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT
  year,
  month       AS best_selling_month,
  avg_sale    AS highest_avg_sale
FROM (
  SELECT
    year,
    month,
    avg_sale,
    RANK() OVER (
      PARTITION BY year
      ORDER BY avg_sale DESC
    ) AS sale_rank
  FROM monthly_avg
) ranked_months
WHERE sale_rank = 1
ORDER BY year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, SUM(total_sale) 
from retail_sales
group by customer_id order by total_spent DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, COUNT(DISTINCT customer_id) AS unique_customers
from retail_sales group by category;
select*from retail_sales;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;






