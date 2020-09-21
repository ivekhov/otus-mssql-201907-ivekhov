-- Stocks db contains data on stock markets. #1
CREATE DATABASE Stocks;
GO

USE Stocks;
GO

-- Creating tables with primary and foreign keys #2-3
-- #1 Exchanges table:
-- contain list of world stock exchanges.

-- w\o constraints in create table instruction
CREATE TABLE Exchanges(
	Id INT not null IDENTITY
	, Name NVARCHAR(255)
	, Symbol NVARCHAR(20)
);
-- constraint in separate instruction
ALTER TABLE Exchanges 
	ADD CONSTRAINT PK_Exchanges PRIMARY KEY CLUSTERED(Id);


-- #2 Indicies table
-- Contain list of world indices. Many-to-one relation to exchanges.

-- constraints inside create table script
CREATE TABLE Indicies(
	Id int not null IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
	, ExchangeId int
	, CONSTRAINT PK_Indicies PRIMARY KEY CLUSTERED(Id)
	, CONSTRAINT FK_Indicies_Exchanges FOREIGN KEY (ExchangeId) REFERENCES Exchanges (Id)
);

-- #3 Data on WorldIndices price dynamic per day
-- Source: Yahoo Finance: https://finance.yahoo.com/world-indices 
CREATE TABLE IndiciesData(
	Id int NOT NULL IDENTITY
	, IndexId int
	, LastPrice decimal(10, 2)
	, Change decimal(10, 2)
	, ChangePerc decimal(5, 2)
	, Volume bigint
	, IntradayLow decimal(10, 2)
	, IntradayHigh decimal (10, 2)
	, Last52WeekLow decimal (10, 2)
	, Last52WeekHigh decimal (10, 2)
	, TimeOfData datetime2
	, CONSTRAINT PK_IndiciesData PRIMARY KEY CLUSTERED(Id)
	, CONSTRAINT FK_IndiciesData_Catalog FOREIGN KEY (IndexId) REFERENCES Indicies (Id)
);


-- #4 Data on ETF instruments price
-- Source: Yahoo Finance: https://finance.yahoo.com/etfs
CREATE TABLE EtfCatalogue(
	Id int NOT NULL IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
	, ExchangeId int
	, CONSTRAINT PK_EtfCatalogue PRIMARY KEY CLUSTERED(Id)
	, CONSTRAINT FK_EtfCatalogue_Exchanges FOREIGN KEY (ExchangeId) REFERENCES Exchanges (Id)
);

-- creating indexes #4
CREATE INDEX IX_Exchange_Name ON Exchanges (Name);
CREATE INDEX IX_Indicies_Symbol ON Indicies (Symbol);
CREATE INDEX IX_IndiciesData_ChangePerc ON IndiciesData (ChangePerc);
CREATE INDEX IX_EtfCatalogue_Symbol ON EtfCatalogue (Symbol);


-- adding constraint on data input #5
ALTER TABLE Exchanges WITH CHECK
	ADD CONSTRAINT CHK_Exchanges_Symbol
	CHECK (LEN(Symbol) > 2);

ALTER TABLE Indicies WITH CHECK
	ADD CONSTRAINT CHK_Indicies_Symbol
	CHECK (LEN(Symbol) > 2);

ALTER TABLE IndiciesData WITH CHECK
	ADD CONSTRAINT CHK_IndiciesData_LastPrice
	CHECK (LastPrice >= 0);

ALTER TABLE EtfCatalogue WITH CHECK
	ADD CONSTRAINT CHK_EtfCatalogue_Symbol
	CHECK (LEN(Symbol) > 2);

----------------------------------------------------
