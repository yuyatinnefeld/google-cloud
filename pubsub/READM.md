# PubSub
## create topics (XXXX)
```bash
gcloud pubsub topics create XXXX
```

## create a subscriber (YYY)
```bash
gcloud pubsub subscriptions create YYY --topic XXXX
```

Python SDK
```bash
subscription = subscriber.create_subscription(subscription_path, topic_path, push_config)
```

##check
```bash
gcp gcloud pubsub topics list
```

##create test message
```bash
gcloud pubsub topics publish XXXX --message="hello" \
--attribute="origin=gcloud-sample,username=gcp"
```

```bash
gcloud pubsub subscriptions pull --auto-ack YYY

┌───────┬──────────────────┬──────────────┬──────────────────────┬──────────────────┐
│  DATA │    MESSAGE_ID    │ ORDERING_KEY │      ATTRIBUTES      │ DELIVERY_ATTEMPT │
├───────┼──────────────────┼──────────────┼──────────────────────┼──────────────────┤
│ hello │ 2529979397150706 │              │ origin=gcloud-sample │                  │
│       │                  │              │ username=gcp         │                  │
└───────┴──────────────────┴──────────────┴──────────────────────┴──────────────────┘
```