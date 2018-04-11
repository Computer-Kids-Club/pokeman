## -------------------------------------- ##
## Stat Class
## contains just the class
## -------------------------------------- ##

class Stats(object):
    def __init__(self, i_hp=0, i_atk=0, i_def=0, i_spa=0, i_spd=0, i_spe=0):
        self.i_hp = i_hp
        self.i_atk = i_atk
        self.i_def = i_def
        self.i_spa = i_spa
        self.i_spd = i_spd
        self.i_spe = i_spe

    def to_dic(self, dic_poke, str_prefix=""):
        dic_poke[str_prefix+"hp"] = self.i_hp
        dic_poke[str_prefix+"atk"] = self.i_atk
        dic_poke[str_prefix+"def"] = self.i_def
        dic_poke[str_prefix+"spa"] = self.i_spa
        dic_poke[str_prefix+"spd"] = self.i_spd
        dic_poke[str_prefix+"spe"] = self.i_spe
        return dic_poke

    def get_hp(self):
        return self.i_hp

    def get_atk(self):
        return self.i_atk

    def get_def(self):
        return self.i_def

    def get_spa(self):
        return self.i_spa

    def get_spd(self):
        return self.i_spd

    def get_spe(self):
        return self.i_spe

    def __add__(self, other):
        return Stats( self.i_hp + other.i_hp,
                     self.i_atk + other.i_atk,
                     self.i_def + other.i_def,
                     self.i_spa + other.i_spa,
                     self.i_spd + other.i_spd,
                     self.i_spe + other.i_spe)

    def __mul__(self, other):
        return Stats( self.i_hp * other.i_hp,
                     self.i_atk * other.i_atk,
                     self.i_def * other.i_def,
                     self.i_spa * other.i_spa,
                     self.i_spd * other.i_spd,
                     self.i_spe * other.i_spe)

    def __sub__(self, other):
        return Stats( self.i_hp - other.i_hp,
                     self.i_atk - other.i_atk,
                     self.i_def - other.i_def,
                     self.i_spa - other.i_spa,
                     self.i_spd - other.i_spd,
                     self.i_spe - other.i_spe)

    def __truediv__(self, other):
        return Stats( self.i_hp / other.i_hp,
                     self.i_atk / other.i_atk,
                     self.i_def / other.i_def,
                     self.i_spa / other.i_spa,
                     self.i_spd / other.i_spd,
                     self.i_spe / other.i_spe)
