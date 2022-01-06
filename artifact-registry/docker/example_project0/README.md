# Artifact Registry Example Project (Google Sample Image )

## Activate Docker with the busy busybox image
```bash
docker run --rm busybox date
```

## Create a Docker repo
```bash
PROJECT_ID="yt-demo-dev"
REGION="europe-west1"
REPO_NAME="yt-docker-repo"

gcloud artifacts repositories create ${REPO_NAME} \
    --repository-format=docker \
    --location=${REGION} \
    --description="Docker repository"

gcloud artifacts repositories list
```

## Configure authentication
Before you can push or pull images, configure Docker to use the gcloud command-line tool to authenticate requests to Artifact Registry.

```bash
gcloud auth configure-docker ${REGION}-docker.pkg.dev

Adding credentials for: europe-west1-docker.pkg.dev
After update, the following will be written to your Docker config file located at [/Users/yuyatinnefeld/.docker/config.json]:
 {
  "credHelpers": {
    "europe-west1-docker.pkg.dev": "gcloud"
  }
}

Do you want to continue (Y/n)?  y

Docker configuration file updated.
```

## Pull an image
```bash
# pull a google example docker image
DOCKER_IMAGE="us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0"
docker pull ${DOCKER_IMAGE}
docker images
```

## Tag and Push the image
```bash
# check the images
docker images

# tag the image
docker tag  ${DOCKER_IMAGE} \
    ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/quickstart-image:tag1

# confirm the new image
docker images

docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/quickstart-image:tag1

```

## Pull the pushed image
```bash
#clean up
docker system prune -a
# pull the image
docker pull ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/quickstart-image:tag1
# check
docker images
```

## Clean Up
```bash
gcloud artifacts repositories delete ${REPO_NAME} --location=${REGION}
docker system prune -a
```