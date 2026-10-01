import json
import logging

import pandas as pd
import requests
from sqlalchemy import create_engine, text


# =============================================
# Logging Configuration
# =============================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)


# =============================================
# Configuration
# =============================================

START_DATE = "2010-12-29"
END_DATE = "2014-01-28"

API_URL = "https://api.frankfurter.dev/v2/rates"
RAW_FILE = "datasets/source_api/currency_raw.json"

DATABASE_URL = (
    "mssql+pyodbc://localhost\\MSSQLSERVER01/DataWarehouse"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
    "&TrustServerCertificate=yes"
)


# =============================================
# Database
# =============================================

def create_database_engine():
    engine = create_engine(DATABASE_URL)
    return engine


def test_database_connection(engine):
    with engine.connect():
        logging.info("Database connection successful")


# =============================================
# Extract
# =============================================

def extract_currency_data():
    response = requests.get(
        API_URL,
        params={
            "base": "eur",
            "quotes": "usd,gbp,chf",
            "from": START_DATE,
            "to": END_DATE
        },
        timeout=30
    )

    response.raise_for_status()

    data = response.json()

    logging.info("Currency data extracted successfully")
    logging.info("Number of extracted records: %s", len(data))

    return data


# =============================================
# Save Raw Data
# =============================================

def save_raw_data(data):
    with open(RAW_FILE, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4)

    logging.info("Raw currency data saved successfully")


# =============================================
# Create DataFrame
# =============================================

def create_dataframe(data):
    df = pd.DataFrame(data)
    return df


# =============================================
# Data Preparation
# =============================================

def convert_date_column(df):
    df["date"] = pd.to_datetime(df["date"])
    return df


# =============================================
# Data Quality Checks
# =============================================

def check_null_values(df):
    null_values = df.isnull().sum()
    return null_values


def check_duplicates(df):
    duplicate_count = df.duplicated().sum()
    return duplicate_count


def check_data_types(df):
    data_types = df.dtypes
    return data_types


def check_invalid_rates(df):
    invalid_rates = df[df["rate"] <= 0]
    return invalid_rates


# =============================================
# Incremental Loading
# =============================================

def get_watermark(engine):
    query = """
        SELECT MAX(date) AS watermark
        FROM bronze.api_currency_rates
    """

    result = pd.read_sql(query, engine)
    watermark = result["watermark"][0]

    return watermark


def filter_new_data(df, watermark):
    if pd.isna(watermark):
        new_data = df
    else:
        new_data = df[df["date"] > watermark]

    return new_data


def check_new_data(new_data):
    if new_data.empty:
        logging.info("No new data available")
        return False

    return True


# =============================================
# Load Bronze
# =============================================

def load_bronze(new_data, engine):
    new_data.to_sql(
        "api_currency_rates",
        con=engine,
        schema="bronze",
        if_exists="append",
        index=False
    )

    logging.info(
        "%s records loaded into Bronze successfully",
        len(new_data)
    )


# =============================================
# Load Silver
# =============================================

def load_silver(engine):
    with engine.begin() as connection:
        connection.execute(
            text("EXEC silver.load_api_currency_rates")
        )

    logging.info("Silver stored procedure executed successfully")


# =============================================
# Main Pipeline
# =============================================

def main():
    try:
        logging.info("Pipeline started")

        # Database
        engine = create_database_engine()
        test_database_connection(engine)

        # Extract
        data = extract_currency_data()

        # Raw storage
        save_raw_data(data)

        # DataFrame
        df = create_dataframe(data)
        df = convert_date_column(df)

        # Data quality
        null_values = check_null_values(df)
        duplicate_count = check_duplicates(df)
        data_types = check_data_types(df)
        invalid_rates = check_invalid_rates(df)

        logging.info("Null values:\n%s", null_values)
        logging.info("Duplicate rows: %s", duplicate_count)
        logging.info("Data types:\n%s", data_types)

        if not invalid_rates.empty:
            logging.error(
                "Pipeline stopped: %s invalid rate(s) found",
                len(invalid_rates)
            )
            return

        # Incremental loading
        watermark = get_watermark(engine)

        logging.info("Current watermark: %s", watermark)

        new_data = filter_new_data(df, watermark)

        if not check_new_data(new_data):
            logging.info("Pipeline completed - no new records to process")
            return

        logging.info(
            "%s new records detected",
            len(new_data)
        )

        # Bronze
        load_bronze(new_data, engine)

        # Silver
        load_silver(engine)

        logging.info("Pipeline completed successfully")

    except requests.RequestException as error:
        logging.error(
            "Currency API extraction failed: %s",
            error
        )

    except Exception as error:
        logging.exception(
            "Pipeline failed: %s",
            error
        )


# =============================================
# Run Pipeline
# =============================================

if __name__ == "__main__":
    main()
