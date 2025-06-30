CREATE DATABASE coffee_shop;
USE coffee_shop;
SELECT * FROM coffee_shop.coffee_sales;
DESC coffee_sales;

-- CHECKING MEMORY CONSUMPTION
SELECT DATA_LENGTH/1024
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA= 'coffee_shop' AND
TABLE_NAME= 'coffee_sales';

-- CONVERTING TRANSACTION_DATE COLUMN ONTO A SINGLE FORMAT OF DATE
UPDATE coffee_sales
SET transaction_date =STR_TO_DATE(transaction_date,'%d-%m-%Y');

-- CHANGING DATATYPE OF TRANSACTION_DATE COLUMN
ALTER TABLE coffee_sales
MODIFY COLUMN transaction_date DATE;

-- CONVERTING TRANSACTION_TIME COLUMN ONTO A SINGLE FORMAT OF DATE
UPDATE coffee_sales
SET transaction_time = STR_TO_DATE(transaction_time,'%H:%i:%s');

-- CHANGING DATATYPE OF TRANSACTION_TIME COLUMN
ALTER TABLE coffee_sales 
MODIFY COLUMN transaction_time TIME;

-- CHANGING DATATYPE OF TRANSACTION_ID COLUMN
ALTER TABLE coffee_sales
MODIFY COLUMN transaction_id INT;

-- CHANGING DATATYPE OF TRANSACTION_QTY COLUMN
ALTER TABLE coffee_sales
MODIFY COLUMN  transaction_qty INT;

-- CHANGING DATATYPE OF STORE_ID COLUMN
ALTER TABLE coffee_sales
MODIFY COLUMN store_id INT;

-- CHANGING DATATYPE OF PRODUCT_ID COLUMN
ALTER TABLE coffee_sales
MODIFY COLUMN product_id INT;

-- KPIS REQUIREMENT 1.1
SELECT MONTHNAME(transaction_date),ROUND(SUM(transaction_qty * unit_price)) AS total_sales
FROM coffee_sales
GROUP BY MONTHNAME(transaction_date);
-- OR FOR PARTICULAR MONTH
SELECT ROUND(SUM(transaction_qty * unit_price))
FROM coffee_sales
WHERE MONTHNAME(transaction_date) = 'May';

-- KPIS REQUIREMENT 1.3
SELECT 
	MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty),1)
    OVER(ORDER BY MONTH(transaction_date))) /LAG(SUM(unit_price * transaction_qty),1)
    OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM coffee_sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- KPIS REQUIREMENT 2.1
SELECT MONTH(transaction_date), COUNT(*)
FROM coffee_sales
GROUP BY MONTH(transaction_date);
-- OR
SELECT COUNT(transaction_id)
FROM coffee_sales
WHERE MONTH(transaction_date) = 3; -- HERE YOU CAN CHANGE MONTH NO

-- KPIS REQUIREMENT 2.3
SELECT 
	MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id),1)
    OVER(ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id),1)
    OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
    FROM coffee_sales
    WHERE MONTH(transaction_date) IN (4,5)
    GROUP BY MONTH(transaction_date)
    ORDER BY MONTH(transaction_date);   
    
-- KPIS REQUIREMENT 3.1
SELECT SUM(transaction_qty) AS Total_quantity_sold
FROM coffee_sales
WHERE MONTH(transaction_date) = 6; -- JUNE MONTH 

-- KPIS REQUIREMENT 3.3
SELECT 
	MONTH(transaction_date),
    SUM(transaction_qty) AS Total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty),1) OVER(ORDER BY MONTH(transaction_date))) /
    LAG(SUM(transaction_qty),1) OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM coffee_sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- REQUIREMENT 1.3
SELECT 
DATE(transaction_date),
SUM(transaction_qty * unit_price) AS Total_sales,
SUM(transaction_qty) AS Total_quantity_sold,
COUNT(transaction_id) AS Total_orders
FROM coffee_sales
GROUP BY DATE(transaction_date);
-- OR
SELECT 
SUM(transaction_qty * unit_price) AS Total_sales,
SUM(transaction_qty) AS Total_quantity_sold,
COUNT(transaction_id) AS Total_orders
FROM coffee_sales
WHERE transaction_date = '2023-05-15';

-- REQUIREMENT 2.1
SELECT 
	CASE WHEN DAY(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS Day_type,
	SUM(transaction_qty * unit_price) AS Total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 1
GROUP BY
	CASE WHEN DAY(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END;

-- REQUIREMENT 3.1
SELECT
store_location,
SUM(transaction_qty * unit_price) AS Total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY store_location
ORDER BY SUM(transaction_qty * unit_price) DESC;

-- REQUIREMENT 4.1
SELECT AVG(Total_sales) AS Avg_sales
FROM	(
		SELECT
			ROUND(SUM(transaction_qty * unit_price)) AS Total_sales
		FROM coffee_sales
		WHERE MONTH(transaction_date) = 5
		GROUP BY transaction_date
		) AS INNER_QUERY;

------- and ------
SELECT
	transaction_date,
    ROUND(SUM(transaction_qty * unit_price)) AS Daily_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
GROUP BY transaction_date;


	