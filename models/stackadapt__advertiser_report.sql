with advertiser_delivery as (

    select *
    from {{ ref('stg_stackadapt__advertiser_delivery') }}

),

advertiser as (

    select *
    from {{ ref('stg_stackadapt__advertiser') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['advertiser_delivery.date_day', 'advertiser_delivery.advertiser_id', 'advertiser_delivery.source_relation']) }} as advertiser_report_id,
        advertiser_delivery.source_relation,
        advertiser_delivery.date_day,
        advertiser_delivery.advertiser_id,
        advertiser.advertiser_name,
        advertiser.is_archived,
        sum(advertiser_delivery.impressions) as impressions,
        sum(advertiser_delivery.clicks) as clicks,
        sum(advertiser_delivery.spend) as spend,
        sum(advertiser_delivery.conversions) as conversions
        {{ stackadapt.stackadapt_persist_pass_through_columns(pass_through_variable='stackadapt__advertiser_delivery_passthrough_metrics', identifier='advertiser_delivery', transform='sum', coalesce_with=0) }}
    from advertiser_delivery
    left join advertiser
        on advertiser_delivery.advertiser_id = advertiser.advertiser_id
        and advertiser_delivery.source_relation = advertiser.source_relation
    {{ dbt_utils.group_by(n=6) }}

)

select *
from final
