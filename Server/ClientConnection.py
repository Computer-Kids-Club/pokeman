## -------------------------------------- ##
## Client Connections
## connects clients
## -------------------------------------- ##

from Constants import *
import socket
import sys

HOST = None               # Symbolic name meaning all available interfaces
PORT = 17171              # Arbitrary non-privileged port
s = None
for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC, socket.SOCK_STREAM, 0, socket.AI_PASSIVE):
    af, socktype, proto, canonname, sa = res
    try:
        s = socket.socket(af, socktype, proto)
    except OSError as msg:
        s = None
        continue
    try:
        s.bind(sa)
        s.listen(1)
    except OSError as msg:
        s.close()
        s = None
        continue
    break
if s is None:
    print('could not open socket')
    sys.exit(1)
conn, addr = s.accept()
# with conn:
#     print('Connected by', addr)
#     while True:
#         data = conn.recv(1024)
#         print(data)
#         if not data:
#             break
#         conn.send(data)


class Client(object):
    def __init__(self,addr):
        self.addr = addr

    def run(self):
        data = conn.recv(1024)
        if not data:
            return False
        #conn.send(data)
        Log.info(data)
        return True