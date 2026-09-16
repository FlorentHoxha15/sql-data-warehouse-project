/*
Stored Procedure: Load Bronze Layer (Source -> Bronze)
Script Purpose:
  This stored procedure loqds dqtq into the 'bronze' schema from external CSV files.
  It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the BULK INSERT command to load data from csv files to bronze tables.
Parameters:
None.
This stored procedure does not accept any parameters or return any values.

Usage example:
  EXEC bronze.load_bronze;

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    -- Variables for individual table load times
    DECLARE @start_time DATETIME,
            @end_time DATETIME;

    -- Variables for total Bronze Layer load time
    DECLARE @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        -- =============================================
        -- START TIMER FOR ENTIRE BRONZE LAYER
        -- =============================================

        SET @batch_start_time = GETDATE();

        PRINT '====================';
        PRINT 'Loading Bronze Layer';
        PRINT '====================';


        -- =============================================
        -- LOAD CRM TABLES
        -- =============================================

        PRINT '---------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------';


        -- =============================================
        -- LOAD CRM CUSTOMER INFO
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------------------';


        -- =============================================
        -- LOAD CRM PRODUCT INFO
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------------------';


        -- =============================================
        -- LOAD CRM SALES DETAILS
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------------------';


        -- =============================================
        -- LOAD ERP TABLES
        -- =============================================

        PRINT '---------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------';


        -- =============================================
        -- LOAD ERP CUSTOMER
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_az12';

        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------------------';


        -- =============================================
        -- LOAD ERP LOCATION
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';

        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------------------';


        -- =============================================
        -- LOAD ERP PRODUCT CATEGORY
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------------------';


        -- =============================================
        -- STOP TIMER FOR ENTIRE BRONZE LAYER
        -- =============================================

        SET @batch_end_time = GETDATE();

        PRINT '=================================';
        PRINT 'BRONZE LAYER LOADING COMPLETED';

        PRINT '>> Total Bronze Load Duration: '
            + CAST(
                DATEDIFF(
                    SECOND,
                    @batch_start_time,
                    @batch_end_time
                )
                AS NVARCHAR
            )
            + ' seconds';

        PRINT '=================================';

    END TRY


    -- =============================================
    -- ERROR HANDLING
    -- =============================================

    BEGIN CATCH

        PRINT '=================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';

        PRINT 'Error Message: '
            + ERROR_MESSAGE();

        PRINT 'Error Number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR);

        PRINT '=================================';

    END CATCH

END;
