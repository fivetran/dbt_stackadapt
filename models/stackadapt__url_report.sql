with ad_delivery as (

    select *
    from {{ ref('stg_stackadapt__ad_delivery') }}

),

ads as (

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
        {{ dbt_utils.generate_surrogate_key(['ad_delivery.date_day', 'ad_delivery.ad_id', 'ads.click_url', 'ad_delivery.source_relation']) }} as url_report_key,
        ad_delivery.source_relation,
        ad_delivery.date_day,
        ad_delivery.ad_id,
        ads.ad_name,
        ads.advertiser_id,
        advertiser.advertiser_name,
        ad_delivery.campaign_id,
        campaign.campaign_name,
        ads.click_url,
        ads.base_url,
        ads.url_host,
        ads.url_path,
        ads.utm_source,
        ads.utm_medium,
        ads.utm_campaign,
        ads.utm_content,
        ads.utm_term,
        sum(ad_delivery.impressions) as impressions,
        sum(ad_delivery.clicks) as clicks,
        sum(ad_delivery.spend) as spend,
        sum(ad_delivery.conversions) as conversions
        {{ stackadapt.stackadapt_persist_pass_through_columns(pass_through_variable='stackadapt__ad_delivery_passthrough_metrics', identifier='ad_delivery', transform='sum', coalesce_with=0) }}
    from ad_delivery
    left join ads
        on ad_delivery.ad_id = ads.ad_id
        and ad_delivery.source_relation = ads.source_relation
    left join advertiser
        on ads.advertiser_id = advertiser.advertiser_id
        and ads.source_relation = advertiser.source_relation
    left join campaign
        on ad_delivery.campaign_id = campaign.campaign_id
        and ad_delivery.source_relation = campaign.source_relation
    where ads.click_url is not null
    {{ dbt_utils.group_by(n=18) }}

)

select *
from final
