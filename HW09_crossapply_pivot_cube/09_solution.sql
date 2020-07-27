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
ClienName           InvoiceMonth    Count 
Peeples Valley,     01.01.2013      1
AZ Medicine Lodge,  01.01.2013      2
KS Gasport,         01.01.2013      3
NY Sylvanite,       01.02.2013      4
MT Jessie,          01.02.2013      5
ND                  01.02.2013      6
*/

select top(5) * from Sales.Orders;


WITH PivotData AS (

    SELECT 
        so.CustomerID
        , so.OrderDate
        , sc.CustomerName
        , so.OrderID
        , SUBSTRING(sc.CustomerName
                    , CHARINDEX('(', sc.CustomerName)+1
                    , LEN(sc.CustomerName)
                    -- , CHARINDEX(')', sc.CustomerName)
                    )
        FROM Sales.Orders as so
        LEFT JOIN Sales.Customers as sc
            ON so.CustomerID = sc.CustomerID
        WHERE so.CustomerID BETWEEN 2 and 6

)

