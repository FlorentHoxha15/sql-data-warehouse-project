# 🏗️ SQL & Python Data Warehouse Project

Welcome to my **SQL & Python Data Warehouse Project**! 🚀

This project demonstrates the design and implementation of an end-to-end data warehouse using **SQL Server and Python**.

The project follows the **Medallion Architecture**, transforming raw CRM, ERP, and external API data through **Bronze, Silver, and Gold layers** into clean, integrated, and business-ready datasets.

The project combines traditional **CSV-based ETL** with a **Python REST API pipeline**, including data quality checks, logging, error handling, watermark logic, and incremental loading.

---

# 📖 Project Overview

The goal of this project is to simulate a realistic Data Engineering workflow where data from multiple source systems is collected, processed, validated, transformed, and integrated into a central Data Warehouse.

The project currently integrates three different data sources:

- CRM data from CSV files
- ERP data from CSV files
- Historical currency exchange rates from an external REST API

The project covers:

1. **Data Architecture**
   - Bronze, Silver, and Gold layers
   - Medallion Architecture

2. **Multi-Source Data Ingestion**
   - CRM CSV files
   - ERP CSV files
   - External REST API

3. **Python Data Pipeline**
   - REST API extraction
   - Raw JSON storage
   - Pandas processing
   - Data quality validation
   - Database connectivity
   - Incremental loading
   - Watermark logic
   - Logging and error handling

4. **SQL Data Transformation**
   - Cleaning
   - Standardization
   - Deduplication
   - Data type conversion
   - Business key validation

5. **Data Integration**
   - CRM + ERP integration
   - Historical currency integration

6. **Data Modeling**
   - Fact tables
   - Dimension tables
   - Star Schema

7. **Analytics Layer**
   - Business-ready datasets
   - Historical currency conversion
   - SQL analysis
   - BI-ready data

---

# 🎯 Project Objectives

The main objective is to build an end-to-end Data Warehouse that consolidates data from multiple source systems while applying practical Data Engineering concepts.

## Requirements

- Import CRM and ERP source data.
- Load CSV files into SQL Server.
- Extract historical exchange rates from an external REST API.
- Use Python to automate API ingestion.
- Preserve raw API responses as JSON.
- Convert API responses into Pandas DataFrames.
- Perform data quality checks before loading.
- Detect invalid exchange rates.
- Detect duplicate records.
- Validate data types.
- Implement incremental loading.
- Use watermark logic to identify new records.
- Connect Python to SQL Server using SQLAlchemy.
- Load new API records into the Bronze layer.
- Automatically trigger Silver processing.
- Clean and standardize source data.
- Remove duplicate business records.
- Integrate CRM, ERP, and currency data.
- Create fact and dimension views.
- Build a Star Schema.
- Integrate historical exchange rates with sales data.
- Prepare business-ready datasets for analytics.

---

# 🛠️ Technologies Used

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
- **Logging**
- **Medallion Architecture**
- **Star Schema**
- **Git**
- **GitHub**
- **Visual Studio Code**

---

# 🏗️ Data Architecture

The project follows the **Medallion Architecture**:

```text
CRM CSV ──────────────┐
                      │
ERP CSV ──────────────┼────► 🥉 Bronze
                      │          │
Currency REST API     │          ▼
        │             │      🥈 Silver
        ▼             │          │
      Python ─────────┘          ▼
                             🥇 Gold
                                │
                                ▼
                       📊 Analytics & Reporting
```

## Data Sources

The Data Warehouse integrates three source types:

### CRM

CSV files containing:

- Customer data
- Product data
- Sales data

### ERP

CSV files containing:

- Customer information
- Location information
- Product category information

### Currency REST API

Historical EUR exchange rates for:

- USD
- GBP
- CHF

---

# 🐍 Python Currency API Pipeline

Python is used to retrieve historical currency exchange-rate data from an external REST API and integrate it into the existing Data Warehouse.

The pipeline has evolved from a simple API ingestion script into a structured incremental Data Engineering pipeline.

## Pipeline Flow

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
Data Preparation
        │
        ▼
Data Quality Checks
        │
        ▼
Watermark Check
        │
        ▼
Filter New Records
        │
        ▼
Incremental Load
        │
        ▼
SQL Server Bronze
        │
        ▼
Silver Stored Procedure
        │
        ▼
Gold Currency Integration
```

## Pipeline Responsibilities

The Python pipeline:

- Connects to the currency REST API using `requests`.
- Retrieves historical exchange-rate data.
- Uses HTTP error handling with `raise_for_status()`.
- Stores the raw API response as JSON.
- Converts the API response into a Pandas DataFrame.
- Converts the date column into a proper datetime type.
- Checks NULL values.
- Checks duplicate rows.
- Checks data types.
- Detects invalid exchange rates.
- Creates a SQLAlchemy database engine.
- Tests the SQL Server connection.
- Reads the current watermark from the Bronze layer.
- Filters records based on the watermark.
- Detects whether new records are available.
- Loads only new records into Bronze.
- Executes the Silver stored procedure automatically.
- Logs important pipeline events.
- Handles API and pipeline errors.

---

# 💱 Currency Data

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

The currency data is used to enrich the existing sales data with historical currency conversions.

---

# 🔄 Incremental Loading

One of the main improvements to the Python pipeline is the implementation of **incremental loading**.

Instead of blindly loading the same historical records every time the pipeline runs, the pipeline checks which data has already been processed.

## Watermark Logic

The maximum date already stored in the Bronze currency table is used as a watermark.

Conceptually:

```sql
SELECT MAX(date)
FROM bronze.api_currency_rates;
```

The pipeline then compares the incoming API data with this watermark.

```text
Incoming API Data
        │
        ▼
Read Bronze Watermark
        │
        ▼
Compare Dates
        │
        ├── Old record ──► Skip
        │
        └── New record ──► Load
```

If no watermark exists, the dataset is treated as the initial load.

If a watermark exists, only records with a later date are selected.

This prevents the pipeline from unnecessarily loading the same historical data during every execution.

---

# 🔍 Data Quality Checks

Before new API data is loaded into the Data Warehouse, several data quality checks are performed with Pandas.

The pipeline checks:

- NULL values
- Duplicate rows
- Data types
- Invalid exchange rates

Example pipeline logic:

```text
API Data
   │
   ▼
Pandas DataFrame
   │
   ▼
NULL Check
   │
   ▼
Duplicate Check
   │
   ▼
Data Type Check
   │
   ▼
Invalid Rate Check
   │
   ▼
Incremental Processing
```

Invalid exchange rates are identified when:

```text
rate <= 0
```

If invalid rates are detected, the pipeline logs the problem and stops before loading the affected dataset.

---

# 📝 Logging & Error Handling

The Python pipeline uses logging to make pipeline execution easier to follow and troubleshoot.

Examples of logged events include:

- Pipeline started
- API extraction successful
- Number of extracted records
- Raw JSON saved
- Database connection successful
- NULL values
- Duplicate count
- Data types
- Current watermark
- Number of new records
- Bronze load successful
- Silver procedure successful
- Pipeline completed
- Pipeline failure

The pipeline also handles:

- API request errors
- Database errors
- Unexpected pipeline exceptions

This makes failures easier to identify instead of allowing the pipeline to fail silently.

---

# 🧩 Modular Python Design

The Python pipeline is divided into reusable functions.

Examples include:

```text
create_database_engine()
test_database_connection()

extract_currency_data()
save_raw_data()
create_dataframe()
convert_date_column()

check_null_values()
check_duplicates()
check_data_types()
check_invalid_rates()

get_watermark()
filter_new_data()
check_new_data()

load_bronze()
load_silver()

main()
```

The `main()` function coordinates the complete pipeline.

Conceptually:

```text
main()
 │
 ├── Create database engine
 ├── Test database connection
 │
 ├── Extract API data
 ├── Save raw JSON
 │
 ├── Create DataFrame
 ├── Prepare data
 │
 ├── Run data quality checks
 │
 ├── Read watermark
 ├── Filter new records
 │
 ├── Load Bronze
 └── Execute Silver procedure
```

This structure separates responsibilities and makes the pipeline easier to understand and maintain.

---

# 🥉 Bronze Layer

The Bronze layer stores source data before business transformations are applied.

## Sources

- CRM CSV files
- ERP CSV files
- Currency API data

## Object Type

**Tables**

## CRM & ERP Load Strategy

```text
Batch Processing
Full Load
Truncate & Insert
```

## Currency API Load Strategy

```text
Python Ingestion
Watermark Check
Incremental Loading
Append New Records
```

Currency data is loaded into:

```text
bronze.api_currency_rates
```

## Purpose

The Bronze layer preserves source-level data before Silver transformations are applied.

For the currency pipeline, the Bronze layer also acts as the reference point for the current watermark.

---

# 🥈 Silver Layer

The Silver layer contains cleaned, standardized, validated, and deduplicated data.

## Transformations

- Data Cleaning
- Data Standardization
- Missing Value Handling
- Duplicate Removal
- Data Type Validation
- String Standardization
- Business Key Validation
- Data Enrichment

## Object Type

**Tables**

Currency data flows from:

```text
bronze.api_currency_rates
```

to:

```text
silver.api_currency_rates
```

Currency codes are standardized using:

```sql
TRIM()
UPPER()
```

Invalid exchange rates are handled in the transformation logic.

Duplicate currency records are detected using:

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

This makes the Silver loading process rerunnable without inserting the same business records again.

---

# 🥇 Gold Layer

The Gold layer contains business-ready datasets used for analytics and reporting.

Data from the Silver layer is integrated and modeled into fact and dimension views.

## Object Type

**Views**

## Data Model

The Gold layer contains:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
gold.fact_sales_currency
```

## Transformations

- Data Integration
- Business Logic
- Joins
- Surrogate Keys
- Currency Conversion
- Analytical Modeling

## Purpose

The Gold layer provides structured and business-friendly datasets optimized for analytical SQL queries and BI/reporting tools.

---

# ⭐ Data Modeling

The main Gold model follows a **Star Schema**.

```text
             dim_customers
                   │
                   ▼
dim_products ──► fact_sales
```

## Fact Data

`gold.fact_sales` contains measurable sales events such as:

- Sales amount
- Quantity
- Price
- Order date

## Dimension Data

`gold.dim_customers` contains descriptive customer information.

`gold.dim_products` contains descriptive product information.

This structure makes analytical SQL queries easier to write and provides a clear separation between facts and descriptive attributes.

---

# 💱 Currency Integration

The project extends the original sales model by integrating historical currency exchange rates.

Sales data is connected to currency data using the order date:

```text
fact_sales.order_date
        │
        ▼
api_currency_rates.date
```

Example:

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

# ⚠️ Project Assumption

The original sales dataset does **not contain a currency field**.

For demonstration purposes, the original `sales_amount` values are treated as **EUR**.

Historical EUR exchange rates are retrieved from the external currency API and used to calculate equivalent sales values in USD, GBP, and CHF.

This assumption was introduced specifically to demonstrate:

- API ingestion
- Multi-source data integration
- Historical currency conversion
- Python and SQL integration

---

# 🔄 ETL / ELT Process

The project combines SQL-based warehouse processing with Python-based API ingestion.

## CRM & ERP Pipeline

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

## Currency API Pipeline

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
Data Quality
    │
    ▼
Watermark
    │
    ▼
Incremental Load
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

## Extract

Data is extracted from:

- CRM CSV files
- ERP CSV files
- External REST API

## Load

Source data is loaded into the Bronze layer.

The API pipeline uses watermark logic to determine which currency records are new before appending them to Bronze.

## Transform

The Silver layer performs:

- Cleaning
- Standardization
- Validation
- Deduplication
- Data type conversion

## Model

The Gold layer integrates transformed datasets into business-ready analytical views.

---

# 📊 Analytics

The Gold layer supports analysis across several business areas.

## Customer Behavior

- Customer purchasing patterns
- Customer segmentation
- Customer contribution to revenue

## Product Performance

- Best-performing products
- Product sales performance
- Product categories

## Sales Trends

- Revenue development
- Sales over time
- Business performance

## Currency Analysis

- Historical sales values in different currencies
- EUR to USD conversion
- EUR to GBP conversion
- EUR to CHF conversion
- Exchange-rate changes over time

---

# 📂 Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   ├── source_erp/
│   └── source_api/
│       └── currency_raw.json
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

## `datasets/`

Contains source data used by the project:

- CRM datasets
- ERP datasets
- Raw currency API data

## `python/`

Contains the Python components of the pipeline.

```text
python/
├── ingestion/
│   └── load_data.py
├── utils/
└── validation/
```

`load_data.py` handles:

- REST API extraction
- Raw JSON storage
- Pandas processing
- Data quality checks
- Watermark logic
- Incremental loading
- SQL Server connectivity
- Bronze loading
- Silver execution
- Logging
- Error handling

## `scripts/`

Contains SQL scripts used to build and transform the Data Warehouse.

```text
scripts/
├── bronze/
├── silver/
└── gold/
```

Each directory represents one layer of the Medallion Architecture.

---

# 🔍 Data Quality

Data quality is handled across both Python and SQL.

## Python Data Quality

Before loading currency data, Python checks:

- NULL values
- Duplicate rows
- Data types
- Invalid exchange rates

## SQL Data Quality

SQL transformations include:

- NULL handling
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

This provides multiple layers of validation throughout the pipeline.

---

# 🧠 Skills Demonstrated

## SQL & Data Warehousing

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

## Python & Data Engineering

- Python
- Pandas
- REST API Integration
- JSON Processing
- Requests
- SQLAlchemy
- PyODBC
- API Error Handling
- Exception Handling
- Logging
- Data Quality Checks
- Database Connection Management
- Incremental Loading
- Watermark Logic
- Automated Database Loading
- Modular Pipeline Development

## Engineering Practices

- Multi-Source Data Integration
- ETL / ELT Pipelines
- Incremental Data Processing
- Business Key Deduplication
- Idempotent Silver Loading
- Separation of Pipeline Responsibilities
- Error Handling
- Pipeline Logging
- Git
- GitHub
- Technical Documentation

---

# 🚀 Key Learning Outcomes

Through this project, I gained hands-on experience building an end-to-end Data Engineering pipeline combining **SQL and Python**.

The project demonstrates how a Data Engineer can:

1. Ingest data from different source types.
2. Extract external data through a REST API.
3. Process API responses using Python and Pandas.
4. Preserve raw API data as JSON.
5. Perform data quality checks before loading.
6. Connect Python applications to SQL Server.
7. Load data into SQL Server programmatically.
8. Implement incremental loading using watermark logic.
9. Process only records that have not already been loaded.
10. Design Bronze, Silver, and Gold data layers.
11. Clean and deduplicate data using SQL.
12. Automate transformations using stored procedures.
13. Integrate multiple datasets into analytical models.
14. Build fact and dimension views.
15. Implement historical currency conversion.
16. Add logging and error handling to a data pipeline.
17. Structure Python code into reusable pipeline functions.
18. Prepare business-ready data for analytics and BI.

---

# 🔜 Next Steps

The next phase of the project will focus on **Databricks and PySpark**.

The goal is to explore how the Data Engineering concepts already implemented in Python and SQL Server can be applied in a more scalable data-processing environment.

Planned areas include:

```text
Current Project
Python + Pandas + SQL Server
          │
          ▼
Learn PySpark
          │
          ▼
Databricks
          │
          ▼
Bronze / Silver Processing
          │
          ▼
Lakehouse Concepts
```

Future learning goals:

- PySpark DataFrames
- Reading and transforming data with Spark
- Spark data types and schemas
- Filtering and cleaning data with PySpark
- Databricks notebooks
- Bronze and Silver processing with PySpark
- Lakehouse concepts
- Comparing Pandas processing with distributed Spark processing

The objective is to build on the existing project rather than replacing it, showing the progression from a local Python/SQL Server pipeline toward modern Data Engineering technologies.

---

# 🛡️ License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more information.
