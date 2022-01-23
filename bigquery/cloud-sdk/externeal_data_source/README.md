# External Data Source

BigQuery supports the following external data sources:

- Bigtable
- Cloud SQL
- Cloud Storage
- Drive

## 2 different mechanisms 
- External tables
    - Bigtable
    - Cloud Storage
    - Driv

The table metadata, including the table schema, is stored in BigQuery storage, but the data itself resides in the external source.

- Federated queries
    - Cloud SQL
    - Cloud Spanner

A federated query is a way to send a query statement to an external database and get the result back as a temporary table.

## External tables

### Limitations
- Query performance not high as native BigQuery table query
- You cannot run a BigQuery job that exports data from an external table
- You cannot reference an external table in a wildcard table query
- External tables do not support clustering
- The query results (Bigtable, Drive) are not cached.

### Querying Cloud Storage data

```bash
SCHEMA=num:INTEGER,age:INTEGER,webframework:STRING
SOURCE_FORMAT=CSV
BUCKET_NAME=yygcplearning-ds
FILE_NAME=stackoverflow.csv
DATASET=ds_eu
TABLE=stackoverflow
bq mk \
--external_table_definition=${SCHEMA}@${SOURCE_FORMAT}=gs://${BUCKET_NAME}/${FILE_NAME} \
 ${DATASET}.${TABLE}
```

### Querying externally partitioned data 
BigQuery supports querying externally partitioned data in Avro, Parquet, ORC, JSON, and CSV formats that is stored on Cloud Storage using a default hive partitioning layout


#### Creating an external table for hive-partitioned dat
```bash
GCS_URI_SHARED_PREFIX=gs://myBucket/myTable/{dt:DATE}/{val:STRING}
bq mkdef --source_format=ORC \
--hive_partitioning_mode=AUTO \
--hive_partitioning_source_uri_prefix=${GCS_URI_SHARED_PREFIX} \
${GCS_URIS} > ${TABLE_DEF_FILE}
```

##  BigQuery Connection API


```bash
LOCATION=eu
PROPERTIES='{"instanceId":"federation-test:us-central1:mytestsql","database":"mydatabase""type":"MYSQL"}'
CREDENTIALS='{"username":"myusername", "password":"mypassword"}'

# create a connection with the CLOUD SQL
bq mk --connection \
--display_name='nice display name' \
--connection_type='CLOUD_SQL' \
--properties=${PROPERTIES} \
--connection_credential=${CREDENTIALS} \
--project_id=${PROJECT_ID} --location=${LOCATION} \
${CONNECTION_ID}


# get information about a connection resource
bq show --connection ${PROJECT_ID}.${LOCATION}.${CONNECTION_ID}

# list all connection resources
bq ls --connection --project_id=${PROJECT_ID} --location=${LOCATION}

# delete a connection
bq rm --connection ${PROJECT_ID}.${LOCATION}.${CONNECTION_ID}
```

## Federated Queries
- Use the EXTERNAL_QUERY SQL function to run federated queries.

```sql
SELECT * FROM EXTERNAL_QUERY(
'connection_id',
'''SELECT * FROM customers AS c ORDER BY c.customer_id'');
```