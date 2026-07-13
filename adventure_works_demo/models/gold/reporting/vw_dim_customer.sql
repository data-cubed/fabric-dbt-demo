
select
    dim_customer.CustomerKey,
    dim_customer.NameStyle,
    dim_customer.Title,
    dim_customer.FirstName,
    dim_customer.MiddleName,
    dim_customer.LastName,
    dim_customer.Suffix,
    dim_customer.EmailAddress,
    dim_customer.Phone
FROM {{ ref('dim_customer') }} dim_customer
