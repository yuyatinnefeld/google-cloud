############# setup environemtn #############

# create python env
apt-get install -y virtualenv
python3 -m venv venv
source venv/bin/activate

# install client library
pip install --upgrade google-cloud-pubsub
git clone https://github.com/googleapis/python-pubsub.git
cd python-pubsub/samples/snippets

# basic cmd
python publisher.py $GOOGLE_CLOUD_PROJECT create MyTopic
python publisher.py $GOOGLE_CLOUD_PROJECT list
python subscriber.py $GOOGLE_CLOUD_PROJECT create MyTopic MySub
python subscriber.py $GOOGLE_CLOUD_PROJECT list-in-project

# publish messages
gcloud pubsub topics publish MyTopic --message "Hello"
gcloud pubsub topics publish MyTopic --message "Hey"
gcloud pubsub topics publish MyTopic --message "Hi"

# check messages
python subscriber.py $GOOGLE_CLOUD_PROJECT receive MySub