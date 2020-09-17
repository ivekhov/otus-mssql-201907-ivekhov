-----------------------------------------------------------------------------------------
-- 1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
-----------------------------------------------------------------------------------------

/* Subquery */
USE WideWorldImporters;
SELECT 
FullName
, IsSalesperson
FROM Application.People
WHERE IsSalesperson = 1 AND
PersonID NOT IN 
	(
		SELECT DISTINCT SalespersonPersonID
		FROM Sales.Orders
	);

/* CTE */
USE WideWorldImporters;
WITH FindZeroSalesperson AS 
(
	SELECT DISTINCT SalespersonPersonID
	FROM Sales.Orders
)
SELECT 
ap.FullName 
FROM Application.People AS ap
WHERE ap.IsSalesperson = 1 
	AND ap.PersonID  IN (SELECT * FROM FindZeroSalesperson);

/* проверочный запрос. выводятся все продажники, у которых были заказы. 
т.к. в результате задачи нет ни одного продажника с условием */
USE WideWorldImporters;
SELECT DISTINCT
ap.FullName
, ap.IsSalesperson
, ap.PersonID
, so.SalespersonPersonID
, ap.IsEmployee
FROM Application.People as ap
LEFT JOIN Sales.Orders as so
	ON ap.PersonID = so.SalespersonPersonID
WHERE ap.IsSalesperson = 1
ORDER BY ap.FullName ASC;

-----------------------------------------------------------------------------------------
-- 2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 
-----------------------------------------------------------------------------------------

/* Simple select */
USE WideWorldImporters;
SELECT DISTINCT TOP (10)  StockItemName, UnitPrice
FROM Warehouse.StockItems
ORDER BY UnitPrice ASC;

/* Subquery */
USE WideWorldImporters;
SELECT StockItemName, UnitPrice
FROM Warehouse.StockItems 
WHERE UnitPrice =
	(
		SELECT MIN(UnitPrice)
		FROM Warehouse.StockItems
	);

/* CTE */
USE WideWorldImporters;
WITH LowestPrice AS 
(
	SELECT MIN(UnitPrice) as LowestPrice
	FROM Warehouse.StockItems	
)
SELECT StockItemName , UnitPrice
FROM Warehouse.StockItems 
WHERE UnitPrice IN (SELECT * FROM  LowestPrice);

-----------------------------------------------------------------------------------------
-- 3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей 
-- из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE)
-----------------------------------------------------------------------------------------


/* join */
USE WideWorldImporters;
SELECT 
TOP(5)
sct.AmountExcludingTax As MaxAmount
,sct.CustomerID
,sc.CustomerName
FROM Sales.CustomerTransactions as sct
LEFT JOIN Sales.Customers as sc
	ON sc.CustomerID = sct.CustomerID
ORDER BY MaxAmount DESC;
GO

/* subquery */
USE WideWorldImporters;
SELECT 
sc.CustomerName as CustomerName
,sc.CustomerID
FROM Sales.Customers as sc
WHERE sc.CustomerID IN
	(
		SELECT TOP(5)
		sct.CustomerID
		--,sct.ANY_FIELD_FROM_THIS_TABLE
		FROM Sales.CustomerTransactions as sct
		ORDER BY sct.AmountExcludingTax DESC
	);
GO

/* cte */
USE WideWorldImporters;
WITH FindMaxAmount AS
	(
		SELECT TOP(5)
		sct.CustomerID
		FROM Sales.CustomerTransactions as sct
		ORDER BY sct.AmountExcludingTax DESC
	)
SELECT 
sc.CustomerName
--,sc.ANY_FIELD_FROM_THIS_TABLE		
FROM Sales.Customers as sc
WHERE sc.CustomerId IN 
	(
		SELECT * FROM FindMaxAmount
	)
;
GO

----------------------------------------------------------------
/*
4. Выберите города (ид и название), 
	в которые были доставлены товары, 
		входящие в тройку самых дорогих товаров, 
а также Имя сотрудника, который осуществлял упаковку заказов
2do : проблема с поиском поляи таблицы идшника сотрудника-упаковщика
*/
----------------------------------------------------------------


USE WideWorldImporters;
WITH TopExpensGoods AS 
(
	SELECT DISTINCT TOP(3)
	UnitPrice
	FROM Sales.OrderLines
	ORDER BY UnitPrice DESC
)
SELECT 
DISTINCT
sc.DeliveryCityID
,ac.CityName
,so.SalespersonPersonID AS SalesPersonID /* optionally added*/
,ap.FullName AS SalesPersonFullName /* optionally added*/
,so.PickedByPersonID AS PickedPersonID
,ap2.FullName AS PickedPersonName
FROM Sales.OrderLines AS sol
LEFT JOIN Sales.Orders AS so
	ON so.OrderID = sol.OrderID
LEFT JOIN Sales.Customers AS sc
	ON sc.CustomerID = so.CustomerID
LEFT JOIN Application.Cities AS ac
	ON ac.CityID = sc.DeliveryCityID
LEFT JOIN Application.People AS ap
	ON ap.PersonID = so.SalespersonPersonID
LEFT JOIN Application.People AS ap2
	ON ap2.PersonID = so.PickedByPersonID
WHERE sol.UnitPrice IN 
	(
		SELECT UnitPrice FROM TopExpensGoods
	)
ORDER BY ac.CityName;
GO

--------------------------------------------------------------------------
-- 5. Объясните, что делает и оптимизируйте запрос:
--------------------------------------------------------------------------

USE WideWorldImporters;

SELECT
Sales.Invoices.InvoiceID
,Sales.Invoices.InvoiceDate
,(
	SELECT People.FullName
	FROM Application.People 
	WHERE People.PersonID = Invoices.SalespersonPersonID 
) AS SalesPersonName
, SalesTotals.TotalSumm AS TotalSummByInvoice
, (
	SELECT SUM (OrderLines.PickedQuantity * OrderLines.UnitPrice) 
	FROM Sales.OrderLines 
	WHERE OrderLines.OrderId = 
		(
			SELECT Orders.OrderId 
			FROM Sales.Orders 
			WHERE NOT Orders.PickingCompletedWhen IS NULL	 
				AND Orders.OrderId = Invoices.OrderId
		)	 
) AS TotalSummForPickedItems 
FROM Sales.Invoices 
JOIN 
	(
		SELECT InvoiceID, SUM (Quantity * UnitPrice) AS TotalSumm 
		FROM Sales.InvoiceLines
		GROUP BY InvoiceId
		HAVING SUM(Quantity * UnitPrice) > 27000
	) AS SalesTotals
	ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC;


/*
описание запроса: 
Выбраны инвойсы (идшка, дата, продажник), 
общая сумма которых превышает 27000, приведена сумма этого инвойса,
сравнивается со стоимостью товаров, отгруженных по инвойсу.
инвойсы фильтруются по признаку завершенности и проверяются по соответствию 
(идшка заказа и инвойса)
инвойсы отранжированы по сумме по убыванию.
*/
--------------------------------------------------------------------------