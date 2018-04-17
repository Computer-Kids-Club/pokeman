## -------------------------------------- ##
## Battle Class
## just the class
## -------------------------------------- ##

from Constants import *
from FieldClass import Field
from random import randint
import json

# master dictionary of all the ongoing battles
l_battles = []

# client to battle
dic_battles = {}

class Battle(object):
    def __init__(self, l_new_players=[]):

        self.field = Field()

        self.l_players = l_new_players

        for player in self.l_players:
            other_player = self.get_other_player(player)

            player.i_turn_readiness = NOT_READY

            player.send_data(FOUND_BATTLE)
            player.send_pokes(other_player.team)
            player.send_data(SELECT_POKE)


    def get_other_player(self, player):
        i_player_idx = self.l_players.index(player)
        return self.l_players[(i_player_idx+1)%2]

    def recieved_data(self, player, dic_data):

        other_player = self.get_other_player(player)

        if dic_data["battlestate"] == "pokes":
            #self.send_data(FOUND_BATTLE)

            #self.send_pokes(tmp_client.team)
            #self.send_data(SELECT_POKE)
            pass
        elif dic_data["battlestate"] == "selectpoke":
            #print(dic_data["poke"])
            #self.send_data(DISPLAY_TEXT+"Player selected pokeman number "+str(dic_data["poke"]))
            #self.send_data(DISPLAY_POKES+json.dumps({"player":ME,"pokeidx":dic_data["poke"]}))
            #self.send_data(DISPLAY_POKES+json.dumps({"player":OTHER,"pokeidx":randint(0,5)}))
            #self.send_pokes()
            #self.send_data(SELECT_POKE_OR_MOVE)
            pass
        elif dic_data["battlestate"] == "selectmove":
            #print(dic_data["move"])
            #self.send_data(DISPLAY_TEXT+"Player selected move number "+str(dic_data["move"]))
            #self.send_pokes()
            #self.send_data(SELECT_POKE_OR_MOVE)
            pass


    def everyone_ready(self):
        b_ready = True
        for player in self.l_players:
            b_ready = b_ready and player.i_turn_readiness
        return b_ready

    def run(self):
        #Log.info("battle running")

        #print(self.l_players[0].i_turn_readiness,self.l_players[1].i_turn_readiness)

        if(not self.everyone_ready()):
            return

        # calculate damage
        for player in self.l_players:
            player.i_active_poke.i_hp = randint(0,player.i_active_poke.get_usable_stats().i_hp)

        # send updated info to players
        for player in self.l_players:
            other_player = self.get_other_player(player)

            player.i_turn_readiness = NOT_READY

            player.send_data(DISPLAY_TEXT + "You selected pokeman number " + str(player.i_active_poke_idx))
            player.send_data(DISPLAY_POKES+json.dumps({"player":ME,"pokeidx":player.i_active_poke_idx}))

            player.send_data(DISPLAY_TEXT + "Your opponent selected pokeman number " + str(other_player.i_active_poke_idx))
            player.send_data(DISPLAY_POKES+json.dumps({"player":OTHER,"pokeidx":other_player.i_active_poke_idx}))

            player.send_data(SELECT_POKE_OR_MOVE)


        return