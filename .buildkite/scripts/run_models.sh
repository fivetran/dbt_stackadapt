#!/bin/bash

set -euo pipefail

apt-get update
apt-get install libsasl2-dev

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip setuptools
pip install -r integration_tests/requirements.txt
mkdir -p ~/.dbt
cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml

db=$1
echo `pwd`
cd integration_tests
dbt deps

dbt seed --target "$db" --full-refresh
dbt source freshness --target "$db" || echo "...Only verifying freshness runs…"
dbt compile --target "$db"
dbt run --target "$db" --full-refresh
dbt run --target "$db"
dbt test --target "$db"

# Passthrough metrics test: exercises alias renaming and multi-column passthrough across all delivery models
dbt run --target "$db" --full-refresh --vars '{stackadapt__ad_delivery_passthrough_metrics: [{name: revenue, alias: ad_revenue}, {name: impression_conversions_bigint}], stackadapt__advertiser_delivery_passthrough_metrics: [{name: revenue, alias: advertiser_revenue}], stackadapt__campaign_delivery_passthrough_metrics: [{name: revenue}, {name: impression_conversions_bigint, alias: campaign_view_through_conversions}], stackadapt__campaign_group_delivery_passthrough_metrics: [{name: impression_conversions_bigint, alias: view_through_conversions}]}'
dbt test --target "$db" --vars '{stackadapt__ad_delivery_passthrough_metrics: [{name: revenue, alias: ad_revenue}, {name: impression_conversions_bigint}], stackadapt__advertiser_delivery_passthrough_metrics: [{name: revenue, alias: advertiser_revenue}], stackadapt__campaign_delivery_passthrough_metrics: [{name: revenue}, {name: impression_conversions_bigint, alias: campaign_view_through_conversions}], stackadapt__campaign_group_delivery_passthrough_metrics: [{name: impression_conversions_bigint, alias: view_through_conversions}]}'

dbt run-operation fivetran_utils.drop_schemas_automation --target "$db"
