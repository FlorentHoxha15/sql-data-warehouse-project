# 🏗️ SQL, Python & PySpark Data Warehouse Project

Welcome to my **SQL, Python & PySpark Data Warehouse Project**! 🚀

This project demonstrates the design and implementation of an end-to-end data warehouse using **SQL Server, Python, Pandas, and PySpark**.

The project follows the **Medallion Architecture**, transforming raw CRM, ERP, and external API data through **Bronze, Silver, and Gold layers** into clean, integrated, and business-ready datasets.

The project combines traditional **CSV-based ETL** with a **Python REST API pipeline**, including data quality checks, logging, error handling, watermark logic, and incremental loading.

As the project evolved, a second implementation of the currency pipeline was developed using **PySpark and Parquet**. The original Pandas + SQL Server implementation is intentionally preserved to demonstrate the progression toward more scalable Data Engineering technologies.

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

4. **PySpark Data Pipeline**
   - SparkSession
   - Spark DataFrames
   - Data cleaning and transformation
   - Data type conversion
   - Data quality validation
   - Incremental processing
   - Spark-based watermark logic
   - Parquet storage
   - Data partitioning
   - Bronze and Silver processing

5. **SQL Data Transformation**
   - Cleaning
   - Standardization
   - Deduplication
   - Data type conversion
   - Business key validation

6. **Data Integration**
   - CRM + ERP integration
   - Historical currency integration

7. **Data Modeling**
   - Fact tables
   - Dimension tables
   - Star Schema

8. **Analytics Layer**
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
- Reimplement the currency pipeline using PySpark.
- Store Spark-processed data in Parquet format.
- Partition datasets for more efficient processing.
- Apply watermark-based incremental processing with Spark.

---

# 🛠️ Technologies Used

- **SQL Server**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**
- **Python**
- **Pandas**
- **PySpark**
- **Apache Spark**
- **Apache Parquet**
- **Requests**
- **SQLAlchemy**
- **PyODBC**
- **REST API**
- **JSON**
- **CSV**
- **Logging**
- **Medallion Architecture**
- **Star Schema**
- **Partitioned Data Storage**
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

# ⚡ PySpark Currency Pipeline

As the project evolved, a second implementation of the currency pipeline was developed using **PySpark**.

The original **Pandas + SQL Server pipeline** is intentionally preserved in the repository. This demonstrates the progression from local DataFrame processing and relational database loading toward distributed data processing and Parquet-based storage.

## PySpark Pipeline Flow

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
PySpark DataFrame
        │
        ▼
Data Type Conversion
        │
        ▼
NULL & Duplicate Handling
        │
        ▼
Data Quality Validation
        │
        ▼
Watermark Check
        │
        ▼
Incremental Processing
        │
        ▼
🥉 Bronze Parquet
        │
        ▼
PySpark Transformations
        │
        ▼
🥈 Silver Parquet
```

## PySpark Features

The PySpark implementation demonstrates:

- SparkSession creation
- Spark DataFrame processing
- Data type conversion using `cast()`
- Date conversion using `to_date()`
- NULL handling with `dropna()`
- Duplicate removal with `dropDuplicates()`
- Filtering with Spark expressions
- Data quality validation
- Spark aggregations
- Watermark logic
- Incremental data processing
- Parquet storage
- Partitioning using `partitionBy()`
- Bronze processing with PySpark
- Silver transformations with PySpark
- Modular pipeline development
- Logging and error handling

## Pipeline Evolution

```text
Version 1
Pandas + SQLAlchemy + SQL Server
        │
        ▼
Watermark-based Incremental Loading
        │
        ▼
SQL Server Bronze
        │
        ▼
SQL Server Silver

                ↓ EVOLUTION ↓

Version 2
PySpark DataFrames
        │
        ▼
Spark Transformations
        │
        ▼
Watermark-based Incremental Processing
        │
        ▼
Partitioned Bronze Parquet
        │
        ▼
Partitioned Silver Parquet
```

Both implementations are kept in the repository to demonstrate the learning journey and the transition toward scalable Data Engineering technologies.

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

One of the main improvements to the currency pipelines is the implementation of **incremental loading and processing**.

Instead of blindly loading the same historical records every time the pipeline runs, the pipelines determine which data has already been processed.

## Pandas + SQL Server Watermark

In the original implementation, the maximum date already stored in the Bronze currency table is used as a watermark.

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

## PySpark Watermark

The PySpark implementation applies the same concept using Spark.

The Bronze Parquet dataset is read and the maximum processed date is retrieved using a Spark aggregation.

Conceptually:

```python
bronze_df.agg(
    spark_max("date").alias("watermark")
)
```

Incoming records are then filtered using:

```python
col("date") > watermark
```

If no watermark exists, the dataset is treated as the initial load.

This prevents the pipelines from unnecessarily processing the same historical data during every execution.

---

# 🔍 Data Quality Checks

Data quality validation is performed before data continues through the pipeline.

The pipelines check for:

- NULL values
- Duplicate rows
- Data types
- Invalid exchange rates

Invalid exchange rates are identified when:

```text
rate <= 0
```

The PySpark implementation additionally performs transformations such as:

```text
Date conversion
      │
      ▼
Rate type conversion
      │
      ▼
NULL removal
      │
      ▼
Duplicate removal
      │
      ▼
Invalid rate validation
```

If invalid rates are detected, the pipeline logs the problem and stops before loading the affected dataset.

---

# 📝 Logging & Error Handling

The pipelines use logging to make execution easier to follow and troubleshoot.

Examples of logged events include:

- Pipeline started
- API extraction successful
- Number of extracted records
- Raw JSON saved
- Database connection successful in the SQL Server implementation
- Current watermark
- Number of new records
- Bronze load successful
- Silver processing successful
- Pipeline completed
- Pipeline failure

The pipelines also handle:

- API request errors
- Database errors in the SQL Server implementation
- Unexpected pipeline exceptions

This makes failures easier to identify instead of allowing a pipeline to fail silently.

---

# 🧩 Modular Pipeline Design

Both implementations are divided into reusable functions.

## Pandas + SQL Server

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

## PySpark

The PySpark implementation includes functions such as:

```text
create_spark_session()

extract_currency_data()
save_raw_data()

create_dataframe()

convert_date_column()
convert_rate_column()
remove_nulls()
remove_duplicates()

check_invalid_rates()
check_data_quality()

get_watermark()
filter_new_data()
check_new_data()

load_bronze()

transform_silver()
load_silver()

main()
```

The `main()` function coordinates each pipeline.

This structure separates responsibilities and makes the pipelines easier to understand, maintain, and extend.

---

# 🥉 Bronze Layer

The Bronze layer stores source data before business transformations are applied.

## Sources

- CRM CSV files
- ERP CSV files
- Currency API data

## SQL Server Implementation

CRM and ERP use:

```text
Batch Processing
Full Load
Truncate & Insert
```

The original currency API pipeline uses:

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

## PySpark Implementation

The PySpark currency pipeline stores incremental Bronze data in **Parquet format**.

```text
API Data
   │
   ▼
PySpark DataFrame
   │
   ▼
Incremental Filter
   │
   ▼
Bronze Parquet
```

The Bronze Parquet dataset is partitioned by the currency quote.

The Bronze layer also provides the processed data used to determine the current watermark.

---

# 🥈 Silver Layer

The Silver layer contains cleaned, standardized, validated, and deduplicated data.

## SQL Server Transformations

- Data Cleaning
- Data Standardization
- Missing Value Handling
- Duplicate Removal
- Data Type Validation
- String Standardization
- Business Key Validation
- Data Enrichment

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

## PySpark Silver Processing

The PySpark implementation performs Silver transformations using Spark DataFrame operations.

These include:

- Duplicate removal
- Invalid rate filtering
- Data type preparation
- Spark-based transformations
- Parquet output
- Partitioned storage

The transformed data is stored as a Silver Parquet dataset.

---

# 🥇 Gold Layer

The Gold layer contains business-ready datasets used for analytics and reporting.

Data from the SQL Server Silver layer is integrated and modeled into fact and dimension views.

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

The current PySpark learning implementation focuses on **Bronze and Silver processing**. Gold processing with Spark can be added in a later stage.

---

# ⭐ Data Modeling

The main SQL Server Gold model follows a **Star Schema**.

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

The resulting analytical SQL Server view is:

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

The project combines SQL-based warehouse processing with Python and PySpark-based API ingestion.

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

## Original Currency API Pipeline

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
SQL Server Bronze
    │
    ▼
SQL Server Silver
    │
    ▼
Gold Currency Integration
```

## PySpark Currency Pipeline

```text
REST API
    │
    ▼
Python Requests
    │
    ▼
Raw JSON
    │
    ▼
PySpark DataFrame
    │
    ▼
Data Preparation
    │
    ▼
Data Quality
    │
    ▼
Watermark
    │
    ▼
Incremental Processing
    │
    ▼
Bronze Parquet
    │
    ▼
PySpark Transformations
    │
    ▼
Silver Parquet
```

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
│   └── ingestion/
│       ├── load_data.py
│       └── currency_pipeline_pyspark.py
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

Contains the Python and PySpark components of the pipeline.

```text
python/
└── ingestion/
    ├── load_data.py
    └── currency_pipeline_pyspark.py
```

### `load_data.py`

Contains the original **Pandas + SQL Server** currency pipeline:

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

### `currency_pipeline_pyspark.py`

Contains the second-generation **PySpark** implementation:

- SparkSession creation
- Spark DataFrames
- Data cleaning
- Spark transformations
- Data quality validation
- Watermark logic
- Incremental processing
- Parquet storage
- Partitioned Bronze storage
- Silver transformation
- Partitioned Silver storage
- Logging
- Error handling

## `scripts/`

Contains SQL scripts used to build and transform the SQL Server Data Warehouse.

```text
scripts/
├── bronze/
├── silver/
└── gold/
```

Each directory represents one layer of the Medallion Architecture.

---

# 🔍 Data Quality

Data quality is handled across Python, PySpark, and SQL.

## Python Data Quality

The original currency pipeline checks:

- NULL values
- Duplicate rows
- Data types
- Invalid exchange rates

## PySpark Data Quality

The Spark implementation performs:

- NULL handling
- Duplicate removal
- Date conversion
- Rate type conversion
- Invalid rate detection
- Validation before Bronze processing

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

This provides multiple layers of validation throughout the project.

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

## PySpark & Distributed Processing

- PySpark
- Apache Spark
- SparkSession
- Spark DataFrames
- Spark Transformations
- Spark Filtering
- Data Type Casting
- NULL Handling
- Duplicate Removal
- Spark Aggregations
- Incremental Processing
- Watermark Logic with Spark
- Apache Parquet
- Data Partitioning
- Bronze / Silver Processing

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

Through this project, I gained hands-on experience building and evolving an end-to-end Data Engineering pipeline combining **SQL, Python, Pandas, and PySpark**.

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
19. Create and process Spark DataFrames with PySpark.
20. Perform transformations using Spark functions.
21. Apply data quality rules using PySpark.
22. Implement Spark-based watermark logic.
23. Perform incremental processing with PySpark.
24. Store datasets using Apache Parquet.
25. Partition Parquet datasets for more efficient processing.
26. Build Bronze and Silver processing using PySpark.
27. Compare local Pandas processing with Spark-based processing.

---

# 🔜 Next Steps

The project has now progressed from a **Pandas + SQL Server pipeline** to an additional **PySpark + Parquet implementation**.

The next phase will focus on applying these Spark concepts in a more cloud-oriented Data Engineering environment.

```text
SQL Server + Pandas
        │
        ▼
PySpark + Parquet
        │
        ▼
Databricks
        │
        ▼
Cloud Data Platform
        │
        ▼
Orchestration
        │
        ▼
End-to-End Data Engineering Pipeline
```

Future learning goals:

- Databricks notebooks
- Spark processing in Databricks
- Cloud storage integration
- Lakehouse architecture
- Delta Lake
- Pipeline orchestration
- Scheduled data pipelines
- End-to-end cloud Data Engineering

The objective is to continue evolving the same project as new Data Engineering technologies are learned, while preserving earlier implementations to demonstrate the complete learning journey.

---

# 🛡️ License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more information.
