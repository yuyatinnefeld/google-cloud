# Metadata with INFORMATION_SCHEMA

## Querying dataset metadata
BigQuery stores metadata about each object stored in it. You can query these metadata tables to get a better understanding of a dataset and it's contents. [See documentation.](https://cloud.google.com/bigquery/docs/dataset-metadata)


## INFORMATION_SCHEMA is a series of views that provide access to:
- dataset metadata
- job metadata
- job timeline metadata
- access control metadata
- reservation metadata
- streaming metadata
- routine metadata
- table metadata
- table snapshot metadata
- view metadata

## Pricing 
On-Demand: 10 MB is the minimum billing amount for on-demand queries against INFORMATION_SCHEMA.
Flat-Rate: Queries against INFORMATION_SCHEMA views and tables consume your purchased BigQuery slots


## Dataset qualifier (Metadata for Tables)

```sql
SELECT * FROM myDataset.INFORMATION_SCHEMA.TABLES;
```

```bash
bq query --nouse_legacy_sql \
'SELECT * FROM myDataset.INFORMATION_SCHEMA.TABLES'
```


Listing - INFORMATION_SCHEMA.SCHEMATA: 
```bash
COLUMNS
COLUMN_FIELD_PATHS
PARAMETERS
ROUTINES
ROUTINE_OPTIONS
TABLES
TABLE_OPTIONS
VIEWS
```

## Region qualifier (Metadata for Datasets)

```sql
SELECT * FROM region-eu.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_PROJECT;
```


```bash
bq query --nouse_legacy_sql \
'SELECT * FROM region-eu.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_PROJECT'
```

Option by Region qualifiers: 
```bash
ASSIGNMENT_CHANGES_BY_PROJECT
ASSIGNMENTS_BY_PROJECT
CAPACITY_COMMITMENT_CHANGES_BY_PROJECT
CAPACITY_COMMITMENTS_BY_PROJECT
JOBS_BY_ORGANIZATION
JOBS_BY_FOLDER
JOBS_BY_PROJECT
JOBS_BY_USER
JOBS_TIMELINE_BY_ORGANIZATION
JOBS_TIMELINE_BY_FOLDER
JOBS_TIMELINE_BY_PROJECT
JOBS_TIMELINE_BY_USER
OBJECT_PRIVILEGES
RESERVATION_CHANGES_BY_PROJECT
RESERVATIONS_PROJECT
STREAMING_TIMELINE_BY_ORGANIZATION
STREAMING_TIMELINE_BY_FOLDER
STREAMING_TIMELINE_BY_PROJECT
SCHEMATA
SCHEMATA_OPTIONS
```

## Job Metadata
You can query the INFORMATION_SCHEMA.JOBS_BY_* view to retrieve real-time metadata about BigQuery jobs.
The Views contain the current job and the history of jobs completed in the past 180 days.


Calculate AVG Slots
```sql
SELECT
   SUM(total_slot_ms) / (1000*60*60*24*7) AS avg_slots
 FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
 WHERE
   -- Filter by the partition column first to limit the amount of data scanned. Eight days
   -- allows for jobs created before the 7 day end_time filter.
   creation_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 8 DAY) AND CURRENT_TIMESTAMP()
   AND job_type = "QUERY"
   AND statement_type != "SCRIPT"
   AND end_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY) AND CURRENT_TIMESTAMP()
```

Most Expensive Jobs
```sql
 SELECT
   job_id,
   job_type,
   priority,
   state,
   user_email,
   total_bytes_processed,
   total_slot_ms
 FROM `region-eu`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
 WHERE EXTRACT(DATE FROM  creation_time) = current_date()
 ORDER BY total_bytes_processed DESC
 LIMIT 10
```

daily based performance reporting
```sql
SELECT
EXTRACT(DAY FROM period_start) as period_start,
SUM(period_slot_ms) AS total_slot_ms,
SUM(IF(state = "PENDING", 1, 0)) as PENDING,
SUM(IF(state = "RUNNING", 1, 0)) as RUNNING
FROM
 `region-eu`.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_PROJECT
GROUP BY period_start
```
