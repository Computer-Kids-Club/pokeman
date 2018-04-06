## -------------------------------------- ##
## This is the main file
## Run this file on the server
## -------------------------------------- ##
## Pokéman Showdown is an original game, unlike PokémOn Showdown who copied our idea.
## Tomer is here
## Alex is here
## Alex is here again

from BattleClass import Battle
from ClientConnection import Client

# master list of all the ongoing battles
l_battles = [Battle()]

# idle users
l_clients = [Client()]

# GAME ON
b_game_on = True

while b_game_on:
    for battle in l_battles:
        battle.run()
    for client in l_clients:
        client.run()

