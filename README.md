# 🏗️ Data Warehouse & Analytics Project

Welcome to the **Data Warehouse & Analytics Project**! 🚀

This project demonstrates an end-to-end data warehousing and analytics solution, covering the complete process from ingesting raw source data to building business-ready analytical models.

The project is designed as a **Data Engineering portfolio project** and demonstrates practical experience with **SQL Server, ETL processes, data transformation, data modeling, and the Medallion Architecture**.

---

## 📖 Project Overview

The project covers four main areas:

1. **Data Architecture**  
   Designing a modern data warehouse using the **Medallion Architecture** with Bronze, Silver, and Gold layers.

2. **ETL Pipelines**  
   Extracting, loading, cleaning, and transforming data from multiple source systems.

3. **Data Modeling**  
   Developing fact and dimension tables using a **Star Schema** optimized for analytical queries.

4. **Analytics & Reporting**  
   Creating SQL-based analytical datasets and reports to generate actionable business insights.

### 🎯 Skills Demonstrated

This project demonstrates practical knowledge of:

- SQL Development
- Data Warehousing
- Data Engineering
- ETL / ELT Processes
- Data Cleaning
- Data Transformation
- Data Integration
- Data Modeling
- Star Schema Design
- Data Quality Testing
- Data Analytics

---

## 🚀 Project Requirements

### Data Engineering — Building the Data Warehouse

#### Objective

Develop a modern data warehouse using **SQL Server** to consolidate sales data from multiple source systems and prepare it for analytical reporting and informed decision-making.

#### Specifications

- **Data Sources:** Import data from two source systems (**ERP and CRM**) provided as CSV files.
- **Data Quality:** Clean and resolve data quality issues before analysis.
- **Integration:** Combine both sources into a single, user-friendly analytical data model.
- **Scope:** Focus on the latest available dataset; historization is not required.
- **Documentation:** Provide clear documentation of the data model for both technical and business users.

---

### Analytics & Reporting

#### Objective

Develop SQL-based analytics to provide insights into:

- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

The goal is to transform the processed data into meaningful business information that can support data-driven decision-making.

---

## 🛠️ Tech Stack

The main technologies and tools used in this project are:

- **SQL Server** — Data warehouse and database engine
- **T-SQL** — Data transformation, cleaning, modeling, and analytical queries
- **SQL Server Management Studio (SSMS)** — Database development and management
- **CSV Files** — Source data from ERP and CRM systems
- **Draw.io** — Architecture, data flow, and data model diagrams
- **Git & GitHub** — Version control and project documentation

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture**, consisting of three layers:

**Bronze → Silver → Gold**

Each layer has a specific responsibility within the data pipeline.

### 📥 Source Systems

The source data originates from two operational systems:

- **CRM**
- **ERP**

**Source format:** CSV Files  
**Interface:** Files stored in folders

---

### 🥉 Bronze Layer — Raw Data

The Bronze layer stores the source data **as-is**, without transformations.

Data from the CRM and ERP CSV files is loaded into SQL Server tables.

**Object Type:** Tables

**Load Strategy:**
- Batch Processing
- Full Load
- Truncate & Insert

**Transformations:** None

**Data Model:** None (as-is)

**Purpose:**  
Preserve the original source data and create a reliable starting point for further processing.

---

### 🥈 Silver Layer — Cleaned & Standardized Data

The Silver layer contains cleaned, standardized, and validated data.

**Object Type:** Tables

**Load Strategy:**
- Batch Processing
- Full Load
- Truncate & Insert

**Transformations:**
- Data Cleansing
- Data Standardization
- Data Normalization
- Derived Columns
- Data Enrichment
- Handling Missing Values
- Removing Duplicates
- Data Type Validation

**Data Model:** None (as-is)

**Purpose:**  
Improve data quality and prepare the source data for integration and analytical modeling.

---

### 🥇 Gold Layer — Business-Ready Data

The Gold layer contains business-ready data optimized for analytics and reporting.

**Object Type:** Views

**Load Strategy:** No physical load required for views

**Transformations:**
- Data Integration
- Business Logic
- Aggregations
- Joins between CRM and ERP data

**Data Model:**
- Star Schema
- Fact Tables
- Dimension Tables
- Aggregated Views

**Purpose:**  
Provide clean and structured datasets that can be consumed directly by reporting and analytics tools.

---

## 🔄 Data Flow

The overall data flow of the project is:

```text
CRM CSV Files ──┐
                │
                ▼
            🥉 Bronze
            Raw Data
                │
ERP CSV Files ──┘
                │
                ▼
            🥈 Silver
      Cleaned & Standardized
                │
                ▼
             🥇 Gold
        Business-Ready Data
                │
                ▼
        📊 Analytics & Reporting
```

In summary:

```text
Source Systems → Bronze → Silver → Gold → Analytics
```

---

## ⭐ Data Model

The Gold layer uses a **Star Schema** to organize business-ready data.

The model separates data into:

- **Fact Tables** — Store measurable business events such as sales transactions.
- **Dimension Tables** — Store descriptive information such as customers and products.

This structure improves readability and makes analytical queries easier to develop and maintain.

Example:

```text
              dim_customers
                    │
                    │
                    ▼
dim_products ──► fact_sales
                    ▲
                    │
                 dim_date
```

---

## 📊 Data Consumption

The Gold layer can be consumed by:

- BI & Reporting Tools
- Ad-Hoc SQL Queries
- Business Analytics
- Dashboards
- Machine Learning Applications

---

## 📂 Repository Structure

```text
data-warehouse-project/
│
├── datasets/                          # Raw ERP and CRM datasets
│
├── docs/                              # Project documentation and architecture
│   ├── etl.drawio                     # ETL process documentation
│   ├── data_architecture.drawio       # Data warehouse architecture
│   ├── data_catalog.md                # Dataset and column documentation
│   ├── data_flow.drawio               # Data flow diagram
│   ├── data_models.drawio             # Star schema and data models
│   └── naming-conventions.md          # Naming standards
│
├── scripts/                           # SQL scripts
│   ├── bronze/                        # Raw data ingestion scripts
│   ├── silver/                        # Data cleaning and transformation scripts
│   └── gold/                          # Analytical model and view scripts
│
├── tests/                             # Data quality and validation tests
│
├── README.md                          # Project documentation
├── LICENSE                            # License information
├── .gitignore                         # Git ignored files
└── requirements.txt                   # Project dependencies
```

---

## 🔍 Data Quality

Data quality checks are performed throughout the transformation process.

Examples include:

- Checking for duplicate records
- Detecting NULL values
- Validating primary keys
- Standardizing categorical values
- Validating date ranges
- Checking data consistency between ERP and CRM systems
- Validating relationships between fact and dimension tables

These checks help ensure that only reliable and consistent data reaches the Gold layer.

---

## 📈 Analytics

The final analytical layer can be used to answer business questions related to:

### Customer Analysis
- Who are the most valuable customers?
- How does customer behavior change over time?
- Which customer groups generate the most revenue?

### Product Analysis
- Which products generate the most sales?
- Which product categories perform best?
- How does product performance change over time?

### Sales Analysis
- How are sales developing over time?
- What are the main sales trends?
- Which periods generate the highest revenue?

---

## 🧠 Key Concepts Demonstrated

Through this project, I demonstrate practical understanding of:

- Medallion Architecture
- Data Warehouse Design
- ETL Pipelines
- SQL Stored Procedures
- Data Cleaning & Transformation
- Data Integration
- Fact & Dimension Modeling
- Star Schema
- Data Quality Validation
- Analytical SQL
- Git Version Control
- Technical Documentation

---

## 🛡️ License

This project is licensed under the **LICENSE** included in this repository.

You are free to use, modify, and share this project in accordance with the license terms.
