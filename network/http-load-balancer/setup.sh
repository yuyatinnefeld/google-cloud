# source: https://www.cloudskillsboost.google/focuses/12007?parent=catalog

# set default region and zone
gcloud config set compute/zone europe-west1-b
gcloud config set compute/region europe-west1

# create 3 GCE vms with network tag
gcloud compute instances create www1 \
  --image-family debian-9 \
  --image-project debian-cloud \
  --zone europe-west1-b \
  --tags network-lb-tag \
  --metadata startup-script="#! /bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo service apache2 restart
    echo '<!doctype html><html><body><h1>www1</h1></body></html>' | tee /var/www/html/index.html"

gcloud compute instances create www2 \
  --image-family debian-9 \
  --image-project debian-cloud \
  --zone europe-west1-b \
  --tags network-lb-tag \
  --metadata startup-script="#! /bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo service apache2 restart
    echo '<!doctype html><html><body><h1>www2</h1></body></html>' | tee /var/www/html/index.html"

gcloud compute instances create www3 \
  --image-family debian-9 \
  --image-project debian-cloud \
  --zone europe-west1-b \
  --tags network-lb-tag \
  --metadata startup-script="#! /bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo service apache2 restart
    echo '<!doctype html><html><body><h1>www3</h1></body></html>' | tee /var/www/html/index.html"


# create a firewall rule (tcp:80) with network tag
gcloud compute firewall-rules create www-firewall-network-lb --target-tags network-lb-tag --allow tcp:80

# check the external ip
gcloud compute instances list
EXTERNAL_IP_1=104.155.119.148
EXTERNAL_IP_2=35.195.220.95
EXTERNAL_IP_3=104.155.67.174

curl http://$EXTERNAL_IP_1
curl http://$EXTERNAL_IP_2
curl http://$EXTERNAL_IP_3


###########  configure the load balancing service ##########

# create a static external ip for load balancer
gcloud compute addresses create network-lb-ip-1 --region europe-west1

# add a legacy http health check
gcloud compute http-health-checks create basic-check

# create a target pool
# External TCP/UDP Network Load Balancing can use either a backend service or a target pool to define the group of backend instances that receive incoming traffic.
# backend service -> HTTP(S) LB
# target pools -> TCP LB
gcloud compute target-pools create www-pool --region europe-west1 --http-health-check basic-check

# add intances to the target-pool
gcloud compute target-pools add-instances www-pool --instances www1,www2,www3

# create a forwarding rule
# Forwarding rule references an IP address + ports on which the load balancer accepts traffic
gcloud compute forwarding-rules create www-rule \
    --region europe-west1 \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool

########### sending traffic to your instances ##########

# view the external IP address of the www-rule forwarding rule used by the load balancer:
gcloud compute forwarding-rules describe www-rule --region europe-west1

# access the external ip
IP_ADDRESS=35.195.20.249
while true; do curl -m1 $IP_ADDRESS; done


########### create an HTTP load balancer ##########

# create loadbalancer backend
gcloud compute instance-templates create lb-backend-template \
   --region=europe-west1 \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --image-family=debian-9 \
   --image-project=debian-cloud \
   --metadata=startup-script='#! /bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'

# create instace group
gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=europe-west1-b

# create a fw-allow-health-check firewall rule
gcloud compute firewall-rules create fw-allow-health-check \
    --network=default \
    --action=allow \
    --direction=ingress \
    --source-ranges=130.211.0.0/22,35.191.0.0/16 \
    --target-tags=allow-health-check \
    --rules=tcp:80

# create a static loadbalancer ip address
gcloud compute addresses create lb-ipv4-1 \
    --ip-version=IPV4 \
    --global

# verify the ip address
gcloud compute addresses describe lb-ipv4-1 \
    --format="get(address)" \
    --global

LB_IP_ADDRESS=34.102.251.192

# create a health check for the lb
gcloud compute health-checks create http http-basic-check \
    --port 80

# create lb backend service 
gcloud compute backend-services create web-backend-service \
    --protocol=HTTP \
    --port-name=http \
    --health-checks=http-basic-check \
    --global

# add instance group to backend service
gcloud compute backend-services add-backend web-backend-service \
    --instance-group=lb-backend-group \
    --instance-group-zone=europe-west1-b\
    --global

# create url map
gcloud compute url-maps create web-map-http \
    --default-service web-backend-service

# create target http proxiy
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http

# create global forwarding rule
gcloud compute forwarding-rules create http-content-rule \
    --address=lb-ipv4-1\
    --global \
    --target-http-proxy=http-lb-proxy \
    --ports=80


########### testing traffic sent to your instances ##########

# check a new loadbalancer 

loadbalancer > web-map-http

# check the health status
web-map-http > health >  2 of 2

# open the the 
LB_IP_ADDRESS=34.102.251.192

curl http://$LB_IP_ADDRESS/

#check the result
#Page served from: lb-backend-group-xxxx).

########### clean ##########

# delete backend in the gcp console
web-map-http
www-pool
vm instances

gcloud compute firewall-rules delete www-firewall-network-lb
gcloud compute firewall-rules delete fw-allow-health-check
gcloud compute instance-groups managed delete lb-backend-group
gcloud compute instance-templates delete lb-backend-template
gcloud compute addresses delete network-lb-ip-1 --region europe-west1
