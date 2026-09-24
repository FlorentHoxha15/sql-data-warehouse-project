# 🏗️ SQL & Python Data Warehouse Project

Welcome to my **SQL & Python Data Warehouse Project**! 🚀

This project demonstrates the design and implementation of an end-to-end data warehouse using **SQL Server and Python**.

The project follows the **Medallion Architecture**, transforming raw CRM, ERP, and external API data through **Bronze, Silver, and Gold layers** into clean, integrated, and business-ready datasets for analytics and reporting.

The project combines traditional **CSV-based ETL** with a **Python REST API ingestion pipeline**, demonstrating how multiple data sources can be integrated into a modern data warehouse.

---

## 📖 Project Overview

This project covers the complete data warehouse development process:

1. **Data Architecture**  
   Designing a data warehouse using the **Bronze, Silver, and Gold layers**.

2. **Multi-Source Data Ingestion**  
   Loading CRM and ERP data from CSV files and historical exchange-rate data from an external REST API.

3. **Python Data Pipeline**  
   Using Python, Requests, Pandas, SQLAlchemy, and PyODBC to extract API data and load it into SQL Server.

4. **Data Transformation**  
   Cleaning, standardizing, validating, and deduplicating raw data.

5. **Data Integration**  
   Combining CRM, ERP, and external currency data into integrated analytical datasets.

6. **Data Modeling**  
   Creating fact and dimension views using a **Star Schema**.

7. **Analytics**  
   Preparing business-ready datasets for SQL analysis and BI/reporting tools.

---

## 🎯 Project Objectives

The main objective is to build an end-to-end data warehouse that consolidates data from multiple source systems.

### Requirements

- Import data from **ERP and CRM** source systems.
- Load CSV files into SQL Server.
- Extract historical exchange rates from an external REST API.
- Use Python to automate API data ingestion.
- Preserve raw API responses as JSON.
- Clean and standardize source data.
- Resolve data quality issues.
- Remove duplicate records.
- Integrate data from multiple sources.
- Create business-ready fact and dimension views.
- Build a **Star Schema** for analytical queries.
- Integrate historical currency rates with sales data.
- Prepare the data for reporting and analytics.

---

## 🛠️ Technologies Used

- **SQL Server**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**
- **Python**
- **Pandas**
- **Requests**
- **SQLAlchemy**
- **PyODBC**
- **REST API**
- **JSON**
- **CSV**
- **Medallion Architecture**
- **Star Schema**
- **Git**
- **GitHub**
- **Visual Studio Code**

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture**:

```text
CRM CSV ─────────────┐
                     │
ERP CSV ─────────────┼────► 🥉 Bronze
                     │          │
Currency REST API    │          ▼
        │            │      🥈 Silver
        ▼            │          │
      Python ────────┘          ▼
                            🥇 Gold
                                │
                                ▼
                      📊 Analytics & Reporting
```

### Data Sources

The warehouse integrates three source types:

- **CRM CSV files** — customer, product, and sales data.
- **ERP CSV files** — customer, location, and product category data.
- **Currency REST API** — historical EUR exchange rates for USD, GBP, and CHF.

---

## 🐍 Python API Pipeline

Python is used to ingest historical exchange-rate data from an external REST API.

The pipeline performs the following steps:

```text
Frankfurter REST API
        │
        ▼
Python Requests
        │
        ▼
Raw JSON
        │
        ▼
Pandas DataFrame
        │
        ▼
Data Quality Checks
        │
        ▼
SQL Server Bronze
        │
        ▼
Silver Stored Procedure
```

The Python pipeline:

- Connects to the currency API using `requests`.
- Retrieves historical exchange rates for the sales period.
- Stores the raw API response as JSON.
- Loads the JSON data into a Pandas DataFrame.
- Performs basic data quality checks.
- Connects to SQL Server using SQLAlchemy and PyODBC.
- Loads the API data into the Bronze layer.
- Automatically executes the Silver loading procedure.

Historical exchange rates are collected for the sales period:

```text
2010-12-29 → 2014-01-28
```

Currencies retrieved:

```text
EUR → USD
EUR → GBP
EUR → CHF
```

---

## 🥉 Bronze Layer

The Bronze layer stores raw source data before business transformations are applied.

### Sources

- CRM CSV files
- ERP CSV files
- Currency API data

### Object Type

**Tables**

### Load Strategy

CRM and ERP data:

- Batch Processing
- Full Load
- Truncate & Insert

Currency API data:

- Python ingestion
- Append-based loading
- Raw historical exchange-rate records

### Purpose

Preserve source data before cleaning and transformation.

The API pipeline loads currency data into:

```text
bronze.api_currency_rates
```

---

## 🥈 Silver Layer

The Silver layer contains cleaned, standardized, and validated data.

### Transformations

- Data Cleaning
- Data Standardization
- Handling Missing Values
- Removing Duplicates
- Data Type Validation
- String Standardization
- Derived Columns
- Data Enrichment
- Business Key Validation

### Object Type

**Tables**

Currency data is transformed from:

```text
bronze.api_currency_rates
```

into:

```text
silver.api_currency_rates
```

Currency codes are standardized using:

```text
TRIM
UPPER
```

Invalid exchange rates are handled and duplicate currency records are detected using:

```sql
ROW_NUMBER()
```

The currency business key consists of:

```text
date + base + quote
```

Existing Silver records are protected from duplicate insertion using:

```sql
NOT EXISTS
```

This allows the Silver currency load to be rerun without creating duplicate business records.

---

## 🥇 Gold Layer

The Gold layer contains business-ready datasets used for analytics and reporting.

Data from the Silver layer is integrated and modeled into **fact and dimension views**.

### Object Type

**Views**

### Data Model

The Gold layer contains:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
gold.fact_sales_currency
```

### Transformations

- Data Integration
- Business Logic
- Joins
- Surrogate Keys
- Currency Conversion
- Analytical Modeling

### Purpose

Provide structured and business-friendly datasets optimized for analytical queries and BI tools.

---

## ⭐ Data Modeling

The main Gold model follows a **Star Schema**.

```text
             dim_customers
                   │
                   ▼
dim_products ──► fact_sales
```

### Fact Data

`gold.fact_sales` contains measurable sales events such as:

- Sales amount
- Quantity
- Price
- Order date

### Dimension Data

`gold.dim_customers` contains descriptive customer information.

`gold.dim_products` contains descriptive product information.

This structure makes analytical SQL queries easier to write and improves the usability of the data warehouse.

---

## 💱 Currency Integration

The project extends the original sales model by integrating historical currency exchange rates.

Sales data is connected to currency data using the order date:

```text
fact_sales.order_date
        │
        ▼
api_currency_rates.date
```

For example:

```text
Sales Amount
€3,578

Historical EUR → USD Rate
1.3155

Converted Sales
€3,578 × 1.3155 = $4,706.86
```

The resulting analytical view is:

```text
gold.fact_sales_currency
```

It contains:

- Order Number
- Product Key
- Customer Key
- Order Date
- EUR Sales Amount
- Target Currency
- Historical Exchange Rate
- Converted Sales Amount

Each sales transaction can therefore be analyzed using historical:

- USD
- GBP
- CHF

exchange rates.

---

## ⚠️ Project Assumption

The original sales dataset does **not contain a currency field**.

For demonstration purposes, the original `sales_amount` values are treated as **EUR**.

Historical EUR exchange rates are retrieved from the external currency API and used to calculate equivalent sales values in USD, GBP, and CHF.

This assumption is introduced specifically to demonstrate **API ingestion, multi-source data integration, and historical currency conversion** within the data warehouse.

---

## 🔄 ETL / ELT Process

The project combines SQL-based warehouse processing with Python-based API ingestion.

### CRM & ERP Pipeline

```text
CSV Files
    │
    ▼
Bronze
    │
    ▼
Silver
    │
    ▼
Gold
```

### Currency API Pipeline

```text
REST API
    │
    ▼
Python
    │
    ▼
Raw JSON
    │
    ▼
Pandas
    │
    ▼
Bronze
    │
    ▼
Silver
    │
    ▼
Gold Currency Integration
```

### Extract

Data is extracted from:

- CRM CSV files
- ERP CSV files
- External REST API

### Load

Raw source data is loaded into the **Bronze layer**.

### Transform

The Silver layer performs:

- Cleaning
- Standardization
- Validation
- Deduplication
- Data type conversion

### Model

The Gold layer integrates the transformed data into business-ready analytical views.

---

## 📊 Analytics

The Gold layer can support analysis across several business areas.

### Customer Behavior

- Customer purchasing patterns
- Customer segmentation
- Customer contribution to revenue

### Product Performance

- Best-performing products
- Product sales performance
- Product categories

### Sales Trends

- Revenue development
- Sales over time
- Business performance

### Currency Analysis

- Historical sales values in different currencies
- EUR to USD conversion
- EUR to GBP conversion
- EUR to CHF conversion
- Exchange-rate changes over time

---

## 📂 Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   ├── source_erp/
│   └── source_api/
│       └── currency_raw.json
│
├── docs/
│
├── python/
│   ├── ingestion/
│   │   └── load_data.py
│   ├── utils/
│   └── validation/
│
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   └── proc_load_silver.sql
│   │
│   └── gold/
│       └── ddl_gold.sql
│
├── LICENSE
└── README.md
```

### `datasets/`

Contains source data used by the project:

- CRM datasets
- ERP datasets
- Raw currency API data

### `python/`

Contains the Python components of the data pipeline.

```text
python/
├── ingestion/
│   └── load_data.py
├── utils/
└── validation/
```

`load_data.py` handles the historical currency API ingestion and loads the results into SQL Server.

### `scripts/`

Contains the SQL scripts used to build and transform the data warehouse.

```text
scripts/
├── bronze/
├── silver/
└── gold/
```

Each directory represents one layer of the Medallion Architecture.

### `docs/`

Contains project documentation and architecture diagrams.

---

## 🔍 Data Quality

Several data quality techniques are implemented throughout the project.

Examples include:

- NULL value checks
- Duplicate detection
- Data type validation
- String trimming
- Standardization with `UPPER()`
- Invalid value handling
- Business key validation
- Deduplication using `ROW_NUMBER()`
- Duplicate prevention using `NOT EXISTS`
- Sales validation
- Date validation

Python also performs basic quality checks using Pandas before loading API data into SQL Server.

---

## 🧠 Skills Demonstrated

This project demonstrates practical experience with:

### SQL & Data Warehousing

- SQL Development
- T-SQL
- Data Warehousing
- Medallion Architecture
- Bronze / Silver / Gold Design
- Stored Procedures
- Window Functions
- Data Cleaning
- Data Transformation
- Data Integration
- Fact & Dimension Modeling
- Star Schema Design
- Analytical SQL

### Python & Data Engineering

- Python
- Pandas
- REST API Integration
- JSON Processing
- Requests
- SQLAlchemy
- PyODBC
- API Error Handling
- Logging
- Data Quality Checks
- Automated Database Loading

### Engineering Practices

- Multi-Source Data Integration
- ETL / ELT Pipelines
- Business Key Deduplication
- Git
- GitHub
- Technical Documentation

---

## 🚀 Key Learning Outcomes

Through this project, I gained hands-on experience building an end-to-end data pipeline that combines **SQL and Python**.

The project demonstrates how a Data Engineer can:

1. Ingest data from different source types.
2. Extract external data through a REST API.
3. Process API responses using Python and Pandas.
4. Load data into SQL Server programmatically.
5. Design Bronze, Silver, and Gold data layers.
6. Clean and deduplicate data using SQL.
7. Automate transformations using stored procedures.
8. Integrate multiple datasets into analytical models.
9. Build fact and dimension views.
10. Prepare business-ready data for analytics and BI.

---

## 🛡️ License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more information.