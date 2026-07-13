USE DB_Aurora_Bank;
GO

CREATE TABLE bronze.clients (
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

CREATE TABLE bronze..cards (
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

CREATE TABLE bronze.transactions (
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

CREATE TABLE bronze.mcc (
    mcc_id VARCHAR(10),
    Description VARCHAR(255)
);
GO