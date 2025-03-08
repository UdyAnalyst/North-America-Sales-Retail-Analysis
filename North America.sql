SELECT * FROM [Sales Retail]

--to create Dimcustomer from sales retail table

SELECT * INTO Dimcustomer
FROM 
	(SELECT Customer_ID, Customer_Name FROM [Sales Retail])
AS DimC


WITH CTE_DimC
AS
	(SELECT Customer_ID, Customer_Name,ROW_NUMBER() OVER (PARTITION BY  Customer_ID, Customer_Name ORDER BY  Customer_ID ASC) AS RowNum
	FROM Dimcustomer
	)
DELETE FROM CTE_DimC
WHERE RowNum > 1

--to create DimLocation from sales retail table

SELECT * INTO DimLocation
FROM  
	(SELECT Postal_Code,Country, City,State,Region FROM [Sales Retail])
	AS DimL

WITH CTE_DimL
AS
(SELECT Postal_Code,Country, City,State,Region,ROW_NUMBER() OVER (PARTITION BY Postal_Code,Country, City,State,Region ORDER BY Postal_Code ASC) AS RowNum
	FROM DimLocation
	)
DELETE FROM CTE_DimL
WHERE RowNum > 1 --to remove duplicates

--to create DimProduct from sales retail table

SELECT * INTO DimProduct
FROM  
	(SELECT Product_ID, Category,Sub_Category, Product_Name FROM [Sales Retail])
AS DimP

WITH CTE_DimP
AS
(SELECT Product_ID, Category,Sub_Category, Product_Name,ROW_NUMBER() OVER (PARTITION BY Product_ID, Category,Sub_Category, Product_Name ORDER BY Product_ID ASC) AS RowNum
	FROM DimProduct
		)
DELETE FROM CTE_DimP
WHERE RowNum > 1 --to remove duplicates

--to create our salesfact table

SELECT* INTO OrdersFactTable
FROM
	(SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Segment, Postal_Code, Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit
	FROM [Sales Retail])
	AS OrderFact

WITH CTE_OrderFact
AS
(SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Segment, Postal_Code, Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit,
ROW_NUMBER() OVER (PARTITION BY Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Segment, Postal_Code, Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit ORDER BY Order_ID ASC) AS RowNum
	FROM OrdersFactTable
	)
DELETE FROM CTE_OrderFact
WHERE RowNum > 1 --to remove duplicates

SELECT* FROM DimProduct
WHERE Product_ID = 'FUR-FU-10004091'

--to add a new column(surrogate key) called product key to serve as the unique identifier for DimProduct
ALTER TABLE DimProduct
ADD ProductKey INT IDENTITY(1,1) PRIMARY KEY;

--To add the ProductKey to the OrderFact Table

ALTER TABLE OrdersFactTable
ADD ProductKey INT

UPDATE OrdersFactTable
SET ProductKey = DimProduct.ProductKey
FROM OrdersFactTable
JOIN DimProduct
ON OrdersFactTable.Product_ID = DimProduct.Product_ID

--To drop the Product_ID in the OrdersFactTable
ALTER TABLE DimProduct
DROP COLUMN Product_ID

ALTER TABLE OrdersFactTable
DROP COLUMN Product_ID

SELECT * FROM OrdersFactTable
WHERE Order_ID = 'CA-2014-102652'

--To add a unique Identifier to the OrderFactTable
ALTER TABLE OrdersFactTable
ADD Row_ID INT IDENTITY (1,1)

-- Exploratory analysis
-- What is the average Delivery days for different Product subcategory
SELECT * FROM OrdersFactTable
SELECT * FROM DimProduct

SELECT dp.Sub_category, Avg(DATEDIFF(Day, oft.Order_Date,oft.Ship_Date)) AS AvgDeliveryDays
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
GROUP BY dp.Sub_Category

--What is the average Delivery days for segment

SELECT Segment, Avg(DATEDIFF(Day, Order_Date,Ship_Date)) AS AvgDeliveryDays
FROM OrdersFactTable 
GROUP BY Segment
ORDER BY AvgDeliveryDays DESC

--What are the top 5 fastest delivered products and slowest delivered products

SELECT TOP 5(dp.Product_Name), DATEDIFF(Day, oft.Order_Date,oft.Ship_Date) AS DeliveryDays
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
ORDER BY 2 ASC

SELECT TOP 5(dp.Product_Name), DATEDIFF(Day, oft.Order_Date,oft.Ship_Date) AS DeliveryDays
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
ORDER BY 2 DESC

--Which Sub-category generate most profit

SELECT dp.Sub_category, ROUND(SUM(oft.Profit),2) AS TotalProfit
FROM OrdersFactTable AS oft
LEFT JOIN DimProduct AS dp
ON Oft.ProductKey = dp.ProductKey
WHERE Profit > 0
GROUP BY dp.Sub_Category
ORDER BY 2 DESC;


--Which segment generate most profit
SELECT Segment, ROUND(SUM(Profit),2) AS TotalProfit
FROM OrdersFactTable 
WHERE Profit > 0
GROUP BY Segment
ORDER BY 2 DESC


--Which Top 5 Customers made the most Profit
SELECT TOP 5 (dc.Customer_Name),ROUND(SUM(oft.Profit),2) AS TotalProfit
FROM OrdersFactTable AS oft
LEFT JOIN Dimcustomer AS dc
ON oft.Customer_ID = dc.Customer_ID
WHERE Profit > 0
GROUP BY dc.Customer_Name
ORDER BY 2 DESC


--What is the total number of product by sub-category
SELECT Sub_category, COUNT(Product_Name) AS TotalProduct
FROM DimProduct 
GROUP BY Sub_Category
ORDER BY 2 DESC

SELECT* FROM DimProduct