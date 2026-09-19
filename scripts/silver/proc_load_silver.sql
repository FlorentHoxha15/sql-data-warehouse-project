/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================

Purpose:
    This stored procedure loads, cleans, standardizes, and transforms data from
    the Bronze layer into the Silver layer.

Actions performed:
    - Truncates each Silver table before loading new data.
    - Removes duplicate customer records.
    - Trims unnecessary spaces from text values.
    - Standardizes marital status, gender, product lines, and country names.
    - Replaces missing or invalid values.
    - Converts source dates into valid DATE values.
    - Corrects inconsistent sales and price values.
    - Creates product validity periods.
    - Records the loading duration of each table and the complete batch.
    - Captures and reports errors that occur during execution.

Load strategy:
    - Batch processing
    - Full load
    - Truncate and insert

Parameters:
    None.

Usage:
    EXEC silver.load_silver;

===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    -- Individual table loading times
    DECLARE
        @start_time DATETIME,
        @end_time   DATETIME;

    -- Total Silver-layer loading time
    DECLARE
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY

        /*======================================================================
          Start Silver-layer loading
        ======================================================================*/

        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';


        /*======================================================================
          1. Load CRM Customer Information
        ======================================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading: silver.crm_cust_info';
        PRINT '------------------------------------------------';

        PRINT '>> Truncating table: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Loading data into: silver.crm_cust_info';

        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_material_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,

            -- Remove unnecessary spaces from customer names
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname)  AS cst_lastname,

            -- Standardize marital-status values
            CASE
                WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_material_status,

            -- Standardize gender values
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,

            cst_create_date

        FROM (
            -- Keep the most recent record for each customer
            SELECT
                *,
                ROW_NUMBER() OVER (
                    PARTITION BY cst_id
                    ORDER BY cst_create_date DESC
                ) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) AS latest_customer
        WHERE flag_last = 1;

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';


        /*======================================================================
          2. Load CRM Product Information
        ======================================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading: silver.crm_prd_info';
        PRINT '------------------------------------------------';

        PRINT '>> Truncating table: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Loading data into: silver.crm_prd_info';

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,

            -- Extract and standardize the product category identifier
            REPLACE(
                SUBSTRING(prd_key, 1, 5),
                '-',
                '_'
            ) AS cat_id,

            -- Extract the product identifier from the source key
            SUBSTRING(
                prd_key,
                7,
                LEN(prd_key)
            ) AS prd_key,

            prd_nm,

            -- Replace missing product costs with zero
            ISNULL(prd_cost, 0) AS prd_cost,

            -- Convert abbreviated product-line values into readable values
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,

            CAST(prd_start_dt AS DATE) AS prd_start_dt,

            -- End each historical version one day before the next version
            DATEADD(
                DAY,
                -1,
                LEAD(prd_start_dt) OVER (
                    PARTITION BY prd_key
                    ORDER BY prd_start_dt
                )
            ) AS prd_end_dt

        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';


        /*======================================================================
          3. Load CRM Sales Details
        ======================================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading: silver.crm_sales_details';
        PRINT '------------------------------------------------';

        PRINT '>> Truncating table: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Loading data into: silver.crm_sales_details';

        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,

            -- Convert valid YYYYMMDD values into DATE values
            CASE
                WHEN sls_order_dt = '0'
                  OR LEN(sls_order_dt) <> 8
                THEN NULL
                ELSE TRY_CONVERT(DATE, sls_order_dt, 112)
            END AS sls_order_dt,

            CASE
                WHEN sls_ship_dt = '0'
                  OR LEN(sls_ship_dt) <> 8
                THEN NULL
                ELSE TRY_CONVERT(DATE, sls_ship_dt, 112)
            END AS sls_ship_dt,

            CASE
                WHEN sls_due_dt = '0'
                  OR LEN(sls_due_dt) <> 8
                THEN NULL
                ELSE TRY_CONVERT(DATE, sls_due_dt, 112)
            END AS sls_due_dt,

            -- Recalculate sales when the source value is missing or incorrect
            CASE
                WHEN sls_sales IS NULL
                  OR sls_sales <= 0
                  OR sls_sales <> sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,

            sls_quantity,

            -- Recalculate price when the source value is missing or invalid
            CASE
                WHEN sls_price IS NULL
                  OR sls_price <= 0
                THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price

        FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';


        /*======================================================================
          4. Load ERP Customer Information
        ======================================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading: silver.erp_cust_az12';
        PRINT '------------------------------------------------';

        PRINT '>> Truncating table: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Loading data into: silver.erp_cust_az12';

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            -- Remove the NAS prefix to align ERP and CRM customer identifiers
            CASE
                WHEN cid LIKE 'NAS%'
                THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid,

            -- Replace future birthdates with NULL
            CASE
                WHEN bdate > GETDATE()
                THEN NULL
                ELSE bdate
            END AS bdate,

            -- Standardize gender values
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
                ELSE 'n/a'
            END AS gen

        FROM bronze.erp_cust_az12;

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';


        /*======================================================================
          5. Load ERP Customer Locations
        ======================================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading: silver.erp_loc_a101';
        PRINT '------------------------------------------------';

        PRINT '>> Truncating table: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Loading data into: silver.erp_loc_a101';

        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            -- Remove hyphens to align ERP and CRM customer identifiers
            REPLACE(cid, '-', '') AS cid,

            -- Standardize country values
            CASE
                WHEN TRIM(cntry) = 'DE'
                    THEN 'Germany'
                WHEN TRIM(cntry) IN ('US', 'USA')
                    THEN 'United States'
                WHEN TRIM(cntry) = ''
                  OR cntry IS NULL
                    THEN 'n/a'
                ELSE TRIM(cntry)
            END AS cntry

        FROM bronze.erp_loc_a101;

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';


        /*======================================================================
          6. Load ERP Product Categories
        ======================================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading: silver.erp_px_cat_g1v2';
        PRINT '------------------------------------------------';

        PRINT '>> Truncating table: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Loading data into: silver.erp_px_cat_g1v2';

        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2;

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';


        /*======================================================================
          Complete Silver-layer loading
        ======================================================================*/

        SET @batch_end_time = GETDATE();

        PRINT '================================================';
        PRINT 'Silver Layer Loading Completed';

        PRINT '>> Total load duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @batch_start_time,
                    @batch_end_time
                ) AS NVARCHAR(10)
            )
            + ' seconds';

        PRINT '================================================';

    END TRY

    BEGIN CATCH

        /*======================================================================
          Error handling
        ======================================================================*/

        PRINT '================================================';
        PRINT 'Error While Loading the Silver Layer';
        PRINT '>> Error number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT '>> Error line: '
            + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT '>> Error message: '
            + ERROR_MESSAGE();
        PRINT '================================================';

        THROW;

    END CATCH;
END;
GO
