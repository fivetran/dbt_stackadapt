with ad_delivery as (

    select *
    from {{ ref('stg_stackadapt__ad_delivery') }}

),

ad as (

    select *
    from {{ ref('stg_stackadapt__ad') }}

),

advertiser as (

    select *
    from {{ ref('stg_stackadapt__advertiser') }}

),

campaign as (

    select *
    from {{ ref('stg_stackadapt__campaign') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['ad_delivery.date_day', 'ad_delivery.ad_id', 'ad_delivery.source_relation']) }} as ad_report_id,
        ad_delivery.source_relation,
        ad_delivery.date_day,
        ad_delivery.ad_id,
        ad.ad_name,
        ad.ad_state,
        ad.ad_status,
        ad.channel_type,
        ad.creative_size,
        ad.advertiser_id,
        advertiser.advertiser_name,
        ad.campaign_id,
        campaign.campaign_name,
        sum(ad_delivery.impressions) as impressions,
        sum(ad_delivery.clicks) as clicks,
        sum(ad_delivery.spend) as spend,
        sum(ad_delivery.conversions) as conversions
        {{ stackadapt.stackadapt_persist_pass_through_columns(pass_through_variable='stackadapt__ad_delivery_passthrough_metrics', identifier='ad_delivery', transform='sum', coalesce_with=0) }}
    from ad_delivery
    left join ad
        on ad_delivery.ad_id = ad.ad_id
        and ad_delivery.source_relation = ad.source_relation
    left join advertiser
        on ad.advertiser_id = advertiser.advertiser_id
        and ad.source_relation = advertiser.source_relation
    left join campaign
        on ad.campaign_id = campaign.campaign_id
        and ad.source_relation = campaign.source_relation
    {{ dbt_utils.group_by(n=13) }}

)

select *
from final
