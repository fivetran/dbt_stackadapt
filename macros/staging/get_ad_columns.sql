{% macro get_ad_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "advertiser_id", "datatype": dbt.type_int()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "channel_type", "datatype": dbt.type_string()},
    {"name": "click_url", "datatype": dbt.type_string()},
    {"name": "creative_size", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "is_archived", "datatype": "boolean"},
    {"name": "is_draft", "datatype": "boolean"},
    {"name": "is_rejected", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "paused", "datatype": "boolean"},
    {"name": "state", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
