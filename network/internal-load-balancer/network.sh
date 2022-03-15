PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
NW_TAG="lb-backend"

# create network
NETWORK="my-internal-app"

gcloud compute networks create ${NETWORK} \
    --subnet-mode=custom \
    --bgp-routing-mode=regional \
    --mtu=1460

# creeate subnets
SUBNET_1="subnet-a"
RANGE_1="10.10.20.0/24"
SUBNET_2="subnet-b"
RANGE_2="10.10.30.0/24"

gcloud compute networks subnets create ${SUBNET_1} \
    --network=${NETWORK} \
    --range=${RANGE_1} \
    --region=${REGION}

gcloud compute networks subnets create ${SUBNET_2} \
    --network=${NETWORK} \
    --range=${RANGE_2} \
    --region=${REGION}


# create FW rules
FW_ICMP="app-allow-icmp"
FW_SSH_RDP="app-allow-ssh-rdp"
FW_HTTP="app-allow-http"
FW_HEALTH_CHECK="app-allow-health-check"

gcloud compute --project=${PROJECT_ID} firewall-rules create ${FW_ICMP} \
    --direction=INGRESS \
    --priority=1000 \
    --network=${NETWORK} \
    --action=ALLOW \ 
    --rules=icmp \ 
    --source-ranges=0.0.0.0/0

gcloud compute --project=${PROJECT_ID} firewall-rules create ${FW_SSH_RDP} \
    --direction=INGRESS \
    --priority=1000 \
    --network=${NETWORK} \
    --action=ALLOW \ 
    --rules=tcp:22, 80, 3389 \ 
    --source-ranges=0.0.0.0/0

gcloud compute --project=${PROJECT_ID} firewall-rules create ${FW_HTTP} \
    --direction=INGRESS \
    --priority=1000 \
    --network=${NETWORK} \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=${NW_TAG}

gcloud compute --project=${PROJECT_ID} firewall-rules create ${FW_HEALTH_CHECK} \
    --direction=INGRESS \
    --priority=1000 \
    --network=${NETWORK} \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=130.211.0.0/22,35.191.0.0/16 \
    --target-tags=${NW_TAG}

