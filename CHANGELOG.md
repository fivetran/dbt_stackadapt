# dbt_stackadapt v0.2.0

[PR #2](https://github.com/fivetran/dbt_stackadapt/pull/2) includes the following updates:

## Schema/Data Changes (--full-refresh required after upgrading)
**1 total change • 1 possible breaking change**

| Data Model(s) | Change type | Old | New | Notes |
| ------------- | ----------- | --- | --- | ----- |
| All models | `source_relation` column (when using a single Stack Adapt schema) | Empty string (`''`) | `<database>.<schema>` |  |

## Feature Updates
- Introduces the new (recommended) `stackadapt_sources` variable for more robust union data configuration. The old `stackadapt_union_schemas` and `stackadapt_union_databases` variables will still be supported. See the [README](https://github.com/fivetran/dbt_stackadapt/tree/main#define-database-and-schema-variables) for specific details.

## Under the Hood
- Adds the `fivetran_using_source_casing` variable for case-sensitive destination support. When enabled, downstream transformations respect source casing to ensure consistent results. See the [Additional Configurations](https://github.com/fivetran/dbt_stackadapt/#source-casing-for-case-sensitive-destinations) section of the README for details.
- Introduces `fivetran_utils.partition_by_source_relation` to conditionally include `source_relation` in partition clauses only when multiple sources are configured.

# dbt_stackadapt v0.1.0

This is the initial release of the `dbt_stackadapt` dbt package.

## Initial Release

This package models data from Fivetran's [StackAdapt connector](https://fivetran.com/docs/connectors/applications/stackadapt-graphql) and produces the following analytics-ready tables:

| Table | Description |
| :---- | :---- |
| [`stackadapt__advertiser_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__advertiser_report) | Represents daily performance aggregated at the advertiser level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>How does performance compare across different advertisers?</li><li>Which advertisers are driving the most spend or conversions?</li></ul> |
| [`stackadapt__campaign_group_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__campaign_group_report) | Represents daily performance aggregated at the campaign group level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which campaign groups have the highest click-through rate or conversion rate?</li><li>How does spend and performance compare across campaign groups within each advertiser?</li></ul> |
| [`stackadapt__campaign_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__campaign_report) | Represents daily performance aggregated at the campaign level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which campaigns are most efficient in terms of cost per conversion?</li><li>How does delivery performance vary by campaign channel type and status?</li></ul> |
| [`stackadapt__ad_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__ad_report) | Represents daily performance at the individual ad level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which ad creatives are driving the lowest cost per click?</li><li>How do different ad sizes compare in performance?</li><li>Which ads are top-performing within each campaign?</li></ul> |
| [`stackadapt__url_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__url_report) | Represents daily performance aggregated at the landing URL level, with URL components and UTM parameters parsed from `click_url`. Includes `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which landing pages are driving the most conversions?</li><li>How does performance compare across UTM campaigns and sources?</li><li>Which URL paths have the highest spend relative to conversions?</li></ul> |
