<!--section="stackadapt_transformation_model"-->
# StackAdapt dbt Package

This dbt package transforms data from Fivetran's StackAdapt connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 21
- Connector documentation
  - [StackAdapt connector documentation](https://fivetran.com/docs/connectors/applications/stackadapt-graphql)
  - [StackAdapt ERD](https://fivetran.com/docs/connectors/applications/stackadapt-graphql#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_stackadapt)
  - [dbt Docs](https://fivetran.github.io/dbt_stackadapt/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_stackadapt/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_stackadapt/blob/main/CHANGELOG.md)
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

## What does this dbt package do?
This package enables you to better understand the performance of your ads across varying grains and produces modeled tables that leverage StackAdapt data. It creates enriched models with metrics focused on advertiser, campaign group, campaign, and ad level reports.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_stackadapt_reports
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [`stackadapt__advertiser_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__advertiser_report) | Represents daily performance aggregated at the advertiser level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>How does performance compare across different advertisers?</li><li>Which advertisers are driving the most spend or conversions?</li></ul> |
| [`stackadapt__campaign_group_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__campaign_group_report) | Represents daily performance aggregated at the campaign group level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which campaign groups have the highest click-through rate or conversion rate?</li><li>How does spend and performance compare across campaign groups within each advertiser?</li></ul> |
| [`stackadapt__campaign_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__campaign_report) | Represents daily performance aggregated at the campaign level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which campaigns are most efficient in terms of cost per conversion?</li><li>How does delivery performance vary by campaign channel type and status?</li></ul> |
| [`stackadapt__ad_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__ad_report) | Represents daily performance at the individual ad level, including `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which ad creatives are driving the lowest cost per click?</li><li>How do different ad sizes compare in performance?</li><li>Which ads are top-performing within each campaign?</li></ul> |
| [`stackadapt__url_report`](https://fivetran.github.io/dbt_stackadapt/#!/model/model.stackadapt.stackadapt__url_report) | Represents daily performance aggregated at the landing URL level, with URL components and UTM parameters parsed from `click_url`. Includes `impressions`, `clicks`, `spend`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which landing pages are driving the most conversions?</li><li>How does performance compare across UTM campaigns and sources?</li><li>Which URL paths have the highest spend relative to conversions?</li></ul> |

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran StackAdapt connection created on or after January 15, 2026 using the StackAdapt GraphQL API syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_stackadapt/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following stackadapt package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/stackadapt
    version: [">=0.1.0", "<0.2.0"] # we recommend using ranges to capture non-breaking changes automatically
```

### Define database and schema variables

#### Option A: Single connection
By default, this package runs using your destination and the `stackadapt` schema. If this is not where your StackAdapt data is (for example, if your StackAdapt schema is named `stackadapt_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    stackadapt_database: your_destination_name
    stackadapt_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple StackAdapt connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `stackadapt_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  stackadapt:
    stackadapt_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

### (Optional) Additional configurations

#### Change the build schema
By default, this package builds the StackAdapt staging models within a schema titled (`<target_schema>` + `_stackadapt_staging`) and your StackAdapt modeling models within a schema titled (`<target_schema>` + `_stackadapt_reports`) in your destination. If this is not where you would like your StackAdapt data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    stackadapt:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_stackadapt/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    stackadapt_<default_source_table_name>_identifier: your_table_name
```

#### Pass through additional metrics
By default, this package selects only the standard metrics (`impressions`, `clicks`, `spend`, `conversions`) from each delivery source table. If your StackAdapt connector syncs additional columns that you would like included in the final report models, use the passthrough metrics variables below.

Each variable accepts a list of column configurations with the following fields:
- `name` (required): The source column name as it appears in the delivery table.
- `alias` (optional): An alternative name to use for the column in the output model.

> IMPORTANT: Make sure to exercise due diligence when adding metrics to these models. The metrics added by default (impressions, clicks, spend, and conversions) have been vetted by the Fivetran team, maintaining this package for accuracy. There are metrics included within the source reports, such as metric averages, which may be inaccurately represented at the grain for reports created in this package. You must ensure that whichever metrics you pass through are appropriate to aggregate at the respective reporting levels in this package.

```yml
vars:
    stackadapt__advertiser_delivery_passthrough_metrics:
      - name: custom_metric
        alias: my_custom_metric

    stackadapt__campaign_group_delivery_passthrough_metrics:
      - name: custom_metric

    stackadapt__campaign_delivery_passthrough_metrics:
      - name: custom_metric
        alias: my_custom_metric

    stackadapt__ad_delivery_passthrough_metrics:
      - name: custom_metric
```
> NOTE: `stackadapt__ad_delivery_passthrough_metrics` applies to both `stackadapt__ad_report` and `stackadapt__url_report`, as both models are built from ad-level delivery data.

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```

<!--section="stackadapt_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/stackadapt/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_stackadapt/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_stackadapt/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
