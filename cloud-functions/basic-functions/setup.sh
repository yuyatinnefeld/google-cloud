############ setup environment ############ 

PROJECT_ID=$(gcloud config get-value project)
REGION=europe-west1
FUNCTION_NAME="nodejs-http-function"
# enable apis
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

# create repo
mkdir functions-repo && cd $_
mkdir hello-http && cd $_
vi index.js
vi package.json

# deploy
gcloud beta functions $FUNCTION_NAME deploy  \
  --gen2 \
  --runtime nodejs16 \
  --entry-point helloWorld \
  --source . \
  --region $REGION \
  --trigger-http \
  --timeout 600s

# test
gcloud beta functions call $FUNCTION_NAME --gen2 --region $REGION


############ pub/sub function ############ 

# service account setup
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member  serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
  --role roles/iam.serviceAccountTokenCreator

# create topic
TOPIC="cloud-functions-gen2-topic"
gcloud pubsub topics create $TOPIC

# create 
cd ~/functions-repo
mkdir ~/hello-pubsub && cd $_
vi requreiments.txt

# deploy
FUNCTION_NAME2="python-pubsub-function"

gcloud beta functions deploy $FUNCTION_NAME2 \
  --gen2 \
  --runtime python39 \
  --entry-point hello_pubsub \
  --source . \
  --region $REGION \
  --trigger-topic $TOPIC

# test 
# topic send
gcloud pubsub topics publish $TOPIC --message="Hello World"

# recive the topic
gcloud beta functions logs read $FUNCTION_NAME2 \
  --region $REGION --gen2 --format "value(log)"

############ storage function ############ 

FUNCTION_NAME3="nodejs-storage-function"
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher


cd ~/function-repo
mkdir hello-storage && cd $_
vi index.js
vi package.json

# create sample bucket
BUCKET="gs://gcf-gen2-storage-$PROJECT_ID"
gsutil mb -l $REGION $BUCKET

# deploy functions
gcloud beta functions deploy $FUNCTION_NAME3 \
  --gen2 \
  --runtime nodejs16 \
  --entry-point helloStorage \
  --source . \
  --region $REGION \
  --trigger-bucket $BUCKET \
  --trigger-location $REGION

# test
echo "Hello World" > random.txt
gsutil cp random.txt $BUCKET/random.txt

gcloud beta functions logs read $FUNCTION_NAME3 \
  --region $REGION --gen2 --limit=100 --format "value(log)"


############ traffic splitting function ############ 

cd ~/functions-repo
mkdir traffic-splitting && cd $_
vi main.py

# deploy type1
COLOR=orange
gcloud beta functions deploy hello-world-colored \
  --gen2 \
  --runtime python39 \
  --entry-point hello_world \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --update-env-vars COLOR=$COLOR


# deploy type2
COLOR=yellow
gcloud beta functions deploy hello-world-colored \
  --gen2 \
  --runtime python39 \
  --entry-point hello_world \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --update-env-vars COLOR=$COLOR

# split the traffic 50-50

# check revision id of cloud run
gcloud run revisions list --service hello-world-colored \
  --region $REGION --format 'value(REVISION)'

REVISION_ID1="hello-world-colored-00001-hot"
REVISION_ID2="hello-world-colored-00002-mow"

# split the traffic
gcloud run services update-traffic hello-world-colored \
  --region $REGION \
  --to-revisions $REVISION_ID1=50,$REVISION_ID2=50