import os
from pathlib import Path

# File System Paths
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
RAW_DIR = DATA_DIR / "raw"
CLEANED_DIR = DATA_DIR / "cleaned"

# Database Configuration (SQL Server Express)
DB_CONFIG = {
    "driver": "ODBC Driver 18 for SQL Server",
    "server": r".\SQLEXPRESS",
    "database": "DB_Aurora_Bank",
    "trusted_connection": "yes",
    "TrustServerCertificate": "yes",
    "Encrypt": "no"
}


CONN_STR = f"DRIVER={DB_CONFIG['driver']};SERVER={DB_CONFIG['server']};DATABASE={DB_CONFIG['database']};Trusted_Connection={DB_CONFIG['trusted_connection']};"

# Ensure directories exist
for folder in [RAW_DIR, CLEANED_DIR]:
    folder.mkdir(parents=True, exist_ok=True)