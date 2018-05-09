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
    str_weather = field.get_weather()
    str_mov_type = move.type.getName()
    str_mov_name = move.str_name
    if move.str_cat == 'physical':
        i_atk = atk_poke.get_usable_stats().get_atk()
        i_def = def_poke.get_usable_stats().get_def()
        if str_status == 'burn':
            i_burn = 0.5
            if str_atk_ability == 'guts' or str_mov_name == 'facade':
                i_burn = 1.5
    elif move.str_cat == 'special':
        i_atk = atk_poke.get_usable_stats().get_spa()
        i_def = def_poke.get_usable_stats().get_spd()
    else:
        i_atk = 0
        i_def = 7
        i_other = 0

    #---------------------#
    # DEFENDING ABILITIES #
    #---------------------#
    if str_def_ability != 'damp' or str_atk_ability != 'damp:'
        if i_def_hp == 0 and str_def_ability == 'aftermath' and b_contact:
            i_atk_hp -= (i_atk_hp / 4)

    if i_def_hp < (def_poke.base_stats.i_hp)//2:
        if str_mov_name != 'leach-seed':
                def_poke.get_usable_stats().get_spa += 1

    if str_mov_name == 'shell-smash':
        if str_def_ability != 'big-pecs'
            def_poke.get_usable_stats().get_def -= 1

    #--------------------#
    # ATACKING ABILITIES #
    #--------------------#
    if str_atk_ability == 'beast-boost':
        if i_damage >= i_def_hp:
            if i_count < 6:
                atk_poke.get_usable_stats().get_atk += 1
                atk_poke.get_usable_stats().get_def += 1
                atk_poke.get_usable_stats().get_spa += 1
                atk_poke.get_usable_stats().get_spd += 1
                atk_poke.get_usable_stats().get_spe += 1
                i_count += 1

    if str_atk_ability == 'blaze':
        if i_atk_hp <= (atk_poke.base_states.i_hp)//3
            i_atk += i_atk//2

    if str_atk_ability == 'chlorophyll':
        if str_weather == Weather.HARSH_SUNLIGHT or str_weather == Weather.EXTREMELY_HARSH_SUNLIGHT:
            atk_poke.get_usable_stats().get_spe *= 2

    if str_def_ability == 'chlorophyll':
        if str_weather == Weather.HARSH_SUNLIGHT or str_weather == Weather.EXTREMELY_HARSH_SUNLIGHT:
            def_poke.get_usable_stats().get_spe *= 2

    