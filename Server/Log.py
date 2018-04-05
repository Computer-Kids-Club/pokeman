## -------------------------------------- ##
## Log
## logs errors and stuff
## -------------------------------------- ##

from Constants import *
from datetime import datetime
import logging
logging.basicConfig(format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p',level=logging.DEBUG)

b_logging = True

class Log(object):
    def __init__(self):
        pass

    @staticmethod
    def debug(str_message):
        if not b_logging:
            return

        #print(str_message)

        logging.debug(str_message)

        #log_file = open('log.txt','w')

        #log_file.write(str(datetime.now())+': '+str_message)

        #log_file.close()

    @staticmethod
    def info(str_message):
        if not b_logging:
            return
        logging.info(str_message)

    @staticmethod
    def warning(str_message):
        if not b_logging:
            return
        logging.warning(str_message)