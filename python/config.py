import os
from pathlib import Path

# File System Paths
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
RAW_DIR = DATA_DIR / "raw"
STAGING_DIR = DATA_DIR / "staging"
PROCESSED_DIR = DATA_DIR / "cleaned"

# Database Configuration (SQL Server Express)
DB_CONFIG = {
    "data_source": r".\SQLEXPRESS",
    "integrated_security": True,
    "persist_security_info": False,
    "pooling": False,
    "multiple_active_result_sets": False,
    "encrypt": True,
    "trust_server_certificate": True,
    "application_name": "SQL Server Management Studio",
    "command_timeout": 0
}

CONN_STR = (
    r"Data Source=.\SQLEXPRESS;"
    r"Integrated Security=True;"
    r"Persist Security Info=False;"
    r"Pooling=False;"
    r"MultipleActiveResultSets=False;"
    r"Encrypt=True;"
    r"TrustServerCertificate=True;"
    r"Application Name=SQL Server Management Studio;"
    r"Command Timeout=0"
)

# Ensure directories exist
for folder in [RAW_DIR, STAGING_DIR, PROCESSED_DIR]:
    folder.mkdir(parents=True, exist_ok=True)