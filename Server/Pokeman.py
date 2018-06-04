## -------------------------------------- ##
## This is the main file
## Run this file on the server
## -------------------------------------- ##
## Pokéman Showdown is an original game, unlike PokémOn Showdown who copied our idea.
## Tomer is here
## Alex is here
## Alex is here again

from BattleClass import *
from ClientConnection import *
from DamageCalculation import *
#import os, pwd, grp
import base64
from Crypto.Cipher import AES


# GAME ON
b_game_on = True

b_multiplayer = False

while b_game_on:
    for b in range(len(l_battles)-1,-1,-1):
        battle = l_battles[b]
        battle.run()
        if battle.b_gameover:
            for client in battle.l_players:
                client.battle = None
                client.i_battle_state = NOT_READY
            l_battles.pop(b)
            continue

    recieve_connection()

    for client in l_clients:
        client = l_clients[client]
        if client.battle == None and client.i_battle_state==READY:
            if b_multiplayer:
                for client2 in l_clients:
                    client2 = l_clients[client2]
                    if client2.battle == None and client2.i_battle_state == READY and client != client2:
                        tmp_client = client2
                        new_battle = Battle([client,tmp_client])
                        client.battle = new_battle
                        tmp_client.battle = new_battle
                        l_battles.append(new_battle)
                        break
            else:
                tmp_client = init_tmp_client()
                new_battle = Battle([client,tmp_client])
                client.battle = new_battle
                tmp_client.battle = new_battle
                l_battles.append(new_battle)


server_socket.close()
