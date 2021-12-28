# set environment vars

export PROJECT_ID=yt-demo-dev
export DATAPROC_STAGING_BUCKET=yt-demo-dev-dataproc-staging
export DATAPROC_TEMP_BUCKET=yt-demo-dev-dataproc-temp
export REGION=europe-west1
export CLUSTER_NAME=iam-cluster-abc
export GOOGLE_APPLICATION_CREDENTIALS=/.../service_account.json     # Linux/Mac


# create a dataproc service
cd python-docs-samples/appengine/standard/flask
mkdir dataproc && cd dataproc
python3 -m venv env
source env/bin/activate
pip install flask pytest
vi main.py 
vi app.yaml
export FLASK_APP=main.py

# check the result
flask run

# deploy the app engine service
gcloud app deploy --bucket=gs://yt-demo-dev-dataproc-app --version=1 #if not working try again
gcloud app browse -s dataproc-service

# update the service (--quite == auto-approve)
gcloud app deploy --quiet
