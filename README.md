### Aurora Commercial Banking Customer Analytics Platform

---

Project Name: Aurora Commercial Banking Customer Analytics Platform

Owner: Chan Tang

Role: Project Owner / Data Analyst / Data Engineer

Version: 1.1

Date: Feb 2026

---

### 1. Project Overview

This project aims to design and implement an end-to-end analytics solution for Aurora Commercial Bank (Aurora Bank) by transforming raw operational data into meaningful business intelligence. The solution will demonstrate the complete analytics lifecycle, including data ingestion, data warehousing, ETL development, data quality management, SQL analysis, Python-based analytics, and interactive reporting through Power BI. The project is built using four operational datasets provided by the bank:

- Users Data
- Cards Data
- Transactions Data
- Merchant Category Codes (MCC)

These datasets will be integrated into a centralized SQL Server data warehouse using a **Medallion Architecture** (Bronze → Silver → Gold). The curated data will then be analysed to provide insights into customer behaviours, transaction patterns, financial health, and sales/merchant performance.

### 2. Business Background

The commercial bank offers a variety of financial products including savings accounts, credit cards, debit cards, and payment services. Every customer interaction generates transactional data that is valuable for understanding spending patterns and customer engagement. The bank currently maintains separate datasets for:

- Customer information
- Card information
- Financial transactions
- Merchant Category Code (MCC) reference data

Although these datasets contain rich operational information, they have not been integrated into a unified analytical environment. **Senior management has identified several business challenges:**

- Customer profitability is difficult to measure.
- Spending behaviour is not fully understood.
- Merchant category performance cannot be easily analysed.
- Card usage trends are difficult to monitor.
- Operational reporting requires significant manual processing.

To address these issues, the bank has commissioned the development of a centralized data warehouse and business intelligence solution.

---

### 3. Project Objectives

The primary objective of this project is to build a modern analytics platform capable of supporting business intelligence and data-driven decision making. Specific objectives include:

- Build a centralized SQL Server data warehouse.
- Implement a Medallion Architecture consisting of Bronze, Silver, and Gold layers.
- Develop reusable ETL pipelines using Python.
- Improve overall data quality through validation and cleansing.
- Design a dimensional data model optimized for reporting.
- Produce interactive dashboards using Power BI.
- Analyse customer behaviour and transaction patterns.
- Identify high-value customers and profitable merchant categories.
- Demonstrate professional data engineering and analytics skills suitable for a production environment.

---

### 4. Technology Stack

`Component Technology`

- Database: SQL Server 2022 Express
- Database Management: SQL Server Management Studio (SSMS 22)
- Programming Language: Python 3.14
- IDE: Visual Studio Code
- Data Processing: Pandas, NumPy
- Database Connectivity: SQLAlchemy, pyodbc
- Machine Learning: Scikit-learn
- Visualization: Power BI Desktop
- Version Control: Git
- Repository Hosting: GitHub

---

### 5. How to use this Repository

```bash
# Clone the repository
git clone https://github.com/your-username/aurora-banking-analytics.git
cd aurora-banking-analytics

# Review configuration and utility scripts
python scripts/config.py
python scripts/utils.py

# Initialize database structure and base schemas
python scripts/database/create_database.py
python scripts/database/create_tables.py

# Ingestion & Bronze Layer
python scripts/pipeline/extract.py
python scripts/pipeline/validate.py
python scripts/pipeline/load_bronze.py

# Silver Layer (Cleansing & Transformation)
python scripts/pipeline/transformation_silver.py
python scripts/pipeline/load_silver.py

# Gold Layer & Views Creation
python scripts/pipeline/load_gold.py
python scripts/pipeline/create_views.py
```

---

### 6. Reporting & Analytics

- Open the `docs/` directory to review complete project documentation and data dictionaries.
- Launch `dashboards/aurora_analytics.pbix` in Power BI Desktop to explore the interactive visual analytics.
- Open the `image/diagram/Findings_Recommendations.png` to review the summary of findings and recommendations.

---