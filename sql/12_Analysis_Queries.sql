USE CommercialBankAnalytics;
GO

-- Customer Analytics
-- 1. Who are the highest-value customers?
SELECT TOP 10
    c.client_id,
    c.gender,
    c.current_age,
    c.yearly_income,
    c.credit_score,
    a.total_spend_volume,
    a.avg_spend_per_transaction,
    a.unique_cards_used
FROM gold.vw_customer_analytics a
JOIN gold.dim_customer c ON c.client_id = a.client_id
ORDER BY a.total_spend_volume DESC;
GO

-- 2. Which age groups spend the most?
SELECT
    CASE
        WHEN current_age < 25 THEN 'Under 25'
        WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
        WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+' 
    END AS age_group,
    COUNT(DISTINCT c.client_id) AS customer_count,
    SUM(t.amount) AS total_spend_volume
FROM gold.dim_customer c
JOIN gold.fact_transactions t ON t.client_id = c.client_id
WHERE t.errors IS NULL
GROUP BY
    CASE
        WHEN current_age < 25 THEN 'Under 25'
        WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
        WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+' 
    END
ORDER BY total_spend_volume DESC;
GO

-- 3. Which customer segments generate the highest revenue?
SELECT
    CASE
        WHEN yearly_income < 50000 THEN 'Low Income'
        WHEN yearly_income BETWEEN 50000 AND 99999 THEN 'Middle Income'
        ELSE 'High Income'
    END AS customer_segment,
    COUNT(DISTINCT c.client_id) AS customer_count,
    SUM(t.amount) AS total_spend_volume
FROM gold.dim_customer c
JOIN gold.fact_transactions t ON t.client_id = c.client_id
WHERE t.errors IS NULL
GROUP BY
    CASE
        WHEN yearly_income < 50000 THEN 'Low Income'
        WHEN yearly_income BETWEEN 50000 AND 99999 THEN 'Middle Income'
        ELSE 'High Income'
    END
ORDER BY total_spend_volume DESC;
GO

-- 4. What is the average customer lifetime value?
SELECT
    AVG(customer_ltv) AS average_customer_ltv
FROM (
    SELECT
        client_id,
        SUM(amount) AS customer_ltv
    FROM gold.fact_transactions
    WHERE errors IS NULL
    GROUP BY client_id
) ltv;
GO

-- Transaction Analytics
-- 5. How many transactions occur each day?
SELECT
    CAST(date AS DATE) AS tx_date,
    COUNT(transaction_id) AS total_transactions
FROM gold.fact_transactions
GROUP BY CAST(date AS DATE)
ORDER BY tx_date;
GO

-- 6. What are the monthly spending trends?
SELECT
    DATEPART(YEAR, date) AS tx_year,
    DATEPART(MONTH, date) AS tx_month,
    COUNT(transaction_id) AS total_transactions,
    SUM(amount) AS total_amount
FROM gold.fact_transactions
WHERE errors IS NULL
GROUP BY DATEPART(YEAR, date), DATEPART(MONTH, date)
ORDER BY tx_year, tx_month;
GO

-- 7. Which transactions contribute most to total revenue?
SELECT TOP 20
    f.transaction_id,
    f.client_id,
    f.card_id,
    f.date,
    m.mcc_id,
    m.Description,
    f.amount
FROM gold.fact_transactions f
JOIN gold.dim_mcc m ON f.mcc_id = m.mcc_id
WHERE f.errors IS NULL
ORDER BY f.amount DESC;
GO

-- 8. Are there unusual transaction patterns?
WITH tx_stats AS (
    SELECT
        transaction_id,
        card_id,
        date,
        amount,
        AVG(amount) OVER (PARTITION BY card_id) AS avg_amount,
        STDEV(amount) OVER (PARTITION BY card_id) AS stddev_amount,
        LAG(date) OVER (PARTITION BY card_id ORDER BY date) AS prev_date,
        LAG(transaction_id) OVER (PARTITION BY card_id ORDER BY date) AS prev_transaction_id
        FROM gold.fact_transactions
)
SELECT
    transaction_id,
    card_id,
    date,
    amount,
    avg_amount,
    stddev_amount,
    CASE
        WHEN stddev_amount IS NULL THEN 'No baseline'
        WHEN amount > avg_amount + (3 * COALESCE(stddev_amount, 0)) THEN 'High-value outlier'
        WHEN prev_date IS NOT NULL
             AND DATEDIFF(SECOND, prev_date, date) <= 60
             AND prev_transaction_id IS NOT NULL
             THEN 'Rapid successive transaction'
        ELSE 'Normal'
    END AS anomaly_flag
FROM tx_stats
ORDER BY date;
GO

-- Card Analytics
-- 9. Which card types are most frequently used?
SELECT TOP 10
    cd.card_type,
    COUNT(t.transaction_id) AS total_transactions,
    COUNT(DISTINCT t.client_id) AS unique_customers
FROM gold.dim_card cd
JOIN gold.fact_transactions t ON t.card_id = cd.card_id
GROUP BY cd.card_type
ORDER BY total_transactions DESC;
GO

-- 10. Which cards generate the highest transaction value?
SELECT TOP 10
    cd.card_id,
    cd.card_type,
    cd.card_brand,
    SUM(t.amount) AS total_amount,
    COUNT(t.transaction_id) AS total_transactions
FROM gold.dim_card cd
JOIN gold.fact_transactions t ON t.card_id = cd.card_id
WHERE t.errors IS NULL
GROUP BY cd.card_id, cd.card_type, cd.card_brand
ORDER BY total_amount DESC;
GO

-- 11. What percentage of customers actively use their cards?
SELECT
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN t.transaction_id IS NOT NULL THEN c.client_id END) / NULLIF(COUNT(DISTINCT c.client_id), 0),
        2
    ) AS active_customer_percentage
FROM gold.dim_customer c
LEFT JOIN gold.fact_transactions t ON t.client_id = c.client_id AND t.errors IS NULL;
GO

-- Merchant Analytics
-- 12. Which Merchant Category Codes generate the highest revenue?
SELECT TOP 10
    m.mcc_id,
    m.Description AS merchant_category,
    SUM(t.amount) AS total_amount,
    COUNT(t.transaction_id) AS total_transactions
FROM gold.fact_transactions t
JOIN gold.dim_mcc m ON m.mcc_id = t.mcc_id
WHERE t.errors IS NULL
GROUP BY m.mcc_id, m.Description
ORDER BY total_amount DESC;
GO

-- 13. Which industries receive the highest spending?
SELECT TOP 10
    m.Description AS industry,
    SUM(t.amount) AS total_spend_volume
FROM gold.fact_transactions t
JOIN gold.dim_mcc m ON m.mcc_id = t.mcc_id
WHERE t.errors IS NULL
GROUP BY m.Description
ORDER BY total_spend_volume DESC;
GO

-- 14. Which merchant categories show the fastest growth?
WITH yearly_revenue AS (
    SELECT
        YEAR(t.date) AS year,
        m.Description,
        SUM(t.amount) AS rev
    FROM gold.fact_transactions t
    JOIN gold.dim_mcc m ON t.mcc_id = m.mcc_id
    GROUP BY YEAR(t.date), m.Description
),
revenue_with_lag AS (
    SELECT 
        year,
        Description,
        rev,
        LAG(rev, 1) OVER (
            PARTITION BY Description 
            ORDER BY year
        ) AS prev_year_rev
    FROM yearly_revenue
)
SELECT
    year,
    Description,
    rev,
    prev_year_rev,
    (rev - prev_year_rev) AS rev_diff,
    -- Calculates growth percentage, multiplying by 100.0 for a percentage value
    -- NULLIF prevents a division-by-zero error if prev_year_rev is 0 or NULL
    ((rev - prev_year_rev) / NULLIF(prev_year_rev, 0)) * 100.0 AS growth_percentage
FROM revenue_with_lag
WHERE prev_year_rev IS NOT NULL
ORDER BY growth_percentage DESC;