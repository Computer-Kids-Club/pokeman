## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from TypeClass import Type
from MoveClass import Move
from StatClass import Stats

class Pokeman(object):
    def __init__(self,num=1):
        self.i_num = num
        self.str_name = "Pikachu"

        self.b_shiny = False

        self.type_1 = Type()
        self.type_2 = None

        self.str_ability = "error"
        self.str_nature = "error"
        self.str_item = "error"

        self.l_moves = [Move(),Move(),Move(),Move()]

        self.base_stats = Stats()
        self.ev_stats = Stats()
        self.iv_stats = Stats()
        self.nature_stats = Stats()

        self.item_stats = Stats()
        self.modifier_stats = Stats()

    def get_moves(self):
        return self.l_moves

    def get_stats_range(self):
        return Stats(),Stats()

    def get_usable_stats(self):
        return Stats()

    # overriding str method
    def __str__(self):
        return self.str_name
