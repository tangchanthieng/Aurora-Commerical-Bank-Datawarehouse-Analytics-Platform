### Aurora Commercial Banking Customer Analytics Platform

---

Data Architecture

Project Name: Aurora Commercial Banking Customer Analytics Platform

Owner: Chan Tang

Role: Project Owner / Data Analyst / Data Engineer

Version: 1.1

Date: Feb 2026

---

Kindly use this link to access data architecture on Lucid.

`https://lucid.app/lucidchart/73b3d231-03b5-4979-a647-47dc75536a3a/edit?invitationId=inv_cbd90b2c-d43b-4ab4-baf2-308501fef300`

---

### Medallion Architecture (Bronze, Silver, Gold)

To guarantee data quality and auditability, data transitions through three distinct logical layers within SQL Server:

- Bronze (Raw Ingestion): Captures exact replicas of incoming operational tables with minimal overhead. Data includes tracking metadata (e.g., ingestion timestamps) to maintain a complete historical audit path.
- Silver (Cleaned & Conformed): Applies structural enforcement. Raw text identifiers are parsed, currency types (like $59,696) are stripped down to numerical floats, dates are cast into ISO formats, and referential checks are evaluated.
- Gold (Curated Business Insights): Formats clean datasets into an analytical Star Schema layout. Aggregated views and structured datasets are deployed specifically to maximize performance for Power BI report consumption.

---

### Star Schema

The semantic model layer within the Gold zone uses a Star Schema dimensional architecture. By organizing the dataset into central numeric transactional tables surrounded by informative descriptive entities, the system ensures swift filter response times and an easy mapping landscape for Power BI model configurations
