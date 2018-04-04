## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from Constants import *

class Move(object):
    def __init__(self,name="Thunder Bolt"):
        self.str_name = name
        self.i_dmg = 0
        self.i_acc = 0
        self.i_pp = 0

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
