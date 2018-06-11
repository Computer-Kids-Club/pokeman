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
    str_status = atk_poke.str_status
    i_count = 0
    str_weather = field.get_weather()
    str_mov_type = move.type.getName()
    str_mov_name = move.str_name
    i_a_atk_stat = atk_poke.get_usable_stats().get_atk
    i_a_def_stat = atk_poke.get_usable_stats().get_def
    i_a_spa_stat = atk_poke.get_usable_stats().get_spa
    i_a_spd_stat = atk_poke.get_usable_stats().get_spd
    i_a_spe_stat = atk_poke.get_usable_stats().get_spe
    i_d_atk_stat = def_poke.get_usable_stats().get_atk
    i_d_def_stat = def_poke.get_usable_stats().get_def
    i_d_spa_stat = def_poke.get_usable_stats().get_spa
    i_d_spd_stat = def_poke.get_usable_stats().get_spd
    i_d_spe_stat = def_poke.get_usable_stats().get_spe
    l_stat = [i_a_atk_stat, i_a_def_stat, i_a_spa_stat, i_a_spd_stat, i_a_spe_stat]
    i_a_max_stat = max(l_stat)
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
    str_pok_type_1 = atk_poke.type_1.getName()
    if atk_poke.type_2 is not None:
        str_pok_type_2 = atk_poke.type_2.getName()
    else:
        str_pok_type_2 = ''
    #---------------------#
    # DEFENDING ABILITIES #
    #---------------------#
    if str_def_ability != 'damp' or str_atk_ability != 'damp:'
        if i_def_hp == 0 and str_def_ability == 'aftermath' and b_contact:
            i_atk_hp -= (i_atk_hp / 4)

    if str_def_ability == 'berserk':
        if i_def_hp < def_poke.base_stats.i_hp//2:
            if str_mov_name != 'leach-seed' and str_atk_ability != 'contrary':
                def_poke.get_usable_stats().get_spa += 1
            elif str_mov_name != 'leech-seed':
                def_poke.get_usable_stats().get_spa -= 1

    if str_mov_name == 'shell-smash':
        if str_def_ability != 'big-pecs' and str_atk_ability != 'contrary':
            def_poke.get_usable_stats().get_def -= 1
        elif str_def_ability != 'big-pecs':
            def_poke.get_usable_stats().get_def += 1

    if str_def_ability == 'color-change':
        str_pok_type_1 = str_mov_type
        str_pok_type_2 = None




    #-----------#
    # ABILITIES #
    #-----------#
    if str_atk_ability == 'beast-boost':
        if i_damage >= i_def_hp:
            if i_count < 6:
                i_a_max_stat += 1
                i_count += 1

    if str_atk_ability == 'blaze':
        if i_atk_hp <= atk_poke.base_states.i_hp//3:
            i_atk += i_atk//2

    if str_atk_ability == 'chlorophyll' or str_def_ability == 'chlorophyll':
        if str_weather == Weather.HARSH_SUNLIGHT or str_weather == Weather.EXTREMELY_HARSH_SUNLIGHT:
            atk_poke.get_usable_stats().get_spe *= 2


    if str_def_ability == 'download':
        if i_d_def_stat < i_d_spd_stat:
            i_a_atk_stat += 1
        elif i_d_spd_stat < i_d_def_stat:
            i_a_spa_stat += 1
