with campaign_delivery as (

    select *
    from {{ ref('stg_stackadapt__campaign_delivery') }}

),

campaign as (

    select *
    from {{ ref('stg_stackadapt__campaign') }}

),

advertiser as (

    select *
    from {{ ref('stg_stackadapt__advertiser') }}

),

campaign_group as (

    select *
    from {{ ref('stg_stackadapt__campaign_group') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['campaign_delivery.date_day', 'campaign_delivery.campaign_id', 'campaign_delivery.source_relation']) }} as campaign_report_key,
        campaign_delivery.source_relation,
        campaign_delivery.date_day,
        campaign_delivery.campaign_id,
        campaign.campaign_name,
        campaign.campaign_state,
        campaign.campaign_status,
        campaign.channel_type,
        campaign_delivery.advertiser_id,
        advertiser.advertiser_name,
        campaign.campaign_group_id,
        campaign_group.campaign_group_name,
        sum(campaign_delivery.impressions) as impressions,
        sum(campaign_delivery.clicks) as clicks,
        sum(campaign_delivery.spend) as spend,
        sum(campaign_delivery.conversions) as conversions
        {{ stackadapt.stackadapt_persist_pass_through_columns(pass_through_variable='stackadapt__campaign_delivery_passthrough_metrics', identifier='campaign_delivery', transform='sum', coalesce_with=0) }}
    from campaign_delivery
    left join campaign
        on campaign_delivery.campaign_id = campaign.campaign_id
        and campaign_delivery.source_relation = campaign.source_relation
    left join advertiser
        on campaign.advertiser_id = advertiser.advertiser_id
        and campaign.source_relation = advertiser.source_relation
    left join campaign_group
        on campaign.campaign_group_id = campaign_group.campaign_group_id
        and campaign.source_relation = campaign_group.source_relation
    {{ dbt_utils.group_by(n=12) }}

)

select *
from final
