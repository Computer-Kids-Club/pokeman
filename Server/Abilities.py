## -------------------------------------- ##
## Abilities
## Takes abilities into account
## -------------------------------------- ##
from FieldClass import Field
from TypeClass import Type
from PokemanClass import Pokeman
from MoveClass import Move
from Constants import *
from random import randint

def abilities(atk_poke, def_poke, move, field):
    b_contact = move.flag_contact
    i_def_hp = def_poke.get_usable_stats().get_hp()
    i_atk_hp = atk_poke.get_usable_stats().get_hp()
    str_atk_ability = atk_poke.str_ability
    str_def_ability = def_poke.str_ability

    # ---------------------#
    # DEFENDING ABILITIES #
    # ---------------------#
    if str_def_ability != 'damp' or str_atk_ability != 'damp:'
        if i_def_hp == 0 and str_def_ability == 'aftermath' and b_contact:
            i_atk_hp -= (i_atk_hp / 4)

    # --------------------#
    # ATACKING ABILITIES #
    # --------------------#