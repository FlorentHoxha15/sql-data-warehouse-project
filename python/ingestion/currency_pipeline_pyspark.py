import json
import logging
import requests

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col,
    to_date,
    avg,
    min as spark_min,
    max as spark_max
)


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

BRONZE_PATH = "datasets/bronze/currency_rates"
SILVER_PATH = "datasets/silver/currency_rates"
GOLD_PATH = "datasets/gold/currency_summary"


# =============================================
# Spark Session
# =============================================

def create_spark_session():
    spark = SparkSession.builder \
        .appName("CurrencyPipeline") \
        .getOrCreate()

    return spark


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

    logging.info(
        "Currency data extracted successfully"
    )

    logging.info(
        "Number of extracted records: %s",
        len(data)
    )

    return data


# =============================================
# Save Raw Data
# =============================================

def save_raw_data(data):
    with open(
        RAW_FILE,
        "w",
        encoding="utf-8"
    ) as file:
        json.dump(
            data,
            file,
            indent=4
        )

    logging.info(
        "Raw currency data saved successfully"
    )


# =============================================
# Create Spark DataFrame
# =============================================

def create_dataframe(spark, data):
    df = spark.createDataFrame(data)

    return df


# =============================================
# Data Preparation
# =============================================

def convert_date_column(df):
    df = df.withColumn(
        "date",
        to_date(
            col("date"),
            "yyyy-MM-dd"
        )
    )

    return df


def convert_rate_column(df):
    df = df.withColumn(
        "rate",
        col("rate").cast("double")
    )

    return df


def remove_nulls(df):
    df = df.dropna(
        subset=[
            "date",
            "rate"
        ]
    )

    return df


def remove_duplicates(df):
    df = df.dropDuplicates()

    return df


# =============================================
# Data Quality
# =============================================

def check_invalid_rates(df):
    invalid_rates = df.filter(
        col("rate") <= 0
    )

    return invalid_rates


def check_data_quality(invalid_rates):
    if invalid_rates.count() > 0:
        return False

    return True


# =============================================
# Watermark
# =============================================

def get_watermark(spark):
    try:
        bronze_df = spark.read.parquet(
            BRONZE_PATH
        )

        result = bronze_df.agg(
            spark_max("date").alias(
                "watermark"
            )
        ).collect()

        watermark = result[0]["watermark"]

        return watermark

    except Exception:
        # First pipeline run:
        # Bronze does not exist yet
        return None


# =============================================
# Incremental Loading
# =============================================

def filter_new_data(df, watermark):
    if watermark is None:
        new_data = df

    else:
        new_data = df.filter(
            col("date") > watermark
        )

    return new_data


def check_new_data(new_data):
    if new_data.count() == 0:
        logging.info(
            "No new data available"
        )

        return False

    return True


# =============================================
# Load Bronze
# =============================================

def load_bronze(new_data):
    new_data.write \
        .mode("append") \
        .partitionBy("quote") \
        .parquet(BRONZE_PATH)

    logging.info(
        "%s records loaded into Bronze successfully",
        new_data.count()
    )


# =============================================
# Read Bronze
# =============================================

def read_bronze(spark):
    bronze_df = spark.read.parquet(
        BRONZE_PATH
    )

    return bronze_df


# =============================================
# Transform Silver
# =============================================

def transform_silver(bronze_df):
    silver_df = bronze_df.dropDuplicates()

    silver_df = silver_df.filter(
        col("rate") > 0
    )

    return silver_df


# =============================================
# Load Silver
# =============================================

def load_silver(silver_df):
    silver_df.write \
        .mode("overwrite") \
        .partitionBy("quote") \
        .parquet(SILVER_PATH)

    logging.info(
        "Silver data saved successfully"
    )


# =============================================
# Read Silver
# =============================================

def read_silver(spark):
    silver_df = spark.read.parquet(
        SILVER_PATH
    )

    return silver_df


# =============================================
# Transform Gold
# =============================================

def transform_gold(silver_df):
    gold_df = silver_df.groupBy(
        "quote"
    ).agg(
        avg("rate").alias(
            "average_rate"
        ),

        spark_min("rate").alias(
            "min_rate"
        ),

        spark_max("rate").alias(
            "max_rate"
        )
    )

    return gold_df


# =============================================
# Load Gold
# =============================================

def load_gold(gold_df):
    gold_df.write \
        .mode("overwrite") \
        .parquet(GOLD_PATH)

    logging.info(
        "Gold data saved successfully"
    )


# =============================================
# Main Pipeline
# =============================================

def main():
    try:
        logging.info(
            "Pipeline started"
        )

        # =====================================
        # Spark
        # =====================================

        spark = create_spark_session()


        # =====================================
        # Extract
        # =====================================

        data = extract_currency_data()


        # =====================================
        # Raw Storage
        # =====================================

        save_raw_data(data)


        # =====================================
        # Create Spark DataFrame
        # =====================================

        df = create_dataframe(
            spark,
            data
        )


        # =====================================
        # Data Preparation
        # =====================================

        df = convert_date_column(df)

        df = convert_rate_column(df)

        df = remove_nulls(df)

        df = remove_duplicates(df)


        # =====================================
        # Data Quality
        # =====================================

        invalid_rates = check_invalid_rates(
            df
        )

        if not check_data_quality(
            invalid_rates
        ):
            logging.error(
                "Pipeline stopped: invalid rates found"
            )

            return


        # =====================================
        # Watermark
        # =====================================

        watermark = get_watermark(
            spark
        )

        logging.info(
            "Current watermark: %s",
            watermark
        )


        # =====================================
        # Incremental Processing
        # =====================================

        new_data = filter_new_data(
            df,
            watermark
        )


        if not check_new_data(
            new_data
        ):
            logging.info(
                "Pipeline completed - no new records to process"
            )

            return


        logging.info(
            "%s new records detected",
            new_data.count()
        )


        # =====================================
        # Bronze
        # =====================================

        load_bronze(
            new_data
        )


        # =====================================
        # Bronze → Silver
        # =====================================

        bronze_df = read_bronze(
            spark
        )

        silver_df = transform_silver(
            bronze_df
        )

        load_silver(
            silver_df
        )


        # =====================================
        # Silver → Gold
        # =====================================

        silver_df = read_silver(
            spark
        )

        gold_df = transform_gold(
            silver_df
        )

        load_gold(
            gold_df
        )


        # =====================================
        # Pipeline Completed
        # =====================================

        logging.info(
            "Pipeline completed successfully"
        )


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
