from google.cloud import logging


logging_client = logging.Client()
logger_name = "my_custom_logger2"                                
logger = logging_client.logger(logger_name)                                 
                                                                               
for i in range(10):
    print(f"create log i")                                               
    logger.log_struct({'key':'hello-yt', 'number':i})  