{{config(
    post_hook=[
        "{{ apply_constraints() }}"
    ]
    )
}}

select
    md5(concat_ws('|', ProductDescriptionID, Culture)) as u_id,
    *
from {{ source('adventure_works_bronze', 'productmodelproductdescription') }}