import pandas as pd
from config import STAGING_DIR

def transform_pipeline():
    """No transformations occur before bronze ingestion."""
    staging_files = [
        "stg_users_data.csv",
        "stg_cards_data.csv",
        "stg_transactions_data.csv",
        "stg_mcc_codes.csv"
    ]

    for file_name in staging_files:
        df = pd.read_csv(STAGING_DIR / file_name)
        print(f"Staging file {file_name} contains {len(df)} records and will be loaded into bronze.raw without transformation.")

if __name__ == "__main__":
    transform_pipeline()