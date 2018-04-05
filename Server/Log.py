## -------------------------------------- ##
## Log
## logs errors and stuff
## -------------------------------------- ##

from Constants import *
from datetime import datetime
import logging
logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)

b_logging = True

class Log(object):
    def __init__(self):
        pass

    @staticmethod
    def debug(str_message):
        if not b_logging:
            return

        #print(str_message)

        logging.debug(str(datetime.now())+': '+str_message)

        #log_file = open('log.txt','w')

        #log_file.write(str(datetime.now())+': '+str_message)

        #log_file.close()

    def info(str_message):
        if not b_logging:
            return
        logging.info(str(datetime.now())+': '+str_message)

    def warning(str_message):
        if not b_logging:
            return
        logging.warning(str(datetime.now())+': '+str_message)