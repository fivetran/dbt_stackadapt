# dbt_stackadapt v0.1.0

This is the initial release of the `dbt_stackadapt` dbt package.

## Initial Release

This package models data from Fivetran's [StackAdapt connector](https://fivetran.com/docs/connectors/applications/stackadapt-graphql) and produces the following analytics-ready tables:

- `stackadapt__advertiser_report` — one row per advertiser per day, with aggregated delivery metrics (spend, impressions, clicks, conversions, revenue)
- `stackadapt__campaign_group_report` — one row per campaign group per day, with aggregated delivery metrics across all campaigns in the group
- `stackadapt__campaign_report` — one row per campaign per day, with delivery metrics and campaign attributes (state, status, channel type)
- `stackadapt__ad_report` — one row per ad per day, with delivery metrics and ad attributes (state, status, channel type, creative size)
- `stackadapt__url_report` — one row per click URL per day, aggregating impressions, clicks, spend, conversions, and revenue. URL components (base_url, url_host, url_path) and UTM parameters (utm_source, utm_medium, utm_campaign, utm_content, utm_term) are extracted from the ad's `click_url` and exposed as dimensions.