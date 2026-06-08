with base as (

    select *
    from {{ ref('stg_stackadapt__advertiser_delivery_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stackadapt__advertiser_delivery_tmp')),
                staging_columns=get_advertiser_delivery_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='stackadapt') }}
    from base

),

final as (

    select
        source_relation,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'advertiser_id', 'granularity_time']) }} as advertiser_delivery_key,
        cast(advertiser_id as {{ dbt.type_string() }}) as advertiser_id,
        cast(granularity_time as date) as date_day,
        impressions_bigint as impressions,
        clicks_bigint as clicks,
        cost as spend,
        conversions_bigint as conversions
        {{ stackadapt.stackadapt_fill_pass_through_columns(pass_through_fields=var('stackadapt__advertiser_delivery_passthrough_metrics')) }}
    from fields

)

select *
from final
