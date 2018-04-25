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

def accuracy(atk_poke, def_poke, move, field, atk_player, def_player):
    f_acc = 1

    f_acc *= move.i_acc/100

    f_poke_acc = get_acc_eva_stage_changes(atk_poke.i_accuracy)
    f_poke_eva = get_acc_eva_stage_changes(def_poke.i_evasion)

    f_acc = f_acc*f_poke_acc/f_poke_eva

    if randint(0, 99) < 100*f_acc:
        return True
    return False