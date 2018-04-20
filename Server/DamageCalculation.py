## -------------------------------------- ##
## Damage Calculations
## calculates the damage
## -------------------------------------- ##

from FieldClass import Field
from PokemanClass import Pokeman
from MoveClass import Move
from Constants import *
from random import randint

def attack(atk_poke,def_poke,move,field):
    i_lvl = atk_poke.i_lv
    i_pow = move.i_pow
    i_crit = 1
    i_rand = randint(85,100)/100
    i_stab = 1
    str_pok_type_1 = atk_poke.type_1.getName()
    if atk_poke.type_2 != None:
        str_pok_type_2 = atk_poke.type_2.getName()
    else:
        str_pok_type_2 = ''
    str_mov_type = move.str_type.getName()
    if (str_pok_type_1 == str_mov_type) or (str_pok_type_2 == str_mov_type):
        i_stab = 1.5

    i_goal = randint(1,16)
    if i_goal == 1:
        i_crit = 1.5

    i_type = move.type.getAtkEff(def_poke.type_1, def_poke.type_2)

    if move.str_cat == 'physical':
        i_atk = atk_poke.get_usable_stats().get_atk()
        i_def = def_poke.get_usable_stats().get_def()

    elif move.str_cat == 'special':
        i_atk = atk_poke.get_usable_stats().get_spa()
        i_def = def_poke.get_usable_stats().get_spd()
    else:
        i_atk = 0
        i_def = 7
    #str_weather = field.get_weather()
    #str_terrain = field.get_terrain()
    i_mod = i_crit*i_stab*i_type*i_rand
    i_damage = ((((((2*i_lvl)/5)+2)*(i_pow)*(i_atk/i_def))/50)+2)*i_mod
    return i_damage

