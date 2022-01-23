#!/bin/bash

REGION="europe-west3"
LOCATION="EU"
ZONE="europe-west3-b"
PROJECT_ID="yygcplearning"
STORAGE_CLASS="Standard"
BUCKET_NAME="yygcplearning"
FILE_NAME_1="backup-file"
FILE_NAME_2="backup-file2"
DATASET="ds_eu"
TABLE_NAME1="tb1"
TABLE_NAME2="tb2"
EXPIRATION=36000
SCHEMA=qrt:STRING,sales:FLOAT,year:STRING
COMPRESSION_GZIP="GZIP"
COMPRESSION_SNAPPY="SNAPPY"
FORMAT_CSV="CSV"
FORMAT_AVRO="AVRO"
FORMAT_JSON="NEWLINE_DELIMITED_JSON"
SKIP_ROWS=1

# create a table with the specific schema
bq mk --table ${DATASET}.${TABLE_NAME1} ${SCHEMA}

# create a table with the json schema
bq mk --table ds_eu.mytable ./myschema.json

# create a table with the json schema and load the values
bq load --source_format=CSV ds_eu.mytable ./myfile.csv ./myschema.json

# create a table with the schema auto detect mode
bq load --autodetect --source_format=CSV ds_eu.mytable2 ./myfile.csv

# create a table from a query result
bq query \
--destination_table ${DATASET}.${TABLE_NAME1} \
--label bqsandbox:dev \
--use_legacy_sql=false \
'SELECT 
  * 
FROM `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 
LIMIT 10
'

# show tables
bq show ${DATASET}.${TABLE_NAME1}
bq show ${DATASET}.${TABLE_NAME2}

# show table with the json format
bq show --format=prettyjson ${DATASET}.${TABLE_NAME1}

# show table with max rows
bq head --max_rows=5 ${DATASET}.${TABLE_NAME1}

# show table information with the ddl column
bq query --nouse_legacy_sql \
'SELECT
   table_name, ddl
 FROM
   ${DATASET}.${TABLE_NAME1}.INFORMATION_SCHEMA.TABLES
 WHERE
   table_name="tb1"'


bq query --nouse_legacy_sql \
'SELECT
   * 
 FROM
   `bigquery-sandbox-323313`.ds_eu.INFORMATION_SCHEMA.COLUMNS
 WHERE
   table_name="tb1"'

# load CSV file from cloud storage
bq load \
    --source_format=${FORMAT_CSV} \
    --skip_leading_rows ${SKIP_ROWS} \
    --autodetect \
    ${DATASET}.${TABLE_NAME1} \
    gs://${BUCKET_NAME}/${FILE_NAME_1}


# copy table
bq --location=${LOCATION} cp -f \
${SOURCE_DATASET}.${SOURCE_TABLE} \
${DESTINATION_PROJECT_ID}:${DESTINATION_DATASET}.${DESTINATION_TABLE}

# delete table
bq rm -t -f ${DATASET}.${TABLE_NAME1}

# update the schema (add or delete columns)
vi myschema.json
bq update ${DATASET}.${TABLE_NAME1} /tmp/myschema.json

# update the column name

bq query \
--destination_table ${DESTINATION_DATASET} \
--replace \
--use_legacy_sql=false \
'SELECT
  * EXCEPT(column_one,
    column_two),
  column_one AS newcolumn_one,
  column_two AS newcolumn_two
FROM
  <dataset>.<table>'

# time travel
# Time travel only provides access to table data for the past seven days

