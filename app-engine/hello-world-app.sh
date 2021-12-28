### GCP CLOUD SHELL

PROJECT_ID="yt-demo-dev"

# create an app engine application
gcloud app create --region=europe-west --project=${PROJECT_ID}
gcloud app describe

# create a hello world service
git clone https://github.com/GoogleCloudPlatform/python-docs-samples
cd python-docs-samples/appengine/standard/flask/hello_world
python3 -m venv env
source env/bin/activate
pip install flask pytest
export FLASK_APP=main.py

# check the result
flask run

# deploy the app engine service
gcloud app deploy --bucket=gs://yt-demo-dev-helloworld-app --version=1 #if not working try again
gcloud app browse #https://yt-demo-dev.ey.r.appspot.com


if gsutil du -s gs://yt-demo-dev-helloworld-app
then
  echo "the bucket exists"
else
  gsutil mb -l europe-west1 -c STANDARD gs://${GCP_APP_BUCKET} 
fi
