with base as (

    select *
    from {{ ref('stg_stackadapt__ad_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stackadapt__ad_tmp')),
                staging_columns=get_ad_columns()
            )
        }}
        {{ fivetran_utils.apply_source_relation(package_name='stackadapt') }}
    from base

),

final as (

    select
        source_relation,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'id']) }} as ad_key,
        cast(id as {{ dbt.type_string() }}) as ad_id,
        cast(advertiser_id as {{ dbt.type_string() }}) as advertiser_id,
        cast(campaign_id as {{ dbt.type_string() }}) as campaign_id,
        name as ad_name,
        state as ad_state,
        status as ad_status,
        channel_type,
        click_url,
        creative_size,
        paused as is_paused,
        is_archived,
        is_draft,
        is_rejected
    from fields

),

url_fields as (

    select
        *,
        {{ dbt.split_part('click_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('click_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('click_url') }} as url_path,
        {{ stackadapt.stackadapt_extract_url_parameter('click_url', 'utm_source') }} as utm_source,
        {{ stackadapt.stackadapt_extract_url_parameter('click_url', 'utm_medium') }} as utm_medium,
        {{ stackadapt.stackadapt_extract_url_parameter('click_url', 'utm_campaign') }} as utm_campaign,
        {{ stackadapt.stackadapt_extract_url_parameter('click_url', 'utm_content') }} as utm_content,
        {{ stackadapt.stackadapt_extract_url_parameter('click_url', 'utm_term') }} as utm_term
    from final

)

select *
from url_fields
