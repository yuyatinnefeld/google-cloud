# Internal Loal Balancer for TCP/UDP-based traffic

## Info 
https://cloud.google.com/load-balancing/docs/internal/setting-up-internal#gcloud

## Resources
- 1 x LB
- 2 x FW (HTTP, health check)
- 2 x GCE instance template (instance-group-1, instance-group-2)
- 2 x instance groups for scaling
- 1 x Network (my-internal-app)
- 2 x Subnets (subnet-a, subnet-b)

## Setup Network
./network.sh

## Setup GCE
./compute-engine.sh

## Testing
./compute-engine2.sh
```bash
# connect utility-vm ssh
gcloud compute ssh utility-vm --zone=us-central-f
INTERNAL_IP_1=10.10.20.2
INTERNAL_IP_2=10.10.30.2

curl ${INTERNAL_IP_1}
curl ${INTERNAL_IP_2}
```

## Setup Load Balancer
./load-balancer.sh

## Testing
```bash
gcloud compute ssh utility-vm --zone=us-central-f
INTERNAL_LB_IP=10.10.22.2
crul http://${INTERNAL_LB_IP}
```
