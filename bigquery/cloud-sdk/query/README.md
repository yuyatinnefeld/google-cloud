# Query BQ data

## Query Types
- Interactive queries (default)
- Batch queries

## Query Jobs
Jobs are actions that BigQuery runs on your behalf
- load data
- export data
- query data
- copy data. 

## Saving Query and sharing
- When you save a query, it can be private (visible only to you)
- You can share at the project or public level


## Batch Query
```bash
bq query \
--batch \
--destination_table ${DATASET}.${TABLE} \
--use_legacy_sql=false \
'SELECT day, month FROM `ds_eu.covid`'
```

## Dry Run Query
- You can use the --dry_run flag to estimate the number of bytes read by the query.

```bash
bq query \
--use_legacy_sql=false \
--dry_run \
'SELECT day, month FROM `ds_eu.covid`'

Query successfully validated. Assuming the tables are not modified, running this query will process 1600 bytes of data.
```

## Temporary and permanent tables

- BigQuery uses temporary tables to cache query results that aren't written to a permanent table. 
- You can also create temporary tables for your own use. 
- After a query finishes, the temporary table exists for up to 24 hours.

```bash
bq query \
--destination_table ${DATASET}.${TABLE} \
--use_legacy_sql=false \
'SELECT * FROM `ds_eu.covid` WHERE month = 6 OR month = 7'
```

## Using Query Cache
- No storage costs for cached temporary tables, but if you write query results to a permanent table, you are charged
- All query results are cached in temporary tables for 24 hours.
- In addition to reducing costs, queries that use cached results are significantly faster

### Exceptions to query caching
Query results are not cached:
- When a destination table is specified in the job configuration, the Cloud Console, the bq command-line tool, or the API
- When tables have recently received streaming inserts 
- Query uses non-deterministic functions; for example, date and time functions such as CURRENT_TIMESTAMP() and NOW()
- If you are querying multiple tables using a wildcard
- If the query runs against an external data source other than Cloud Storage. (BigQuery standard SQL queries on Cloud Storage are supported by cached query results.)

## Parameterized Queries
- To specify a named parameter, use the @ character followed by an identifier, such as @param_name

```bash
# single parameter
bq query \
--use_legacy_sql=false \
--parameter=param::chokoball \
'SELECT @param'

bq query \
--use_legacy_sql=false \
--parameter=param::INT64:1999 \
'SELECT @param'


# muliti parameter
bq query \
--use_legacy_sql=false \
--parameter=month_6:INT64:6 \
--parameter=month_7:INT64:7 \
'SELECT 
  day, month 
FROM 
  `ds_eu.covid`
WHERE
  month = @month_6
OR
  month = @month_7'


# timestamps in parameterized queries
bq query \
--use_legacy_sql=false \
--parameter='ts_value:TIMESTAMP:2030-12-07 08:00:00' \
'SELECT
  TIMESTAMP_ADD(@ts_value, INTERVAL 1 HOUR)'

# array in parameterized queries

bq query \
--use_legacy_sql=false \
--parameter='gender::M' \
--parameter='states:ARRAY<STRING>:["WA", "WI", "WV", "WY"]' \
'SELECT
  name,
  SUM(number) AS count
FROM
  `bigquery-public-data.usa_names.usa_1910_2013`
WHERE
  gender = @gender
  AND state IN UNNEST(@states)
GROUP BY
  name
ORDER BY
  count DESC
LIMIT
  10'

# struct in parameterized queries
bq query \
--use_legacy_sql=false \
--parameter='struct_val1:STRUCT<x INT64, y STRING, z INT64>:{"x": 1, "y": "foo", "z": 100}' \
'SELECT
  @struct_val1 AS struct_value_123'

```

## Table Sampling
- Table sampling lets you query random subsets of data from large BigQuery tables. 
- usefully for modeling data


```sql
SELECT * FROM dataset.my_table TABLESAMPLE SYSTEM (10 PERCENT)
```

```bash
bq query --use_legacy_sql=false --parameter=percent:INT64:50 \
    'SELECT * FROM `dataset.my_table` TABLESAMPLE SYSTEM (@percent PERCENT)`
```

## Querying multiple tables using a wildcard table
- Wildcard tables enable you to query multiple tables using concise SQL statements. Wildcard tables are available only in standard SQL

```sql
# standardSQL
SELECT * FROM (
  SELECT
    *
  FROM
    `dataset.customer_data202101` UNION ALL
  SELECT
    *
  FROM
    `dataset.customer_data202102` UNION ALL
  SELECT
    *
  FROM
    `dataset.customer_data202103` UNION ALL

  # ... Tables omitted for brevity

  SELECT
    *
  FROM
    `dataset.customer_data202112` )

# wildcard table
SELECT * FROM (
  SELECT
    *
  FROM
    `dataset.customer_data2021*`
)

# filtering selected tables using _TABLE_SUFFIX (only 202101 and 202102 and 202103)

SELECT * FROM (
  SELECT
    *
  FROM
    `dataset.customer_data2021*` 
  WHERE
   (_TABLE_SUFFIX = '01' OR _TABLE_SUFFIX = '02' OR _TABLE_SUFFIX = '03')

)

# filtering selected table _TABLE_SUFFIX + BETWEEN

SELECT * FROM (
  SELECT
    *
  FROM
    `dataset.customer_data2021*` 
  WHERE
   (_TABLE_SUFFIX BETWEEN '01' AND '06')

)

```

## Scheduling Queries
- enable  BigQuery Data Transfer API 
- 
```bash
# create daily based query job
bq query \
--use_legacy_sql=false \
--destination_table=ds_eu_backup.covid \
--display_name='My Scheduled Query' \
--schedule='every 24 hours' \
--replace=true \
'SELECT * FROM ds_eu.covid'


# view the status of scheduled queries
bq ls \
--transfer_config \
--transfer_location=eu

# update a scheduled query
# resource (i.e. projects/928012749692/locations/europe/transferConfigs/614c865f-0000-2211-8720-30fd38131378)

bq mk \
--transfer_run \
--start_time 2021-08-25T00:00:00Z \
--end_time 2021-08-28T00:00:00Z \
projects/928012749692/locations/europe/transferConfigs/614c865f-0000-2211-8720-30fd38131378


```