from google.cloud import logging


def list_sinks():
    """Lists all sinks."""
    logging_client = logging.Client()

    sinks = list(logging_client.list_sinks())

    if not sinks:
        print("No sinks.")

    for sink in sinks:
        print("{}: {} -> {}".format(sink.name, sink.filter_, sink.destination))


if __name__ == '__main__':
    list_sinks()
