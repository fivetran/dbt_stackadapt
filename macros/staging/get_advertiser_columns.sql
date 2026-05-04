{% macro get_advertiser_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "description", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_int()},
    {"name": "is_archived", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
