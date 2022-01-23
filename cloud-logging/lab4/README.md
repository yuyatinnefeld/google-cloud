# Python Custom Logger

## Setup
```bash
# install package
pip install google-cloud-logging

# run main.py
python main.py

# open GCP Logs Explorer and define run query
resource.labels.job_id="abc-job-id"
labels.cluster =~ "^.*processing-cluster.*$"
```