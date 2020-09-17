------------------------------------------------------
--1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
------------------------------------------------------

USE WideWorldImporters;

INSERT INTO Sales.Customers
(
	[CustomerID]
      ,[CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
      ,[ValidFrom]
      ,[ValidTo]
)
VALUES 
(
	9990
	, 'John Snow'
	, 9990
	, 3
	, NULL
	, 3261
	, NULL
	, 3
	, 19881
	, 19881
	, 2000
	,'2016-07-05'
	, 0
	, 0
	, 0
	, 7
	, '(206) 555-0100'
	, '(206) 555-0101'
	, NULL
	, NULL
	, 'http://www.microsoft.com/'
	, 'Shop 12'
	, '652 Victoria Lane'
	, 90243
	, 0xE6100000010C11154FE2182D4740159ADA087A035FC0
	, 'PO Box 8112'
	, 'Milicaville'
	, 90243
	, 1
	, DEFAULT
	, DEFAULT
), 
(
	9991
	, 'Daeneris Targarien'
	, 9991
	, 4
	, NULL
	, 3261
	, NULL
	, 3
	, 19882
	, 19882
	, 2100
	,'2016-07-05'
	, 0
	, 0
	, 0
	, 7
	, '(206) 555-0100'
	, '(206) 555-0101'
	, NULL
	, NULL
	, 'http://www.microsoft.com/'
	, 'Shop 12'
	, '652 Victoria Lane'
	, 90243
	, 0xE6100000010C11154FE2182D4740159ADA087A035FC0
	, 'PO Box 8112'
	, 'Milicaville'
	, 90243
	, 1
	, DEFAULT
	, DEFAULT
),
(
	9992
	, 'Bran Snow'
	, 9992
	, 5
	, NULL
	, 3261
	, NULL
	, 3
	, 19883
	, 19883
	, 2200
	,'2016-07-05'
	, 0
	, 0
	, 0
	, 7
	, '(206) 555-0100'
	, '(206) 555-0101'
	, NULL
	, NULL
	, 'http://www.microsoft.com/'
	, 'Shop 12'
	, '652 Victoria Lane'
	, 90243
	, 0xE6100000010C11154FE2182D4740159ADA087A035FC0
	, 'PO Box 8112'
	, 'Milicaville'
	, 90243
	, 1
	, DEFAULT
	, DEFAULT	
),
(
	9993
	, 'Red Lady'
	, 9993
	, 3
	, NULL
	, 3261
	, NULL
	, 3
	, 19884
	, 19884
	, 2300
	,'2016-07-05'
	, 0
	, 0
	, 0
	, 7
	, '(206) 555-0100'
	, '(206) 555-0101'
	, NULL
	, NULL
	, 'http://www.microsoft.com/'
	, 'Shop 12'
	, '652 Victoria Lane'
	, 90243
	, 0xE6100000010C11154FE2182D4740159ADA087A035FC0
	, 'PO Box 8112'
	, 'Milicaville'
	, 90243
	, 1
	, DEFAULT
	, DEFAULT
),
(
	9994
	, 'Serseya Lanister'
	, 9994
	, 2
	, NULL
	, 3261
	, NULL
	, 3
	, 19885
	, 19885
	, 2400
	,'2016-07-05'
	, 0
	, 0
	, 0
	, 7
	, '(206) 555-0100'
	, '(206) 555-0101'
	, NULL
	, NULL
	, 'http://www.microsoft.com/'
	, 'Shop 12'
	, '652 Victoria Lane'
	, 90243
	, 0xE6100000010C11154FE2182D4740159ADA087A035FC0
	, 'PO Box 8112'
	, 'Milicaville'
	, 90243
	, 1
	, DEFAULT
	, DEFAULT
);

--------------------------------------------------------------------
--2. удалите 1 запись из Customers, которая была вами добавлена
--------------------------------------------------------------------

USE WideWorldImporters;
DELETE FROM Sales.Customers 
WHERE CustomerName = 'John Snow';

-- checking
SELECT CustomerName 
FROM Sales.Customers 
WHERE CustomerName like '%John%';

--------------------------------------------------------------------
--3. изменить одну запись, из добавленных через UPDATE
--------------------------------------------------------------------

USE WideWorldImporters;
SELECT StandardDiscountPercentage 
FROM Sales.Customers
WHERE CustomerName like '%Lanister%';


UPDATE Sales.Customers
SET
	StandardDiscountPercentage = 50
WHERE CustomerName like '%Lanister%';


SELECT StandardDiscountPercentage 
FROM Sales.Customers
WHERE CustomerName like '%Lanister%';

--------------------------------------------------------------------
--4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
--------------------------------------------------------------------

USE WideWorldImporters;

DROP TABLE IF EXISTS #my_temp;
CREATE TABLE #my_temp
(

	CustomerID INT
      ,CustomerName NVARCHAR(100)
      ,BillToCustomerID INT
      ,CustomerCategoryID INT
      ,BuyingGroupID INT
      ,PrimaryContactPersonID  INT 
      ,AlternateContactPersonID INT
      ,DeliveryMethodID INT
      ,DeliveryCityID INT
      ,PostalCityID INT
      ,CreditLimit DECIMAL(18, 3)
      ,AccountOpenedDate DATE
      ,StandardDiscountPercentage DECIMAL(18, 3)
      ,IsStatementSent BIT
      ,IsOnCreditHold BIT
      ,PaymentDays INT
      ,PhoneNumber NVARCHAR(20)
      ,FaxNumber NVARCHAR(20)
      ,DeliveryRun NVARCHAR(5)
      ,RunPosition NVARCHAR(5)
      ,WebsiteURL NVARCHAR(256)
      ,DeliveryAddressLine1 NVARCHAR(60)
      ,DeliveryAddressLine2 NVARCHAR(60)
      ,DeliveryPostalCode NVARCHAR(10)
      ,DeliveryLocation GEOGRAPHY
      ,PostalAddressLine1 NVARCHAR(60)
      ,PostalAddressLine2 NVARCHAR(60)
      ,PostalPostalCode NVARCHAR(10)
      ,LastEditedBy INT
      ,ValidFrom DATETIME2(7)
      ,ValidTo DATETIME2(7)

)
INSERT INTO #my_temp
(
      CustomerID
      ,CustomerName
      ,BillToCustomerID
      ,CustomerCategoryID
      ,BuyingGroupID
      ,PrimaryContactPersonID
      ,AlternateContactPersonID
      ,DeliveryMethodID
      ,DeliveryCityID
      ,PostalCityID
      ,CreditLimit
      ,AccountOpenedDate
      ,StandardDiscountPercentage
      ,IsStatementSent
      ,IsOnCreditHold
      ,PaymentDays
      ,PhoneNumber
      ,FaxNumber
      ,DeliveryRun
      ,RunPosition
      ,WebsiteURL
      ,DeliveryAddressLine1
      ,DeliveryAddressLine2
      ,DeliveryPostalCode
      ,DeliveryLocation
      ,PostalAddressLine1
      ,PostalAddressLine2
      ,PostalPostalCode
      ,LastEditedBy
      ,ValidFrom
      ,ValidTo
)

VALUES
(
	9999
	, 'Tirion Lanister'
	, 9999
	, 3
	, NULL
	, 3261
	, NULL
	, 3
	, 19881
	, 19881
	, 2000
	,'2016-07-05'
	, 90
	, 0
	, 0
	, 7
	, '(206) 555-0100'
	, '(206) 555-0101'
	, NULL
	, NULL
	, 'http://www.microsoft.com/'
	, 'Shop 12'
	, '652 Victoria Lane'
	, 90243
	, 0xE6100000010C11154FE2182D4740159ADA087A035FC0
	, 'PO Box 8112'
	, 'Milicaville'
	, 90243
	, 1
	, DEFAULT
	, DEFAULT
)

SELECT * FROM #my_temp;

MERGE Sales.Customers AS target
USING (
	SELECT * FROM #my_temp
) AS source
ON target.CustomerID = source.CustomerID
WHEN MATCHED
	THEN UPDATE SET
				  CustomerID = source.CustomerID
				  ,CustomerName = source.CustomerName
				  ,BillToCustomerID = source.BillToCustomerID
				  ,CustomerCategoryID = source.CustomerCategoryID
				  ,BuyingGroupID = source.BuyingGroupID
				  ,PrimaryContactPersonID = source.PrimaryContactPersonID
				  ,AlternateContactPersonID = source.AlternateContactPersonID
				  ,DeliveryMethodID = source.DeliveryMethodID
				  ,DeliveryCityID = source.DeliveryCityID
				  ,PostalCityID = source.PostalCityID
				  ,CreditLimit = source.CreditLimit
				  ,AccountOpenedDate = source.AccountOpenedDate
				  ,StandardDiscountPercentage = source.StandardDiscountPercentage
				  ,IsStatementSent = source.IsStatementSent
				  ,IsOnCreditHold = source.IsOnCreditHold
				  ,PaymentDays = source.PaymentDays
				  ,PhoneNumber = source.PhoneNumber
				  ,FaxNumber = source.FaxNumber
				  ,DeliveryRun = source.DeliveryRun
				  ,RunPosition = source.RunPosition
				  ,WebsiteURL = source.WebsiteURL
				  ,DeliveryAddressLine1 = source.DeliveryAddressLine1
				  ,DeliveryAddressLine2 = source.DeliveryAddressLine2
				  ,DeliveryPostalCode = source.DeliveryPostalCode
				  ,DeliveryLocation = source.DeliveryLocation
				  ,PostalAddressLine1 = source.PostalAddressLine1
				  ,PostalAddressLine2 = source.PostalAddressLine2
				  ,PostalPostalCode = source.PostalPostalCode
				  ,LastEditedBy = source.LastEditedBy
--				  ,ValidFrom = source.ValidFrom
--				  ,ValidTo = source.ValidTo
WHEN NOT MATCHED 
	THEN INSERT (
				  CustomerID
				  ,CustomerName
				  ,BillToCustomerID
				  ,CustomerCategoryID
				  ,BuyingGroupID
				  ,PrimaryContactPersonID
				  ,AlternateContactPersonID
				  ,DeliveryMethodID
				  ,DeliveryCityID
				  ,PostalCityID
				  ,CreditLimit
				  ,AccountOpenedDate
				  ,StandardDiscountPercentage
				  ,IsStatementSent
				  ,IsOnCreditHold
				  ,PaymentDays
				  ,PhoneNumber
				  ,FaxNumber
				  ,DeliveryRun
				  ,RunPosition
				  ,WebsiteURL
				  ,DeliveryAddressLine1
				  ,DeliveryAddressLine2
				  ,DeliveryPostalCode
				  ,DeliveryLocation
				  ,PostalAddressLine1
				  ,PostalAddressLine2
				  ,PostalPostalCode
				  ,LastEditedBy
--				  ,ValidFrom
--				  ,ValidTo
				)
		VALUES (
				  source.CustomerID
				  ,source.CustomerName
				  ,source.BillToCustomerID
				  ,source.CustomerCategoryID
				  ,source.BuyingGroupID
				  ,source.PrimaryContactPersonID
				  ,source.AlternateContactPersonID
				  ,source.DeliveryMethodID
				  ,source.DeliveryCityID
				  ,source.PostalCityID
				  ,source.CreditLimit
				  ,source.AccountOpenedDate
				  ,source.StandardDiscountPercentage
				  ,source.IsStatementSent
				  ,source.IsOnCreditHold
				  ,source.PaymentDays
				  ,source.PhoneNumber
				  ,source.FaxNumber
				  ,source.DeliveryRun
				  ,source.RunPosition
				  ,source.WebsiteURL
				  ,source.DeliveryAddressLine1
				  ,source.DeliveryAddressLine2
				  ,source.DeliveryPostalCode
				  ,source.DeliveryLocation
				  ,source.PostalAddressLine1
				  ,source.PostalAddressLine2
				  ,source.PostalPostalCode
				  ,source.LastEditedBy
--				  ,source.ValidFrom
--				  ,source.ValidTo
)
;

SELECT * 
FROM Sales.Customers
WHERE CustomerID > 9990;

-----------------------------------------------------------------------------
--5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
-----------------------------------------------------------------------------


USE WideWorldImporters;

/* создаю временную таблицу, куда перемещаю часть данных из рабочей таблицы*/
DROP TABLE IF EXISTS ##my_temp4bulk;
CREATE TABLE ##my_temp4bulk
(
	CustomerID INT
      ,CustomerName NVARCHAR(100)
      ,BillToCustomerID INT
      ,CustomerCategoryID INT
      ,BuyingGroupID INT
      ,PrimaryContactPersonID  INT 
      ,AlternateContactPersonID INT
      ,DeliveryMethodID INT
      ,DeliveryCityID INT
      ,PostalCityID INT
      ,CreditLimit DECIMAL(18, 3)
      ,AccountOpenedDate DATE
      ,StandardDiscountPercentage DECIMAL(18, 3)
      ,IsStatementSent BIT
      ,IsOnCreditHold BIT
      ,PaymentDays INT
      ,PhoneNumber NVARCHAR(20)
      ,FaxNumber NVARCHAR(20)
      ,DeliveryRun NVARCHAR(5)
      ,RunPosition NVARCHAR(5)
      ,WebsiteURL NVARCHAR(256)
      ,DeliveryAddressLine1 NVARCHAR(60)
      ,DeliveryAddressLine2 NVARCHAR(60)
      ,DeliveryPostalCode NVARCHAR(10)
      ,DeliveryLocation GEOGRAPHY
      ,PostalAddressLine1 NVARCHAR(60)
      ,PostalAddressLine2 NVARCHAR(60)
      ,PostalPostalCode NVARCHAR(10)
      ,LastEditedBy INT
)
;


INSERT INTO ##my_temp4bulk
(
      CustomerID
      ,CustomerName
      ,BillToCustomerID
      ,CustomerCategoryID
      ,BuyingGroupID
      ,PrimaryContactPersonID
      ,AlternateContactPersonID
      ,DeliveryMethodID
      ,DeliveryCityID
      ,PostalCityID
      ,CreditLimit
      ,AccountOpenedDate
      ,StandardDiscountPercentage
      ,IsStatementSent
      ,IsOnCreditHold
      ,PaymentDays
      ,PhoneNumber
      ,FaxNumber
      ,DeliveryRun
      ,RunPosition
      ,WebsiteURL
      ,DeliveryAddressLine1
      ,DeliveryAddressLine2
      ,DeliveryPostalCode
      ,DeliveryLocation
      ,PostalAddressLine1
      ,PostalAddressLine2
      ,PostalPostalCode
      ,LastEditedBy
)
SELECT 
		CustomerID
		,CustomerName
		,BillToCustomerID
		,CustomerCategoryID
		,BuyingGroupID
		,PrimaryContactPersonID
		,AlternateContactPersonID
		,DeliveryMethodID
		,DeliveryCityID
		,PostalCityID
		,CreditLimit
		,AccountOpenedDate
		,StandardDiscountPercentage
		,IsStatementSent
		,IsOnCreditHold
		,PaymentDays
		,PhoneNumber
		,FaxNumber
		,DeliveryRun
		,RunPosition
		,WebsiteURL
		,DeliveryAddressLine1
		,DeliveryAddressLine2
		,DeliveryPostalCode
		,DeliveryLocation
		,PostalAddressLine1
		,PostalAddressLine2
		,PostalPostalCode
		,LastEditedBy
FROM Sales.Customers
;

/* настройки для утилиты */
EXEC sp_configure 'show advanced options', 1;  
GO  

EXEC sp_configure 'xp_cmdshell', 1;  
GO  

RECONFIGURE;  
GO  

/* выгрузка данных */
exec master..xp_cmdshell 'bcp  "[##my_temp4bulk]" out "C:\Users\ivan\Work\sql\Temp4Bulk.csv" -T -w -t, -S DESKTOP-43EBNMR\SQL2017'

/* создаю таблицу, куда загружаются данные из файла */
DROP TABLE IF EXISTS #Temp4Bulk --#my_temp_bulk;
CREATE TABLE #Temp4Bulk
(
	CustomerID INT
      ,CustomerName NVARCHAR(100)
      ,BillToCustomerID INT
      ,CustomerCategoryID INT
      ,BuyingGroupID INT
      ,PrimaryContactPersonID  INT 
      ,AlternateContactPersonID INT
      ,DeliveryMethodID INT
      ,DeliveryCityID INT
      ,PostalCityID INT
      ,CreditLimit DECIMAL(18, 3)
      ,AccountOpenedDate DATE
      ,StandardDiscountPercentage DECIMAL(18, 3)
      ,IsStatementSent BIT
      ,IsOnCreditHold BIT
      ,PaymentDays INT
      ,PhoneNumber NVARCHAR(20)
      ,FaxNumber NVARCHAR(20)
      ,DeliveryRun NVARCHAR(5)
      ,RunPosition NVARCHAR(5)
      ,WebsiteURL NVARCHAR(256)
      ,DeliveryAddressLine1 NVARCHAR(60)
      ,DeliveryAddressLine2 NVARCHAR(60)
      ,DeliveryPostalCode NVARCHAR(10)
      ,DeliveryLocation GEOGRAPHY
      ,PostalAddressLine1 NVARCHAR(60)
      ,PostalAddressLine2 NVARCHAR(60)
      ,PostalPostalCode NVARCHAR(10)
      ,LastEditedBy INT
--      ,ValidFrom DATETIME2(7)
--      ,ValidTo DATETIME2(7)
)

/* загружаю данные в конечную таблицу*/
USE WideWorldImporters;
BULK INSERT #Temp4Bulk 
FROM "C:\Users\ivan\Work\sql\Temp4Bulk.csv" 
WITH 
(
	FIRSTROW = 1,
	BATCHSIZE = 1000, 
	DATAFILETYPE = 'widechar',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\r\n'
	,KEEPNULLS
	,TABLOCK   
)

/* проверка */
SELECT  * FROM #Temp4Bulk;
