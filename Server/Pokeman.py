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



# GAME ON
b_game_on = True

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
            tmp_client = init_tmp_client()
            new_battle = Battle([client,tmp_client])
            client.battle = new_battle
            tmp_client.battle = new_battle
            l_battles.append(new_battle)


server_socket.close()