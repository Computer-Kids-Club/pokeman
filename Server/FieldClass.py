## -------------------------------------- ##
## Field Class
## contains just the class
## -------------------------------------- ##

from Constants import *

class Field(object):
    def __init__(self):
        self.weather = Weather.CLEAR_SKIES
        self.terrain = Terrain.NO
        self.entry_hazards = [[],[]]

    def get_weather(self):
        return self.weather

    def get_terrain(self):
        return self.terrain

    def get_entry_hazards(self, idx):
        return self.entry_hazards[idx]

    # overriding str method
    def __str__(self):
        return self.weather
