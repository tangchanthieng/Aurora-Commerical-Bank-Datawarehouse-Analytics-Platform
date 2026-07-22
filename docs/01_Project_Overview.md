### Aurora Commercial Banking Customer Analytics Platform

---

Project Proposal

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

---

### 2. Why the Project Exists

Commercial banks generate millions of transactional records every day. While this data contains valuable information, it is often distributed across multiple operational systems and stored in formats that are not suitable for analytical reporting.

Decision-makers require accurate, timely, and consolidated information to understand customer behaviours, identify revenue opportunities, monitor operational performance, and support strategic planning.

Currently, Aurora Bank's data exists as separate operational files, making it difficult to perform comprehensive analysis without significant manual effort. This project addresses that challenge by creating a centralized analytical platform capable of transforming raw banking data into actionable business insights.

**Disclamer:** At this stage, this is conducted as a pilot project by using certain batches of data instead of incrementally ingested daily/hourly. For further development, other data ingestion methods can be undertaken to provide real-time analysis and make full use of the central data lakehouse.

---

### 3. Business Background

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

### 4. Problem Statement

The existing operational datasets are stored separately and are designed primarily for transaction processing rather than analytical reporting. As a result:

- Reporting requires manual consolidation.
- Business users spend excessive time preparing data.
- Data inconsistencies reduce confidence in reporting.
- Customer insights are limited.
- Executive decision-making lacks real-time analytical support.

The bank requires an integrated analytics platform capable of transforming raw operational data into reliable, business-ready information.

---

### 5. Stakeholders

The success of this project depends on multiple business and technical stakeholders.

| Stakeholder                | Responsibilities                                | 
| -------------------------- | ----------------------------------------------- | 
| Executive Management       | Strategic decision making and KPI monitoring    | 
| Business Intelligence Team | Dashboard development and reporting             | 
| Data Engineering Team      | Data warehouse development and ETL processes    | 
| Data Analysts              | Customer and transaction analysis               | 
| Relationship Managers      | Customer engagement and portfolio management    | 
| Risk & Compliance Team     | Transaction monitoring and regulatory reporting | 
| IT Operations              | Database administration and system maintenance  |

---

### 6. Project Objectives

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

### 7. Scope

**`In Scope`**

- Import four operational datasets into SQL Server.
- Design relational and dimensional database models.
- Develop Python ETL scripts.
- Perform data validation and cleansing.
- Build Bronze, Silver, and Gold layers.
- Create analytical SQL views.
- Perform exploratory data analysis using Python.
- Develop customer segmentation.
- Perform anomaly detection on transactions.
- Create executive Power BI dashboards.
- Produce complete project documentation.

**`Out of Scope`**

The following activities are not included in this project:

- Real-time data streaming.
- Online transaction processing (OLTP) systems.
- Production deployment to cloud infrastructure.
- Mobile application development.
- Customer-facing banking applications.
- Machine learning model deployment.

---

### 8. Business Questions

The analytics platform should enable the bank to answer key business questions, including:

`Customer Analytics`
- Who are the highest-value customers?
- Which age groups spend the most?
- Which customer segments generate the highest revenue?
- What is the average customer lifetime value?

`Transaction Analytics`
- How many transactions occur each day?
- What are the monthly spending trends?
- Which transactions contribute most to total revenue?
- Are there unusual transaction patterns?

`Card Analytics`
- Which card types are most frequently used?
- Which cards generate the highest transaction value?
- What percentage of customers actively use their cards?

`Merchant Analytics`
- Which Merchant Category Codes generate the highest revenue?
- Which industries receive the highest spending?
- Which merchant categories show the fastest growth?

---

### 9. Success Metrics

The project will be considered successful if it achieves the following measurable outcomes: 

| Category        | Success Metric                                                   | 
| --------------- | ---------------------------------------------------------------  | 
| Data Quality    | 100% of source records successfully loaded into the Bronze layer | 
| Data Validation | Duplicate and invalid records identified and reported            | 
| Data Warehouse  | Fully functional Bronze, Silver, and Gold architecture           | 
| SQL Development | Reusable SQL scripts and stored procedures implemented           | 
| ETL Pipeline    | Automated extraction, transformation, and loading using Python   | 
| Reporting       | Interactive Power BI dashboard connected to SQL Server           | 
| Analytics       | Customer segmentation and anomaly detection completed            | 
| Documentation   | Complete technical and business documentation delivered          |

---

### 10. Expected Deliverables

The project will deliver the following artefacts:

`Documentation`
- Project Overview
- Data Architecture

`Database`
- SQL Server Database
- Bronze Layer
- Silver Layer
- Gold Layer
- Star Schema
- SQL Views

`Python` 
- ETL Pipeline
- Data Validation
- Feature Engineering
- Anomaly Detection

`Analytics`
- SQL Analytical Queries
- Exploratory Data Analysis
- Business Insights

`Reporting`
- Power BI Dashboard
- Customer Dashboard
- Transaction Dashboard
- Risk Management Dashboard

`Source Control`
- Git Repository
- GitHub Repository
- Version-controlled source code
- Project documentation

---

### 11. Technology Stack

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

### 12. Project Outcome

Upon completion, Aurora Bank will have a centralized analytics platform capable of transforming fragmented operational data into actionable business intelligence. The solution will improve reporting efficiency, enhance data quality, support strategic decision-making, and provide a scalable foundation for future analytical initiatives. From a portfolio perspective, this project demonstrates end-to-end competencies in data engineering, data warehousing, ETL development, SQL analytics, Python programming, and business intelligence using industry-standard tools and methodologies.