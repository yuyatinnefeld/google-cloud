# Lab 3 - Create, List, Delete Sink
Log Sinks: control how Cloud Logging routes logs. Using sinks, you can route some or all of your logs to supported destinations. Some of the reasons that you might want to control how your logs are routed include the following:

- To store logs that are unlikely to be read but that must be retained for compliance purposes.
- To organize your logs in buckets in a format that is useful to you.
- To use big-data analysis tools on your logs.
- To stream your logs to other applications, other repositories, or third parties.

## Setup the Environment
```bash
# create python env
python3 -m venv venv
source venv/bin/activate
pip install google-cloud-logging

# create a demo script
mkdir src
vi lab3/src/create_sinks.py

# connect to the project
PROJECT_ID="yt-demo-dev"
gcloud config set project ${PROJECT_ID}

# create a cloud storage bucket
gsutil mb -c standard -l europe-west1 gs://oraora-loglog-bucket
```

## Test Run
```bash
# create a sink
python lab3/src/create_sink.py

# create a logs
python lab1/src/example_1.py
python lab1/src/example_2.py

# list the sink
python lab3/src/delete.py

# delete the sink
python lab3/src/delete.py
```

## Clean Up
```bash
gsutil rm -r gs://oraora-loglog-bucket
```