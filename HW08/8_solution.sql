USE WideWorldImporters;

SET STATISTICS TIME ON;


DROP TABLE IF EXISTS  #task8_temp_table_v_1;
CREATE TABLE #task8_temp_table_v_1(
	InvoiceID BIGINT PRIMARY KEY
	, CustomerName varchar(255)
	, SalesDate datetime
	, SalesSum decimal
	, SalesMonth VARCHAR(255)
	-- , MonthSum decimal
);

INSERT INTO #task8_temp_table_v_1
( 	InvoiceID		--Sales.Invoices.InvoiceID
	, CustomerName	--Sales.Invoices.CustomerID join 
	, SalesDate		--Sales.Invoices.InvoiceDate
	, SalesSum		--Sales.InvoiceLines.ExtendedPrice on InvoiceID
	, SalesMonth		--Sales.Invoices.InvoiceDate
)
SELECT
	si.InvoiceID
	, sc.CustomerName
	, si.InvoiceDate
	, sil.ExtendedPrice
	, FORMAT(si.InvoiceDate, 'yyyy-MM')
FROM Sales.Invoices AS si
LEFT JOIN Sales.InvoiceLines AS sil
ON (si.InvoiceID = sil.InvoiceLineID)
LEFT JOIN Sales.Customers AS sc
ON (si.CustomerID = sc.CustomerID);

SELECT * FROM #task8_temp_table_v_1;
TRUNCATE TABLE #task8_temp_table_v_1;

-- how2 format datetime into yyyy--mm-dd? 
-- FORMAT(date from table, pattern'')

-- ToDo: 1 create select to input in temp table
/*  
SELECT
FROM 
*/

-- ToDo: 2 calculate MonthSum Total 

----------------------------------------
----------------------------------------

SELECT TOP(10) * FROM Sales.Customers;

SELECT TOP(10) * FROM Sales.InvoiceLines; --Extended Price, InvoiceID

SELECT TOP(10) * FROM Sales.Orders;

SELECT TOP(10) * FROM Purchasing.PurchaseOrders;

exec sp_help 'Sales.Invoices';
