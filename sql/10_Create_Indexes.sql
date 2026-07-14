USE CommercialBankAnalytics;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactTx_Date' AND object_id = OBJECT_ID('gold.fact_transactions'))
    CREATE NONCLUSTERED INDEX IX_FactTx_Date ON gold.fact_transactions([date]) INCLUDE (client_id, card_id, mcc_id, amount, errors);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactTx_Client' AND object_id = OBJECT_ID('gold.fact_transactions'))
    CREATE NONCLUSTERED INDEX IX_FactTx_Client ON gold.fact_transactions(client_id) INCLUDE (amount, card_id, mcc_id, errors);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactTx_Card' AND object_id = OBJECT_ID('gold.fact_transactions'))
    CREATE NONCLUSTERED INDEX IX_FactTx_Card ON gold.fact_transactions(card_id) INCLUDE (client_id, amount, errors);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FactTx_Mcc' AND object_id = OBJECT_ID('gold.fact_transactions'))
    CREATE NONCLUSTERED INDEX IX_FactTx_Mcc ON gold.fact_transactions(mcc_id) INCLUDE (client_id, amount, errors);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimCustomer_Financial' AND object_id = OBJECT_ID('gold.dim_customer'))
    CREATE NONCLUSTERED INDEX IX_DimCustomer_Financial ON gold.dim_customer(credit_score, yearly_income) INCLUDE (total_debt, per_capita_income, num_credit_cards);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DimCard_Client' AND object_id = OBJECT_ID('gold.dim_card'))
    CREATE NONCLUSTERED INDEX IX_DimCard_Client ON gold.dim_card(client_id) INCLUDE (card_type, credit_limit);
GO