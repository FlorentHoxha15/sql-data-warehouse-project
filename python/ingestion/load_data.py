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

logging.info("Pipeline started")


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
# Extract Currency Data
# =============================================

try:
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
    logging.info("Number of records: %s", len(data))


    # =============================================
    # Save Raw JSON
    # =============================================

    with open(RAW_FILE, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4)

    logging.info("Raw currency data saved successfully")


    # =============================================
    # Load Data into Pandas
    # =============================================

    df = pd.read_json(RAW_FILE)

    logging.info("Currency data loaded into Pandas")


    # =============================================
    # Data Quality Checks
    # =============================================

    logging.info("Null values:\n%s", df.isnull().sum())
    logging.info("Duplicate rows: %s", df.duplicated().sum())
    logging.info("Data types:\n%s", df.dtypes)


    # =============================================
    # Database Connection
    # =============================================

    engine = create_engine(DATABASE_URL)

    with engine.connect():
        logging.info("Database connection successful")


    # =============================================
    # Load Data into Bronze
    # =============================================

    df.to_sql(
        "api_currency_rates",
        con=engine,
        schema="bronze",
        if_exists="append",
        index=False
    )

    logging.info("Currency data loaded into Bronze successfully")


    # =============================================
    # Load Data into Silver
    # =============================================

    with engine.begin() as connection:
        connection.execute(
            text("EXEC silver.load_api_currency_rates")
        )

    logging.info("Currency data loaded into Silver successfully")
    logging.info("Pipeline completed successfully")


except requests.RequestException as error:
    logging.error("Currency API extraction failed: %s", error)

except Exception as error:
    logging.exception("Pipeline failed: %s", error)