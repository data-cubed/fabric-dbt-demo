{{ config(
    materialized='incremental',
    unique_key='SalesOrderID',
    on_schema_change='append_new_columns'
) }}

SELECT
    sales_order_detail.SalesOrderNumber,
    sales_order_detail.SalesOrderLineNumber,
    sales_order_detail.RevisionNumber,
    sales_order_detail.CustomerKey,
    sales_order_detail.SalesAmount,
    sales_order_detail.TaxAmt,
    sales_order_detail.OrderDate,
    sales_order_detail.DueDate,
    sales_order_detail.ShipDate,
    sales_order_detail.OrderQuantity,
    sales_order_detail.ProductKey,
    sales_order_detail.UnitPrice,
    sales_order_detail.UnitPriceDiscountPct,
FROM {{ ref('sales_order_header') }} sales_order_header