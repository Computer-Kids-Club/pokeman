## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from Constants import *

class Move(object):
    def __init__(self):
        self.str_name = "Thunder Bolt"
        self.i_dmg = 0
        self.i_acc = 0
        self.i_pp = 0

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
