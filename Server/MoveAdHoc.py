
from random import randint, choice
from FieldClass import Field
from Constants import *
from TypeClass import Type, get_atk_types_with_eff_rate, get_def_types_with_eff_rate
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
            if move.str_name == "baton-pass":
                atk_player.baton_pass_stats = atk_poke.modifier_stats.get_copy()
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
    elif move.str_name in ["conversion-2"]:
        atk_poke.type2 = None
        l_types = get_atk_types_with_eff_rate(0, atk_poke.l_last_move[-1].type)
        l_types.extend(get_atk_types_with_eff_rate(0.5, atk_poke.l_last_move[-1].type))
        atk_poke.type1 = Type(choice(l_types))
    elif move.str_name in ["curse"]:
        if atk_poke.is_type("ghost"):
            atk_poke.i_hp -= atk_poke.get_usable_stats().i_hp // 2
            def_poke.b_cursed = True
        else:
            atk_poke.modifier_stats.i_spe -= 1
            atk_poke.modifier_stats.i_atk += 1
            atk_poke.modifier_stats.i_def += 1
    elif move.str_name in ["destiny-bond"]:
        def_poke.b_destiny_bonded = True
    elif move.str_name in ["detect"]:
        atk_poke.b_protected = True
    elif move.str_name in ["disable"]:
        def_poke.get_last_move().i_disable_idx = 4
    elif move.str_name in ["doom-desire"]:
        atk_poke.i_doom_desire_idx = 2
    elif move.str_name in ["electrify"]:
        def_poke.forced_move_type = Type("electric")
    elif move.str_name in ["encore"]:
        def_poke.i_encore_idx = 3
    elif move.str_name in ["endure"]:
        atk_poke.b_endure_idx = True
    elif move.str_name in ["entrainment"]:
        def_poke.str_ability = atk_poke.str_ability
    elif move.str_name in ["flower-shield"]:
        if atk_poke.is_type("grass"):
            atk_poke.modifier_stats.i_def += 1
        if def_poke.is_type("grass"):
            def_poke.modifier_stats.i_def += 1
    elif move.str_name in ["focus-energy"]:
        atk_poke.f_critical_hit += 2
    elif move.str_name in ["forests-curse"]:
        if not def_poke.is_type("grass"):
            if def_poke.type_2 == None:
                def_poke.type_2 = Type("grass")
            else:
                def_poke.type_3 = Type("grass")
    elif move.str_name in ["gastro-acid"]:
        def_poke.str_ability = "nullified"
    elif move.str_name in ["future-sight"]:
        atk_poke.i_future_sight_idx = 2
    elif move.str_name in ["grudge"]:
        atk_poke.b_grudge = True
    elif move.str_name in ["guard-split"]:
        i_avg_def = (atk_poke.usable_stats.i_def + def_poke.usable_stats.i_def) // 2
        i_avg_spd = (atk_poke.usable_stats.i_spd + def_poke.usable_stats.i_spd) // 2
        atk_poke.usable_stats.i_def = i_avg_def
        def_poke.usable_stats.i_def = i_avg_def
        atk_poke.usable_stats.i_spd = i_avg_spd
        def_poke.usable_stats.i_spd = i_avg_spd
    elif move.str_name in ["guard-swap"]:
        atk_poke.modifier_stats.i_def, def_poke.modifier_stats.i_def = def_poke.modifier_stats.i_def, atk_poke.modifier_stats.i_def
        atk_poke.modifier_stats.i_spd, def_poke.modifier_stats.i_spd = def_poke.modifier_stats.i_spd, atk_poke.modifier_stats.i_spd
    elif move.str_name in ["heal-bell"]:
        for poke in atk_player.team:
            poke.str_status = "none"
    elif move.str_name in ["heart-swap"]:
        atk_poke.modifier_stats, def_poke.modifier_stats = def_poke.modifier_stats, atk_poke.modifier_stats
    elif move.str_name in ["instruct"]:
        def_poke.b_instruct = True
    elif move.str_name in ["kings-shield"]:
        atk_poke.b_protected = True
        atk_poke.b_kings_shield = True
    elif move.str_name in ["laser-focus"]:
        atk_poke.b_laser_focus = True
    elif move.str_name in ["lock-on"]:
        atk_poke.b_lock_on = True
    elif move.str_name in ["magic-coat"]:
        atk_poke.b_magic_coat = True
    elif move.str_name in ["magnet-rise"]:
        atk_poke.b_magnet_rise = True
    elif move.str_name in ["mean-look"]:
        atk_poke.b_trapped = True
    elif move.str_name in ["memento"]:
        atk_poke.i_hp = 0
    elif move.str_name in ["metronome"]:
        pass
    elif move.str_name in ["mimic"]:
        pass
    elif move.str_name in ["mind-reader"]:
        atk_poke.b_perfect_aim = True
    elif move.str_name in ["mirror-move"]:
        pass
    elif move.str_name in ["nature-power"]:
        pass
    elif move.str_name in ["pain-split"]:
        i_avg_hp = (atk_poke.usable_stats.i_hp + def_poke.usable_stats.i_hp) // 2
        atk_poke.usable_stats.i_hp = i_avg_hp
        def_poke.usable_stats.i_hp = i_avg_hp
    elif move.str_name in ["powder"]:
        def_poke.b_powdered = True
    elif move.str_name in ["power-split"]:
        i_avg_atk = (atk_poke.usable_stats.i_atk + def_poke.usable_stats.i_atk) // 2
        atk_poke.usable_stats.i_atk = i_avg_atk
        def_poke.usable_stats.i_atk = i_avg_atk
        i_avg_spa = (atk_poke.usable_stats.i_spa + def_poke.usable_stats.i_spa) // 2
        atk_poke.usable_stats.i_spa = i_avg_spa
        def_poke.usable_stats.i_spa = i_avg_spa
    elif move.str_name in ["power-swap"]:
        atk_poke.usable_stats.i_atk, def_poke.usable_stats.i_atk = def_poke.usable_stats.i_atk, atk_poke.usable_stats.i_atk
        atk_poke.usable_stats.i_spa, def_poke.usable_stats.i_spa = def_poke.usable_stats.i_spa, atk_poke.usable_stats.i_spa
    elif move.str_name in ["power-trick"]:
        atk_poke.usable_stats.i_atk, atk_poke.usable_stats.i_def = atk_poke.usable_stats.i_def, atk_poke.usable_stats.i_atk
        atk_poke.usable_stats.i_spa, atk_poke.usable_stats.i_spd = atk_poke.usable_stats.i_spd, atk_poke.usable_stats.i_spa
    elif move.str_name in ["psycho-shift"]:
        def_poke.str_status = atk_poke.str_status
        atk_poke.str_status = "none"
    elif move.str_name in ["psych-up"]:
        atk_poke.modifier_stats = def_poke.modifier_stats.get_copy()
    elif move.str_name in ["purify"]:
        def_poke.str_status = "none"
        atk_poke.i_hp += atk_poke.get_usable_stats().i_hp // 2
    elif move.str_name in ["reflect-type"]:
        atk_poke.type1 = def_poke.type1
        atk_poke.type2 = def_poke.type2
    elif move.str_name in ["refresh"]:
        if atk_poke.str_status in ["burn", "paralyse", "poison", "toxic"]:
            atk_poke.str_status = "none"
    elif move.str_name in ["role-play"]:
        atk_poke.str_ability = def_poke.str_ability
    elif move.str_name in ["shell-smash"]:
        atk_poke.modifier_stats.i_atk += 2
        atk_poke.modifier_stats.i_spa += 2
        atk_poke.modifier_stats.i_spe += 2
        atk_poke.modifier_stats.i_def -= 1
        atk_poke.modifier_stats.i_spd -= 1
    elif move.str_name in ["simple-beam"]:
        def_poke.str_ability = "simple"
    elif move.str_name in ["sketch"]:
        pass
    elif move.str_name in ["skill-swap"]:
        atk_poke.str_ability, def_poke.str_ability = def_poke.str_ability, atk_poke.str_ability
    elif move.str_name in ["soak"]:
        atk_poke.type1 = Type("water")
        atk_poke.type2 = None
    elif move.str_name in ["speed-swap"]:
        atk_poke.usable_stats.i_spe, def_poke.usable_stats.i_spe = def_poke.usable_stats.i_spe, atk_poke.usable_stats.i_spe
    elif move.str_name in ["spider-web"]:
        atk_poke.b_trapped = True
    elif move.str_name in ["spite"]:
        pass
    elif move.str_name in ["strength-sap"]:
        if def_poke.modifier_stats.i_atk > 0:
            atk_poke.i_hp += atk_poke.get_usable_stats().i_hp // 8 * def_poke.modifier_stats.i_atk
            def_poke.modifier_stats.i_atk -= 1
    elif move.str_name in ["topsy-turvy"]:
        def_poke.modifier_stats.i_hp *= -1
        def_poke.modifier_stats.i_atk *= -1
        def_poke.modifier_stats.i_def *= -1
        def_poke.modifier_stats.i_spa *= -1
        def_poke.modifier_stats.i_spd *= -1
        def_poke.modifier_stats.i_spe *= -1
    elif move.str_name in ["trick-or-treat"]:
        if not def_poke.is_type("ghost"):
            if def_poke.type_2 == None:
                def_poke.type_2 = Type("ghost")
            else:
                def_poke.type_3 = Type("ghost")
    elif move.str_name in ["worry-seed"]:
        def_poke.str_ability = "insomnia"

    return True

def move_ad_hoc_being_attacked(atk_poke, def_poke, move, field, atk_player = None, def_player = None, b_last = False):

    if def_poke.b_protected:
        return True

    return False

def move_ad_hoc_after_turn(atk_poke, def_poke, field, atk_player = None, def_player = None):

    atk_poke.b_protected = False

    return

