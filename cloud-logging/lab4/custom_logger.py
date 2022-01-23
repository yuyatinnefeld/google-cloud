import logging

import google.cloud.logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2 import Resource

from settings import (
    logger_name,
    logger_type,
    resource_labels,
    labels
)


client = google.cloud.logging.Client()

try:
    handler = CloudLoggingHandler(
        client, name=logger_name, 
        resource=Resource(type=logger_type, labels=resource_labels), 
        labels=labels)
except google.auth.exceptions.DefaultCredentialsError:
    handler = logging.StreamHandler()

custom_logger = logging.getLogger(logger_name)
custom_logger.setLevel(logging.DEBUG)
custom_logger.addHandler(handler)
