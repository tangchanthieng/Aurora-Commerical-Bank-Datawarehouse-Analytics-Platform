-- Create bronze tables
USE DB_Aurora_Bank;
GO

CREATE TABLE bronze.users_raw (
    client_id VARCHAR(50), 
    current_age VARCHAR(10), 
    retirement_age VARCHAR(10),
    birth_year VARCHAR(10), 
    birth_month VARCHAR(10), 
    gender VARCHAR(10),
    address VARCHAR(255), 
    latitude VARCHAR(50), 
    longitude VARCHAR(50),
    per_capita_income VARCHAR(20), 
    yearly_income VARCHAR(20), 
    total_debt VARCHAR(20),
    credit_score VARCHAR(10), 
    num_credit_cards VARCHAR(10)
);

CREATE TABLE bronze.cards_raw (
    card_id VARCHAR(50), 
    client_id VARCHAR(50), 
    card_brand VARCHAR(100),
    card_type VARCHAR(100), 
    card_number VARCHAR(100), 
    expires VARCHAR(10), 
    cvv VARCHAR(10), 
    has_chip VARCHAR(10), 
    num_cards_issued VARCHAR(10),
    credit_limit VARCHAR(20), 
    acct_open_date VARCHAR(10), 
    year_pin_last_changed VARCHAR(10)
);

CREATE TABLE bronze.transactions_raw (
    transaction_id VARCHAR(50), 
    date VARCHAR(10), 
    client_id VARCHAR(50),
    card_id VARCHAR(50), 
    amount VARCHAR(20), 
    use_chip VARCHAR(10),
    merchant_id VARCHAR(50), 
    merchant_city VARCHAR(100), 
    merchant_state VARCHAR(100),
    zip VARCHAR(10), 
    mcc_id VARCHAR(10), 
    errors VARCHAR(255)
);

CREATE TABLE bronze.mcc_raw (
    mcc_id VARCHAR(10),
    Description VARCHAR(255)
);
GO

-- Create silver tables
USE DB_Aurora_Bank;
GO

CREATE TABLE silver.users_clean (
    client_id INT PRIMARY KEY, 
    current_age INT, 
    retirement_age INT,
    birth_year INT, 
    birth_month INT, 
    gender VARCHAR(50), 
    address VARCHAR(255),
    latitude DECIMAL(10,6), 
    longitude DECIMAL(10,6), 
    per_capita_income DECIMAL(18,2),
    yearly_income DECIMAL(18,2), 
    total_debt DECIMAL(18,2), 
    credit_score INT, 
    num_credit_cards INT
);

CREATE TABLE silver.cards_clean (
    card_id INT PRIMARY KEY, 
    client_id INT, 
    card_brand VARCHAR(50),
    card_type VARCHAR(50), 
    card_number VARCHAR(50), 
    expires VARCHAR(20),
    cvv INT, 
    has_chip VARCHAR(10), 
    num_cards_issued INT, 
    credit_limit DECIMAL(18,2),
    acct_open_date VARCHAR(20), 
    year_pin_last_changed INT
);

CREATE TABLE silver.transactions_clean (
    transaction_id BIGINT PRIMARY KEY, 
    date DATETIME, 
    client_id INT,
    card_id INT, 
    amount DECIMAL(18,2), 
    use_chip VARCHAR(50), 
    merchant_id BIGINT,
    merchant_city VARCHAR(100), 
    merchant_state VARCHAR(50), 
    zip VARCHAR(20),
    mcc_id INT, 
    errors VARCHAR(255)
);

CREATE TABLE silver.mcc_clean (
    mcc_id INT PRIMARY KEY,
    Description VARCHAR(255)
);
GO

-- Create gold tables (DIM, FACT)
USE DB_Aurora_Bank;
GO

CREATE TABLE gold.dim_customer (
    client_id INT PRIMARY KEY, 
    current_age INT, 
    retirement_age INT,
    birth_year INT, 
    birth_month INT, 
    gender VARCHAR(50), 
    address VARCHAR(255),
    latitude DECIMAL(10,6), 
    longitude DECIMAL(10,6), 
    per_capita_income DECIMAL(18,2),
    yearly_income DECIMAL(18,2), 
    total_debt DECIMAL(18,2), 
    credit_score INT, 
    num_credit_cards INT
);

CREATE TABLE gold.dim_card (
    card_id INT PRIMARY KEY, 
    client_id INT, 
    card_brand VARCHAR(50),
    card_type VARCHAR(50), 
    card_number VARCHAR(50), 
    expires VARCHAR(20),
    cvv INT, has_chip VARCHAR(10), 
    num_cards_issued INT, 
    credit_limit DECIMAL(18,2),
    acct_open_date VARCHAR(20), 
    year_pin_last_changed INT
);

CREATE TABLE gold.dim_mcc (
    mcc_id INT PRIMARY KEY,
    Description VARCHAR(255)
);

CREATE TABLE gold.fact_transactions (
    transaction_id BIGINT PRIMARY KEY, 
    date DATETIME, 
    client_id INT,
    card_id INT, 
    amount DECIMAL(18,2), 
    use_chip VARCHAR(50), 
    merchant_id BIGINT,
    merchant_city VARCHAR(100), 
    merchant_state VARCHAR(50), 
    zip VARCHAR(20),
    mcc_id INT, 
    errors VARCHAR(255),
    FOREIGN KEY (card_id) REFERENCES gold.dim_card(card_id),
    FOREIGN KEY (mcc_id) REFERENCES gold.dim_mcc(mcc_id)
);
GO