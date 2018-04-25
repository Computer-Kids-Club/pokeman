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

def accuracy(atk_poke, def_poke, move, field, atk_player, def_player):
    f_acc = 1

    if randint(0, 99) < 100*f_acc:
        return True
    return False