## -------------------------------------- ##
## Stat Class
## contains just the class
## -------------------------------------- ##

def get_stat_stage_changes(i_stage):

    if i_stage == -6:
        return 2/8
    if i_stage == -5:
        return 2/7
    if i_stage == -4:
        return 2/6
    if i_stage == -3:
        return 2/5
    if i_stage == -2:
        return 2/4
    if i_stage == -1:
        return 2/3
    if i_stage == 0:
        return 2/2
    if i_stage == 1:
        return 3/2
    if i_stage == 2:
        return 4/2
    if i_stage == 3:
        return 5/2
    if i_stage == 4:
        return 6/2
    if i_stage == 5:
        return 7/2
    if i_stage == 6:
        return 8/2

class Stats(object):
    def __init__(self, i_hp=0, i_atk=0, i_def=0, i_spa=0, i_spd=0, i_spe=0):
        self.i_hp = i_hp
        self.i_atk = i_atk
        self.i_def = i_def
        self.i_spa = i_spa
        self.i_spd = i_spd
        self.i_spe = i_spe

    def __str__(self):
        return str(self.i_hp) + " " + str(self.i_atk) + " " + str(self.i_def) + " " + str(self.i_spa) + " " + str(self.i_spd) + " " + str(self.i_spe)

    def to_dic(self, dic_poke, str_prefix=""):
        dic_poke[str_prefix+"hp"] = self.i_hp
        dic_poke[str_prefix+"atk"] = self.i_atk
        dic_poke[str_prefix+"def"] = self.i_def
        dic_poke[str_prefix+"spa"] = self.i_spa
        dic_poke[str_prefix+"spd"] = self.i_spd
        dic_poke[str_prefix+"spe"] = self.i_spe
        return dic_poke

    def get_modifier_rates(self):
        return Stats(get_stat_stage_changes(self.i_hp),get_stat_stage_changes(self.i_atk),get_stat_stage_changes(self.i_def),
                     get_stat_stage_changes(self.i_spa),get_stat_stage_changes(self.i_spd),get_stat_stage_changes(self.i_spe))

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

    def get_copy(self):
        return Stats(self.i_hp, self.i_atk, self.i_def, self.i_spa, self.i_spd, self.i_spe)

    def limit(self, i_lower=-6, i_upper=6):
        self.i_hp = max(i_lower,min(self.i_hp,i_upper))
        self.i_atk = max(i_lower,min(self.i_atk,i_upper))
        self.i_def = max(i_lower,min(self.i_def,i_upper))
        self.i_spa = max(i_lower,min(self.i_spa,i_upper))
        self.i_spd = max(i_lower,min(self.i_spd,i_upper))
        self.i_spe = max(i_lower,min(self.i_spe,i_upper))

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
