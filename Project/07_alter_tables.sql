/*
 Changes in tables: adding ExchangeId field for foreign keys.
 */

USE Stocks;
GO

ALTER TABLE Indicies
ADD ExchangeID bigint;

ALTER  TABLE Currencies
ADD ExchangeId bigint;


ALTER  TABLE MseCurrencies
ADD ExchangeId bigint;

ALTER  TABLE Etf
ADD ExchangeId bigint;
