# View

## Info (Details): 
- https://cloud.google.com/bigquery/docs/views-intro

## About
A VIEW in SQL Server is like a virtual table that contains data from one or multiple tables. It does not hold any data and does not exist physically in the database. Similar to a SQL table, the view name should be unique in a database. It contains a set of predefined SQL queries to fetch data from the database


## Create a view

```bash
bq mk \
--use_legacy_sql=false \
--expiration 3600 \
--description "This is my view" \
--label yt:dev \
--view \
'SELECT
  complaint_type,
  source
FROM
  `bigquery-public-data.austin_311.311_service_requests`
WHERE
  city = "Austin"
' \
<DATASET_ID>.<TABLE_ID>
```

## listing
```bash
bq ls --format=pretty <DATASET_ID>
```

## show the details about a view
```bash
bq show --format=prettyjson ds_us.austin_view
```

## update 
```bash
bq update \
--use_legacy_sql=false \
--view \
'SELECT
  complaint_type,
  source,
  status
FROM
  `bigquery-public-data.austin_311.311_service_requests`
WHERE
  city = "Austin"
' \
<DATASET_ID>.<TABLE_ID>
```

## delete
```bash
bq rm -f -t <DATASET_ID>.<TABLE_ID>
```