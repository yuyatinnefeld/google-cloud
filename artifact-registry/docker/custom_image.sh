PROJECT_ID="yt-demo-dev"
REGION="europe-west1"
REPO_NAME="yt-docker-repo"

# create a repo
gcloud artifacts repositories create ${REPO_NAME} \
    --repository-format=docker \
    --location=${REGION} \
    --description="Docker repository"

gcloud artifacts repositories list

# docker pull
DOCKER_IMAGE="alpine:latest"
MY_CUSTOM_IMAGE="yt-alpine-image"
docker pull ${DOCKER_IMAGE}
docker images

# tag the image
docker tag  ${DOCKER_IMAGE} \
    ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${MY_CUSTOM_IMAGE}:tag1

docker images

# docker push
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${MY_CUSTOM_IMAGE}:tag1

# pull the image
docker pull ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${MY_CUSTOM_IMAGE}:tag1

# check
docker images
```

## clean Up
```bash
gcloud artifacts repositories delete ${REPO_NAME} --location=${REGION}
docker system prune -a
```
