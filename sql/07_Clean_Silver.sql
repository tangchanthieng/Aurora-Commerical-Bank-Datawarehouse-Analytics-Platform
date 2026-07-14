USE CommercialBankAnalytics;
GO

-- 1. Load transformed users data from cleaned folder into silver.users_clean
TRUNCATE TABLE silver.users_clean;
INSERT INTO silver.users_clean (
    client_id,
    current_age,
    retirement_age,
    birth_year,
    birth_month,
    gender,
    address,
    latitude,
    longitude,
    per_capita_income,
    yearly_income,
    total_debt,
    credit_score,
    num_credit_cards
)
SELECT 
    TRY_CAST(client_id AS INT),
    TRY_CAST(current_age AS INT),
    TRY_CAST(retirement_age AS INT),
    TRY_CAST(birth_year AS INT),
    TRY_CAST(birth_month AS INT),
    gender,
    address,
    TRY_CAST(latitude AS DECIMAL(10,6)),
    TRY_CAST(longitude AS DECIMAL(10,6)),
    TRY_CAST(per_capita_income AS DECIMAL(18,2)),
    TRY_CAST(yearly_income AS DECIMAL(18,2)),
    TRY_CAST(total_debt AS DECIMAL(18,2)),
    TRY_CAST(credit_score AS INT),
    TRY_CAST(num_credit_cards AS INT)
FROM OPENROWSET(
    BULK N'D:\Personal Projects\Commercial-Banking-Analysis\data\cleaned\clean_users.csv',
    FORMAT='CSV',
    PARSER_VERSION='2.0',
    FIRSTROW=2
) AS t (
    client_id varchar(50),
    current_age varchar(10),
    retirement_age varchar(10),
    birth_year varchar(10),
    birth_month varchar(10),
    gender varchar(50),
    address varchar(255),
    latitude varchar(50),
    longitude varchar(50),
    per_capita_income varchar(50),
    yearly_income varchar(50),
    total_debt varchar(50),
    credit_score varchar(10),
    num_credit_cards varchar(10)
);

-- 2. Load transformed cards data from cleaned folder into silver.cards_clean
TRUNCATE TABLE silver.cards_clean;
INSERT INTO silver.cards_clean (
    card_id,
    client_id,
    card_brand,
    card_type,
    card_number,
    expires,
    cvv,
    has_chip,
    num_cards_issued,
    credit_limit,
    acct_open_date,
    year_pin_last_changed
)
SELECT 
    TRY_CAST(card_id AS INT), 
    TRY_CAST(client_id AS INT), 
    card_brand, 
    card_type, 
    card_number, 
    expires, 
    TRY_CAST(cvv AS INT), 
    has_chip, 
    TRY_CAST(num_cards_issued AS INT), 
    TRY_CAST(credit_limit AS DECIMAL(18,2)), 
    acct_open_date, 
    TRY_CAST(year_pin_last_changed AS INT)
FROM OPENROWSET(
    BULK N'D:\Personal Projects\Commercial-Banking-Analysis\data\cleaned\clean_cards.csv',
    FORMAT='CSV',
    PARSER_VERSION='2.0',
    FIRSTROW=2
) AS t (
    card_id varchar(50),
    client_id varchar(50),
    card_brand varchar(100),
    card_type varchar(100),
    card_number varchar(100),
    expires varchar(20),
    cvv varchar(10),
    has_chip varchar(10),
    num_cards_issued varchar(10),
    credit_limit varchar(50),
    acct_open_date varchar(20),
    year_pin_last_changed varchar(10)
);

-- 3. Load transformed transactions data from cleaned folder into silver.transactions_clean
TRUNCATE TABLE silver.transactions_clean;
INSERT INTO silver.transactions_clean (
    transaction_id,
    date,
    client_id,
    card_id,
    amount,
    use_chip,
    merchant_id,
    merchant_city,
    merchant_state,
    zip,
    mcc_id,
    errors
)
SELECT 
    TRY_CAST(transaction_id AS BIGINT), 
    TRY_CAST(date AS DATETIME), 
    TRY_CAST(client_id AS INT), 
    TRY_CAST(card_id AS INT), 
    TRY_CAST(amount AS DECIMAL(18,2)), 
    use_chip, 
    TRY_CAST(merchant_id AS BIGINT), 
    merchant_city, 
    merchant_state, 
    zip, -- Kept as VARCHAR(20) in Silver schema to preserve leading zeros
    TRY_CAST(mcc_id AS INT), 
    errors
FROM OPENROWSET(
    BULK N'D:\Personal Projects\Commercial-Banking-Analysis\data\cleaned\clean_transactions.csv',
    FORMAT='CSV',
    PARSER_VERSION='2.0',
    FIRSTROW=2
) AS t (
    transaction_id varchar(50),
    date varchar(50),
    client_id varchar(50),
    card_id varchar(50),
    amount varchar(50),
    use_chip varchar(50),
    merchant_id varchar(50),
    merchant_city varchar(100),
    merchant_state varchar(50),
    zip varchar(20),
    mcc_id varchar(50),
    errors varchar(255)
);

-- 4. Load transformed MCC data from cleaned folder into silver.mcc_clean
TRUNCATE TABLE silver.mcc_clean;
INSERT INTO silver.mcc_clean (
    mcc_id,
    Description
)
SELECT 
    TRY_CAST(mcc_id AS INT), 
    Description
FROM OPENROWSET(
    BULK N'D:\Personal Projects\Commercial-Banking-Analysis\data\cleaned\clean_mcc.csv',
    FORMAT='CSV',
    PARSER_VERSION='2.0',
    FIRSTROW=2
) AS t (
    mcc_id varchar(50),
    Description varchar(255)
);
GO