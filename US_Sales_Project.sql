-- Rename columns
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data.Sales Channel.US_sales_project..US_Regional_Sales_Data.Sales Channel','SalesChannel'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data._SalesTeamID','SalesTeamID'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data._CustomerID','CustomerID'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data._StoreID','StoreID'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data._ProductID','ProductID'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data.Order Quantity','OrderQuantity'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data.Discount Applied','DiscountApplied'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data.Unit Cost','UnitCost'
EXEC sp_rename'US_sales_project..US_Regional_Sales_Data.Unit Price','UnitPrice'

-- 1. Sales channel analysis
-- Convert varchar to datetime format
WITH date_format_table AS (
select *, 
(case 
    when charindex('/',right(sales.ProcuredDate,4)) > 0  then CONVERT(datetime,sales.ProcuredDate,3)
    else convert(datetime,replace(sales.ProcuredDate,'/20','/'),3)
end) AS ProcuredDate_mod,
(case 
    when charindex('/',right(sales.OrderDate,4)) > 0  then CONVERT(datetime,sales.OrderDate,3)
    else convert(datetime,replace(sales.OrderDate,'/20','/'),3)
end) AS OrderDate_mod,
(case 
    when charindex('/',right(sales.ShipDate,4)) > 0  then CONVERT(datetime,sales.ShipDate,3)
    else convert(datetime,replace(sales.ShipDate,'/20','/'),3)
end) AS ShipDate_mod,
(case 
    when charindex('/',right(sales.DeliveryDate,4)) > 0  then CONVERT(datetime,sales.DeliveryDate,3)
    else convert(datetime,replace(sales.DeliveryDate,'/20','/'),3)
end) AS DeliveryDate_mod
from US_sales_project..US_Regional_Sales_Data as sales
)
-- What is the most efficient sales channel?
SELECT year(OrderDate_mod) as OrderYear
     , SalesChannel       
     , count(OrderNumber) as TotalOrders
     , sum(OrderQuantity) as TotalProductSold
     , round(sum(UnitPrice * OrderQuantity * (1 - (DiscountApplied))),2) as TotalRevenue
FROM date_format_table
GROUP BY year(OrderDate_mod), SalesChannel
ORDER BY OrderYear ASC



--2. SalesChannel + SalesTeam time series analysis
-- Convert varchar to datetime format
WITH date_format_table AS (
select *, 
(case 
    when charindex('/',right(sales.ProcuredDate,4)) > 0  then CONVERT(datetime,sales.ProcuredDate,3)
    else convert(datetime,replace(sales.ProcuredDate,'/20','/'),3)
end) AS ProcuredDate_mod,
(case 
    when charindex('/',right(sales.OrderDate,4)) > 0  then CONVERT(datetime,sales.OrderDate,3)
    else convert(datetime,replace(sales.OrderDate,'/20','/'),3)
end) AS OrderDate_mod,
(case 
    when charindex('/',right(sales.ShipDate,4)) > 0  then CONVERT(datetime,sales.ShipDate,3)
    else convert(datetime,replace(sales.ShipDate,'/20','/'),3)
end) AS ShipDate_mod,
(case 
    when charindex('/',right(sales.DeliveryDate,4)) > 0  then CONVERT(datetime,sales.DeliveryDate,3)
    else convert(datetime,replace(sales.DeliveryDate,'/20','/'),3)
end) AS DeliveryDate_mod
from US_sales_project..US_Regional_Sales_Data as sales
)
-- SalesChannel + SalesTeam time series analysis
SELECT year(OrderDate_mod) AS OrderYear
     , month(OrderDate_mod) AS OrderMonth
     , SalesChannel
     , SalesTeamID
     , count(OrderNumber) as TotalOrders
     , sum(OrderQuantity) as TotalProductSold
     , round(sum(UnitPrice * OrderQuantity * (1 - (DiscountApplied))),2) as TotalRevenue
FROM date_format_table
GROUP BY month(OrderDate_mod), year(OrderDate_mod), SalesChannel, SalesTeamID
ORDER BY OrderYear, OrderMonth, SalesTeamID ASC


--3. Product analysis
-- Convert varchar to datetime format
WITH date_format_table AS (
select *, 
(case 
    when charindex('/',right(sales.ProcuredDate,4)) > 0  then CONVERT(datetime,sales.ProcuredDate,3)
    else convert(datetime,replace(sales.ProcuredDate,'/20','/'),3)
end) AS ProcuredDate_mod,
(case 
    when charindex('/',right(sales.OrderDate,4)) > 0  then CONVERT(datetime,sales.OrderDate,3)
    else convert(datetime,replace(sales.OrderDate,'/20','/'),3)
end) AS OrderDate_mod,
(case 
    when charindex('/',right(sales.ShipDate,4)) > 0  then CONVERT(datetime,sales.ShipDate,3)
    else convert(datetime,replace(sales.ShipDate,'/20','/'),3)
end) AS ShipDate_mod,
(case 
    when charindex('/',right(sales.DeliveryDate,4)) > 0  then CONVERT(datetime,sales.DeliveryDate,3)
    else convert(datetime,replace(sales.DeliveryDate,'/20','/'),3)
end) AS DeliveryDate_mod
from US_sales_project..US_Regional_Sales_Data as sales
)
-- Product analysis
SELECT year(OrderDate_mod) AS OrderYear
     , month(OrderDate_mod) AS OrderMonth
     , WarehouseCode
     , ProductID
     , sum(OrderQuantity) as TotalProductSold
     , round(sum(UnitPrice * OrderQuantity * (1 - (DiscountApplied))),2) as TotalRevenue
FROM date_format_table
GROUP BY month(OrderDate_mod), year(OrderDate_mod), WarehouseCode, ProductID
ORDER BY OrderYear, OrderMonth, ProductID ASC


--4. Warehouse analysis
-- Convert varchar to datetime format
WITH date_format_table AS (
select *, 
(case 
    when charindex('/',right(sales.ProcuredDate,4)) > 0  then CONVERT(datetime,sales.ProcuredDate,3)
    else convert(datetime,replace(sales.ProcuredDate,'/20','/'),3)
end) AS ProcuredDate_mod,
(case 
    when charindex('/',right(sales.OrderDate,4)) > 0  then CONVERT(datetime,sales.OrderDate,3)
    else convert(datetime,replace(sales.OrderDate,'/20','/'),3)
end) AS OrderDate_mod,
(case 
    when charindex('/',right(sales.ShipDate,4)) > 0  then CONVERT(datetime,sales.ShipDate,3)
    else convert(datetime,replace(sales.ShipDate,'/20','/'),3)
end) AS ShipDate_mod,
(case 
    when charindex('/',right(sales.DeliveryDate,4)) > 0  then CONVERT(datetime,sales.DeliveryDate,3)
    else convert(datetime,replace(sales.DeliveryDate,'/20','/'),3)
end) AS DeliveryDate_mod
from US_sales_project..US_Regional_Sales_Data as sales
)
-- WH analysis
SELECT year(OrderDate_mod) AS OrderYear
     , month(OrderDate_mod) AS OrderMonth
     , WarehouseCode
     , count(ProductID) as NumPro
FROM date_format_table
GROUP BY month(OrderDate_mod), year(OrderDate_mod), WarehouseCode
ORDER BY OrderYear, OrderMonth, ProductID ASC
