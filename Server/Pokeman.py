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

# GAME ON
b_game_on = True

while b_game_on:
    for battle in l_battles:
        battle.run()
    recieve_connection()

    for client in l_clients:
        client = l_clients[client]
        if not client in dic_battles and client.i_battle_state==READY:
            tmp_client = init_tmp_client()
            new_battle = Battle([client,tmp_client])
            dic_battles[client] = new_battle
            client.battle = new_battle
            tmp_client.battle = new_battle
            l_battles.append(new_battle)


server_socket.close()