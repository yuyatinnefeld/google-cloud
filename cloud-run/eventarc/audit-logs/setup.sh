

############# setup audit logs #############

# create a bucket
BUCKET_NAME=eventarc-auditlog-$PROJECT_ID
gsutil mb -l $REGION gs://$BUCKET_NAME

# enable audit logs
IAM & Admin > Audit Logs > filter and activate "Google Cloud Storage" > Admin Read, Data Read, Data Write

# update bucket
echo "Hello World" > random.txt
gsutil cp random.txt gs://$BUCKET_NAME/random.txt

# verify
cloud logging > explorer > filter GCS with bucketname "eventarc-auditlog-yuyatinnefeld-dev"

# check the audit log trigger info
gcloud beta eventarc attributes types describe google.cloud.audit.log.v1.written

# create a trigger
TRIGGER_NAME=trigger-auditlog
gcloud eventarc triggers create $TRIGGER_NAME\
  --destination-run-service=$SERVICE_NAME \
  --destination-run-region=$REGION \
  --event-filters="type=google.cloud.audit.log.v1.written" \
  --event-filters="serviceName=storage.googleapis.com" \
  --event-filters="methodName=storage.objects.create" \
  --event-filters-path-pattern="resourceName=/projects/_/buckets/$BUCKET_NAME/objects/*" \
  --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com

# verify the result
gcloud eventarc triggers list
gsutil cp random.txt gs://$BUCKET_NAME/random.txt

# check
cloud run > log > check this msg "... Received event of type google.cloud.audit.log.v1.written. Event data: ..."


############# clean up #############

gcloud eventarc triggers delete $TRIGGER_NAME
gsutil rm -r gs://$BUCKET_NAME

