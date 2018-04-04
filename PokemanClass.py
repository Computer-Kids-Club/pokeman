## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

class Pokeman(object):
    def __init__(self):
        self.str_name = "Pikachu"

    # overriding str method
    def __str__(self):
        return self.str_name
