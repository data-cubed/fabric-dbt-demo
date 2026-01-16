{{ config(
    materialized='incremental',
    unique_key='CustomerId',
    on_schema_change='append_new_columns'
) }}

with customer_address as (
    SELECT
        *,
        row_number() OVER (PARTITION BY CustomerID ORDER BY ModifiedDate desc) as rn
    FROM {{ ref('customer_address') }}
),

address as (
    SELECT
        *,
        row_number() OVER (PARTITION BY AddressID ORDER BY ModifiedDate desc) as rn
    FROM {{ ref('address') }}
)

select
    customer.CustomerID,
    customer.NameStyle,
    customer.Title,
    customer.FirstName,
    customer.MiddleName,
    customer.LastName,
    customer.Suffix,
    customer.CompanyName,
    customer.SalesPerson,
    customer.EmailAddress,
    customer.Phone,
    address.AddressLine1,
    address.AddressLine2,
    address.City,
    address.StateProvince,
    address.PostalCode,
    customer.ModifiedDate
FROM {{ ref('customer') }} customer
LEFT JOIN customer_address
    ON customer.CustomerID = customer_address.CustomerID
    and customer_address.rn = 1
LEFT JOIN address
    ON customer_address.AddressID = address.AddressID
    and customer_address.rn = 1
    and address.rn = 1
{% if is_incremental() %}
WHERE customer.ModifiedDate > (SELECT MAX(ModifiedDate) FROM {{ this }})
{% endif %}