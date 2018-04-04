## -------------------------------------- ##
## Field Class
## contains just the class
## -------------------------------------- ##

class Weather(object):
    CLEAR_SKIES              = 0
    HARSH_SUNLIGHT           = 1
    EXTREMELY_HARSH_SUNLIGHT = 2
    RAIN                     = 3
    HEAVY_RAIN               = 4
    SANDSTORM                = 5
    HAIL                     = 6
    MYSTERIOUS_AIR_CURRENT   = 7

class Field(object):
    def __init__(self):
        self.weather = Weather.CLEAR_SKIES

    # overriding str method
    def __str__(self):
        return self.weather
