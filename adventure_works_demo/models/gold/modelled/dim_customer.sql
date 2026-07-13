{{ config(
    materialized='incremental',
    unique_key='CustomerKey',
    on_schema_change='append_new_columns'
) }}

select
    customer.CustomerKey,
    customer.NameStyle,
    customer.Title,
    customer.FirstName,
    customer.MiddleName,
    customer.LastName,
    customer.Suffix,
    customer.EmailAddress,
    customer.Phone,
FROM {{ ref('customer') }} customer