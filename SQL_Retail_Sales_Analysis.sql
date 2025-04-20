--SQL Retail Sales Analysis	
CREATE DATABASE SQL_Retail_Sales_Analysis

--Create Table
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales
         (
		   transactions_id INT PRIMARY KEY,
		   sale_date DATE,
		   sale_time TIME,
		   customer_id	INT,
		   gender VARCHAR(15),
		   age INT,
		   category	VARCHAR(15),
		   quantity INT,
		   price_per_unit FLOAT,
		   cogs	FLOAT,
		   total_sale FLOAT
         );

--To see the values of first 10 rows
SELECT * FROM Retail_Sales
LIMIT 10;

--To calculate the no of Rows
SELECT  
    COUNT (*)
FROM Retail_Sales;

--To Check if there is any null value in the column
SELECT * FROM Retail_Sales
WHERE transactions_id IS null;

SELECT * FROM Retail_Sales
WHERE sale_date IS null;

SELECT * FROM Retail_Sales
WHERE sale_time IS null;

SELECT * FROM Retail_Sales
WHERE customer_id IS null;

SELECT * FROM Retail_Sales
WHERE gender IS null;

--it has missing value
SELECT * FROM Retail_Sales
WHERE age IS null;

SELECT * FROM Retail_Sales
WHERE category IS null;

--it has missing value
SELECT * FROM Retail_Sales
WHERE quantiy IS null;

--it has missing value
SELECT * FROM Retail_Sales
WHERE price_per_unit IS null;

--it has missing value
SELECT * FROM Retail_Sales
WHERE cogs IS null;

--it has missing value
SELECT * FROM Retail_Sales
WHERE total_sale IS null;


--2nd METHOD - In which ever column it will find null value it will print those rows for the columns
SELECT * FROM Retail_Sales
WHERE 
	transactions_id IS null
	OR
	sale_date IS null
	OR
	sale_time IS null
    OR
	customer_id IS null
	OR	
	gender IS null
	OR	
	age IS null
	OR	
	category IS null
	OR	
	quantity IS null
	OR	
	price_per_unit IS null
	OR	
	cogs IS null
	OR	 
	total_sale IS null;

--To Delete those Rows Which have Null Values
DELETE FROM Retail_Sales
WHERE 
	transactions_id IS null
	OR
	sale_date IS null
	OR
	sale_time IS null
    OR
	customer_id IS null
	OR	
	gender IS null
	OR	
	age IS null
	OR	
	category IS null
	OR	
	quantity IS null
	OR	
	price_per_unit IS null
	OR	
	cogs IS null
	OR	 
	total_sale IS null;
 
--START PROJECT 

--DATA EXPLORATION

-- HOW MANY ROWS WE HAVE?
SELECT COUNT(*) AS total_sale FROM Retail_Sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT category) AS total_Category FROM Retail_Sales;

--TO GET THE UNIQUE CATEGORY
SELECT DISTINCT category FROM Retail_Sales;


--DATA ANALYSIS & BUSINESS PROBLEMS & ANSWERS

--Q1 - Write SQL Query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM Retail_Sales where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--STEP1 - To find the 'clothing' category rows
SELECT *
       FROM Retail_Sales
	   Where category = 'Clothing'


--STEP 2 : To select the date format and show the data for 2022-11
SELECT *
       FROM Retail_Sales
	   Where category = 'Clothing'
	   AND	TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'

--STEP 3 : Final Query
SELECT *
       FROM Retail_Sales
	   Where category = 'Clothing'
	   AND	TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
	   AND quantity >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, 
       SUM(total_sale) as Net_Sale
	   FROM Retail_Sales 
	   Group BY category

--If we want to also calculat the total order for each category
SELECT category, 
       SUM(total_sale) as Net_Sale,
	   Count(*) AS total_orders
	   FROM Retail_Sales 
	   Group BY category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age),2) as Avg_Customer_age
	FROM Retail_Sales
	WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT transactions_id
	FROM Retail_Sales
	WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
       category, 
       gender,
	   COUNT(*) AS Total_Trans
	FROM Retail_Sales
	GROUP BY category, gender
	ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Step1
SELECT 
    Extract(Year from sale_date) as Year,  -- For MYSQL, - Year(sale_date)
	Extract(Month from sale_date) as Month, -- For MYSQL, - Month(sale_date)
	AVG(total_sale) as Avg_Total_Sale
FROM Retail_Sales
Group By 1,2
ORDER BY 1, 3 DESC   

--Step2
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2

--Step 3
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, 
       SUM(total_sale) AS Total_Sale
FROM Retail_Sales
Group BY 1
ORDER BY 2 Desc
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--Step -1
SELECT category, 
       COUNT(customer_id)
FROM Retail_Sales
Group BY 1

--Step-2
SELECT category, 
       COUNT(DISTINCT customer_id) AS Count_Unique_Customer
FROM Retail_Sales
Group BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

--Code to get current Hour - SELECT EXTRACT(HOUR FROM Current_Time)

--Step-1
SELECT *,
    CASE
	   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
	   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'  --Here 12 and 17 are included
	   ELSE 'EVENING'
    END AS Shift
FROM Retail_Sales

--Step 2 - Make CTE(common table expression)
WITH hourly_sale
AS
(
SELECT *,
    CASE
	   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
	   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'  --Here 12 and 17 are included
	   ELSE 'EVENING'
    END AS Shift
FROM Retail_Sales
)
SELECT
      shift,
      COUNT(*) AS Total_Orders
FROM Hourly_sale
GROUP BY shift
 
--END OF PROJECT

