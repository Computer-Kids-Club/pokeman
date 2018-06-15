## -------------------------------------- ##
## Damage Calculations
## calculates the damage
## -------------------------------------- ##

from FieldClass import Field
from TypeClass import Type
from PokemanClass import Pokeman
from MoveClass import Move
from Constants import *
from random import randint
str_prv_mov = ''
i_disguise_cnt = 1
b_flash_fire = False

def confusion_attack(def_poke):

    confusion_move = Move()
    confusion_move.i_pow = 40
    confusion_move.str_type = "confusion"

    i_dmg = attack(def_poke, def_poke, confusion_move, Field())

    return i_dmg

def attack(atk_poke, def_poke, move, field, b_last = False, atk_player = None, def_player = None):
    #-------------------------#
    # VARAIBLE INITIALIZATION #
    #-------------------------#
    global str_prv_mov
    global i_disguise_cnt
    global b_flash_fire
    i_lvl = atk_poke.i_lv
    i_pow = move.i_pow
    i_crit = 1
    i_rand = randint(85, 100) / 100
    i_stab = 1
    i_atk_buff = 1
    i_def_buff = 1
    i_weather = 1
    i_terrain = 1
    str_mov_name = move.str_name
    str_status = atk_poke.str_status
    i_other = 1
    i_move_buff = 1
    i_burn = 1
    b_contact = move.flag_contact
    b_ballistic = move.flag_ballistics
    b_sound = move.flag_sound
    b_punch = move.flag_punch
    b_pulse = move.flag_pulse
    b_bite = move.flag_bite
    b_stat_change = move.b_stat_change
    b_status = move.b_status_effect
    b_stat_change = move.b_stat_change
    i_recoil = move.get_recoil_ratio()
    i_atk_hp = atk_poke.get_usable_stats().get_hp()
    i_def_atk = def_poke.get_usable_stats().get_atk()
    i_def_hp = def_poke.get_usable_stats().get_hp()
    i_atk_hp = atk_poke.get_usable_stats().get_hp()
    i_atk_spa = atk_poke.get_usable_stats().get_spa()
    i_def_spa = def_poke.get_usable_stats().get_spa()
<<<<<<< HEAD
=======
    i_def_spd = def_poke.get_usable_stats().get_spd()
    i_atk_spe = atk_poke.get_usable_stats().get_spe()
    i_atk_def = atk_poke.get_usable_stats().get_def()
    i_atk_atk = atk_poke.get_usable_stats().get_atk()
    i_def_def = def_poke.get_usable_stats().get_def()
    i_atk_spd = atk_poke.get_usable_stats().get_spd()
>>>>>>> 67a58398c8bf30ffb3433e5db1b756c153c450af
    str_atk_gen = poke1.str_gender
    str_def_gen = poke2.str_gender
    str_atk_ability = atk_poke.str_ability
    str_def_ability = def_poke.str_ability
    str_weather = field.get_weather()
    str_terrain = field.get_terrain()
    l_status = ['sleep','poisoned', 'paralyzed']
    l_atk_low_mov = ['aurora-beam', 'baby-doll-eyes', 'charm', 'feather-dance', 'growl', 'lunge', 'memento', 'nobal-roar', 'parting-shot', 'play-nice', 'play-rough', 'secret-power', 'strength-sap', 'tearful-look', 'tickle', 'trop-kick', 'venom-drench']
    l_def_low_mov = ['acid', 'crunch', 'crush-claw', 'fire-lash', 'iron-tail', 'leer', 'liquidation', 'razor-shell', 'rock-smash', 'screech', 'secret-power', 'shadow-bone', 'shadow-down', 'tail-whip', 'tickle']
    l_spa_low_mov = ['captive', 'confide', 'eerie-impulse', 'memento', 'mist-ball', 'moonblast', 'mystical-fire', 'parting-shoot', 'snarl', 'struggle-bug']
    l_spd_low_mov = ['acid-spray', 'bug-buzz', 'earth-power', 'energy-ball', 'fake-tears', 'flash-cannon', 'focus-blast', 'luster-purge', 'metal-sound', 'psychic', 'seed-flare', 'shadow-ball']
    l_spe_low_mov = ['bubble', 'bubble-beam', 'bulldoze', 'constrict', 'cotton-spore', 'electroweb', 'glaciate', 'icy-wind', 'low-sweep', 'mud-shot', 'rock-tomb', 'scary-face', 'secret-power', 'sticky-web', 'string-shot', 'toxic-thread']
    str_pok_type_1 = atk_poke.type_1.getName()
    if atk_poke.type_2 is not None:
        str_pok_type_2 = atk_poke.type_2.getName()
    else:
        str_pok_type_2 = ''
    str_mov_type = move.type.getName()
    print(str_mov_type)

    #-----------#
    # STAB BUFF #
    #-----------#
    if (str_pok_type_1 == str_mov_type) or (str_pok_type_2 == str_mov_type):
        i_stab = 1.5

    if i_stab > 1:
        if str_atk_ability == "adaptability":
            i_stab = 2

    if str_mov_type == 'normal':
        if str_atk_ability == 'aerilate' or str_atk_ability == 'pixilate' or str_atk_ability == 'refrigerate' or str_atk_ability == 'galvanize':
            i_atk_buff = 1.2

    i_goal = randint(1, 16)
    if i_goal == 1:
        i_crit = 1.5

    if i_crit == 1.5:
        if str_atk_ability == 'sniper':
            i_crit = i_crit*1.5

    i_type = move.type.getAtkEff(def_poke.type_1, def_poke.type_2)
    print('type multiplier', i_type)

    #---------------#
    # WEATHER BUFFS #
    #---------------#
    if (str_def_ability or str_atk_ability) == 'delta-stream':
        str_weather = Weather.MYSTERIOUS_AIR_CURRENT

    if (str_def_ability or str_atk_ability) == 'desolate-land':
        str_weather = Weather.HARSH_SUNLIGHT

    if str_atk_ability != 'air-lock' or str_atk_ability != 'cloud-nine' or str_def_ability != 'air-lock' or str_def_ability != 'cloud-nine':
        if str_weather == Weather.HARSH_SUNLIGHT and str_mov_type == 'fire':
            i_weather = 1.5
        elif str_weather == Weather.RAIN and str_mov_type == 'water':
            i_weather = 1.5
        elif str_weather == Weather.HARSH_SUNLIGHT and str_mov_type == 'water':
            i_weather = 0.5
        elif str_weather == Weather.RAIN and str_mov_type == 'fire':
            i_weather = 0.5
        elif str_weather == Weather.EXTREMELY_HARSH_SUNLIGHT and str_mov_type == 'water':
            i_weather = 0
        elif str_weather == Weather.HEAVY_RAIN and str_mov_type == 'fire':
            i_weather = 0
        elif str_weather == Weather.EXTREMELY_HARSH_SUNLIGHT and str_mov_type == 'fire':
            i_weather = 1.5
        elif str_weather == Weather.HEAVY_RAIN and str_mov_type == 'water':
            i_weather = 1.5
        elif str_weather == Weather.MYSTERIOUS_AIR_CURRENT and str_pok_type_2 == 'flying' and i_type > 1:
            i_type = 1

    if str_weather == Weather.HARSH_SUNLIGHT:
        if str_def_ability == 'dry-skin':
            i_def_hp -= (1/8)*def_poke.base_stats.i_hp
        elif str_atk_ability == 'dry-skin':
            i_atk_hp -= (1/8)*atk_poke.base_stats.i_hp
    # --------------#
    # TERRAIN BUFFS #
    # --------------#
    if str_terrain == Terrain.GRASSY and str_mov_type == 'grass':
        i_terrain = 1.5
    elif str_terrain == Terrain.MISTY and str_mov_type == 'fairy':
        i_terrain = 1.5
    elif str_terrain == Terrain.ELECTRIC and str_mov_type == 'electric':
        i_terrain = 1.5
    elif str_terrain == Terrain.PSYCHIC and str_mov_type == 'psychic':
        i_terrain = 1.5

    if (str_mov_name == 'Bulldoze' or str_mov_name == 'Earthquake' or str_mov_name == 'Magnitude') and str_terrain == 'grassy':
        i_terrain = 0.5

    #---------------#
    # MOVE CATEGORY #
    #---------------#
    print(move.str_cat)
    if move.str_cat == 'physical':
        i_atk = atk_poke.get_usable_stats().get_atk()
        i_def = def_poke.get_usable_stats().get_def()
        if str_status == 'burn':
            i_burn = 0.5
            if str_atk_ability == 'guts' or str_mov_name == 'facade':
                i_burn = 1.5
    elif move.str_cat == 'special':
        i_atk = atk_poke.get_usable_stats().get_spa()
        i_def = def_poke.get_usable_stats().get_spd()
    else:
        i_atk = 0
        i_def = 7
        i_other = 0

    #------------#
    # MOVE BUFFS #
    #------------#
    if str_prv_mov == 'minimize':
        if str_mov_name == 'body-slam' or str_mov_name == 'dragon-rush' or str_mov_name == 'flying-press' or str_mov_name == 'heat-crash' or str_mov_name == 'heavy-slam' or str_mov_name == 'phantom-force' or str_mov_name == 'shadow-force' or str_mov_name == 'stomp':
            i_move_buff = 2

    if str_prv_mov == 'dig':
        if str_mov_name == 'earthquake' or str_mov_name == 'magnitude':
            i_move_buff = 2

    if str_prv_mov == 'dive':
        if str_mov_name == 'surf' or str_mov_name == 'whirlpool':
            i_move_buff = 2

    #-------------------#
    # GENERAL ABILITIES #
    #-------------------#
    if str_atk_ability == 'dark-aura' or str_def_ability == 'dark-aura':
        i_pow *= 1.33

    if str_status == 'sleep':
        if str_atk_ability == 'early-bird':
            atk_poke.i_sleep_counter = 1

    if def_poke.str_status == 'sleep':
        if str_def_ability == 'early-bird':
            def_poke.i_sleep_counter = 1

    #--------------------#
    # ATTACKING ABILITIES #
    #--------------------#
    if str_atk_ability == 'water-bubble':
        if str_mov_type == 'water':
            i_atk_buff = 2

    if str_atk_ability == 'flare-boost':
        if str_status == 'burn':
            if move.str_cat == 'special':
                i_atk_buff = 1.5

    if str_atk_ability == 'iron-fist':
        if b_punch:
            i_atk_buff = 1.2

    if str_atk_ability == 'mega-launcher':
        if b_pulse:
            i_atk_buff = 1.5

    if str_atk_ability == 'normalize':
        str_mov_type = 'normal'
        i_atk_buff = 1.2

    if str_atk_ability == 'reckless':
        if str_mov_name in ["jump-kick", "high-jump-kick"] or i_recoil > 0:
            i_atk_buff = 1.2

    if str_atk_ability == 'rivalry':
        if str_def_gen != 'unspecified' or str_atk_gen != 'unspecified':
            if str_atk_gen == str_def_gen:
                i_atk_buff = 1.25
            else:
                i_atk_buff = 0.75

    if str_atk_ability == 'sand-force':
        if str_weather == Weather.SANDSTORM:
            i_atk_buff = 1.3

    if str_atk_ability == 'sheer-force':
        if b_stat_change or b_status:
            i_atk_buff = 1.3

    if str_atk_ability == 'tough-claws':
        if b_contact and str_def_ability != 'long-reach':
            i_atk_buff = 1.3

    if str_atk_ability == 'steelworker':
        if str_mov_type == 'steel':
            i_atk_buff = 1.5

    if b_bite:
        i_atk_buff = 1.5

    if str_atk_ability == 'technition':
        if i_pow <= 60:
            i_pow *= 1.5

    if str_status == 'poisoned':
        if move.str_cat == 'physical':
            i_atk_buff = 1.5

    if str_atk_ability == 'electric-surge':
        i_terrain = 1.5
<<<<<<< HEAD
=======

    if str_atk_ability == 'full-metal-body':
            if atk_poke.modifier_stats.i_atk < 0 or atk_poke.modifier_stats.i_def < 0 or atk_poke.modifier_stats.i_spe < 0 or atk_poke.modifier_stats.i_spa < 0 or atk_poke.modifier_stats.i_spd < 0 or atk_poke.modifier_stats.i_hp < 0:
                atk_poke.modifier_stats.i_atk = 0
                atk_poke.modifier_stats.i_def = 0
                atk_poke.modifier_stats.i_spe = 0
                atk_poke.modifier_stats.i_spa = 0
                atk_poke.modifier_stats.i_spd = 0
                atk_poke.modifier_stats.i_hp = 0

    if str_atk_ability == 'gale-wings':
        if str_mov_type == 'flying':
            move.i_priority += 1

    if str_atk_ability == 'huge-power':
        i_atk *= 2

    if str_atk_ability == 'hustle':
        i_atk *= 1.5

    if str_atk_ability == 'liquid-voice':
        if b_sound:
            str_mov_type = 'water'
>>>>>>> 67a58398c8bf30ffb3433e5db1b756c153c450af
    #---------------------#
    # DEFENDING ABILITIES #
    #---------------------#
    if str_def_ability == 'water-bubble':
        if str_mov_type == 'fire':
            i_def_buff = 0.5

    if str_def_ability == 'aroma-veil':
        if str_atk_ability != 'mold-breaker' or str_atk_ability == 'turboblaze' or str_atk_ability == 'teravolt':
            if str_mov_name == 'taunt' or str_mov_name == 'torment' or str_mov_name == 'encore' or str_mov_name == 'disable' or str_mov_name == 'cursed-body' or str_mov_name == 'heal-block' or str_mov_name == 'infatuation':
                i_def_buff == 0

    if str_def_ability == 'fluffy' and b_contact and str_atk_ability != 'long-reach':
        if str_mov_type == 'fire':
            i_def_buff = 1
        else:
            i_def_buff = 0.5
    elif str_def_ability == 'fluffy' and b_contact == False:
        if str_mov_type == 'fire':
            i_def_buff = 2
        else:
            i_def_buff = 1
    if i_type > 1:
        if str_def_ability == 'filter' or str_def_ability == 'prism-armor' or str_def_ability =='solid-rock':
            i_def_buff = 0.75

    if i_def_hp == def_poke.base_stats.i_hp:
        if str_def_ability == 'multiscale' or str_def_ability == 'shadow-shield':
            i_def_buff = 0.5
    if str_atk_ability == 'tinted-lens':
        if i_type < 1:
            i_type = i_type*2

    if str_def_ability == 'dry-skin':
        if str_mov_type == 'water':
            i_def_buff = 0
        elif str_mov_type == 'fire':
            i_def_buff = 1.25

    if str_def_ability == 'fur-coat':
        if move.str_cat == 'physical':
            i_def_buff = 0.5

    if str_def_ability == 'heatproof':
        if str_mov_type == 'fire':
            i_def_buff = 0.5

    if str_def_ability == 'levitate':
        if str_mov_type == 'ground':
            i_def_buff = 0

    if str_def_ability == 'lightningrod' and str_def_ability == 'motor-drive' and str_def_ability == 'volt-absorb':
        if str_mov_type == 'electric':
            i_def_buff = 0

    if str_def_ability == 'sap-sipper':
        if str_mov_type == 'grass':
            i_def_buff = 0

    if str_def_ability == 'soundproof':
        if b_sound:
            i_def_buff = 0

    if str_def_ability == 'storm-drain' and str_def_ability == 'water-absorb':
        if str_mov_type == 'water':
            i_def_buff = 0

    if str_def_ability == 'thick-fat':
        if str_mov_type == 'ice' or str_mov_type == 'fire':
            i_def_buff = 0.5

    if str_def_ability == 'water-bubble':
        if str_mov_type == 'fire':
            i_def_buff = 0.5

    if str_def_ability == 'wonder-guard':
        if i_type < 2:
            i_def_buff = 0

    if b_ballistic:
        if str_def_ability == 'bulletproof':
            i_def_buff = 0

    if str_def_ability == 'anger-point':
        if i_crit > 1:
            i_def_atk += 6

    if str_atk_ability == 'aura-break' or str_def_ability == 'aura-break':
        if str_mov_type == 'fairy' or str_mov_type == 'dark':
            i_pow //= 1.33
    elif str_atk_ability == 'fairy-aura' and str_def_ability == 'aura-break':
        if str_mov_type == 'fairy':
            i_pow //= 1.25

    if str_def_ability == 'battle-armor':
        i_crit = 1

    if str_def_ability == 'comatose':
        i_burn = 1

    if str_def_ability == 'competitive':
<<<<<<< HEAD
        if move.users_stat_changes.i_atk < 0 or move.users_stat_changes.i_hp < 0 or move.users_stat_changes.i_spe < 0 or move.users_stat_changes.i_spa < 0 or move.users_stat_changes.i_spd < 0 and str_atk_ability != 'contrary':
            i_atk_spa += 2
        elif move.users_stat_changes.i_atk < 0 or move.users_stat_changes.i_hp < 0 or move.users_stat_changes.i_spe < 0 or move.users_stat_changes.i_spa < 0 or move.users_stat_changes.i_spd < 0 and str_atk_ability == 'contrary':
=======
        if def_poke.modifier_stats.i_atk < 0  or def_poke.modifier_stats.i_spe < 0 or def_poke.modifier_stats.i_spa < 0 or def_poke.modifier_stats.i_spd < 0 and str_atk_ability != 'contrary':
            i_atk_spa += 2
        elif def_poke.modifier_stats.i_atk < 0 or def_poke.modifier_stats.i_spe < 0 or def_poke.modifier_stats.i_spa < 0 or def_poke.modifier_stats.i_spd < 0 and str_atk_ability == 'contrary':
>>>>>>> 67a58398c8bf30ffb3433e5db1b756c153c450af
            i_atk_spa -= 2

    if str_def_ability == 'dazzling':
        if move.i_priority > 0:
            i_pow = 0

    if str_def_ability == 'defeatist':
        if i_def_hp < def_poke.base_stats.i_hp//2:
            i_def_atk /= 2
            i_def_spa /= 2

    if str_def_ability == 'defiant':
        if move.users_stat_changes < 0:
            i_def_atk += 2

    if str_def_ability == 'disguise':
        if i_disguise_cnt == 1:
            i_pow = 0
            i_disguise_cnt = 0

    if str_def_ability == 'effect-spore':
        if b_contact and str_atk_ability != 'long-reach':
            if randint(1, 10) == (1 or 2 or 3):
                str_status = l_status[randint(1, 3)]

    if str_def_ability == 'filter':
        if i_type == 2 or i_type == 4:
            i_type //= 1.25

    if str_def_ability == 'flame-body':
        if randint(1, 10) == (1 or 2 or 3):
            str_status = 'burned'

    if str_def_ability == 'flash-fire' and not b_flash_fire and str_mov_type == 'fire':
        b_flash_fire = True

<<<<<<< HEAD
    if str_def_ablity == 'wimp-out':
        def_poke.base_stats.i_hp 
    if str_def_ability == 'white-smoke':
        if str_atk_ability != ('mold-breaker' or 'turboblaze' or 'teravolt'):
            if 0>(move.users_stat_changes.i_atk or move.users_stat_changes.i_def or move.users_stat_changes.i_spa or move.users_stat_changes.i_spd or move.users_stat_changes.i_spe)   
                if str_mov_name!='shell-smash':
                    move.users_stat_changes.t_atk=0
                    move.users_stat_changes.t_def=0
                    move.users_stat_changes.t_spa=0
                    move.users_stat_changes.t_spd=0
                    move.users_stat_changes.t_spe=0
    if str_def_ability == 'weak-armor':
        if move.users_stat_changes.t_hp<0:
            i_def_def-=1
            i_def_spe+=2
    if str_def_ability == 'water-veil':
        if str_def_status=='burn':
            i_burn=0
            str_def_status='none'
    if str_mov_type=='water':
        i_def_def+=2
        
            
                
           
        
    
        

=======
    if str_def_ability == 'wonder-guard':
        atk_poke.i_accuracy /= 2

    if b_flash_fire:
        if str_atk_ability == 'flash-fire':
            if str_mov_type == 'fire':
                i_pow *= 1.5

    if str_def_ability == 'flower-veil':
        if str_pok_type_2 == 'grass':
            if def_poke.modifier_stats.i_atk < 0 or def_poke.modifier_stats.i_def < 0 or def_poke.modifier_stats.i_spe < 0 or def_poke.modifier_stats.i_spa < 0 or def_poke.modifier_stats.i_spd < 0 or def_poke.modifier_stats.i_hp < 0:
                def_poke.modifier_stats.i_atk *= -1
                def_poke.modifier_stats.i_def *= -1
                def_poke.modifier_stats.i_spe *= -1
                def_poke.modifier_stats.i_spa *= -1
                def_poke.modifier_stats.i_spd *= -1
                def_poke.modifier_stats.i_hp *= -1

    if str_def_ability == 'full-metal-body':
            if def_poke.modifier_stats.i_atk < 0 or def_poke.modifier_stats.i_def < 0 or def_poke.modifier_stats.i_spe < 0 or def_poke.modifier_stats.i_spa < 0 or def_poke.modifier_stats.i_spd < 0 or def_poke.modifier_stats.i_hp < 0:
                def_poke.modifier_stats.i_atk = 0
                def_poke.modifier_stats.i_def = 0
                def_poke.modifier_stats.i_spe = 0
                def_poke.modifier_stats.i_spa = 0
                def_poke.modifier_stats.i_spd = 0
                def_poke.modifier_stats.i_hp = 0

    if str_def_ability == 'fur-coat':
        i_def *= 2

    if str_def_ability == 'gooey':
        if b_contact and str_atk_ability != 'long-reach':
            i_atk_spe -= 1
>>>>>>> 67a58398c8bf30ffb3433e5db1b756c153c450af



<<<<<<< HEAD

=======
    if str_def_ability == 'iron-barbs':
        if b_contact and str_atk_ability != 'long-reach':
            i_atk_hp -= int(atk_poke.base_stats.i_hp / 8)
>>>>>>> 67a58398c8bf30ffb3433e5db1b756c153c450af

    if str_def_ability == 'magic-bounce':
        if str_mov_name == 'shell-smash':
            if move.users_stat_changes.i_def < 0:
                i_atk_def -= move.users_stat_changes.i_def
                move.users_stat_changes.i_def = 0
            if move.users_stat_changes.i_spd < 0:
                i_atk_spd -= move.users_stat_changes.i_spd

    #--------------------#
    # CALCULATING DAMAGE #
    #--------------------#
    i_other = i_other * i_def_buff * i_move_buff * i_atk_buff
    print(i_crit , i_stab , i_type , i_rand , i_weather , i_terrain , i_other , i_burn)
    i_mod = i_crit * i_stab * i_type * i_rand * i_weather * i_terrain * i_other * i_burn
    i_damage = int(int(int(int(int(int(int(2 * i_lvl) / 5) + 2) * i_pow * (i_atk / i_def)) / 50) + 2) * i_mod)
    str_prv_mov = str_mov_name
<<<<<<< HEAD
=======

    if str_def_ability == 'ice-body':
        if str_weather == Weather.HAIL:
            i_def_hp += int(def_poke.get_usable_stats().get_hp() / 16)

    if str_def_ability == 'innards-out':
        if i_def_hp < i_damage:
            i_atk_hp -= i_def_hp

    if i_damage > 0:
        if str_mov_type == 'dark':
            i_def_atk += 1

>>>>>>> 67a58398c8bf30ffb3433e5db1b756c153c450af
    return i_damage

poke1 = Pokeman()
poke1.base_stats.i_atk = 212
poke1.base_stats.i_def = 236
poke1.base_stats.i_hp = 341
poke1.base_stats.i_spa = 236
poke1.base_stats.i_spd = 236
poke1.base_stats.i_spe = 259
poke1.usable_stats = poke1.base_stats
poke1.type_1 = Type("psychic")
poke1.type_2 = None
poke1.str_ability = "contrary"
#poke1.str_status = 'burn'

poke2 = Pokeman()
poke2.base_stats.i_atk = 212
poke2.base_stats.i_def = 236
poke2.base_stats.i_hp = 341
poke2.base_stats.i_spa = 236
poke2.base_stats.i_spd = 236
poke2.base_stats.i_spe = 259
poke2.usable_stats = poke2.base_stats
poke2.type_1 = Type("psychic")
poke2.type_2 = None
poke2.str_ability = "competitive"
move = Move("feather-dance")

field = Field()
#field.terrain = Terrain.ELECTRIC

print(attack(poke1, poke2, move, field))
print(str_prv_mov)

#move = Move("surf")
#print(attack(poke2, poke1, move, field))
#print(str_prv_mov)
