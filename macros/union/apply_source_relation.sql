{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'stackadapt') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('stackadapt_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("stackadapt_database", target.database) }}' || '.'|| '{{ var("stackadapt_schema", "stackadapt") }}' as source_relation
{% endif %}

{%- endmacro %}
