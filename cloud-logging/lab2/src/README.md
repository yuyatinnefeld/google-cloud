# Lab 2 - Read Logs and Delete Logs

## Setup the Environment
```bash
# create python env
python3 -m venv venv
source venv/bin/activate
pip install google-cloud-logging

# create a demo script
mkdir -p lab2/src
vi src/entries.py

# connect to the project
PROJECT_ID="yt-demo-dev"
gcloud config set project ${PROJECT_ID}
```

## Test Run
```bash
python lab2/src/entries.py
python lab2/src/delete.py

```