# Create a Website

## Services / Stacks

- GCE
- Nginx
- PHP
- Cloud SQL
- GSC

## Setup Steps


### 1 Deploy a web server VM instance
```bash
PROJECT_ID=$DEVSHELL_PROJECT_ID
REGION=us-central1
ZONE=us-central1-a
VM_NAME=bloghost

gcloud compute instances create $VM_NAME \
--project=$PROJECT_ID \
--zone=$ZONE \
--machine-type=e2-medium \
--metadata=startup-script=apt-get\ update$'\n'apt-get\ install\ apache2\ php\ php-mysql\ -y$'\n'service\ apache2\ restart \
--maintenance-policy=MIGRATE \
--provisioning-model=STANDARD \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--create-disk=auto-delete=yes,boot=yes,device-name=bloghost,image=projects/debian-cloud/global/images/debian-9-stretch-v20220406,mode=rw,size=10,type=projects/bda-so-mario-dev/zones/us-central1-a/diskTypes/pd-balanced \
--tags=http-server \
--reservation-affinity=any

# ex. 
#EXTERNAL_IP: 34.71.16.80
#
```
### 2. Create a GCS bucket
```bash
gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID
gsutil cp gs://cloud-training/gcpfci/my-excellent-blog.png my-excellent-blog.png
gsutil cp my-excellent-blog.png gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png
gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png
```
### 3. Create the Cloud SQL instance
```bash
INSTANCE_NAME=blog-db

gcloud sql instances create $INSTANCE_NAME \
--database-version=MYSQL_8_0 \
--cpu=2 \
--memory=7680MB \
--region=$REGION

HOST=$PROJECT_ID:$REGION:$INSTANCE_NAME
USER_NAME=blogdbuser
PASSWORD=superpwd

gcloud sql users create $USER_NAME \
--host=$HOST \
--instance=$INSTANCE_NAME \
--password=$PASSWORD

# add network in Cloud SQL instance
# click Add network button
# name: web front end
# network: 34.71.16.80/32
```
### 4. Configure an application in a Compute Engine instance to use Cloud SQL
```bash
# connect ssh
gcloud compute ssh --project=$PROJECT_ID --zone=$ZONE $VM_NAME

cd /var/www/html
sudo nano index.php (copy paste index.php)
# restart 
sudo service apache2 restart

# verify (you will see Database connection failed: ...)
EXTERNAL_IP=34.71.16.80
curl http://$EXTERNAL_IP/index.php

# adjust the CLOUDSQLIP (ex. 34.71.203.183) and DBPASSWORD ()
sudo nano index.php
sudo service apache2 restart

# verify (you will see Database connection succeeded.)
curl http://35.192.208.2/index.php
```

# 5. Configure an application in a Compute Engine instance to use a Cloud Storage object
```bash
# connect ssh
gcloud compute ssh --project=$PROJECT_ID --zone=$ZONE $VM_NAME
cd /var/www/html
sudo nano index.php
# add img of the image file from the GCS bucket 
(ex.) <img src='https://storage.googleapis.com/PROJECT_ID/my-excellent-blog.png'>
sudo service apache2 restart
```


