## -------------------------------------- ##
## Damage Calculations
## calculates the damage
## -------------------------------------- ##

from FieldClass import Field
from TypeClass import Type
from PokemanClass import Pokeman
from MoveClass import Move
from Constants import *
from random import randint
str_prv_mov = ''


def attack(atk_poke, def_poke, move, field, b_last = False, atk_player = None, def_player = None):
    global str_prv_mov
    i_lvl = atk_poke.i_lv
    i_pow = move.i_pow
    i_crit = 1
    i_rand = randint(85, 100) / 100
    i_stab = 1
    i_ability_buff = 1
    i_weather = 1
    i_terrain = 1
    str_mov_name = move.str_name
    str_status = atk_poke.str_status
    i_other = 1
    i_move_buff = 1
    i_burn = 1
    b_contact = move.flag_contact
    i_def_hp = def_poke.base_stats.i_hp
    str_atk_ability = atk_poke.str_ability
    str_def_ability = def_poke.str_ability
    str_weather = field.get_weather()
    str_terrain = field.get_terrain()
    str_pok_type_1 = atk_poke.type_1.getName()
    if atk_poke.type_2 is not None:
        str_pok_type_2 = atk_poke.type_2.getName()
    else:
        str_pok_type_2 = ''
    str_mov_type = move.type.getName()
    print(str_mov_type)
    if (str_pok_type_1 == str_mov_type) or (str_pok_type_2 == str_mov_type):
        i_stab = 1.5

    if i_stab > 1:
        if str_atk_ability == "adaptability":
            i_stab = 2

    if str_mov_type == 'normal':
        if str_atk_ability == 'aerilate' or str_atk_ability == 'pixilate' or str_atk_ability == 'refrigerate':
            i_ability_buff = 1.2

    i_goal = randint(1, 16)
    if i_goal == 1:
        i_crit = 1.5

    if i_crit == 1.5:
        if str_atk_ability == 'sniper':
            i_crit = i_crit*1.5

    i_type = move.type.getAtkEff(def_poke.type_1, def_poke.type_2)
    print('type multiplier', i_type)

    if str_weather == Weather.HARSH_SUNLIGHT and str_mov_type == 'fire':
        i_weather = 1.5
    elif str_weather == Weather.RAIN and str_mov_type == 'water':
        i_weather = 1.5
    elif str_weather == Weather.HARSH_SUNLIGHT and str_mov_type == 'water':
        i_weather = 0.5
    elif str_weather == Weather.RAIN and str_mov_type == 'fire':
        i_weather = 0.5

    if str_terrain == Terrain.GRASSY and str_mov_type == 'grass':
        i_terrain = 1.5
    elif str_terrain == Terrain.MISTY and str_mov_type == 'fairy':
        i_terrain = 1.5
    elif str_terrain == Terrain.ELECTRIC and str_mov_type == 'electric':
        i_terrain = 1.5
    elif str_terrain == Terrain.PSYCHIC and str_mov_type == 'psychic':
        i_terrain = 1.5

    if (str_mov_name == 'Bulldoze' or str_mov_name == 'Earthquake' or str_mov_name == 'Magnitude') and str_terrain == 'grassy':
        i_terrain = 0.5

    print(move.str_cat)
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

    if str_prv_mov == 'minimize':
        if str_mov_name == 'body-slam' or str_mov_name == 'dragon-rush' or str_mov_name == 'flying-press' or str_mov_name == 'heat-crash' or str_mov_name == 'heavy-slam' or str_mov_name == 'phantom-force' or str_mov_name == 'shadow-force' or str_mov_name == 'stomp':
            i_move_buff = 2

    if str_prv_mov == 'dig':
        if str_mov_name == 'earthquake' or str_mov_name == 'magnitude':
            i_move_buff = 2

    if str_prv_mov == 'dive':
        if str_mov_name == 'surf' or str_mov_name == 'whirlpool':
            i_move_buff = 2

    if str_atk_ability == 'tough-claws':
        if b_contact:
            i_ability_buff = 1.3
    if str_def_ability == 'fluffy' and b_contact:
        if str_mov_type == 'fire':
            i_ability_buff = 1
        else:
            i_ability_buff = 0.5
    elif str_def_ability == 'fluffy' and b_contact == False:
        if str_mov_type == 'fire':
            i_ability_buff = 2
        else:
            i_ability_buff = 1
    if i_type > 1:
        if str_def_ability == 'filter' or str_def_ability == 'prism-armor' or str_def_ability =='solid-rock':
            i_ability_buff = 0.75

    if i_def_hp == def_poke.get_usable_stats().get_hp():
        if str_def_ability == 'multiscale' or str_def_ability == 'shadow-shield':
            i_ability_buff = 0.5
    if str_atk_ability == 'tinted-lens':
        if i_type < 1:
            i_type = i_type*2

    i_rand = 1
    b_ballistic = move.flag_ballistics
    if b_ballistic:
        if str_def_ability == 'bulletproof':
            i_ability_buff = 0
    i_other = i_other * i_ability_buff * i_move_buff
    print(i_crit , i_stab , i_type , i_rand , i_weather , i_terrain , i_other , i_burn)
    i_mod = i_crit * i_stab * i_type * i_rand * i_weather * i_terrain * i_other * i_burn
    i_damage = int(int(int(int(int(int(int(2 * i_lvl) / 5) + 2) * i_pow * (i_atk / i_def)) / 50) + 2) * i_mod)
    str_prv_mov = str_mov_name
    return i_damage

poke1 = Pokeman()
poke1.base_stats.i_atk = 212
poke1.base_stats.i_def = 236
poke1.base_stats.i_hp = 341
poke1.base_stats.i_spa = 236
poke1.base_stats.i_spd = 236
poke1.base_stats.i_spe = 259
poke1.usable_stats = poke1.base_stats
poke1.type_1 = Type("psychic")
poke1.type_2 = None
#poke1.str_ability = "tough-claws"
#poke1.str_status = 'burn'

poke2 = Pokeman()
poke2.base_stats.i_atk = 212
poke2.base_stats.i_def = 236
poke2.base_stats.i_hp = 341
poke2.base_stats.i_spa = 236
poke2.base_stats.i_spd = 236
poke2.base_stats.i_spe = 259
poke2.usable_stats = poke2.base_stats
poke2.type_1 = Type("psychic")
poke2.type_2 = None
poke2.str_ability = "multiscale"
move = Move("dark-pulse")

field = Field()
field.terrain = Terrain.ELECTRIC

print(attack(poke1, poke2, move, field))
print(str_prv_mov)

move = Move("body-slam")
print(attack(poke2, poke1, move, field))
print(str_prv_mov)
