# Cloud Run + FastAPI

## Info
- FastAPI: https://fastapi.tiangolo.com/deployment/docker/
- PORT Setup: https://cloud.google.com/run/docs/reference/container-contract#port
- Cloud Submit as alternative: https://blog.somideolaoye.com/fastapi-deploy-containerized-apps-on-google-cloud-run
## Enable Docker

## Setup the Python Environment
```bash
cd cloud-run/fastapi
python3 -m venv venv
source venv/bin/activate
pip install fastapi[all]
pip install uvicorn[standard]
```

## Create an App
```bash
mkdir app && cd app
vi main.py
```

## Run the App locally
```bash
# run the live server
uvicorn app.main:app --reload

# Json Response API UI
http://127.0.0.1:8000

# swagger UI
http://127.0.0.1:8000/docs

# alternative API docs UI
http://127.0.0.1:8000/redoc
```
## Create a Dockerfile
```bash
FROM python:3.7-slim
WORKDIR /code
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./app /code/app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```

## Create a requirements.txt
```bash
pip freeze > requirements.txt
```
## Deploy local
```bash
# test run
docker build -t myimage .
docker run -d --name mycontainer -p 8080:8080 myimage
docker ps
# check 
http://127.0.0.1:8080/docs
```
## Deploy to Cloud Run in Cloud Code 
- service name: fastapi-service
- region: europe-west1
- url: gcr.io/yt-demo-dev/fastapi

or

## (ALTERNATIVE) Deploy via Cloud Build
```bash
# retrieve project-id of active project
gcloud config get-value project

# build docker/container image
gcloud builds submit --tag gcr.io/{MY-PROJECT-ID}/mygeocoder

# cloud run deploy
gcloud run deploy --image {MY-CONTAINER-URL} --platform managed
```

## Clean up
```bash
gcloud run services delete fastapi-service --region=europe-west1
deactivate
rm -rf venv
docker stop mycontainer
docker system prune -a
```
