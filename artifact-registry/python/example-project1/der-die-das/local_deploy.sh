# set env variables
current_repo="der-die-das"
target_repo="another-project"
package_dir="der_die_das"

# create a der_die_das wheel package
rm -rf dist/*
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel
python setup.py bdist_wheel


# install the wheel package in an another project
cd ..
mkdir ${target_repo}
cp -R ${current_repo}/dist ${target_repo}/dist
cd ${target_repo}
python -m venv venv
source ./venv/bin/activate
pip install dist/*.whl

# test the package in the Python Console
python
>>> from der_die_das import check
>>> check("Burger")
searched : Burger
answer: DER Burger

>>> check("Kerzenleuchter")
searched : Kerzenleuchter
answer: DER Kerzenleuchter

# create a GCP private repo (artifact registry)
REGION="europe-west1"
PROJECT_ID="yt-demo-dev"
REPO_NAME="der-die-das-repo"
PACKAGE_NAME="der-die-das"

gcloud artifacts repositories create ${REPO_NAME} \
    --repository-format=python \
    --location=${REGION} \
    --description="DER DIE DAS package repository"

gcloud artifacts repositories list

# upload the package into the artifact registry
python -m pip install -U pip
pip install twine keyrings.google-artifactregistry-auth
gcloud config set artifacts/repository ${REPO_NAME}
gcloud config set artifacts/location ${REGION}
gcloud artifacts print-settings python
keyring --list-backends

twine upload --repository-url https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPO_NAME}/ dist/*
gcloud artifacts packages list --repository=${REPO_NAME}
gcloud artifacts versions list --package=${PACKAGE_NAME}


# donwload the package and use this
cd ..
mkdir some-test-dir && cd some-test-dir
python -m venv venv
source ./venv/bin/activate
REGION="europe-west1"
PROJECT_ID="yt-demo-dev"
REPO_NAME="der-die-das-repo"
PACKAGE_NAME="der-die-das"

gcloud auth login
gcloud config set project ${PROJECT_ID}
pip install twine keyrings.google-artifactregistry-auth
gcloud artifacts packages list --repository=${REPO_NAME}
pip install --extra-index-url https://${REGION}-python.pkg.dev/${PROJECT_ID}/${REPO_NAME}/simple/ ${PACKAGE_NAME}

python
>>> from der_die_das import check
>>> check("Burger")
searched : Burger
answer: DER Burger

# or
python -m der_die_das.__init__ Burger