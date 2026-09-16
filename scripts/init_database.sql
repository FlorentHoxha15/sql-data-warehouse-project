/*
Create Databse and Schemas
This script creates a new database named 'DataWarehouse'
The script sets up three schemas within the database: 'bronze', 'silver', 'gold'.
*/

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
