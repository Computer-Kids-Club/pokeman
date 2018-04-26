## -------------------------------------- ##
## Other Move Calculations
## calculates everything other than the damage
## -------------------------------------- ##

from FieldClass import Field
from TypeClass import Type
from PokemanClass import Pokeman
from MoveClass import Move
from Constants import *
from random import randint

def get_acc_eva_stage_changes(i_stage):
    if i_stage == -6:
        return 3/9
    if i_stage == -5:
        return 3/8
    if i_stage == -4:
        return 3/7
    if i_stage == -3:
        return 3/6
    if i_stage == -2:
        return 3/5
    if i_stage == -1:
        return 3/4
    if i_stage == 0:
        return 3/3
    if i_stage == 1:
        return 4/3
    if i_stage == 2:
        return 5/3
    if i_stage == 3:
        return 6/3
    if i_stage == 4:
        return 7/3
    if i_stage == 5:
        return 8/3
    if i_stage == 6:
        return 9/3

def accuracy(atk_poke, def_poke, move):
    f_acc = 1

    f_acc *= move.i_acc/100

    f_poke_acc = get_acc_eva_stage_changes(atk_poke.i_accuracy)
    f_poke_eva = get_acc_eva_stage_changes(def_poke.i_evasion)

    f_acc = f_acc*f_poke_acc/f_poke_eva

    if randint(0, 99) < 100*f_acc:
        return True
    return False

MULTI_HIT_MOVES = ["arm-thrust","barrage","bone-rush","bullet-seed","comet-punch","doubleslap","fury-attack","fury-swipes","icicle-spear","pin-missile","rock-blast","spike-cannon","tail-slap"]
DOUBLE_HIT_MOVES = ["twineedle","bonemerang","double-hit","double-kick","double-chop","gear-saucer"]

def multi_hit(move):
    i_hits = 1

    if move.str_name in DOUBLE_HIT_MOVES:
        i_hits = 2
    elif move.str_name in MULTI_HIT_MOVES:
        i_hits = randint(2, 5)

    return i_hits

def status_effect(atk_poke, def_poke, move):
    str_eff = "none"

    if def_poke.str_status != "none" or not move.b_status_effect:
        return str_eff

    str_eff = move.str_status_effect
    def_poke.str_status = str_eff

    return str_eff

def stat_change(atk_poke, def_poke, move):
    str_eff = "none"

    if not move.b_stat_change:
        return str_eff

    atk_poke.modifier_stats = atk_poke.modifier_stats + move.users_stat_changes
    def_poke.modifier_stats = def_poke.modifier_stats + move.targets_stat_changes

    atk_poke.modifier_stats.limit()
    def_poke.modifier_stats.limit()

    str_eff = "some stat change"

    return str_eff


