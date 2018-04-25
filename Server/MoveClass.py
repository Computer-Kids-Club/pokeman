## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from Constants import *
from TypeClass import Type
import json
from pathlib import Path


def parse_move_json(str_json, i_default=0):
    i_ret = i_default
    if str_json != '-' and str_json != '???' and str_json != 'error' and str_json != '':
        i_ret = int(str_json)
    return i_ret


class Move(object):
    def __init__(self, name="tackle"):
        if name == None or name == "":
            name = "error"

        self.str_name = name

        dic_move = json.load(open(dir_path + '/pokeinfo/move/' + name + '.txt'))

        self.str_type = dic_move['type']
        self.str_cat = dic_move['cat']

        self.type = Type(self.str_type)

        self.i_pow = parse_move_json(dic_move['power'])
        self.i_acc = parse_move_json(dic_move['acc'])
        if self.i_acc == 0:
            self.i_acc = 100

        self.i_max_pp = parse_move_json(dic_move['pp'])
        self.i_pp = self.i_max_pp

        self.i_prob = parse_move_json(dic_move['prob'])

    def to_dic(self):
        move_dic = {}

        move_dic["name"] = self.str_name

        move_dic["type"] = self.type.getName()
        move_dic["cat"] = self.str_cat

        move_dic["power"] = self.i_pow
        move_dic["acc"] = self.i_acc

        move_dic["pp"] = self.i_pp
        move_dic["maxpp"] = self.i_max_pp

        return move_dic

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
