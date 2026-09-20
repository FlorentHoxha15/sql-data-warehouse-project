# 🏗️ SQL Data Warehouse Project

Welcome to my **SQL Data Warehouse Project**! 🚀

This project demonstrates the design and implementation of a modern data warehouse using **SQL Server**.

The project follows the **Medallion Architecture**, transforming raw ERP and CRM data through **Bronze, Silver, and Gold layers** into clean, structured, and business-ready datasets for analytics and reporting.

---

## 📖 Project Overview

This project covers the complete data warehouse development process:

1. **Data Architecture**  
   Designing a data warehouse using the **Bronze, Silver, and Gold** layers.

2. **Data Ingestion**  
   Loading raw ERP and CRM data from CSV files into SQL Server.

3. **Data Transformation**  
   Cleaning, standardizing, and transforming raw data into reliable datasets.

4. **Data Modeling**  
   Creating fact and dimension tables using a **Star Schema**.

5. **Analytics**  
   Preparing business-ready data for SQL analysis and reporting.

---

## 🎯 Project Objectives

The main objective is to build a modern data warehouse that consolidates sales data from two different source systems.

### Requirements

- Import data from **ERP and CRM** source systems.
- Load CSV files into SQL Server.
- Clean and standardize the source data.
- Resolve data quality issues.
- Integrate data from multiple sources.
- Create business-ready fact and dimension tables.
- Build a **Star Schema** for analytical queries.
- Prepare the data for reporting and analytics.

---

## 🛠️ Technologies Used

- **SQL Server**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**
- **CSV Files**
- **Medallion Architecture**
- **Git**
- **GitHub**

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture**:

```text
ERP & CRM
    │
    ▼
🥉 Bronze
Raw Data
    │
    ▼
🥈 Silver
Cleaned & Standardized Data
    │
    ▼
🥇 Gold
Business-Ready Data
    │
    ▼
📊 Analytics & Reporting
```

---

## 🥉 Bronze Layer

The Bronze layer stores the raw source data.

Data from the ERP and CRM CSV files is loaded into SQL Server without applying business transformations.

**Object Type:** Tables

**Load Strategy:**
- Batch Processing
- Full Load
- Truncate & Insert

**Transformations:** None

**Purpose:**  
Preserve the source data in its original form before further processing.

---

## 🥈 Silver Layer

The Silver layer contains cleaned and standardized data.

Transformations include:

- Data Cleaning
- Data Standardization
- Data Normalization
- Handling Missing Values
- Removing Duplicates
- Data Type Validation
- Derived Columns
- Data Enrichment

**Object Type:** Tables

**Load Strategy:**
- Batch Processing
- Full Load
- Truncate & Insert

**Purpose:**  
Improve data quality and prepare the data for integration and analytical modeling.

---

## 🥇 Gold Layer

The Gold layer contains business-ready data used for analytics and reporting.

Data from the Silver layer is integrated and modeled into **fact and dimension tables**.

**Object Type:** Views

**Transformations:**
- Data Integration
- Business Logic
- Joins
- Aggregations

**Data Model:**
- Star Schema
- Fact Tables
- Dimension Tables

**Purpose:**  
Provide structured and business-friendly datasets optimized for analytical queries.

---

## ⭐ Data Modeling

The Gold layer follows a **Star Schema**.

The model separates data into:

- **Fact Tables** — measurable business events such as sales.
- **Dimension Tables** — descriptive information such as customers and products.

Example:

```text
             dim_customers
                   │
                   ▼
dim_products ──► fact_sales
```

This structure makes analytical SQL queries easier to write and improves the usability of the data warehouse.

---

## 📊 Analytics

The Gold layer can be used to analyze:

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

---

## 📂 Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/                 # Raw ERP and CRM datasets
│
├-- docs/                     # Project documentation and architecture details
│
├── scripts/                  # SQL scripts for the data warehouse
│
├── LICENSE                   # MIT License
└── README.md                 # Project documentation
```

### `datasets/`

Contains the raw CSV datasets from the **ERP and CRM source systems**.

### `docs/`

Contains documentation and diagrams related to the data warehouse architecture, data flow, and data modeling.

### `scripts/`

Contains the SQL scripts used to build and transform the data warehouse.

The scripts are organized around the different stages of the Medallion Architecture:

```text
scripts/
│
├── bronze/       # Raw data ingestion
├── silver/       # Data cleaning and transformation
└── gold/         # Business-ready analytical models
```

---

## 🔄 ETL Process

The project follows this general data pipeline:

```text
CSV Files
   ↓
SQL Server
   ↓
Bronze Layer
   ↓
Silver Layer
   ↓
Gold Layer
   ↓
Analytics
```

### Extract

ERP and CRM data is extracted from CSV files.

### Load

The raw data is loaded into the **Bronze layer**.

### Transform

The data is cleaned, standardized, validated, and enriched in the **Silver layer**.

### Model

The transformed data is integrated into fact and dimension models in the **Gold layer**.

---

## 🧠 Skills Demonstrated

This project demonstrates practical experience with:

- SQL Development
- Data Engineering
- Data Warehousing
- ETL Processes
- Data Cleaning
- Data Transformation
- Data Integration
- Medallion Architecture
- Fact & Dimension Modeling
- Star Schema Design
- Analytical SQL
- Git & GitHub
- Technical Documentation

---

## 🛡️ License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more information.
