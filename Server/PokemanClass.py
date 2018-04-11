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

        self.i_happy = 255
        self.b_shiny = False
        self.i_lv = 100
        self.str_gender = "gay"

        self.type_1 = Type()
        self.type_2 = None

        self.str_ability = "error"
        self.str_nature = "error"
        self.str_item = "error"

        self.l_moves = [Move(),Move(),Move(),Move()]

        self.f_height = 0
        self.f_weight = 0

        self.base_stats = Stats()
        self.ev_stats = Stats()
        self.iv_stats = Stats()
        self.nature_stats = Stats()

        self.evasion = 1

        self.item_stats = Stats()
        self.modifier_stats = Stats()

    def get_moves(self):
        return self.l_moves

    def get_stats_range(self):
        return Stats(),Stats()

    def get_usable_stats(self):
        return self.base_stats

    def to_dic(self):
        dic_poke = {}

        dic_poke["num"] = self.i_num

        self.get_usable_stats().to_dic(dic_poke,"base")

        dic_poke['hap'] = self.i_happy
        dic_poke['lv'] = self.i_lv
        dic_poke['shiny'] = self.b_shiny

        dic_poke['moves'] = [move.to_dic() for move in self.l_moves]

        return dic_poke

    # overriding str method
    def __str__(self):
        return self.str_name
