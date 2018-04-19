## -------------------------------------- ##
## Type Class
## contains just the class
## -------------------------------------- ##

from Constants import *

l_typ_short  =  "NorFirWatEleGraIceFigPoiGroFlyPsyBugRocGhoDraDarSteFai"
mat_type_eff = [[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1, 0, 1, 1,-1, 1], # Nor
                [ 1,-1,-1, 1, 2, 2, 1, 1, 1, 1, 1, 2,-1, 1,-1, 1, 2, 1], # Fir
                [ 1, 2,-1, 1,-1, 1, 1, 1, 2, 1, 1, 1, 2, 1,-1, 1, 1, 1], # Wat
                [ 1, 1, 2,-1,-1, 1, 1, 1, 0, 2, 1, 1, 1, 1,-1, 1, 1, 1], # Ele
                [ 1,-1, 2, 1,-1, 1, 1,-1, 2,-1, 1,-1, 2, 1,-1, 1,-1, 1], # Gra
                [ 1,-1,-1, 1, 2,-1, 1, 1, 2, 2, 1, 1, 1, 1, 2, 1,-1, 1], # Ice
                [ 2, 1, 1, 1, 1, 2, 1,-1, 1,-1,-1,-1, 2, 0, 1, 2, 2,-1], # Fig
                [ 1, 1, 1, 1, 2, 1, 1,-1,-1, 1, 1, 1,-1,-1, 1, 1, 0, 2], # Poi
                [ 1, 2, 1, 2,-1, 1, 1, 2, 1, 0, 1,-1, 2, 1, 1, 1, 2, 1], # Gro
                [ 1, 1, 1,-1, 2, 1, 2, 1, 1, 1, 1, 2,-1, 1, 1, 1,-1, 1], # Fly
                [ 1, 1, 1, 1, 1, 1, 2, 2, 1, 1,-1, 1, 1, 1, 1, 0,-1, 1], # Psy
                [ 1,-1, 1, 1, 2, 1,-1,-1, 1,-1, 2, 1, 1,-1, 1, 2,-1,-1], # Bug
                [ 1, 2, 1, 1, 1, 2,-1, 1,-1, 2, 1, 2, 1, 1, 1, 1,-1, 1], # Roc
                [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1,-1, 1, 1], # Gho
                [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1,-1, 0], # Dra
                [ 1, 1, 1, 1, 1, 1,-1, 1, 1, 1, 2, 1, 1, 2, 1,-1, 1,-1], # Dar
                [ 1,-1,-1,-1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1,-1, 2], # Ste
                [ 1,-1, 1, 1, 1, 1, 2,-1, 1, 1, 1, 1, 1, 1, 2, 2,-1, 1]] # Fai


class Type(object):
    def __init__(self, name="normal"):
        self.str_name = name.lower()

    # return 0, 0.25, 0.5, 1, 2, or 4 representing the effectiveness of the attack
    def getAtkEff(self, def_type_1, def_type_2=None):
        idx_eff_1 = mat_type_eff[self.getIdx()][def_type_1.getIdx()]
        if idx_eff_1 == -1:
            idx_eff_1 = 0.5

        if def_type_2 == None:
            return idx_eff_1

        idx_eff_2 = mat_type_eff[self.getIdx()][def_type_2.getIdx()]
        if idx_eff_2 == -1:
            idx_eff_2 = 0.5

        return idx_eff_1 * idx_eff_2

    def getIdx(self):
        return l_typ_short.index(self.str_name.capitalize()[:3]) // 3

    def getName(self):
        return self.str_name

    # overriding str method
    def __str__(self):
        return self.str_name.capitalize()
