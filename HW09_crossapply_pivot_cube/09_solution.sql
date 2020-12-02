USE WideWorldImporters;
GO

-- monthYear
-- count of orders
/*
1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента  - МесяцГод - Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:  
InvoiceMonth    Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
01.01.2013      3               1                   4           2               2 
01.02.2013      7               3                   4           2               1
*/


WITH PivotData AS (
    SELECT InvoiceMonth
         , CustomerName
         , OrderId
    FROM (SELECT
                FORMAT(o.OrderDate, 'dd.MM.yyyy') as InvoiceMonth
               , substring(c.CustomerName,
                            CHARINDEX('(', c.CustomerName) + 1,
                            CHARINDEX(')', c.CustomerName) - CHARINDEX('(', c.CustomerName) - 1
                ) as CustomerName
               , o.OrderID  as OrderId
          FROM Sales.Orders AS o
                   LEFT JOIN Sales.Customers AS c
                             ON c.CustomerID = o.CustomerID
          WHERE o.CustomerID in (2, 3, 4, 5, 6)
         ) as [IMCIOI]
)
SELECT InvoiceMonth,
--        'Sylvanite, MT', 'Peeples Valley, AZ' , 'Medicine Lodge, KS', 'Gasport, NY', 'Jessie, ND'

       ['Sylvanite, MT'], ['Peeples Valley, AZ'] , ['Medicine Lodge, KS'], ['Gasport, NY'], ['Jessie, ND']
FROM PivotData
    PIVOT (
        COUNT(OrderId)
        FOR CustomerName in (['Sylvanite, MT'], ['Peeples Valley, AZ'] , ['Medicine Lodge, KS'], ['Gasport, NY'], ['Jessie, ND'])

--          FOR CustomerName in ('Sylvanite, MT', 'Peeples Valley, AZ' , 'Medicine Lodge, KS', 'Gasport, NY', 'Jessie, ND')

        )
    AS P;









    SELECT
    FROM (SELECT
                FORMAT(o.OrderDate, 'MM.yyyy') as InvoiceMonth
               , substring(c.CustomerName,
                            CHARINDEX('(', c.CustomerName) + 1,
                            CHARINDEX(')', c.CustomerName) - CHARINDEX('(', c.CustomerName) - 1
                    ) as CustomerName
               , o.OrderID as CountOrders
          FROM Sales.Orders AS o
                   LEFT JOIN Sales.Customers AS c
                             ON c.CustomerID = o.CustomerID
          WHERE o.CustomerID in (2, 3, 4, 5, 6)
         ) as s
    PIVOT (
        COUNT(CountOrders)
        FOR CustomerName in (['Sylvanite, MT'], ['Peeples Valley, AZ'] , ['Medicine Lodge, KS'], ['Gasport, NY'], ['Jessie, ND'])
        )
    AS P;
