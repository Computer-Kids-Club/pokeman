## -------------------------------------- ##
## Pokeman Class
## contains just the class
## -------------------------------------- ##

class Move(object):
    def __init__(self):
        self.str_name = "Thunder Bolt"

    # overriding str method
    def __str__(self):
        return self.str_name
