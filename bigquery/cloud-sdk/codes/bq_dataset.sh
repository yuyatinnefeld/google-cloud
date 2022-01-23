#!/bin/bash

REGION="europe-west3"
LOCATION="EU"
ZONE="europe-west3-b"
PROJECT_ID="yygcplearning"
STORAGE_CLASS="Standard"
BUCKET_NAME="yygcplearning"
DATASET="ds_eu"
TABLE_NAME1="tb1"
TABLE_NAME2="tb2"
EXPIRATION=36000
SCHEMA=qrt:STRING,sales:FLOAT,year:STRING
COMPRESSION_TYPE=GZIP

# create a dataset
bq mk \
    --location=${LOCATION} \
    --project_id=${PROJECT_ID} \
    ${DATASET}

# create tables
bq mk \
    --table \
    --expiration ${EXPIRATION} \
    --label organization:development \
    ${DATASET}.${TABLE_NAME1} \


bq mk \
    --table \
    --expiration ${EXPIRATION} \
    --description "table XXXXX for YYYYY" \
    --label organization:development \
    ${DATASET}.${TABLE_NAME1} \
    userId:INT64,movieId:INT64,rating:FLOAT,timestamp:INT64

bq mk \
    --table \
    --expiration ${EXPIRATION} \
    --description "table XXXXX for YYYYY" \
    --label organization:development \
    ${DATASET}.${TABLE_NAME2} \
    movieId:INT64,title:STRING,genres:STRING

# show dataset details 
bq show ${DATASET}.${TABLE_NAME1}
bq show ${DATASET}.${TABLE_NAME2}

# copy table

bq mk \
    --transfer_config \
    --project_id=${PROJECT_ID} \
    --data_source=cross_region_copy \
    --target_dataset=${DESTINATION_DATASET} \
    --display_name='My Dataset Copy' \
    --params='{"source_dataset_id":${SOURCE_DATASET},"source_project_id":${SOURCE_PROJECT_ID},"overwrite_destination_table":"true"}'

# show all datasets
bq ls -a

# show max 60 datasets
bq ls --max_results 60

# show datasets with the filter "org:dev"
bq ls --filter labels.org:dev

# show datasets with the project filter
bq ls --project_id bigquery-sandbox-323313

# show information schema
bq query --nouse_legacy_sql \
'SELECT
   * EXCEPT(schema_owner)
 FROM
   INFORMATION_SCHEMA.SCHEMATA'

# update the dataset description
bq update \
    --description "Description of mydataset" \ 
    ${PROJECT_ID}:${DATASET}

# update the expiration times
bq update --default_table_expiration 7200 ${PROJECT_ID}:${DATASET}

# update the partition expiration times
bq update --default_partition_expiration 93600 ${PROJECT_ID}:${DATASET}

# create backups
## Restore a 2-min old copy (deleted tables are flushed after 2days or if recreated with same name)
NOW=$(date +%s)
SNAPSHOT=$(echo "($NOW - 120) * 1000" | bc)

bq --location=EU cp \
ch10eu.restored_cycle_stations@$SNAPSHOT \
ch10eu.restored_table

# delete the dataset
bq rm -r -f ${PROJECT_ID}:${DATASET}