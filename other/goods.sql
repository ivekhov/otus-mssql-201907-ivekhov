/***
Необходимо написать SQL-запрос
  (стандарт ANSI или любой диалект на выбор),
  выводящий
  среднюю стоимость покупки клиентов
  из центрального региона ("Central"),
  совершившим первую покупку в январе 2018 года.
  Результаты предоставить в разбивке по городам.
***/

USE goods;
WITH ClientOrders AS (
    SELECT O.CustomerID
            , O.OrderID
            , MONTH(CONVERT(datetime2, CAST(O.OrderDate AS NVARCHAR), 126)) as Month
            , YEAR(CONVERT(datetime2, CAST(O.OrderDate AS NVARCHAR), 126)) as Year
            , C.CityID
            , CR.Region
            , OL.SKU
            , (OL.Quantity*OL.Price) AS SkuPrice
            , RANK() over (
                    PARTITION BY O.CustomerID
                    ORDER BY MONTH(CONVERT(datetime2, CAST(O.OrderDate AS NVARCHAR), 126)) ASC
                )  AS OrderNumPerClient
    FROM test.Orders AS O
    LEFT JOIN test.Order_List OL on O.OrderID = OL.OrderID
    LEFT JOIN test.Customers C ON C.CustomerID = O.CustomerID
    LEFT JOIN test.City_Region CR on CR.CityID = CAST(C.CityID AS int)
    WHERE O.OrderState = 'Fulfilled' AND C.CityID != 'NULL' AND CR.Region = 'Central'
), SelectedCustomers AS (
    SELECT DISTINCT CO.CustomerID
    FROM ClientOrders AS CO
    WHERE CO.OrderNumPerClient = 1
        AND CO.Month = 1
        AND CO.Year = 2018
)
, CityOrders AS (
SELECT
        CO.CityID
        , CO.OrderID
        , SUM(CO.SkuPrice) as OrderSum
FROM ClientOrders AS CO
    RIGHT JOIN SelectedCustomers AS SC ON SC.CustomerID = CO.CustomerID

GROUP BY CO.CityID, CO.OrderID)


SELECT COD.CityID, AVG(OrderSum)
FROM CityOrders as COD
GROUP BY CityID

;

/***
Answer:
1	19659
2	17325
3	19274
9	19614

  ***/
