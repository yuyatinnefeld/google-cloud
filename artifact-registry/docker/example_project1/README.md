# Artifact Registry Example Project (FastAPI Image )
## Create a Demo FastAPI App

```bash
.
├── app
│   ├── __init__.py
│   └── main.py
├── Dockerfile
└── requirements.txt
```

## Test Run

```bash
DOCKER_IMAGE="my-fastapi-image"
docker build -t ${DOCKER_IMAGE} .
docker run -d --name fastapi -p 8080:8080 ${DOCKER_IMAGE}
curl -i http://127.0.0.1:8080/docs
curl -i http://127.0.0.1:8080/items/5?q=somequery
```

## Setup the Private Repo
```bash
# set env variables
PROJECT_ID="yt-demo-dev"
REGION="europe-west1"
REPO_NAME="my-docker-repo"
GCP_SERVICE_ACCOUNT_KEY_DEV="/..path-to-gcp-json-key/service-account.json"

# use a service account
gcloud auth activate-service-account --key-file ${GCP_SERVICE_ACCOUNT_KEY_DEV}
gcloud config set project ${PROJECT_ID}
gcloud config list

# create a docker repo
gcloud artifacts repositories create ${REPO_NAME} \
    --repository-format=docker \
    --location=${REGION} \
    --description="Docker repository"

gcloud artifacts repositories list

# configuration
gcloud config set artifacts/repository ${REPO_NAME}
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet
```

## Upload the image into Private Repo
```bash
# tag the image
TAG="0.1"
GAR_DOCKER_IMAGE=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${DOCKER_IMAGE}:${TAG}

docker tag  ${DOCKER_IMAGE} ${GAR_DOCKER_IMAGE}

# confirm the new repositroy:tag image
docker images

# push the image
docker push ${GAR_DOCKER_IMAGE}

# confirm the image on the artifact registry
gcloud artifacts docker images list
```

## Use the image from the Private Repo
```bash
# remove all local images
docker image prune -a

# pull the image
docker pull ${GAR_DOCKER_IMAGE}

# create a container 
docker images
docker run -d --name fastapi -p 8080:8080 ${GAR_DOCKER_IMAGE}

# confirm the fastapi
curl -i http://127.0.0.1:8080/docs
```


## Deploy Cloud Run with the image
```bash
SERVICE_NAME="my-simple-fastapi-service"
gcloud run deploy ${SERVICE_NAME} \
    --image=${GAR_DOCKER_IMAGE} \
    --region=${REGION} \
    --allow-unauthenticated

curl -i https://my-simple-fastapi-service-su5bcdndka-ew.a.run.app/docs
```

## Clean Up
```bash
gcloud artifacts repositories delete ${REPO_NAME} --location=${REGION}
gcloud run services delete ${SERVICE_NAME} --region=${REGION} 
docker system prune -a
```

## CI/CD Pipeline

- Info: https://ludusrusso.space/blog/2020/09/gitlab-ci-gcr

### Cloud Container Registry

### Cloud Artifact Registr
