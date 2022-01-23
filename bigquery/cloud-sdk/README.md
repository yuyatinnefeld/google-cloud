# BigQuery

## About
- BigQuery is a GCP DWH solution
- column-oriented data store logic (RDBMS => record-oriented)
- query execution tree (distributed processing)

## How to use BigQuery
- GCP Console
- GCP SDK / bq 
- REST API / client library (Python, C#, Go, Java, Node.js, PHP, Ruby)


## Info
- https://cloud.google.com/architecture/marketing-data-warehouse-on-gcp
- https://cloud.google.com/architecture/bigquery-data-warehouse
- https://dev.classmethod.jp/articles/bigquery-cloud-sql-federated-queries/


## Slots
![GitHub Logo](/images/bq-slots.png)

A BigQuery slot is a virtual CPU used by BigQuery to execute SQL queries. BigQuery automatically calculates how many slots are required by each query, depending on query size and complexity.
> https://cloud.google.com/bigquery/docs/slots#query_execution_using_slots

BigQuery SQL query is a dynamic DAG

BigQuery slots execute individual units of work at each stage of the query. For example, if BigQuery determines that a stage's optimal parallelization factor is 10, it requests 10 slots to process that stage.

## Analysis Pricing (Query Price)
- https://cloud.google.com/products/calculator
- https://cloud.google.com/bigquery/pricing#data_ingestion_pricing

### 1. On-demand pricing. 
- $6.5 per TB
- purchased for the number of bytes
- The first 1 TB of query data processed per month is free.

### 2. Flat-rate
- purchased for the number of slots (virtual CPUs)
- Flex slots: You commit to an initial 60 seconds.
- Monthly slots: You commit to an initial 30 days. => $2,600/month for 100 slots
- Annual slots: You commit to 365 days => $2,210/month for 100 slots

### Free Tier
- Storage < 10 GB per month
- Query < 1TB per month

### Best Practice
- Estimate your query costs before running a query
- Select only what you need (NOT use "SELECT * ")
- Preview the data
- LIMIT DOESN'T limit the query size
- use specific times and dates
- save that query as an intermediate table when you often use this

## Storage pricing

### 1. Active storage	
- $0.023 per GB
- data used within 90 days
- The first 10 GB is free each month.

### 2. Long-term storage	
- $0.016 per GB
- data NOT used longer than 90 days
- The first 10 GB is free each month.

## Data ingestion pricing
- Batch loading: Free using
- Streaming inserts: $0.010 per 200 MB
- BigQuery Storage Write API: $0.025 per 1 GB


## Data Extraction pricing
- Batch export: Free using
- Streaming inserts: $1.10 per TB read

## BigQuery SDK

### download sample data
```bash
curl http://files.grouplens.org/datasets/movielens/ml-20m.zip --output ml-20m.zip
unzip ml-20m.zip
cd mv ml-20 PROJECT-PATH/data/ml-20
```

### define ENV variables
```bash
REGION=xxxxx
ZONE=xxxxx
PROJECT_ID=xxxxx
BUCKET_NAME=xxxx
DATASET=xxxx
TABLE_NAME1=xxxx
TABLE_NAME2=xxxx
```

### show dataset
```bash
bq ls
```

### create a dataset (db)
```bash
bq mk \
    --dataset \
    --default_table_expiration 36000 \
    --description "...about dataset..." \
    ${DATASET}
```

### create a table
```bash
bq mk \
    --table \
    --expiration 36000 \
    --description "...about table..." \
    --label organization:development \
    ${DATASET}.${TABLE_NAME1} \
    <COLUMN_1>:<DATA_TYPE>,<COLUMN_2>:<DATA_TYPE>,....
```

### show dataset info
```bash
bq show ${DATASET}.${TABLE_NAME1}
bq show ${DATASET}.${TABLE_NAME2}
```

### data upload
```bash
bq load \
--source_format=<FORMAT> \
--skip_leading_rows 1 \
--autodetect \
${DATASET}.${TABLE_NAME1} \
gs://${BUCKET_NAME}/${FILE_NAME1}
```

FORMAT:
- CSV
- JSON
- Avro
- Parquet
- ORC
- Datastore exports
- Firestore exports


```bash
bq load \
--source_format=CSV \
--skip_leading_rows 1 \
--autodetect \
${DATASET}.${TABLE_NAME1} \
gs://${BUCKET_NAME}/${FILE_NAME2}
```

### show dataset info
```bash
bq show --format=prettyjson <DATASET_NAME>
```

### show table info
```bash
bq show <PROJECT_ID>:<DATASET_ID>.<TABLE_ID>
```
### show table data
```bash
bq head [-n <rows>] <PROJECT_ID>:<DATASET_ID>.<TABLE_ID>
```
### use shell
```bash
bq shell
```

### read the data in the bq shell 
```bash
bq query --use_legacy_sql=false \
'SELECT
   word,
   SUM(word_count) AS count
 FROM
   `bigquery-public-data`.samples.shakespeare
 WHERE
   word LIKE "%raisin%"
 GROUP BY
   word'
```

```bash
bq query --use_legacy_sql=false \
'SELECT <DIM_OR_METRIC> FROM `<DATASET_ID>.<TABLE_ID>` LIMIT 10'
```

### create ML Model
- Details: https://cloud.google.com/bigquery-ml/docs/reference/standard-sql/bigqueryml-syntax-create

example: logistic_reg
```bash
bq query --use_legacy_sql=false \
'CREATE OR REPLACE MODEL `<DATASET_ID>.<TABLE_ID>.<MODEL_NAME>`
OPTIONS
  (model_type='logistic_reg',
    input_label_col=['postition']) AS
SELECT
  <DIMENSION1_>,
  <DIMENSION_2>,
  <DIMENSION_3>,
  ...
FROM `<DATASET_ID>.<TABLE_ID>`'
```

```bash
MODEL_TYPE = { 'LINEAR_REG' | 'LOGISTIC_REG' | 'KMEANS' | 'TENSORFLOW' |
'MATRIX_FACTORIZATION' | 'AUTOML_REGRESSOR' | 'AUTOML_CLASSIFIER' |
'BOOSTED_TREE_CLASSIFIER' | 'BOOSTED_TREE_REGRESSOR' | 'DNN_CLASSIFIER' |
'DNN_REGRESSOR' | 'ARIMA_PLUS' | 'ARIMA' }
```

### evaluate ML Model

example: logistic_reg
```bash
bq query --use_legacy_sql=false \
'SELECT * FROM ML.EVALUATE(MODEL `<DATASET_ID>.<TABLE_ID>.<MODEL_NAME>`,
  (
  SELECT
  <DIMENSION1_>,
  <DIMENSION_2>,
  <DIMENSION_3>,
  ...
  FROM `<DATASET_ID>.<TABLE_ID>`
  )
'
```

## Load AVRO/CSV/JSON data from cloud storage
```bash
bq --location=<location> load \
--source_format=<format> \
<dataset>.<table> \
<path_to_source>
```

ex. AVRO
```bash
bq load \
--source_format=AVRO \
mydataset.mytable \
gs://mybucket/mydata.avro
```

ex. CSV
```bash
bq load \
--source_format=CSV \
mydataset.mytable \
gs://mybucket/mydata.csv \
./myschema.json
```
ex. JSON
```bash
bq load \
--source_format=NEWLINE_DELIMITED_JSON \
mydataset.mytable \
gs://mybucket/mydata.json \
./myschema
```

## Cloud SQL federated queries
- Info: https://cloud.google.com/bigquery/docs/cloud-sql-federated-queries

```bash
bq mk --connection --connection_type='CLOUD_SQL' --properties=PROPERTIES --connection_credential=CREDENTIALS --project_id=PROJECT_ID --location=LOCATION new_connection
```
```bash
SELECT * FROM EXTERNAL_QUERY("connection_id",
"select * from information_schema.tables;");
```

## create a sample table from 

the dataset "tmp" must be default and NOT europe

```roomsql
CREATE TABLE tmp.test_arquet_export AS
SELECT * FROM bigquery-public-data.samples.wikipedia LIMIT 100;
```