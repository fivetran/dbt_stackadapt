{# Backwards compatible version of fivetran_utils.fill_pass_through_columns #}

{% macro stackadapt_fill_pass_through_columns(pass_through_fields, except=[]) %}
    {{ return(adapter.dispatch('stackadapt_fill_pass_through_columns', 'stackadapt')(pass_through_fields, except)) }}
{% endmacro %}

{% macro default__stackadapt_fill_pass_through_columns(pass_through_fields, except=[]) %}

{% if pass_through_fields %}
    {% for field in pass_through_fields %}
        {% if (field.alias if field.alias else field.name) not in except %}
            {% if field.transform_sql %}
                , coalesce(cast({{ field.transform_sql }} as {{ dbt.type_float() }}), 0) as {{ field.alias if field.alias else field.name }}
            {% else %}
                , coalesce(cast({{ field.alias if field.alias else field.name }} as {{ dbt.type_float() }}), 0) as {{ field.alias if field.alias else field.name }}
            {% endif %}
        {% endif %}
    {% endfor %}
{% endif %}

{% endmacro %}
