from google.cloud import logging


def create_sink(sink_name, destination_bucket, filter_):
    """Creates a sink to export logs to the given Cloud Storage bucket.

    The filter determines which logs this sink matches and will be exported
    to the destination. For example a filter of 'severity>=INFO' will send
    all logs that have a severity of INFO or greater to the destination.
    See https://cloud.google.com/logging/docs/view/advanced_filters for more
    filter information.
    """
    logging_client = logging.Client()

    # The destination can be a Cloud Storage bucket, a Cloud Pub/Sub topic,
    # or a BigQuery dataset. In this case, it is a Cloud Storage Bucket.
    # See https://cloud.google.com/logging/docs/api/tasks/exporting-logs for
    # information on the destination format.
    destination = "storage.googleapis.com/{bucket}".format(bucket=destination_bucket)

    sink = logging_client.sink(sink_name, filter_=filter_, destination=destination)

    if sink.exists():
        print("Sink {} already exists.".format(sink.name))
        return

    sink.create()
    print("Created sink {}".format(sink.name))
    
if __name__ == '__main__':
    sink_name ="all_logs"
    destination_bucket="oraora-loglog-bucket"
    filter_ = "severity>=INFO"
    create_sink(sink_name, destination_bucket, filter_)
