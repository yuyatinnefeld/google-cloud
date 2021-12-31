# Lab 1 - Send Logs

## Setup the Environment
```bash
# create python env
python3 -m venv venv
source venv/bin/activate
pip install google-cloud-logging

# create a demo script
mkdir -p lab1/src
vi lab1/src/example_1.py

# connect to the project
PROJECT_ID="yt-demo-dev"
gcloud config set project ${PROJECT_ID}
```

## Test Run
```bash
#create 10 logs
python lab1/src/example_1.py 

# create 10 logs with the batch process
python lab1/src/example_2.py

# create error logs with the JSON-serializable dictionary
python lab1/src/example_3.py

```

## Check Logs Explorer
filter with the custom logger name
e.g. my_custom_logger1, my_custom_logger2, my_custom_logger3
