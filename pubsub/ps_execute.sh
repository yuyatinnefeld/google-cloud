#!/bin/bash

PROJECT="helloyuyaworld"
REGION="europe-west3"
ZONE="europe-west3-b"
PROJECT_ID="helloyuyaworld-12345"
TOPICS="my-topic"
SUBSCRIBER="subscriber-chan"

docker run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk \
gcloud pubsub topics create ${TOPICS}

docker run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk \
gcloud pubsub subscriptions create ${SUBSCRIBER} --topic ${TOPICS}

docker run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk \
gcloud pubsub topics publish ${TOPICS} --message="hello" \
  --attribute="origin=gcloud-sample,username=gcp"

docker run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk \
gcloud pubsub subscriptions pull --auto-ack ${SUBSCRIBER}

