# Lab2 - Cloud Functions Logging & Monitoring

Info: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function

## Create Cloud Function Instance via Terraform (Public Function)
```bash
cd lab2/tf
gcloud auth application-default login

# create a src zip file for cloud functions
cd src
zip archive.zip main.py
terraform init
terraform plan
terraform apply
cd ..
```

## Confirm Cloud Functions
1. Open Cloud Functions Instance (hello_world)

2. Click Trigger

3. Open the Trigger URL (DON'T CLOSE THE URL)
e.g. https://europe-west1-yt-demo-test.cloudfunctions.net/hello_world


## Install vegeta tool and Send Test Traffic to Cloud Function with this
```bash
CLOUD_FUNCTION_URL="https://europe-west1-yt-demo-test.cloudfunctions.net/hello_world"

# open cloud shell
mkdir vegeta-room && cd vegeta-room

# install vegeta pacakge
wget 'https://github.com/tsenart/vegeta/releases/download/v6.3.0/vegeta-v6.3.0-linux-386.tar.gz'

# unpack the vegeta
tar xvzf vegeta-v6.3.0-linux-386.tar.gz

# send the traffic with the vegeta attact
echo "GET ${CLOUD_FUNCTION_URL}" | ./vegeta attack -duration=300s > results.bin

# clean up in cloud shell
cd ..
rm -rf vegeta-room

```
## Create logs-based metric (Logs Explorer)
1. select reource type: cloud functions 
2. service name: hello_world
3. click metric type
- metric type: Distribution
- name: CloudFunctionLatency-Logs
- field name: textPayload
- regex field: execution took (\d+)
4. create metric

## Metrics Explorer (Metrics Explorer)
1. Open Metrics Explorer
2. Configuration
3. Metric > Only show active > filter with "executions"
4. change the graph type with stacked bar chart

## Clean Up

```bash
# cloud functions & gcs
terraform destroy

# logs-based metric
manual delete

```