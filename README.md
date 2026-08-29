# Zepto Quick-Commerce Analytics

##  Project Overview

An end-to-end analytics project focused on understanding customer behavior, product performance, revenue trends, and delivery operations for a quick-commerce business.

The project uses SQL for data analysis and Power BI for interactive dashboarding.

##  Business Objectives

- Analyze overall revenue and order performance
- Understand customer segments and purchasing behavior
- Identify high-performing products and categories
- Analyze revenue and order trends
- Evaluate delivery performance and operational challenges
- Understand customer ratings and review patterns

##  Dataset

The analysis uses six interconnected tables:

- Customers
- Products
- Orders
- Transactions
- Ratings
- Delivery

##  Tools & Technologies

- MySQL — Data analysis and SQL querying
- Power BI — Data modeling, DAX and visualization
- Excel/CSV — Data preparation

##  Analysis Performed

### Customer Analytics
- Customer segmentation
- Customer conversion
- City-wise AOV

### Product & Category Analytics
- Category revenue
- Sub-category performance
- Top products by revenue
- Price range vs demand

### Revenue & Order Analytics
- Monthly revenue
- Month-over-month revenue growth
- Basket size analysis
- Day-wise order trends
- Order status analysis

### Delivery Analytics
- Delivery status analysis
- State-wise late delivery
- Distance vs delivery time
- Distance vs late delivery

### Customer Experience
- Rating analysis
- Category-wise ratings
- Delivery status vs rating
- Review analysis

##  Key Insights

- Generated approximately **₹36.12M revenue** across **20,000 orders**, with an AOV of approximately **₹1,966**.
- **Repeat customers** represent the largest customer segment with **5,442 customers**.
- **Baby Care** is the highest-revenue category at approximately **₹9.26M**.
- The **₹100–249** price range drives the highest unit volume, while **₹250–499** products contribute higher revenue.
- Approximately **49.68% of deliveries are late**, highlighting a significant delivery reliability challenge.
- **Rajasthan** has the highest late-delivery rate at **51.11%**.
- Average delivery time increases sharply with distance, from **17.11 minutes for 0–3 km** to **75.73 minutes for 10+ km**.
- Customer ratings are relatively consistent across categories, ranging from approximately **3.85 to 3.90**.
- Positive reviews primarily highlight freshness, packaging and fast delivery, while negative reviews mention quality, damaged items, missing items and delivery delays.

##  Business Recommendations

- Investigate operational causes behind high late-delivery rates, particularly in high-delay states.
- Optimize delivery zones and capacity planning for longer-distance orders.
- Use cross-selling and bundling to increase the value of customer baskets.
- Focus retention initiatives on repeat customers and encourage higher purchase frequency.
- Monitor product quality, missing-item incidents and delivery delays to improve customer experience.

## SQL Analysis

The SQL analysis covers customer segmentation, revenue and order trends, product and category performance, delivery operations, and customer experience.

##  Power BI Dashboard

The dashboard provides an interactive view of business performance, customer behavior, product performance, and delivery operations.

### Executive Overview
<img width="884" height="500" alt="image" src="https://github.com/user-attachments/assets/d240f662-97a6-49a6-acc1-8df39dd382ff" />

**Key takeaways**

- 20K orders generated approximately ₹36.12M in revenue.
- Average Order Value (AOV) is approximately ₹1,966.
- Nearly half of deliveries are late, highlighting delivery reliability as a key operational challenge.
  
### Customer Analytics
<img width="888" height="499" alt="image" src="https://github.com/user-attachments/assets/958d21c4-7223-4f61-9547-a92885061a0b" />
**Key takeaways**

- Repeat customers form the largest customer segment with 5,442 customers.
- Customer behavior indicates an opportunity to increase purchase frequency among one-time customers.

### Product & Category Analytics
<img width="889" height="499" alt="image" src="https://github.com/user-attachments/assets/3c3155ef-730f-48f1-aaae-a410d68f5d13" />
**Key takeaways**

- Baby Care is the highest-revenue category at approximately ₹9.26M.
- A small group of products contributes significantly to overall category revenue.

### Delivery & Operations
<img width="884" height="498" alt="image" src="https://github.com/user-attachments/assets/0baeb6fa-f8a9-40e5-939b-44799d1aebf0" />
**Key takeaways**

- 49.68% of deliveries are late.
- Rajasthan has the highest late-delivery rate at 51.11%.
- Delivery time increases substantially with delivery distance.

## Project Structure

```text
Zepto-Quick-Commerce-Analytics/
│
├── README.md
├── SQL/
│   └── zepto_analytics.sql
├── PowerBI/
│   ├── Zepto_Analytics.pbix
│   └── Zepto_Analytics.pdf
