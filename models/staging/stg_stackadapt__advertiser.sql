with base as (

    select *
    from {{ ref('stg_stackadapt__advertiser_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stackadapt__advertiser_tmp')),
                staging_columns=get_advertiser_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='stackadapt') }}
    from base

),

final as (

    select
        source_relation,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'id']) }} as advertiser_key,
        cast(id as {{ dbt.type_string() }}) as advertiser_id,
        name as advertiser_name,
        description,
        is_archived
    from fields

)

select *
from final
