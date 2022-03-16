############# setup environment (cloud shell) #############

# setup env
PROJECT_ID=yuyatinnefeld-dev
ZONE=europe-west1-b

gcloud config set project $PROJECT_ID
echo $GOOGLE_CLOUD_PROJECT
gcloud config set compute/zone $ZONE

# clone source repo
git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd ~/monolith-to-microservices

# install nvm and react
./setup.sh

# start web server and check the website
cd monolith
npm start


############# build and deploy #############

# dockerize the app
cat Dockerfile
gcloud services enable cloudbuild.googleapis.com
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:1.0.0 .

# deploy container to cloud run
APP_NAME="monolith-app"
gcloud config set run/region europe-west1
gcloud run deploy $APP_NAME --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:1.0.0 --platform managed

Service name (monolith):  monolith-app
Allow unauthenticated invocations to [monolith-app] (y/N)?  y

# verify
gcloud run services list

# crate new revision with lower concurrency
gcloud run deploy $APP_NAME --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:1.0.0 --platform managed --concurrency 1


############# update the website #############

cd ~/monolith-to-microservices/react-app/src/pages/Home
mv index.js.new index.js
cat ~/monolith-to-microservices/react-app/src/pages/Home/index.js

# build react app to generate the static files
cd ~/monolith-to-microservices/react-app
npm run build:monolith


# update image version
cd ~/monolith-to-microservices/monolith

# test local
npm start

# build and upload
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0 .

# deploy cloud run app
gcloud run deploy $APP_NAME --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0 --platform managed --region europe-west1
gcloud run services describe $APP_NAME --platform managed 

############# clean up #############

# container registry
gcloud container images delete gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:1.0.0 --quiet
gcloud container images delete gcr.io/${GOOGLE_CLOUD_PROJECT}/monolith:2.0.0 --quiet

# cloud build bucket
gsutil rm -r gs://yuyatinnefeld-dev_cloudbuild

# cloud run
gcloud run services delete monolith --platform $APP_NAME

# repo
rm -rf monolith-to-microservice