# 🏗️ SQL, Python & PySpark Data Warehouse Project

Welcome to my **SQL, Python & PySpark Data Warehouse Project**! 🚀

This project demonstrates the development and evolution of an end-to-end Data Engineering pipeline using **SQL Server, Python, Pandas, PySpark, and Parquet**.

The project follows the **Medallion Architecture**, transforming data through **Bronze, Silver, and Gold layers**.

Two implementations of the currency pipeline are intentionally kept in the repository:

- **Version 1:** Pandas + SQL Server
- **Version 2:** PySpark + Parquet

This shows the progression from a traditional Python/SQL pipeline toward a more scalable Spark-based architecture.

---

# 📖 Project Overview

The goal of this project is to simulate a realistic Data Engineering workflow where data from multiple sources is collected, validated, transformed, stored, and prepared for analytics.

The project integrates:

- CRM data from CSV files
- ERP data from CSV files
- Historical currency exchange rates from a REST API

The project covers:

- REST API ingestion
- Raw JSON storage
- Data quality checks
- Incremental loading
- Watermark logic
- SQL Server
- Pandas
- PySpark
- Parquet
- Partitioning
- Medallion Architecture
- Bronze / Silver / Gold processing
- Data modeling
- Analytics-ready datasets
- Logging and error handling

---

# 🎯 Project Goal

The goal is to build an end-to-end Data Engineering pipeline and gradually evolve it toward technologies used for larger-scale data processing.

The project started with:

```text
Python + Pandas + SQL Server
```

and was later extended with:

```text
PySpark + Parquet + Partitioning
```

This allows both approaches to be compared while keeping the learning journey visible in the repository.

---

# 🛠️ Technologies Used

- **Python**
- **SQL**
- **SQL Server**
- **T-SQL**
- **Pandas**
- **PySpark**
- **Apache Spark**
- **Apache Parquet**
- **REST API**
- **Requests**
- **JSON**
- **CSV**
- **SQLAlchemy**
- **PyODBC**
- **Logging**
- **Medallion Architecture**
- **Star Schema**
- **Git**
- **GitHub**
- **Visual Studio Code**

---

# 🏗️ Architecture

The project follows the **Medallion Architecture**:

```text
             Source Systems
                   │
        ┌──────────┼──────────┐
        │          │          │
        ▼          ▼          ▼
      CRM         ERP      REST API
      CSV         CSV     Currency Data
        │          │          │
        └──────────┼──────────┘
                   │
                   ▼
              🥉 BRONZE
                   │
                   ▼
              🥈 SILVER
                   │
                   ▼
               🥇 GOLD
                   │
                   ▼
          Analytics / Reporting
```

Each layer has a different responsibility:

### 🥉 Bronze

Stores ingested data with minimal transformation.

### 🥈 Silver

Contains cleaned, validated, standardized, and deduplicated data.

### 🥇 Gold

Contains business-ready and aggregated datasets for analytics and reporting.

---

# 📥 Data Sources

## CRM

CSV files containing:

- Customer data
- Product data
- Sales data

## ERP

CSV files containing:

- Customer information
- Location information
- Product category information

## Currency REST API

Historical EUR exchange rates from the Frankfurter API for:

- USD
- GBP
- CHF

The currency data covers the sales period:

```text
2010-12-29 → 2014-01-28
```

---

# 🐍 Version 1 — Pandas + SQL Server Pipeline

The first implementation uses **Python, Pandas, SQLAlchemy, and SQL Server**.

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
Incremental Loading
        │
        ▼
🥉 SQL Server Bronze
        │
        ▼
🥈 SQL Server Silver
        │
        ▼
🥇 SQL Server Gold
        │
        ▼
Analytics
```

## Features

The original pipeline demonstrates:

- REST API extraction
- Raw JSON storage
- Pandas DataFrames
- Date conversion
- NULL checks
- Duplicate checks
- Data type validation
- Invalid exchange-rate detection
- SQLAlchemy database connectivity
- SQL Server integration
- Watermark logic
- Incremental loading
- Stored procedures
- Logging
- Error handling

---

# ⚡ Version 2 — PySpark + Parquet Pipeline

The second implementation rebuilds the currency pipeline using **PySpark**.

Instead of processing the data primarily with Pandas and storing each layer in SQL Server, this version uses:

- Spark DataFrames
- Spark transformations
- Parquet storage
- Partitioning
- Spark-based watermark logic
- Incremental processing

## Pipeline Flow

```text
Frankfurter REST API
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
Data Quality Checks
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
        │
        ▼
PySpark Aggregations
        │
        ▼
🥇 Gold Parquet
        │
        ▼
Analytics / Reporting
```

---

# ⚡ PySpark Processing

The PySpark pipeline uses a `SparkSession` to process data using Spark DataFrames.

The pipeline performs:

- Spark DataFrame creation
- Date conversion with `to_date()`
- Numeric conversion with `cast()`
- NULL handling
- Duplicate removal
- Filtering
- Data quality validation
- Aggregations
- Incremental processing
- Parquet reads and writes
- Partitioning

Example transformation:

```python
df = df.withColumn(
    "rate",
    col("rate").cast("double")
)
```

---

# 🔍 Data Quality

Data quality validation is performed before data continues through the pipeline.

The PySpark pipeline:

```text
Incoming Data
      │
      ▼
Convert Data Types
      │
      ▼
Remove NULLs
      │
      ▼
Remove Duplicates
      │
      ▼
Check Invalid Rates
      │
      ▼
Continue Pipeline
```

An exchange rate is considered invalid when:

```text
rate <= 0
```

If invalid rates are detected, the pipeline stops before loading the affected data.

---

# 🔄 Watermark & Incremental Processing

The pipeline uses a **watermark** to avoid processing the same records repeatedly.

The watermark represents:

> The latest date that has already been processed.

In the PySpark implementation, the Bronze Parquet dataset is read and Spark calculates the maximum date:

```python
result = bronze_df.agg(
    spark_max("date").alias("watermark")
).collect()

watermark = result[0]["watermark"]
```

New API data is then filtered:

```python
new_data = df.filter(
    col("date") > watermark
)
```

Conceptually:

```text
API Data
   │
   ▼
Read Bronze
   │
   ▼
MAX(date)
   │
   ▼
Watermark
   │
   ▼
date > watermark
   │
   ▼
Only New Records
```

If Bronze does not exist yet:

```text
watermark = None
```

This indicates the first pipeline run, so all available records are processed.

---

# 🥉 Bronze Layer — PySpark

Bronze contains the incrementally ingested currency data.

Only records newer than the watermark are appended.

```python
new_data.write \
    .mode("append") \
    .partitionBy("quote") \
    .parquet(BRONZE_PATH)
```

The data is partitioned by:

```text
quote
```

Example:

```text
bronze/currency_rates/

├── quote=USD/
├── quote=GBP/
└── quote=CHF/
```

This organizes the dataset by currency and allows Spark to avoid unnecessary partitions when queries filter on the partition column.

---

# 🥈 Silver Layer — PySpark

After new records are added to Bronze, the pipeline reads the complete Bronze dataset.

```text
Bronze
   │
   ▼
Read Complete Dataset
   │
   ▼
Remove Duplicates
   │
   ▼
Validate Rates
   │
   ▼
Silver
```

Silver contains cleaned and validated currency data.

The transformation includes:

- Duplicate removal
- Invalid-rate filtering
- Clean data types
- Valid currency records

Silver is stored as partitioned Parquet:

```text
silver/currency_rates/

├── quote=USD/
├── quote=GBP/
└── quote=CHF/
```

The Silver dataset is rebuilt from the complete Bronze dataset to preserve historical data.

---

# 🥇 Gold Layer — PySpark

The Gold layer transforms the cleaned Silver data into a simple analytical currency summary.

The data is grouped by:

```text
quote
```

The pipeline calculates:

- Average exchange rate
- Minimum exchange rate
- Maximum exchange rate

Example:

```text
quote | average_rate | min_rate | max_rate
------------------------------------------------
USD   | 1.35         | 1.20     | 1.48
GBP   | 0.84         | 0.78     | 0.91
CHF   | 1.18         | 1.02     | 1.32
```

The transformation is performed using:

```python
gold_df = silver_df.groupBy(
    "quote"
).agg(
    avg("rate").alias("average_rate"),
    spark_min("rate").alias("min_rate"),
    spark_max("rate").alias("max_rate")
)
```

Gold is then stored as Parquet:

```python
gold_df.write \
    .mode("overwrite") \
    .parquet(GOLD_PATH)
```

This dataset is ready for analytical use or further integration with reporting tools.

---

# 📦 Why Parquet?

The PySpark implementation uses **Apache Parquet** instead of CSV for the Medallion layers.

Parquet provides:

- Column-oriented storage
- Compression
- Data type preservation
- Efficient analytical reads
- Good integration with Spark
- Support for partitioning

This makes Parquet well suited for analytical Data Engineering workloads.

---

# 📂 Partitioning

Bronze and Silver are partitioned by currency:

```python
.partitionBy("quote")
```

This creates a structure such as:

```text
currency_rates/

├── quote=USD/
├── quote=GBP/
└── quote=CHF/
```

When Spark needs only one currency, partition pruning can allow irrelevant partitions to be skipped.

For example:

```python
df.filter(
    col("quote") == "USD"
)
```

Spark can focus on the USD partition instead of scanning all currency partitions.

Gold is not partitioned because the aggregated Gold dataset is very small.

---

# 🧠 Pipeline Evolution

One of the main goals of this repository is to show how the project evolved while learning new Data Engineering concepts.

## Version 1

```text
REST API
   ↓
Python
   ↓
Pandas
   ↓
SQLAlchemy
   ↓
SQL Server Bronze
   ↓
SQL Server Silver
   ↓
SQL Server Gold
```

## Version 2

```text
REST API
   ↓
Python
   ↓
PySpark
   ↓
Incremental Processing
   ↓
Bronze Parquet
   ↓
Silver Parquet
   ↓
Gold Parquet
```

The first implementation is intentionally kept in the repository.

The goal is not to show that one tool is always better than another, but to demonstrate how the same Data Engineering problem can be approached with different technologies as data-processing requirements evolve.

---

# 💱 SQL Currency Integration

The original SQL Server implementation integrates historical exchange rates with sales data.

Sales data is connected to currency data using:

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

The resulting analytical SQL view is:

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

---

# ⭐ SQL Server Data Model

The original SQL Server implementation also contains a Star Schema.

```text
             dim_customers
                  │
                  ▼
dim_products ──► fact_sales
```

Gold objects include:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
gold.fact_sales_currency
```

This allows the project to demonstrate both:

- Data pipeline engineering
- Analytical data modeling

---

# ⚠️ Project Assumption

The original sales dataset does not contain a currency field.

For demonstration purposes, the original `sales_amount` values are treated as **EUR**.

Historical EUR exchange rates are retrieved from the currency API and used to calculate equivalent values in:

- USD
- GBP
- CHF

This assumption allows the project to demonstrate API ingestion, historical currency conversion, and multi-source data integration.

---

# 🧩 Modular Pipeline Design

The PySpark pipeline is divided into reusable functions.

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
read_bronze()

transform_silver()
load_silver()
read_silver()

transform_gold()
load_gold()

main()
```

The `main()` function coordinates the complete pipeline.

```text
Extract
   ↓
Prepare
   ↓
Validate
   ↓
Watermark
   ↓
Incremental Processing
   ↓
Bronze
   ↓
Silver
   ↓
Gold
```

This separation makes the pipeline easier to understand, maintain, test, and extend.

---

# 📝 Logging & Error Handling

The pipeline logs important execution events.

Examples include:

- Pipeline started
- API extraction successful
- Number of extracted records
- Raw JSON saved
- Current watermark
- Number of new records
- Bronze load successful
- Silver load successful
- Gold load successful
- Pipeline completed
- Pipeline failed

The pipeline also handles API errors:

```python
except requests.RequestException as error:
```

and unexpected pipeline errors:

```python
except Exception as error:
```

This prevents failures from happening silently and makes troubleshooting easier.

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

## Python Pipelines

### `load_data.py`

Original implementation using:

```text
Python
Pandas
SQLAlchemy
SQL Server
```

It demonstrates:

- API extraction
- Pandas processing
- Data quality
- SQL Server connectivity
- Watermark logic
- Incremental loading
- Stored procedure execution

### `currency_pipeline_pyspark.py`

New implementation using:

```text
Python
PySpark
Apache Spark
Parquet
```

It demonstrates:

- SparkSession
- Spark DataFrames
- Data cleaning
- Data quality
- Watermark logic
- Incremental processing
- Parquet
- Partitioning
- Bronze processing
- Silver transformations
- Gold aggregations

---

# 📊 Analytics

The project supports analysis such as:

## Customer Analysis

- Customer purchasing patterns
- Customer contribution to revenue

## Product Analysis

- Best-performing products
- Product categories
- Product sales performance

## Sales Analysis

- Revenue trends
- Sales over time
- Business performance

## Currency Analysis

- Historical exchange rates
- Average exchange rate by currency
- Minimum exchange rate
- Maximum exchange rate
- EUR → USD conversion
- EUR → GBP conversion
- EUR → CHF conversion

---

# 🧠 Skills Demonstrated

## SQL

- T-SQL
- SQL Server
- Stored Procedures
- Window Functions
- Joins
- Data Cleaning
- Data Transformation
- Fact Tables
- Dimension Tables
- Star Schema
- Medallion Architecture

## Python

- Python
- Pandas
- REST APIs
- Requests
- JSON
- SQLAlchemy
- PyODBC
- Functions
- Exception Handling
- Logging
- Modular Pipeline Development

## PySpark

- Apache Spark
- SparkSession
- Spark DataFrames
- `select()`
- `filter()`
- `withColumn()`
- `cast()`
- `to_date()`
- `dropna()`
- `dropDuplicates()`
- `groupBy()`
- `agg()`
- Spark aggregations
- Parquet reads and writes
- Partitioning
- Partition pruning concepts

## Data Engineering

- ETL / ELT
- Data Ingestion
- Data Quality
- Incremental Processing
- Watermark Logic
- Medallion Architecture
- Bronze / Silver / Gold
- Parquet
- Partitioning
- Multi-source Data Integration
- Data Modeling
- Logging
- Error Handling
- Git
- GitHub

---

# 🚀 Key Learning Outcomes

Through this project, I learned how to build and gradually evolve an end-to-end Data Engineering pipeline.

The project demonstrates how to:

1. Ingest data from CSV files and REST APIs.
2. Preserve raw API data as JSON.
3. Process data using Pandas.
4. Process data using PySpark.
5. Create and transform Spark DataFrames.
6. Validate data quality.
7. Handle NULL values and duplicates.
8. Convert data types.
9. Implement watermark logic.
10. Process only new records.
11. Build incremental pipelines.
12. Store analytical datasets using Parquet.
13. Partition datasets.
14. Understand partition pruning.
15. Build Bronze, Silver, and Gold layers.
16. Perform Spark aggregations.
17. Build SQL Server fact and dimension models.
18. Integrate historical currency data with sales data.
19. Add logging and error handling.
20. Structure pipelines into reusable functions.
21. Evolve a Pandas-based pipeline toward PySpark.

---

# 🔜 Next Steps

The project has progressed through:

```text
SQL
 │
 ▼
Python + Pandas
 │
 ▼
REST API Pipeline
 │
 ▼
Watermark & Incremental Loading
 │
 ▼
PySpark
 │
 ▼
Parquet & Partitioning
 │
 ▼
Bronze / Silver / Gold with Spark
```

The next phase will focus on running these concepts in a modern Data Engineering platform.

```text
Current Project
      │
      ▼
Databricks
      │
      ▼
Delta Lake
      │
      ▼
Cloud Storage
      │
      ▼
Orchestration
      │
      ▼
Production-style Data Pipeline
```

Future learning goals:

- Databricks
- Spark notebooks
- Delta Lake
- Lakehouse Architecture
- Cloud storage
- Pipeline orchestration
- Scheduled pipelines
- Monitoring
- End-to-end cloud Data Engineering

The objective is to continue evolving the same project while preserving earlier implementations to demonstrate the complete learning journey.

---

# 🛡️ License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more information.
