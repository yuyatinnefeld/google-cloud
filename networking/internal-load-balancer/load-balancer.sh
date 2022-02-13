PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
BACKEND_SERVICE="backend-ilb"

# create health check
gcloud compute health-checks create http hc-http-80 \
    --region=${REGION} \
    --port=80

# create backend service
gcloud compute backend-services create ${BACKEND_SERVICE} \
    --load-balancing-scheme=internal \
    --protocol=tcp \
    --region=${REGION} \
    --health-checks=hc-http-80 \
    --health-checks-region=${REGION}

gcloud compute backend-services add-backend ${BACKEND_SERVICE} \
    --region=${REGION} \
    --instance-group=ig-a \
    --instance-group-zone=${REGION}-a

gcloud compute backend-services add-backend ${BACKEND_SERVICE} \
    --region=${REGION} \
    --instance-group=ig-b \
    --instance-group-zone=${REGION}-b

# create mapping
FORWARDING="fr-ilb"
INTERNAL_IP=10.10.22.2

gcloud compute forwarding-rules create ${FORWARDING} \
    --region=${REGION} \
    --load-balancing-scheme=internal \
    --network=${NETWORK} \
    --subnet=${SUBNET} \
    --address=${INTERNAL_IP} \
    --ip-protocol=TCP \
    --ports=80,8008,8080,8088 \
    --backend-service=${BACKEND_SERVICE} \
    --backend-service-region=${REGION}