############# topics #############

# create a topic
gcloud pubsub topics create myTopic

# test comppleted task
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2
gcloud pubsub topics list

# delete topics
gcloud pubsub topics delete Test1
gcloud pubsub topics delete Test2


############# subscriptions #############

# create a subscription
gcloud  pubsub subscriptions create --topic myTopic mySubscription
gcloud  pubsub subscriptions create --topic myTopic Test1
gcloud  pubsub subscriptions create --topic myTopic Test2

gcloud pubsub topics list-subscriptions myTopic

# delete test subscriptions
gcloud pubsub subscriptions delete Test1
gcloud pubsub subscriptions delete Test2


############# publishing and pulling a single message #############

# create a message
gcloud pubsub topics publish myTopic --message "Hello"
gcloud pubsub topics publish myTopic --message "Hola"
gcloud pubsub topics publish myTopic --message "Konichiwa"

# pull the message
gcloud pubsub subscriptions pull mySubscription --auto-ack

gcloud pubsub topics publish myTopic --message "pubsuuub"
gcloud pubsub topics publish myTopic --message "puuuuubsuuub"
gcloud pubsub topics publish myTopic --message "pubbbbsuuub"

# pull again
gcloud pubsub subscriptions pull mySubscription --auto-ack --limit=3

# clean up
gcloud pubsub topics delete myTopic
gcloud pubsub subscriptions delete mySubscription

