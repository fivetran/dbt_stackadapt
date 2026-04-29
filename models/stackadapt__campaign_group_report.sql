with campaign_group_delivery as (

    select *
    from {{ ref('stg_stackadapt__campaign_group_delivery') }}

),

campaign_group as (

    select *
    from {{ ref('stg_stackadapt__campaign_group') }}

),

advertiser as (

    select *
    from {{ ref('stg_stackadapt__advertiser') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['campaign_group_delivery.date_day', 'campaign_group_delivery.campaign_group_id', 'campaign_group_delivery.source_relation']) }} as campaign_group_report_id,
        campaign_group_delivery.source_relation,
        campaign_group_delivery.date_day,
        campaign_group_delivery.campaign_group_id,
        campaign_group.campaign_group_name,
        campaign_group.is_archived,
        campaign_group_delivery.advertiser_id,
        advertiser.advertiser_name,
        sum(campaign_group_delivery.impressions) as impressions,
        sum(campaign_group_delivery.clicks) as clicks,
        sum(campaign_group_delivery.spend) as spend,
        sum(campaign_group_delivery.conversions) as conversions
        {{ stackadapt.stackadapt_persist_pass_through_columns(pass_through_variable='stackadapt__campaign_group_delivery_passthrough_metrics', identifier='campaign_group_delivery', transform='sum', coalesce_with=0) }}
    from campaign_group_delivery
    left join campaign_group
        on campaign_group_delivery.campaign_group_id = campaign_group.campaign_group_id
        and campaign_group_delivery.source_relation = campaign_group.source_relation
    left join advertiser
        on campaign_group_delivery.advertiser_id = advertiser.advertiser_id
        and campaign_group_delivery.source_relation = advertiser.source_relation
    {{ dbt_utils.group_by(n=8) }}

)

select *
from final
