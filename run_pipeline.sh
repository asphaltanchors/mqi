#!/bin/bash

# Set file paths for Meltano pipeline
# Edit these paths as needed for your environment
export CUSTOMERS_FILE_PATH="/Users/oren/Dropbox-AAC/AAC/Oren/CSV/customers_all.csv"
# export CUSTOMERS_FILE_PATH="sample-data/customers_daily.csv"
export INVOICES_FILE_PATH="sample-data/invoice_daily.csv"
export SALES_RECEIPTS_FILE_PATH="sample-data/sales_daily.csv"

# Optional: Print the paths for verification
echo "Using the following file paths:"
echo "Customers: $CUSTOMERS_FILE_PATH"
echo "Invoices: $INVOICES_FILE_PATH"
echo "Sales Receipts: $SALES_RECEIPTS_FILE_PATH"

# Run the Meltano pipeline
meltano run tap-csv target-postgres

# Optional: Add dbt transformations if needed
# meltano run tap-csv target-postgres dbt-postgres:run
