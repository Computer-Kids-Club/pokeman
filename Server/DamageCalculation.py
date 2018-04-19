## -------------------------------------- ##
## Damage Calculations
## calculates the damage
## -------------------------------------- ##

from FieldClass import Field
from PokemanClass import Pokeman
from MoveClass import Move
from Constants import *

def attack(atk_poke,def_poke,move,field):
    if move.str_cat == 'physical':
        i_atk = atk_poke.get_usable_stats().get_atk()
        i_def = def_poke.get_usable_stats().get_def()

    elif move.str_cat == 'status':
        i_atk = 0
        i_def = 0
    else:
        i_atk = atk_poke.get_usable_stats().get_spa()
        i_def = def_poke.get_usable_stats().get_spd()
    str_weather = field.get_weather()
    str_terrain = field.get_terrain()
    str_lvl = atk_poke.i_lv
