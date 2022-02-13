# create 2 instance templates

TEMPLATE_NAME_1="us-east1-template"
METADATA="startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh,enable-oslogin=true"
REGION="us-east1"

gcloud compute instance-templates create ${TEMPLATE_NAME_1} \
    --project=${PROJECT_ID} \
    --machine-type=n1-standard-1 \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --metadata=${METADATA} \
    --maintenance-policy=MIGRATE \
    --service-account=809689202411-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append  \
    --region=${REGION} \
    --tags=${NW_TAG} \
    --create-disk=auto-delete=yes,boot=yes,device-name=${TEMPLATE_NAME_1},image=projects/debian-cloud/global/images/debian-10-buster-v20220118,mode=rw,size=10,type=pd-balanced  \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any

TEMPLATE_NAME_2="europe-west1-template"
METADATA="startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh,enable-oslogin=true"
REGION="europe-west1"

gcloud compute instance-templates create ${TEMPLATE_NAME_2} \
    --project=${PROJECT_ID} \
    --machine-type=n1-standard-1 \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --metadata=${METADATA} \
    --maintenance-policy=MIGRATE \
    --service-account=809689202411-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append  \
    --region=${REGION} \
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
    --region=us-east1 --cool-down-period=45 \
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
    --zone=europe-west1-b


gcloud beta compute instance-groups managed set-autoscaling ${GROUP_2} \
    --project=${PROJECT_ID} \
    --region=us-east1 --cool-down-period=45 \
    --max-num-replicas=5 \
    --min-num-replicas=1 \
    --mode=on \
    --target-cpu-utilization=0.8


# confirm the GCE backend access
EXTERNAL_IP_BACKEND=35.185.2.3
curl ${EXTERNAL_IP_BACKEND}



# configure HTTP LB to balance traffic between the two backends

# 1 Create load balancer
# From Internet to my VMs or serverless services
# Name = http-lb

# 2 configure the backend
# 3 Create Backend Service
# name = http-backend
# Instance group = us-east1-mig
# port number = 80
# Balancing mode = Rate
# Maximum RPS = 50
# Capacity = 100

+

# name = http-backend
# Instance group = europe-west1-mig
# port number = 80
# Balancing mode = Rate
# Maximum RPS = 80
# Capacity = 100

# 4 create a health check
# name = http-health-check
# protocol = TCP
# port = 80

# 5 configure frontend
# protocol = HTTP
# IP version =IPv4
# IP Address = Eph
# Port = 80

+

# protocol = HTTP
# IP version =IPv6
# IP Address = Eph
# Port = 80



# access LB
LB_IP=34.111.247.23:80
curl ${LB_IP}