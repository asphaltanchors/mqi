{{ config(materialized='table') }}

-- Invoices data
WITH invoices AS (
  SELECT
    "QuickBooks Internal Id" as quickbooks_id,
    "Invoice No" as order_number,
    'invoice' as order_type,
    "Class" as class,
    "Terms" as terms,
    "Status" as status,
    "PO Number" as po_number,
    'Invoice' as payment_method,
    TO_DATE("Invoice Date", 'MM-DD-YYYY') as order_date,
    MAX(CAST(NULLIF("Total Amount", '') AS NUMERIC)) as total_amount,  -- Handle empty strings and cast to NUMERIC
    "Customer" as customer_name
  FROM {{ source('raw', 'invoices') }}
  WHERE "QuickBooks Internal Id" != ''
  GROUP BY
    "QuickBooks Internal Id",
    "Invoice No",
    "Class",
    "Terms",
    "Status",
    "PO Number",
    "Invoice Date",
    "Customer"
),

-- Sales Receipts data
sales_receipts AS (
  SELECT
    "QuickBooks Internal Id" as quickbooks_id,
    "Sales Receipt No" as order_number,  
    'sales_receipt' as order_type,
    "Class" as class,
    NULL as terms,
    'Closed' as status,
    NULL as po_number,
    "Payment Method" as payment_method,
    TO_DATE("Sales Receipt Date", 'MM-DD-YYYY') as order_date,
    MAX(CAST(NULLIF("Total Amount", '') AS NUMERIC)) as total_amount,
    "Customer" as customer_name
  FROM {{ source('raw', 'sales_receipts') }}
  WHERE "QuickBooks Internal Id" != ''
  GROUP BY
    "QuickBooks Internal Id",
    "Sales Receipt No",  
    "Sales Receipt Date",
    "Class",
    "Payment Method",
    "Customer"
)

-- Combine both sources
SELECT * FROM invoices
UNION ALL
SELECT * FROM sales_receipts
