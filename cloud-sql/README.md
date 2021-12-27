# Cloud SQL Connection (PostgreSQL DB)

## Methods
- gcloud
- ssh connection
- proxy
- python (e.g. Jupyter Notebook)


### create Cloud SQL & VPC Env
- Create 2 Instance (public-db-instance, private-db-instance)
- Create 2 DB (frontend-db for public-db-instance and private-db-instance)
- Create 2 dummy user (postgres for public-db-instance and private-db-instance)
- Create Network setup for private-db-instance 
    - VPC (main-net) + Subnet (subnet-0)
    - Firewalls (main-net-allow-ssh, main-net-allow-http, main-net-allow-https)
    - Private Service Connection (private-ip-address)

1. activate Cloud SQL Admin API in GCP
2. execute terraform
```bash
gcloud auth application-default login
cd terraform-setup
terraform init
terraform plan -out=tfplan
terraform apply tfplan -var="deletion_protection=false"
terraform-docs markdown . >README.md
```

### Option1: gcloud connection (Only External IP)

```bash
DB_INSTANCE=public-db-instance
gcloud sql connect ${DB_INSTANCE} --user=postgres --quiet
\c frontend-db 
```
Cloud Shell doesn't currently support connecting to a Cloud SQL instance that has only a private IP address. (https://cloud.google.com/sql/docs/postgres/configure-private-ip#configuring_an_instance_to_use_private_ip)


### Option2: ssh remote access (For Internal IP)

```bash
# use a terraform created internal network (e.g. main-net)
# use a terraform created subnet (e.g. subnet-0)
# use 3 terraform created firewall rules (e.g. main-net-allow-ssh, main-net-allow-http, main-net-allow-https)

PROJECT_ID="yt-demo-dev"
ZONE="europe-west1-b"
VM_NAME="postgres-conn-vm"
SERVICE_ACCOUNT="114877050363-compute@developer.gserviceaccount.com"
VM_IMAGE="ubuntu-1804-bionic-v20211206"
SUBNET_NAME="subnet-0"
CLOUD_SQL_INTERNAL_IP="10.197.0.3"
TAGS="ssh-allow,http-server,https-server"
SCOPE=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append

# create a GCE instance
gcloud compute instances create ${VM_NAME} \
 --project=${PROJECT_ID} \
 --zone=${ZONE} \
 --machine-type=e2-medium \
 --network-interface=network-tier=STANDARD,subnet=${SUBNET_NAME} \
 --service-account=${SERVICE_ACCOUNT} \
 --scopes=${SCOPE} \
 --maintenance-policy=MIGRATE \
 --tags=${TAGS} \
 --create-disk=auto-delete=yes,boot=yes,device-name=test-instance-to-connect-sql,image=projects/ubuntu-os-cloud/global/images/${VM_IMAGE},mode=rw,size=10,type=projects/${PROJECT_ID}/zones/${ZONE}/diskTypes/pd-balanced \
--no-shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any


# create ssh conn
gcloud compute ssh --zone ${ZONE} ${VM_NAME} --project ${PROJECT_ID}

# install postgres-client
sudo apt-get install
sudo apt-get update
sudo apt -y install postgresql-client

# create DB conn
psql "sslmode=disable dbname=postgres user=postgres hostaddr=${CLOUD_SQL_INTERNAL_IP}"

CREATE DATABASE frontend-test;
\l
\c frontend-db
\c frontend-test
CREATE TABLE demo-table (
    user_id BIGINT NOT NULL, 
    name TEXT NOT NULL
); 
```

### Option3: Proxy connection (Public IP)
Info: https://www.cloudskillsboost.google/focuses/1215?parent=catalog


```bash
# download the Cloud SQL Proxy (ubuntu terminal)
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy

# make the proxy executable
chmod +x cloud_sql_proxy

POSTGRES_CONN_NAME="yt-demo-dev:europe-west1:public-db-instance"
export POSTGRES_PASSWORD="postgres"

# install postgres clinet
apt install postgresql-client

# create proxy connection
./cloud_sql_proxy -instances=${POSTGRES_CONN_NAME}=tcp:3306

# open secound terminal (ubuntu terminal)
psql -h 127.0.0.1 -p 3306 -U postgres -d frontend-db 
# psql -h <hostname> -p <port> -U <username> -d <database name>

# list dbs
\l
```

### Option4: Python Script (Private IP)

1. create a Dataproc cluster which you can use Jupyter Notebook
- region = europe-west1
- enable component Gateway
- enable Jupyter Notebook in option components
- select primary network = main-net, subnet = subnet-0
- enable Internal IP only
- network tags = ssh-allow, http-server, https-server

2. open Jupyter notebook

```bash
# install client module
pip install psycopg2-binary

# adjust connection info in the script

# run connection script
python postgres_conn.py

```

## clean up the project
```bash
gcloud compute instances delete ${VM_NAME}

terraform destroy
```