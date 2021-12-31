from google.cloud import logging

def delete_sink(sink_name):
    """Deletes a sink."""
    logging_client = logging.Client()
    sink = logging_client.sink(sink_name)

    sink.delete()

    print("Deleted sink {}".format(sink.name))

if __name__ == '__main__':
    sink_name ="all_logs"
    delete_sink(sink_name)

    