
############# setup cloud storage #############

# create a bucket
BUCKET_NAME=eventarc-gcs-$PROJECT_ID
gsutil mb -l $REGION gs://$BUCKET_NAME


# create a trigger
TRIGGER_NAME=trigger-gcs
gcloud eventarc triggers create $TRIGGER_NAME\
  --destination-run-service=$SERVICE_NAME \
  --destination-run-region=$REGION \
  --event-filters="type=google.cloud.storage.object.v1.finalized" \
  --event-filters="bucket=$BUCKET_NAME" \
  --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com

# check the trigger
gcloud eventarc triggers list

# update bucket
echo "Hello World" > random.txt
gsutil cp random.txt gs://$BUCKET_NAME/random.txt

# check
cloud run > log > check this msg "... eceived event of type google.cloud.storage.object.v1.finalized. Event data: { "kind": ..."

# clean up
gcloud eventarc triggers delete $TRIGGER_NAME
gsutil rm -r gs://$BUCKET_NAME