## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

from TypeClass import Type
from MoveClass import Move

class Pokeman(object):
    def __init__(self,num=1):
        self.i_num = num
        self.str_name = "Pikachu"

        self.b_shiny = False

        self.type_1 = Type()
        self.type_2 = None

        self.str_ability = "error"
        self.str_item = "error"

        self.moves = [Move(),Move(),Move(),Move()]





    # overriding str method
    def __str__(self):
        return self.str_name
