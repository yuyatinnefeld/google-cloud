# BigQuery + dbt - Data transform Project

## Gitlab

https://gitlab.com/yuyatinnefeld/bigquery-dbt-cicd

## initial setup

1. install packages
```bash
python -m venv dbt-env
source dbt-env/bin/activate
pip install wheel
pip3 install --user --upgrade dbt-bigquery
pip install --upgrade dbt-bigquery
```
2. create a project
```bash
dbt init dbt_bq
```
3. set env variables
```bash
cd
export DEV_PROFILE_TARGET="--profiles-dir profile --target dev"
export PROD_PROFILE_TARGET="--profiles-dir profile --target prod"
```

4. configure profile/profiles.yml
```yml
dbt_bq:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: yygcplearning #GCP dev project
      dataset: ds_dbt
      location: EU
      threads: 1
      keyfile: conf/gcp_key.json
      timeout_seconds: 300
      priority: interactive
      retries: 1
    prod:
      type: bigquery
      method: service-account
      project: yygcplearning #GCP prod project
      dataset: ds_dbt
      location: EU
      threads: 1
      keyfile: 'conf/gcp_key.json'
      timeout_seconds: 300
      priority: interactive
      retries: 1
```
5. configure dbt_project.yml
```yml
name: 'dbt_bq'
version: '1.0.0'
config-version: 2

profile: 'dbt_bq'

source-paths: ["models"]
analysis-paths: ["analysis"]
test-paths: ["tests"]
data-paths: ["data"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

target-path: "target"  
clean-targets:         
    - "target"
    - "dbt_modules"


models:
  dbt_bq:
      example:
          materialized: view
```
6. test the connection
```bash
dbt debug $DEV_PROFILE_TARGET
dbt run $DEV_PROFILE_TARGET
```

## create the models
1. create the dirs
```bash
cd dbt_bq
mkdir models/l10_rawdata
mkdir models/l20_transform
mkdir models/step_3_mart
```
2. update the dbt_project.yml
```yml

name: 'dbt_bq'
version: '1.0.0'
config-version: 2
....
models:
  dbt_bq:
      l10_rawdata:
          schema: l10_rawdata
          materialized: view
      l20_transform:
          schema: l20_transform
          materialized: view
      step_3_mart:
          schema: step_3_mart
          materialized: view
```

3. create customize schema naming macros
```bash
vi macros/call_me_anything_you_want.sql
```

```bash
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}


{% macro set_query_tag() -%}
  {% set new_query_tag = model.name %} {# always use model name #}
  {% if new_query_tag %}
    {% set original_query_tag = get_current_query_tag() %}
    {{ log("Setting query_tag to '" ~ new_query_tag ~ "'. Will reset to '" ~ original_query_tag ~ "' after materialization.") }}
    {% do run_query("alter session set query_tag = '{}'".format(new_query_tag)) %}
    {{ return(original_query_tag)}}
  {% endif %}
  {{ return(none)}}
{% endmacro %}
```

4. create a packages.yml
```bash
cd dbt_bq
vi packages.yml
```
```yml
packages:
  - package: fishtown-analytics/dbt_utils
    version: 0.6.4
```


5. install the dbt plugins
```bash
dbt deps $DEV_PROFILE_TARGET
```

## Build dbt pipelines - raw data

1. create model files 

models/l10_rawdata/rawdata_jobs_by_user.sql
```sql
SELECT * FROM `region-eu`.INFORMATION_SCHEMA.JOBS_BY_USER
```
models/l10_rawdata/rawdata_jobs_timeline_by_user.sql
```sql
SELECT * FROM `region-eu`.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_USER
```

2. deploy the model
```bash
dbt run --model l10_rawdata $DEV_PROFILE_TARGET --no-version-check
```

## Build dbt pipelines - transformed data

1. create models
- models/l20_transform/tfm_jobs_by_user.sql
- models/l20_transform/tfm_jobs_timeline_by_user.sql

2. deploy the model
```bash
dbt run --model l20_transform $DEV_PROFILE_TARGET --no-version-check
```
3. verify the data
```sql
select * from `yygcplearning.l20_transform.tfm_jobs_by_user`
select * from `yygcplearning.l20_transform.tfm_jobs_timeline_by_user`
```

## Integrate gitlab CI/CD 
0. pip freeze > requirements.txt

1. git push

2. update profile/profiles.yml
- keyfile: "{{ env_var('GCP_JSON_KEY') }}"

3. create a variable "GCP_JSON_KEY" as file variable

4. create .gitlab-ci.yml file
```yml
stages:
  - build
  - test
  - deploy
  
image: registry.gitlab.com/gitlab-data/data-image/dbt-image:v0.0.15

before_script:
  - export GCP_JSON_KEY=$GCP_JSON_KEY
  - export CI_PROFILE_TARGET="--profiles-dir profile --target dev"
  - export PROD_PROFILE_TARGET="--profiles-dir profile --target prod"
  - echo $CI_PROFILE_TARGET
  - echo $PROD_PROFILE_TARGET

after_script:
  - echo "❄️OK❄️"

build1 ⚙️:
  stage: build
  script:
    - echo "❄️install all packages❄️"
    - pip install -r requirements.txt

test1 🦖:
  stage: test
  script:
    - echo "❄️connection test❄️"
    - dbt debug $CI_PROFILE_TARGET

test2 🐭:
  stage: test
  needs: [test1 🦖]
  script:
    - echo "❄️config test❄️"
    - dbt test $CI_PROFILE_TARGET

dev deploy ⚡:
  stage: deploy
  script:
    - echo "❄️ deploy to development ❄️"
    - dbt run $CI_PROFILE_TARGET
  when: manual

prod deploy 🚀:
  stage: deploy
  script:
    - echo "❄️ deploy to production ❄️"
    - dbt seed $PROD_PROFILE_TARGET
    - dbt run $PROD_PROFILE_TARGET
  when: manual
```
