## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from Constants import *
from TypeClass import Type

class Move(object):
    def __init__(self,name="Thunder Bolt"):

        self.str_name = name

        self.str_type = "normal"
        self.str_cat = "physical"

        self.type = Type()

        self.i_pow = 0
        self.i_acc = 0

        self.i_pp = 0
        self.i_max_pp = 0

    def to_dic(self, move_dic={}):

        move_dic["name"] = self.str_name

        move_dic["type"] = self.i_pow
        move_dic["cat"] = self.str_cat

        move_dic["power"] = self.i_pow
        move_dic["acc"] = self.i_acc

        move_dic["pp"] = self.i_pp
        move_dic["maxpp"] = self.i_max_pp

        return move_dic

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
