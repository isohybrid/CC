#!/usr/bin/env python

import socket

PORT = 22222
BUFSIZ = 1024

data = {
    "server":"p1.5bird.com",
    "server_port":23715,
    "local_port":8080,
    "password":"k78931"
}

data['server'] = socket.gethostbyaddr(data['server'])[2][0]
print data

tcpCliSock = socket.socket(AF_INET ,SOCK_STREAM)
tcpCliSock.connect((data['server'], PORT))

while True:
  tcpCliSock.send(data)
  tmp = tcpCliSock.recv(BUFSIZ)
  if not tmp:
    break
  print tmp

tcpCliSock.close()
