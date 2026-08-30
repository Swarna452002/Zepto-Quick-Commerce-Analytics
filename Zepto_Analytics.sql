/*
PROJECT: Zepto Quick-Commerce Analytics
TOOLS:
MySQL
OBJECTIVE:
Analyze customer behavior, product performance,
revenue trends, and delivery operations.
TABLES:
customers
products
orders
transactions
ratings
delivery
ANALYSIS AREAS:
1. Business Overview
2. Customer Analysis
3. Product & Category Analysis
4. Revenue & Order Analysis
5. Delivery Analysis
6. Customer Experience
*/

CREATE 
      database Zepto_Quick_Commerce;
      
USE   
	Zepto_Quick_Commerce;

SELECT 'customers' AS table_name, 
      COUNT(*) FROM customers
            UNION ALL
SELECT 'products', COUNT(*) FROM products
            UNION ALL
SELECT 'orders', COUNT(*) FROM orders
            UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
			UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
            UNION ALL

SELECT 'delivery',  
      COUNT(*) FROM delivery;
      
DESCRIBE customers;
ALTER TABLE customers
RENAME COLUMN ï»¿customer_id TO Customer_ID;
DESCRIBE delivery;
ALTER TABLE delivery
RENAME COLUMN Customer_ID TO Delivery_ID;
DESCRIBE orders;
ALTER TABLE orders
RENAME COLUMN ï»¿order_id TO Order_ID;
DESCRIBE products;
ALTER TABLE products
RENAME COLUMN ï»¿product_id TO Product_ID;
DESCRIBE ratings;
ALTER TABLE ratings
RENAME COLUMN ï»¿rating_id TO Rating_ID;
DESCRIBE transactions;
ALTER TABLE transactions
RENAME COLUMN ï»¿transaction_id TO Transaction_ID;

SELECT  
     SUM(amount) as total_revenue 
     from transactions;
     
SELECT 
     SUM(quantity) as total_quanity_sold 
     from transactions;
     
SELECT 
    count(distinct Order_ID) as total_orders 
    from orders;
    
## average order value

SELECT 
	SUM(t.amount) / COUNT(DISTINCT o.Order_ID) AS Average_Order_value 
       FROM transactions t 
         JOIN orders o 
            ON t.order_id=o.Order_ID;

## average rating

SELECT 
     ROUND(AVG (rating),2) AS Avg_ratings 
         FROM ratings;

## Average delivery time

SELECT 
    ROUND(AVG (delivery_time_mins),2) AS Avg_delivery_time
         FROM delivery;

## Orders per customer

SELECT 
     Customer_ID, 
        COUNT(DISTINCT Order_ID) AS order_count 
           FROM orders 
     group by Customer_ID
     order by order_count desc;

## Customer Segments

SELECT 
	c.Customer_ID AS Customer_ID, 
	   COUNT(DISTINCT o.Order_ID) AS order_count ,
          CASE
           WHEN COUNT(DISTINCT o.Order_ID) = 0 THEN 'NO ORDER'
           WHEN COUNT(DISTINCT o.Order_ID) = 1  THEN 'ONE-TIME'
           WHEN COUNT(DISTINCT o.Order_ID) BETWEEN 2 AND 4 THEN 'REPEAT'
           ELSE 'FREQUENT'
	END AS Customer_Segment 
      FROM customers c
       LEFT JOIN orders o
        ON c.Customer_ID=o.customer_id
    GROUP BY
    c.Customer_ID;

## How many customers are No Order, One-Time, Repeat, and Frequent?

SELECT 
   customer_segment,
	COUNT(*) AS customer_count
   FROM
     (SELECT 
        c.Customer_ID,
        CASE
          WHEN COUNT(DISTINCT o.Order_ID) = 0 THEN "No Order"
          WHEN COUNT(DISTINCT o.Order_ID) = 1 THEN "One Time"
          WHEN COUNT(DISTINCT o.Order_ID) between 2 AND 4 THEN "Repeat"
          ELSE "Frequent"
       END AS
       customer_segment
        FROM customers c 
         LEFT JOIN orders o
          ON c.Customer_ID=o.customer_id
       GROUP BY
        c.Customer_ID)
         AS customer_segment
             GROUP BY customer_segment
              ORDER BY customer_count DESC;

## Revenue by Customer Segement

SELECT 
  customer_segment ,
    COUNT(DISTINCT Customer_ID) AS Customer,
	SUM(revenue) AS Total_Revenue
     FROM
       (SELECT c.Customer_ID AS Customer_ID,
          CASE
            WHEN COUNT(DISTINCT o.Order_ID)=0 THEN "No order"
            WHEN COUNT(DISTINCT o.Order_ID)=1 THEN "One order"
			WHEN COUNT(DISTINCT o.Order_ID) BETWEEN 2 AND 4 THEN "Repeat"
            ELSE "Frequent"
              END AS
                customer_segment,
		 COALESCE(SUM(t.amount),0) AS revenue
           FROM customers c 
             LEFT JOIN
			   orders o
                  ON c.Customer_ID=o.customer_id
             LEFT JOIN
				transactions t
                  ON o.Order_ID=t.order_id
                     GROUP BY c.Customer_ID)
                        AS Customer_Data
		GROUP BY customer_segment
		ORDER BY Total_Revenue DESC;

## Revenue By product category

SELECT 
  p.category,
   SUM(t.amount) AS Revenue
      FROM products p 
         LEFT JOIN
           transactions t
              ON p.Product_ID=t.product_id
GROUP BY p.category
ORDER BY Revenue DESC;

## Revenue By state

SELECT 
   c.state,
     SUM(t.amount) AS Revenue
        FROM customers c 
          JOIN orders o
			ON c.Customer_ID=o.customer_ID
          JOIN transactions t
            ON o.Order_ID=t.order_ID
GROUP BY c.state
ORDER BY Revenue DESC;

## Monthly Revenue

SELECT 
   MONTH(o.order_date) AS Order_month,
   YEAR(o.order_date) As Order_Year,
   SUM(t.amount) as Revenue 
      FROM orders o 
         JOIN transactions t 
             ON o.Order_ID=t.order_id
	               GROUP BY MONTH(o.order_date),
				            YEAR(o.order_date)
                   ORDER BY MONTH(o.order_date),
				            YEAR(o.order_date);

## Top 10 products by revenue;

SELECT 
    p.product_name AS Products,
	SUM(t.amount) AS Revenue
       FROM products p
         JOIN transactions t
			ON p.Product_ID=t.product_id
GROUP BY p.product_name
ORDER BY Revenue DESC
LIMIT 10;

## Which individual products are driving the most revenue?

SELECT 
    p.Product_ID ,
	p.product_name ,
	p.category ,
	SUM(t.quantity) AS Units_Sold,
	SUM(t.amount) As Revenue
	  FROM products p
         JOIN transactions t
            ON p.Product_ID=t.product_id
GROUP BY p.Product_ID ,
	     p.product_name ,
         p.category 
ORDER BY Revenue DESC
LIMIT 10;

## How many orders are being successfully fulfilled versus cancelled?

SELECT 
   order_status,
   COUNT(DISTINCT Order_ID) AS Orders_Count
     FROM Orders
GROUP BY order_status;

## Out of all orders, what % were cancelled?

SELECT 
  COUNT(CASE WHEN order_status="cancelled" THEN 1 END) AS cancelled_orders,
  COUNT(*) AS total_orders,
  ROUND(COUNT(CASE WHEN order_status="cancelled" THEN 1 END)*100.0/COUNT(*),2)
     AS cancellation_rate FROM orders;

## Average delivery time

SELECT 
ROUND(AVG(delivery_time_mins),2) AS Avg_delivery_time
FROM delivery;

## Delivery status distribution

SELECT 
   delivery_status,
   COUNT(Delivery_ID) AS Total_Deliveries
     FROM delivery
GROUP BY delivery_status
ORDER BY Total_Deliveries DESC;

## Calculate late-delivery %

SELECT
   COUNT(CASE WHEN delivery_status="Delivered Late" THEN 1 END) AS Late_delivery,
   COUNT(*) AS Total_deliveries,
   ROUND(COUNT(CASE WHEN delivery_status="Delivered Late" THEN 1 END)*100/COUNT(*),2)
AS Late_delivery_pct
FROM delivery;

## Do longer delivery distances lead to longer delivery times?

SELECT
  CASE 
    WHEN distance_km > 3 THEN "0-3 KM"
    WHEN distance_km > 6 THEN "0-6 KM"
    WHEN distance_km >= 10 THEN "0-10 KM"
    ELSE "10+ KM"
      END AS 
        Distance_Range,
  ROUND(AVG(delivery_time_mins),2) AS AVG_Delivery_Time
    FROM delivery
GROUP BY Distance_Range
ORDER BY CASE WHEN distance_Range="0-3 KM" THEN 1
              WHEN distance_Range="0-6 KM" THEN 2
              WHEN distance_Range="0-10 KM" THEN 3
              ELSE 4
                END;

## Do customers give lower ratings when delivery takes longer?

SELECT
    CASE 
       WHEN d.delivery_time_mins =30 THEN "Under 30 mins"
       WHEN d.delivery_time_mins BETWEEN 30 AND 44 THEN "30 - 44 mins"
       WHEN d.delivery_time_mins BETWEEN 45 AND 59 THEN "44 - 59 mins"
       ELSE "60+ mins"
    END AS delivery_time_taken,
    ROUND(AVG(r.rating),2) AS Avg_ratings
      FROM delivery d JOIN ratings r
         ON d.order_id=r.order_id
			GROUP BY delivery_time_taken;

## Which products are driving revenue, and how much are customers buying?

SELECT 
  p.Product_ID,
  p.product_name,
  SUM(t.quantity) AS Units_sold,
  SUM(t.amount) AS Revenue
     FROM products p JOIN transactions t
       ON p.Product_ID=t.product_id
          GROUP BY p.Product_ID,
		           p.product_name
		  ORDER BY Revenue DESC
          LIMIT 10;

## Revenue + units by category

SELECT 
   p.category,
   SUM(t.quantity) AS Units_Sold,
   SUM(t.amount) AS Revenue
     FROM products p JOIN transactions t
       ON p.Product_ID=t.product_id
GROUP BY p.category
ORDER BY Revenue DESC;

## Average product price by category

SELECT 
  p.category,
  ROUND(AVG(t.amount),2) AS Avg_Product_Price
     FROM products p JOIN transactions t
       ON p.Product_ID=t.product_id
         GROUP BY p.category;

## Number of products in each category

SELECT 
   category,
   COUNT(DISTINCT Product_ID) AS Number_of_products
FROM products
GROUP BY category;

## Orders by year

SELECT 
   YEAR(order_date),
   COUNT(Order_ID) AS Orders
FROM orders
GROUP BY  YEAR(order_date);

## Orders by month

SELECT 
   YEAR(order_date),
   MONTH(order_date),
   COUNT(Order_ID) AS Orders
     FROM orders
GROUP BY  YEAR(order_date),
          MONTH(order_date);

## Orders by status

SELECT order_status,
COUNT(order_id) as Orders
FROM orders
GROUP BY order_status;

## Customers by city

SELECT 
    city,
    COUNT(Customer_ID) AS Customers
      FROM customers
        GROUP BY city
	    ORDER BY Customers DESC;

## Customers by gender

SELECT 
   gender,
   COUNT(DISTINCT Customer_ID) AS Customers
      FROM customers
        GROUP BY gender
        ORDER BY Customers;

## Average customer age by gender

SELECT 
    gender,
	ROUND(AVG(age),2) AS Customer_age
       FROM customers
          GROUP BY gender;

## Average delivery time by status

SELECT 
    o.order_status,
    ROUND(AVG(d.delivery_time_mins),2) AS AVG_Delivery_Time
		FROM orders o JOIN delivery d
            ON o.Order_ID=d.order_id
                 GROUP BY o.order_status;

## Average delivery time by distance range

SELECT 
    CASE 
        WHEN distance_km <3 THEN "0-3 KM"
        WHEN distance_km <6 THEN "3-6 KM"
        WHEN distance_km <10 THEN "6-10 KM"
        ELSE "10+ KM"
          END AS distance_range,
	ROUND(AVG(delivery_time_mins),2) AS Avg_delivery_time
             FROM delivery
                 GROUP BY distance_range;


## Delivery performance by state

SELECT 
   c.state,
   COUNT(d.Delivery_ID) AS Deliveries,
   ROUND(AVG(d.delivery_time_mins),2) AS Time_taken
       FROM customers c JOIN orders o
          ON c.Customer_ID=o.customer_id
              JOIN delivery d 
                 ON o.Order_ID=d.order_id
GROUP BY c.state
ORDER BY Time_taken DESC;

## Average rating by delivery status

SELECT 
    d.delivery_status,
	ROUND(AVG(r.rating),2) AS Avg_ratings
	   FROM delivery d JOIN ratings r
          ON d.order_id=r.order_id
GROUP BY d.delivery_status;

## Average rating by distance range

SELECT
    CASE
        WHEN d.distance_km < 3 THEN '0–3 km'
        WHEN d.distance_km < 6 THEN '3–6 km'
        WHEN d.distance_km < 10 THEN '6–10 km'
        ELSE '10+ km'
        END AS distance_range,
	ROUND(AVG(r.rating),2) AS avg_ratings
          FROM delivery d JOIN ratings r
              ON d.order_id=r.order_id
GROUP BY distance_range;

## Revenue by payment mode

SELECT 
     payment_mode,
        SUM(amount)AS Revenue
               FROM transactions
GROUP BY payment_mode;

## Quantity by payment mode

SELECT 
    payment_mode,
    SUM(quantity) AS No_of_quantities_sold
        FROM transactions
GROUP BY payment_mode;

## what percentage of total revenue each category contributes.

SELECT
    p.category,
    SUM(t.amount) AS total_revenue,
    ROUND(
        SUM(t.amount) * 100.0 /
        (SELECT SUM(amount) FROM transactions),
        2
    ) AS revenue_share_pct
FROM products p
JOIN transactions t
    ON p.Product_ID = t.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

## Which products combine strong demand with strong revenue generation?

SELECT p.Product_ID,
       p.product_name,
       p.category,
       SUM(t.amount) AS Revenue,
       SUM(DISTINCT quantity) AS Quantity_Sold,
       ROUND(
             SUM(t.amount)/SUM(DISTINCT quantity),
               2) AS revenue_per_unit
  FROM products p JOIN transactions t
  ON p.Product_ID = t.product_id
GROUP BY p.Product_ID,
         p.product_name,
         p.category
ORDER BY Revenue DESC
LIMIT 15;

## Average Order Value by Customer

SELECT 
    c.Customer_ID,
    c.customer_name,
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    SUM(t.amount) AS Revenue,
    ROUND(
          SUM(t.amount)/COUNT(DISTINCT o.Order_ID),
          2) AS AOV
FROM customers c JOIN orders o
ON c.Customer_ID = o.customer_id
JOIN transactions t
ON o.Order_ID = t.order_id
GROUP BY c.Customer_ID,
c.customer_name;

## How many products/units do customers typically buy in a single order?

SELECT 
     order_id,
     SUM(quantity) AS Units
FROM transactions
GROUP BY order_id;

SELECT
CASE WHEN units = 1 THEN "1 Item"
     WHEN units BETWEEN 2 AND 3 THEN "2-3 Items"
     WHEN units BETWEEN 4 AND 6 THEN "4-6 Items"
     ELSE "7+ Items"
 END AS Basket_size,
 COUNT(*) AS orders,
 ROUND(
       AVG(order_value),
       2) AS AOV
 FROM(SELECT order_id,
      SUM(quantity) AS units,
      SUM(amount) AS order_value
 FROM transactions
 GROUP BY order_id)
 AS baskets
 GROUP BY Basket_size 
 ORDER BY orders DESC;

## Which age groups are more likely to become repeat customers?

SELECT
   CASE 
      WHEN c.age < 25 THEN "Under 25"
      WHEN c.age BETWEEN 25 AND 34 THEN "25-34"
      WHEN c.age BETWEEN 35 AND 44 THEN "35-44"
      WHEN c.age BETWEEN 45 AND 54 THEN "45-54"
      ELSE "55+"
   END AS "age_group",
   COUNT(c.Customer_ID) AS No_of_customers,
   COUNT(DISTINCT o.Order_ID) AS orders 
FROM customers c JOIN orders O 
ON c.Customer_ID=o.customer_id
GROUP BY age_group
ORDER BY orders DESC;

## Do lower-priced products sell more units, or do customers also buy higher-priced products?

SELECT 
CASE WHEN p.price < 100 THEN "Under 100"
	 WHEN p.price < 250 THEN "100-249"
     WHEN p.price < 500 THEN "250-499"
     ELSE "500+"
END AS "Price_range",
COUNT(DISTINCT p.Product_ID) AS No_of_products,
SUM(t.quantity) AS Units,
SUM(t.amount) AS Revenue
FROM products p JOIN transactions T 
ON p.Product_ID=t.product_id
GROUP BY Price_range
ORDER BY 
      CASE 
         WHEN Price_range="Under 100" THEN 1
         WHEN Price_range="100-249" THEN 2
         WHEN Price_range="250-499" THEN 3
         ELSE 4
         END;

## Which days of the week generate the most orders?

SELECT 
    DAYNAME(order_date) AS Week,
    COUNT(DISTINCT Order_ID) AS Orders
FROM orders
GROUP BY DAYNAME(order_date)
ORDER BY orders;

## Is revenue growing or declining each month, and by how much?

WITH Monthly_revenue AS 
(
   SELECT MONTH(o.order_Date) AS Order_Month,
   SUM(t.amount) AS Revenue 
   FROM orders o JOIN transactions t
   ON o.Order_ID=t.order_id
   GROUP BY MONTH(o.order_date)
)
(SELECT
Order_Month,
Revenue,
ROUND(
     (Revenue - LAG(Revenue) OVER (ORDER BY Order_Month))
     *100/ LAG(Revenue) OVER(ORDER BY Order_Month),
     2) AS MOM
     FROM Monthly_revenue 
     ORDER BY Order_Month );
     
## Are most orders small baskets, or are customers placing higher-value orders?

SELECT 
    CASE 
      WHEN amount < 200 THEN "Under 200"
      WHEN amount < 500 THEN "200-449"
      WHEN amount < 1000 THEN "500-999" 
      ELSE "1000+"
    END AS
    Order_Value,
    COUNT(order_id) AS Total_Orders,
    ROUND(
    AVG(amount),
    2) AS Avg_Order_Value
 FROM transactions
 GROUP BY Order_Value;
 
 ## Which product categories have the best and worst customer satisfaction?
 
 SELECT 
       p.category,
       COUNT(DISTINCT Rating_ID) AS Reviews_Count,
       ROUND(AVG(r.rating),2) AS Avg_rating
	FROM products p JOIN transactions t
          ON p.Product_ID=t.product_id
          JOIN ratings r
          ON t.order_id=r.order_id
GROUP BY p.category;

## How many new customers are joining the platform each month?

SELECT 
    YEAR(created_date) AS Signup_Year,
    MONTH(Created_date) AS Signup_Month,
    COUNT(DISTINCT Customer_ID) AS New_Customers
FROM customers
GROUP BY YEAR(created_date),
MONTH(Created_date);

## Of the customers who registered in each month, how many actually placed an order?

SELECT  
    YEAR(c.created_date) AS Signup_Year,
	MONTH(c.Created_date) AS Signup_Month,
    COUNT(DISTINCT c.Customer_ID) AS New_Customers,
    COUNT(DISTINCT o.customer_id) AS Customers_within_order
FROM customers c JOIN orders O
ON c.Customer_ID=o.customer_id
GROUP BY YEAR(created_date),
MONTH(Created_date);

## Which Cities Have the Highest Conversion?

SELECT 
    c.city,
    COUNT(DISTINCT c.Customer_ID) AS New_Customers,
    COUNT(DISTINCT o.customer_id) AS Customers_within_orders,
    ROUND(
          (COUNT(DISTINCT c.Customer_ID)/COUNT(DISTINCT o.customer_id))
           ,2) AS Customer_Coversion_Pct
	FROM customers c JOIN orders o
    ON c.Customer_ID=o.customer_id
    GROUP BY c.city;
    
## Which cities have customers placing higher-value orders?

SELECT 
    c.city,
    COUNT(DISTINCT t.Order_ID) AS total_orders,
    SUM(t.amount) AS Revenue,
    ROUND(
         (SUM(t.amount)/COUNT(DISTINCT t.Order_ID))
         ,2) AS AOV
FROM customers c JOIN orders o
ON c.Customer_ID=o.customer_id
JOIN transactions t
ON o.Order_ID=t.order_id
GROUP BY c.city
ORDER BY Revenue DESC
LIMIT 10;

## One-time vs Repeat vs Frequent Customers

SELECT
     Customer_Segment,
     COUNT(*) AS Customers
     FROM
     (SELECT
       c.Customer_ID,
       COUNT(DISTINCT o.Order_ID) AS order_count,
       CASE 
         WHEN COUNT(DISTINCT o.Order_ID) = 0 THEN "No orders"
         WHEN COUNT(DISTINCT o.Order_ID) = 1 THEN "One Time"
         WHEN COUNT(DISTINCT o.Order_ID) BETWEEN 2 AND 4 THEN "Repeat"
         ELSE "Frequent"
		END AS Customer_Segment
		FROM customers c JOIN orders o
		ON c.Customer_ID=o.customer_id
		GROUP BY C.Customer_ID)
As Customer_Segments
GROUP BY Customer_Segment;

## Average Order Value by Order Status

SELECT o.order_status,
ROUND(
     (SUM(t.amount)/COUNT(t.order_id))
     ,2) AS AOV
     FROM orders o JOIN transactions t
     ON o.Order_ID=t.order_id
     GROUP BY o.order_status;
     
## Does Distance Affect Late Deliveries?

SELECT
    CASE WHEN distance_km <3 THEN "0-3 KM"
         WHEN distance_km <6 THEN "3-6 KM"
         WHEN distance_km <10 THEN "6-9 KM"
         ELSE "10+ KM"
    END AS Distance_Range,
    COUNT(*) AS Total_deliveries,
SUM(CASE
     WHEN delivery_status = "Delivered Late" THEN 1
     ELSE 0 
     END)
     AS Late_deliveries
     FROM delivery
     GROUP BY Distance_Range;
     
SELECT 
delivery_status,
COUNT(*) AS orders
FROM delivery GROUP BY delivery_status;

## Delivery Efficiency by State
# Which States Have Delivery Problems?

SELECT 
   c.state,
   COUNT(DISTINCT d.Delivery_ID) AS Total_deliveries,
   ROUND(AVG(d.delivery_time_mins),2) AS Avg_delivery_mins,
SUM(
CASE WHEN delivery_status="Delivered Late" THEN 1
     ELSE 0 
     END)
     AS Late_deliveries
     FROM customers c JOIN orders o
     ON c.Customer_ID=o.customer_id
     JOIN delivery d ON
     o.Order_ID=d.order_id
     GROUP BY c.state
     ORDER BY Total_deliveries DESC;
     
## Late delivery % 

SELECT
    c.state,

    COUNT(DISTINCT d.Delivery_ID) AS Total_deliveries,

    ROUND(AVG(d.delivery_time_mins), 2) AS Avg_delivery_mins,

    SUM(
        CASE
            WHEN d.delivery_status = 'Delivered Late'
            THEN 1
            ELSE 0
        END
    ) AS Late_deliveries,

    ROUND(
        SUM(
            CASE
                WHEN d.delivery_status = 'Delivered Late'
                THEN 1
                ELSE 0
            END
        ) * 100.0
        / COUNT(DISTINCT d.Delivery_ID),
        2
    ) AS Late_delivery_pct

FROM customers c

JOIN orders o
    ON c.Customer_ID = o.customer_id

JOIN delivery d
    ON o.Order_ID = d.order_id

GROUP BY c.state

ORDER BY Late_delivery_pct DESC;
     
## Customer Satisfaction
# What Are Customers Complaining About?

SELECT 
   review,
   COUNT(Rating_ID) AS Review_Count,
   ROUND(AVG(rating),2) AS Avg_rating
FROM ratings
GROUP BY review
ORDER BY Review_Count DESC;

## Rating by Order Value
# Do Higher-Value Orders Get Better Ratings?

SELECT
  CASE 
      WHEN t.amount < 200 THEN "Under 200"
      WHEN t.amount < 500 THEN "200-499"
      WHEN t.amount < 1000 THEN "500-99"
      ELSE "1000+"
  END AS Order_value,
  COUNT(t.order_id) AS Orders,
  ROUND(AVG(rating),2) AS Avg_rating
  FROM transactions t JOIN ratings r
  ON t.order_id=r.order_id
    GROUP BY Order_Value
    ORDER BY Orders;
    
## Which Categories Have Lots of Products but Low Sales?

SELECT 
    p.category,
    COUNT(DISTINCT p.Product_ID) AS Products,
    COUNT(t.order_id) AS Units_sold,
    SUM(t.amount) AS revenue
FROM products p JOIN transactions t
ON p.Product_ID=t.product_id
GROUP BY p.category
ORDER BY revenue DESC;

## Which Sub-categories Drive Revenue?

SELECT 
    p.category,
    p.sub_category,
    COUNT(t.quantity) AS Units_sold,
    SUM(t.amount) AS Revenue
FROM products p JOIN transactions t
ON p.Product_ID=t.product_id
GROUP BY p.category,
p.sub_category
ORDER BY Revenue DESC
LIMIT 20;

## High Revenue + Low Rating Categories

SELECT 
   p.category,
   SUM(t.amount) AS Revenue,
   ROUND(AVG(r.rating),2) AS Avg_ratings
FROM products p JOIN transactions t ON
p.Product_ID=t.product_id
JOIN ratings r ON
t.order_id=r.order_id
GROUP BY p.category
ORDER BY Revenue DESC;

SELECT 
    p.category,
    ROUND(AVG(r.rating),2) AS Avg_rating
FROM products p JOIN transactions t
ON p.Product_ID=t.product_id
JOIN ratings r
ON t.order_id=r.order_id
GROUP BY p.category;



