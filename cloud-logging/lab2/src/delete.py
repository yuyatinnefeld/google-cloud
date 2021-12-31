from google.cloud import logging


def delete_logger(logger_name):
    """Deletes a logger and all its entries.

    Note that a deletion can take several minutes to take effect.
    """
    logging_client = logging.Client()
    logger = logging_client.logger(logger_name)

    logger.delete()

    print("Deleted all logging entries for {}".format(logger.name))
    
    
    
if __name__ == '__main__':
    logger_name = "my_custom_logger2"
    delete_logger(logger_name)