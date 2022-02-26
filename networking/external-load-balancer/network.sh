# create 2 firewalls (HTTP, health check)
PROJECT_ID=$(gcloud config get-value project)
FW_NAME_1="default-allow-http"
FW_NAME_2="default-allow-health-check"
NW_TAG="http-server"

gcloud compute --project=${PROJECT_ID} firewall-rules create ${FW_NAME_1} \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=${NW_TAG}

gcloud compute --project=${PROJECT_ID} firewall-rules create ${FW_NAME_2} \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp \
    --source-ranges=130.211.0.0/22,35.191.0.0/16 \
    --target-tags=${NW_TAG}

