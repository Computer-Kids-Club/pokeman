## -------------------------------------- ##
## Field Class
## contains just the class
## -------------------------------------- ##

from Constants import *

class Field(object):
    def __init__(self, player=None, other_player=None):
        self.weather = Weather.CLEAR_SKIES
        self.terrain = Terrain.NO
        self.dic_entry_hazards = {}
        self.dic_entry_hazards[player] = []
        self.dic_entry_hazards[other_player] = []

    def get_weather(self):
        return self.weather

    def get_terrain(self):
        return self.terrain

    def get_entry_hazards(self, player):
        return self.dic_entry_hazards[player]

    def remove_entry_hazards(self, player):
        self.dic_entry_hazards[player] = []

    def count_entry_hazards(self, player, str_hazard):
        return self.dic_entry_hazards[player].count(str_hazard)

    def add_entry_hazard(self, player, str_hazard):
        self.dic_entry_hazards[player].append(str_hazard)

    def to_dic(self, player, other_player):
        move_dic = {}

        move_dic["weather"] = self.weather
        move_dic["terrain"] = self.terrain

        move_dic["mehazards"] = self.dic_entry_hazards[player]
        move_dic["otherhazards"] = self.dic_entry_hazards[other_player]

        return move_dic

    # overriding str method
    def __str__(self):
        return self.weather
