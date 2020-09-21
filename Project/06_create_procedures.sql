/*
  Here are the list of some procedures for analytics

  1.1 Get latest price on particular Etf
  1.2 Get price on all Etf for the last available day
  1.3 Daily report with price dynamic on etfs -- find who is growing and who is falling: ToDo

  2.1 Get latest price on particular crypto
  2.2 Get price on all crypto for the last available day
  2.3 Daily report with price dynamic on crypto -- find who is growing and who is falling: ToDo

  3.1 Get latest price on particular currency in RUR
  3.2 Get price on all currency for the last available day
  3.3 Daily report with price dynamic on currency -- find who is growing and who is falling: ToDo


 */

USE Stocks;
GO

-- 1.1) get latest price on particular Etf-product
CREATE PROCEDURE uspGetEtfLastPrice
    @EtfSymbol nvarchar(50)
AS
    SET NOCOUNT ON;
    SELECT E.Symbol, E.Name, EF.LastPrice, EF.LastTime
    FROM Etf as E
    LEFT JOIN EtfFacts EF on E.Id = EF.EtfId
    WHERE E.Symbol = @EtfSymbol
GO
--EXECUTE uspGetEtfLastPrice N'DVEM';

-- 1.2) get data for Etf on last day
DROP PROCEDURE IF EXISTS uspGetEtfPriceOnLastDate

CREATE PROCEDURE uspGetEtfPriceOnLastDate
AS
    SET NOCOUNT ON
    SELECT E.Symbol, E.Name, EF.LastPrice, EF.Volume, FORMAT(EF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM EtfFacts as EF
    LEFT JOIN Etf E on E.Id = EF.EtfId
    WHERE LastTime = (
        SELECT MAX(LastTime)
                      FROM EtfFacts
                   )
    ORDER BY E.Name
GO
-- EXECUTE uspGetEtfPriceOnLastDate;

-- 2.1) Get latest price on particular Crypto
DROP PROCEDURE IF EXISTS uspGetCryptoLastPrice

CREATE PROCEDURE uspGetCryptoLastPrice
    @CryptoSymbol nvarchar(50)
AS
    SET NOCOUNT ON;
    SELECT C.Symbol, C.Name, CF.LastPrice, FORMAT(CF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM Crypto as C
    LEFT JOIN CryptoFacts CF on C.Id = CF.CryptoId
    WHERE C.Symbol = @CryptoSymbol
GO
-- EXECUTE uspGetCryptoLastPrice N'BTC-USD';


-- 2.2 ) get data for crypto on last day
DROP PROCEDURE IF EXISTS uspGetCryptoPriceOnLastDate

CREATE PROCEDURE uspGetCryptoPriceOnLastDate
AS
    SET NOCOUNT ON
    SELECT C.Symbol, C.Name, CF.LastPrice, CF.MarketCap , CF.Supply, FORMAT(CF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM CryptoFacts as CF
    LEFT JOIN Crypto as C on C.Id = CF.CryptoId
    WHERE LastTime = (
        SELECT MAX(LastTime)
                      FROM CryptoFacts
                   )
    ORDER BY CF.LastPrice DESC
GO
-- EXECUTE uspGetCryptoPriceOnLastDate;


-- 3.1) Get latest price on particular currency in RUR
CREATE PROCEDURE uspGetMseCurrencyLastPrice
    @MseCurrencyName nvarchar(50)
AS
    SET NOCOUNT ON;
    SELECT MC.Name, MCF.LastPrice, FORMAT(MCF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM MseCurrencies as MC
    LEFT JOIN MseCurrenciesFacts MCF on MC.Id = MCF.MseCurrencyId
    WHERE MC.Name = @MseCurrencyName
GO
--EXECUTE uspGetMseCurrencyLastPrice N'EURRUB_TOM';


-- 3.2 ) get data for particular currency in RUR on last day
DROP PROCEDURE IF EXISTS uspGetMseCurrencyPriceOnLastDate;

CREATE PROCEDURE uspGetMseCurrencyPriceOnLastDate
AS
    SET NOCOUNT ON
    SELECT MC.Name, MCF.LastPrice, FORMAT(MCF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM MseCurrenciesFacts as MCF
    LEFT JOIN MseCurrencies as MC on MC.Id = MCF.MseCurrencyId
    WHERE LastTime = (
        SELECT MAX(LastTime)
                      FROM MseCurrenciesFacts
                   )
    ORDER BY MC.Name
GO
--EXECUTE uspGetMseCurrencyPriceOnLastDate;


-- 4.1) Get latest price on particular company stocks
CREATE PROCEDURE uspGetCompanyLastPrice
    @CompanyName nvarchar(50)
AS
    SET NOCOUNT ON;
    SELECT C.Name, CF.LastPrice, FORMAT(CF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM Companies as C
    LEFT JOIN CompaniesFacts as CF on C.Id = CF.CompanyId
    WHERE C.Name = @CompanyName
GO
--EXECUTE uspGetCompanyLastPrice N'Kellogg Company';


--4.2) Get latest data on stocks price
CREATE PROCEDURE uspGetCompanyPriceOnLastDate
AS
    SET NOCOUNT ON
    SELECT C.Name, CF.LastPrice, FORMAT(CF.LastTime, 'dd/MM/yyyy') as LastDay
    FROM CompaniesFacts as CF
    LEFT JOIN Companies as C on C.Id = CF.CompanyId
    WHERE LastTime = (
        SELECT MAX(LastTime)
                      FROM CompaniesFacts as CF
                   )
    ORDER BY C.Name
GO
EXECUTE uspGetCompanyPriceOnLastDate;

--------------------------------------