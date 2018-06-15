## -------------------------------------- ##
## Client Connections
## connects clients
## -------------------------------------- ##

from Constants import *
import json
import socket
from PokemanClass import Pokeman
from StatClass import Stats
from MoveClass import Move
from random import randint
from BattleClass import *
import select
random_symbols=['`','!','@','#','$','%','^','&','(',')','-','_','+','=','|','}','{',']','[','~','>','<','.','?','/',',']
mixed_letters='qwertyuiopasdfghjklzxcvbnm'

# from random import randint

# sockets
l_sockets = []

# idle users
l_clients = {}

# message queue
l_msg = []
def encrypt(password):
    new_str=''
    for i in password:
        new_str+=random_symbols[mixed_letters.index(i)]
    return new_str
def decrypt(password):
    new_str=''
    for i in password:
        new_str+=mixed_letters[random_symbols.index(i)]
    return new_str
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

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
print(s.getsockname()[0])
s.close()

print("Chat server started on port " + str(PORT))

def init_tmp_client():
    tmp_client = Client()
    tmp_client.team = [Pokeman(randint(1,807)) for i in range(6)]
    tmp_client.b_tmp = True
    return tmp_client

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

        self.b_tmp = False

        self.i_turn_readiness = NOT_READY

        self.active_poke = None
        self.i_active_poke_idx = 0

        self.i_active_move_idx = -1

        self.b_active_poke_is_new = False

        self.b_healing_wish = False

        self.b_lunar_dance = False

        self.battle = None

        self.baton_pass_stats = Stats()

        self.friends = []

    def send_data(self, str_data):

        if self.b_tmp:
            if str_data[0] == SELECT_POKE_OR_MOVE:
                if randint(0,7)==0 and len(json.loads(str_data[1:])["availpoke"])>0:
                    l_avail_pokes = json.loads(str_data[1:])["availpoke"]
                    self.recieved_data(json.dumps({"battlestate":"selectpoke","poke":l_avail_pokes[randint(0,len(l_avail_pokes)-1)]}).encode("utf-8"))
                else:
                    self.recieved_data(json.dumps({"battlestate":"selectmove","move":randint(0,3)}).encode("utf-8"))
                    #self.recieved_data(json.dumps({"battlestate": "selectpass"}).encode("utf-8"))
            elif str_data[0] == SELECT_POKE:
                l_avail_pokes = json.loads(str_data[1:])["availpoke"]
                self.recieved_data(json.dumps({"battlestate":"selectpoke","poke":l_avail_pokes[randint(0,len(l_avail_pokes)-1)]}).encode("utf-8"))
            elif str_data[0] == SELECT_MOVE:
                if randint(0,7)==0:
                    self.recieved_data(json.dumps({"battlestate":"selectmove","move":randint(0,3)}).encode("utf-8"))
                else:
                    self.recieved_data(json.dumps({"battlestate":"selectmove","move":randint(0,3)}).encode("utf-8"))
                    #self.recieved_data(json.dumps({"battlestate": "selectpass"}).encode("utf-8"))
            return

        self.socket.send((str_data + TERMINATING_CHAR).encode("utf-8"))

    def send_pokes(self, team):
        l_poke_data = []
        for poke in team:
            l_poke_data.append(poke.to_dic())
        self.send_data(SENDING_POKE+json.dumps({"pokes":l_poke_data}))

    def pre_turn(self):
        for poke in self.team:
            poke.pre_turn()

    def recieved_data(self, str_data):

        try:
            dic_data = json.loads(str_data.decode("utf-8"))
        except:
            print("Woah Error!")
            return

        if dic_data["battlestate"] == "pokes":
            self.team = []
            for dic_poke in dic_data["pokes"]:
                poke = Pokeman(dic_poke["num"])

                poke.str_name = dic_poke["name"]

                poke.usable_stats = Stats( dic_poke['hp'], dic_poke['atk'], dic_poke['def'],
                                        dic_poke['spa'], dic_poke['spd'], dic_poke['spe'])

                #print(poke.str_name,poke.usable_stats.to_dic({}))

                poke.i_happy = dic_poke['hap']
                poke.i_lv = dic_poke['lv']
                poke.b_shiny = dic_poke['shiny']

                poke.l_moves = []
                for dic_move in dic_poke['moves']:
                    poke.l_moves.append(Move(dic_move))

                poke.i_hp = poke.get_usable_stats().i_hp

                #print("hey hey hey ", poke.get_usable_stats().i_atk)

                self.team.append(poke)
            self.i_battle_state = READY
            self.i_turn_readiness = READY
        elif dic_data["battlestate"] == "selectpoke":
            self.i_active_poke_idx = dic_data["poke"]
            self.active_poke = self.team[self.i_active_poke_idx]
            self.b_active_poke_is_new = True
            self.active_poke.modifier_stats = self.baton_pass_stats.get_copy()
            self.baton_pass_stats = Stats()

            if self.b_healing_wish or self.b_lunar_dance:
                self.b_healing_wish = False
                self.b_lunar_dance = False
                self.active_poke.i_hp = self.active_poke.get_usable_stats().i_hp
                self.str_status = "none"

            #print(dic_data["poke"])
            self.i_turn_readiness = READY
        elif dic_data["battlestate"] == "selectmove":
            self.i_active_move_idx = dic_data["move"]
            self.i_turn_readiness = READY
        elif dic_data["battlestate"] == "selectpass":
            self.i_turn_readiness = READY
        elif dic_data["battlestate"] == "pokewrite":
            file_in = open(dir_path+'/pokeSave.txt', 'r')
            sentPokes = file_in.read()
            file_in.close()
            loaded_pokes = json.loads(sentPokes)
            loaded_pokes[dic_data['username']] = dic_data["pokes"]
            sentPokes = json.dumps(loaded_pokes)
            file_in = open(dir_path+'/pokeSave.txt', 'w')
            file_in.write(sentPokes)
            file_in.close()
            
        elif dic_data["battlestate"] == "pokeread":
            file_in = open(dir_path+'/pokeSave.txt', 'r')
            sentPokes = file_in.read()
            file_in.close()

            loaded_pokes = json.loads(sentPokes)
            if dic_data['username'] in loaded_pokes:
                self.send_data("z" + json.dumps({"pokes":loaded_pokes[dic_data['username']]}))
            else:
                self.send_data("badUserDic")
        elif dic_data["battlestate"] == "addfriend":
            file_in = open('friendList.txt', 'r')
            friendList = file_in.read()
            file_in.close()
            loaded_friends = json.loads(friendList)
            if dic_data["username"] in loaded_friends:
                self.friends = loaded_friends[dic_data["username"]]
                if dic_data["newfriend"] not in self.friends:
                    self.friends.append(dic_data["newfriend"])
                    loaded_friends[dic_data['username']] = self.friends
                    friendList = json.dumps(loaded_friends)
                    file_in = open('friendList.txt', 'w')
                    file_in.write(friendList)
                    file_in.close()
        elif dic_data["battlestate"] == "removefriend":
            file_in = open('friendList.txt', 'r')
            friendList = file_in.read()
            file_in.close()
            loaded_friends = json.loads(friendList)
            print(self.friends)
            print()
            if dic_data["username"] in loaded_friends:
                print("good 1")
                self.friends = loaded_friends[dic_data["username"]]
                if dic_data["newfriend"] in self.friends:
                    print("good2")
                    self.friends.remove(dic_data["newfriend"])
                    loaded_friends[dic_data['username']] = self.friends
                    friendList = json.dumps(loaded_friends)
                    file_in = open('friendList.txt', 'w')
                    file_in.write(friendList)
                    file_in.close()
                    sendingFriends = json.dumps(self.friends)
                    self.send_data("x" + sendingFriends)
            print()
            print(dic_data["newfriend"])
            print()
            print(self.friends)
        elif dic_data["battlestate"] == "friendread":
            file_in = open('friendList.txt', 'r')
            friendList = file_in.read()
            file_in.close()
            loaded_friends = json.loads(friendList)
            if dic_data['username'] in loaded_friends:
                self.friends = loaded_friends[dic_data['username']]
                sendingFriends = json.dumps(self.friends)
                self.send_data("x" + sendingFriends)
            else:
                self.send_data("badUserDic")
        elif dic_data["battlestate"] == "loadall":
            file_in = open('friendList.txt', 'r')
            friendList = file_in.read()
            file_in.close()
            loaded_friends = json.loads(friendList)
            
            if dic_data['username'] in loaded_friends:
                self.friends = loaded_friends[dic_data['username']]
                sendingFriends = self.friends
            else:
                sendingFriends = []
                
            file_in = open(dir_path+'/pokeSave.txt', 'r')
            sentPokes = file_in.read()
            file_in.close()

            loaded_pokes = json.loads(sentPokes)
            
            if dic_data['username'] in loaded_pokes:
                sendingPokes = {"pokes":loaded_pokes[dic_data['username']]}
            else:
                sendingPokes = {"pokes": []}

            sendingAll = json.dumps({"friends":sendingFriends,"pokemon":sendingPokes})

            self.send_data("y" + sendingAll)
        elif dic_data["battlestate"] == "login":
            file_in = open('usernames.txt','r')    
            usernamelst = file_in.read()  
            usernamelst=usernamelst.split('*')
            file_in.close()
            file_in = open('passwords.txt','r')     
            passwordlst = file_in.read()   
            passwordlst=passwordlst.split('*')
            file_in.close()
            print(passwordlst)
            if dic_data['username'] in usernamelst and encrypt(dic_data['password']) in passwordlst:
                if len(dic_data['username'])>0 and len(dic_data['password'])>0:                    
                    if usernamelst.index(dic_data['username'])==passwordlst.index(encrypt(dic_data['password'])):
                        self.send_data('ltrue')
                    else:
                        self.send_data('lfalse')
                else:
                    self.send_data('lfalse')
            else:
                self.send_data('lfalse')
        elif dic_data["battlestate"] == "register":
            file_in = open('usernames.txt','r')    
            usernamelst = file_in.read()  
            usernamelst=usernamelst.split('*')
            file_in.close()
            if dic_data['username'] not in usernamelst and len(dic_data['username'])>0 and len(dic_data['password'])>0:
                file_out = open('usernames.txt', "a")
                file_out.write('*') 
                file_out.write(dic_data['username'])  # 2. Convert the info to string and write in the file
                file_out.close()
                file_out = open('passwords.txt', "a")
                file_out.write('*') 
                file_out.write(encrypt(dic_data['password']))# 2. Convert the info to string and write in the file
                file_out.close()
                self.send_data('ltrue')
            else:
                self.send_data('lfalse')
        elif dic_data["battlestate"] == "command":
            l_words = dic_data["command"].split()
            if l_words[0] == "weakness":
                try:
                    str_poke_name = l_words[1]
                    tmp_poke = Pokeman(dic_name_to_num[str_poke_name])
                    self.send_data(DISPLAY_TEXT+str_poke_name+":")
                    self.send_data(DISPLAY_TEXT+"Very Weak: " + join_with_none(get_def_types_with_eff_rate(4,tmp_poke.type_1,tmp_poke.type_2)))
                    self.send_data(DISPLAY_TEXT+"Weak: " + join_with_none(get_def_types_with_eff_rate(2,tmp_poke.type_1,tmp_poke.type_2)))
                    self.send_data(DISPLAY_TEXT+"Resist: " + join_with_none(get_def_types_with_eff_rate(0.5,tmp_poke.type_1,tmp_poke.type_2)))
                    self.send_data(DISPLAY_TEXT+"Very Resist: " + join_with_none(get_def_types_with_eff_rate(0.25,tmp_poke.type_1,tmp_poke.type_2)))
                    self.send_data(DISPLAY_TEXT+"Immune: " + join_with_none(get_def_types_with_eff_rate(0,tmp_poke.type_1,tmp_poke.type_2)))

                except:
                    self.send_data(DISPLAY_TEXT + "Error: Invalid Arguments 3006. Please contact support with the error code at ethanzohar9@gmail.com.")
            elif l_words[0] == "data":
                try:
                    str_poke_name = l_words[1]
                    tmp_poke = Pokeman(dic_name_to_num[str_poke_name])
                    self.send_data(DISPLAY_TEXT+str_poke_name+":")
                    self.send_data(DISPLAY_TEXT+"HP: " + str(tmp_poke.base_stats.get_hp()))
                    self.send_data(DISPLAY_TEXT+"ATK: " + str(tmp_poke.base_stats.get_atk()))
                    self.send_data(DISPLAY_TEXT+"DEF: " + str(tmp_poke.base_stats.get_def()))
                    self.send_data(DISPLAY_TEXT+"SPA: " + str(tmp_poke.base_stats.get_spa()))
                    self.send_data(DISPLAY_TEXT+"SPD: " + str(tmp_poke.base_stats.get_spd()))
                    self.send_data(DISPLAY_TEXT+"SPE: " + str(tmp_poke.base_stats.get_spe()))

                except:
                    self.send_data(DISPLAY_TEXT + "Error: Invalid Arguments 3006. Please contact support with the error code at ethanzohar9@gmail.com.")
            elif l_words[0] == "strongness":
                try:
                    str_poke_name = l_words[1]
                    self.send_data(DISPLAY_TEXT+"strong")
                except:
                    self.send_data(DISPLAY_TEXT + "Error: Invalid Arguments 3007. Please contact support with the error code at ethanzohar9@gmail.com.")
            else:
                self.send_data(DISPLAY_TEXT+"Error: Invalid Command 3009. Please contact support with the error code at ethanzohar9@gmail.com.")
                
        if self.battle != None:
            self.battle.recieved_data(self, dic_data)

    def get_available_pokes(self):
        l_ret = []
        for i in range(len(self.team)):
            if self.team[i].is_usable() and i != self.i_active_poke_idx:
                l_ret.append(i)
        return l_ret

    def run(self):
        Log.info("here")
        return True
