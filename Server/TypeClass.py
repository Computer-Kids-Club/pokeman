## -------------------------------------- ##
## Type Class
## contains just the class
## -------------------------------------- ##

from Constants import *

class Type(object):
    def __init__(self,name="normal"):
        self.str_name = name.lower()

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
