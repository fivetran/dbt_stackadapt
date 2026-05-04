{# Adapted from fivetran_utils.persist_pass_through_columns() macro to include exclusions and coalesces #}

{% macro stackadapt_persist_pass_through_columns(pass_through_variable, identifier=none, transform='', coalesce_with=none, exclude_fields=[]) %}
    {{ return(adapter.dispatch('stackadapt_persist_pass_through_columns', 'stackadapt')(pass_through_variable, identifier, transform, coalesce_with, exclude_fields)) }}
{% endmacro %}

{% macro default__stackadapt_persist_pass_through_columns(pass_through_variable, identifier=none, transform='', coalesce_with=none, exclude_fields=[]) %}

{% if var(pass_through_variable, none) %}
    {% for field in var(pass_through_variable) %}
        {% set field_name = field.alias|default(field.name)|lower if field is mapping else field %}
        {% if field_name not in exclude_fields %}
        , {{ transform ~ '(' ~ ('coalesce(' if coalesce_with is not none else '') ~ (identifier ~ '.' if identifier else '') ~ field_name ~ ((', ' ~ coalesce_with ~ ')') if coalesce_with is not none else '') ~ ')' }} as {{ field_name }}
        {% endif %}
    {% endfor %}
{% endif %}

{% endmacro %}
