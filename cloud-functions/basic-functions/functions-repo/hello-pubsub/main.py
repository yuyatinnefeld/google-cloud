import functions_framework

@functions_framework.cloud_event
def hello_pubsub(cloud_event):
   print('Pub/Sub with Python in GCF 2nd gen! Id: ' + cloud_event['id'])