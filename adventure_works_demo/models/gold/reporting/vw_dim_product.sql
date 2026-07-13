
SELECT 
    dim_product.ProductKey,
    dim_product.ProductName,
    dim_product.Color,
    dim_product.Size,
    dim_product.ListPrice,
    dim_product.ProductModelName,
    dim_product.ProductSubcategoryName,
    dim_product.ProductCategoryName
FROM {{ ref('dim_product') }} dim_product