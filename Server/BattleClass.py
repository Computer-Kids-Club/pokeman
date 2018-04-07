## -------------------------------------- ##
## Battle Class
## just the class
## -------------------------------------- ##

from Constants import *
from FieldClass import Field
from ClientConnection import Client

class Battle(object):
    def __init__(self):

        self.field = Field()

        self.players = [Client(),Client()]

    def run(self):
        #Log.info("battle running")
        return