with base as (

    select *
    from {{ ref('stg_stackadapt__campaign_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stackadapt__campaign_tmp')),
                staging_columns=get_campaign_columns()
            )
        }}
        {{ stackadapt.apply_source_relation() }}
    from base

),

final as (

    select
        source_relation,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'id']) }} as campaign_key,
        cast(id as {{ dbt.type_string() }}) as campaign_id,
        cast(advertiser_id as {{ dbt.type_string() }}) as advertiser_id,
        cast(campaign_group_id as {{ dbt.type_string() }}) as campaign_group_id,
        name as campaign_name,
        state as campaign_state,
        status as campaign_status,
        channel_type,
        is_archived,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at
    from fields

)

select *
from final
