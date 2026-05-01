{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set exclude_columns = [] + var('consistency_test_exclude_fields', []) %}

with prod as (
    select {{ dbt_utils.star(from=ref('stackadapt__url_report'), except=exclude_columns) }}
    from {{ target.schema }}_stackadapt_prod.stackadapt__url_report
),

dev as (
    select {{ dbt_utils.star(from=ref('stackadapt__url_report'), except=exclude_columns) }}
    from {{ target.schema }}_stackadapt_dev.stackadapt__url_report
),

prod_not_in_dev as (
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final
