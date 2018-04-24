## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from TypeClass import Type
from MoveClass import Move
from StatClass import Stats
from Constants import *
from random import choice, randint
import json

class Pokeman(object):
    def __init__(self,num=1):
        self.i_num = num

        dic_poke = json.load(open(dir_path + '/pokeinfo/pokemon/' + str(num) + '.txt'))

        self.str_name = dic_poke["name"]

        self.i_happy = 255
        self.b_shiny = False
        self.i_lv = 100
        self.str_gender = "gay"

        self.type_1 = Type(dic_poke["type1"])
        self.type_2 = None
        if "type2" in dic_poke:
            self.type_2 = Type(dic_poke["type2"])

        self.l_possible_abi = [dic_poke["ability1"]]
        if "ability2" in dic_poke:
            self.l_possible_abi.append(dic_poke["ability2"])
        if "hiddenability" in dic_poke:
            self.l_possible_abi.append(dic_poke["hiddenability"])

        self.str_ability = choice(self.l_possible_abi)
        self.str_nature = "error"
        self.str_item = "error"

        self.str_status = 'none'

        self.l_possible_moves = []
        for dic_move in dic_poke["levelmoves"]:
            self.l_possible_moves.append(dic_move["move"])
        for dic_move in dic_poke["eggmoves"]:
            self.l_possible_moves.append(dic_move["move"])
        for dic_move in dic_poke["tutormoves"]:
            self.l_possible_moves.append(dic_move["move"])
        for dic_move in dic_poke["tmmoves"]:
            self.l_possible_moves.append(dic_move["move"])
        self.l_possible_moves = list(set(self.l_possible_moves))

        self.l_moves = [Move(choice(self.l_possible_moves)),Move(choice(self.l_possible_moves)),Move(choice(self.l_possible_moves)),Move(choice(self.l_possible_moves))]

        self.f_height = dic_poke["height"]
        self.f_weight = dic_poke["weight"]

        self.base_stats = Stats()
        self.base_stats.i_hp = dic_poke["HP"]
        self.base_stats.i_atk = dic_poke["ATK"]
        self.base_stats.i_def = dic_poke["DEF"]
        self.base_stats.i_spa = dic_poke["SPA"]
        self.base_stats.i_spd = dic_poke["SPD"]
        self.base_stats.i_spe = dic_poke["SPE"]

        #self.ev_stats = Stats()
        #self.iv_stats = Stats()
        #self.nature_stats = Stats()

        self.i_evasion = 1

        self.item_stats = Stats()
        self.modifier_stats = Stats()

        self.i_hp = self.get_usable_stats().i_hp

        self.b_fainted = False

    def get_moves(self):
        return self.l_moves

    def get_stats_range(self):
        return Stats(),Stats()

    def get_usable_stats(self):
        return self.base_stats

    def to_dic(self):
        dic_poke = {}

        dic_poke["num"] = self.i_num
        dic_poke["name"] = self.str_name

        self.get_usable_stats().to_dic(dic_poke,"base")

        dic_poke['hap'] = self.i_happy
        dic_poke['shiny'] = self.b_shiny
        dic_poke['lv'] = self.i_lv
        dic_poke['gender'] = self.str_gender

        dic_poke['type1'] = self.type_1.getName()
        if self.type_2 != None:
            dic_poke['type2'] = self.type_2.getName()

        dic_poke['ability'] = self.str_ability
        dic_poke['item'] = self.str_item

        l_tmp_move_dic = []
        for move in self.l_moves:
            l_tmp_move_dic.append(move.to_dic())
            #print(str(move))
        dic_poke['moves'] = l_tmp_move_dic

        dic_poke['eva'] = self.i_evasion

        dic_poke['hp'] = self.i_hp

        dic_poke['faint'] = self.b_fainted

        return dic_poke

    # overriding str method
    def __str__(self):
        return self.str_name

    def is_usable(self):
        return not self.b_fainted

    def is_trapped(self):
        return False
