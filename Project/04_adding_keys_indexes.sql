/*
 Creating primary keys on existed tables.
 Creating Indexes
 Foreing Indexes

 */



USE Stocks;

-- 1) Adding primary keys and clustered indexes on tables

ALTER TABLE Exchanges
	ADD CONSTRAINT PK_Exchanges PRIMARY KEY CLUSTERED(Id);

ALTER TABLE Indicies
    ADD CONSTRAINT PK_Indicies PRIMARY KEY CLUSTERED (Id);

ALTER TABLE IndiciesFacts
    ADD CONSTRAINT PK_IndiciesFacts PRIMARY KEY CLUSTERED (Id);

ALTER TABLE Etf
    ADD CONSTRAINT PK_Etf PRIMARY KEY CLUSTERED (Id);

ALTER TABLE EtfFacts
    ADD CONSTRAINT PK_EtfFacts PRIMARY KEY CLUSTERED (Id);

ALTER TABLE Companies
    ADD CONSTRAINT PK_Companies PRIMARY KEY NONCLUSTERED (Id);

ALTER TABLE CompaniesFacts
    ADD CONSTRAINT PK_CompaniesFacts PRIMARY KEY CLUSTERED (Id);

ALTER TABLE Crypto
    ADD CONSTRAINT PK_Crypto PRIMARY KEY NONCLUSTERED (Id);

ALTER TABLE CryptoFacts
    ADD CONSTRAINT PK_CryptoFacts PRIMARY KEY CLUSTERED (Id);

ALTER TABLE Currencies
    ADD CONSTRAINT PK_Currencies PRIMARY KEY NONCLUSTERED (Id);

ALTER TABLE CurrenciesFacts
    ADD CONSTRAINT PK_CurrenciesFacts PRIMARY KEY CLUSTERED (Id);

ALTER TABLE MseCurrencies
    ADD CONSTRAINT PK_MseCurrencies PRIMARY KEY NONCLUSTERED (Id);

ALTER TABLE MseCurrenciesFacts
    ADD CONSTRAINT PK_MseCurrenciesFacts PRIMARY KEY NONCLUSTERED (Id);


--2) INDEXES
CREATE NONCLUSTERED INDEX IX_EtfFacts_EtfId  ON EtfFacts(EtfId)

CREATE NONCLUSTERED INDEX IX_IndiciesFacts_IndexId ON
    IndiciesFacts(IndexId);

CREATE CLUSTERED INDEX CIX_Companies_Name ON Companies(Name);

CREATE NONCLUSTERED INDEX IX_CompaniesFacts_CompanyId ON
    CompaniesFacts(CompanyId);

CREATE CLUSTERED INDEX CIX_Crypto_Name ON Crypto(Name);

CREATE NONCLUSTERED INDEX IX_CryptoFacts_CryptoId ON
    CryptoFacts(CryptoId);

CREATE CLUSTERED INDEX CIX_Currencies_Name ON Currencies(Name);

CREATE NONCLUSTERED INDEX IX_CurrenciesFacts_CurrencyId ON
    CurrenciesFacts(CurrencyId);

CREATE NONCLUSTERED INDEX IX_MseCurrenciesFacts_MseCurrencyID ON
    MseCurrenciesFacts(MseCurrencyId);


-- 2) Foreign keys
ALTER TABLE Companies
    ADD CONSTRAINT FK_Companies_Exchanges FOREIGN KEY (ExchangeId) REFERENCES Exchanges(Id);

ALTER TABLE Crypto
    ADD CONSTRAINT FK_Crypto_Exchanges FOREIGN KEY (ExchangeId) REFERENCES Exchanges(Id);

ALTER TABLE  CompaniesFacts
    ADD CONSTRAINT FK_CompaniesFacts_CompaniesId FOREIGN KEY (CompanyId) REFERENCES
    Companies(Id);

ALTER TABLE CryptoFacts
    ADD CONSTRAINT FK_CryptoFacts_CryptoId FOREIGN KEY (CryptoId) REFERENCES Crypto(Id);

ALTER TABLE CurrenciesFacts
    ADD CONSTRAINT FK_CurrenciesFacts_CurrencyId FOREIGN KEY (CurrencyId) REFERENCES Currencies(Id);

ALTER TABLE EtfFacts
    ADD CONSTRAINT FK_EtfFacts_EtfId FOREIGN KEY (EtfId) REFERENCES Etf(Id);

ALTER TABLE IndiciesFacts
    ADD CONSTRAINT FK_IndiciesFacts_IndexId FOREIGN KEY (IndexId) REFERENCES Indicies(Id);

ALTER TABLE MseCurrenciesFacts
    ADD CONSTRAINT FK_MseCurrenciesFacts_IndexId FOREIGN KEY (MseCurrencyId) REFERENCES MseCurrencies(Id);


ALTER TABLE Indicies
    ADD CONSTRAINT FK_Indicies_ExchangeId FOREIGN KEY (ExchangeID) REFERENCES Exchanges(Id);


ALTER TABLE Currencies
    ADD CONSTRAINT FK_Currencies_ExchangeId FOREIGN KEY (ExchangeId) REFERENCES Exchanges(Id);

ALTER TABLE MseCurrencies
    ADD CONSTRAINT FK_MseCurrencies_ExchangeId FOREIGN KEY (ExchangeId) REFERENCES Exchanges(Id);

ALTER TABLE Etf
    ADD CONSTRAINT FK_Etf_ExchangeId FOREIGN KEY (ExchangeId) REFERENCES Exchanges(Id);

