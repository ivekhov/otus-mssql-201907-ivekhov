USE WideWorldImporters;

SET STATISTICS TIME ON;

-- task #1
-- creating temp table with data
DROP TABLE IF EXISTS  #task8_temp_table_v_1;
CREATE TABLE #task8_temp_table_v_1(
	InvoiceID BIGINT PRIMARY KEY
	, CustomerName varchar(255)
	, SalesDate datetime
	, SalesSum decimal
	, SalesMonth VARCHAR(255)
);

INSERT INTO #task8_temp_table_v_1
( 	InvoiceID
	, CustomerName 
	, SalesDate
	, SalesSum
	, SalesMonth
)
SELECT
	si.InvoiceID
	, sc.CustomerName
	, FORMAT(si.InvoiceDate, 'yyyy-MM-dd')
	, sil.ExtendedPrice
	, FORMAT(si.InvoiceDate, 'yyyy-MM')
FROM Sales.Invoices AS si
LEFT JOIN Sales.InvoiceLines AS sil
ON (si.InvoiceID = sil.InvoiceLineID)
LEFT JOIN Sales.Customers AS sc
ON (si.CustomerID = sc.CustomerID)
WHERE YEAR(si.InvoiceDate) >= 2015
;

-- calculation Monthly Sales w\o window function
SELECT
	t.InvoiceID
	, t.CustomerName
	, FORMAT(t.SalesDate, 'yyyy-MM-dd')
	, t.SalesSum
	, m.MonthlySales
FROM #task8_temp_table_v_1 AS t
LEFT JOIN 
	(
		SELECT 
		SalesMonth
		, SUM(SalesSum) AS MonthlySales
		FROM #task8_temp_table_v_1
		GROUP BY SalesMonth
	) AS m
ON (t.SalesMonth = m.SalesMonth)
ORDER BY t.SalesDate;

-- Total execution time: 00:00:03.444
-------------------------------------------------------------


-- creating table variable with data
DECLARE @task8_temp_var_v_1 table (
	InvoiceID BIGINT PRIMARY KEY
	, CustomerName varchar(255)
	, SalesDate datetime
	, SalesSum decimal
	, SalesMonth VARCHAR(255)
);

INSERT INTO @task8_temp_var_v_1
( 	InvoiceID
	, CustomerName 
	, SalesDate
	, SalesSum
	, SalesMonth
)
SELECT
	si.InvoiceID
	, sc.CustomerName
	, FORMAT(si.InvoiceDate, 'yyyy-MM-dd')
	, sil.ExtendedPrice
	, FORMAT(si.InvoiceDate, 'yyyy-MM')
FROM Sales.Invoices AS si
LEFT JOIN Sales.InvoiceLines AS sil
ON (si.InvoiceID = sil.InvoiceLineID)
LEFT JOIN Sales.Customers AS sc
ON (si.CustomerID = sc.CustomerID)
WHERE YEAR(si.InvoiceDate) >= 2015;

-- calculation
SELECT
	t.InvoiceID
	, t.CustomerName
	, FORMAT(t.SalesDate, 'yyyy-MM-dd')
	, t.SalesSum
	, m.MonthlySales
FROM @task8_temp_var_v_1 AS t
LEFT JOIN 
	(
		SELECT 
		SalesMonth
		, SUM(SalesSum) AS MonthlySales
		FROM @task8_temp_var_v_1
		GROUP BY SalesMonth
	) AS m
ON (t.SalesMonth = m.SalesMonth)
ORDER BY t.SalesDate;

-- (with table creation and insertion) Total execution time: 00:04:03.178
-------------------------------------------------------------


-- Task 2 calculation with window function.
SELECT
	InvoiceID
	, CustomerName
	, FORMAT(SalesDate, 'yyyy-MM-dd')
	, SalesSum
	, SUM(SalesSum) OVER (
		PARTITION BY SalesMonth 
	) as MonthlySales
FROM #task8_temp_table_v_1
ORDER BY SalesDate;

-- Total execution time: 00:00:02.681


-- Conclusion: 
-- 1) Window function faster on ~20% than temp tables.
-- 2) temp variables are much slower than window functions and temp tables.
-------------------------------------------------------------

-- Task #3. Вывести список 2х самых популярных продуктов (по кол-ву проданных) каждом месяце  
-- за 2016 год (по 2 самых популярных продукта в каждом месяце)

DROP TABLE IF EXISTS #task8_temp_table_v_3;
CREATE TABLE #task8_temp_table_v_3(
	InvoiceMonth NVARCHAR(10)
	, ProductName NVARCHAR(255)
	, Volume INT
	, RankNumber INT
);

INSERT INTO #task8_temp_table_v_3(
	InvoiceMonth
	, ProductName
	, Volume
	, RankNumber
)
SELECT
	FORMAT(si.InvoiceDate, 'yyyy-MM') AS InvoiceMonth
	, sil.Description AS ProductName
	, SUM(sil.Quantity) AS Volume
	, ROW_NUMBER() OVER (
		PARTITION BY 
			FORMAT(si.InvoiceDate, 'yyyy-MM')
		ORDER BY 
			SUM(sil.Quantity) DESC
		)
FROM Sales.InvoiceLines AS sil
	LEFT JOIN Sales.Invoices AS si
		ON (sil.InvoiceID = si.InvoiceID)
WHERE YEAR(si.InvoiceDate) = 2016
GROUP BY 
	FORMAT(si.InvoiceDate, 'yyyy-MM')
	, sil.Description
ORDER BY InvoiceMonth, Volume  DESC
;

SELECT 
	InvoiceMonth
	, ProductName
	, Volume
	, RankNumber
FROM #task8_temp_table_v_3
WHERE RankNumber < 3
ORDER BY 
	InvoiceMonth
	, RankNumber ASC
;
-------------------------------------------------------------

/*
Task 4. Функции одним запросом
+ Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
+ пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
+ посчитайте общее количество товаров и выведете полем в этом же запросе
+ посчитайте общее количество товаров в зависимости от первой буквы названия товара
+ отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
+ отобразите	предыдущий ид товара с тем же порядком отображения (по имени)
+ отобразите названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
~ сформируйте 30 групп товаров по полю вес товара на 1 шт
*/

SELECT
	StockItemID
	, StockItemName
	, UnitPrice
	, ROW_NUMBER() OVER (
		PARTITION BY LEFT(StockItemName, 1)
		ORDER BY StockItemName ASC
	) AS RowNumberInFirstLetterOfName
	, COUNT(StockItemName) OVER () AS ItemsCount
	, COUNT(StockItemName) OVER (
		PARTITION BY LEFT(StockItemName, 1)
	) AS ItemsCountByFirstLetterofName
	, LEAD(StockItemID) OVER (
		ORDER BY StockItemName ASC
	) AS NextId
	, LAG (StockItemID) OVER (
		ORDER BY StockItemName ASC
	) AS PrevId
	, LAG (StockItemName, 2, 'No Items') OVER (
		ORDER BY StockItemName ASC
	) AS PrevStockItemName
	, TypicalWeightPerUnit

	, NTILE(30) OVER (
		PARTITION BY TypicalWeightPerUnit
		ORDER BY StockItemName
	)
	/*в последнем пунтке непонятна задача, поэтому есть вероятность
	неверного решения*/
FROM Warehouse.StockItems
;
-------------------------------------------------------------


/* Task 5. По каждому сотруднику выведите последнего клиента, которому сотрудник 
что-то продал. В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата 
продажи, сумму сделки. */

-- ToDo
SELECT
	ap.PersonID
	, ap.FullName
	, LAST_VALUE(so.CustomerID) OVER (
		-- PARTITION BY ap.PersonID
		ORDER BY ap.PersonID
	--  ROWs BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS LastClient
	, so.OrderDate
	, so.OrderID
FROM Application.People as ap
LEFT JOIN Sales.Orders as so
	ON so.SalespersonPersonID = ap.PersonID
WHERE ap.IsSalesperson = 1
;
-------------------------------------------------------------


/* Task 5. По каждому сотруднику выведите последнего клиента, которому сотрудник 
что-то продал. В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата 
продажи, сумму сделки. */

---------------------------------
-- teachers example

SELECT 
	Trns.SalespersonPersonID,
	p.FullName,
	Trns.CustomerID,
	c.CustomerName,
	Trns.TransactionDate,
	Trns.TransactionAmount
FROM
(
	SELECT
	i.SalespersonPersonID,
	i.CustomerID,
	tr.TransactionDate,
	tr.TransactionAmount,
	ROW_NUMBER() OVER (PARTITION BY i.SalespersonPersonID ORDER BY tr.TransactionDate DESC) as TrRank -- RANK() или MAX(), если нужны все клиенты за последнюю дату
	FROM Sales.Invoices AS i
	JOIN Sales.CustomerTransactions as tr
		ON i.InvoiceID = tr.InvoiceID
		)  AS Trns

JOIN Sales.Customers AS c
	ON Trns.CustomerID = c.CustomerID
JOIN Application.People AS p
	ON Trns.SalespersonPersonID = p.PersonID
WHERE TrRank = 1
;
---------------------------------


-------------------------------------------------------------
/*6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
 В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки. */

SELECT 
	cp.CustomerID
	, cp.StockItemID
	, cp.OrderDate
	, cp.UnitPrice
	, cp.OrderDate
	, sc.CustomerName
from 
(
	select 
		so.CustomerID
		, sol.StockItemID
		, sol.[Description]
		, sol.UnitPrice
		, so.OrderDate
		, ROW_NUMBER() OVER (
			PARTITION BY so.CustomerID
			ORDER BY Unitprice DESC
		) AS PriceRank
	from Sales.Orders as so
	LEFT JOIN Sales.OrderLines as sol
		ON so.OrderID = sol.OrderID
	LEFT JOIN Sales.Customers as sc
		ON so.CustomerID = sc.CustomerID
) as cp
left join Sales.Customers as sc
	on sc.CustomerID = cp.CustomerID
where PriceRank < 3
;

-------------------------------------------------------------
-------------------------------------------------------------

-- Напишите запрос, который выбирает 10 клиентов, которые сделали больше 30 заказов 
-- и последний заказ 
-- был не позднее апреля 2016.
