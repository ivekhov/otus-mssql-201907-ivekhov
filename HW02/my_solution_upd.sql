------------------------------------------------------------
-- исправления домашних заданий по поступившим коммментариям
------------------------------------------------------------
------------------------------------------------------------------------------------
--#2 заменена таблица, теперь используется Purchasing.PurchaseOrders
------------------------------------------------------------------------------------

USE WideWorldImporters;
SELECT DISTINCT ps.SupplierName
FROM Purchasing.Suppliers as ps  
LEFT JOIN 
	Purchasing.PurchaseOrders as ppo 
	ON ps.SupplierID = ppo.SupplierID
WHERE ppo.SupplierID  IS NULL;


------------------------------------------------------------------------------------
--#3 заменена таблица, теперь используется Sales.Orders; исключены избыточные поля из вывода 
------------------------------------------------------------------------------------

USE WideWorldImporters;
SELECT 
so.OrderID
,so.OrderDate As OrderDate
,DATENAME (quarter, so.OrderDate) AS Quarter
, CASE 
	WHEN MONTH (so.OrderDate) BETWEEN 1 AND 4 THEN 1
	WHEN MONTH (so.OrderDate) BETWEEN 5 AND 8 THEN 2
	WHEN MONTH (so.OrderDate) BETWEEN 9 AND 12 THEN 3
END as Tertial
, DATENAME (month, so.OrderDate) As Month
, so.ExpectedDeliveryDate as DeliveryDate
FROM  Sales.Orders as so 
LEFT JOIN Sales.OrderLines as sol
	ON sol.OrderID = so.OrderID
WHERE sol.Quantity > 20 OR sol.UnitPrice > 100
ORDER BY Quarter ASC, Tertial ASC, OrderDate ASC;


-- с оффсетом и постраничной выборкой 
DECLARE 
	@pagesize BIGINT = 100,
	@pagenum BIGINT = 10;

USE WideWorldImporters;
SELECT 
so.OrderID
,so.OrderDate As OrderDate
,DATENAME (quarter, so.OrderDate) AS Quarter
, CASE 
	WHEN MONTH (so.OrderDate) BETWEEN 1 AND 4 THEN 1
	WHEN MONTH (so.OrderDate) BETWEEN 5 AND 8 THEN 2
	WHEN MONTH (so.OrderDate) BETWEEN 9 AND 12 THEN 3
END as Tertial
, DATENAME (month, so.OrderDate) As Month
, so.ExpectedDeliveryDate as DeliveryDate
FROM  Sales.Orders as so 
LEFT JOIN Sales.OrderLines as sol
	ON sol.OrderID = so.OrderID
WHERE sol.Quantity > 20 OR sol.UnitPrice > 100
ORDER BY Quarter ASC, Tertial ASC, OrderDate ASC
OFFSET @pagenum * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;

------------------------------------------------------------------------------------
--# 5 добавлено поле с именем клиента
------------------------------------------------------------------------------------

USE WideWorldImporters;
SELECT TOP(10)
si.InvoiceDate as InvoiceDate
, ap.FullName as EmployeeName
, si.InvoiceID
, si.OrderID
, sc.CustomerName as CustomerName
FROM Sales.Invoices as si
LEFT JOIN Application.People as ap
	ON si.SalespersonPersonID = ap.PersonID
LEFT JOIN Sales.Customers as sc
	ON si.CustomerID = sc.CustomerID
ORDER BY InvoiceDate DESC;

---------------------------------------------------------
--6 приведена 2 версия запроса через Sales.OrderLines 
---------------------------------------------------------

USE WideWorldImporters;
SELECT
DISTINCT sc.CustomerID
, sc.CustomerName
, sc.PhoneNumber
FROM Sales.OrderLines as sol
LEFT JOIN Sales.Orders as so
	ON so.OrderID = sol.OrderID
LEFT JOIN Sales.Customers as sc
	ON sc.CustomerID = so.CustomerID
WHERE sol.Description = 'Chocolate frogs 250g'
ORDER BY sc.CustomerID ASC;

-----------------------------------------------------------
