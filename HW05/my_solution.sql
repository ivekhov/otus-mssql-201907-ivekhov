----------------------------------------------------------------------------
-- Домашнее задание Группировки и агрегатные функции
-- 1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
----------------------------------------------------------------------------

USE WideWorldImporters;

SELECT 
DATENAME (year, so.OrderDate) AS YearOfOrder
,MONTH(so.OrderDate) AS MonthNum
,DATENAME (month, so.OrderDate) AS MonthOfOrder
,CONCAT(
		DATENAME (year, so.OrderDate)
		, ' '
		, DATENAME (month, so.OrderDate) ) AS YearMonth
,SUM(sol.Quantity * sol.UnitPrice) AS GrossSales
,AVG(sol.UnitPrice) AS AveragePrice
FROM Sales.OrderLines AS sol
LEFT JOIN Sales.Orders AS so
	ON sol.OrderID = so.OrderID
GROUP BY 
DATENAME (year, so.OrderDate) 
, MONTH(so.OrderDate)
,DATENAME (month, so.OrderDate)
ORDER BY 
DATENAME (year, so.OrderDate) ASC
,MONTH(so.OrderDate) ASC
,DATENAME (month, so.OrderDate) 
;
GO

------------------------------------------------------------
-- 1 Модификация запроса 1.2. добавлено поле продукта.
------------------------------------------------------------
USE WideWorldImporters;

SELECT 
DATENAME (year, so.OrderDate) AS YearOfOrder
,MONTH(so.OrderDate) AS MonthNum
,DATENAME (month, so.OrderDate) AS MonthOfOrder
,CONCAT(
		DATENAME (year, so.OrderDate)
		, ' '
		, DATENAME (month, so.OrderDate) ) AS YearMonth
, sol.Description AS Product
,SUM(sol.Quantity * sol.UnitPrice) AS GrossSales
,AVG(sol.UnitPrice) AS AveragePrice
FROM Sales.OrderLines AS sol
LEFT JOIN Sales.Orders AS so
	ON sol.OrderID = so.OrderID
GROUP BY 
DATENAME (year, so.OrderDate) 
,MONTH(so.OrderDate)
,DATENAME (month, so.OrderDate)
,sol.Description 
ORDER BY 
DATENAME (year, so.OrderDate) ASC
,MONTH(so.OrderDate) ASC
,SUM(sol.Quantity * sol.UnitPrice) DESC
;
GO

---------------------------------------------------------------------
-- 2. Отобразить все месяцы, где общая сумма продаж превысила 10 000 
---------------------------------------------------------------------

USE WideWorldImporters;

SELECT 
DATENAME (year, so.OrderDate) AS YearOfOrder
,MONTH(so.OrderDate) AS MonthNum
,DATENAME (month, so.OrderDate) AS MonthOfOrder
,CONCAT(
		DATENAME (year, so.OrderDate)
		, ' '
		, DATENAME (month, so.OrderDate) ) AS YearMonth
,SUM(sol.Quantity * sol.UnitPrice) AS GrossSales
,AVG(sol.UnitPrice) AS AveragePrice
FROM Sales.OrderLines AS sol
LEFT JOIN Sales.Orders AS so
	ON sol.OrderID = so.OrderID
GROUP BY 
DATENAME (year, so.OrderDate) 
, MONTH(so.OrderDate)
,DATENAME (month, so.OrderDate)
HAVING SUM(sol.Quantity * sol.UnitPrice) > 10000
ORDER BY 
DATENAME (year, so.OrderDate) ASC
,MONTH(so.OrderDate) ASC
,DATENAME (month, so.OrderDate) 
;
GO

------------------------------------------------------------
-- 2 Модификация запроса 2.2: добавлено поле продукта в таблицу
------------------------------------------------------------

USE WideWorldImporters;

SELECT 
DATENAME (year, so.OrderDate) AS YearOfOrder
,MONTH(so.OrderDate) AS MonthNum
,DATENAME (month, so.OrderDate) AS MonthOfOrder
,CONCAT(
		DATENAME (year, so.OrderDate)
		, ' '
		, DATENAME (month, so.OrderDate) ) AS YearMonth
, sol.Description AS Product
,SUM(sol.Quantity * sol.UnitPrice) AS GrossSales
,AVG(sol.UnitPrice) AS AveragePrice
FROM Sales.OrderLines AS sol
LEFT JOIN Sales.Orders AS so
	ON sol.OrderID = so.OrderID
GROUP BY 
DATENAME (year, so.OrderDate) 
,MONTH(so.OrderDate)
,DATENAME (month, so.OrderDate)
,sol.Description 
HAVING SUM(sol.Quantity * sol.UnitPrice) > 10000
ORDER BY 
DATENAME (year, so.OrderDate) ASC
,MONTH(so.OrderDate) ASC
,SUM(sol.Quantity * sol.UnitPrice) DESC
;
GO

---------------------------------------------------------------
/*
3. Вывести сумму продаж,  дату первой продажи и 
количество проданного по месяцам, по товарам, 
продажи которых менее 50 ед в месяц. 
Группировка должна быть по году и месяцу.
*/
---------------------------------------------------------------

USE WideWorldImporters;
WITH FirstOrderDate AS 
(
	SELECT 
		sol.Description AS Product
		,MIN(so.OrderDate) AS FirstOrderDate
	FROM Sales.OrderLines AS sol
	LEFT JOIN Sales.Orders AS so
		ON sol.OrderID = so.OrderID
	GROUP BY sol.Description
)
SELECT 
	DATENAME (year, so.OrderDate) AS YearOfOrder
	,MONTH(so.OrderDate) AS MonthNum
	,DATENAME (month, so.OrderDate) AS MonthOfOrder
	,CONCAT(
			DATENAME (year, so.OrderDate)
			, ' '
			, DATENAME (month, so.OrderDate) ) AS YearMonth
	,sol.Description AS Product
	,fod.FirstOrderDate
	,SUM(sol.Quantity * sol.UnitPrice) AS GrossSales
	,SUM(sol.Quantity) AS GrossQuantity
FROM Sales.OrderLines AS sol
LEFT JOIN Sales.Orders AS so
	ON sol.OrderID = so.OrderID
LEFT JOIN FirstOrderDate AS fod
	ON fod.Product = sol.Description
GROUP BY 
	DATENAME (year, so.OrderDate) 
	,MONTH(so.OrderDate)
	,DATENAME (month, so.OrderDate)
	,sol.Description
	,fod.FirstOrderDate
HAVING SUM(sol.Quantity) >= 50
ORDER BY 
	DATENAME (year, so.OrderDate) ASC
	,MONTH(so.OrderDate) ASC
	,SUM(sol.Quantity * sol.UnitPrice) DESC
;
GO

-----------------------------------------------------------------------
/*
4. Написать рекурсивный CTE sql запрос 
и заполнить им временную таблицу и табличную переменную
*/
-----------------------------------------------------------------------

USE WideWorldImporters;
CREATE TABLE dbo.MyEmployees 
( 
	EmployeeID smallint NOT NULL, 
	FirstName nvarchar(30) NOT NULL, 
	LastName nvarchar(40) NOT NULL, 
	Title nvarchar(50) NOT NULL, 
	DeptID smallint NOT NULL, 
	ManagerID int NULL, 
	CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
); 
INSERT INTO dbo.MyEmployees VALUES 
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 

-- temp table
CREATE TABLE #my_table_2
(
	EmployeeID smallint NOT NULL, 
	FirstName nvarchar(30) NOT NULL, 
	LastName nvarchar(40) NOT NULL, 
	Title nvarchar(50) NOT NULL, 
	DeptID smallint NOT NULL, 
	ManagerID int NULL, 
	CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);

WITH CTE AS 
(
	SELECT 
		EmployeeID
		, CONCAT(MyEmployees.FirstName, ' ', MyEmployees.LastName) AS EmplName
		, Title
		, 1 AS EmployeeLevel
	FROM MyEmployees
	WHERE ManagerID IS NULL
	UNION ALL

	SELECT 
		me.EmployeeID
		, CONCAT(me.FirstName, ' ', me.LastName) AS EmplName
		, me.Title
		, mycte.EmployeeLevel + 1 AS EmployeeLevel
	FROM CTE AS mycte
		JOIN MyEmployees AS me
			ON mycte.EmployeeID = me.ManagerID
)
SELECT * INTO #my_table_2
FROM CTE;


-- table variable

DECLARE @my_table_var TABLE 
(
	EmployeeID smallint NOT NULL, 
	FirstName nvarchar(30) NOT NULL, 
	LastName nvarchar(40) NOT NULL, 
	Title nvarchar(50) NOT NULL, 
	DeptID smallint NOT NULL, 
	ManagerID int NULL
	--,CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);

WITH CTE AS 
(
	SELECT 
		EmployeeID
		, CONCAT(MyEmployees.FirstName, ' ', MyEmployees.LastName) AS EmplName
		, Title
		, 1 AS EmployeeLevel
	FROM MyEmployees
	WHERE ManagerID IS NULL
	UNION ALL

	SELECT 
		me.EmployeeID
		, CONCAT(me.FirstName, ' ', me.LastName) AS EmplName
		, me.Title
		, mycte.EmployeeLevel + 1 AS EmployeeLevel
	FROM CTE AS mycte
		JOIN MyEmployees AS me
			ON mycte.EmployeeID = me.ManagerID
)
SELECT * INTO my_table_var
FROM CTE;

-----------------------------------------------------------------------
