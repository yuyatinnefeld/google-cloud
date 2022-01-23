# GCP Project 7 - Setup Cloud SQL DB

## About
- Create a Cloud SQL instance & DB
- import data into the DB
- check the data

## Info
- https://cloud.google.com/sql/docs/mysql/quickstart
- https://cloud.google.com/sql/docs/mysql/quickstart-private-ip

## Prep your environment
```bash
gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
echo "$PROJECT_ID"
export BUCKET=${PROJECT_ID}-ml
echo "$BUCKET"
```

## Create a Cloud SQL instance

for us-central1-f

```bash
gcloud sql instances create taxi \
    --tier=db-n1-standard-1 --activation-policy=ALWAYS
```

for custom setup

```bash
ZONE="xxxxx"
PASSWORD="xxxxx"
CPU_NUM=? #1,2,3
MEMORY_SIZE="xxxxx" #7680MB
DB_VERSION="xxxxx" #MYSQL_8_0 / POSTGRES_12
INSTANCE_NAME="taxi"

gcloud sql instances create ${INSTANCE_NAME}  \
--database-version=${DB_VERSION} --cpu=${CPU_NUM} --memory=${MEMORY_SIZE}  \
--zone=${ZONE} --root-password=${PASSWORD}
```


This will take a few minutes to complete.

## Setup DB
```bash
# setup username & password
gcloud sql users set-password root --host % --instance taxi \
 --password Passw0rd

# create an environment var with the IP address
export ADDRESS=$(wget -qO - http://ipecho.net/plain)/32
echo "$ADDRESS"

# Whitelist the Cloud Shell instance for management access 
gcloud sql instances patch taxi --authorized-networks $ADDRESS

# get the IP of the SQL instance
MYSQLIP=$(gcloud sql instances describe \
taxi --format="value(ipAddresses.ipAddress)")

echo $MYSQLIP

# login in the DB
mysql --host=$MYSQLIP --user=root \
      --password --verbose

# create the DB "bts"
create database if not exists bts;
use bts;

# create the table "trips"
drop table if exists trips;

create table trips (
  vendor_id VARCHAR(16),		
  pickup_datetime DATETIME,
  dropoff_datetime DATETIME,
  passenger_count INT,
  trip_distance FLOAT,
  rate_code VARCHAR(16),
  store_and_fwd_flag VARCHAR(16),
  payment_type VARCHAR(16),
  fare_amount FLOAT,
  extra FLOAT,
  mta_tax FLOAT,
  tip_amount FLOAT,
  tolls_amount FLOAT,
  imp_surcharge FLOAT,
  total_amount FLOAT,
  pickup_location_id VARCHAR(16),
  dropoff_location_id VARCHAR(16)
);

# check the table
describe trips;
# query the trips (return empty set)
select distinct(pickup_location_id) from trips;

exit
```
## Add data to Cloud SQL instance

```bash
# copy the New York City taxi trips CSV files 
gsutil cp gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_1.csv trips.csv-1

gsutil cp gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv trips.csv-2

# import the CSV data into Cloud SQL
mysqlimport --local --host=$MYSQLIP --user=root --password \
--ignore-lines=1 --fields-terminated-by=',' bts trips.csv-*

rm -rf trips.csv-1 trips.csv-2
```

## Connect MYSQL and check the data

```bash
mysql --host=$MYSQLIP --user=root  --password

# select the target DB
use bts;

# check the data
select distinct(pickup_location_id) from trips;

# see the min and max values
select
  max(trip_distance),
  min(trip_distance)
from
  trips;

# query with the where condition
select count(*) from trips where trip_distance = 0;


# query the payment_type
select
  payment_type,
  count(*)
from
  trips
group by
  payment_type;

exit
```