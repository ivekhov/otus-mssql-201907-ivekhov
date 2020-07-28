USE WideWorldImporters;
GO

-- monthYear
-- count of orders
/*
1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента МесяцГод Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
InvoiceMonth    Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
01.01.2013      3               1                   4           2               2 
01.02.2013      7               3                   4           2               1
*/

-- отдельно определить поименно по идшке покупателя
-- назвать алиасом
-- подцепить в основной запрос по алиасу
-- ? 


-----------------------
-- works but CustomerNames are hard-coded
DECLARE @toys int;
SET @toys = LEN('Tailspin Toys') + 3;
WITH PivotData AS (
SELECT
    FORMAT(so.OrderDate, 'yyyy-MM-dd') as OrderDate
    ,SUBSTRING(sc.CustomerName
                    , CHARINDEX('(', sc.CustomerName)+1
                    , LEN(sc.CustomerName) - @toys
                    ) as ShortName
    , so.OrderID as OrderId
    FROM Sales.Orders as so
    LEFT JOIN Sales.Customers as sc
        ON so.CustomerID = sc.CustomerID
    WHERE so.CustomerID BETWEEN 2 and 6
)
SELECT 
    OrderDate
    , [Gasport, NY]
    , [Jessie, ND]
    , [Medicine Lodge, KS]
    , [Peeples Valley, AZ]
    , [Sylvanite, MT]
FROM PivotData
    PIVOT(COUNT(OrderId)
        FOR ShortName IN (
            [Gasport, NY]
            , [Jessie, ND]
            , [Medicine Lodge, KS]
            , [Peeples Valley, AZ]
            , [Sylvanite, MT]
        )
) AS P
ORDER BY OrderDate ASC;

-----------------------


-- works but too complex (with temp tables) and CustomerNames are hard-coded.
DROP TABLE IF EXISTS #task_1;
DECLARE @toys int;
SET @toys = LEN('Tailspin Toys') + 3;
CREATE TABLE #task_1 (
    Id INT
    , CustomerName NVARCHAR(255)
)
INSERT INTO #task_1(
    Id
    , CustomerName
)
select 
    sc.CustomerID as Id
    ,SUBSTRING(sc.CustomerName
                    , CHARINDEX('(', sc.CustomerName)+1
                    , LEN(sc.CustomerName) - @toys
                    ) 
from Sales.Customers as sc
WHERE sc.CustomerID BETWEEN 2 AND 6;

WITH PivotData AS (
    SELECT
        FORMAT(so.OrderDate, 'yyyy-MM-dd') as OrderDate
        , t.CustomerName
        , so.OrderID as OrderId
        FROM Sales.Orders as so
        LEFT JOIN Sales.Customers as sc
            ON so.CustomerID = sc.CustomerID
        LEFT JOIN #task_1 as t
            ON t.Id = so.CustomerID
        WHERE so.CustomerID BETWEEN 2 and 6
)
SELECT 
    OrderDate
    , [Gasport, NY]
    , [Jessie, ND]
    , [Medicine Lodge, KS]
    , [Peeples Valley, AZ]
    , [Sylvanite, MT]

FROM PivotData
    PIVOT(COUNT(OrderId)
        FOR CustomerName IN (
            [Gasport, NY]
            , [Jessie, ND]
            , [Medicine Lodge, KS]
            , [Peeples Valley, AZ]
            , [Sylvanite, MT]
        )

) AS P
ORDER BY OrderDate ASC;
---------------------



-- works but w/o CustomerNames - inly ID.
DECLARE @toys int;
SET @toys = LEN('Tailspin Toys') + 3;
WITH PivotData AS (
SELECT
    FORMAT(so.OrderDate, 'yyyy-MM-dd') as OrderDate
    , sc.CustomerID as ShortName
    , so.OrderID as OrderId
    FROM Sales.Orders as so
    LEFT JOIN Sales.Customers as sc
        ON so.CustomerID = sc.CustomerID
    WHERE so.CustomerID BETWEEN 2 and 6
)
SELECT OrderDate, [2], [3], [4], [5], [6]
FROM PivotData
    PIVOT(COUNT(OrderId)
        FOR ShortName IN ([2], [3], [4], [5], [6])
) AS P
ORDER BY OrderDate ASC;
---------------------

-- ToDo: put CustomerNames from script, not hard-coding.
-----------------------------------------------------


/*
2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов:
CustomerName                    AddressLine
Tailspin Toys (Head Office)     Shop 38
Tailspin Toys (Head Office)     1877 Mittal Road
Tailspin Toys (Head Office)     PO Box 8975
Tailspin Toys (Head Office)     Ribeiroville
*/

-- steps: 
-- create sample of rows for condition
-- put cross apply condition


-- possible solution (?) new information on task needed. 
SELECT 
    CustomerName
    , a.*
FROM Sales.Customers as sc1
    CROSS APPLY (
        SELECT DISTINCT DeliveryAddressLine1
        FROM Sales.Customers as sc2
        -- WHERE sc1.CustomerID = sc2.CustomerID
    ) AS a
-- WHERE CustomerName LIKE '%Tailspin Toys%'
WHERE CustomerName = 'Tailspin Toys (Head Office)'
ORDER BY CustomerName;



SELECT DeliveryAddressLine1, DeliveryAddressLine2
FROM Sales.Customers
where DeliveryAddressLine2 like '%Ribeiroville%' 
    or DeliveryAddressLine2 like '%PO Box 8975%'
    or DeliveryAddressLine2 like '%1877 Mittal Road%'
    or DeliveryAddressLine1  like '%Ribeiroville%' 
    or DeliveryAddressLine1 like '%PO Box 8975%'
    or DeliveryAddressLine1 like '%1877 Mittal Road%'
;
-- result is one row :Shop 38	1877 Mittal Road



----------------------
-- wrong solution.
SELECT 
    CustomerName
    , DeliveryAddressLine1
FROM Sales.Customers
WHERE CustomerName LIKE '%Tailspin Toys%'
ORDER BY CustomerName;
----------------------
