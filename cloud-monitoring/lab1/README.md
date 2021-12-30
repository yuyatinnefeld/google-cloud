# Lab1 - Use Cloud Monitoring

## Create GCE instance via Terraform
```bash
cd lab1/tf
gcloud auth application-default login
terraform init
terraform plan
terraform apply
cd ..
```

## SSH connect (Cloud Shell > VS Code)
```bash
gcloud config set project yt-demo-test
gcloud beta compute ssh --zone "europe-west1-b" "lamp-1-vm"  --project "yt-demo-test"

# open VS Code Remote SSH and add the SSH config

Host GCE
  HostName 35.195.152.114 # VMs external IP
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/google_compute_engine
  User yuyatinnefeld

```

## Add Apache2 HTTP Server
```bash
sudo apt-get update
sudo apt-get install apache2 php7.0
sudo service apache2 restart

# click External IP in VM Instance GUI and check the Apache Server
```

## Create Monitoring Metrics Scope

Install agents on the VM
```bash
# monitoring-agent
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
sudo apt-get update
sudo apt-get install stackdriver-agent

# logging-agent
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh
sudo apt-get update
sudo apt-get install google-fluentd
```

## Create an uptime check
1. Open uptime check GUI
- Title: Lamp Uptime Check, then click Next.
- Protocol: HTTP
- Resource Type: Instance
- Applies to: Single, lamp-1-vm
- Path: leave at default
- Check Frequency: 1 min

2. Click TEST to check the connection
3. Click CREATE

## Create an alerting policy

1. Click Create Policy
2. Click Add Condition
- Target: VM
- Resource Type: VM Instance
- Metric: Netowrk tfaffic (agent.googleapis.com/interface/traffic) NOT Other one!
3. Contidion
- Condition: is above
- Threshold: 500
- For: 1 minute
4. ADD > Next
5. Notification Channels > Manage Notification Channels
6. Email > ADD NEW
7. Define Email address + Display Name (Test Alert)
8. Go back to Notification Channel Setup and Add the Notification Channel (Test Alert) under "Who should be notified?"
9. Rename Alert Name to "Inbound Traffic Alert"

## Create a Dashboard

1. Open Create Dashboard
2. Click Create Dashboard
3. Select Line Chart
- Chart Title: CPU Load
- Resource Type: VM Instance
- Metric: CPU Usage
4. Select next Chart what you need for your business case


## Clean Up
```bash
# delete the GCE instance
terraform destroy

# delete alerting policy 
# delete alerting notification channel
# delete cloud monitoring dashboard




```