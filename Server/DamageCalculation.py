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


def attack(atk_poke, def_poke, move, field, atk_player=None, def_player=None):
    i_lvl = atk_poke.i_lv
    i_pow = move.i_pow
    i_crit = 1
    i_rand = randint(85, 100) / 100
    i_stab = 1
    str_pok_type_1 = atk_poke.type_1.getName()
    if atk_poke.type_2 is not None:
        str_pok_type_2 = atk_poke.type_2.getName()
    else:
        str_pok_type_2 = ''
    str_mov_type = move.type.getName()
    print(str_mov_type)
    if (str_pok_type_1 == str_mov_type) or (str_pok_type_2 == str_mov_type):
        i_stab = 1.5

    i_goal = randint(1, 16)
    if i_goal == 1:
        i_crit = 1.5

    i_type = move.type.getAtkEff(def_poke.type_1, def_poke.type_2)

    str_weather = field.get_weather()
    str_terrain = field.get_terrain()

    i_weather = 1
    if str_weather == Weather.HARSH_SUNLIGHT and str_mov_type == 'fire':
        i_weather = 1.5
    elif str_weather == Weather.RAIN and str_mov_type == 'water':
        i_weather = 1.5
    elif str_weather == Weather.HARSH_SUNLIGHT and str_mov_type == 'water':
        i_weather = 0.5
    elif str_weather == Weather.RAIN and str_mov_type == 'fire':
        i_weather = 0.5

    i_terrain = 1
    if str_terrain == Terrain.GRASSY and str_mov_type == 'grass':
        i_terrain = 1.5
    elif str_terrain == Terrain.MISTY and str_mov_type == 'fairy':
        i_terrain = 1.5
    elif str_terrain == Terrain.ELECTRIC and str_mov_type == 'electric':
        i_terrain = 1.5
    elif str_terrain == Terrain.PSYCHIC and str_mov_type == 'psychic':
        i_terrain = 1.5

    str_mov_name = move.str_name
    if str_mov_name == 'Bulldoze' or str_mov_name == 'Earthquake' or str_mov_name == 'Magnitude':
        i_terrain = 0.5

    str_status = atk_poke.str_status
    i_other = 1
    i_burn = 1
    str_ability = atk_poke.str_ability
    str_mov_name = move.str_name
    if move.str_cat == 'physical':
        i_atk = atk_poke.get_usable_stats().get_atk()
        i_def = def_poke.get_usable_stats().get_def()
        if str_status == 'burn':
            i_burn = 0.5
            if str_ability == 'guts' or str_mov_name == 'facade':
                i_burn = 1.5
    elif move.str_cat == 'special':
        i_atk = atk_poke.get_usable_stats().get_spa()
        i_def = def_poke.get_usable_stats().get_spd()
    else:
        i_atk = 0
        i_def = 7
        i_other = 0
    print(i_crit , i_stab , i_type , i_rand , i_weather , i_terrain , i_other , i_burn)
    i_mod = i_crit * i_stab * i_type * i_rand * i_weather * i_terrain * i_other * i_burn
    i_damage = int(int(int(int(int(int(int(2 * i_lvl) / 5) + 2) * i_pow * (i_atk / i_def)) / 50) + 2) * i_mod)
    return i_damage

poke1 = Pokeman()
poke1.base_stats.i_atk = 212
poke1.base_stats.i_def = 236
poke1.base_stats.i_hp = 341
poke1.base_stats.i_spa = 236
poke1.base_stats.i_spd = 236
poke1.base_stats.i_spe = 259
poke1.type_1 = Type("psychic")
poke1.str_status = 'burn'

poke2 = Pokeman()
poke2.base_stats.i_atk = 100
poke2.base_stats.i_def = 236
poke2.base_stats.i_hp = 341
poke2.base_stats.i_spa = 100
poke2.base_stats.i_spd = 236
poke2.base_stats.i_spe = 100
poke2.type_1 = Type("psychic")


move = Move("tackle")

field = Field()
field.terrain = Terrain.ELECTRIC

print(attack(poke1, poke2, move, field))
