'''
Stocks db contains data on stock markets.
'''
CREATE DATABASE Stocks;
GO

USE Stocks;
GO


'''
Exchanges table:
contain list of world stock exchanges.
'''
-- w\o constraints in create table instruction
CREATE TABLE Exchanges(
	Id INT not null IDENTITY
	, Name NVARCHAR(255)
	, Symbol NVARCHAR(20)
);
-- constraint in separate instruction
ALTER TABLE Exchanges 
	ADD CONSTRAINT PK_Exchanges PRIMARY KEY CLUSTERED(Id);


'''
Indicies table
Contain list of world indices. Many-to-one relation to exchanges.
'''
-- constraints inside create table script
CREATE TABLE WorldIndiñies(
	Id int not null IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
	, ExchangeId int
	, CONSTRAINT PK_WorldIndicies PRIMARY KEY CLUSTERED(Id)
	, CONSTRAINT FK_WorldIndicies_Exchanges FOREIGN KEY (ExchangeId) REFERENCES Exchanges (Id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- creating index
CREATE INDEX IX_Exchange_Name ON Exchanges (Name);
CREATE INDEX IX_WorldIndicies_Symbol ON WorldIndiñies (Symbol);

'''
Data on WorldIndices price dynamic per day
Source: Yahoo Finance: https://finance.yahoo.com/world-indices 
'''
CREATE TABLE WorldIndiciesData(
	Id int NOT NULL IDENTITY
	, WorldIndexId int
	, LastPrice decimal(10, 2)
	, Change decimal(10, 2)
	, ChangePerc decimal(5, 2)
	, Volume bigint
	, IntradayLow decimal(10, 2)
	, IntradayHigh decimal (10, 2)
	, Last52WeekLow decimal (10, 2)
	, Last52WeekHigh decimal (10, 2)
	, TimeOfData datetime2
	, CONSTRAINT PK_WorldIndiciesData PRIMARY KEY CLUSTERED(Id)
	, CONSTRAINT FK_WorldIndiciesData_Catalog FOREIGN KEY (WorldIndexId) REFERENCES WorldIndiñies (Id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- creating index
CREATE INDEX IX_WorldIndiciesData_ChangePerc ON WorldIndiciesData (ChangePerc);

'''
Data on ETF instruments price
Source: Yahoo Finance: https://finance.yahoo.com/etfs
'''
CREATE TABLE EtfCatalogue(
	Id int NOT NULL IDENTITY
	, Name NVARCHAR(50)
	, Symbol NVARCHAR(20)
	, ExchangeId int
	, CONSTRAINT PK_EtfCatalogue PRIMARY KEY CLUSTERED(Id)
	, CONSTRAINT FK_EtfCatalogue_Exchanges FOREIGN KEY (ExchangeId) REFERENCES Exchanges (Id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);
-- creating index
CREATE INDEX IX_EtfCatalogue_Symbol ON EtfCatalogue (Symbol);
