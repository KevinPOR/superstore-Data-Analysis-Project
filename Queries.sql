CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_id TEXT,
  order_date DATE,
  ship_date DATE,
  ship_mode TEXT,
  customer_name TEXT,
  segment TEXT,
  state TEXT,
  country TEXT,
  market TEXT,
  region TEXT,
  product_id TEXT,
  category TEXT,
  sub_category TEXT,
  product_name TEXT,
  sales NUMERIC,
  quantity INT,
  discount NUMERIC,
  profit NUMERIC,
  shipping_cost NUMERIC,
  order_priority TEXT,
  year INT,
  month INT,
  profit_margin NUMERIC
);

SET datestyle = 'ISO, DMY';

COPY orders(
  order_id, order_date, ship_date, ship_mode, customer_name,
  segment, state, country, market, region,
  product_id, category, sub_category, product_name,
  sales, quantity, discount, profit,
  shipping_cost, order_priority,
  year, month, profit_margin
)
FROM 'D:/SuperStore_Prj/PowerBI_datasets/superstore_cleaned.csv'
DELIMITER ','
CSV HEADER;

-- Top 10 Customers by Sales

SELECT customer_name, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Profit Margin by Category

SELECT category,
       AVG(profit / NULLIF(sales, 0)) AS avg_profit_margin
FROM orders
WHERE sales IS NOT NULL
GROUP BY category
ORDER BY avg_profit_margin ASC;

-- Profit Margin by Region

SELECT region,
       AVG(profit / NULLIF(sales, 0)) AS avg_profit_margin
FROM orders
GROUP BY region
ORDER BY avg_profit_margin ASC;

-- Count of Loss-Making Orders

SELECT COUNT(*) AS negative_orders
FROM orders
WHERE profit < 0;

-- Monthly Sales Trend

SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
       SUM(sales) AS total_sales
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

-- Region + Category Combined

SELECT region, category,
       AVG(profit / NULLIF(sales, 0)) AS avg_profit_margin
FROM orders
GROUP BY region, category
ORDER BY avg_profit_margin ASC;

-- Top Customers WITH Ranking (Window Function)

SELECT customer_name,
       SUM(sales) AS total_sales,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS rank
FROM orders
GROUP BY customer_name;

-- Profitability by Discount Level

SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category,
    AVG(profit / NULLIF(sales, 0)) AS avg_profit_margin
FROM orders
GROUP BY discount_category;