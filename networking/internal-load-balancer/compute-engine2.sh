PROJECT_ID=$(gcloud config get-value project)
ZONE_3="us-central1-f"
PROJECT_NUM="114877050363"
SERVICE_ACCOUNT="${PROJECT_NUM}-compute@developer.gserviceaccount.com"
SUBNET="subnet-a"
PRIVAT_IP=10.10.20.50

gcloud compute instances create utility-vm \
 --project=${PROJECT_ID} \
 --zone=${ZONE_3} \
 --machine-type=f1-micro \
 --network-interface=network-tier=PREMIUM,private-network-ip=${PRIVAT_IP},subnet=${SUBNET} \
 --metadata=enable-oslogin=true \
 --maintenance-policy=MIGRATE \
 --provisioning-model=STANDARD \
 --service-account=${SERVICE_ACCOUNT} \
 --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
 --create-disk=auto-delete=yes,boot=yes,device-name=utility-vm,image=projects/debian-cloud/global/images/debian-10-buster-v20220118,mode=rw,size=10,type=projects/qwiklabs-gcp-00-813dc58b2c33/zones/${ZONE_3}/diskTypes/pd-balanced \
 --no-shielded-secure-boot \
 --shielded-vtpm \
 --shielded-integrity-monitoring \
 --reservation-affinity=any
