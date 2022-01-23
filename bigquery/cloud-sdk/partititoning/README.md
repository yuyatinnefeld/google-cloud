# Partitioning and Clustering
Both partitioning and clustering can improve performance and reduce query cost.

## Partitioning
A partitioned table is a special table that is divided into segments, called partitions, that make it easier to manage and query your data.


Info (Details): 
- https://cloud.google.com/bigquery/docs/partitioned-tables

## Partition types
- Time-unit column
- Ingestion time
- Integer range

### Time-unit column-partitioned table
```sql
SELECT 
CREATE TABLE
  <dataset>.<tablename> (transaction_id INT64, transaction_date DATE)
PARTITION BY
  transaction_date
OPTIONS(
  partition_expiration_days=3,
  require_partition_filter=true
)
```

```bash
bq mk -t \
  --schema 'ts:TIMESTAMP,qtr:STRING,sales:FLOAT' \
  --time_partitioning_field ts \
  --time_partitioning_type HOUR \
  --time_partitioning_expiration 259200  \
  <dataset>.<tablename>
  ```

### Ingestion-time partitioned table
```sql
CREATE TABLE
  <dataset>.<tablename> (transaction_id INT64)
PARTITION BY
  _PARTITIONDATE
OPTIONS(
  partition_expiration_days=3,
  require_partition_filter=true
)
```

```bash
bq mk -t \
  --schema 'qtr:STRING,sales:FLOAT,year:STRING' \
  --time_partitioning_type DAY \
  --time_partitioning_expiration 259200 \
  <dataset>.<tablename>
```

## Integer-range partitioned table
```sql
CREATE TABLE <dataset>.<tablename> (customer_id INT64, date1 DATE)
PARTITION BY
  RANGE_BUCKET(customer_id, GENERATE_ARRAY(0, 100, 10))
OPTIONS(
  require_partition_filter=true
)
```
```bash
bq mk -t \
  --schema 'customer_id:INTEGER,qtr:STRING,sales:FLOAT' \
  --range_partitioning=customer_id,0,100,10 \
  <dataset>.<tablename>
```

## Clustering
When you create a clustered table in BigQuery, the table data is automatically organized based on the contents of one or more columns in the table’s schema.
Clustering is used for the text columns or id columns. Clustering columns must be top-level, NON-REPEATED columns.
You might not see a significant difference in query performance between a clustered and unclustered table if the table or partition is under 1 GB.

```sql
CREATE TABLE <dataset>.<tablename> (transaction_date DATE, customer_id INT64, transaction_amount FLOAT)
PARTITION BY
  transaction_date
CLUSTER BY customer_id
OPTIONS(
  partition_expiration_days=3,
  description="cluster"
)
```


```bash
bq mk -t \
--expiration 2592000 \
--schema 'ts:TIMESTAMP,customer_id:STRING,transaction_amount:FLOAT' \
--clustering_fields customer_id \
--description "This is my clustered table" \
--label org:dev \
<dataset>.<tablename>
```