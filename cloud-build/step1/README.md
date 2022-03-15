# setup

```bash
# set environment variables
export REPO_NAME="quickstart-docker-repo"
export REGION="europe-west1"
export PROJECT_ID=$(gcloud config get-value project)
export IMAGE_NAME="quickstart-image:tag1"

# create Dockerfile
mkdir getting-started
cd getting-started

vi helloworld.sh
chmod +x helloworld.sh
vi Dockerfile

# create repo
gcloud artifacts repositories create $REPO_NAME --repository-format=docker \
    --location=$REGION --description="Docker repository"

# verify
gcloud artifacts repositories list

# option 1 build
gcloud builds submit --tag $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME

# option 2 build with cloudbuild.yaml
gcloud builds submit --config cloudbuild.yaml


# clean up
gcloud artifacts repositories delete $REPO_NAME
```

