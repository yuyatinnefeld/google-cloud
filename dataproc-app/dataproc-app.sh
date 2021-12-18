# set environment vars
export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/conf/service_account.json

# check the result
export FLASK_APP=./rest_api/app.py
flask run

# deploy the app engine service
gcloud app deploy --bucket=gs://yt-demo-dev-dataproc-app --version=1 #if not working try again
gcloud app browse -s dataproc-service

# update the service (--quite == auto-approve)
gcloud app deploy --quiet
