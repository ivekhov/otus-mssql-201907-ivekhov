------------------------------------------------------------------------------------
-- #1 Все товары, в которых в название есть пометка urgent или
-- название начинается с Animal 
------------------------------------------------------------------------------------
USE WideWorldImporters;
SELECT StockItemName
FROM WideWorldImporters.Warehouse.StockItems
WHERE StockItemName like '%urgent%'or 
StockItemName like 'Animal%'

------------------------------------------------------------------------------------
--#2 Поставщиков, у которых не было сделано ни одного заказа, JOIN
------------------------------------------------------------------------------------
USE WideWorldImporters;
SELECT DISTINCT ps.SupplierName
FROM Purchasing.Suppliers as ps  
LEFT JOIN 
	Purchasing.SupplierTransactions as pst 
	ON ps.SupplierID = pst.SupplierID
WHERE pst.SupplierID  IS NULL

------------------------------------------------------------------------------------
-- #3. Продажи с названием месяца, в котором была продажа, номером квартала, 
-- к которому относится продажа, включите также к какой трети года относится дата - каждая 
-- треть по 4 месяца, дата забора заказа должна быть задана, с ценой товара более 100$ либо 
-- количество единиц товара более 20. Добавьте вариант этого запроса с постраничной выборкой 
-- пропустив первую 1000 и отобразив следующие 100 записей. 
-- Сортировка должна быть по номеру квартала, трети года, дате продажи. 
------------------------------------------------------------------------------------

-- основной источник информации о продажах : Sales.OrderLines
-- без оффсета
USE WideWorldImporters;
SELECT 
solines.OrderID
,StockItemID
,solines.Description
,Quantity
,UnitPrice
,TaxRate
,so.OrderDate As OrderDate
,UnitPrice * Quantity AS TotalCostWOTax
,(UnitPrice * Quantity + (TaxRate / 100) * UnitPrice * Quantity)  AS TotalCostWithTax
,DATENAME (quarter, so.OrderDate) AS Quarter
, CASE 
	WHEN MONTH (so.OrderDate) BETWEEN 1 AND 4 THEN 1
	WHEN MONTH (so.OrderDate) BETWEEN 5 AND 8 THEN 2
	WHEN MONTH (so.OrderDate) BETWEEN 9 AND 12 THEN 3
END as Tertial
, DATENAME (month, so.OrderDate) As Month
, CONVERT(date, so.ExpectedDeliveryDate) as DeliveryDate
FROM [WideWorldImporters].[Sales].[OrderLines] as solines
LEFT JOIN Sales.Orders as so
	ON so.OrderID = solines.OrderID
WHERE Quantity > 20 OR UnitPrice > 100
ORDER BY Quarter ASC, Tertial ASC, OrderDate ASC


-- с оффсетом и постраничной выборкой 
DECLARE 
	@pagesize BIGINT = 100,
	@pagenum BIGINT = 10;

USE WideWorldImporters;
SELECT 
solines.OrderID
,StockItemID
,solines.Description
,Quantity
,UnitPrice
,TaxRate
,so.OrderDate As OrderDate
,UnitPrice * Quantity AS TotalCostWOTax
,(UnitPrice * Quantity + (TaxRate / 100) * UnitPrice * Quantity)  AS TotalCostWithTax
,DATENAME (quarter, so.OrderDate) AS Quarter
, CASE 
	WHEN MONTH (so.OrderDate) BETWEEN 1 AND 4 THEN 1
	WHEN MONTH (so.OrderDate) BETWEEN 5 AND 8 THEN 2
	WHEN MONTH (so.OrderDate) BETWEEN 9 AND 12 THEN 3
END as Tertial
, DATENAME (month, so.OrderDate) As Month
, CONVERT(date, so.ExpectedDeliveryDate) as DeliveryDate
FROM [WideWorldImporters].[Sales].[OrderLines] as solines
LEFT JOIN Sales.Orders as so
	ON so.OrderID = solines.OrderID
WHERE Quantity > 20 OR UnitPrice > 100
ORDER BY Quarter ASC, Tertial ASC, OrderDate ASC
OFFSET @pagenum * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;


---------------------------------------------------------
-- 4. Заказы поставщикам, которые были исполнены за 2014й год 
-- с доставкой Road Freight или Post, добавьте название поставщика, 
-- имя контактного лица принимавшего заказ
---------------------------------------------------------

USE WideWorldImporters;
SELECT 
ppo.PurchaseOrderID
, ppo.OrderDate
, adm.DeliveryMethodName
, ps.SupplierName
, ap.FullName
FROM Purchasing.PurchaseOrders as ppo
LEFT JOIN Application.DeliveryMethods as adm
	ON adm.DeliveryMethodID = ppo.DeliveryMethodID
LEFT JOIN Purchasing.Suppliers as ps
	ON ps.SupplierID = ppo.SupplierID
LEFT JOIN Application.People as ap
	ON ap.PersonID = ppo.ContactPersonID
WHERE ppo.IsOrderFinalized = 1 
	AND YEAR(ppo.OrderDate) = 2014
	AND (adm.DeliveryMethodName IN ('Post', 'Road Freight'))

---------------------------------------------------------
-- 5. 10 последних по дате продаж с именем клиента 
-- и именем сотрудника, который оформил заказ.
---------------------------------------------------------

USE WideWorldImporters;
SELECT TOP(10)
si.InvoiceDate as Date
, ap.FullName
, si.InvoiceID
, si.OrderID
FROM Sales.Invoices as si
LEFT JOIN Application.People as ap
	ON si.SalespersonPersonID = ap.PersonID
ORDER BY Date DESC


---------------------------------------------------------
--6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
---------------------------------------------------------

USE WideWorldImporters;
SELECT 
DISTINCT wsit.CustomerID
, sc.CustomerName
, sc.PhoneNumber
, wsi.StockItemName
FROM Warehouse.StockItemTransactions as wsit
LEFT JOIN Sales.Customers as sc
	ON sc.CustomerID = wsit.CustomerID
LEFT JOIN Warehouse.StockItems as wsi
	ON wsit.StockItemID = wsi.StockItemID
WHERE wsi.StockItemName = 'Chocolate frogs 250g'
	AND wsit.CustomerID IS NOT NULL 
ORDER BY wsit.CustomerID ASC

-----------------------------------------------------------

