# Dataproc Flask REST API Template

## GCP Setup
download the service account credentials key (json) into the conf directory of your project
```bash
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/conf/service_account.json
```

### GCP Environment Setup
```bash
gcp-iac.sh
```
### Dataproc Workflow Temp and Autoscaling Policy Setup & Test run
```bash
wf_temps.sh
```

## Python Env Setup

```bash
# create python environment and install packages
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Flask App Run

setting up the ./resources/app_conf.yaml
```bash
project_id: <YOUR_PROJECT>
dataproc_staging_bucket: <STAGING_BUCKET>
dataproc_temp_bucket: <TEMP_BUCKET>
region: <REGION>

# check the result
export FLASK_APP=./rest_api/app.py
flask run
```

## Deploy App Engine Service

```bash
gcloud app deploy --bucket=gs://yt-demo-dev-dataproc-app --version=1 #if not working try again
gcloud app browse -s dataproc-service

# update the service (--quite == auto-approve)
gcloud app deploy --quiet
```