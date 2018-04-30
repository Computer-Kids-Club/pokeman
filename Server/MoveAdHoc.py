
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
        if field.count_entry_hazards(def_player, "stealth-rock") <= 0:
            field.add_entry_hazard(def_player,"stealth-rock")
        else:
            return False
    elif move.str_name == "spikes":
        if field.count_entry_hazards(def_player, "spikes") < 3:
            field.add_entry_hazard(def_player,"spikes")
        else:
            return False
    elif move.str_name == "sticky-web":
        if field.count_entry_hazards(def_player, "sticky-web") <= 0:
            field.add_entry_hazard(def_player,"sticky-web")
        else:
            return False
    elif move.str_name == "toxic-spikes":
        if field.count_entry_hazards(def_player, "toxic-spikes") < 2:
            field.add_entry_hazard(def_player,"toxic-spikes")
        else:
            return False
    elif move.str_name == "rapid-spin":
        field.remove_entry_hazards(atk_player)
    elif move.str_name == "defog":
        field.remove_entry_hazards(atk_player)
        field.remove_entry_hazards(def_player)

    return True

def move_ad_hoc_being_attacked(atk_poke, def_poke, move, field, b_last = False, atk_player = None, def_player = None):

    if def_poke.b_protected:
        return True

    return False

def move_ad_hoc_after_turn(atk_poke, def_poke, field, atk_player = None, def_player = None):

    atk_poke.b_protected = False

    return

