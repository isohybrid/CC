#!/usr/bin/env python

import socket
from time import ctime

HOST = '115.28.15.60'
PORT = 22222
BUFSIZ = 1024

tcpSerSock = socket.socket(AF_INET, SOCK_STREAM)
tcpSerSock.bind((HOST, PORT))
tcpSerSock.listen(5)

while(True):
  print 'waiting for connection...'
  tcpCliSock, addr = tcpSerSock.accept()
  print 'Connected from:', addr, '...'

  while True:
    data = tcpCliSock.recv(BUFSIZ)
    if not data:
      break
    tcpCliSock.send('[%s] %s' % (ctime(), data))

  tcpCliSock.close()
tcpSerSock.close()
