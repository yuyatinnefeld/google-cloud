#global env variables
PROJECT_ID=$(gcloud config get-value project)
REGION=europe-west1

# create 3 buckets
gsutil mb -l europe-west1 gs://${PROJECT_ID}-dataproc-staging
gsutil mb -l europe-west1 gs://${PROJECT_ID}-dataproc-temp
gsutil mb -l europe-west1 gs://${PROJECT_ID}-dataproc-app

# upload the spark src and sample data
gsutil cp -r spark/ gs://${PROJECT_ID}-dataproc-app/
gsutil cp -r sample_data/ gs://${PROJECT_ID}-dataproc-app/

# upload initialization_actions bash file for dataproc python environment setup
gsutil cp gs://goog-dataproc-initialization-actions-${REGION}/python/pip-install.sh gs://${PROJECT_ID}-dataproc-app/config/pip-install.sh
