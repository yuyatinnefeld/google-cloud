# GCP Project 2 - Create the Recommendation ML

## About
- Transfer data from Cloud Storage into Cloud SQL
- Run the ML model on the Dataproc cluster

## Info
- Data: create ML Model 
- GCP Services: Cloud SQL, Google Storage, Dataproc

## Setup SQL

### create Cloud SQL instance
- Type:MySQL 
- Instance ID: rentals
- password:password
- region: us-central1

### connect MySQL
```bash
gcloud sql connect rentals --user=root --quiet
Allowlisting your IP for incoming connection for 5 minutes...⠹

```
check dbs

```sql
SHOW DATABASES;
```

### create Table
```sql
CREATE DATABASE IF NOT EXISTS recommendation_spark;

USE recommendation_spark;

DROP TABLE IF EXISTS Recommendation;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Accommodation;

CREATE TABLE IF NOT EXISTS Accommodation
(
  id varchar(255),
  title varchar(255),
  location varchar(255),
  price int,
  rooms int,
  rating float,
  type varchar(255),
  PRIMARY KEY (ID)
);

CREATE TABLE  IF NOT EXISTS Rating
(
  userId varchar(255),
  accoId varchar(255),
  rating int,
  PRIMARY KEY(accoId, userId),
  FOREIGN KEY (accoId)
    REFERENCES Accommodation(id)
);

CREATE TABLE  IF NOT EXISTS Recommendation
(
  userId varchar(255),
  accoId varchar(255),
  prediction float,
  PRIMARY KEY(userId, accoId),
  FOREIGN KEY (accoId)
    REFERENCES Accommodation(id)
);
SHOW DATABASES;
```

show tables 
```sql
USE recommendation_spark;
SHOW TABLES;
SELECT * FROM Accommodation;
```

## Upload data in Cloud Storage Buckets


```bash
echo "Creating bucket: gs://$DEVSHELL_PROJECT_ID"
gsutil mb gs://$DEVSHELL_PROJECT_ID

echo "Copying data to our storage from public dataset"
gsutil cp gs://cloud-training/bdml/v2.0/data/accommodation.csv gs://$DEVSHELL_PROJECT_ID
gsutil cp gs://cloud-training/bdml/v2.0/data/rating.csv gs://$DEVSHELL_PROJECT_ID

echo "Show the files in our bucket"
gsutil ls gs://$DEVSHELL_PROJECT_ID

echo "View some sample data"
gsutil cat gs://$DEVSHELL_PROJECT_ID/accommodation.csv

```
## Load Cloud Storage data into Cloud SQL

1. Import Accommodation

SQL > Import
- Source: <bucketname>/accommodation.csv
- format: CSV
- Database: recommendation_spark
- Table: Accommodation

2. Import Rating

SQL > Import
- Source: <bucketname>/rating.csv
- format: CSV
- Database: recommendation_spark
- Table: Rating

## Explore Cloud SQL data

```sql
USE recommendation_spark;

SELECT * FROM Accommodation
LIMIT 15;

SELECT * FROM Rating
LIMIT 15;

SELECT
    COUNT(userId) AS num_ratings,
    COUNT(DISTINCT userId) AS distinct_user_ratings,
    MIN(rating) AS worst_rating,
    MAX(rating) AS best_rating,
    AVG(rating) AS avg_rating
FROM Rating;

SELECT
    userId,
    COUNT(rating) AS num_ratings
FROM Rating
GROUP BY userId
ORDER BY num_ratings DESC;
```

## Launch Dataproc

1. Dataproc API Enable
2. create cluster 
- name: rentals
- master node maschine type: n1-standard-2 (2 vCPUs, 7.5 GB memory
- worker node maschine type: n1-standard-2 (2 vCPUs, 7.5 GB memory)

3. Note the Name, Zone and Total worker nodes in your cluster.

4. Configure Cluster
```bash
echo "Authorizing Cloud Dataproc to connect with Cloud SQL"
CLUSTER=rentals
CLOUDSQL=rentals
ZONE=us-central1-c
NWORKERS=2

machines="$CLUSTER-m"
for w in `seq 0 $(($NWORKERS - 1))`; do
   machines="$machines $CLUSTER-w-$w"
done

echo "Machines to authorize: $machines in $ZONE ... finding their IP addresses"
ips=""
for machine in $machines; do
    IP_ADDRESS=$(gcloud compute instances describe $machine --zone=$ZONE --format='value(networkInterfaces.accessConfigs[].natIP)' | sed "s/\['//g" | sed "s/'\]//g" )/32
    echo "IP address of $machine is $IP_ADDRESS"
    if [ -z  $ips ]; then
       ips=$IP_ADDRESS
    else
       ips="$ips,$IP_ADDRESS"
    fi
done

echo "Authorizing [$ips] to access cloudsql=$CLOUDSQL"
gcloud sql instances patch $CLOUDSQL --authorized-networks $ips
```

5. On the main Cloud SQL page, under Connect to this instance, copy your Public IP Address to your clipboard. (Alternatively, write it down because you're using it next.)

## run the ML model

1. copy the file
```bash
gsutil cp gs://cloud-training/bdml/v2.0/model/train_and_apply.py train_and_apply.py
cloudshell edit train_and_apply.py
```
2. When prompted, select Open in New Window.

3. Wait for the Editor UI to load.

4. Open the train_and_apply.py file, find line 30: CLOUDSQL_INSTANCE_IP, and paste the Cloud SQL IP address you copied earlier.
```bash
# MAKE EDITS HERE
CLOUDSQL_INSTANCE_IP = '<paste-your-cloud-sql-ip-here>'   # <---- CHANGE (database server IP)
CLOUDSQL_DB_NAME = 'recommendation_spark' # <--- leave as-is
CLOUDSQL_USER = 'root'  # <--- leave as-is
CLOUDSQL_PWD  = '<type-your-cloud-sql-password-here>'  # <---- CHANGE
```

5. Find line 33: CLOUDSQL_PWD and type in your Cloud SQL password,

6. The editor will autosave but to be sure, select File > Save.

7. From the Cloud Shell ribbon, click on the Open Terminal icon and copy this file to your Cloud Storage bucket using this Cloud Shell command:
```bash
gsutil cp train_and_apply.py gs://$DEVSHELL_PROJECT_ID
```

## run your ML job on Dataproc
1. click rentals cluster
2. click Submit job
3. For Job type, select PySpark and for Main python file, specify the location of the Python file you uploaded to your bucket. Your <bucket-name> is likely to be your Project ID, which you can find by clicking on the Project ID dropdown in the top navigation menu. 
- gs://<bucket-name>/train_and_apply.py
4. For Max restarts per hour, enter 1.
5. click Submit
6. Select Navigation menu > Dataproc > Job tab to see the Job status.
