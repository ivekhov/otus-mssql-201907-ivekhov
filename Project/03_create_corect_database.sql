CREATE DATABASE Stocks;
GO

USE Stocks;
GO

CREATE TABLE Exchanges(
	Id BIGINT not null IDENTITY
	, Name NVARCHAR(255)
	, Symbol NVARCHAR(20)
);

CREATE TABLE Indicies(
	Id BIGINT not null IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
);

CREATE TABLE IndiciesFacts(
	Id bigint NOT NULL IDENTITY
	, IndexId int
	, LastPrice decimal(10, 2)
	, LastTime datetime2
);

CREATE TABLE Etf(
	Id int NOT NULL IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
);

CREATE TABLE EtfFacts
(
    Id        bigint NOT NULL IDENTITY,
    EtfId     int,
    LastPrice decimal(10, 2),
    Volume    bigint,
    LastTime  datetime2
);

CREATE TABLE Companies(
	Id bigint NOT NULL IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
    , ExchangeId int
);

CREATE TABLE Currencies(
	Id bigint NOT NULL IDENTITY
	, Name NVARCHAR(50)
);

CREATE TABLE CurrenciesFacts
(
    Id        bigint NOT NULL IDENTITY,
    CurrencyId     bigint,
    LastPrice decimal(10, 2),
    LastTime  datetime2
);

CREATE TABLE MseCurrencies(
    Id bigint NOT NULL IDENTITY
    , Name NVARCHAR(50)
);

CREATE TABLE MseCurrenciesFacts
(
    Id        bigint NOT NULL IDENTITY,
    MseCurrencyId     bigint,
    LastPrice decimal(10, 2),
    LastTime  datetime2
);

CREATE TABLE Crypto(
	Id bigint NOT NULL IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
    , ExchangeId bigint
);

CREATE TABLE CryptoFacts (
    Id bigint NOT NULL IDENTITY
    , CryptoId bigint
    , LastPrice decimal(10, 2)
    , MarketCap bigint
    , Supply bigint
    , LastTime datetime2
);

---------

