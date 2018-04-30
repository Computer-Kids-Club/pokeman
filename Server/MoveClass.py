## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from Constants import *
from StatClass import Stats
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

        self.i_priority = 0

        if self.str_name in ["helping-hand"]:
            self.i_priority = 5
        elif self.str_name in ["detect", "magic-coat", "protect", "snatch"]:
            self.i_priority = 4
        elif self.str_name in ["crafty-shield", "fake-out", "quick-guard", "wide-guard", "spotlight"]:
            self.i_priority = 3
        elif self.str_name in ["ally-switch", "extreme-speed", "feint", "first-impression", "follow-me", "rage-powder"]:
            self.i_priority = 2
        elif self.str_name in ["accelerock", "aqua-jet", "baby-doll-eyes", "bide", "bullet-punch", "ice-shard", "ion-deluge", "mach-punch", "powder", "quick-attack", "shadow-sneak", "sucker-punch", "vacuum-wave", "water-shuriken"]:
            self.i_priority = 1
        elif self.str_name in ["vital-throw"]:
            self.i_priority = -1
        elif self.str_name in ["beak-blast", "focus-punch", "shell-trap"]:
            self.i_priority = -3
        elif self.str_name in ["avalanche", "revenge"]:
            self.i_priority = -4
        elif self.str_name in ["counter", "mirror-coat"]:
            self.i_priority = -5
        elif self.str_name in ["circle-throw", "dragon-tail", "roar", "whirlwind"]:
            self.i_priority = -6
        elif self.str_name in ["trick-room"]:
            self.i_priority = -7

        print(name)
        self.flag_contact = dic_move['flag_contact']
        self.flag_charge = dic_move['flag_charge']
        self.flag_recharge = dic_move['flag_recharge']
        self.flag_protect = dic_move['flag_protect']
        self.flag_reflectable = dic_move['flag_reflectable']
        self.flag_snatch = dic_move['flag_snatch']
        self.flag_mirror = dic_move['flag_mirror']
        self.flag_punch = dic_move['flag_punch']
        self.flag_sound = dic_move['flag_sound']
        self.flag_gravity = dic_move['flag_gravity']
        self.flag_defrost = dic_move['flag_defrost']
        self.flag_distance = dic_move['flag_distance']
        self.flag_heal = dic_move['flag_heal']
        self.flag_authentic = dic_move['flag_authentic']
        self.flag_powder = dic_move['flag_powder']
        self.flag_bite = dic_move['flag_bite']
        self.flag_pulse = dic_move['flag_pulse']
        self.flag_ballistics = dic_move['flag_ballistics']
        self.flag_mental = dic_move['flag_mental']
        self.flag_non_sky_battle = dic_move['flag_non-sky-battle']
        self.flag_dance = dic_move['flag_dance']

        self.str_anime_style = self.str_cat
        if self.flag_punch:
            self.str_anime_style = "flag_punch"
        if self.flag_sound:
            self.str_anime_style = "flag_sound"
        if self.flag_powder:
            self.str_anime_style = "flag_powder"
        if self.flag_bite:
            self.str_anime_style = "flag_bite"
        if self.flag_pulse:
            self.str_anime_style = "flag_pulse"
        if self.flag_ballistics:
            self.str_anime_style = "flag_ballistics"
        if self.flag_dance:
            self.str_anime_style = "flag_dance"

        self.b_stat_change = False
        if 'stacha' in dic_move:
            self.b_stat_change = True
            self.i_stat_change_chance = dic_move['stacha']

            self.users_stat_changes = Stats(dic_move['ihp'],dic_move['iatk'],dic_move['idef'],dic_move['ispa'],dic_move['ispd'],dic_move['ispe'])
            self.targets_stat_changes = Stats(dic_move['uhp'],dic_move['uatk'],dic_move['udef'],dic_move['uspa'],dic_move['uspd'],dic_move['uspe'])

            #print(name,"hey")

        self.b_status_effect= False
        if 'effcha' in dic_move:
            self.b_status_effect = True
            self.i_status_effect_chance = dic_move['effcha']
            self.str_status_effect = dic_move['eff']

    def to_dic(self):
        move_dic = {}

        move_dic["name"] = self.str_name

        move_dic["type"] = self.type.getName()
        move_dic["cat"] = self.str_cat

        move_dic["power"] = self.i_pow
        move_dic["acc"] = self.i_acc

        move_dic["pp"] = self.i_pp
        move_dic["maxpp"] = self.i_max_pp

        move_dic["anime"] = self.str_anime_style

        return move_dic

    def get_recoil_ratio(self):
        i_recoil_ratio = 0

        if self.str_name in ["take-down", "submission", "wild-charge", "head-charge", "shadow-rush"]:
            i_recoil_ratio = 1/4
        elif self.str_name in ["double-edge", "volt-tackle", "flare-blitz", "brave-bird", "wood-hammer"]:
            i_recoil_ratio = 1/3
        elif self.str_name in ["head-smash", "light-of-ruin"]:
            i_recoil_ratio = 1/2

        return i_recoil_ratio

    def get_heal_hp(self, i_dmg, atk_poke):
        i_heal_hp = 0

        if self.str_name == "dream-eater" and atk_poke.str_status == "sleep":
            i_heal_hp = i_dmg * 1/2
        elif self.str_name in ["absorb", "drain-punch", "giga-drain", "horn-leech", "leech-life", "mega-drain"]:
            i_heal_hp = i_dmg * 1/2
        elif self.str_name in ["heal-order", "heal-pulse", "milk-drink"]:
            i_heal_hp = atk_poke.get_usable_stats().i_hp * 1 / 2
        elif self.str_name in ["recover", "roost", "slack-off", "softboiled"]:
            i_heal_hp = atk_poke.get_usable_stats().i_hp * 1 / 2
        elif self.str_name in ["rest"]:
            i_heal_hp = atk_poke.get_usable_stats().i_hp * 1 / 1
            atk_poke.str_status = "none"

        return i_heal_hp

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
