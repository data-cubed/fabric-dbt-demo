{{ config(
    materialized='incremental',
    unique_key='ProductId',
    on_schema_change='append_new_columns'
) }}

with product_model as (
    SELECT
        *,
        row_number() OVER (PARTITION BY ProductModelID ORDER BY ModifiedDate desc) as rn
    FROM {{ ref('product_model') }}
),

product_model_product_description as (
    SELECT
        *,
        row_number() OVER (PARTITION BY ProductModelID ORDER BY ModifiedDate desc) as rn
    FROM {{ ref('product_model_product_description') }}
    WHERE trim(Culture) = 'en'
),

product_description as (
    SELECT
        *,
        row_number() OVER (PARTITION BY ProductDescriptionID ORDER BY ModifiedDate desc) as rn
    FROM {{ ref('product_description') }}
),

product_category as (
    SELECT
        *,
        row_number() OVER (PARTITION BY ProductCategoryID ORDER BY ModifiedDate desc) as rn
    FROM {{ ref('product_category') }}
)

SELECT 
    product.ProductID,
    product.Name as ProductName,
    product.Color,
    product.Size,
    product.ListPrice,
    product_model.Name as ProductModelName,
    product_description.Description as ProductDescription,
    product_category.Name as ProductCategoryName,
    product.ModifiedDate
FROM {{ ref('product') }} product
LEFT JOIN product_model
    ON product_model.ProductModelID = product.ProductModelID
    and product_model.rn = 1
LEFT JOIN product_model_product_description
    ON product.ProductModelID = product_model_product_description.ProductModelID
    and product_model_product_description.rn = 1
LEFT JOIN product_description
    ON product_model_product_description.ProductDescriptionID = product_description.ProductDescriptionID
    and product_description.rn = 1
LEFT JOIN product_category
    ON product.ProductCategoryID = product_category.ProductCategoryID
    and product_category.rn = 1

{% if is_incremental() %}
WHERE product.ModifiedDate > (SELECT MAX(ModifiedDate) FROM {{ this }})
{% endif %}