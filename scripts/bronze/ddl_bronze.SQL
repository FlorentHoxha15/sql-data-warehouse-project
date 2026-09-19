/*
===============================================================================
DDL Script: Create Bronze Layer Tables
===============================================================================

Purpose:
    This script creates the tables in the 'bronze' schema.

    Existing tables are dropped and recreated to ensure that the Bronze layer
    follows the required structure.

    The Bronze layer stores raw data from the CRM and ERP source systems
    without applying transformations.

Warning:
    Running this script deletes the existing Bronze tables and their data.

===============================================================================
*/


/*==============================================================================
  CRM Customer Information
==============================================================================*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);


/*==============================================================================
  CRM Product Information
==============================================================================*/

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(255),
    prd_cost     DECIMAL(10, 2),
    prd_line     NVARCHAR(10),
    prd_start_dt DATE,
    prd_end_dt   DATE
);


/*==============================================================================
  CRM Sales Details
==============================================================================*/

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt NVARCHAR(8),
    sls_ship_dt  NVARCHAR(8),
    sls_due_dt   NVARCHAR(8),
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);


/*==============================================================================
  ERP Customer Information
==============================================================================*/

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
    CID   NVARCHAR(50),
    BDATE DATE,
    GEN   NVARCHAR(20)
);


/*==============================================================================
  ERP Customer Location
==============================================================================*/

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
    CID   NVARCHAR(50),
    CNTRY NVARCHAR(50)
);


/*==============================================================================
  ERP Product Categories
==============================================================================*/

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID          NVARCHAR(20),
    CAT         NVARCHAR(50),
    SUBCAT      NVARCHAR(100),
    MAINTENANCE NVARCHAR(10)
);
