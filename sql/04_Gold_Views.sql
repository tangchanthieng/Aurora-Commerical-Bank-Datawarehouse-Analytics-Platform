USE DB_Aurora_Bank;
GO

-- ==========================================
-- TRACK 1: MARKETING & PERSONALIZATION
-- ==========================================

-- 1. Customer Profiling
-- High-net-worth definition: Top 10% income or high income + low debt ratio. 
-- Generational definition: Gen Z (born 1997-2012 / age 14-29 in 2026), Middle-aged (age 40-59).
CREATE OR ALTER VIEW gold.vw_customer_profiling AS
WITH ClientSpending AS (
    SELECT 
        client_id,
        SUM(amount) AS total_spending,
        AVG(amount) AS avg_transaction_value
    FROM gold.fact_transactions
    WHERE errors IS NULL OR errors = ''
    GROUP BY client_id
),
RankedIncome AS (
    SELECT 
        client_id,
        NTILE(10) OVER (ORDER BY yearly_income DESC) AS income_percentile
    FROM gold.dim_customer
)
SELECT 
    c.client_id,
    c.current_age,
    c.gender,
    c.yearly_income,
    c.total_debt,
    c.credit_score,
    CASE 
        WHEN ri.income_percentile = 1 THEN 'High-Net-Worth'
        ELSE 'Standard'
    END AS customer_value,
    CASE 
        WHEN c.birth_year BETWEEN 1997 AND 2012 THEN 'Gen Z'
        WHEN c.current_age BETWEEN 40 AND 59 THEN 'Middle-Aged'
        ELSE 'Other'
    END AS age_generation,
    COALESCE(s.total_spending, 0) AS total_spending,
    COALESCE(s.avg_transaction_value, 0) AS avg_transaction_value    
FROM gold.dim_customer c
JOIN ClientSpending s ON c.client_id = s.client_id
JOIN RankedIncome ri ON c.client_id = ri.client_id;
GO

-- 2. Spending Trends (Merchant Analytics)
-- Analyzes spending shares and correlates errors to merchant categories.
CREATE OR ALTER VIEW gold.vw_merchant_spending_trends AS
SELECT 
    m.mcc_id,
    m.Description AS merchant_category,
    SUM(t.amount) AS total_spend,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(CASE WHEN t.errors IS NOT NULL AND t.errors <> '' THEN 1 ELSE 0 END) AS error_count,
    CAST(SUM(CASE WHEN t.errors IS NOT NULL AND t.errors <> '' THEN 1.0 ELSE 0.0 END) / COUNT(t.transaction_id) * 100 AS DECIMAL(5,2)) AS error_rate_percentage
FROM gold.fact_transactions t
JOIN gold.dim_mcc m ON t.mcc_id = m.mcc_id
GROUP BY m.mcc_id, m.Description;
GO

-- 3. Card Usage Optimization
-- Identifies high credit score customers (>700) with low credit card transaction frequencies.
CREATE OR ALTER VIEW gold.vw_card_usage_optimization AS
SELECT 
    c.client_id,
    c.credit_score,
    cd.credit_limit,
    cd.card_type,
    COUNT(t.transaction_id) AS transaction_frequency,
    SUM(t.amount) AS total_spend_amount,
    CASE 
        -- Original Credit logic
        WHEN cd.card_type = 'Credit' 
             AND c.credit_score >= 700 
             AND COUNT(t.transaction_id) < 100 
             AND cd.credit_limit <= 20000 
             THEN 'Target for Credit Limit Increase'
        
        -- New Non-Credit/Debit promotion logic
        WHEN cd.card_type <> 'Credit' 
             AND COUNT(t.transaction_id) < 100 
             AND SUM(t.amount) < 2000 
             THEN 'Promotion/cross-sell needed'
             
        ELSE 'Normal'
    END AS marketing_action
FROM gold.dim_customer c
JOIN gold.dim_card cd ON c.client_id = cd.client_id
JOIN gold.fact_transactions t ON cd.card_id = t.card_id
GROUP BY 
    c.client_id, 
    c.credit_score, 
    cd.credit_limit, 
    cd.card_type;
GO

-- 4. Geographic Segmentation
-- Groups purchasing power metrics based on latitude/longitude regions.
CREATE OR ALTER VIEW gold.vw_geographic_purchasing_power AS
SELECT 
    c.latitude,
    c.longitude,
    COUNT(DISTINCT c.client_id) AS customer_count,
    SUM(t.amount) AS total_spend,
    AVG(t.amount) AS avg_transaction
FROM gold.dim_customer c
JOIN gold.fact_transactions t ON c.client_id = t.client_id
WHERE t.errors IS NULL OR t.errors = ''
GROUP BY c.latitude, c.longitude;
GO

-- 5. High-Potential Customers
-- Filters the top 10% highest income earners with stable transaction volume histories.
CREATE OR ALTER VIEW gold.vw_high_potential_vip AS
WITH CustomerStability AS (
    SELECT 
        client_id,
        COUNT(transaction_id) AS tx_count,
        STDEV(amount) AS spend_volatility
    FROM gold.fact_transactions
    GROUP BY client_id
),
IncomeRanking AS (
    SELECT 
        client_id,
        yearly_income,
        credit_score,
        PERCENT_RANK() OVER (ORDER BY yearly_income DESC) AS income_rank
    FROM gold.dim_customer
)
SELECT 
    ir.client_id,
    ir.yearly_income,
    ir.credit_score,
    cs.tx_count,
    cs.spend_volatility
FROM IncomeRanking ir
JOIN CustomerStability cs ON ir.client_id = cs.client_id
WHERE ir.income_rank <= 0.10 AND cs.tx_count >= 100;
GO


-- ==========================================
-- TRACK 2: RISK MANAGEMENT & CREDIT
-- ==========================================

-- 1. NPL Warning (DTI Analysis)
-- Flags Debt-to-Income ratios above 40% paired with subprime credit profiles.
CREATE OR ALTER VIEW gold.vw_npl_dti_warning AS
SELECT 
    client_id,
    yearly_income,
    total_debt,
    credit_score,
    CASE 
        WHEN yearly_income = 0 THEN 0
        ELSE CAST((CAST(total_debt AS DECIMAL(18,2)) / CAST(yearly_income AS DECIMAL(18,2))) * 100 AS DECIMAL(5,2))
    END AS dti_ratio_percentage,
    CASE 
        WHEN (yearly_income > 0 AND (CAST(total_debt AS DECIMAL(18,2)) / CAST(yearly_income AS DECIMAL(18,2))) > 0.40) 
             AND credit_score < 600 THEN 'CRITICAL ALERT: High DTI & Low Credit'
        WHEN (yearly_income > 0 AND (CAST(total_debt AS DECIMAL(18,2)) / CAST(yearly_income AS DECIMAL(18,2))) > 0.40) THEN 'Warning: High DTI'
        ELSE 'Safe'
    END AS risk_status
FROM gold.dim_customer;
GO

-- 2. Fraud Detection (Fraud Patterns)
-- Pinpoints abnormally high values (3x historical client average) or potential cross-border location mismatches.
CREATE OR ALTER VIEW gold.vw_fraud_detection AS
WITH ClientBaseline AS (
    SELECT 
        client_id
    FROM gold.fact_transactions
    WHERE errors IS NULL OR errors = ''
    GROUP BY client_id
)
SELECT 
    t.transaction_id,
    t.date,
    t.client_id,
    t.amount,
    t.merchant_city,
    t.merchant_state,
    CASE 
        -- 1. Absolute Threshold Flag (> 500)
        WHEN ABS(t.amount) > 1000 THEN 'High Value Absolute Spending Alert'

        -- 2. Anomalously High Amount Spike (relative to baseline)
        WHEN t.amount > 5000 THEN 'Anomalously High Amount Spike'
        
        -- 3. Location Mismatch Flag
        WHEN t.merchant_state <> 'ONLINE' AND (c.latitude IS NOT NULL AND t.merchant_state IS NOT NULL) THEN 'Location Verification Required'
        
        ELSE 'Suspect Pattern'
    END AS fraud_indicator_reason
FROM gold.fact_transactions t
JOIN gold.dim_customer c ON t.client_id = c.client_id
JOIN ClientBaseline cb ON t.client_id = cb.client_id
GO

-- 3. Transaction Errors (Error Code Analysis)
-- Concentrates data surrounding systemic failures per card brand/type combo.
CREATE OR ALTER VIEW gold.vw_transaction_error_analysis AS
SELECT 
    cd.card_brand,
    cd.card_type,
    t.errors AS error_message,
    COUNT(t.transaction_id) AS error_occurrence_count,
    SUM(t.amount) AS disrupted_volume
FROM gold.fact_transactions t
JOIN gold.dim_card cd ON t.card_id = cd.card_id
WHERE t.errors IS NOT NULL AND t.errors <> ''
GROUP BY cd.card_brand, cd.card_type, t.errors;
GO

-- 4. Portfolio Risk Assessment
-- Stratifies customers by standardized FICO tiers to observe credit limits vs overall system risk exposure.
CREATE OR ALTER VIEW gold.vw_portfolio_risk_assessment AS
SELECT 
    CASE 
        WHEN c.credit_score >= 800 THEN 'Exceptional (800-850)'
        WHEN c.credit_score BETWEEN 740 AND 799 THEN 'Very Good (740-799)'
        WHEN c.credit_score BETWEEN 670 AND 739 THEN 'Good (670-739)'
        WHEN c.credit_score BETWEEN 580 AND 669 THEN 'Fair (580-669)'
        ELSE 'Poor (300-579)'
    END AS credit_score_bucket,
    COUNT(DISTINCT c.client_id) AS customer_count,
    SUM(c.total_debt) AS aggregate_outstanding_debt,
    SUM(cd.credit_limit) AS aggregate_granted_limit,
    CAST(SUM(c.total_debt) * 100.0 / NULLIF(SUM(cd.credit_limit), 0) AS DECIMAL(5,2)) AS credit_exposure_ratio_percentage
FROM gold.dim_customer c
JOIN gold.dim_card cd ON c.client_id = cd.client_id
GROUP BY 
    CASE 
        WHEN c.credit_score >= 800 THEN 'Exceptional (800-850)'
        WHEN c.credit_score BETWEEN 740 AND 799 THEN 'Very Good (740-799)'
        WHEN c.credit_score BETWEEN 670 AND 739 THEN 'Good (670-739)'
        WHEN c.credit_score BETWEEN 580 AND 669 THEN 'Fair (580-669)'
        ELSE 'Poor (300-579)'
    END;
GO

-- 5. Strategic Recommendations
-- isolates clean repayment records (zero debt balances) coupled with good credit to trigger manual limit adjustments.
CREATE OR ALTER VIEW gold.vw_strategic_credit_recommendations AS
SELECT 
    c.client_id,
    c.yearly_income,
    c.total_debt,
    c.credit_score,
    cd.card_id,
    cd.credit_limit AS current_limit,
    CAST(cd.credit_limit * 1.25 AS INT) AS recommended_new_limit,
    'Increase Limit 25% - Positive Profile' AS policy_action
FROM gold.dim_customer c
JOIN gold.dim_card cd ON c.client_id = cd.client_id
WHERE c.total_debt = 0 
  AND c.credit_score >= 720 
  AND cd.card_type = 'Credit'
  AND cd.credit_limit != 0;
GO