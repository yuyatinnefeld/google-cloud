# GCP Project 4 - Real Time IoT Dashboard

## About
- Create streaming data pipeline for a real time dashboard
- Monitor where is the fleet of vehicles

## Info
- Data: Taxi Data
- GCP Services: Pub/Sub, Dataflow, BigQuery, Data Studio


## Enable APIs and Services
- Cloud Pub/Sub API
- Dataflow API

## Create BigQuery Dataset

```bash
# crreate taxirides dataset
bq mk taxirides

# create taxirides.realtime table
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime
```
## Create a Cloud Storage Bucket
- Bucket Name: Project ID
```bash
echo "Creating bucket: gs://$DEVSHELL_PROJECT_ID"
gsutil mb gs://$DEVSHELL_PROJECT_ID
```

## Setup Dataflow Pipeline

1. Navigation menu > Dataflow.
2. Click CREATE JOB FROM TEMPLATE.
3. Define
- Job Name: streaming-taxi-pipelin
- Region: us-central1 
- Dataflow Templete: Pub/Sub Topic to BigQuery template
5. Under Input Pub/Sub topic, enter 
```bash
projects/pubsub-public-data/topics/taxirides-realtime
```
### Output results into the sink (BigQuery)

6. Under BigQuery output table, enter 
```bash
<myprojectid>:taxirides.realtime
```

### Define the temporary location

7. Under Temporary location, enter 
```bash
gs://<mybucket>/tmp/
```

8. run Job

Note: If the dataflow job fails for the first time then re-create a new job template with new job name and run the job.


## Analyze the realtime data in BigQuery


```sql
SELECT * FROM taxirides.realtime LIMIT 10
```

If no records are returned, wait another minute and re-run the above query (Dataflow takes 3-10 minutes to setup the stream). You will receive a similar output

### Perform aggregations on the stream for reporting

```sql
WITH streaming_data AS (

SELECT
  timestamp,
  TIMESTAMP_TRUNC(timestamp, HOUR, 'UTC') AS hour,
  TIMESTAMP_TRUNC(timestamp, MINUTE, 'UTC') AS minute,
  TIMESTAMP_TRUNC(timestamp, SECOND, 'UTC') AS second,
  ride_id,
  latitude,
  longitude,
  meter_reading,
  ride_status,
  passenger_count
FROM
  taxirides.realtime
WHERE ride_status = 'dropoff'
ORDER BY timestamp DESC
LIMIT 100000

)

# calculate aggregations on stream for reporting:
SELECT
 ROW_NUMBER() OVER() AS dashboard_sort,
 minute,
 COUNT(DISTINCT ride_id) AS total_rides,
 SUM(meter_reading) AS total_revenue,
 SUM(passenger_count) AS total_passengers
FROM streaming_data
GROUP BY minute, timestamp
```

## Create a Real time dashboard

1. Click EXPLORE DATA > Explore with Data Studio in BigQuery page

2. Click GET STARTED, then click AUTHORIZE.

3. Specify the below settings:
- Chart type: Combo chart
- Date range Dimension: dashboard_sort
- Dimension: dashboard_sort
- Drill Down: dashboard_sort (Make sure that Drill down option is- turned ON)
- Metric: SUM() total_rides, SUM() total_passengers, SUM() total_revenue
- Sort: dashboard_sort, Ascending (latest rides first)


## Create a time series dashboard

1. Open the link:
> https://datastudio.google.com/u/0/

2. New Report > Add Data Source = BigQuery

3. Under CUSTOM QUERY, click qwiklabs-gcp-xxxxxxx > Enter Custom Query, add the following query.
```sql
SELECT
  *
FROM
  taxirides.realtime
WHERE
  ride_status='dropoff'
```
4. click Add > Add to report

5. create a time series chart
- Chart type: Line chart
- Dimension: timestamp
- Metric: meter_reading(SUM)

## Stop the Dataflow job 
