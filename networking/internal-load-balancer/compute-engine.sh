PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
PROJECT_NUM="114877050363"
SERVICE_ACCOUNT="${PROJECT_NUM}-compute@developer.gserviceaccount.com"
NW_TAG="lb-backend"
ZONE_1="us-central1-a"
ZONE_2="us-central1-b"

# create GCE instance template 1
TEMPLATE_NAME_1="instance-template-1"
SUBNET_2="subnet-a"
METADATA=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh,enable-oslogin=true

gcloud compute instance-templates create ${TEMPLATE_NAME_1} \
 --project=${PROJECT_ID} \
 --machine-type=n1-standard-1 \
 --network-interface=network-tier=PREMIUM,subnet=${SUBNET_1} \
 --metadata=${METADATA} \
 --maintenance-policy=MIGRATE \
 --service-account=${SERVICE_ACCOUNT} \
 --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
 --tags=${NW_TAG} \
 --region=${REGION} \
 --create-disk=auto-delete=yes,boot=yes,device-name=${TEMPLATE_NAME_1},image=projects/debian-cloud/global/images/debian-10-buster-v20220118,mode=rw,size=10,type=pd-balanced \
 --no-shielded-secure-boot \
 --shielded-vtpm \
 --shielded-integrity-monitoring \
 --reservation-affinity=any

# create GCE instance template 2
TEMPLATE_NAME_2="instance-template-2"
SUBNET_2="subnet-b"
METADATA=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh,enable-oslogin=true

gcloud compute instance-templates create ${TEMPLATE_NAME_2} \
 --project=${PROJECT_ID} \
 --machine-type=n1-standard-1 \
 --network-interface=network-tier=PREMIUM,subnet=${SUBNET_2} \
 --metadata=${METADATA} \
 --maintenance-policy=MIGRATE \
 --service-account=${SERVICE_ACCOUNT} \
 --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
 --region=${REGION} \
 --tags=${NW_TAG} \
 --create-disk=auto-delete=yes,boot=yes,device-name=${TEMPLATE_NAME_2},image=projects/debian-cloud/global/images/debian-10-buster-v20220118,mode=rw,size=10,type=pd-balanced \
 --no-shielded-secure-boot \
 --shielded-vtpm \
 --shielded-integrity-monitoring \
 --reservation-affinity=any

# create instance group 1
GROUP_1="instance-group-1"
gcloud beta compute instance-groups managed create ${GROUP_1} \
    --project=${PROJECT_ID} \
    --base-instance-name=${GROUP_1} \
    --size=1 \
    --template=${TEMPLATE_NAME_1} \
    --zone=${ZONE_1}
    
gcloud beta compute instance-groups managed set-autoscaling ${GROUP_1} \
    --project=${PROJECT_ID} \
    --zone=${ZONE_1}
    --cool-down-period=45 \
    --max-num-replicas=5 --min-num-replicas=1 \
    --mode=on \
    --target-cpu-utilization=0.8

# create instance group 2
GROUP_2="instance-group-2"
gcloud beta compute instance-groups managed create ${GROUP_2} \
    --project=${PROJECT_ID} \
    --base-instance-name=${GROUP_2} \ 
    --size=1 \ 
    --template=${TEMPLATE_NAME_2} \
    --zone=${ZONE_2}

gcloud beta compute instance-groups managed set-autoscaling ${GROUP_2} \
    --project=${PROJECT_ID} \
    --zone=${ZONE_2}
    --cool-down-period=45 \
    --max-num-replicas=5 --min-num-replicas=1 \
    --mode=on \
    --target-cpu-utilization=0.8