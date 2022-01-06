# Example Project - Upload and Install Python Packages

In this project you can learn the following topics:

- How to create a Python package (Wheel)
- How to use the package in other project
- How to create a Python private repository by GCP
- How to upload the package on the private repo by GCP
- How to install the package from the private repo

## About the Python Package
This is a example package "der-die-das" can answer the article DER, DIE or DAS of German nouns. 

### Example:
```bash
python
>>> from der_die_das import check
>>> check("Burger")
searched : Burger
answer: DER Burger

>>> check("Kerzenleuchter")
searched : Kerzenleuchter
answer: DER Kerzenleuchter
```

## How to create a Python package (Wheel)
```bash
# create these setup files
vi pyproject.toml
vi setup.py
vi setup.cnf
vi LICENSE
vi requirements.txt

# create a package path
mkdir der_die_das 

# create a python module
vi der_die_das/__init__.py

# create a wheel package
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel
python setup.py bdist_wheel --universal

# build, dist dirs are created in the current project
ls build
ls dist
```

## How to use the package in other project
```bash
# set env variables
current_repo="der-die-das"
target_repo="another-project"
package="der_die_das-0.0.1-py2.py3-none-any.whl"
package_dir="der_die_das"

# create a new project
cd ..
mkdir ${target_repo}

# copy the wheel package in the new project
cp -R ${current_repo}/dist ${target_repo}/dist
cd ${target_repo}
python -m venv venv
source ./venv/bin/activate

# install the wheel package
pip install dist/${package}

# test the package in the Python Console
python
>>> from der_die_das import check
>>> check("Burger")
searched : Burger
answer: DER Burger

>>> check("Kerzenleuchter")
searched : Kerzenleuchter
answer: DER Kerzenleuchter
```
## How to create a Python private repository by GCP
```bash
# set gcp env varialbes
REGION="europe-west1"
PROJECT_ID="yt-demo-dev"
REPO_NAME="der-die-das-repo"
PACKAGE_NAME="der-die-das"

# create a private repo (artifact registry)
gcloud artifacts repositories create ${REPO_NAME} \
    --repository-format=python \
    --location=${REGION} \
    --description="DER DIE DAS package repository"

# check the repo
gcloud artifacts repositories list
gcloud artifacts print-settings python
```


## How to upload the package on the private repo by GCP

```bash
# setup python upload env
python -m pip install -U pip
pip install twine keyrings.google-artifactregistry-auth
keyring --list-backends
gcloud config set artifacts/repository ${REPO_NAME}
gcloud config set artifacts/location ${REGION}

# upload the package into the private reop
twine upload --repository-url https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPO_NAME}/ dist/*

# checkt the uploaded package
gcloud artifacts packages list --repository=${REPO_NAME}
gcloud artifacts versions list --package=${PACKAGE_NAME}
```
## How to install the package from the private repo
```bash
# open a new terminal and set the env variables
REGION="europe-west1"
PROJECT_ID="yt-demo-dev"
REPO_NAME="der-die-das-repo"
PACKAGE_NAME="der-die-das"

# create a python venv
mkdir some-test-dir && cd some-test-dir
python -m venv venv
source ./venv/bin/activate

# setup the gcp & python install env
gcloud auth login
gcloud config set project ${PROJECT_ID}
pip install twine keyrings.google-artifactregistry-auth

# list all packages
gcloud artifacts packages list --repository=${REPO_NAME}

# install the package "der-die-das"
pip install --extra-index-url https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPO_NAME}/simple/ ${PACKAGE_NAME}

# test the package
python -m der_die_das.__init__ Burger

# test in the python console
>>> from der_die_das import check
>>> check("Burger")
searched : Burger
answer: DER Burger
```

## CI/CD Pipeline

Service Account needs the following roles:
- IAP-secured Web App User
- Artifact Registry Administrator
- Artifact Registry Repository Administrator


API [cloudresourcemanager.googleapis.com] has to be enabled on the project 