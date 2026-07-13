{{ config(
    materialized='incremental',
    unique_key='ProductKey',
    on_schema_change='append_new_columns'
) }}

SELECT 
    product.ProductKey,
    product.EnglishProductName as ProductName,
    product.Color,
    product.Size,
    product.ListPrice,
    product.ModelName as ProductModelName,
    product.EnglishDescription as ProductDescription,
    product_category.EnglishProductCategoryName as ProductCategoryName,
    product_subcategory.EnglishProductSubcategoryName as ProductSubcategoryName,
FROM {{ ref('product') }} product
LEFT JOIN product_subcateory
    ON product.ProductSubcategoryKey = product_subcategory.ProductSubcategoryKey
LEFT JOIN product_category
    ON product_subcategory.ProductCategoryKey = product_category.ProductCategoryKey