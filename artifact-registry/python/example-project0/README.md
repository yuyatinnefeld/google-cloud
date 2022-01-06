# Artifact Registry

## Info

## Setup a Virtual environment
```bash
python3 -m venv venv
source venv/bin/activate
python --version
python -m pip install -U pip
pip install twine keyrings.google-artifactregistry-auth
keyring --list-backends
REGION="europe-west1"
PROJECT_ID="yt-demo-dev"
REPO_NAME="my-python-repo"
```
## Enable Artifact Registry API (Cloud Code)

## Create a repository (Terraform)
```bash
gcloud auth application-default login
gcloud artifacts repositories list
cd tf
terraform init
terraform plan
terraform apply --auto-approve
gcloud artifacts repositories list
cd ..
```

## Set my-python-repo as default repo
```bash
gcloud config set artifacts/repository ${REPO_NAME}
gcloud config set artifacts/location ${REGION}
```

## Print Repo Configuration Info
```bash
gcloud artifacts print-settings python
gcloud artifacts repositories describe ${REPO_NAME} --location=${REGION}
```

## Create a Simple Pacakge
```bash
mkdir python-yt-package
mkdir -p python-yt-pacakge/dist
cd python-yt-pacakge/dist
pip download sampleproject
# wheel files are created in the dist dir
```

## Upload the Package
```bash
cd ..
twine upload --repository-url https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPO_NAME}/ dist/*
```

## Check the Package
```bash
gcloud artifacts packages list --repository=${REPO_NAME}
gcloud artifacts versions list --package=peppercorn
gcloud artifacts versions list --package=sampleproject
```

## Use the Packages
```bash
# open an another dir in an another terminal
cd .. && mkdir use-repo && cd use-repo
python3 -m venv venv
source venv/bin/activate
REGION="europe-west1"
PROJECT_ID="yt-demo-dev"
REPO_NAME="my-python-repo"
gcloud auth login
gcloud config set project ${PROJECT_ID}
pip install twine keyrings.google-artifactregistry-auth
keyring --list-backends
pip install --index-url https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPO_NAME}/simple/ sampleproject
```

## Clean Up
```bash
gcloud artifacts repositories delete ${REPO_NAME}
gcloud config unset artifacts/repository
gcloud config unset artifacts/location
rm -rf python-yt-pacakge/dist
```