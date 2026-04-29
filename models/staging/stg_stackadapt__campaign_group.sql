with base as (

    select *
    from {{ ref('stg_stackadapt__campaign_group_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_stackadapt__campaign_group_tmp')),
                staging_columns=get_campaign_group_columns()
            )
        }}
        {{ stackadapt.apply_source_relation() }}
    from base

),

final as (

    select
        source_relation,
        cast(id as {{ dbt.type_string() }}) as campaign_group_id,
        name as campaign_group_name,
        budget_rollover,
        budget_type,
        domain_exclusions,
        domains,
        freq_cap_expiry,
        freq_cap_limit,
        is_archived,
        is_inventory_packages_strict,
        revenue_pricing,
        revenue_type,
        timezone,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at
    from fields

)

select *
from final
