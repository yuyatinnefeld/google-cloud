# Snapshot

## Info (Details): 
- https://cloud.google.com/bigquery/docs/table-snapshots-intro

## Benefits
- Keep a record for longer than seven days. With BigQuery time travel, you can only access a table's data from seven days ago or more recently.

- BigQuery only stores bytes that are different between a snapshot and its base table, so a table snapshot typically uses less storage than a full copy of the table.

## Limitation
- Table snapshots are not fully supported in the Cloud Console. For best results, use the bq command-line tool, APIs, or SQL statements

- A table snapshot must be in the same project as its base table.

- Table snapshots are read-only; you can't update the data in a table snapsho

## Create a table snapshot 


### table snapshot with an expiration

```sql
CREATE SNAPSHOT TABLE
  myproject.library_backup.books
  CLONE myproject.library.books
  OPTIONS(expiration_timestamp = TIMESTAMP "2022-04-27 12:30:00.00-08:00")
```

```bash
bq cp \
    --snapshot \
    --no_clobber \
    --expiration=86400 \
    <DATASET_ID>.<TABLE_ID> <BACKUP_DATASET_ID>.<TABLE_ID>
```

### table snapshot using time travel

```sql
CREATE SNAPSHOT TABLE
  <BACKUP_DATASET_ID>.<TABLE_ID>
  CLONE <DATASET_ID>.<TABLE_ID>
  FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR);
```

```bash
bq cp \
    --no_clobber \
    --snapshot <DATASET_ID>.<TABLE_ID>@-3600000 \
    <BACKUP_DATASET_ID>.<TABLE_ID>
```

## restore to a new table

```sql
CREATE TABLE library.books_new
  CLONE library_backup.books
```
```bash
bq cp \
    --restore \
    --no_clobber \
    <BACKUP_DATASET_ID>.<TABLE_ID> <DATASET_ID>.<NEW_TABLE>
```

## listing the snapshots
```sql
SELECT *
  FROM <BACKUP_DATASET_ID>.INFORMATION_SCHEMA.TABLE_SNAPSHOTS;
```

```bash
bq ls <BACKUP_DATASET_ID>
```

## get a table snapshot's metadata

```bash
bq show --format=prettyjson <BACKUP_DATASET_ID>.<TABLE_ID>
```

## copy the snapshot
```bash
bq cp --no_clobber --expiration=86400 <BACKUP_DATASET_ID>.<TABLE_ID> \
  <DATASET_ID>.<NEW_TABLE>
```

## delete the snapshot
```bash
bq rm -f <DATASET_ID>.<NEW_TABLE>
```