
from random import randint
from FieldClass import Field

def move_ad_hoc_during(atk_poke, def_poke, move, field, b_last = False, atk_player = None, def_player = None):

    if move.str_name == "protect":
        if randint(0, 99) < 1/(3**atk_poke.i_protect_counter)*100:
            atk_poke.b_protected = True
            atk_poke.i_protect_counter += 1
        else:
            atk_poke.i_protect_counter = 0
            return False
    elif move.str_name == "stealth-rock":
        field.add_entry_hazard(def_player,"stealth-rock")
    elif move.str_name == "spikes":
        field.add_entry_hazard(def_player,"spikes")
    elif move.str_name == "sticky-web":
        field.add_entry_hazard(def_player,"sticky-web")
    elif move.str_name == "toxic-spikes":
        field.add_entry_hazard(def_player,"toxic-spikes")

    return True

def move_ad_hoc_being_attacked(atk_poke, def_poke, move, field, b_last = False, atk_player = None, def_player = None):

    if def_poke.b_protected:
        return True

    return False

def move_ad_hoc_after_turn(atk_poke, def_poke, field, atk_player = None, def_player = None):

    atk_poke.b_protected = False

    return

