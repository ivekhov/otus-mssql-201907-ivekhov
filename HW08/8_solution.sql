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





-- Task #2 calculation with window function.
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

-- ToDo: 3, 4, 5, 6 + their alternatives + bonus






-------------------------------------------------------------
-------------------------------------------------------------
-- how2 format datetime into yyyy--mm-dd? 
-- FORMAT(date from table, pattern'')
