import logging


logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# this handler prints log results in a console
std_handler = logging.StreamHandler()
std_handler.setFormatter(logging.Formatter('%(asctime)s | %(levelname)s | %(filename)s | %(funcName)s | %(message)s | %(name)s'))

logger.addHandler(std_handler)

#this handler saves log results in a file
#file_name = 'debug.log'
#file_handler = logging.FileHandler(file_name)
#file_format = logging.Formatter("%(asctime)s\t%(levelname)s -- %(processName)s -- %(filename)s:%(lineno)s -- %(message)s")
#file_handler.setFormatter(file_format)
#logger.addHandler(file_handler)