## -------------------------------------- ##
## Client Connections
## connects clients
## -------------------------------------- ##

from Constants import *
import json
import socket
from PokemanClass import Pokeman
from StatClass import Stats
from random import randint
import select

# from random import randint

# sockets
l_sockets = []

# idle users
l_clients = {}

# message queue
l_msg = []


# broadcast chat messages to all connected clients
def broadcast(server_socket, sock, message):
    # print("broadcasted",message.encode("utf-8"))
    for socket in l_sockets:
        # send the message only to peer
        if socket != server_socket and socket != sock:
            try:
                socket.send((message + TERMINATING_CHAR).encode("utf-8"))
                # socket.send(b"b100x")
            except:
                # broken socket connection
                socket.close()
                # broken socket, remove it
                if socket in l_sockets:
                    l_sockets.remove(socket)


server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind((HOST, PORT))
server_socket.listen(10)

print("Chat server started on port " + str(PORT))


def recieve_connection():
    while len(l_msg) > 0:
        l_clients[l_msg[0][0]].recieved_data(l_msg[0][1])
        l_msg.pop(0)

    ready_to_read, ready_to_write, in_error = select.select([server_socket], [], [], 0)

    if len(ready_to_read) > 0:
        sockfd, addr = server_socket.accept()
        l_sockets.append(sockfd)
        print(str(addr) + " connected")

        l_clients[addr] = Client(addr, sockfd)

        # sockfd.send(b"gey")
        # broadcast(server_socket, sockfd, "[%s:%s] entered our chatting room\n" % addr)
        # print("[%s:%s] entered our chatting room\n" % addr)

    # get the list sockets which are ready to be read through select
    # 4th arg, time_out  = 0 : poll and never block
    if(len(l_sockets)==0):
        return
    ready_to_read, ready_to_write, in_error = select.select(l_sockets, [], [], 0)

    for sock in ready_to_read:
        # a message from a client, not a new connection
        # process data recieved from client,
        try:
            # receiving data from the socket.
            data = sock.recv(RECV_BUFFER)
            if data:
                # there is something in the socket
                # sockfd.send(data)
                # broadcast(server_socket, sock, "\r" + '[' + str(sock.getpeername()) + '] ' + data)
                # print(str(sock.getpeername()) + ': ' + data)
                # l_clients[sock.getpeername()].recieved_data(data)
                l_msg.append((sock.getpeername(), data))
            else:
                # at this stage, no data means probably the connection has been broken
                # broadcast(server_socket, sock, "Client (%s, %s) is offline\n" % addr)
                print(str(sock.getpeername()) + " is offline")

                del l_clients[sock.getpeername()]

                # remove the socket that's broken
                if sock in l_sockets:
                    l_sockets.remove(sock)

        # exception
        except:
            # broadcast(server_socket, sock, "Client (%s, %s) is offline\n" % addr)
            print(str(sock.getpeername()) + " is offline")

            del l_clients[sock.getpeername()]

            continue

class Client(object):
    def __init__(self, addr=None, socket=None):
        self.addr = addr
        self.socket = socket
        self.team = []
        self.i_battle_state = NOT_READY

    def send_data(self, str_data):
        self.socket.send((str_data + TERMINATING_CHAR).encode("utf-8"))

    def send_pokes(self, team):
        l_poke_data = []
        for poke in team:
            l_poke_data.append(poke.to_dic())
        self.send_data(SENDING_POKE+json.dumps({"pokes":l_poke_data}))

    def recieved_data(self, str_data):

        try:
            dic_data = json.loads(str_data.decode("utf-8"))
        except:
            return

        if dic_data["battlestate"] == "pokes":
            self.team = []
            for dic_poke in dic_data["pokes"]:
                poke = Pokeman(dic_poke["num"])

                poke.base_stats = Stats( dic_poke['hp'], dic_poke['atk'], dic_poke['def'],
                                        dic_poke['spa'], dic_poke['spd'], dic_poke['spe'])

                poke.i_happy = dic_poke['hap']
                poke.i_lv = dic_poke['lv']
                poke.b_shiny = dic_poke['shiny']

                self.team.append(poke)
            print(str(self.team))
            self.send_data(FOUND_BATTLE)
            tmp_client.team = [Pokeman(randint(1,807)) for i in range(6)]
            self.send_pokes(tmp_client.team)
            self.send_data(SELECT_POKE)
        elif dic_data["battlestate"] == "selectpoke":
            print(dic_data["poke"])
            self.send_data(DISPLAY_TEXT+"Player selected pokeman number "+str(dic_data["poke"]))
            self.send_data(DISPLAY_POKES+json.dumps({"player":ME,"pokeidx":dic_data["poke"]}))
            self.send_data(DISPLAY_POKES+json.dumps({"player":OTHER,"pokeidx":randint(0,5)}))
            #self.send_pokes()
            self.send_data(SELECT_POKE_OR_MOVE)
        elif dic_data["battlestate"] == "selectmove":
            print(dic_data["move"])
            self.send_data(DISPLAY_TEXT+"Player selected move number "+str(dic_data["move"]))
            #self.send_pokes()
            self.send_data(SELECT_POKE_OR_MOVE)

    def run(self):
        Log.info("here")
        return True

tmp_client = Client()