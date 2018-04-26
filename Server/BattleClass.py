## -------------------------------------- ##
## Battle Class
## just the class
## -------------------------------------- ##

from Constants import *
from FieldClass import Field
from random import randint
from ClientConnection import Client
from DamageCalculation import attack
from OtherMoveCalculations import accuracy, multi_hit, stat_change, status_effect
import json

# master dictionary of all the ongoing battles
l_battles = []

# client to battle
dic_battles = {}


class Battle(object):
    def __init__(self, l_new_players=[]):

        self.field = Field()

        self.l_players = l_new_players

        self.b_gameover = False

        for player in self.l_players:
            other_player = self.get_other_player(player)

            player.i_turn_readiness = NOT_READY

            player.send_data(FOUND_BATTLE)
            player.send_pokes(other_player.team)
            player.send_data(SELECT_POKE + json.dumps({"availpoke": player.get_available_pokes()}))

    def get_other_player(self, player):
        i_player_idx = self.l_players.index(player)
        return self.l_players[(i_player_idx + 1) % 2]

    def recieved_data(self, player, dic_data):

        other_player = self.get_other_player(player)

        if dic_data["battlestate"] == "pokes":
            pass
        elif dic_data["battlestate"] == "selectpoke":
            pass
        elif dic_data["battlestate"] == "selectmove":
            pass

    def everyone_ready(self):
        b_ready = True
        for player in self.l_players:
            b_ready = b_ready and player.i_turn_readiness
        return b_ready

    def send_players_pokes(self):

        for player in self.l_players:
            if player.b_active_poke_is_new:
                player.b_active_poke_is_new = False

        # send updated info to players
        for player in self.l_players:
            other_player = self.get_other_player(player)

            player.send_data(DISPLAY_POKES + json.dumps({"player": ME, "pokeidx": player.i_active_poke_idx, "poke": player.active_poke.to_dic()}))

            player.send_data(DISPLAY_POKES + json.dumps({"player": OTHER, "pokeidx": other_player.i_active_poke_idx, "poke": other_player.active_poke.to_dic()}))

    def send_delay(self):
        for player in self.l_players:
            player.send_data(DISPLAY_DELAY)

    def send_broadcast(self, str_msg):
        for player in self.l_players:
            player.send_data(DISPLAY_TEXT+str_msg)

    def send_move(self, player, move):
        other_player = self.get_other_player(player)
        player.send_data(DISPLAY_MOVE+json.dumps({"player": ME, "move": move.to_dic()}))
        other_player.send_data(DISPLAY_MOVE+json.dumps({"player": OTHER, "move": move.to_dic()}))

    def run(self):
        # Log.info("battle running")

        # print(self.l_players[0].i_turn_readiness,self.l_players[1].i_turn_readiness)

        if (not self.everyone_ready() or self.b_gameover):
            return

        self.send_players_pokes()

        # calculate damage

        l_move_queue= []

        # add moves to queue according to speed
        for player in self.l_players:
            if (player.i_active_move_idx == -1):
                continue

            if len(l_move_queue)>=1 and player.active_poke.get_usable_stats().i_spe > l_move_queue[0].active_poke.get_usable_stats().i_spe:
                l_move_queue.insert(0,player)
            else:
                l_move_queue.append(player)

        # move according to queue
        for player in l_move_queue:

            if not player.active_poke.is_usable():
                continue

            other_player = self.get_other_player(player)

            cur_move = player.active_poke.get_moves()[player.i_active_move_idx]

            print(player.active_poke, "used move", cur_move)

            # check if move hit
            b_hit = accuracy(player.active_poke, other_player.active_poke, cur_move)

            b_para_immo = False
            if player.active_poke.str_status == "paralyze":
                if randint(0,99) < 25:
                    b_para_immo = True

            if b_para_immo:

                # paralysed, can't move
                self.send_broadcast(player.active_poke.str_name.capitalize() + " is paralyzed!")
                self.send_broadcast("It can't move!")

            elif player.active_poke.str_status == "freeze":

                # frozen, can't move
                self.send_broadcast(player.active_poke.str_name.capitalize() + " is frozen solid!")

            elif b_hit:

                self.send_broadcast(player.active_poke.str_name.capitalize() + " used " + cur_move.str_name + ".")

                self.send_move(player, cur_move)

                # some moves hit more than one time
                i_hits = multi_hit(cur_move)
                for i in range(i_hits):

                    # calculate damage

                    i_dmg = attack(player.active_poke, other_player.active_poke, cur_move, self.field, player, other_player)

                    # if the move is not status, tell everyone the damage
                    if cur_move.str_cat != "status":

                        i_tmp_eff = cur_move.type.getAtkEff(other_player.active_poke.type_1, other_player.active_poke.type_2)

                        if i_tmp_eff == 0:
                            self.send_broadcast("It had no effect!")
                        elif i_tmp_eff == 0.25:
                            self.send_broadcast("It is very not very effective!")
                        elif i_tmp_eff == 0.5:
                            self.send_broadcast("It is not very effective.")
                        elif i_tmp_eff == 2:
                            self.send_broadcast("It is super effective!")
                        elif i_tmp_eff == 4:
                            self.send_broadcast("It is super super effective!")

                        # self.send_broadcast(str(other_player.active_poke.i_hp) + " - " + str(i_dmg) + " = " + str(other_player.active_poke.i_hp - i_dmg))
                        self.send_broadcast(other_player.active_poke.str_name.capitalize() + " lost " + str(i_dmg / other_player.active_poke.get_usable_stats().i_hp * 100) + "% HP.")

                    # actually take damage

                    other_player.active_poke.i_hp -= i_dmg

                    player.i_active_move_idx = -1

                    # is it dead???
                    if (other_player.active_poke.i_hp <= 0):
                        other_player.active_poke.i_hp = 0
                        other_player.active_poke.b_fainted = True
                        break

                    # send updated pokes
                    self.send_players_pokes()

                    # implement status effect

                    str_eff = status_effect(player.active_poke, other_player.active_poke, cur_move)

                    if str_eff != 'none':
                        self.send_broadcast(other_player.active_poke.str_name.capitalize() + " is " + str_eff + ".")

                    self.send_players_pokes()

                    # implement stat change

                    str_eff = stat_change(player.active_poke, other_player.active_poke, cur_move)

                    if str_eff != 'none':
                        self.send_broadcast("Its " + str(player.active_poke.get_usable_stats()) + " stat changed.")

                    self.send_players_pokes()

            else:
                # the move missed
                self.send_broadcast("It missed.")

            # make a new line to look more organised
            self.send_broadcast("")

            # send updated pokes
            self.send_players_pokes()

            # the moving poke is dead !?!?
            if not other_player.active_poke.is_usable():
                other_player.i_turn_readiness = NOT_READY
                other_player.i_active_move_idx = -1

                if len(other_player.get_available_pokes()) <= 0:
                    self.b_gameover = True
                    other_player.send_data(DISPLAY_LOSE)
                    player.send_data(DISPLAY_WIN)
                    #self.send_delay()
                    return

                other_player.send_data(SELECT_POKE + json.dumps({"availpoke": other_player.get_available_pokes()}))
                #self.send_delay()

                return

        # after turn heal / damage
        for player in l_move_queue:

            if not player.active_poke.is_usable():
                continue

            #player.active_poke.i_hp += int(player.active_poke.get_usable_stats().i_hp / 13)

            #self.send_broadcast("It regained 7.69230769231% hp.")

            if player.active_poke.str_status == "burn":
                player.active_poke.i_hp -= int(player.active_poke.get_usable_stats().i_hp / 16)
            elif player.active_poke.str_status == "poison":
                player.active_poke.i_hp -= int(player.active_poke.get_usable_stats().i_hp / 8)
            elif player.active_poke.str_status == "toxic":
                player.active_poke.i_hp -= int(player.active_poke.get_usable_stats().i_hp / 16 * player.active_poke.toxic_idx)
                player.active_poke.toxic_idx += 1

            player.active_poke.i_hp = min(player.active_poke.i_hp, player.active_poke.get_usable_stats().i_hp)

            # is it dead???
            if (player.active_poke.i_hp <= 0):
                player.active_poke.i_hp = 0
                player.active_poke.b_fainted = True

            # the moving poke is dead !?!?
            if not player.active_poke.is_usable():
                player.i_turn_readiness = NOT_READY
                player.i_active_move_idx = -1

                if len(player.get_available_pokes()) <= 0:
                    self.b_gameover = True
                    player.send_data(DISPLAY_LOSE)
                    other_player.send_data(DISPLAY_WIN)
                    # self.send_delay()
                    return

                player.send_data(SELECT_POKE + json.dumps({"availpoke": player.get_available_pokes()}))
                # self.send_delay()

                return

            self.send_players_pokes()

            self.send_delay()

        if (not self.everyone_ready() or self.b_gameover):
            return

        # send updated info to players
        for player in self.l_players:
            other_player = self.get_other_player(player)

            player.i_turn_readiness = NOT_READY
            #player.i_active_move_idx = -1

            #player.send_data(DISPLAY_TEXT + "You selected pokeman number " + str(player.i_active_poke_idx))
            #player.send_data(DISPLAY_TEXT + "Your opponent selected pokeman number " + str(other_player.i_active_poke_idx))

            self.send_players_pokes()

            if player.active_poke.is_usable():
                player.send_data(SELECT_POKE_OR_MOVE + json.dumps({"availpoke": player.get_available_pokes()}))
            elif player.active_poke.is_trapped():
                player.send_data(SELECT_MOVE)
            else:
                player.send_data(SELECT_POKE + json.dumps({"availpoke": player.get_available_pokes()}))

        return
