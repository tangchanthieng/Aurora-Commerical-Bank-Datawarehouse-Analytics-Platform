USE CommercialBankAnalytics;
GO

-- 1. Customer Analytics: highest-value customers, age groups, segments, and lifetime value
CREATE OR ALTER VIEW gold.vw_customer_analytics AS
SELECT
    c.client_id,
    c.gender,
    c.current_age,
    c.retirement_age,
    c.address,
    c.yearly_income,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_spend_volume,
    SUM(CASE WHEN t.errors IS NOT NULL THEN 1 ELSE 0 END) AS transaction_errors_count,
    COUNT(DISTINCT t.card_id) AS unique_cards_used,
    CASE WHEN COUNT(t.transaction_id) = 0 THEN 0 ELSE SUM(t.amount) / COUNT(t.transaction_id) END AS avg_spend_per_transaction
FROM gold.dim_customer c
INNER JOIN gold.fact_transactions t ON c.client_id = t.client_id
GROUP BY c.client_id, c.gender, c.current_age, c.retirement_age, c.address, c.yearly_income;
GO

-- 2. Customer Financial Profile: affordability and credit health indicators
CREATE OR ALTER VIEW gold.vw_customer_financial_profile AS
SELECT
    c.client_id,
    c.credit_score,
    CASE
        WHEN c.yearly_income IS NULL OR c.yearly_income = 0 THEN NULL
        ELSE ROUND(c.total_debt / c.yearly_income, 4)
    END AS debt_to_income,
    c.yearly_income,
    c.per_capita_income,
    c.total_debt,
    c.num_credit_cards,
    CASE
        WHEN c.yearly_income IS NULL OR c.yearly_income = 0 THEN NULL
        ELSE ROUND(c.yearly_income / NULLIF(c.num_credit_cards, 0), 2)
    END AS income_per_card
FROM gold.dim_customer c;
GO

-- 3. Transaction Analytics: daily volume, monthly trend, revenue, and quality metrics
CREATE OR ALTER VIEW gold.vw_transaction_analytics AS
SELECT
    CAST(t.date AS DATE) AS tx_date,
    DATEPART(YEAR, t.date) AS tx_year,
    DATEPART(MONTH, t.date) AS tx_month,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_amount,
    AVG(t.amount) AS average_transaction_amount,
    SUM(CASE WHEN t.errors IS NOT NULL THEN 1 ELSE 0 END) AS error_transactions,
    SUM(CASE WHEN t.errors IS NULL THEN 1 ELSE 0 END) AS valid_transactions
FROM gold.fact_transactions t
GROUP BY CAST(t.date AS DATE), DATEPART(YEAR, t.date), DATEPART(MONTH, t.date);
GO

-- 4. Card Analytics: card usage frequency, spend value, and active card percentage
CREATE OR ALTER VIEW gold.vw_card_utilization_metrics AS
SELECT
    cd.card_id,
    cd.card_brand,
    cd.card_type,
    cd.credit_limit,
    COUNT(t.transaction_id) AS total_transactions,
    COALESCE(SUM(t.amount), 0) AS total_amount,
    CASE
        WHEN cd.credit_limit = 0 OR cd.credit_limit IS NULL THEN 0
        ELSE (COALESCE(SUM(t.amount), 0) / cd.credit_limit) * 100
    END AS usage_percentage,
    CASE WHEN COUNT(t.transaction_id) > 0 THEN 1 ELSE 0 END AS is_active_card
FROM gold.dim_card cd
JOIN gold.fact_transactions t ON cd.card_id = t.card_id AND t.errors IS NULL
GROUP BY cd.card_id, cd.card_brand, cd.card_type, cd.credit_limit;
GO

-- 5. Merchant Analytics: merchant categories with highest revenue and growth signals
CREATE OR ALTER VIEW gold.vw_merchant_revenue_metrics AS
SELECT
    m.mcc_id,
    m.Description AS merchant_category,
    DATEPART(YEAR, t.date) AS tx_year,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_amount,
    AVG(t.amount) AS average_transaction_amount,
    COUNT(DISTINCT t.card_id) AS distinct_cards_used
FROM gold.fact_transactions t
JOIN gold.dim_mcc m ON t.mcc_id = m.mcc_id
WHERE t.errors IS NULL
GROUP BY m.mcc_id, m.Description, DATEPART(YEAR, t.date);
GO