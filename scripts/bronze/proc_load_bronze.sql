/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Purpose:
    This stored procedure loads raw data from external CRM and ERP CSV files
    into the tables of the 'bronze' schema.

Actions performed:
    - Truncates each Bronze table before loading new data.
    - Loads the CSV files using BULK INSERT.
    - Records and displays the loading duration for each table.
    - Records and displays the total Bronze-layer loading duration.
    - Captures and reports errors that occur during execution.

Load strategy:
    - Batch processing
    - Full load
    - Truncate and insert

Parameters:
    None.

Usage:
    EXEC bronze.load_bronze;

Important:
    The file paths used by BULK INSERT are specific to the local environment.
    Update these paths when running the project on another computer.

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    -- Individual table loading times
    DECLARE
        @start_time DATETIME,
        @end_time   DATETIME;

    -- Total Bronze-layer loading time
    DECLARE
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY

        /*======================================================================
          Start Bronze-layer loading
        ======================================================================*/

        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';


        /*======================================================================
          Load CRM tables
        ======================================================================*/

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';


        /*----------------------------------------------------------------------
          Load CRM Customer Information
        ----------------------------------------------------------------------*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Loading data into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '------------------------------------------------';


        /*----------------------------------------------------------------------
          Load CRM Product Information
        ----------------------------------------------------------------------*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Loading data into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '------------------------------------------------';


        /*----------------------------------------------------------------------
          Load CRM Sales Details
        ----------------------------------------------------------------------*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Loading data into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '------------------------------------------------';


        /*======================================================================
          Load ERP tables
        ======================================================================*/

        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';


        /*----------------------------------------------------------------------
          Load ERP Customer Information
        ----------------------------------------------------------------------*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Loading data into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '------------------------------------------------';


        /*----------------------------------------------------------------------
          Load ERP Customer Locations
        ----------------------------------------------------------------------*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Loading data into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '------------------------------------------------';


        /*----------------------------------------------------------------------
          Load ERP Product Categories
        ----------------------------------------------------------------------*/

        SET @start_time = GETDATE();

        PRINT '>> Truncating table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Loading data into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\flore\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10))
            + ' seconds';

        PRINT '------------------------------------------------';


        /*======================================================================
          Complete Bronze-layer loading
        ======================================================================*/

        SET @batch_end_time = GETDATE();

        PRINT '================================================';
        PRINT 'Bronze Layer Loading Completed';

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
        PRINT 'Error While Loading the Bronze Layer';
        PRINT '>> Error number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT '>> Error message: '
            + ERROR_MESSAGE();
        PRINT '================================================';

        THROW;

    END CATCH;
END;
GO
