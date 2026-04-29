{% macro get_ad_delivery_columns() %}

{% set columns = [
    {"name": "ad_id", "datatype": dbt.type_int()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "clicks_bigint", "datatype": dbt.type_int()},
    {"name": "conversions_bigint", "datatype": dbt.type_int()},
    {"name": "cost", "datatype": dbt.type_float()},
    {"name": "granularity_time", "datatype": dbt.type_timestamp()},
    {"name": "impressions_bigint", "datatype": dbt.type_int()}
] %}

{{ stackadapt.stackadapt_add_pass_through_columns(base_columns=columns, pass_through_fields=var('stackadapt__ad_delivery_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
