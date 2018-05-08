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

def abilities(atk_poke, def_poke, move, field, i_damage):
    b_contact = move.flag_contact
    i_def_hp = def_poke.get_usable_stats().get_hp()
    i_atk_hp = atk_poke.get_usable_stats().get_hp()
    str_atk_ability = atk_poke.str_ability
    str_def_ability = def_poke.str_ability
    i_count = 0
    str_mov_type = move.type.getName()
    str_mov_name = move.str_name

    # --------------------#
    # DEFENDING ABILITIES #
    # --------------------#
    if str_def_ability != 'damp' or str_atk_ability != 'damp:'
        if i_def_hp == 0 and str_def_ability == 'aftermath' and b_contact:
            i_atk_hp -= (i_atk_hp / 4)

    if i_def_hp < (def_poke.base_stats.i_hp)//2:
        if str_mov_name != 'leach-seed':
            def_poke.get_usable_stats().get_spa += 1

    # -------------------#
    # ATACKING ABILITIES #
    # -------------------#
    if str_atk_ability == 'beast-boost':
        if i_damage >= i_def_hp:
            if i_count < 6:
                atk_poke.get_usable_stats().get_atk += 1
                atk_poke.get_usable_stats().get_def += 1
                atk_poke.get_usable_stats().get_spa += 1
                atk_poke.get_usable_stats().get_spd += 1
                atk_poke.get_usable_stats().get_spe += 1
                i_count += 1
