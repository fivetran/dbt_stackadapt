{% macro get_campaign_group_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "budget_rollover", "datatype": "boolean"},
    {"name": "budget_type", "datatype": dbt.type_string()},
    {"name": "created_at", "datatype": dbt.type_timestamp()},
    {"name": "domain_exclusions", "datatype": dbt.type_string()},
    {"name": "domains", "datatype": dbt.type_string()},
    {"name": "freq_cap_expiry", "datatype": dbt.type_int()},
    {"name": "freq_cap_limit", "datatype": dbt.type_int()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "is_archived", "datatype": "boolean"},
    {"name": "is_inventory_packages_strict", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "revenue_pricing", "datatype": dbt.type_float()},
    {"name": "revenue_type", "datatype": dbt.type_string()},
    {"name": "timezone", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
