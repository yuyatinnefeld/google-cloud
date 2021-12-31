from google.cloud import logging


def write_entry(logger_name):
    """Writes log entries to the given logger."""
    logging_client = logging.Client()

    # This log can be found in the Cloud Logging console under 'Custom Logs'.
    logger = logging_client.logger(logger_name)

    # Make a simple text log
    logger.log_text("Hello, world!")

    # Simple text log with severity.
    logger.log_text("Goodbye, world!", severity="ERROR")

    # Struct log. The struct can be any JSON-serializable dictionary.
    logger.log_struct(
        {
            "name": "King Arthur",
            "quest": "Find the Holy Grail",
            "favorite_color": "Blue",
        }, 
        severity="ERROR"
    )

    print("Wrote logs to {}.".format(logger.name))
    

logger_name = "my_custom_logger3"
write_entry(logger_name)