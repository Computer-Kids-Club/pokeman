## -------------------------------------- ##
## Battle Class
## just the class
## -------------------------------------- ##

from Constants import *
from FieldClass import Field
from random import randint
from ClientConnection import Client
from DamageCalculation import attack
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

            print(player.active_poke, "used move", player.active_poke.get_moves()[player.i_active_move_idx])

            self.send_move(player, player.active_poke.get_moves()[player.i_active_move_idx])

            player.i_active_move_idx = -1

            # actually take damage

            i_dmg = attack(player.active_poke, other_player.active_poke, player.active_poke.get_moves()[player.i_active_move_idx], self.field, player, other_player)

            self.send_broadcast(str(other_player.active_poke.i_hp) + str(i_dmg) + str(other_player.active_poke.i_hp-i_dmg))

            other_player.active_poke.i_hp -= i_dmg

            # is it dead???
            if (other_player.active_poke.i_hp <= 0):
                other_player.active_poke.i_hp = 0
                other_player.active_poke.b_fainted = True

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

            # player.active_poke.i_hp = randint(0,player.active_poke.get_usable_stats().i_hp)

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
