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

# load data from google sheets
gcloud auth login --enable-gdrive-access

SCHEMA=name:STRING,age:STRING,city:STRING
bq mk \
    --external_table_definition=${SCHEMA}:INTEGER@GOOGLE_SHEETS=https://drive.google.com/open?id=xxxxxxxxxxxx \
    ${DATASET}.${TABLE_NAME1}


# load CSV file from cloud storage
bq load \
    --source_format=${FORMAT_CSV} \
    --skip_leading_rows ${SKIP_ROWS} \
    --autodetect \
    ${DATASET}.${TABLE_NAME1} \
    gs://${BUCKET_NAME}/${FILE_NAME_1}

# load AVRO file from cloud storage 
bq load \
    --source_format=${FORMAT_AVRO} \
    ${DATASET}.${TABLE_NAME1} \
    gs://${BUCKET_NAME}/${FILE_NAME_1}

# load JSON file from cloud storage 
# BigQuery only accepts new-line delimited JSON 
# see the myschema.json
bq load \
    --autodetect \
    --source_format=${FORMAT_JSON} \
    ${DATASET}.${TABLE_NAME1} \
    gs://${BUCKET_NAME}/${FILE_NAME_1}

# load ORC file from cloud storage
bq load \
  --source_format=ORC \
  ${DATASET}.${TABLE_NAME1} 
  gs://${BUCKET_NAME}/${FILE_NAME_1}

# export table to the cloud storage

## storage - csv 
bq --location=${LOCATION} extract \
    --destination_format ${FORMAT_CSV} \
    --compression ${COMPRESSION_GZIP} \
    ${DATASET}.${TABLE_NAME1} \
    gs://${BUCKET_NAME}/${FILE_NAME_1}.csv

## storage - avro
bq --location=${LOCATION} extract \
    --destination_format ${FORMAT_AVRO} \
    --compression ${COMPRESSION_SNAPPY} \
    ${DATASET}.${TABLE_NAME1} \
    gs://${BUCKET_NAME}/${FILE_NAME_2}.avro
