# North America Sales Retail Optimization Analysis
This is a project from Data clique 1 bootcamp practical


## Project Overview
North America Retail is a major retail company operating in multiple
locations, offering a wide range of products to different customer
groups. They focus on excellent customer service and a smooth
shopping experience.

As a data analyst, my job was to analyze their sales data to reveal
key insights on profitability, business performance, products, and
customer behavior. I worked with a dataset containing details on
products, customers, sales, profits, and returns. My findings
helped identify areas for improvement and suggest strategies to boost
efficiency and profitability.

## Data Source
The dataset used was provided by Data clique (Retail Supply Chain Sales Analysis.CSV)

## Tools used
- SQL

## Data Cleaning and Preparation
- Data importation and inspection
- Splited the data into fact and dimension tables then created an ERD

## Objectives
1. What was the Average delivery days for different
product subcategory?
2. What was the Average delivery days for each segment ?
3.What are the Top 5 Fastest delivered products and Top 5
slowest delivered products?
4. Which product Subcategory generate most profit?
5. Which segment generates the most profit?
6. Which Top 5 customers made the most profit?
7. What is the total number of products by Subcategory?

## Data Analysis
### 1. What was the Average delivery days for different
product subcategory?
```sql
SELECT dp.Sub_category, Avg(DATEDIFF(Day, oft.Order_Date,oft.Ship_Date)) AS AvgDeliveryDays
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
GROUP BY dp.Sub_Category;
/* It takes an average of 32 days to deliver products from bookcase and Chairs sub-categories,
average of 34 days to deliver product from Furnishings Sub-category and
average of 36 days to deliver products from Table Sub-category */
```


### 2. What was the Average delivery days for each segment?
```sql
SELECT Segment, Avg(DATEDIFF(Day, Order_Date,Ship_Date)) AS AvgDeliveryDays
FROM OrdersFactTable 
GROUP BY Segment
ORDER BY AvgDeliveryDays DESC

/* The average delivery days are 35, 34, 31 days for Corporate, Consumer and Home Office segment respectively */
```


### 3.What are the Top 5 Fastest delivered products and Top 5
slowest delivered products?
```sql
SELECT TOP 5(dp.Product_Name), DATEDIFF(Day, oft.Order_Date,oft.Ship_Date) AS DeliveryDays
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
ORDER BY 2 ASC
/* The Top 5 fastest delivered products with 0 days which means the product were delivered the same day
Sauder Camden County Barrister Bookcase, Planked Cherry Finish
Sauder Inglewood Library Bookcases
O'Sullivan 2-Shelf Heavy-Duty Bookcases
O'Sullivan Plantations 2-Door Library in Landvery Oak
O'Sullivan Plantations 2-Door Library in Landvery Oak */


SELECT TOP 5(dp.Product_Name), DATEDIFF(Day, oft.Order_Date,oft.Ship_Date) AS DeliveryDays
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
ORDER BY 2 DESC
/* The Top 5 Slowest delivered products with 214 days
Bush Mission Pointe Library
Hon Multipurpose Stacking Arm Chairs
Global Ergonomic Managers Chair
Tensor Brushed Steel Torchiere Floor Lamp
Howard Miller 11-1/2" Diameter Brentwood Wall Clock */ 
```
### 4. Which product Subcategory generate most profit?
```sql
SELECT dp.Sub_category, ROUND(SUM(oft.Profit),2) AS TotalProfit
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
WHERE Profit > 0
GROUP BY dp.Sub_Category
ORDER BY 2 DESC;
/* Chairs sub-category makes most of the company's profit of about 36471.1 and Tables sub-category makes the least of the company's profit of about 8358 */
```
5. Which segment generates the most profit?
```sql
SELECT Segment, ROUND(SUM(Profit),2) AS TotalProfit
FROM OrdersFactTable 
WHERE Profit > 0
GROUP BY Segment
ORDER BY 2 DESC

/* Consumer segment makes most of the company's profit of about 35427.03 and Home Office makes the least of the company's profit of about 13657.04 */
```
6. Which Top 5 customers made the most profit?
```sql
SELECT TOP 5 (dc.Customer_Name),ROUND(SUM(oft.Profit),2) AS TotalProfit
FROM OrdersFactTable AS oft
LEFT JOIN Dimcustomer AS dc
ON oft.Customer_ID = dc.Customer_ID
WHERE Profit > 0
GROUP BY dc.Customer_Name
ORDER BY 2 DESC
/* The following are the top 5 customers the generate more profit to the company
Laura Armstrong
Joe Elijah
Seth Vernon
Quincy Jones
Maria Etezadi */
```
7. What is the total number of products by Subcategory?
```sql
SELECT Sub_category, COUNT(Product_Name) AS TotalProduct
FROM DimProduct 
GROUP BY Sub_Category
ORDER BY 2 DESC
/* The total number of product for each sub-category are as follows
Furnishings 186
Chairs  87
Bookcases 48
Tables  34 */
```

## Insights
1. It takes an average of 32 days to deliver products from bookcase and Chairs sub-categories,
average of 34 days to deliver product from Furnishings Sub-category and
average of 36 days to deliver products from Table Sub-category.
2. The average delivery days are 35, 34, 31 days for Corporate, Consumer and Home Office segment respectively.
3. The Top 5 fastest delivered products with 0 days which means the product were delivered the same day
Sauder Camden County Barrister Bookcase, Planked Cherry Finish
Sauder Inglewood Library Bookcases
O'Sullivan 2-Shelf Heavy-Duty Bookcases
O'Sullivan Plantations 2-Door Library in Landvery Oak
O'Sullivan Plantations 2-Door Library in Landvery Oak
4. The Top 5 Slowest delivered products with 214 days
Bush Mission Pointe Library
Hon Multipurpose Stacking Arm Chairs
Global Ergonomic Managers Chair
Tensor Brushed Steel Torchiere Floor Lamp
Howard Miller 11-1/2" Diameter Brentwood Wall Clock
5. Chairs sub-category makes most of the company's profit of about 36471.1 and Tables sub-category makes the least of the company's profit of about 8358.
6. Consumer segment makes most of the company's profit of about 35427.03 and Home Office makes the least of the company's profit of about 13657.04.
7. The following are the top 5 customers the generate more profit to the company
Laura Armstrong
Joe Elijah
Seth Vernon
Quincy Jones
Maria Etezadi
8. The total number of product for each sub-category are as follows
Furnishings 186
Chairs  87
Bookcases 48
Tables  34

## Recommendation
1. Delivery days on the slowest delivered products should be reviewed by assigning more dispatch riders.
2. An incentive should be given to the top 5 customers the generate more profit annually
3. Sourcing department should change suppliers for table sub-category to maximize profit.

