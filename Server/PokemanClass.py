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
        self.toxic_idx = 1

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

        self.f_height = (dic_poke["height"])
        self.f_weight = (dic_poke["weight"])

        self.base_stats = Stats()
        self.base_stats.i_hp = int(dic_poke["HP"])
        self.base_stats.i_atk = int(dic_poke["ATK"])
        self.base_stats.i_def = int(dic_poke["DEF"])
        self.base_stats.i_spa = int(dic_poke["SPA"])
        self.base_stats.i_spd = int(dic_poke["SPD"])
        self.base_stats.i_spe = int(dic_poke["SPE"])

        self.usable_stats = Stats()

        self.usable_stats.i_hp = ((((2 * self.base_stats.i_hp + 31 + int(88 / 4)) * 100)) / 100 + 100 + 10)
        self.usable_stats.i_atk = (((2 * self.base_stats.i_atk + 31 + int(84 / 4)) * 100) / 100 + 5)
        self.usable_stats.i_def = (((2 * self.base_stats.i_def + 31 + int(84 / 4)) * 100) / 100 + 5)
        self.usable_stats.i_spa = (((2 * self.base_stats.i_spa + 31 + int(84 / 4)) * 100) / 100 + 5)
        self.usable_stats.i_spd = (((2 * self.base_stats.i_spd + 31 + int(84 / 4)) * 100) / 100 + 5)
        self.usable_stats.i_spe = (((2 * self.base_stats.i_spe + 31 + int(84 / 4)) * 100) / 100 + 5)

        #self.ev_stats = Stats()
        #self.iv_stats = Stats()
        #self.nature_stats = Stats()

        self.i_evasion = 0
        self.i_accuracy = 0

        self.item_stats = Stats(0, 0, 0, 0, 0, 0)
        self.modifier_stats = Stats(0, 0, 0, 0, 0, 0)

        self.i_hp = self.get_usable_stats().i_hp

        self.b_fainted = False

    def get_moves(self):
        return self.l_moves

    def get_stats_range(self):
        return Stats(),Stats()

    def get_usable_stats(self):
        actually_usable_stats = self.usable_stats*self.modifier_stats.get_modifier_rates()

        if self.str_status == "paralyze":
            actually_usable_stats.i_spe = actually_usable_stats.i_spe//2

        return actually_usable_stats

    def to_dic(self):
        dic_poke = {}

        dic_poke["num"] = self.i_num
        dic_poke["name"] = self.str_name

        dic_poke["status"] = self.str_status

        dic_poke["statchange"] = []
        if self.modifier_stats.i_atk != 0:
            dic_poke["statchange"].append("atk "+str(self.modifier_stats.i_atk))
        if self.modifier_stats.i_def != 0:
            dic_poke["statchange"].append("def "+str(self.modifier_stats.i_def))
        if self.modifier_stats.i_spa != 0:
            dic_poke["statchange"].append("spa "+str(self.modifier_stats.i_spa))
        if self.modifier_stats.i_spd != 0:
            dic_poke["statchange"].append("spd "+str(self.modifier_stats.i_spd))
        if self.modifier_stats.i_spe != 0:
            dic_poke["statchange"].append("spe "+str(self.modifier_stats.i_spe))

        #print(self.modifier_stats.to_dic({}),dic_poke["statchange"])

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
