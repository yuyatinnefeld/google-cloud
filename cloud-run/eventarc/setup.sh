# source: https://codelabs.developers.google.com/codelabs/cloud-run-events#0

# about
# Eventarc makes it easy to connect Cloud Run services with events from a variety of sources. 
# It allows you to build event-driven architectures in which microservices are loosely coupled and distributed

# topic
# recive events from Cloud Pub/Sub and Cloud Audit Logs with Eventarc 
# and pass them to Cloud Run (fully managed).


############# setup environment (cloud shell) #############

PROJECT_ID=$(gcloud config get-value project)
REGION="europe-west1"

# activate apis
gcloud services enable run.googleapis.com
gcloud services enable eventarc.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable cloudbuild.googleapis.com


# set default region
gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

# configure compute engine service account
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role roles/eventarc.eventReceiver

# configure cloud storage service accoutn
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_NUMBER \
    --member serviceAccount:$SERVICE_ACCOUNT \
    --role roles/pubsub.publisher


############# event discovery #############

# list of event tpyes
gcloud beta eventarc attributes types list

# describe event info
EVENT_NAME="google.cloud.audit.log.v1.written"
gcloud beta eventarc attributes types describe $EVENT_NAME

# list of service with the event
gcloud beta eventarc attributes service-names list --type=$EVENT_NAME

# list of method names
gcloud beta eventarc attributes method-names list --type=$EVENT_NAME --service-name=workflows.googleapis.com


############# setup cloud run #############

# create cloud run sink

SERVICE_NAME=hello
gcloud run deploy $SERVICE_NAME \
  --image=gcr.io/cloudrun/hello \
  --allow-unauthenticated

