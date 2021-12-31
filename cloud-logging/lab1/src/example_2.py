from google.cloud import logging


logging_client = logging.Client()
logger_name = "my_custom_logger2"
logger = logging_client.logger(logger_name)

with logger.batch() as blogger:
    for i in range(10):                                                        
        blogger.log_text('hello log world.')    
