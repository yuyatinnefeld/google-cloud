# create 2 instance templates
TEMPLATE_NAME_1="us-east1-template"
METADATA="startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh,enable-oslogin=true"
REGION_1="us-east1"
REGION_2="europe-west1"
ZONE_1="us-east1-b"
ZONE_2="europe-west1-b"


gcloud compute instance-templates create ${TEMPLATE_NAME_1} \
    --project=${PROJECT_ID} \
    --machine-type=n1-standard-1 \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --metadata=${METADATA} \
    --maintenance-policy=MIGRATE \
    --service-account=809689202411-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append  \
    --region=${REGION_1} \
    --tags=${NW_TAG} \
    --create-disk=auto-delete=yes,boot=yes,device-name=${TEMPLATE_NAME_1},image=projects/debian-cloud/global/images/debian-10-buster-v20220118,mode=rw,size=10,type=pd-balanced  \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any

TEMPLATE_NAME_2="europe-west1-template"
METADATA="startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh,enable-oslogin=true"

gcloud compute instance-templates create ${TEMPLATE_NAME_2} \
    --project=${PROJECT_ID} \
    --machine-type=n1-standard-1 \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --metadata=${METADATA} \
    --maintenance-policy=MIGRATE \
    --service-account=809689202411-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append  \
    --region=${REGION_2} \
    --tags=${NW_TAG} \
    --create-disk=auto-delete=yes,boot=yes,device-name=${TEMPLATE_NAME_2},image=projects/debian-cloud/global/images/debian-10-buster-v20220118,mode=rw,size=10,type=pd-balanced  \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any

# create 2 instance groups

GROUP_1="us-east1-mig"
gcloud beta compute instance-groups managed create ${GROUP_1} \
    --project=${PROJECT_ID} \
    --base-instance-name=${GROUP_1} \ 
    --size=1 \ 
    --template=${TEMPLATE_NAME_1} \
    --zones=us-east1-b,us-east1-c,us-east1-d \ 
    --target-distribution-shape=EVEN

gcloud beta compute instance-groups managed set-autoscaling ${GROUP_1} \
    --project=${PROJECT_ID} \
    --region=${REGION_1} \
    --cool-down-period=45 \
    --max-num-replicas=5 \
    --min-num-replicas=1 \
    --mode=on \
    --target-cpu-utilization=0.8

GROUP_2="europe-west1-mig"
gcloud compute instance-groups managed create ${GROUP_2} \
    --project=${PROJECT_ID} \
    --base-instance-name=europe-west1-mig \
    --size=1 \
    --template=${TEMPLATE_NAME_2} \
    --zones=europe-west1-a,europe-west1-b \ 

gcloud beta compute instance-groups managed set-autoscaling ${GROUP_2} \
    --project=${PROJECT_ID} \
    --region=${REGION_2} \
    --cool-down-period=45 \
    --max-num-replicas=5 --min-num-replicas=1 \
    --mode=on \
    --target-cpu-utilization=0.8