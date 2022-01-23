# GCP Project 1 - Deploy Cloud Storage Website

## About
- Install Github Website repo via GCE
- Transform data from GCE into Cloud Storage
- Deploy this via Cloud Storage 

## Info
- Data: the public GCP earthquake dataset
- GCP Services: GCE, Google Storage

## Create GCE instance
- 1vCPU
- name:earthquakevm
- Debian GNU/Linux
- Allow full access to all Cloud API

```bash
PROJECT_ID= "yuyatinnefeld_testing"
INSTANCE_NAME="earthquakevm"
ZONE_OF_INSTANCE="europe-west3-b"

# create instance
gcloud compute instances create \
    --project ${PROJECT_ID} \
    --zone ${ZONE_OF_INSTANCE} \
    ${INSTANCE_NAME}

# connect ssh
gcloud compute ssh rancher@${INSTANCE_NAME} \
    --project ${PROJECT_ID} \
    --zone ${ZONE_OF_INSTANCE}
```

## Setup GCE / VM Instance - earthquakevm

```bash
# install git
sudo apt-get install -y git

# clone google repo
git clone https://www.github.com/GoogleCloudPlatform/training-data-analyst

# go earthquakevm dir
cd traning-datanalayst/courses/bdml_fundamentals/demos/earthquakevm

# check the files
ls

# missing software check and install these
cat install_missing.sh
./install_missing.sh

# run ingest.sh
./ingest.sh

# check csv file
head earthquakes.csv

# create an image out of it
./taransform.py

# check the image
ls *.png

```
## Create Cloud storage backet
- Storage access control model: set object-level and bucket-level permission


```bash
PROJECT_ID= "yuyatinnefeld-testing"
STORAGE_CLASS="Standard"
REGION="europe-west3"
OBJECT_NAME="earthquake"
BUCKET_NAME=${OBJECT_NAME}-${PROJECT_ID}

gsutil mb -p ${PROJECT_ID} \
    -c ${STORAGE_CLASS} \
    -l ${REGION} \
    -b on gs://${BUCKET_NAME}
```

## Copy VM Data to Cloud storage backet

copy the earthquakes of GCE (earthquakevm) to storage

```bash
gsutil ls gs://${BUCKET_NAME}
gsutil cp earthquakes.* gs://${BUCKET_NAME}
```

## Delete GCE instance
```bash
PROJECT_ID= 
INSTANCE_NAME="earthquakevm"
ZONE_OF_INSTANCE="europe-west3-b"

gcloud compute instances delete \
    --project ${PROJECT_ID} \
    --zone ${ZONE_OF_INSTANCE} \
    ${INSTANCE_NAME}

```

6. change storage data public
- GStorage> select 3 files >Permissions>add members
- allUsers + Role: Storage Object Viewer

7. open the qearthquakes.htm