# Example

# create a sample table
```sql
WITH
  Microsoft AS (
    SELECT 'Xbox One' AS name, 290 AS price UNION ALL
    SELECT 'Xbox Series X', 210 UNION ALL
    SELECT 'Xbox Series S', 43),
  Nintendo AS (
    SELECT 'Wii U' AS name, 100 AS price UNION ALL
    SELECT 'Nintendo Switch', 200 UNION ALL
    SELECT 'Nintendo Switch Lite', 10)
SELECT * FROM (
  SELECT name, price FROM Microsoft  UNION ALL
  SELECT name, price FROM Nintendo)


SELECT 
   ROW_NUMBER() OVER ( PARTITION BY parent_id) row_num,
   en_name, 
   canonical_name, 
   country_code
FROM 
   ds_us.ads
ORDER BY row_num
```

# create a mini table from a query result
```bash
DATASET1=ds_eu
DATASET2=ds_eu_backup
TABLE_NAME1=covid
TABLE_NAME2=stackoverflow
PROJECT=yygcplearning
BUCKET_NAME=yygcplearning-ds 
FILE_NAME_1=heroes.csv

bq query \
--destination_table ${DATASET1}.${TABLE_NAME1} \
--label bqsandbox:dev \
--use_legacy_sql=false \
'SELECT 
  * 
FROM `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` 
LIMIT 100
'
```

# create a mini tables 
```sql
-- location US
CREATE TABLE ds_us.smalltb AS (
    SELECT * FROM `bigquery-public-data.austin_311.311_service_requests` LIMIT 10
)

-- location EU
CREATE TABLE ds_eu.smalltb AS (
    SELECT * FROM `bigquery-public-data.covid19_ecdc_eu.covid_19_geographic_distribution_worldwide` LIMIT 10
)
```

#  create a mini table from cloud storage (CSV)
```bash
bq load \
    --source_format=CSV \
    --skip_leading_rows 1 \
    --autodetect \
    ${DATASET2}.${TABLE_NAME2} \
    gs://${BUCKET_NAME}/${FILE_NAME_1}
```
