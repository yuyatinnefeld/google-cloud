# External Load Balancer

## Info
https://cloud.google.com/iap/docs/load-balancer-howto#gcloud_5

## Resources
- 1 x LB
- 2 x FW (HTTP, health check)
- 2 x GCE instance template (us-east1, europe-west1)
- 2 x instance groups for scaling
- 2 x Default Subnets (us-east1, europe-west1)
- 1 x Default VPC

## Setup Network
./network.sh

## Setup GCE
./compute-engine.sh (Service Account Change)

## Testing for confirm the GCE backend access
```bash
./compute-engine2.sh

# connect ssh
EXTERNAL_IP_BACKEND=35.185.2.3
curl ${EXTERNAL_IP_BACKEND}
```

## Create an External Load Balancer
./load-balancer.sh

## Testing the Load Balancer Access
```bash
LB_IP=34.111.247.23:80
curl ${LB_IP}
```
