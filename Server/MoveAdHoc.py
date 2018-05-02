
from random import randint, choice
from FieldClass import Field
from Constants import *
from TypeClass import Type
import json

def move_ad_hoc_during(atk_poke, def_poke, move, field, atk_player = None, def_player = None, b_last = False):

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
    elif move.str_name in ["roar", "whirlwind"]:
        if len(def_player.get_available_pokes()):
            def_player.i_active_poke_idx = choice(def_player.get_available_pokes())
            def_player.active_poke = def_player.team[def_player.i_active_poke_idx]
            def_player.b_active_poke_is_new = True
        else:
            return False
    elif move.str_name in ["baton-pass", "parting-shot", "u-turn", "volt-switch"]:
        if len(atk_player.get_available_pokes()):
            atk_player.send_data(SELECT_POKE + json.dumps({"availpoke": atk_player.get_available_pokes()}))
            atk_player.i_turn_readiness = NOT_READY
            atk_player.i_active_move_idx = -1
        else:
            return False
    elif move.str_name == "aromatherapy":
        for poke in atk_player.team:
            poke.str_status = 'none'
    elif move.str_name == "baneful-bunker":
        atk_poke.b_baneful_bunker = True
        atk_poke.b_protected = True
    elif move.str_name in ["block"]:
        def_poke.b_trapped = True
    elif move.str_name in ["camouflage"]:
        atk_poke.type2 = None
        if field.terrain == Terrain.NO:
            atk_poke.type1 = Type("normal")
        elif field.terrain == Terrain.ELECTRIC:
            atk_poke.type1 = Type("electric")
        elif field.terrain == Terrain.GRASSY:
            atk_poke.type1 = Type("grassy")
        elif field.terrain == Terrain.MISTY:
            atk_poke.type1 = Type("misty")
        elif field.terrain == Terrain.PSYCHIC:
            atk_poke.type1 = Type("psychic")
    elif move.str_name in ["conversion"]:
        atk_poke.type2 = None
        atk_poke.type1 = choice(atk_poke.l_moves).type

    return True

def move_ad_hoc_being_attacked(atk_poke, def_poke, move, field, atk_player = None, def_player = None, b_last = False):

    if def_poke.b_protected:
        return True

    return False

def move_ad_hoc_after_turn(atk_poke, def_poke, field, atk_player = None, def_player = None):

    atk_poke.b_protected = False

    return

