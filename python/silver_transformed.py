import sys
from pathlib import Path
from config import STAGING_DIR, PROCESSED_DIR

import pandas as pd

# sys.path.append(str(Path(__file__).resolve().parent))

# try:
#     from .config import STAGING_DIR, PROCESSED_DIR
# except ImportError:  # pragma: no cover - allows direct script execution
#     from config import STAGING_DIR, PROCESSED_DIR


# def strip_string_columns(df: pd.DataFrame) -> pd.DataFrame:
#     string_columns = df.select_dtypes(include=["object", "string"]).columns
#     for col in string_columns:
#         df[col] = df[col].apply(lambda x: x.strip() if isinstance(x, str) else x)
#     return df

def transform_users():
    df = pd.read_csv(STAGING_DIR / "stg_users_data.csv")

    # df = strip_string_columns(df)
    df["gender"] = df["gender"].astype(str).str.upper().replace({"M": "Male", 
                                                                 "MALE": "Male", 
                                                                 "F": "Female", 
                                                                 "FEMALE": "Female"})
    df["latitude"] = pd.to_numeric(df["latitude"], errors="coerce")
    df["longitude"] = pd.to_numeric(df["longitude"], errors="coerce")

    for col in ["per_capita_income", "yearly_income", "total_debt"]:
        df[col] = df[col].replace(r'[\$,]', '', regex=True).astype(float)
        df[col] = pd.to_numeric(df[col], errors="coerce")
        df[col] = df[col].abs()

    for col in ["client_id", "current_age", "retirement_age", "birth_year", "birth_month", "credit_score", "num_credit_cards"]:
        df[col] = pd.to_numeric(df[col], errors="coerce", downcast="integer")
        if col in ["current_age", "retirement_age", "birth_year", "birth_month", "credit_score"]:
            df[col] = df[col].abs()

    df.to_csv(PROCESSED_DIR / "clean_users.csv", index=False)
    return df


def transform_cards():
    df = pd.read_csv(STAGING_DIR / "stg_cards_data.csv")

    # df = strip_string_columns(df)
    df["card_brand"] = df["card_brand"].astype(str).str.upper()
    df["card_type"] = df["card_type"].astype(str).str.upper()
    df["has_chip"] = df["has_chip"].astype(str).str.upper().replace({"Y": "YES", 
                                                                     "YES": "YES", 
                                                                     "N": "NO", 
                                                                     "NO": "NO"})

    df["credit_limit"] = df["credit_limit"].replace(r'[\$,]', '', regex=True).astype(float)
    df["credit_limit"] = pd.to_numeric(df["credit_limit"], errors="coerce").abs()

    for col in ["card_id", "client_id", "cvv", "num_cards_issued", "year_pin_last_changed"]:
        df[col] = pd.to_numeric(df[col], errors="coerce", downcast="integer")

    # for date_col in ['expires', 'acct_open_date']:
    #     parsed = pd.to_datetime(df[date_col], format="%m/%d/%y", errors="coerce")
    #     df[date_col] = parsed.dt.strftime('%m/%d/%y')

    df.to_csv(PROCESSED_DIR / "clean_cards.csv", index=False)
    return df


def transform_transactions():
    df = pd.read_csv(STAGING_DIR / "stg_transactions_data.csv")

    # df = strip_string_columns(df)
    # df["date"] = pd.to_datetime(df["date"], format='%m/%d/%y %H:%M', errors="coerce")
    # df["errors"] = df["errors"].replace({"": None})
    df["merchant_city"] = df["merchant_city"].astype(str).str.upper()
    df["merchant_state"] = df["merchant_state"].astype(str).str.upper()

    numeric_cols = ["transaction_id", "client_id", "card_id", "amount", "merchant_id", "mcc_id"]
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    # df["zip"] = df["zip"].astype(str).str.strip()
    # df["zip"] = df["zip"].replace({"nan": None, "": None})
    # df["date"] = pd.to_datetime(df['date'], format='%m/%d/%y %H:%M')

    df.to_csv(PROCESSED_DIR / "clean_transactions.csv", index=False)
    return df


def transform_mcc():
    df = pd.read_csv(STAGING_DIR / "stg_mcc_codes.csv")

    # df = strip_string_columns(df)
    df["mcc_id"] = pd.to_numeric(df["mcc_id"], errors="coerce", downcast="integer")
    df["Description"] = df["Description"].replace({"": None})

    df.to_csv(PROCESSED_DIR / "clean_mcc.csv", index=False)
    return df


def transform_all():
    transform_users()
    transform_cards()
    transform_transactions()
    transform_mcc()


if __name__ == "__main__":
    transform_all()


