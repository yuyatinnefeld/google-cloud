
############# setup pubsub #############

# check the trigger definition
gcloud beta eventarc attributes types describe google.cloud.pubsub.topic.v1.messagePublished

# create a trigger for pubsub
TRIGGER_NAME="trigger-pubsub"

gcloud eventarc triggers create $TRIGGER_NAME \
  --destination-run-service=$SERVICE_NAME \
  --destination-run-region=$REGION \
  --event-filters="type=google.cloud.pubsub.topic.v1.messagePublished"

# find the topic
TOPIC_ID=$(gcloud eventarc triggers describe $TRIGGER_NAME --format='value(transport.pubsub.topic)')

# check the eventarc trigger
gcloud eventarc triggers list

# send a topic
gcloud pubsub topics publish $TOPIC_ID --message="Hello World"

# check
cloud run > log > check this msg "... Received event of type google.cloud.pubsub.topic.v1.messagePublished. Event data: Hello World"


############# clean up #############

gcloud eventarc triggers delete $TRIGGER_NAME
