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
( 	InvoiceID		--Sales.Invoices.InvoiceID
	, CustomerName	--Sales.Invoices.CustomerID join 
	, SalesDate		--Sales.Invoices.InvoiceDate
	, SalesSum		--Sales.InvoiceLines.ExtendedPrice on InvoiceID
	, SalesMonth	--Sales.Invoices.InvoiceDate
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
( 	InvoiceID		--Sales.Invoices.InvoiceID
	, CustomerName	--Sales.Invoices.CustomerID join 
	, SalesDate		--Sales.Invoices.InvoiceDate
	, SalesSum		--Sales.InvoiceLines.ExtendedPrice on InvoiceID
	, SalesMonth	--Sales.Invoices.InvoiceDate
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


-- Task #1.2 calculation with window function.
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

-- Task #2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) каждом месяце  
-- за 2016 год (по 2 самых популярных продукта в каждом месяце)

-- month
-- product name 
-- (sum of units top(2) )

DROP TABLE IF EXISTS #task8_temp_table_v_2;
CREATE TABLE #task8_temp_table_v_2(
	InvoiceMonth NVARCHAR(10)
	, ProductName NVARCHAR(255)
	, Volume INT
);
INSERT INTO #task8_temp_table_v_2(
	InvoiceMonth
	, ProductName
	, Volume
)
SELECT
	FORMAT(si.InvoiceDate, 'yyyy-MM') AS InvoiceMonth
	, sil.Description AS ProductName
	, SUM(sil.Quantity) AS Volume
FROM Sales.InvoiceLines AS sil
	LEFT JOIN Sales.Invoices AS si
		ON (sil.InvoiceID = si.InvoiceID)
WHERE YEAR(si.InvoiceDate) = 2016
GROUP BY 
	FORMAT(si.InvoiceDate, 'yyyy-MM')
	, sil.Description
ORDER BY InvoiceMonth, Volume  DESC 
;

SELECT *  FROM #task8_temp_table_v_2;


SELECT TOP(100) 
	InvoiceMonth
	, ProductName
	, Volume
	, RANK() OVER (
		PARTITION BY InvoiceMonth, Volume
		ORDER BY InvoiceMonth, Volume
	) 
FROM #task8_temp_table_v_2
ORDER BY InvoiceMonth, Volume;


--ORDER BY Volume;

-- SELECT  
-- 	InvoiceMonth
-- 	, ProductName
-- 	, LAG(Volume) OVER (
-- 		PARTITION BY InvoiceMonth, ProductName
-- 		ORDER BY Volume
-- 		-- ROWS 2 PRECEDING
-- 	)
-- FROM #task8_temp_table_v_2
-- ;

-- ToDo: 2, 3, 4, 5  + their alternatives for 2, 4, 5  + bonus

-------------------------------------------------------------
-------------------------------------------------------------
-- how2 format datetime into yyyy--mm-dd? 
-- FORMAT(date from table, pattern'')


-- 4. Функции одним запросом
-- Посчитайте по таблице товаров, в вывод также должен попасть ид 
-- товара, 
-- название, брэнд и цена
-- пронумеруйте записи по названию товара, так чтобы при изменении 
-- буквы алфавита 
-- нумерация начиналась заново
-- посчитайте общее количество товаров и выведете полем в этом же запросе
-- посчитайте общее количество товаров в зависимости от первой буквы 
-- названия товара
-- отобразите следующий id товара исходя из того, что порядок отображения 
-- товаров по имени
-- предыдущий ид товара с тем же порядком отображения (по имени)
-- названия товара 2 строки назад, в случае если предыдущей строки нет 
-- нужно вывести 
-- "No items"
-- сформируйте 30 групп товаров по полю вес товара на 1 шт
-- Для этой задачи НЕ нужно писать аналог без аналитических функций


-- 5. По каждому сотруднику выведите последнего клиента, которому сотрудник 
-- что-то продал
-- В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата 
-- продажи, сумму сделки


-- 6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
-- В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

-- Опционально можно сделать вариант запросов для заданий 2,4,5 без использования 
-- windows function и 
-- сравнить скорость как в задании 1.

-- Bonus из предыдущей темы
-- Напишите запрос, который выбирает 10 клиентов, которые сделали больше 30 заказов 
-- и последний заказ 
-- был не позднее апреля 2016.